import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'is_dark_mode';

  final RxBool isDarkMode = false.obs;

  ThemeMode get themeMode {
    return isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final bool savedIsDarkMode = prefs.getBool(_themeKey) ?? false;

    isDarkMode.value = savedIsDarkMode;

    Get.changeThemeMode(savedIsDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(bool value) async {
    if (isDarkMode.value == value) return;

    isDarkMode.value = value;

    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  Future<void> setLightTheme() async {
    await toggleTheme(false);
  }

  Future<void> setDarkTheme() async {
    await toggleTheme(true);
  }
}
