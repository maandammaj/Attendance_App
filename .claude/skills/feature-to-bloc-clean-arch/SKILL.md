---
name: feature-to-bloc-clean-arch
description: >-
  Playbook for migrating (or building) a feature to Bloc + Clean Architecture in
  this Flutter app. Use when asked to "convert/refactor a feature to Bloc + Clean
  Architecture", decompose a God-Class screen/StatefulWidget, or scaffold a new
  feature under lib/features/<feature>/{domain,data,presentation}. Mirrors the
  completed `auth` migration (ADR-003) as the reference implementation.
---

# Feature → Bloc + Clean Architecture

A repeatable recipe for restructuring a feature into **domain ← data → presentation**
with `flutter_bloc`, `get_it`, `dartz` (`Either`), and `equatable`. The `auth`
feature is the canonical, already-shipped reference — read it when in doubt:
`lib/features/auth/` + `lib/core/{error,usecases,di,utils/result.dart}` +
[ADR-003](../../../docs/adr/ADR-003-bloc-clean-architecture.md).

## Project rules (non-negotiable — apply to every layer)

- **Every user-facing string is a translation key** — never a literal in a widget and
  never a hard-coded `static const` in Dart. The copy lives in BOTH
  `lib/config/locales/ar.json` and `lib/config/locales/en.json`, namespaced per feature
  (`account.title`, `account.menu.my_orders`, `account.failure.*`). Add the key to both
  files in the same pass; an English-only or Arabic-only key is a bug.
  - Widgets never spell a key out. Each feature owns one typed accessor,
    `presentation/<feature>_strings.dart`, which is the ONLY place the key strings
    appear, plus a `failure(messageKey)` resolver for `Failure.messageKey` →
    `<feature>.failure.<key>`. Reference:
    `lib/features/account_mangmant/presentation/account_strings.dart`.
  - Resolve context-free through `LangConfig.instance.data[key]` (wrapped in the
    accessor) so blocs, sheets and builders without a `BuildContext` use the same
    lookup. Do NOT call `LangConfig.of(context)?.data[...]` from a widget — that is the
    legacy pattern being retired, and it is what keeps the keys scattered.
  - The accessor falls back to the key when the delegate has not loaded (unit tests,
    early startup); keep that guard, it is the only defensive branch allowed here.
- **Reuse the legacy models in `lib/core/items/`** — never re-declare data the app already
  models. That folder holds the shipped `json_serializable` DAOs (`Account`, `Market`, `Cart`,
  `Product`, `Subscription`, `Tenant`, …) with their `*.g.dart`, SQLite table definition and CRUD
  statics; they are the app's real storage layer, and `02-project-structure.md` keeps them there.
  - Import them **only inside `data/`** (data sources, models, repository impls). They are DAOs
    carrying Flutter/SQLite dependencies — a `domain/` or `presentation/` import breaks the
    dependency rule. (`cart` and `all_offers` leak them into `domain/`; that is grandfathered and
    documented in place — do not copy it into a new migration.)
  - Map DAO → domain through a `*Model` in `data/models/`: `class FooModel extends FooEntity`
    with a `factory FooModel.fromCoreItem(Foo dao)`. Reference:
    `lib/features/subscriptions/data/models/subscription_model.dart`. When the mapping only
    filters and converts, a static mapper is enough — `data/models/tenant_model.dart`
    (`TenantModel.fromTenants`).
  - Write a NEW `data/models/<x>_model.dart` DTO (`fromJson`/`toJson`) only for a payload shape
    that has no `core/items` DAO. A new **persisted** model still belongs in `lib/core/items/`
    with its `*.g.dart` and a `database_provider.dart` migration — not in the feature folder.
  - Pure storage/lifecycle calls may use the DAO statics directly without a `*Model` wrapper —
    e.g. `Account.clear()` in `lib/features/auth/data/datasources/auth_local_data_source.dart`.
- **Web is a supported target** — `apps/{tawseel,almuealim,bazooka,sehabah_delivery}` each ship a
  `web/` build, so every layer must compile and run there. Do not write Android/iOS-only code.
  - **Never touch `dart:io`'s `Platform`.** Its `Platform.isX` getters compile for web but throw
    `UnsupportedError` the moment they are read — a top-level `final x = Platform.isAndroid ? …`
    crashes during startup. Go through `PlatformInfo` (`package:common/core/utils/platform_info.dart`, re-exported by
    the `package:common/common.dart` barrel):
    `PlatformInfo.isWeb/isAndroid/isIOS`, and `PlatformInfo.osType` for the backend's `os_type`.
  - **Data:** web has no encrypted SQLite. `AppSingleton.isWebVersion()`
    (`Singleton.IsWeb || IS_WEB_VERSION || !DatabaseProvider.isOpen`) is the "no local DB" flag —
    a local data source reading `DatabaseProvider.db` cannot be the source of truth there, so the
    repository falls back to remote. Reference: `Account.getAccount()` in
    `lib/core/items/account.dart` hits the setup endpoint instead of querying the table.
    `SharedPreferences` does work on web, so prefs-backed local sources need no branch.
  - **Presentation:** an iOS-only affordance is just `PlatformInfo.isIOS` — it already answers
    `false` on web. Do NOT carry over the legacy `!Singleton.IsWeb && Platform.isIOS` pairing
    (still in `cart_page.dart` and other unmigrated screens); the `IsWeb` half only existed to
    stop `dart:io`'s `Platform` from throwing, and `PlatformInfo` removes that need. Reach for
    `PlatformInfo.isWeb` when web needs a genuinely different branch. Most plugins here DO work on
    web (`geolocator_web`, `google_maps_flutter_web`, `firebase_messaging_web`,
    `permission_handler_html` all resolve in `apps/tawseel/pubspec.lock`) — check the lock file
    before writing a fallback. Full detail: `.claude/rules/19-web-support.md`.
- **Runnable app is `apps/tawseel/`** — any startup wiring (e.g. `configureDependencies()`)
  must be added to `apps/tawseel/lib/main.dart` too, not only `ecommerce_bloc/lib/main.dart`.
- **Naming:** domain entities end with `Entity` (`FooEntity`, file `foo_entity.dart`);
  data models end with `Model` (`FooModel`). Enums and transient result/bridge types keep
  their own names.
- Follow `CLAUDE.md`: extract duplicated logic into shared helpers, widget-based responsive
  UI (no giant `build`), theme-based styling (no hard-coded colors/sizes), dispose every
  controller/stream/timer, guard `setState`/context across `await` with `mounted`.

## Adapting by feature shape (READ FIRST)

The layering, DI, facade, storage-keys, naming and testing rules below are **universal** — apply
them to every feature. But `auth` is only ONE shape: a **command/flow** feature (stateful
multi-step flow + external SDK + session lifecycle). Most screens in this app are a different
shape, and copying auth literally will leave you missing the patterns that shape needs. First
classify the feature, then adjust the layers per this table:

| Shape | Examples | State holder | Use cases | Data/repository | Presentation |
|---|---|---|---|---|---|
| **Command / flow** (auth's shape) | login, checkout, OTP | **Bloc** (events per intent) | one per action | remote + SDK; local = flags/prefs | one page, per-state step router; side-effects service |
| **List / CRUD** (most common here) | products, orders, addresses, search | **Bloc** (events: load/loadMore/refresh/filter) | get-page, create, update, delete | **paginated**; repository merges cache+remote; map `PageEntity<T>{items,hasMore,nextCursor}` | list page (loading/empty/error/loaded) + detail/form pages; pull-to-refresh, infinite scroll, debounced search |
| **Read-only / display** | home sections, product detail, banners | **Cubit** (no event taxonomy needed) | 1–2 fetch use cases (or repo call direct) | remote, often cached | single page; skip the event boilerplate |
| **Cached / offline-first** | cart, favorites, catalog browse | Bloc or Cubit | get/sync use cases | **local source is a real cache** (SQLite/prefs), not just flags; repository does cache-then-network or offline-first; emit cached data immediately, refresh in background | show stale-while-revalidate; reflect sync state |

Cross-cutting decisions this implies:

- **Bloc vs Cubit:** use **Cubit** when there's no meaningful "event" vocabulary (a read-only
  screen with `load()`/`retry()`); use **Bloc** when distinct user intents justify events
  (flows, lists with load/loadMore/refresh/filter). Don't force Events on a 1-action screen.
- **How many use cases:** command/flow & CRUD → one per action. Read-only → 1–2, and it's fine
  for a thin screen to call the repository through a single `Get<X>` use case. Don't invent
  use cases that only forward.
- **Pagination (list shape):** model it in the entity (`PageEntity<T>` with `items`, `hasMore`,
  `nextCursor/page`) and in state (`loaded(items, isLoadingMore, hasReachedEnd)`); the bloc
  handles `LoadMore`/`Refresh`/`Filter` events. Lists must have search/filter + pull-to-refresh
  - pagination (CLAUDE.md) — never load everything at once.
- **Caching (cached/offline shape):** the local data source becomes a genuine cache layer, and
  the repository decides the policy (remote-only / cache-then-network / offline-first). auth's
  local source is NOT this — don't use it as the cache reference.
- **Multiple pages / blocs:** a feature may own several pages (list + detail + form) and more
  than one bloc/cubit. Keep them under the same `presentation/{bloc,pages,widgets}/`; the facade
  exports only the entry page(s) outside code routes to.
- **Side-effects service** (`*_service.dart`): auth-specific (session/topics). Only add one when
  a feature genuinely has app-wide lifecycle actions called from many screens — not by default.

Everything else in this skill is shape-independent. When unsure which shape, default to the
**List / CRUD** patterns — they're the majority case in this app.

## Target structure

```
lib/core/                                   ← shared, created ONCE (already exists)
  error/{failures,exceptions}.dart          — sealed Failure / AppException
  usecases/usecase.dart                     — UseCase<Type,Params>, NoParams
  utils/result.dart                         — typedef Result<T> = Either<Failure,T>
  di/injection.dart                         — get_it: configureDependencies()
  (shared SharedPreferences keys live in `AppStorageKeys`, exported from the
   `package:common/common.dart` barrel — see "Storage keys" below; an
   ecommerce_bloc-only shared key may instead define `AppStorageKeys` in ecommerce_bloc core)

lib/features/<feature>/
  <feature>.dart                             — (optional) public-API facade: export ... show ...
  <feature>_injection.dart                   — register<Feature>Feature(GetIt) DI module
  domain/                                    ← pure Dart. NO Flutter/Firebase/HTTP types.
    entities/<x>_entity.dart                 — Equatable value objects
    repositories/<feature>_repository.dart   — abstract contract, returns Result<T>
    usecases/<verb>.dart                     — one class per action (UseCase + Params)
  data/                                      ← the ONLY layer touching SDK/HTTP/storage
    models/<x>_model.dart                    — DTOs (fromJson/toJson) + `core/items` DAO → entity
                                               mappers (`<X>Model extends <X>Entity`)
    datasources/<feature>_remote_data_source.dart   — abstract + Impl (network/SDK)
    datasources/<feature>_local_data_source.dart     — abstract + Impl (prefs/SQLite)
    repositories/<feature>_repository_impl.dart      — orchestration + exception→Failure
    services/<feature>_service.dart          — (optional) extracted app-wide lifecycle helpers
                                               (auth reference: services/account_service.dart → AccountService)
    <feature>_storage_keys.dart              — (optional) feature-private SharedPreferences keys (NOT exported)
  presentation/
    <feature>_strings.dart                   — typed accessor over the `<feature>.*`
                                               keys in lib/config/locales/{ar,en}.json
    bloc/{<feature>_bloc,<feature>_event,<feature>_state}.dart
                                             — one Bloc: files sit directly in bloc/.
                                               Two or more: bloc/<holder>/… per holder.
    cubit/<holder>_cubit.dart                — Cubits NEVER share the bloc/ folder
    pages/<feature>_page.dart                — BlocProvider + a view that renders per-state
    widgets/{<page_name>/,shared/}           — grouped per page once widgets/ passes ~8 files
                                               or the feature owns 2+ pages
```

**Dependency rule:** `presentation → domain ← data`. Domain imports nothing from data, Flutter,
or `lib/core/items/`. Only `*_data_source.dart` touches `FirebaseAuth`, `NetworkUtils`,
`SharedPreferences`, `DatabaseProvider` and the `core/items` DAOs. The repository converts
`AppException` (data) → `Failure` (domain).

**Feature facade (optional `<feature>.dart`):** if outside code keeps importing the same few
symbols from a feature, add a curated barrel at the feature root that exports ONLY the public
surface — never a "export everything" barrel. A blanket barrel breaks the dependency rule
(it lets any consumer reach `data/` internals), hides real dependencies, and risks circular
imports. Rules:

- Export only the external surface with `show` (typically the page used by `routes.dart` and
  any service like `*_service.dart`). NEVER export `data/datasources`, `data/models`,
  `*_repository_impl`, domain use cases/repositories, or the internal Bloc.
- Outside code imports `package:ecommerce_bloc/features/<feature>/<feature>.dart`; inside the
  feature keep explicit imports so the layering stays visible.
- `lib/core/di/injection.dart` is the composition root — it legitimately imports the internal
  layers to register them and does NOT use the facade.
- Reference: `lib/features/auth/auth.dart` (exports only `LoginPage` + `AccountService`).

**Storage keys (no magic strings).** Never inline a `SharedPreferences` key as a literal — a
typo silently reads/writes the wrong key, and the flat key namespace is collision-prone.
Centralize keys as `static const String` in one of two homes:

- Feature-private key (only this feature's data layer touches it) →
  `lib/features/<feature>/data/<feature>_storage_keys.dart` (`<Feature>StorageKeys`). NOT
  exported from the facade — keys are a data-layer detail.
- Key shared by 2+ features / core → `AppStorageKeys`. NOTE: if the `common` package also
  uses the key (e.g. its storage migration list), the single source of truth must live in
  `package:common/core/storage/app_storage_keys.dart` (common can't import ecommerce_bloc) and be
  exported from the `package:common/common.dart` barrel — files already importing `common.dart`
  then get `AppStorageKeys` for free (no ecommerce_bloc shim file). If the key is ecommerce_bloc-only,
  define `AppStorageKeys` in ecommerce_bloc core directly.
- Litmus: "do I want another feature to read this key?" → then it's a core key; put it in core.
  Wanting to export a feature's keys is the signal they're actually shared. Always grep BOTH
  `ecommerce_bloc/lib` AND `flutter_libs_bloc/common/lib` before classifying — a key used in common is
  cross-package and belongs in common.
- NEW keys namespace their VALUE with a `feature.` prefix (e.g. `cart.items`) to avoid
  collisions. But NEVER change the VALUE of a key already shipped — it orphans users' stored
  data; only the Dart constant's name/location may change. (Verify a key's reach with a quick
  grep before deciding feature-private vs core.)
Reference: `package:common/core/storage/app_storage_keys.dart` (the shared single
source, re-exported via `common.dart`) + `lib/features/auth/data/auth_storage_keys.dart`
(feature-private). There is intentionally NO ecommerce_bloc re-export shim.

**The legacy `StateProvider` bus (you WILL hit this).** Almost every unmigrated screen mixes in
`StateListener` and reacts to untyped `int` signals from the global bus — ~280 live `notify` calls
remain. Full rules: `.claude/rules/21-legacy-state-provider.md`. The migration-relevant half:

- **Listeners are removed by the migration.** Never carry `with StateListener` into new code.
  Inject the shared `AppEventsDataSource` (`lib/core/utils/events/`, registered in `_registerCore`)
  behind a narrow feature-owned interface that names the signals it wants:
  `Stream<void> get onExternalChange => _events.whenAny(_watched);`. The bloc then consumes a
  plain stream and tests fake the feature's interface, not the global bus. Reference:
  `lib/features/notifications/data/datasources/notifications_events_data_source.dart`.
- **Notifiers are kept.** A migrated feature that mutates shared data must still call
  `StateProvider.notify(...)` while unmigrated screens are subscribed — they have no other way to
  hear it. Removing a `notify` is safe only when its last listener is gone; check with
  `grep -rn "case ObserverState.SIGNAL_NAME" lib`. Leave a `// legacy bus: <who still listens>`
  note next to each one you keep, and record it in the ADR.
- **Never add a constant** to `ObserverState` or `StateProvider`. A new cross-feature signal means
  the owning feature exposes a repository stream and the consumer depends on that repository.

## Step-by-step

### 0. Plan from the legacy code

Read the God Class / existing screen. List every distinct action (each becomes a use case),
every data shape (entity vs. model), every backend call/SDK touch (→ data source), every
piece of UI state (→ bloc state), and every lifecycle/side-effect (logout, analytics, FCM,
topics → repository side-effects or a `*_service.dart` service). Confirm scope:
note anything intentionally dropped.

### 1. Domain (write this first — it has no dependencies)

- **Entities** — `class FooEntity extends Equatable` with `props`. Immutable; add `copyWith`
  if state evolves. Hold no SDK types.
- **Repository contract** — abstract class; methods return `Future<Result<T>>` (use a plain
  type, not `Result`, only for calls that genuinely can't fail — see `resendTimerSeconds()`).
- **Use cases** — one per action, implementing `UseCase<Type, Params>`; bundle inputs into an
  `Equatable` `Params` (or `NoParams`). Use cases just delegate to the repository:

```dart
class RequestFooOtp implements UseCase<FooEntity, RequestFooOtpParams> {
  const RequestFooOtp(this.repository);
  final FooRepository repository;

  @override
  Future<Result<FooEntity>> call(RequestFooOtpParams p) =>
      repository.requestFooOtp(phone: p.phone, countryCode: p.countryCode);
}
```

### 2. Data

- **Models** — grep `lib/core/items/` FIRST: if the shape already has a DAO there, the model is a
  `<X>Model extends <X>Entity` with a `fromCoreItem(dao)` factory, not a new DTO. Only a shape with
  no DAO gets a fresh `fromJson`/`toJson` model. Keep server quirks here either way.
- **Data sources** — `abstract class FooRemoteDataSource` + `FooRemoteDataSourceImpl`. Throw
  `ServerException`/`NetworkException`/`AuthException(code)` where `code` is a **localization
  key** (e.g. `'no_internet_connection'`). Never return `Failure` from here, never touch
  `BuildContext`.
- **Repository impl** — inject the data sources; orchestrate; convert exceptions to failures:

```dart
@override
Future<Result<FooEntity>> requestFooOtp({...}) async {
  try {
    final session = await remote.requestFooOtp(...);
    return Right(session);
  } on NetworkException catch (e) {
    return Left(NetworkFailure(messageKey: e.code, message: e.message));
  } on AppException catch (e) {
    return Left(ServerFailure(e.code, message: e.message));
  } catch (e) {
    return Left(UnknownFailure(message: '$e'));
  }
}
```

### 3. Presentation (Bloc or Cubit — see "Adapting by feature shape")
>
> This section shows the **Bloc** path (command/flow & list shapes). For a read-only/display
> shape, use a **Cubit** instead — skip the Events taxonomy, expose methods (`load()`/`retry()`)
> that emit the same States; everything else (states, fold, page/strings) is identical.

- **Events** — `sealed`/abstract `FooEvent extends Equatable`, one per user intent.
- **States** — `sealed`/abstract `FooState extends Equatable`: `FooInitial`, loading states,
  success, `FooFailed(messageKey)`. Carry the data each step needs.
- **Bloc** — inject use cases; in each handler `fold` the `Result` into states:

```dart
Future<void> _onPhoneSubmitted(FooPhoneSubmitted e, Emitter<FooState> emit) async {
  emit(const FooRequesting());
  final res = await requestFooOtp(RequestFooOtpParams(phone: e.phone, ...));
  res.fold(
    (f) => emit(FooFailed(f.messageKey)),
    (session) => emit(FooOtpSent(session: session)),
  );
}
```

- **Page** — `BlocProvider(create: (_) => getIt<FooBloc>(), child: FooView())`. The view uses
  `BlocConsumer`: `listener` drives navigation / dialogs (loading/error via shared
  `package:common/views/loading/loading_view.dart` — `showLoadingDialog`/`hideDialog`/
  `showErrorDialog`/`showNormalDialog`/`isDialogShowing`), `builder` renders the step for the
  current state. Break the screen into small widgets under `widgets/`.
- **Strings** — every literal goes through `<feature>_strings.dart`, whose keys are added to
  BOTH `lib/config/locales/ar.json` and `en.json`; map `Failure.messageKey` via its
  `failure(...)` resolver. Styling from `Theme.of(context)` only.
- **Derived state predicates** — when `builder`/`listener` keep re-deriving booleans from the
  state (`isLoading`, `isOtpStep`, "is the back button blocked", which session+timer to show),
  put them in an `extension <Feature>StateX on <Feature>State` (one file,
  `bloc/<feature>_state_extensions.dart`) instead of repeating
  `state is FooLoading || state is FooRequesting` at every call site. Keeps the page declarative
  and the predicates tested in one place. Reference:
  `lib/features/auth/presentation/bloc/auth_state_x.dart` — the pattern is right, but the `_x`
  file name is the old spelling (`.claude/rules/20-naming-and-file-organization.md`); name new
  ones `*_state_extensions.dart`.
- **Well-known failure keys** — if the data layer emits specific `messageKey`s the UI must
  branch on (e.g. "user cancelled the OAuth sheet → stay silent"), name them as constants in
  `domain/<feature>_failure_keys.dart` rather than matching raw strings in the widget. Reference:
  `lib/features/auth/domain/auth_failure_keys.dart`.

**Keep the page file thin (split when it grows).** A page mixing chrome, a per-state step
router, state predicates, and navigation/dialog side-effects becomes a 300+ line file. Split by
responsibility (CLAUDE.md: no giant `build`, extract reused widgets):

- `pages/<feature>_page.dart` — keep TWO things here: the `BlocProvider` wrapper
  (`<Feature>Page`) and the `BlocConsumer` view (`<Feature>View`). The view owns the
  navigation/dialog side-effect methods as **private methods** (`_onStateChanged`,
  `_handleOutcome`, `_onBackRequested`). **Do NOT extract a separate `*_effects.dart` file** —
  effects need the view's `context`/`Navigator`/bloc and pulling them out only adds plumbing
  for no real reuse (decided against during the auth migration).
- `widgets/<feature>_step_view.dart` — the per-state step **router** (`switch`/`if` over the
  state → the right section widget); no business logic, just selection.
- `widgets/<surface>_scaffold.dart` — the branded chrome (gradient, logo, surface panel,
  safe-area) wrapping every step, so each step widget stays content-only.
- `widgets/<step>_section.dart` — one focused widget per step (phone input, OTP input, social
  fallback). Each disposes its own controllers/focus nodes.
- State predicates → the `<feature>_state_extensions.dart` extension above, not inline in the view.
Reference: `lib/features/auth/presentation/{pages/login_page.dart, widgets/{login_step_view,
auth_surface_scaffold,social_fallback_section}.dart, bloc/auth_state_x.dart}`.

### 4. Dependency injection (per-feature module + thin composition root)

Each feature owns its DI in `lib/features/<feature>/<feature>_injection.dart` — a top-level
`void register<Feature>Feature(GetIt getIt)` (manual get_it, no codegen). This keeps the
feature's internal types (`*Impl`, the Bloc) imported only there, not in a shared file that
would see every feature's internals. Register externals + data sources + repository + use
cases as `registerLazySingleton`; the **Bloc/Cubit as `registerFactory`** (fresh per screen).

```dart
// lib/features/foo/foo_injection.dart
void registerFooFeature(GetIt getIt) {
  getIt.registerLazySingleton<FooRemoteDataSource>(() => FooRemoteDataSourceImpl(...));
  getIt.registerLazySingleton<FooRepository>(
    () => FooRepositoryImpl(remote: getIt(), local: getIt()));
  getIt.registerLazySingleton(() => RequestFooOtp(getIt()));
  getIt.registerFactory(() => FooBloc(requestFooOtp: getIt(), verifyOtp: getIt()));
}
```

The composition root `lib/core/di/injection.dart` stays thin: register shared/core services
FIRST (so features can depend on them), then call each `register<Feature>Feature(getIt)`. Keep
it idempotent. The register function is NOT part of the feature facade — its only consumer is
this root, which imports it directly.

```dart
Future<void> configureDependencies() async {
  if (getIt.isRegistered<FooRepository>()) return;
  _registerCore(getIt);        // shared singletons (http client, storage) — once, here
  registerAuthFeature(getIt);  // then each feature module
  registerFooFeature(getIt);
}
```

Order matters: the root controls it. Register shared externals once in `_registerCore` (never
inside a feature module, to avoid double registration). Ensure `configureDependencies()` runs
at startup in **both** `apps/tawseel/lib/main.dart` and `ecommerce_bloc/lib/main.dart`.

### 5. Routing & cutover — delete the legacy screen in the same pass

Cut over on the **same route** and remove the old implementation as part of the migration.
Do NOT keep the legacy page behind a `kUseLegacy<Feature>` flag: earlier migrations did, and
every one of those flags is still sitting at `false` with a dead screen behind it (see
`REFACTOR_PROGRESS.md` → cross-cutting debt X-3). Git history is the rollback path.

1. **Give the new page the legacy page's `static const path`** (and `path_sub`, if it had
   one), so every caller, button and deep link keeps working untouched.
2. **Point the route at the new page** in `lib/core/utils/routes.dart` — one `case`, no branch:

   ```dart
   case <Feature>Page.path:
     widget = <Feature>Page(from: routingData['from']);
     break;
   ```

3. **Extract anything still shared** out of the legacy file before deleting it. A God-class
   screen often hides a public static that other features import (the account page's
   `getTenants` was called from three unrelated screens). Those become a proper widget /
   entry point in `presentation/`, exported from the feature facade.
4. **Delete the legacy file(s)** with `git rm`, then repoint **every** caller of the old
   symbol — grep the class name, not just the file path.
5. **Verify nothing references the old symbol:** a clean grep plus `flutter analyze`, and
   check for imports left behind in files that no longer use them.

### 6. Record what the migration dropped

Deleting the legacy screen means its quirks vanish silently unless you write them down. In the
ADR, list every behavior intentionally NOT carried over — dead menu entries, settings read but
never used, code paths that could only produce an error. Reviewers need to tell a deliberate
simplification from an oversight.

### 7. Tests (required — don't skip)

Add `test/features/<feature>/` mirroring the layers:

- `domain/usecases_test.dart` — each use case delegates correctly.
- `data/<feature>_repository_impl_test.dart` — orchestration + exception→Failure mapping,
  using fakes in `<feature>_test_doubles.dart`.
- `presentation/<feature>_bloc_test.dart` — `bloc_test` for every state transition.
- Aim to also cover the real data sources, widget tests (`testWidgets`) for the page/widgets,
  any extracted `*_service`, and an `integration_test/` for the end-to-end flow.
  At minimum ship the three unit-test files green.

### 8. Docs

- New ADR under `docs/adr/` for the architectural decision (template in `docs/templates/`).
- Add/update `docs/features/<feature>/` (architecture, changelog with a dated entry, tests,
  technical-debt). Record that the legacy page was **deleted**, and carry its removed
  behaviors into the changelog so the history is not lost with the file.
- Move the feature's row in `REFACTOR_PROGRESS.md` from *In progress* to *Migrated* and
  refresh the baseline metrics — it is part of the migration, not a follow-up.

## Verification checklist (run before reporting done)

- [ ] `flutter analyze lib/features/<feature> test/features/<feature>` — no new errors.
- [ ] `flutter test test/features/<feature>` — all green.
- [ ] Legacy page deleted, its route pointing at the new page on the same
      `<Feature>Page.path`; no `kUseLegacy<Feature>` flag, and a clean grep for the old symbol.
- [ ] Every behavior intentionally dropped is listed in the ADR.
- [ ] Domain layer imports no Flutter/Firebase/HTTP; data layer is the only SDK toucher.
- [ ] No `with StateListener` in the new code; listeners go through `AppEventsDataSource`, kept
      `notify` calls are annotated, and the ADR lists them (`.claude/rules/21-legacy-state-provider.md`).
- [ ] Entities end with `Entity`, models end with `Model`.
- [ ] Naming & layout per `.claude/rules/20-naming-and-file-organization.md`: full words (no `_x`,
      no `_widget` suffix), nothing loose at the `presentation/` root, Cubits out of `bloc/`,
      widgets grouped per page once they pass ~8 files.
- [ ] No shape re-declared that `lib/core/items/` already models; `core/items` imported only from
      `data/`, mapped to entities via `<X>Model.fromCoreItem`.
- [ ] Web-safe: no `dart:io` `Platform` (use `PlatformInfo`); local-DB reads have an
      `isWebVersion()` remote fallback; web-unsupported plugins have a branch or disabled state.
      See `.claude/rules/19-web-support.md`.
- [ ] Every new string exists in BOTH `lib/config/locales/ar.json` and `en.json`, and is
      reached only through `<feature>_strings.dart` — no literal or key inside a widget.
- [ ] `configureDependencies()` wired in `apps/tawseel/lib/main.dart`.
- [ ] New/changed screens checked in light AND dark mode, RTL-safe; all controllers disposed.
- [ ] ADR + `docs/features/<feature>/changelog.md` updated.

## Reference files (copy the patterns, not the domain)

- Core: `lib/core/usecases/usecase.dart`, `lib/core/utils/result.dart`,
  `lib/core/error/{failures,exceptions}.dart`, `lib/core/di/injection.dart`,
  `package:common/core/utils/platform_info.dart` (web-safe platform checks; via `common.dart`),
  `lib/core/items/` (the shipped DAOs — check here before writing any model)
- DAO → entity mapping: `lib/features/subscriptions/data/models/subscription_model.dart`
  (`fromCoreItem`), `lib/features/account_mangmant/data/models/tenant_model.dart` (static mapper)
- Domain: `lib/features/auth/domain/{entities,repositories,usecases}/`
- Data: `lib/features/auth/data/{models,datasources,repositories,services}/`
- Presentation: `lib/features/auth/presentation/{bloc,pages,widgets}/`,
  `lib/features/auth/presentation/auth_strings.dart`
