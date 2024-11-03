import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/language.dart';

class ActivityCard extends StatefulWidget {
  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  String _selectedActivityType = '';
  List<String> _dependentItems = [];

  late Map<String, TextEditingController> _goalHourControllers;
  late Map<String, TextEditingController> _goalMinuteControllers;
  TextEditingController _goalHourController = TextEditingController();
  TextEditingController _goalMinuteController = TextEditingController();

  late Map<String, TextEditingController> _behaviorHourControllers;
  late Map<String, TextEditingController> _behaviorMinuteControllers;
  TextEditingController _behaviorHourController = TextEditingController();
  TextEditingController _behaviorMinuteController = TextEditingController();


  String calculateTotalGoal() {
    int total = 0;

    _goalHourControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)! * 60;
        total += value;
      }
    });

    _goalMinuteControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)!;
        total += value;
      }
    });

    return total.toString();
  }

  String calculateTotalBehavior() {
    int total = 0;

    _behaviorHourControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)! * 60;
        total += value;
      }
    });

    _behaviorMinuteControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        int value = int.tryParse(controller.text)!;
        total += value;
      }
    });

    return total.toString();
  }

  void incrementGoalHour() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_goalHourControllers[_selectedActivityType]!.text.isEmpty) {
          _goalHourControllers[_selectedActivityType]!.text = 1.toString();
        } else {
          _goalHourControllers[_selectedActivityType]!.text =
              (int.parse(_goalHourControllers[_selectedActivityType]!.text) + 1)
                  .toString();
        }
      }
    });
  }

  void incrementBehaviorHour() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_behaviorHourControllers[_selectedActivityType]!.text.isEmpty) {
          _behaviorHourControllers[_selectedActivityType]!.text = 1.toString();
        } else {
          _behaviorHourControllers[_selectedActivityType]!.text = (int.parse(
                      _behaviorHourControllers[_selectedActivityType]!.text) +
                  1)
              .toString();
        }
      }
    });
  }

  void incrementGoalMinute() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_goalMinuteControllers[_selectedActivityType]!.text.isEmpty) {
          _goalMinuteControllers[_selectedActivityType]!.text = 1.toString();
        } else {
          _goalMinuteControllers[_selectedActivityType]!.text =
              (int.parse(_goalMinuteControllers[_selectedActivityType]!.text) +
                      1)
                  .toString();
        }
      }
    });
  }

  void incrementBehaviorMinute() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_behaviorMinuteControllers[_selectedActivityType]!.text.isEmpty) {
          _behaviorMinuteControllers[_selectedActivityType]!.text =
              1.toString();
        } else {
          _behaviorMinuteControllers[_selectedActivityType]!.text = (int.parse(
                      _behaviorMinuteControllers[_selectedActivityType]!.text) +
                  1)
              .toString();
        }
      }
    });
  }

  void decrementGoalHour() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_goalHourControllers[_selectedActivityType]!.text.isNotEmpty &&
            int.parse(_goalHourControllers[_selectedActivityType]!.text) > 0) {
          _goalHourControllers[_selectedActivityType]!.text =
              (int.parse(_goalHourControllers[_selectedActivityType]!.text) - 1)
                  .toString();
        }
      }
    });
  }

  void decrementBehaviorHour() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_behaviorHourControllers[_selectedActivityType]!.text.isNotEmpty &&
            int.parse(_behaviorHourControllers[_selectedActivityType]!.text) >
                0) {
          _behaviorHourControllers[_selectedActivityType]!.text = (int.parse(
                      _behaviorHourControllers[_selectedActivityType]!.text) -
                  1)
              .toString();
        }
      }
    });
  }

  void decrementGoalMinute() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_goalMinuteControllers[_selectedActivityType]!.text.isNotEmpty &&
            int.parse(_goalMinuteControllers[_selectedActivityType]!.text) >
                0) {
          _goalMinuteControllers[_selectedActivityType]!.text =
              (int.parse(_goalMinuteControllers[_selectedActivityType]!.text) -
                      1)
                  .toString();
        }
      }
    });
  }

  void decrementBehaviorMinute() {
    setState(() {
      if (_selectedActivityType != '') {
        if (_behaviorMinuteControllers[_selectedActivityType]!
                .text
                .isNotEmpty &&
            int.parse(_behaviorMinuteControllers[_selectedActivityType]!.text) >
                0) {
          _behaviorMinuteControllers[_selectedActivityType]!.text = (int.parse(
                      _behaviorMinuteControllers[_selectedActivityType]!.text) -
                  1)
              .toString();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initGoalHourControllers();
    _initGoalMinuteControllers();
    _initBehaviorHourControllers();
    _initBehaviorMinuteControllers();
  }

  void _initGoalHourControllers() {
    _goalHourControllers = {};
    activityTypes.values.forEach((activities) {
      activities.forEach((activity) {
        _goalHourControllers[activity] = TextEditingController();
        _goalHourControllers[activity]!.text = 0.toString();
      });
    });
  }

  void _initGoalMinuteControllers() {
    _goalMinuteControllers = {};
    activityTypes.values.forEach((activities) {
      activities.forEach((activity) {
        _goalMinuteControllers[activity] = TextEditingController();
        _goalMinuteControllers[activity]!.text = 0.toString();
      });
    });
  }

  void _initBehaviorHourControllers() {
    _behaviorHourControllers = {};
    activityTypes.values.forEach((activities) {
      activities.forEach((activity) {
        _behaviorHourControllers[activity] = TextEditingController();
        _behaviorHourControllers[activity]!.text = 0.toString();
      });
    });
  }

  void _initBehaviorMinuteControllers() {
    _behaviorMinuteControllers = {};
    activityTypes.values.forEach((activities) {
      activities.forEach((activity) {
        _behaviorMinuteControllers[activity] = TextEditingController();
        _behaviorMinuteControllers[activity]!.text = 0.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                const Icon(
                                  Icons.directions_run,
                                  color: secondaryColor,
                                ),
                                Text(
                                  myJournalItems[0],
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
                                        title: Text(myJournalItems[0],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        content: const Text(
                                          activityInfo,
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
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  labelText: 'Select activity category.'),
                              onChanged: (value) {
                                setState(() {
                                  _selectedActivityType =
                                      activityTypes[value!]!.first;
                                  _dependentItems = activityTypes[value!] ?? [];
                                  _goalHourController = _goalHourControllers[
                                      _selectedActivityType]!;
                                  _goalMinuteController =
                                      _goalMinuteControllers[
                                          _selectedActivityType]!;
                                  _behaviorHourController =
                                      _behaviorHourControllers[
                                          _selectedActivityType]!;
                                  _behaviorMinuteController =
                                      _behaviorMinuteControllers[
                                          _selectedActivityType]!;
                                });
                              },
                              items: activityTypes.keys
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  labelText: 'Select activity type.'),
                              onChanged: (value) {
                                _selectedActivityType = value!;
                                setState(() {
                                  _goalHourController = _goalHourControllers[
                                      _selectedActivityType]!;
                                  _goalMinuteController =
                                      _goalMinuteControllers[
                                          _selectedActivityType]!;
                                  _behaviorHourController =
                                      _behaviorHourControllers[
                                          _selectedActivityType]!;
                                  _behaviorMinuteController =
                                      _behaviorMinuteControllers[
                                          _selectedActivityType]!;
                                });
                              },
                              value: _selectedActivityType,
                              items: _dependentItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
                                    onChanged: (value) {
                                      setState(() {});
                                    },
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
                                    onChanged: (value) {
                                      setState(() {});
                                    },
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
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  labelText: 'Type my thoughts'),
                            ),
                            const SizedBox(
                              height: 15,
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
                            const Text(
                              'Please save for feedback!',
                              style: TextStyle(
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
