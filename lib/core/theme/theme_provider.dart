import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the application's selected appearance, including the device setting.
class ThemeProvider extends ChangeNotifier {
  static const _storageKey = 'helpfundus_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get followsSystem => _themeMode == ThemeMode.system;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedMode = preferences.getString(_storageKey);
    if (savedMode == null) return;

    final mode = switch (savedMode) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    if (mode != _themeMode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() =>
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, mode.name);
  }
}
