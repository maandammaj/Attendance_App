# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`attendance_budget_app` — an offline-first Flutter app (Arabic UI) that tracks work attendance and turns it into money: hours worked feed a salary calculation, alongside personal budget, debts, and account ledgers. Flutter 3.41 / Dart SDK `^3.7.0`. No backend — all data lives in a local Isar database.

## Commands

```bash
flutter pub get
flutter run                                   # -d <device>; see `flutter devices`
flutter analyze                               # lints via flutter_lints
flutter test                                  # all tests
flutter test test/widget_test.dart            # single file
flutter test --plain-name "App load test"     # single test by name

# Code generation — REQUIRED after touching any @collection model or @riverpod provider
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs
```

Generated `*.g.dart` files are committed to the repo, so a checkout builds without running build_runner first — but regenerate and commit them whenever the source annotations change.

## Architecture

Clean-architecture layering, wired with Riverpod:

```
presentation/screens,widgets  →  presentation/providers  →  domain/usecases  →  domain/repositories (abstract)
                                                                                        ↑ implements
                                                                          data/local/repositories → Isar
```

- **`domain/entities`** — plain immutable Dart classes, no Isar dependency. Enums are flattened to `String` at this boundary (e.g. `AttendanceEntity.dayType` is a String, `AttendanceModel.dayType` is a `DayType` enum).
- **`data/models`** — Isar `@collection` classes. Every repository impl owns private `_mapToEntity` / `_mapToModel` functions; there is no shared mapper layer. Adding a field means editing model, entity, both mappers, and re-running build_runner.
- **`data/local/repositories`** — the only code that touches Isar. Each impl gets the DB via `Future<Isar> get _db async => await IsarDatabase.instance;` and wraps writes in `isar.writeTxn`.
- **`domain/usecases`** — thin callable wrappers (`call(...)`) over repository methods. A few carry real logic: `GetMonthlyStatsUseCase` aggregates a month of records into `MonthlyStats`, `GetDebtsSummaryUseCase` similarly for debts.
- **`presentation/providers`** — the composition root. Each feature file declares plain `Provider`s for its repository + use cases, `@riverpod` functions for reads, and a `@riverpod class XController extends _$XController` for writes. Controllers hold `AsyncValue<void>` state and refresh reads via `ref.invalidate(...)` (see `AttendanceController._invalidateAll`), so there is no reactive stream from Isar — invalidation is manual and easy to forget.

### Database

`IsarDatabase.instance` is a lazily-initialized static singleton opened in `main()`. All seven schemas are registered in one place — `lib/data/local/database/isar_database.dart`. **A new `@collection` must be added to that schema list or queries against it fail at runtime.**

Uses the `isar_community` fork (`isar_community`, `isar_community_flutter_libs`, `isar_community_generator`), not upstream `isar`. Import `package:isar_community/isar.dart`. This is why Android `minSdk` is pinned to 23.

`ProfileModel` is a **singleton row with `Id id = 0`** — code reads it via `isar.profileModels.get(0)`. It carries the `workSchedule` (a `List<WorkDayConfig>` of embedded per-weekday configs with optional `startTime`/`endTime`/`isCrossDay` shift windows) and `adjustments`, so most attendance and salary logic depends on the profile existing; `AttendanceRepositoryImpl.checkIn` throws `Exception('Profile not set')` without it.

### Salary model

`lib/core/utils/salary_calculator.dart` is the single source of financial truth and the most subtle file in the repo:

- `hourlyWage` prefers the manually entered `profile.hourlyRate`, else derives it from `baseMonthlySalary / (weekly scheduled hours × 4.33)`.
- `overtimeHourlyRate` overloads one field: `profile.overtimeRate > 2` is treated as an absolute per-hour rate, otherwise as a multiplier on `hourlyWage`.
- `calculateShiftDetails` computes overtime/deficit by intersecting the actual presence interval with the scheduled shift window — time inside the window counts as official, missing window time is deficit, presence outside the window (before *or* after) is overtime. With no `startTime`/`endTime` on the day config it returns all zeros and the caller falls back to raw worked hours.
- `calculateMonthly` folds overtime, deficit, `SalaryAdjustment`s, debt payments, and expenses into gross/net.

Attendance records store the *derived* money values (`overtimeValue`, `deficitValue`) at write time, so changing salary settings does not retroactively recompute existing rows.

### Navigation & app shell

`HomeScreen` is the real shell: an `IndexedStack` of five tabs (budget, attendance, debts, accounts, profile) with `CustomBottomNav` and a large biometric FAB that drives check-in/check-out. The named routes in `lib/config/routes.dart` also map `/` to `HomeScreen`, so pushing `AppRoutes.home` re-enters the shell rather than popping to it. `onGenerateRoute` always returns null.

`AutomationService.runDailyAutomation(ref)` fires once from `HomeScreen.initState` via a post-frame callback — currently only warns about a check-in left open >16h; the recurring-expense and debt-reminder branches are stubs.

### Auth & notifications

- `BiometricAuthService` (`core/utils/biometric_auth.dart`) is the one used in production paths. Note that `AttendanceController.checkIn/checkOut` **treat unavailable biometrics as success** so the flow works on emulators and desktop — do not assume `isBiometricVerified` implies a real fingerprint.
- `NotificationService` is a singleton initialized in `main()`; every `showNotification` also persists a `NotificationModel` row that backs `NotificationHistoryScreen`.

## Conventions & gotchas

- UI text, comments, and many identifiers are Arabic. Keep new user-facing strings Arabic; reuse `AppConstants` (currency `ر.ي`, `arabicDays`, biometric prompts) rather than hardcoding.
- `main()` calls `initializeDateFormatting('ar')` and sets `Intl.defaultLocale = 'ar'`. `MaterialApp` declares **no** `localizationsDelegates`/`supportedLocales` and no explicit RTL — screens handle direction themselves. Adding `flutter_localizations` is the correct fix if you need Material widgets localized.
- `DateHelpers` and `WorkDayConfig.dayOfWeek` use a **Saturday-first week** via `date.weekday % 7` (Sunday→0, Saturday→6) matching `AppConstants.arabicDays`. Do not mix this with Dart's `DateTime.weekday` (Monday=1) directly.
- Two dead duplicates exist — prefer the live ones: `lib/core/constants/theme.dart` is the theme actually imported by `app.dart` (`lib/core/theme/app_theme.dart` is an unused copy), and `lib/presentation/viewmodels/*.dart` are unreferenced `StateNotifier` predecessors of the current `@riverpod` controllers in `lib/presentation/providers/`.
- `freezed` and `json_serializable` are in `dev_dependencies` but nothing uses them yet; entities are hand-written.
- iOS/macOS `Podfile`s and the Flutter xcconfigs are locally modified/untracked — check `git status` before assuming platform config is clean.

## Agent configuration (`.claude/`, `.agents/`)

Both directories are **untracked** (`git status` shows `?? .claude/` and `?? .agents/`) and neither is in `.gitignore` — decide deliberately whether to commit them.

- **`.agents/rules/`** (01–17) — the generic upstream Dart/Flutter guideline set. Framework-level advice (style, best practices, code quality, accessibility) that applies anywhere.
- **`.claude/rules/`** (01–23) — a customized fork of those same 17 files **plus** 18–23, all rewritten for a *different* codebase: the Tawseel `ecommerce_bloc` app. Every one of the 17 shared filenames differs from its `.agents/` counterpart.
- **`.claude/skills/`** — the `.agents/skills/` set (Dart/Flutter task playbooks: unit tests, coverage, ffigen, responsive layout, layout fixes, …) plus `find-skills`, and `humanizer` as a symlink into `.agents/skills/`.
- **`.claude/settings.json`** — a permission allowlist whose entries point at `/Users/tawseeldev/AndroidStudioProjetcs/Dart3TawseelApps/ecommerce_bloc`, not this repo. Only `Bash(flutter analyze *)`, `Bash(flutter test *)`, and `Bash(python3 -)` are useful here.
- **`skills-lock.json`** (repo root) — pins the vendored `humanizer` skill to `blader/humanizer` with a content hash.

### The rules describe a different project — read them with that in mind

`.claude/rules/` is written as the law of the Tawseel e-commerce app, and much of it directly contradicts this codebase:

| `.claude/rules/` says | This repo actually does |
| --- | --- |
| Bloc + `get_it` only; **"do not introduce riverpod"** (rule 10) | Riverpod `@riverpod` providers and controllers throughout |
| `lib/features/<feature>/{domain,data,presentation}` (rules 02, 08) | Layer-first `lib/{domain,data,presentation}`, no `features/` |
| Models in `lib/core/items/` with `json_serializable` (rules 02, 11, 13) | Isar `@collection` models in `lib/data/models/`, no JSON layer |
| Routes in `lib/core/utils/routes.dart` (rule 02) | `lib/config/routes.dart` |
| Run `fvm flutter …` (rules 04, 13, 14) | Plain `flutter` / `dart` — no fvm in this project |
| `sqflite_sqlcipher`, `dartz`, `flutter_bloc`, `common` path package (rule 04) | Isar, Riverpod, no local path deps |
| `custom_lint`, `strict-inference`, long exclude list (rule 09) | `analysis_options.yaml` is stock `flutter_lints` and nothing else |
| Localization via `LangConfig` + `lib/config/locales/*.json` (rule 17) | No localization layer at all — Arabic strings inline |
| References `docs/`, `ADR-003`, `REFACTOR_PROGRESS.md`, `.claude/settings.local.json` | None of these exist here |

The same mismatch is baked into several skill descriptions, which carry prefixes like *"DO NOT USE IN THIS PROJECT"* or *"SUPERSEDED IN THIS PROJECT"* — those verdicts were written against the Tawseel repo, so re-derive them here rather than trusting them.

**What still transfers:** the framework-neutral guidance — RTL/`start`-`end` discipline over raw `left`/`right` (rule 01), no speculative defensive code (rule 01), function/file size and code-quality limits (rule 05), Dart and Flutter best practices (rules 06, 07), theme-token access over inline `Color(0xFF…)`/`TextStyle` (rule 15), accessibility (rule 17), and the surface-the-assumption-and-proceed stance (rule 22). The generic `.agents/rules/` copies are the safer read where the two disagree.

**Broken entries** — `.claude/skills/impeccable` and `.claude/skills/ui-ux-pro-max` are plain text files containing a relative path (a symlink that did not survive a copy), and `.claude/skills/screensdesign-data` is a symlink to a nonexistent `.agents/skills/screensdesign-data`. None of the three loads as a skill.

## Other agent configs

An OpenAI Codex config (`~/.codex/config.toml`) and a Gemini CLI config (`~/.gemini/settings.json`) exist on this machine. To import their MCP servers, commands, subagents, skills, or instructions, reply `/import` to see what's importable, then `/import --yes=<digest>` to apply. (If `/import` isn't available on this surface, run `claude import` from a terminal.)
