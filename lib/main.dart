import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_root.dart';
import 'core/scroll/helpfundus_scroll_behavior.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_notifier.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/app_shell/state/app_shell_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(themeModeProvider.notifier).load();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const HelpFundUsApp(),
    ),
  );
}

class HelpFundUsApp extends ConsumerWidget {
  const HelpFundUsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'HelpFundUs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      scrollBehavior: const HelpFundUsScrollBehavior(),
      home: const AppRoot(),
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');
        if (!uri.path.startsWith('/app-shell')) return null;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => AppShell(
            controller: AppShellController(),
            initialUri: uri,
            onSignOut: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const AppRoot()),
              (route) => false,
            ),
          ),
        );
      },
    );
  }
}
