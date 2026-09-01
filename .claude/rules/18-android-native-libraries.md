# Android Native Libraries & 16 KB Page Size

Google Play grades every 64-bit `.so` an app ships — including ones that arrive prebuilt
inside a third-party AAR — against its 16 KB memory-page checks. A dependency bump can
therefore introduce a release warning without any change to this repo's own code, and no
setting in `app/build.gradle` can repair a binary someone else compiled.

## What actually fails

* **`LOAD` segment alignment.** Every `PT_LOAD` in an `arm64-v8a` or `x86_64` library must
  declare `p_align >= 0x4000`. This is the criterion Google's own `check_elf_alignment.sh`
  applies; below it the dynamic loader cannot map the library on a 16 KB-page device.
* **Segment geometry.** A library can be correctly aligned and still be rejected if its
  `PT_GNU_RELRO` does not sit correctly inside the RW `PT_LOAD` segment it belongs to.
  This is what happened to `androidx.datastore` 1.2.0 (see below).

32-bit ABIs are never graded — 16 KB pages exist only on 64-bit devices.

**`ndkVersion` is not part of this.** It governs only native code this project compiles.
Play's warning text recommends NDK r28 generically, but the NDK release recorded in a
library's `.note.android.ident` is not the trigger: this app ships `libsqlcipher.so` (r25c),
`libsentry.so` (r27) and `libc++_shared.so` (r27-beta1) and Play accepts all of them.
Google's own documentation treats "old NDK plus the right linker flags" as fully equivalent
to r28+, so do not chase the NDK version when diagnosing a flagged library.

## Verify before uploading, never after

```bash
docs/scripts/check_16kb_compat.sh apps/tawseel/build/app/outputs/bundle/release/app-release.aab
```

Run it against the artifact that will actually be uploaded — the merged AAB, not the
individual AARs — because packaging is what decides which libraries ship. The script grades
`LOAD` alignment, reports RELRO geometry and the recorded NDK for diagnosis, and fails the
build on a known-defective `androidx.datastore`.

## The `androidx.datastore` 1.2.0 defect

`androidx.datastore` ships `libdatastore_shared_counter.so` prebuilt. In **1.2.0** its
`PT_GNU_RELRO` runs past the end of the RW `LOAD` segment (`0xd000` vs `0xc250` on
arm64-v8a) because Kotlin/Native's bundled linker was too old to honour
`-z common-page-size`. Google tracked this as
[b/476745201](https://issuetracker.google.com/issues/476745201) and fixed it in **1.2.1**;
Flutter independently reverted `shared_preferences_android` to DataStore **1.1.7** for the
same reason ([flutter/packages#11128](https://github.com/flutter/packages/pull/11128)) and
is holding there until 1.3.0.

Only 1.2.0 is defective. 1.1.7 and 1.2.1 are both fine. The pin lives in
[apps/tawseel/android/build.gradle](../../apps/tawseel/android/build.gradle) and must cover
every `androidx.datastore` artifact, including the `-android` and `-core` variants, so no
transitive path can reintroduce 1.2.0.

**Do not exclude the library from packaging.** It looks unused — `System.loadLibrary` is
reached only through `MultiProcessCoordinator` — but `firebase-sessions` creates its store
with `MultiProcessDataStoreFactory`, so the library is loaded on every cold start. Excluding
it does not crash the app, because Firebase swallows the resulting `UnsatisfiedLinkError`,
which is exactly what makes it dangerous: the only symptom is
`dlopen failed: library "libdatastore_shared_counter.so" not found` in logcat while session
state silently stops persisting.

## Diagnosing a newly flagged library

1. Identify the dependency that owns it, and which version introduced the regression.
2. Compare the ELF program headers across versions — `llvm-readelf -lW` from the newest
   installed NDK — rather than trusting release notes, which routinely omit these fixes.
   DataStore's 1.2.1 note describes the fix only as "minor infrastructure bug fixes".
3. Prefer pinning to a good version over dropping the library. Dropping it is safe only
   after proving nothing reaches its `System.loadLibrary` call — including inside Firebase
   and Play Services, not just this repo's code.
4. Confirm on a device that the feature still works, and check logcat for `dlopen failed`.

## Scope changes to the app that was tested

The brands under `apps/` each own their Android module and release separately. Apply a
dependency pin or packaging change to the app it was verified against, and do not fan it out
until each brand has been built and checked on its own — their plugin sets differ, and a
library that is inert in one may be live in another.
