import 'package:project_proud_me/constant.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(authTokenKey);
  await prefs.remove(userDataKey);
}
