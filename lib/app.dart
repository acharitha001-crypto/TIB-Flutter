import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'state/planner_controller.dart';
import 'theme/app_theme.dart';

class TibApp extends StatelessWidget {
  const TibApp({super.key, required this.controller});

  final PlannerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => MaterialApp(
        title: 'TIB',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeShell(controller: controller),
      ),
    );
  }
}
