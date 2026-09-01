# Documentation

## Code-level docs
* `///` doc comments on public APIs.
* First line is a single-sentence summary ending with a period, followed by a blank line before further detail.
* Explain *why* the code exists, not *what* it does — well-named identifiers already say what.
* Do not restate the class or property name in its doc.
* Skip trailing / obvious inline comments — see `CLAUDE.md`.

## Project-level docs
* All non-code docs live under `docs/` — see `CLAUDE.md` § "Documentation paths" for the allowed roots (`docs/features/`, `docs/adr/`, `docs/api/`, `docs/architecture/`, `docs/database/`, etc.).
* **Do not invent new top-level folders under `docs/`.**
* When adding or changing a feature: create / update a file under `docs/features/<feature_name>.md` and link it from the PR description.
* When making an architectural decision: add an ADR in `docs/adr/` using the template in `docs/templates/`.
* When changing DB schema: update `docs/database/`.
* If a change is non-trivial and no matching doc exists, **ask** whether to create one — do not silently skip.

## PR & task summaries
* Link the exact doc path (e.g. `docs/features/orders.md`) so reviewers know where the context lives.
