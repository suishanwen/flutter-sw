import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static void set(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(key);
  }
}
