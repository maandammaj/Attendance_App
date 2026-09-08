# Flutter Style Guide

* **SOLID & composition:** favor composition over inheritance. One responsibility per widget.
* **Immutability:** every `StatelessWidget` and every model under `lib/core/items/` is immutable — mark fields `final`.
* **`const` everywhere possible:** the analyzer enforces `prefer_const_constructors`; add `const` to any constructor that accepts it.
* **Widgets, not helper methods:** never return `Widget` from a private `_buildX()` method. Extract a small `_SectionWidget extends StatelessWidget` instead — it gets proper element-tree reuse and rebuild scoping.
* **State separation:** ephemeral, unobservable UI state stays inside `State`; everything else lives in a Bloc or Cubit — see `10-state-management-and-routing.md`, which is the single authority on this. No `ChangeNotifier`, no `rxdart` subject, no global mutable singleton.
* **Navigation:** use the standard `Navigator` with named routes registered in `lib/core/utils/routes.dart`. Do **not** introduce `go_router` or `auto_route`.
* **No async in `build`:** never call async functions, IO, or DB queries inside `build()`. Loading is the bloc's job — dispatch an event (or call the cubit method) and render the resulting state with `BlocBuilder`. `FutureBuilder` / `StreamBuilder` in a widget is the pre-Bloc pattern; do not add new ones.
* **Single quotes:** the linter enforces `prefer_single_quotes`. Use `'…'` unless the string contains a single quote.
* **Package imports:** the linter enforces `always_use_package_imports` — do not use relative imports across folders.
