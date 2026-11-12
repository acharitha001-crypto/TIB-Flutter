# Architecture

TIB uses a simple three-layer design.

| Layer | Files | Responsibility |
|---|---|---|
| Presentation | `lib/screens/*`, `lib/widgets/*` | Screens and reusable widgets |
| State | `lib/state/planner_controller.dart` | Holds tasks, scores and settings; analytics; `notifyListeners()` |
| Data | `lib/models/*`, `lib/services/storage_service.dart` | Models with JSON conversion; saving with shared_preferences |

## Data flow

1. A screen calls a controller method (for example `addTask`).
2. The controller updates its list and saves it through `StorageService`.
3. `notifyListeners()` rebuilds every `ListenableBuilder`, so all tabs stay in sync.

## Key calculations

- **Completion rate** = completed tasks ÷ total tasks
- **Subject average** = total marks ÷ total maximum marks for that subject
- **Weak subjects** = subjects whose average is below the target score
- **Grade**: O ≥ 90, A+ ≥ 80, A ≥ 70, B+ ≥ 60, B ≥ 50, C ≥ 40, otherwise F
