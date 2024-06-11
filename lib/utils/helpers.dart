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
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('M/d/yyyy').format(now);
  var params = {'user[_id]': id, 'goalType': goalType, 'date': formattedDate};
  return Uri(queryParameters: params).query;
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
