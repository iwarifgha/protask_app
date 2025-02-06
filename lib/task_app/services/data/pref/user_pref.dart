import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String hasOnboardedKey = 'hasOnboarded';
  static const String isSignedInKey = 'isSignedIn';
  static const String userIdKey = 'userIdKey';

  Future<bool> getOnboardState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasOnboardedKey) ?? false;
  }

  Future<bool> getSignedInState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSignedInKey) ?? false;
  }

   Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey) ?? '';
  }

  Future<bool> setSignedInState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isSignedInKey, value);
  }

  Future<bool> setOnboardedState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(hasOnboardedKey, true);
  }

  Future<bool> setUserId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, value);
  }
}
