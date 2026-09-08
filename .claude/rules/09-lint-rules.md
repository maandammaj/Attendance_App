# Lint Rules

The single source of truth is `analysis_options.yaml` at the repo root. Do **not** duplicate its contents into other files; if a rule needs to change, edit `analysis_options.yaml`.

## Key facts about the current setup
* Base: `include: package:flutter_lints/flutter.yaml`.
* Plugin: `custom_lint` is enabled — additional rules may come from custom_lint packages.
* Strictness: `strict-inference: true`, `strict-raw-types: true`, `strict-casts: false`.
* Excluded from analysis: `build/**`, `**/*.g.dart`, `**/*.freezed.dart`, `**/*.pb.dart`, `lib/generated/**`, `lib/l10n/*.arb`.

## Enforced rules to remember while coding
* `avoid_print` → use `developer.log` (see `12-logging.md`).
* `prefer_single_quotes`, `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations`, `prefer_final_fields`.
* `always_use_package_imports` — no relative cross-folder imports.
* `sort_pub_dependencies`, `sort_constructors_first`, `sort_child_properties_last`, `directives_ordering`.
* `unawaited_futures`, `cancel_subscriptions`, `close_sinks`, `await_only_futures`.
* `use_enums`, `avoid_unused_constructor_parameters`, `unnecessary_lambdas`, `avoid_redundant_argument_values`.

## Suppressed / relaxed (do not fight these)
* `lines_longer_than_80_chars` → ignored — do not reflow existing code to 80 cols.
* `camel_case_types`, `non_constant_identifier_names`, `unrelated_type_equality_checks`, `deprecated_member_use` → ignored (legacy noise). Still write new code cleanly.
* `unused_import` → info, not error — but clean it up in files you touch.

## Running the analyzer
```bash
fvm flutter analyze
```
