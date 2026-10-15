import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The persisted appearance preference for the whole application.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw StateError('SharedPreferences must be initialized in main()'),
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    final savedMode = ref.read(sharedPrefsProvider).getString(_storageKey);
    return switch (savedMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  bool get isDarkMode => state == ThemeMode.dark;
  bool get followsSystem => state == ThemeMode.system;

  Future<void> load() async {
    state = build();
  }

  Future<void> toggleTheme() =>
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    final preferences = ref.read(sharedPrefsProvider);
    await preferences.setString(_storageKey, mode.name);
  }
}
