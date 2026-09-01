---
name: karpathy-guidelines
description: ADAPT FOR THIS PROJECT — rule 22 already encodes these four principles with project-specific owners, and overrides two of them (surface-and-proceed instead of stopping; project rules beat surrounding legacy style). Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
license: MIT
source: https://github.com/multica-ai/andrej-karpathy-skills
---

> ## ⚠️ Project override — ADAPT
>
> **Governing rule: `.claude/rules/22-assumptions-and-change-scope.md`**, which is derived from the
> same Karpathy thread and already assigns each principle an owner in this repo. Read it first; the
> generic text below is the upstream original, kept for reference.
>
> | Principle below | Owned here by |
> | --- | --- |
> | 1. Think Before Coding | rule `22` § Surface the assumption, rule `01` § Clarifications |
> | 2. Simplicity First | rule `01` (no defensive code), rule `05` § Function size, CLAUDE.md § File size, § Reusability |
> | 3. Surgical Changes | CLAUDE.md § Working agreement, rule `22` § Every changed line traces to the request |
> | 4. Goal-Driven Execution | rule `14`, CLAUDE.md § Four levels of verification, § Definition of done |
>
> **Two divergences that matter — the project rule wins:**
>
> 1. **Do not stop to ask.** §1 below says *"If something is unclear, stop. Name what's confusing.
>    Ask."* This project says the opposite: name the *specific* ambiguity, propose a sensible
>    default, and **proceed** (rule `01` § Clarifications, rule `22` § Surface the assumption — do
>    not stop for it). Blocking is correct only for the short list rule `22` enumerates — a
>    money-path defect, a destructive Git operation, a new dependency, a one-off colour, a new
>    top-level `docs/` folder.
> 2. **Matching existing style is conditional.** §3 below says *"Match existing style, even if
>    you'd do it differently."* Here, most of `lib/` is legacy God-class screens, so the surrounding
>    style is frequently the banned pattern. Code you write follows the rule even when its
>    neighbours do not: no `Widget _buildX()` helper (rules `03`, `07`), no `ValueNotifier` holding
>    rendered state and no new `StateListener` (rules `10`, `21`), no raw `left`/`right` (rule
>    `17`), no inline `Color(0xFF…)` or `TextStyle(…)` (rule `15`), no `print` (rule `12`).
>
> **Also project-specific:** §4's "verify" step must name one of the four verification levels in
> CLAUDE.md — `flutter analyze lib test` clean, `flutter test test/features/<feature>` green, an RTL
> + dark screenshot. "Make it work" is not a criterion. Tests are `flutter_test` with hand-written
> fakes (rule `14`) — never `mockito`, `mocktail`, `package:checks` or `integration_test`.

# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
