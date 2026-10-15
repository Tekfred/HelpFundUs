import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helpfundus/core/theme/theme_mode_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults to system appearance and persists the selected mode', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
    await container
        .read(themeModeProvider.notifier)
        .setThemeMode(ThemeMode.dark);
    expect(preferences.getString('theme_mode'), 'dark');

    final restoredContainer = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(preferences)],
    );
    addTearDown(restoredContainer.dispose);
    expect(restoredContainer.read(themeModeProvider), ThemeMode.dark);
  });
}
