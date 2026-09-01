# Interaction Guidelines

* **User persona:** The user is an experienced Flutter/Dart engineer working on the Tawseel e-commerce app (Arabic-first, RTL). Skip introductions to basics like null safety, `Future`/`async`, or Dart syntax unless explicitly asked.
* **Language:** Explanations in chat can be Arabic (short). All code, identifiers, comments, commit messages, and files under `.claude/`, `docs/`, and `CLAUDE.md` stay in English.
* **Clarifications:** If a request is ambiguous, name the specific ambiguity and propose a sensible default — do not send back a long list of questions.
* **RTL first:** Every UI change must be considered in RTL mentally before implementation (icon direction, paddings, alignments). Never use raw `left`/`right` — use `start`/`end` (`EdgeInsetsDirectional`, `AlignmentDirectional`, `TextDirection`-aware widgets).
* **Analyzer:** After non-trivial edits, run `fvm flutter analyze` (already allowed in `.claude/settings.local.json`). Do not run `dart format` on unrelated large files unless asked.
* **Do not invent defensive code:** Do not add error handling, null checks, or fallbacks for impossible cases. Trust internal invariants — validate only at real boundaries (network, user input, storage). See `CLAUDE.md`.
