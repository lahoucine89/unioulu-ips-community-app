# E2E / integration test

## What

`app_test.dart` runs `lib/main.dart` on a device, settles, asserts a `MaterialApp` exists (boot smoke test only).

## CI

[`.github/workflows/ci-workflow.yml`](../.github/workflows/ci-workflow.yml): `flutter test integration_test/app_test.dart -d macos`.  
CI writes placeholder `appwrite/.env` (asset in `pubspec.yaml`, not in git).

## Local

Not on web (`-d chrome` unsupported). Example:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test integration_test/app_test.dart -d macos
```

Android: `flutter test integration_test/app_test.dart -d <device_id>` (`flutter devices`).  
Requires local `appwrite/.env`: [SETUP.md](../SETUP.md).

## Other tests

Unit/widget: `test/`, run with `flutter test`.
