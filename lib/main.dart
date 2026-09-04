import 'package:flutter/material.dart';
import 'app_root.dart';
import 'core/theme/app_theme.dart';

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
      home: const AppRoot(),
    );
  }
}
