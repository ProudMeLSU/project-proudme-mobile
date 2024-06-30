import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:intl/intl.dart';

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(authTokenKey);
  await prefs.remove(userDataKey);
}

String getQueryParamsForGoalEndpoints(String id, String goalType) {
  var params = {
    'user[_id]': id,
    'goalType': goalType,
    'date': getNowInFormat(dateFormat)
  };
  return Uri(queryParameters: params).query;
}

String getNowInFormat(String format) {
  DateTime now = DateTime.now();
  return DateFormat(format).format(now);
}

String getPhysicalActivityBehaviorPayload(
    Map<String, TextEditingController> goalHourController,
    Map<String, TextEditingController> goalMinuteController,
    Map<String, TextEditingController> behaviorHourController,
    Map<String, TextEditingController> behaviorMinuteController,
    String userId,
    String feedback,
    String reflection,
    String totalGoal,
    String totalBehavior) {
  String date = getNowInFormat(dateFormat);
  String dateToday = getNowInFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');

  int goalValue = int.parse(totalGoal);
  int behaviorValue = int.parse(totalBehavior);

  Map<String, dynamic> activities = {};

  activityList.forEach((item) {
    int goalHours = int.tryParse(goalHourController[item]!.text) ?? 0;
    int goalMinutes = int.tryParse(goalMinuteController[item]!.text) ?? 0;

    int behaviorHours = int.tryParse(behaviorHourController[item]!.text) ?? 0;
    int behaviorMinutes =
        int.tryParse(behaviorMinuteController[item]!.text) ?? 0;

    activities[item] = {
      'goal': {'hours': goalHours, 'minutes': goalMinutes},
      'behavior': {'hours': behaviorHours, 'minutes': behaviorMinutes},
    };
  });

  bool goalStatus = behaviorValue >= goalValue;

  Map<String, dynamic> payload = {
    'behaviorValue': behaviorValue,
    'goalValue': goalValue,
    'reflection': reflection,
    'feedback': feedback,
    'date': date,
    'goalStatus': goalStatus,
    'user': userId,
    'recommendedValue': recommendedPhysicalActivityValue,
    'goalType': 'activity',
    'dateToday': dateToday,
    'activities': activities
  };

  return jsonEncode(payload);
}

Future<Map<String, dynamic>> getUserFromSharedPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return jsonDecode(prefs.getString(userDataKey) ?? '');
}

bool isToday(String date) {
  DateTime today = DateTime.parse(date);
  DateTime now = DateTime.now();

  return today.year == now.year &&
      today.month == now.month &&
      today.day == now.day;
}

Future<String> getUserId() async {
  Map<String, dynamic> user = await getUserFromSharedPreference();
  return user['_id'];
}

String getHourFromResponse(double s) {
  return s.toInt().toString();
}

String getMinuteFromResponse(double s) {
  return ((s - s.toInt()) * 60).toInt().toString();
}

double toDouble(dynamic value) {
  if (value.runtimeType == int) {
    return value.toDouble();
  } else if (value.runtimeType == double) {
    return value;
  } else {
    throw ArgumentError("Value must be numeric.");
  }
}

double getHourInDouble(String hour, String minute) {
  return int.parse(hour) + (int.parse(minute) / 60);
}

String getSleepPayload(String goalHour, String goalMinute, String behaviorHour,
    String behaviorMinute, String userId, String feedback, String reflection) {
  double goalValue = getHourInDouble(goalHour, goalMinute);
  double behaviorValue = getHourInDouble(behaviorHour, behaviorMinute);

  bool goalStatus = behaviorValue >= goalValue;
  String date = getNowInFormat(dateFormat);
  String dateToday = getNowInFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');

  Map<String, dynamic> payload = {
    'behaviorValue': behaviorValue,
    'goalValue': goalValue,
    'reflection': reflection,
    'feedback': feedback,
    'date': date,
    'goalStatus': goalStatus,
    'user': userId,
    'recommendedValue': recommendedSleepValue,
    'goalType': 'sleep',
    'dateToday': dateToday
  };

  return jsonEncode(payload);
}

String getEatingPayload(String goal, String behavior, String userId,
    String feedback, String reflection) {
  int goalValue = int.parse(goal);
  int behaviorValue = int.parse(behavior);

  bool goalStatus = behaviorValue >= goalValue;
  String date = getNowInFormat(dateFormat);
  String dateToday = getNowInFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');

  Map<String, dynamic> payload = {
    'behaviorValue': behaviorValue,
    'goalValue': goalValue,
    'reflection': reflection,
    'feedback': feedback,
    'date': date,
    'goalStatus': goalStatus,
    'user': userId,
    'recommendedValue': recommendedEatingValue,
    'goalType': 'eating',
    'dateToday': dateToday
  };

  return jsonEncode(payload);
}

String getChatbotPayloadForSleep(String goalHour, String goalMinute,
    String behaviorHour, String behaviorMinute, String reflection) {
  double totalGoal = int.parse(goalHour) + (int.parse(goalMinute) / 60);

  double totalBehavior =
      int.parse(behaviorHour) + (int.parse(behaviorMinute) / 60);

  double percentageAchieved = (totalBehavior / totalGoal) * 100;

  double percentageOfRecommendedGoal = (totalBehavior / 9) * 100;

  String content = "Health goal type: sleep, "
      "Recommended value: $recommendedSleepValue, "
      "Actual Goal Value: ${totalGoal.toStringAsFixed(2)}, "
      "Actual behavior value achieved: ${totalBehavior.toStringAsFixed(2)}, "
      "percentage of actual goal achieved: ${percentageAchieved.toStringAsFixed(2)}%, "
      "percentage of recommended goal achieved: ${percentageOfRecommendedGoal.toStringAsFixed(2)}%, "
      "Reflection: $reflection.";

  Map<String, List<Map<String, String>>> payload = {
    'prompt': [
      {'role': 'system', 'content': content}
    ]
  };

  return jsonEncode(payload);
}

String getChatbotPayloadForPhysicalActivity(int totalGoal, int totalBehavior, String reflection) {
  double percentageAchieved = (totalBehavior / totalGoal) * 100;

  double percentageOfRecommendedGoal = (totalBehavior / 9) * 100;

  String content = "Health goal type: physical activity, "
      "Recommended value: $recommendedPhysicalActivityValue, "
      "Actual Goal Value: ${totalGoal.toStringAsFixed(2)}, "
      "Actual behavior value achieved: ${totalBehavior.toStringAsFixed(2)}, "
      "percentage of actual goal achieved: ${percentageAchieved.toStringAsFixed(2)}%, "
      "percentage of recommended goal achieved: ${percentageOfRecommendedGoal.toStringAsFixed(2)}%, "
      "Reflection: $reflection.";

  Map<String, List<Map<String, String>>> payload = {
    'prompt': [
      {'role': 'system', 'content': content}
    ]
  };

  return jsonEncode(payload);
}

String getChatbotPayloadForEating(
    String goal, String behavior, String reflection) {
  double percentageAchieved = (int.parse(behavior) / int.parse(goal)) * 100;

  double percentageOfRecommendedGoal =
      (int.parse(behavior) / recommendedEatingValue) * 100;

  String content = "Health goal type: eating, "
      "Recommended value: $recommendedEatingValue, "
      "Actual Goal Value: $goal, "
      "Actual behavior value achieved: $behavior}, "
      "percentage of actual goal achieved: ${percentageAchieved.toStringAsFixed(2)}%, "
      "percentage of recommended goal achieved: ${percentageOfRecommendedGoal.toStringAsFixed(2)}%, "
      "Reflection: $reflection.";

  Map<String, List<Map<String, String>>> payload = {
    'prompt': [
      {'role': 'system', 'content': content}
    ]
  };

  return jsonEncode(payload);
}

String calculateTimeDifference(TimeOfDay startTime, TimeOfDay endTime) {
  int startMinutes = startTime.hour * 60 + startTime.minute;
  int endMinutes = endTime.hour * 60 + endTime.minute;

  int difference = endMinutes - startMinutes;

  if (difference < 0) {
    difference = 24 * 60 + difference;
  }

  return difference.toString();
}

String getTimeToDisplay(TimeOfDay time) {
  return '${time.hourOfPeriod}:${getDoubleDigitMinute(time.minute)} ${time.period.name}';
}

String getDoubleDigitMinute(int timeOfDayMinute) {
  String minute = timeOfDayMinute.toString();

  return minute.length == 1 ? '0$minute' : minute;
}
