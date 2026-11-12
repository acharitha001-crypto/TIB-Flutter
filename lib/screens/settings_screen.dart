import 'package:flutter/material.dart';

import '../state/planner_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final PlannerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Target score'),
                subtitle: Text('${controller.targetPercent.round()}%'),
              ),
              Slider(
                value: controller.targetPercent,
                min: 40,
                max: 100,
                divisions: 12,
                label: '${controller.targetPercent.round()}%',
                onChanged: controller.setTarget,
              ),
            ]),
          ),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark mode'),
              value: controller.darkMode,
              onChanged: controller.setDarkMode,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Load demo data'),
              subtitle: const Text('Sample tasks and marks'),
              onTap: controller.loadDemoData,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Clear all data'),
              onTap: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear all data?'),
                    content: const Text('All tasks and marks will be removed.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                    ],
                  ),
                );
                if (ok == true) await controller.clearAll();
              },
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('TIB v1.0.0 · Flutter Lab Project')),
        ],
      ),
    );
  }
}
