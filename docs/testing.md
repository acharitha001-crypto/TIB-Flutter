# Test Plan

Run all tests with `flutter test`.

| Test case | Type | File | Expected result |
|---|---|---|---|
| StudyTask JSON round trip | Unit | model_test.dart | All fields preserved |
| Unknown priority fallback | Unit | model_test.dart | Mapped to Medium |
| SubjectScore percentage | Unit | model_test.dart | 27/30 = 90 % |
| Grade mapping | Unit | model_test.dart | 92 → O, 75 → A, 35 → F |
| Due labels | Unit | model_test.dart | Today / Tomorrow / Overdue |
| Validators | Unit | model_test.dart | Errors for invalid input |
| Add, toggle, delete tasks | Unit | controller_test.dart | Completion rate updated |
| Subject averages & weak subjects | Unit | controller_test.dart | Sorted, weak subject flagged |
| Persistence | Unit | controller_test.dart | Same data after reload |
| Search & filter | Unit | controller_test.dart | Only matching tasks |
| Empty dashboard | Widget | widget_test.dart | Hint shown |
| Empty form validation | Widget | widget_test.dart | Error messages shown |
| Add a task | Widget | widget_test.dart | Task shown in Today's focus |
