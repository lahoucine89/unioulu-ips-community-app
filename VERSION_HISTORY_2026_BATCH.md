# Version History Update (2026 Batch)


Maintained by: **2026 batch**

## Scope

- Captures dependency/tool/image version changes visible in the current working tree.
- Intended for team visibility so duplicate upgrade work is avoided.

## Android / Build Tooling

| File | Key | Original | Current |
|---|---|---:|---:|
| `android/settings.gradle.kts` | Android Gradle Plugin (`com.android.application`) | `8.7.0` | `8.9.1` |
| `android/gradle/wrapper/gradle-wrapper.properties` | Gradle wrapper | `8.10.2` | `8.11.1` |

## Flutter / Dart Dependencies (`pubspec.yaml`)

| Dependency | Original | Current |
|---|---:|---:|
| `appwrite` | `^20.0.0` | `^23.0.0` |
| `bloc` | `^9.0.0` | `^9.2.0` |
| `cupertino_icons` | `^1.0.6` | `^1.0.9` |
| `equatable` | `^2.0.5` | `^2.0.8` |
| `flutter_svg` | `^2.0.10+1` | `^2.2.4` |
| `fpdart` | `^1.1.0` | `^1.2.0` |
| `http` | `^1.2.1` | `^1.6.0` |
| `share_plus` | `^12.0.0` | `^12.0.2` |
| `emoji_picker_flutter` | `^4.3.0` | `^4.4.0` |
| `build_runner` | `^2.4.13` | `>=2.4.13 <2.5.0` |
| `mockito` | `^5.4.4` | `>=5.4.4 <5.4.5` |

## Python Dependency

| File | Package | Original | Current |
|---|---|---:|---:|
| `requirements.txt` | `appwrite` | `1.2.0` | `17.0.0` |

## Appwrite Docker Images (`appwrite/docker-compose.yml`)

| Image | Original | Current |
|---|---:|---:|
| `appwrite/appwrite` | `1.7.4` | `1.9.0` |
| `appwrite/console` | `6.0.13` | `7.8.40` |
| `appwrite/assistant` | `0.4.0` | `0.8.4` |
| `appwrite/browser` | `0.2.4` | `0.3.2` |
| `openruntimes/executor` | `0.7.14` | `0.7.23` |

### Note on `appwrite/appwrite`

The `appwrite/appwrite` image upgrade (`1.7.4` -> `1.9.0`) appears across multiple services in `docker-compose.yml` (main app, realtime, workers, maintenance/stat tasks, and scheduler tasks).

## Verification Notes (2026 Batch)

- `flutter test`: all tests passed after alignment updates.
- `flutter build apk --debug`: successful.
- `flutter run -d emulator-5554`: successful launch confirmed.

---

If you add more upgrades, append new rows with date and author so this file remains the single source of truth for version history in this repository.
