import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final darkMode = ValueNotifier<bool>(false);
  static final arabic = ValueNotifier<bool>(false);

  static const String _darkModeKey = 'dark_mode';
  static const String _arabicKey = 'arabic';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    darkMode.value = prefs.getBool(_darkModeKey) ?? false;
    arabic.value = prefs.getBool(_arabicKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    darkMode.value = value;
  }

  static Future<void> setArabic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_arabicKey, value);
    arabic.value = value;
  }
}
