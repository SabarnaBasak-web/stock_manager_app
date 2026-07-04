import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  const ThemePreferences._();

  static const _darkModeKey = 'is_dark_mode';

  static Future<bool> loadDarkMode() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_darkModeKey) ?? false;
  }

  static Future<void> saveDarkMode(bool value) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_darkModeKey, value);
  }
}
