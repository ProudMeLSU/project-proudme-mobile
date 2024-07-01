import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;
import 'package:http/http.dart' show get, post;
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/endpoints.dart';
import 'package:project_proud_me/language.dart';
import 'package:project_proud_me/utils/helpers.dart';
import 'package:project_proud_me/widgets/toast.dart';

class FruitsVegetablesCard extends StatefulWidget {
  final String userId;

  const FruitsVegetablesCard({required this.userId});

  @override
  _FruitsVegetablesCardState createState() => _FruitsVegetablesCardState();
}

class _FruitsVegetablesCardState extends State<FruitsVegetablesCard>
    with SingleTickerProviderStateMixin {
  late Map<String, TextEditingController> _goalControllers;
  late Map<String, TextEditingController> _behaviorControllers;
  late TabController _tabController;

  TextEditingController _goalController = TextEditingController();
  TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  bool _isLoading = false;
  String _feedback = '';
  String _selectedEatingType = 'Fruits';

  String calculateTotalGoal() {
    int total = 0;
    _goalControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)!;
        total += value;
      }
    });

    return total.toString();
  }

  String calculateTotalBehavior() {
    int total = 0;

    _behaviorControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)!;
        total += value;
      }
    });

    return total.toString();
  }

    void _fetchDataAndSetControllers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String queryString =
          getQueryParamsForGoalEndpoints(widget.userId, 'eating');

      final response = await get(Uri.parse('$getGoal?$queryString'));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        if (responseBody.isNotEmpty) {
          var activityData = responseBody.first as Map<String, dynamic>;
          _reflectionController.text = activityData['reflection'];
          Map<String, dynamic> eating = activityData['servings'];
          eatingType.forEach((item) {
            _goalControllers[item]!.text =
                eating[item]['goal'].toString();
            _behaviorControllers[item]!.text =
                eating[item]['behavior'].toString();
          });
          setState(() {
            _feedback = activityData['feedback'];
          });
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

  void save() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String totalGoal = calculateTotalGoal();
      String totalBehavior = calculateTotalBehavior();
      String chatPayload = getChatbotPayloadForEating(
          totalGoal, totalBehavior, _reflectionController.text);
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
        String jsonData = getEatingBehaviorPayload(
            _goalControllers,
            _behaviorControllers,
            widget.userId,
            _feedback,
            _reflectionController.text,
            totalGoal,
            totalBehavior);
        var response = await post(
          Uri.parse(saveGoal),
          body: jsonData,
          headers: baseHttpHeader,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await post(
            Uri.parse(saveGoal),
            body: jsonData,
            headers: baseHttpHeader,
          );

          showCustomToast(context, eatingSaved,
              Theme.of(context).primaryColor);
        } else if (response.statusCode == 400) {
          showCustomToast(
              context, eatingNotSaved, errorColor);
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

  void _initGoalControllers() {
    _goalControllers = {};
    eatingType.forEach((type) {
      _goalControllers[type] = TextEditingController();
      _goalControllers[type]!.text = 0.toString();
    });
  }

  void _initBehaviorControllers() {
    _behaviorControllers = {};
    eatingType.forEach((type) {
      _behaviorControllers[type] = TextEditingController();
      _behaviorControllers[type]!.text = 0.toString();
    });
  }

  void incrementGoalServing() {
    setState(() {
      if (_selectedEatingType != '') {
        if (_goalController.text.isEmpty) {
          _goalController.text = 1.toString();
        } else {
          _goalController.text =
              (int.parse(_goalController.text) + 1).toString();
        }
      }
    });
  }

  void incrementBehaviorServing() {
    setState(() {
      if (_selectedEatingType != '') {
        if (_behaviorController.text.isEmpty) {
          _behaviorController.text = 1.toString();
        } else {
          _behaviorController.text =
              (int.parse(_behaviorController.text) + 1).toString();
        }
      }
    });
  }

  void decrementGoalServing() {
    setState(() {
      if (_selectedEatingType != '') {
        if (_goalController.text.isNotEmpty &&
            int.parse(_goalController.text) > 0) {
          _goalController.text =
              (int.parse(_goalController.text) - 1).toString();
        }
      }
    });
  }

  void decrementBehaviorServing() {
    setState(() {
      if (_selectedEatingType != '') {
        if (_behaviorController.text.isNotEmpty &&
            int.parse(_behaviorController.text) > 0) {
          _behaviorController.text =
              (int.parse(_behaviorController.text) - 1).toString();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: eatingType.length, vsync: this);
    _initGoalControllers();
    _initBehaviorControllers();
    _goalController = _goalControllers[_selectedEatingType]!;
    _behaviorController = _behaviorControllers[_selectedEatingType]!;
    _fetchDataAndSetControllers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
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
                                    SvgPicture.asset(
                                      appleIconPath,
                                      width: 20,
                                      height: 20,
                                      color: secondaryColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      myJournalItems[2],
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
                                              myJournalItems[2],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: const Text(
                                              fruitsVegetablesInfo,
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
                                TabBar(
                                  controller: _tabController,
                                  tabs: eatingType.map((String tab) {
                                    return Tab(text: tab);
                                  }).toList(),
                                  onTap: (index) {
                                    setState(() {
                                      _selectedEatingType = eatingType[index];
                                      _goalController = _goalControllers[
                                          _selectedEatingType]!;
                                      _behaviorController =
                                          _behaviorControllers[
                                              _selectedEatingType]!;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                          decrementGoalServing();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _goalController,
                                        decoration: const InputDecoration(
                                            labelText: 'Servings/day'),
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
                                          incrementGoalServing();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Total Goal: ${calculateTotalGoal()} Servings',
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
                                  height: 15,
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
                                          decrementBehaviorServing();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _behaviorController,
                                        decoration: const InputDecoration(
                                            labelText: 'Servings/day'),
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
                                          incrementBehaviorServing();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Total Behavior: ${calculateTotalBehavior()} Servings',
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
                            save();
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
