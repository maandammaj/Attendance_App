# Package Management

* **Flutter binary:** the project runs through `fvm flutter …` (already allowed in `.claude/settings.local.json`). Use it in Bash instead of raw `flutter`.
* **Add a runtime dep:** `fvm flutter pub add <package>`.
* **Add a dev dep:** `fvm flutter pub add dev:<package>`.
* **Remove:** `fvm flutter pub remove <package>`.
* **Overrides:** use `dependency_overrides` in `pubspec.yaml` only when unavoidable; leave a comment explaining why.
* **Before adding any new dependency:**
  1. Check that it is not already declared in `pubspec.yaml` or provided by the local `common` package.
  2. Ask first before adding a heavyweight dependency (state management, navigation, DI). The project deliberately uses built-in solutions — do not silently introduce a new paradigm.
  3. Keep `pubspec.yaml` sorted alphabetically inside each section (`sort_pub_dependencies` is enabled).
* **Local path deps:** `common: path: ../flutter_libs/common`. Cross-app changes go there, not into this repo.
* **Established dependencies (do not propose equivalents):** `flutter_bloc`, `bloc`, `get_it`, `dartz`, `equatable`, `sqflite_sqlcipher`, `http`, `json_serializable`, `flutter_svg`, `google_maps_flutter`, `geolocator`, `permission_handler`, `webview_flutter`, `flutter_inappwebview`, `carousel_slider`, `percent_indicator`, `flutter_cached_pdfview`, `path_provider`, `app_links`, `sign_in_with_apple`.
* **`rxdart` is a pinned override, not a dependency you may use.** It appears under `dependency_overrides:` in both `pubspec.yaml` and `apps/tawseel/pubspec.yaml` to pin the version transitive packages (`common`, others) resolve to — **removing it breaks `flutter pub get`**, verified. No file in `lib/`, `test/` or `apps/` imports it, and none may: state management is Bloc-only (`10-state-management-and-routing.md`).
* **Read the section header before touching a version line.** `dependency_overrides:` entries look like ordinary dependencies but are load-bearing pins; deleting one re-opens the whole resolution and can surface an unrelated conflict.
