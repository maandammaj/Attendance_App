# Application Architecture — Bloc + Clean Architecture

This is what the app's architecture **is**. ADR-003 is the decision, the
`feature-to-bloc-clean-arch` skill is the procedure for moving a feature onto it; this file is the
description you should be able to read once and know where any piece of code belongs.

Migration is in progress: 8 of 20 features are on this architecture, the rest are legacy God-class
screens (`REFACTOR_PROGRESS.md` is the live state). Everything below describes the **target**, and
new code has no exemption from it.

## The one rule everything else follows

```text
presentation  ───▶  domain  ◀───  data
```

**Domain is the centre and depends on nothing.** No Flutter, no Firebase, no `http`, no
`sqflite`, no `lib/core/items/` DAOs, no `BuildContext`. It is plain Dart that could run in a
console. Presentation and data both point inward at it, and never at each other.

The inversion that makes this work: the **contract** lives in domain
(`domain/repositories/foo_repository.dart`, abstract), the **implementation** lives in data
(`data/repositories/foo_repository_impl.dart`). Domain declares what it needs; data satisfies it;
`get_it` connects them at startup. So the domain compiles with no knowledge that HTTP or SQLite
exist.

## The layers

```text
lib/features/<feature>/
  <feature>.dart                  ← optional curated facade (export … show …)
  <feature>_injection.dart        ← register<Feature>Feature(GetIt)

  domain/                         ← pure Dart. The rules. Depends on nothing.
    entities/<x>_entity.dart      ← Equatable value objects, immutable
    repositories/<feature>_repository.dart   ← abstract, returns Future<Result<T>>
    usecases/<verb>.dart          ← one class per action

  data/                           ← the ONLY layer allowed to touch the outside world
    models/<x>_model.dart         ← DTOs + `core/items` DAO → entity mappers
    datasources/…_remote_data_source.dart    ← HTTP / SDK. Throws AppException.
    datasources/…_local_data_source.dart     ← SQLite / SharedPreferences
    repositories/…_repository_impl.dart      ← orchestrates sources, maps errors

  presentation/                   ← Flutter. Renders state, sends intents.
    <feature>_strings.dart        ← typed accessor over the locale keys
    bloc/ | cubit/                ← state holders (one folder per holder)
    pages/<feature>_page.dart     ← BlocProvider + a view
    widgets/                      ← small, focused widgets
```

### Domain — what the feature means

* **Entities** (`FooEntity`) are `Equatable`, immutable, and hold no SDK types. They are what the
  rest of the app thinks in.
* **Repository contracts** are abstract classes returning `Future<Result<T>>`. A plain return type
  is allowed only when the call genuinely cannot fail.
* **Use cases** are one class per action, implementing `UseCase<Type, Params>` from
  `lib/core/usecases/usecase.dart`:

  ```dart
  abstract class UseCase<Type, Params> {
    Future<Result<Type>> call(Params params);
  }
  ```

  Inputs are bundled into an `Equatable` `Params` (or `NoParams`). A use case delegates to the
  repository — it is a *named* piece of business logic, not a forwarding layer for its own sake.
  Don't invent one that only forwards on a read-only screen; call the repository through a single
  `Get<X>` use case instead.

### Data — the only layer that touches the world

* **Data sources** are the sole holders of `http`, `FirebaseAuth`, `DatabaseProvider`,
  `SharedPreferences`, and the legacy `lib/core/items/` DAOs. They **throw** `AppException`
  subclasses — they never return a `Failure` and never see a `BuildContext`.
* **Models** (`FooModel`) convert the outside world into entities: a DTO with `fromJson`/`toJson`,
  or a `FooModel extends FooEntity` with a `fromCoreItem(dao)` factory when a `core/items` DAO
  already models the shape (`.claude/rules/20-…` and the skill cover which to write).
* **The repository implementation is the error boundary.** It is the single place where an
  exception becomes a value:

  ```dart
  try {
    return Right(await remote.fetchFoo(...));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(messageKey: e.code, message: e.message));
  } on AppException catch (e) {
    return Left(ServerFailure(e.code, message: e.message));
  } catch (e) {
    return Left(UnknownFailure(message: '$e'));
  }
  ```

  Above this line nothing throws for expected failures — callers `fold`.

### Presentation — renders state, sends intents

* A **Bloc** when distinct user intents justify an event vocabulary (flows; lists with
  load / loadMore / refresh / filter). A **Cubit** when there is none (`load()` / `retry()`).
  Neither is the lesser choice.
* The page is `BlocProvider(create: (_) => getIt<FooBloc>(), child: FooView())`. The view uses
  `BlocConsumer`: `listener` drives navigation and dialogs, `builder` renders the current state.
* **Widgets never** call a use case, a repository, or `getIt` directly, and never hold business
  logic. They receive state and emit events.
* State classes are `sealed`/abstract `Equatable` and carry exactly what the step needs:
  `FooInitial`, loading, success, `FooFailed(messageKey)`.

## The failure contract

`lib/core/error/` and `lib/core/utils/result.dart` are what let the layers stay decoupled:

| Layer | Type it speaks | Rule |
| --- | --- | --- |
| data source | `AppException` (thrown) | `code` is a **localization key**, not a sentence |
| repository | `Result<T>` = `Either<Failure, T>` | converts exception → failure, once |
| use case / bloc | `Failure` | never catches; it `fold`s |
| widget | `messageKey` → text | resolved via `<feature>_strings.dart` |

`Failure` is a `sealed` class carrying a `messageKey` — a locale key, never a localized string —
so the domain has no `BuildContext` and no Arabic/English text in it. That is why a bloc can be
unit-tested with no widget tree and no localization loaded.

## Dependency injection

`get_it`, registered **manually** — no `injectable`, no codegen. Two levels:

* Each feature owns `lib/features/<feature>/<feature>_injection.dart` exposing
  `void register<Feature>Feature(GetIt getIt)`. This is the only file that imports the feature's
  `*Impl` types and its Bloc, so internals stay invisible to everyone else.
* `lib/core/di/injection.dart` is the composition root: `_registerCore` first (shared singletons
  such as `AppEventsDataSource`), then each feature module. It stays thin and idempotent, and it
  is the one place allowed to reach past a feature's facade.

Lifetimes: data sources, repositories and use cases are `registerLazySingleton`; **Blocs and
Cubits are `registerFactory`** so each screen gets a fresh one. Everything below the locator is
constructor-injected — never resolve `getIt` inside `build()`.

`configureDependencies()` must run at startup in **both** `apps/tawseel/lib/main.dart` and
`lib/main.dart`.

## How a request actually flows

```text
user taps  →  FooEvent          (presentation)
           →  FooBloc handler   emits FooLoading
           →  UseCase(params)   (domain)
           →  FooRepository     (domain contract)
           →  FooRepositoryImpl (data)  ─┬─▶ remote data source → HTTP
                                         └─▶ local data source  → SQLite / prefs
           ←  Model.fromJson / fromCoreItem → FooEntity
           ←  Right(entity)  |  Left(Failure)
           →  bloc folds      emits FooReady(entity)  |  FooFailed(messageKey)
           →  BlocBuilder rebuilds
```

Mutations travel the same path in one direction. There is no back-channel: a data source never
calls into presentation, and a widget never reaches around its bloc.

## What is shared, and what is not

* `lib/core/` holds only genuinely cross-feature building blocks: `error/`, `usecases/`,
  `utils/result.dart`, `di/`, `utils/events/`, `utils/services/`, `views/widgets/`, and the legacy
  `items/` DAOs and `database_provider.dart`.
* **Never put feature logic in `core/`.** A feature is not "shared" because two screens inside it
  use it — see `02-project-structure.md`.
* A feature exposes its outside surface through an optional curated facade
  (`features/<feature>/<feature>.dart`) exporting only what other code routes to — typically the
  page and any app-wide service. Never a blanket `export` barrel: that would let any consumer
  reach `data/` internals and quietly break the dependency rule. What may appear in that
  file, who may import it, and why a long import list is never the reason to add one:
  `20-naming-and-file-organization.md` § Imports & exports.
* Cross-feature communication goes through a repository stream or an injected service, **not** the
  legacy `StateProvider` bus (`21-legacy-state-provider.md`).

## Testability is the point

The layering exists so each piece can be tested without the ones around it:

| Test | Substitutes |
| --- | --- |
| use case | a fake repository (hand-written) |
| repository impl | fake data sources — proves exception → failure mapping |
| bloc / cubit | fake use cases — proves every state transition |
| widget | a bloc seeded with states |

If something is hard to test, the layering is wrong — that is the signal, not an argument for a
mocking framework. See `14-testing.md`.

## Related

* Decision: [ADR-003](../../docs/adr/ADR-003-bloc-clean-architecture.md), and one ADR per migrated feature.
* Procedure: `.claude/skills/feature-to-bloc-clean-arch/SKILL.md`.
* State: [REFACTOR_PROGRESS.md](../../REFACTOR_PROGRESS.md).
* Folders and naming: `02-project-structure.md`, `20-naming-and-file-organization.md`.
* State management boundaries: `10-state-management-and-routing.md`.
