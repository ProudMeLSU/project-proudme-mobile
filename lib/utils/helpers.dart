import 'dart:convert';

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

  Map<String, dynamic> payload = {
    'behaviorValue': behaviorValue,
    'goalValue': goalValue,
    'reflection': reflection,
    'feedback': feedback,
    'date': date,
    'goalStatus': goalStatus,
    'user': userId,
    'recommendedValue': recommendedSleepValue,
    'goalType': 'sleep'
  };

  return jsonEncode(payload);
}

String getChatbotPayload(String goalHour, String goalMinute,
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
