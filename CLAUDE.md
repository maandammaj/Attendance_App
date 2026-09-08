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
- **Attendance is session-based.** `AttendanceModel` owns `List<WorkSession> sessions` — a day may hold several check-in/check-out pairs (lunch, an errand, a split shift). `isOpen` is an indexed flag for "the last session has no `checkOut`", because Isar cannot query inside an embedded list. `checkIn`/`checkOut`/`totalPresenceMinutes`/`sessionCount` are **derived** and rewritten by `AttendanceRepositoryImpl._recalculate`, which is the single place any path (biometric, manual, edit) passes through. `AttendanceMigration.run` backfills a one-session list for records written before this model; it runs on every `Isar.open` and is a no-op after the first time.
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

### Design system

`core/constants/design_tokens.dart` defines `AppPalette` — **every colour written out per theme, never derived by `ColorScheme.fromSeed`**, because a derived scheme gives no contrast guarantee. Read it in a widget with `context.palette` (a `ThemeExtension`), which is the only way to reach the financial semantics (`positive`/`negative`/`warning`/`info`) that `ColorScheme` has no slot for. There are **zero** hardcoded `Colors.red`/`Colors.grey`/… left under `lib/presentation`; adding one silently breaks dark mode.

**`accent` (gold) is reserved for money** — the salary, the amount earned, a net figure. It exists so a monetary number outranks everything around it; before it, an amount was the same blue as the navigation and led nothing. Spending it on a non-monetary element destroys the signal, so don't. `accentOnBrand` is its lighter twin, used only over `brandGradient`, where the on-surface gold has too little contrast. `brandGradient` and `activeGradient` are `static const` on the class, not per-instance: the hero card is a dark surface in both themes, so white and gold keep identical ratios over it.

**Chart colour is computed, not chosen.** `AppPalette.categorical` is 8 slots per theme, produced by running the `dataviz` skill's `scripts/validate_palette.js` until every check passed — lightness band (light `0.43–0.77`, dark `0.48–0.67`, they differ), chroma floor, CVD ΔE, normal-vision ΔE, and contrast vs surface. The previous palette failed it (`#757575` read as gray). Slots are assigned **in fixed order and never cycled**: a 9th category folds into "أخرى" rather than taking a generated hue, which would not survive CVD. Never eyeball a replacement — re-run the validator.

Three checks guard the palette and all must stay green:

```bash
python3 tool/contrast_check.py            # the raw hex pairs, before the theme is built
flutter test test/core/theme              # the resolved ThemeData + categorical ΔE in OKLab
node <dataviz>/scripts/validate_palette.js "<8 hexes>" --mode light|dark --surface "<surface>"
```

They cover different failure modes — the first catches a bad hex, the second catches the palette and the derived `ColorScheme` drifting apart.

**Typography is bundled, not fetched.** `google_fonts` was removed: it downloads the face at runtime, so an offline-first app silently lost its Arabic font on a device with no connection. `Tajawal` ships in `assets/fonts/` at weights 400/500/700 and serves both the UI and the PDF export, so the printed report matches the screen.

**`flutter_animate`: never disable an entrance with `target: 0`.** It drives the chain toward its *start*, and `fadeIn`'s start is opacity 0 — the widget builds and stays invisible. Skip the chain instead: `if (context.prefersReducedMotion) return card;`. (An *effect* like `shimmer` is safe at `target: 0` — it simply does not play.)

Elevation is declared **once per surface** — a border (cards) or a shadow (the floating nav bar), never both. Every shadow comes from `AppElevation`, which is two layers (a tight near shadow plus a soft far one) in the palette's neutral `shadow` colour, and returns **an empty list in dark mode** — black on black separates nothing, so depth there is the border's job. A brand-coloured glow is decoration, not elevation; do not hand-roll a `BoxShadow`. Card radius stays 12–16. Entrance animation is one authored moment per screen: `AnimatedEntrance`/`StaggeredColumn` belong on lists whose order carries meaning, not on every static section.

### Charts follow the data's job

The form comes from what the data *is*, never from what looks rich:

| Data | Form | Why not the obvious choice |
| --- | --- | --- |
| Net salary — one headline | a number, no chart | eight coloured slices hide a story that is one figure |
| Salary composition — **signed** contributions | diverging bars around a zero line | a pie shows parts of a positive whole; the old code forced signed values in with `.abs()`, so a deduction rendered as a contribution |
| Spending by category | ranked horizontal bars | the eye reads length more accurately than angle, and Arabic category names do not fit inside phone-sized slices |

Direction is encoded by icon and sign as well as colour, values wear ink tokens (never the series colour), and the coloured swatch beside a label carries identity.

### Startup gates

`MaterialApp.builder` wraps every route in two gates, outermost first:

**They live in `home:`, never in `MaterialApp.builder`.** `builder` is composed *above* the Navigator, so a gate that renders its own screen instead of `child` drops the Navigator and its Overlay — every `Tooltip`, dialog, dropdown and time picker inside then dies with `No Overlay widget found`. Mounting them as the first route keeps them under the Navigator. (`routes` therefore has no `'/'` entry; `home` and `routes['/']` cannot both exist.)

1. `AppLockGate` — biometric lock, inert unless `appLockEnabled`.
2. `SetupGate` — watches `profileProvider` and shows `SetupFlowScreen` while it is null. Nothing else can render first: every figure in the app derives from the salary and the work schedule, and `checkIn` throws `'Profile not set'` without them. Because it watches the provider rather than a callback, saving a profile from anywhere opens the app. `test/presentation/setup_gate_test.dart` pins all three branches.

### Navigation & app shell

`HomeScreen` is the real shell: an `IndexedStack` of five tabs (budget, attendance, debts, accounts, profile) with `CustomBottomNav` and a large biometric FAB that drives check-in/check-out. The named routes in `lib/config/routes.dart` also map `/` to `HomeScreen`, so pushing `AppRoutes.home` re-enters the shell rather than popping to it. `onGenerateRoute` always returns null.

`ReminderController.runStartupCycle()` fires once from `HomeScreen.initState` via a post-frame callback. It requests notification permissions, has `ReminderScheduler` rebuild every scheduled reminder from the profile's `workSchedule` and the debt list, then runs `SmartInsightsService` for the rules that can only be evaluated live (forgotten check-out, budget overrun, spending pace, month-end forecast). Scheduling is declarative: each cycle cancels the ID ranges in `NotificationIds.scheduledRanges` and rebuilds them, so a settings or schedule change needs no diffing. `ProfileController.saveProfile` triggers the same reschedule.

### Auth & notifications

- `BiometricAuthService` (`core/utils/biometric_auth.dart`) returns a typed `BiometricResult`, not a bool: `success` / `failed` / `unavailable` / `notEnrolled` / `lockedOut`.
- **`AttendanceAuthPolicy` owns the security decision**, not the controller. Its rule: **an enrolled fingerprint makes the fingerprint mandatory** — `biometricOnly`, with no device-PIN substitute and no way to switch it off in settings, because allowing a PIN there lets anyone who knows the code clock in as someone else. `allowDeviceCredential` and `requireBiometricForAttendance` only govern devices with no enrolled biometric. It is a pure function so the rule is unit-tested without a device (`test/domain/services/attendance_auth_policy_test.dart`); `AttendanceController._run` only executes what it returns. The per-session `isBiometricVerified` flag records which path was taken, so a record's provenance stays honest.
- `AppLockGate` wraps every route via `MaterialApp.builder` and re-locks after 30s in the background; it is inert unless `appLockEnabled` is on.
- `NotificationService` is a singleton initialized in `main()`; every `showNotification` also persists a `NotificationModel` row that backs `NotificationHistoryScreen`.

## Conventions & gotchas

- UI text, comments, and many identifiers are Arabic. Keep new user-facing strings Arabic; reuse `AppConstants` (currency `ر.ي`, `arabicDays`, biometric prompts) rather than hardcoding.
- `MaterialApp` now pins `locale: Locale('ar')` with the three `flutter_localizations` delegates, so the whole app renders RTL and Material's own pickers are Arabic. New UI must use `EdgeInsetsDirectional`/`AlignmentDirectional` — raw `left`/`right` will now visibly break.
- **Weekday convention.** `WorkDayConfig.dayOfWeek` stores Dart's `DateTime.weekday` (Monday=1 … Sunday=7) — that is what `ProfileScreen` writes and what `_resolveDayType` assumes (Friday=5, Thursday=4). Look a day's config up with `DateHelpers.scheduleDayOf(date)`, never `date.weekday % 7`: that expression maps Sunday to 0, which matches no stored config, so Sunday silently fell through to the 8-hour `orElse` default and corrupted its overtime/deficit.
  `AppConstants.arabicDays` is a separate, **display-only** ordering that starts with Saturday. Convert with `DateHelpers.arabicDayIndex(date)` / `arabicDayNameOfScheduleDay(dayOfWeek)` (`(weekday + 1) % 7`). The two numberings are not interchangeable; `test/core/utils/date_helpers_test.dart` pins both.
- The dead duplicates are gone: `lib/core/theme/app_theme.dart`, `lib/presentation/viewmodels/`, `auth_provider.dart`, `attendance_timeline.dart` and `live_salary_counter.dart` were deleted rather than left as decoys.
- **Three counts are zero under `lib/presentation`, and each is a rule the analyzer cannot enforce — grep before you finish:** `Widget _build…` helpers (rules 03/07 — extract a private widget class instead, so the element tree can reuse it), `dynamic` parameters standing in for a real entity (they silently disable every type check), and hardcoded `Colors.*` (they do not adapt to dark mode).
- Loading and error states go through `StateSwitcher` / `Skeleton` (`widgets/common/state_switcher.dart`). A bare `CircularProgressIndicator` collapses to nothing when data lands, so the page jumps under the reader's thumb; the skeleton reserves the same box.
- `freezed` / `json_serializable` were removed — nothing used them, and `freezed`'s `build ^2.x` constraint blocked upgrading the Isar generator. Entities are hand-written.
- **`share_plus` is pinned to `^10.1.4` on purpose.** Version 13 pulls `win32 6.4.0`, whose Dart 3.11 syntax the `analyzer 7.6.0` that `isar_community_generator` forces cannot parse — `build_runner` then dies with `Missing implementation of visitDotShorthandInvocation`. Do not bump it until the generator chain allows a newer analyzer.
- iOS/macOS `Podfile`s and the Flutter xcconfigs are locally modified/untracked — check `git status` before assuming platform config is clean.

### iOS specifics

- **`NSFaceIDUsageDescription` is load-bearing, not cosmetic.** `local_auth` calling Face ID without it does not fail — iOS kills the process with `SIGABRT`. Since biometric check-in is the app's core action, removing that key breaks the app on every Face ID device. `CFBundleLocalizations` lists `ar` first so iOS treats Arabic as a supported language.
- Flutter raises `IPHONEOS_DEPLOYMENT_TARGET` to 13.0 on first build (the plugin set requires it) and performs the UIScene migration; both are committed, so a clean checkout builds without repeating them.
- `Share.shareXFiles` is always called with `sharePositionOrigin` (computed from the sheet's `RenderBox`). On iPhone it is ignored; on iPad the share sheet is a popover that needs an anchor rect, and without one it appears detached or is refused.

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
