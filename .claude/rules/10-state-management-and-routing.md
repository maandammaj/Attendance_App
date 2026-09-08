# State Management & Routing

## Bloc is the only state management

The project runs **Bloc + Clean Architecture, and nothing else** (ADR-003). There is no second
pattern, no "primary and fallback" — a screen's state lives in a Bloc or a Cubit, reached through
`BlocProvider` / `BlocBuilder` / `BlocConsumer`, and the layering in the
`feature-to-bloc-clean-arch` skill is how it gets there.

* **Bloc vs Cubit** is the only choice to make: Cubit when there is no meaningful event vocabulary
  (`load()` / `retry()`), Bloc when distinct user intents justify events. Both are equally
  first-class — a Cubit is not a lesser option.
* **Do not introduce any other state-management package** — `provider`, `riverpod`, `mobx`,
  `get`, `redux`, `signals`. This is not a preference to re-litigate per feature.
* **Do not hand-roll one either.** These are state management under another name and are all
  banned in new code:
  * `ChangeNotifier` / `ValueNotifier` holding anything a screen renders. (`ValueNotifier` is
    fine as a *widget-local* plumbing detail — e.g. driving an `AnimatedBuilder` — never as the
    place a feature's data lives.)
  * The ad-hoc `controllers/` classes with `onStateChange` callbacks still found under
    `lib/features/{order,main,home}/…/controller*/` — the pattern the migrations delete.
  * The global `StateProvider` bus — frozen, see `21-legacy-state-provider.md`.
  * `rxdart` `BehaviorSubject`/`PublishSubject` as a feature's state holder.
* **`setState` is not a loophole.** It is allowed only for state that is born and dies inside one
  widget and that nothing else can observe: an expand/collapse flag, a focus or scroll position, a
  local animation value. The moment a second widget, a test, or a navigation result needs to read
  it, it belongs in a Cubit.
* **Dependency injection:** `get_it` through `lib/core/di/injection.dart`, with constructor
  injection everywhere below it — never resolve `getIt` inside a widget's `build`. Legacy
  cross-feature singletons still live in `lib/core/utils/` (`DatabaseProvider`, `App`) and are
  retired feature by feature.

`rxdart` is imported by **zero** files in `lib/`, `test/` and `apps/` — only the `common` package
uses it, and it declares its own copy. What appears in this repo's `pubspec.yaml` is a
`dependency_overrides:` pin, not a dependency you may build on; it must stay (removing it breaks
`flutter pub get`) and it must not be imported.

## Stream lifecycle hygiene

Streams still cross the data layer — repositories expose them and blocs consume them.

* Every `StreamSubscription` is stored as a field and cancelled in `close()` (Bloc/Cubit) or
  `dispose()` (`State`) — the `cancel_subscriptions` lint is enabled.
* Every `StreamController` owner closes it in the same place (`close_sinks` is enabled).
* Never create a controller or subscribe inside `build()`.

## Routing

* **Router:** standard `Navigator` with **named routes** registered in `lib/core/utils/routes.dart`.
* **Adding a new screen:** register it in `routes.dart` and navigate via `Navigator.pushNamed(context, RoutePaths.foo, arguments: …)`. Type the arguments; do not pass loose maps if a typed argument class already exists.
* **Do not add** `go_router` / `auto_route`. Deep linking is handled through `app_links` + `routes.dart`.
* **Dialogs / bottom sheets:** use `showDialog`, `showModalBottomSheet` — not new named routes.
* **Back handling:** every screen must have a working back button; destructive actions require a confirmation dialog (see `CLAUDE.md` § UX).
