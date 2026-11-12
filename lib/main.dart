import 'package:flutter/material.dart';

import 'app.dart';
import 'services/storage_service.dart';
import 'state/planner_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = PlannerController(StorageService());
  await controller.load();
  runApp(TibApp(controller: controller));
}
