# End-to-end (integration) test

## What it does

`app_test.dart` runs the real app entrypoint (`lib/main.dart` on device), waits for the first screen to settle, and checks that a `MaterialApp` is present. It is a smoke test that the app boots; it does not walk through full user flows or assert backend behaviour.

## How it runs in CI

[GitHub Actions](../.github/workflows/ci-workflow.yml) runs this file on **macOS** so the full app can execute without an Android emulator:

`flutter test integration_test/app_test.dart -d macos`

The workflow creates a minimal `appwrite/.env` in the job because that path is gitignored locally but required by the app and listed in `pubspec.yaml` assets.

## How to run locally

You need a device Flutter can drive (not Chrome; `integration_test` does not support web):

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test integration_test/app_test.dart -d macos
```

Or, with an Android emulator running:

```bash
flutter test integration_test/app_test.dart -d <device_id>
```

Use `flutter devices` to list ids. Locally you still need `appwrite/.env` per [SETUP.md](../SETUP.md).

## Related

Unit and widget tests live under `test/` and run with `flutter test` (no desktop or emulator required for those).
