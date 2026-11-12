import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tib/app.dart';
import 'package:tib/services/storage_service.dart';
import 'package:tib/state/planner_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<PlannerController> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = PlannerController(StorageService());
    await c.load();
    await tester.pumpWidget(TibApp(controller: c));
    return c;
  }

  testWidgets('empty dashboard shows hint', (tester) async {
    await pumpApp(tester);
    expect(find.textContaining('No tasks due today'), findsOneWidget);
  });

  testWidgets('saving an empty form shows validation errors', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pump();
    expect(find.text('Please enter a task title'), findsOneWidget);
    expect(find.text('Please choose a subject'), findsOneWidget);
  });

  testWidgets('adding a task shows it on the dashboard', (tester) async {
    final c = await pumpApp(tester);
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Revise DBMS unit 3');
    await tester.tap(find.byKey(const Key('subjectField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('DBMS').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    expect(c.tasks.length, 1);
    expect(find.text('Revise DBMS unit 3'), findsOneWidget);
  });
}
