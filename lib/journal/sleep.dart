import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/language.dart';
import 'package:project_proud_me/utils/helpers.dart';
import 'package:project_proud_me/endpoints.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'package:project_proud_me/widgets/toast.dart';

class SleepCard extends StatefulWidget {
  final String userId;

  const SleepCard({required this.userId});

  @override
  _SleepCardState createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  final TextEditingController _goalHourController = TextEditingController();
  final TextEditingController _goalMinuteController = TextEditingController();
  final TextEditingController _behaviorHourController = TextEditingController();
  final TextEditingController _behaviorMinuteController =
      TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  bool _isLoading = false;
  late Map<String, dynamic> _sleepData;

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
        setState(() {
          _sleepData = responseBody.first as Map<String, dynamic>;
        });

        if (isToday(_sleepData['dateToday'])) {
          double goal = toDouble(_sleepData['goalValue']);
          double behavior = toDouble(_sleepData['behaviorValue']);
          _goalHourController.text = getHourFromResponse(goal);
          _goalMinuteController.text = getMinuteFromResponse(goal);
          _behaviorHourController.text = getHourFromResponse(behavior);
          _behaviorMinuteController.text = getMinuteFromResponse(behavior);
          _reflectionController.text = _sleepData['reflection'];
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

  String calculateTotalBehavior() {
    int total = 0;

    if (_behaviorHourController.text.isNotEmpty) {
      int value = int.tryParse(_behaviorHourController.text)! * 60;
      total += value;
    }

    if (_behaviorMinuteController.text.isNotEmpty) {
      int value = int.tryParse(_behaviorMinuteController.text)!;
      total += value;
    }

    return total.toString();
  }

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

  void incrementBehaviorHour() {
    setState(() {
      if (_behaviorHourController.text.isEmpty) {
        _behaviorHourController.text = 1.toString();
      } else {
        _behaviorHourController.text =
            (int.parse(_behaviorHourController.text) + 1).toString();
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

  void incrementBehaviorMinute() {
    setState(() {
      if (_behaviorMinuteController.text.isEmpty) {
        _behaviorMinuteController.text = 1.toString();
      } else {
        _behaviorMinuteController.text =
            (int.parse(_behaviorMinuteController.text) + 1).toString();
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

  void decrementBehaviorHour() {
    setState(() {
      if (_behaviorHourController.text.isNotEmpty &&
          int.parse(_behaviorHourController.text) > 0) {
        _behaviorHourController.text =
            (int.parse(_behaviorHourController.text) - 1).toString();
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

  void decrementBehaviorMinute() {
    setState(() {
      if (_behaviorMinuteController.text.isNotEmpty &&
          int.parse(_behaviorMinuteController.text) > 0) {
        _behaviorMinuteController.text =
            (int.parse(_behaviorMinuteController.text) - 1).toString();
      }
    });
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
                                  'Set My Goal',
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
                                  'Track My Behaviour',
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
                                          decrementBehaviorHour();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _behaviorHourController,
                                        decoration: const InputDecoration(
                                            labelText: 'Hours'),
                                        keyboardType: TextInputType.number,
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
                                          incrementBehaviorHour();
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
                                          decrementBehaviorMinute();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _behaviorMinuteController,
                                        decoration: const InputDecoration(
                                            labelText: 'Minutes'),
                                        keyboardType: TextInputType.number,
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
                                          incrementBehaviorMinute();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Total Behavior: ${calculateTotalBehavior()} Minutes',
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
                                  _sleepData['feedback'],
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
                          onPressed: () {},
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
