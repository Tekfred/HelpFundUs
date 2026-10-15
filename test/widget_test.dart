import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpfundus/core/theme/theme_mode_notifier.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/main.dart';

void main() {
  testWidgets('App starts with splash and auto-advances to welcome screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(preferences)],
      child: const HelpFundUsApp(),
    ));

    // Verify that the splash screen text exists.
    expect(find.text('HelpFundUs'), findsOneWidget);
    expect(find.text('Crowdfunding that cares'), findsOneWidget);

    // Wait for the splash screen duration to elapse and trigger frame.
    await tester.pumpAndSettle(AppMotion.splashHold);

    // Verify that the welcome screen contents are now displayed.
    expect(find.text('Get Started'), findsOneWidget);
  });
}
