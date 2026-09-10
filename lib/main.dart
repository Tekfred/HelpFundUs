import 'package:flutter/material.dart';
import 'app_root.dart';
import 'core/scroll/helpfundus_scroll_behavior.dart';
import 'core/theme/app_theme.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/app_shell/state/app_shell_controller.dart';

void main() {
  runApp(const HelpFundUsApp());
}

class HelpFundUsApp extends StatelessWidget {
  const HelpFundUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpFundUs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
