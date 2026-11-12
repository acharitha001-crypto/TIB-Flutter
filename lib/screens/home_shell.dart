import 'package:flutter/material.dart';

import '../state/planner_controller.dart';
import 'add_task_screen.dart';
import 'dashboard_screen.dart';
import 'performance_screen.dart';
import 'planner_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final PlannerController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _openAddTask() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddTaskScreen(controller: widget.controller)));

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final pages = [
      DashboardScreen(controller: c),
      PlannerScreen(controller: c),
      PerformanceScreen(controller: c),
      SettingsScreen(controller: c),
    ];
    return Scaffold(
      body: SafeArea(child: pages[_index]),
      floatingActionButton: _index < 2
          ? FloatingActionButton.extended(
              onPressed: _openAddTask,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Performance'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
