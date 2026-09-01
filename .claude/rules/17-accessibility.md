# Accessibility (A11Y)

## RTL & localization (project baseline)
* The app is Arabic-first. Every new UI is verified visually in RTL before it is called done.
* Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, and directional icons (`Icons.arrow_back_ios` variants that flip via `Directionality`). Never hard-code `left`/`right`.
* All user-facing strings go through the project's localization layer — never hard-code Arabic or English strings inline, and never leave a `static const` literal in a Dart file.
  * Copy lives in **both** `lib/config/locales/ar.json` and `lib/config/locales/en.json`, namespaced per feature (`account.title`, `account.menu.my_orders`, `account.failure.*`). Adding a key to only one file is a bug.
  * Widgets never spell out a key. Each feature owns one typed accessor, `lib/features/<feature>/presentation/<feature>_strings.dart`, which is the only place the keys appear — see `lib/features/account_mangmant/presentation/account_strings.dart`.
  * Resolve context-free via `LangConfig.instance.data[key]` inside that accessor, so blocs, bottom sheets, and builders without a `BuildContext` share one lookup. Do **not** call `LangConfig.of(context)?.data[...]` from a widget — that legacy pattern is what scattered the keys.
* Numbers, currencies, and dates use the project's Arabic-aware formatters (see `lib/core/utils/english_number_formatter.dart` and related helpers) — do not use `toString()` on raw doubles for money.

## Contrast & sizing
* Meet WCAG 2.1 contrast: 4.5:1 for body text, 3:1 for large text and icons. Verify in both dark and light themes.
* Support system font scaling — never disable `textScaleFactor` and never assume a fixed line height in `pixels`. Test at the OS's largest font size.
* Respect safe areas (notches, gesture bars) with `SafeArea` on top-level screen scaffolds.

## Semantics & interaction
* Wrap non-obvious visual elements (icon-only buttons, custom charts) in `Semantics` with an Arabic-friendly `label:` so TalkBack / VoiceOver announce them.
* Every tappable element must have a minimum 48×48 dp hit target.
* Give async actions immediate visual feedback (button spinner, snackbar) — see `CLAUDE.md` § UX.
