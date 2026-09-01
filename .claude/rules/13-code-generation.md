# Code Generation

* **Tooling:** `build_runner` + `json_serializable` (already dev dependencies).
* **When to regenerate:** after any change to a class annotated with `@JsonSerializable`, or after adding a new model file.
* **Command:**
  ```bash
  fvm dart run build_runner build --delete-conflicting-outputs
  ```
  Use `watch` instead of `build` only during active local development, never in scripts.
* **Generated files:** `*.g.dart` siblings of the model. They are excluded from analysis (see `analysis_options.yaml`) and must **not** be hand-edited.
* **Commit generated files:** yes — the project commits `*.g.dart` so CI and other developers do not need to regenerate before running.
* **Deleted models:** when removing a model, delete its `*.g.dart` too.
