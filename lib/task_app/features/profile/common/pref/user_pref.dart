import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String hasOnboardedKey = 'hasOnboarded';
  static const String isSignedInKey = 'isSignedIn';

  Future<bool> getOnboardState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasOnboardedKey) ?? false;
  }

  Future<bool> getSignedInState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSignedInKey) ?? false;
  }

  Future<bool> setSignedInStateAsTrue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isSignedInKey, true);
  }

  Future<bool> setSignedInStateAsFalse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isSignedInKey, false);
  }

  Future<bool> setOnboardedState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(hasOnboardedKey, true);
  }
}
