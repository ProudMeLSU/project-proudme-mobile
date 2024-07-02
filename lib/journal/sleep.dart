import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/language.dart';
import 'package:project_proud_me/utils/helpers.dart';
import 'package:project_proud_me/endpoints.dart';
import 'package:http/http.dart' show get, post;
import 'dart:convert';
import 'package:project_proud_me/widgets/toast.dart';

class SleepCard extends StatefulWidget {
  //TODO: Change the API to receive goalValue and behaviorValue in minutes not hours (double)
  final String userId;

  const SleepCard({required this.userId});

  @override
  _SleepCardState createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  final TextEditingController _goalHourController = TextEditingController();
  final TextEditingController _goalMinuteController = TextEditingController();

  TimeOfDay _selectedBehaviorBedTime = TimeOfDay.now();
  TimeOfDay _selectedBehaviorWakeUpTime = TimeOfDay.now();

  final TextEditingController _reflectionController = TextEditingController();
  bool _isLoading = false;
  String _feedback = '';

  void incrementGoalHour() {
    setState(() {
      if (_goalHourController.text.isEmpty) {
        _goalHourController.text = 1.toString();
      } else {
        _goalHourController.text =
            (int.parse(_goalHourController.text) + 1).toString();
      }
    });
  }

  void incrementGoalMinute() {
    setState(() {
      if (_goalMinuteController.text.isEmpty) {
        _goalMinuteController.text = 1.toString();
      } else {
        _goalMinuteController.text =
            (int.parse(_goalMinuteController.text) + 1).toString();
      }
    });
  }

  void decrementGoalHour() {
    setState(() {
      if (_goalHourController.text.isNotEmpty &&
          int.parse(_goalHourController.text) > 0) {
        _goalHourController.text =
            (int.parse(_goalHourController.text) - 1).toString();
      }
    });
  }

  void decrementGoalMinute() {
    setState(() {
      if (_goalMinuteController.text.isNotEmpty &&
          int.parse(_goalMinuteController.text) > 0) {
        _goalMinuteController.text =
            (int.parse(_goalMinuteController.text) - 1).toString();
      }
    });
  }

  String calculateTotalGoal() {
    int total = 0;

    if (_goalHourController.text.isNotEmpty) {
      int value = int.tryParse(_goalHourController.text)! * 60;
      total += value;
    }

    if (_goalMinuteController.text.isNotEmpty) {
      int value = int.tryParse(_goalMinuteController.text)!;
      total += value;
    }

    return total.toString();
  }

  Future<void> _selectBehaviorBedTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: _selectedBehaviorBedTime,
            helpText: 'Bed Time') ??
        TimeOfDay.now();
    if (picked != _selectedBehaviorBedTime) {
      setState(() {
        _selectedBehaviorBedTime = picked;
      });
    }
  }

  Future<void> _selectBehaviorWakeUpTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: _selectedBehaviorWakeUpTime,
            helpText: 'Wake up Time') ??
        TimeOfDay.now();
    if (picked != _selectedBehaviorWakeUpTime) {
      setState(() {
        _selectedBehaviorWakeUpTime = picked;
      });
    }
  }

  Future<void> _fetchDataAndSetControllers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String queryString =
          getQueryParamsForGoalEndpoints(widget.userId, 'sleep');

      final response = await get(Uri.parse('$getGoal?$queryString'));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);

        if (responseBody.isNotEmpty) {
          var sleepData = responseBody.first as Map<String, dynamic>;

          int bedBehavior = sleepData['sleep']['bedBehavior'];
          int wakeUpBehavior = sleepData['sleep']['wakeUpBehavior'];
          double goal = toDouble(sleepData['goalValue']);
          
          _goalHourController.text = getHourFromResponse(goal);
          _goalMinuteController.text = getMinuteFromResponse(goal);
          _selectedBehaviorBedTime = intToTimeOfDay(bedBehavior);
          _selectedBehaviorWakeUpTime = intToTimeOfDay(wakeUpBehavior);
          _reflectionController.text = sleepData['reflection'];
          _feedback = sleepData['feedback'];
        } else {
          _goalHourController.text = 0.toString();
          _goalMinuteController.text = 0.toString();
        }
      }
    } catch (e) {
      showCustomToast(context, e.toString(), errorColor);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onSave() async {
    setState(() {
      _isLoading = true;
    });

    String goalHour = _goalHourController.text;
    String goalMinute = _goalMinuteController.text;
    String reflection = _reflectionController.text;
    int totalBehaviorInMinutes = int.tryParse(calculateTimeDifference(
            _selectedBehaviorBedTime, _selectedBehaviorWakeUpTime)) ??
        0;

    try {
      String chatPayload = getChatbotPayloadForSleep(
          goalHour, goalMinute, totalBehaviorInMinutes, reflection);

      var chatResponse = await post(
        Uri.parse(getChatReply),
        body: chatPayload,
        headers: baseHttpHeader,
      );

      if (chatResponse.statusCode == 200) {
        String feedback = jsonDecode(chatResponse.body)['chat_reply'];
        setState(() {
          _feedback = feedback;
        });

        String payload = getSleepPayload(
            goalHour,
            goalMinute,
            totalBehaviorInMinutes,
            _selectedBehaviorBedTime,
            _selectedBehaviorWakeUpTime,
            widget.userId,
            _feedback,
            reflection);

        var response = await post(
          Uri.parse(saveGoal),
          body: payload,
          headers: baseHttpHeader,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await post(
            Uri.parse(saveGoal),
            body: payload,
            headers: baseHttpHeader,
          );
          showCustomToast(context, sleepSaved, Theme.of(context).primaryColor);
        } else {
          showCustomToast(context, sleepNotSaved, errorColor);
        }
      } else {
        showCustomToast(context, sleepNotSaved, errorColor);
      }
    } catch (e) {
      showCustomToast(context, e.toString(), errorColor);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataAndSetControllers();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 10,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 0.7,
                                      child: const Icon(
                                        Icons.mode_night_outlined,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      myJournalItems[3],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              myJournalItems[3],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: const Text(
                                              sleepInfo,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.info),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text(
                                  'Set My Sleep Goal',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove),
                                        color: Colors.white,
                                        onPressed: () {
                                          decrementGoalHour();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _goalHourController,
                                        decoration: const InputDecoration(
                                            labelText: 'Hours'),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => {setState(() {})},
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        color: Colors.white,
                                        onPressed: () {
                                          incrementGoalHour();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove),
                                        color: Colors.white,
                                        onPressed: () {
                                          decrementGoalMinute();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _goalMinuteController,
                                        decoration: const InputDecoration(
                                            labelText: 'Minutes'),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => {setState(() {})},
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        color: Colors.white,
                                        onPressed: () {
                                          incrementGoalMinute();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Total Goal: ${calculateTotalGoal()} Minutes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Track My Sleep',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Bed Time:',
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      getTimeToDisplay(
                                          _selectedBehaviorBedTime),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontFamily),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _selectBehaviorBedTime(context),
                                      child: const Text('Select'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Wake up Time:',
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      getTimeToDisplay(
                                          _selectedBehaviorWakeUpTime),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _selectBehaviorWakeUpTime(context),
                                      child: const Text('Select'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Sleep Duration: ${calculateTimeDifference(_selectedBehaviorBedTime, _selectedBehaviorWakeUpTime)} Minutes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Reflect',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextFormField(
                                  controller: _reflectionController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                      labelText: 'Type my thoughts'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'AI-Generated Feedback',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontFamily,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _feedback,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onSave();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xfff5b342)),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
