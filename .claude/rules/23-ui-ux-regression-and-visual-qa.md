# UI/UX Regression And Visual QA

This rule applies whenever a refactor, migration, bug fix, or widget extraction
touches a visible Flutter screen or user interaction. Passing the analyzer and
tests is not enough for UI work: the refactored app must preserve the intended
look, feel, and behavior of the shipped app unless a product decision explicitly
changes it.

## Primary Objective

For any affected screen or widget, verify both technical behavior and visual
behavior:

* UI/UX consistency
* visual hierarchy
* typography, including font size, weight, line height, and overflow
* spacing, padding, alignment, and SafeArea behavior
* RTL correctness in Arabic
* color and theme consistency
* widget states and interaction behavior
* loading, empty, error, disabled, selected, focused, and pressed states
* responsive layout and keyboard behavior
* visual regressions introduced by refactoring

When possible, compare against the pre-refactor implementation at:

```text
/Users/tawseeldev/AndroidStudioProjetcs/Dart3TawseelApps/ecommerce/lib
```

Do not assume a visual difference is intentional. Treat unexpected differences
as possible regressions until legacy behavior, product direction, or an ADR says
otherwise.

## Regression Detection

Whenever a screen, widget, or flow was affected:

1. Inspect the current implementation.
2. Inspect the old implementation or earlier screenshots when available.
3. Compare widget structure, order, layout, copy, typography, colors, icons, and
   interaction behavior.
4. Identify missing widgets, changed hierarchy, changed constraints, clipping,
   overflow, and changed loading/empty/error states.
5. Preserve the old UX unless the change is deliberate and documented.

Pay attention to subtle regressions:

* elements moving a few pixels
* cards becoming taller or shorter
* buttons changing height or touch target
* text baseline misalignment
* changed margin, padding, radius, shadow, border, or elevation
* icons moving to the wrong side in RTL
* text truncating differently
* spinners or dialogs appearing/disappearing at the wrong time
* keyboard and SafeArea behavior changing after extraction

## Typography

Typography is part of behavior in this app. Inspect and preserve:

* font family
* font size
* font weight
* font style
* line height
* letter spacing
* text color
* text alignment
* max lines and overflow behavior

Do not introduce arbitrary `TextStyle` values. Prefer
`Theme.of(context).textTheme` and existing typography helpers. If the old screen
used a one-off style, compare before replacing it with a theme style; changing a
font size during a refactor is a UI change, not a cleanup.

Arabic text must be checked visually. Ensure the font supports Arabic glyphs,
the weight reads correctly, line height is comfortable, and Arabic text is not
smaller than the surrounding English equivalent.

## RTL

Arabic is the primary locale. Every changed screen must be checked in RTL before
it is called done.

Use direction-aware APIs:

* `EdgeInsetsDirectional`
* `AlignmentDirectional`
* `BorderRadiusDirectional`
* `PositionedDirectional`
* directional icons that flip with `Directionality`

Do not hard-code `left` or `right` for layout unless the design is truly
physical rather than directional. Verify text direction, row direction, icon
placement, navigation/back placement, horizontal scrolling, `PageView`
direction, sliders, progress indicators, and animated transitions.

Rule `17-accessibility.md` owns the broader accessibility and localization
requirements; this rule makes visual RTL regression checks mandatory for UI
refactors.

## Colors And Theme

All colors must follow the app design system. Prefer
`Theme.of(context).colorScheme`, text theme colors, and existing semantic color helpers. Do not
add random hex colors or visually similar replacements.

Verify:

* primary, secondary, background, and surface colors
* text, icon, border, disabled, error, success, and warning colors
* contrast in dark and light mode
* inherited theme behavior after widget extraction
* Material version or theme-extension changes

Rule `15-visual-design-and-theming.md` owns the concrete theme access rules.
This rule adds the regression requirement: a refactor must not silently change
the color contract.

## Widget Quality

Every changed widget must be evaluated for its rendered quality:

* size and constraints
* padding and alignment
* radius, background, elevation, shadow, and borders
* icon size
* minimum 48x48 dp touch targets
* animation and state transitions
* default, pressed, disabled, loading, error, empty, selected, and focused states

Reusable widgets must preserve the original screen's visual output. Do not
over-generalize a widget if the abstraction forces one caller to look or behave
wrong. Parameterize real differences; if two callers need different behavior,
keep that difference explicit.

## Spacing And Layout

Maintain the screen's visual rhythm. Compare:

* screen padding
* section spacing
* card spacing
* internal widget padding
* horizontal alignment
* vertical rhythm
* responsive constraints

Avoid arbitrary new spacing values. Prefer existing constants, theme spacing, or
local values already used by the screen. Common scale values are `4`, `8`, `12`,
`16`, `20`, `24`, and `32`, but matching the existing surface is more important
than forcing a new scale.

## Runtime QA

For important UI changes, use runtime evidence whenever possible. The real
device rendering is the source of truth for visual work.

Preferred loop:

1. Run the app on Android from `apps/tawseel`.
2. Navigate to the affected screen.
3. Inspect the actual rendered UI with Flutter MCP, screenshots, or emulator
   capture.
4. Exercise the changed interaction.
5. Check logs and runtime errors.
6. Check for overflow, clipping, stuck dialogs, wrong navigation, and bad
   loading states.
7. Compare against the old implementation or old screenshot when available.
8. Re-run the same checks after the fix.

Use the Flutter/Dart MCP instructions in `CLAUDE.md` when the MCP server is
connected. If it is not connected, use the documented `flutter run`, `adb
logcat`, and `adb exec-out screencap` fallback. Do not rely on source reading
alone for visual claims.

If runtime QA is impossible, report that explicitly and label the work at the
highest verification level actually reached.

## Reporting Format

When reporting UI QA, include enough structure that the next person can tell
what was actually checked:

```text
Screen: <name>
Visual status: PASS / WARNING / FAIL
Differences from old version:
- ...
UI/UX issues:
- ...
RTL issues:
- ...
Typography issues:
- ...
Color/theme issues:
- ...
Runtime QA:
- Device inspection: PASS / FAIL / NOT RUN
- Navigation: PASS / FAIL / NOT RUN
- RTL: PASS / FAIL / NOT RUN
- Overflow: PASS / FAIL / NOT RUN
- Interaction: PASS / FAIL / NOT RUN
Required fixes:
1. ...
2. ...
```

For small tasks, a shorter summary is fine, but it must still state the
verification level and any visual/runtime checks that were not performed.

## Completion Rule

Never treat a UI refactor as complete only because the code compiles, tests pass,
or the business flow works. If UI/UX changed unexpectedly, the task is not done.
If the change is intentional, document it in the feature changelog or ADR.
