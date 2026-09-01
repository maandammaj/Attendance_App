# Assumptions & Change Scope

Derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876)
on how LLMs fail at coding: wrong assumptions carried silently, overcomplication, and edits that
wander outside the task. Those failure modes are real in this repo — a mid-migration codebase where
most of what looks wrong is deliberate.

Three of his four principles already have owners here, so this file does not restate them:

| Principle | Owned by |
| --- | --- |
| Simplicity First | rule `01` (no defensive code), rule `05` § Function size, CLAUDE.md § File size, § Reusability |
| Surgical Changes — "don't refactor what isn't broken" | CLAUDE.md § Working agreement |
| Goal-Driven Execution — tests | rule `14`, CLAUDE.md § Definition of done |

What follows is the part none of them state.

## Surface the assumption — do not stop for it

* **State it in one line, then proceed.** Rule `01` is the authority on ambiguity: name the
  *specific* ambiguity and propose a sensible default. A list of questions with nothing delivered
  is the failure mode, not the fix.
* **Never pick an interpretation silently.** If two readings lead to materially different work,
  say which one you took and why, in the same message as the work.
* **Blocking is correct only when proceeding either way is unsafe or would waste the work.** In
  this repo that is a short list: a money-path defect (CLAUDE.md § Root-cause debugging — escalate,
  do not fix), a destructive Git operation (§ Git safety), a new dependency (rule `04`), a one-off
  colour that fits neither theme (rule `15`), a new top-level folder under `docs/` (rule `16`).

## Push back, and name the tradeoff

* **If a simpler approach exists, say so before building the complicated one.** Not afterwards in
  the summary.
* **If the request implies something the rules forbid** — `go_router`, a `ValueNotifier` holding
  feature state, a `StateListener`, migrating a feature inside a bug fix — name the rule and offer
  the compliant alternative. Do not silently build the forbidden version, and do not silently
  substitute a different feature than the one asked for.
* **Confusion is a signal to keep reading, not to guess.** CLAUDE.md § Working agreement already
  says it: if you cannot explain why the existing code was written that way, you do not yet know
  enough to replace it.
* **Never present a partial result as a whole one.** Say which of the four verification levels you
  reached (CLAUDE.md § Four levels), and say plainly what you left out and why.

## Every changed line traces to the request

* **Match the surrounding style — except where these rules forbid it.** Most of `lib/` is legacy
  God-class screens, so the local style is frequently the banned pattern. Code you write follows
  the rule even when its neighbours do not: no `Widget _buildX()` helper (rules `03`, `07`), no
  `ValueNotifier`/`ChangeNotifier` holding rendered state and no new `StateListener` (rules `10`,
  `21`), no raw `left`/`right` (rule `17`), no inline `Color(0xFF…)` or `TextStyle(…)` (rule `15`),
  no `print` (rule `12`).
* **Report unrelated problems; do not fix them.** Dead code, a duplicated block, an unmigrated
  screen — name it in the summary and leave it. Unifying two legacy copies inside an unrelated task
  is scope creep (CLAUDE.md § Reusability), and a bug fix is not a migration opportunity
  (§ Working agreement).
* **Clean up the orphans your own change created** — imports, locals, private widgets, and the
  `ar.json` / `en.json` keys a removed string leaves behind. `unused_import` is info-level
  (rule `09`), so the analyzer will not force this.

## State the verification before doing the work

* **Multi-step work gets a brief plan, each step carrying its own check** — the check is what makes
  the step finishable without asking.
* **A check names a verification level** (CLAUDE.md § Four levels). "Make it work" is not a
  criterion. `flutter analyze lib test` clean, `flutter test test/features/<feature>` green, and an
  RTL + dark screenshot from the emulator is.
* If a check cannot be run — no device, no MCP session — say so and label the change unverified
  rather than quietly dropping to source-code analysis.
