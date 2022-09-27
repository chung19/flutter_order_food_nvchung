import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  static String getString(String key) => _prefs?.getString(key) ?? "";

  static void setString({String key = "", String value = ""}) {
    if (value.isEmpty || key.isEmpty) return;
    _prefs?.setString(key, value);
  }
}
