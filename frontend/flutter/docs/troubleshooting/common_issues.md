# Troubleshooting Guide - Smart Nutrition Restaurant Flutter App

## Quick Fixes

### Run Clean Rebuild
```bash
./scripts/clean-rebuild.sh
```

## Common Issues and Solutions

### 1. Assets Directory Error
**Error**: `Error: unable to find directory entry in pubspec.yaml: lib/modules/`

**Solution**:
- Fixed in pubspec.yaml - removed invalid asset path
- Only physical asset directories should be listed under `assets:`

### 2. Java Compilation Warnings
**Error**: `源值 8 已过时，将在未来发行版中删除`

**Root Cause**: Some dependencies still use Java 8 while project uses Java 17

**Solution Applied**:
1. Updated `android/app/build.gradle.kts`:
   ```kotlin
   compileOptions {
       sourceCompatibility = JavaVersion.VERSION_17
       targetCompatibility = JavaVersion.VERSION_17
   }
   ```

2. Added to `android/gradle.properties`:
   ```properties
   android.suppressUnsupportedCompileSdk=35
   android.experimental.java.compilerArgs=-Xlint:-options
   ```

3. Added compiler args in build.gradle.kts:
   ```kotlin
   tasks.withType<JavaCompile>().configureEach {
       options.compilerArgs.add("-Xlint:-options")
   }
   ```

### 3. Firebase Configuration Missing
**Error**: `Missing google_app_id. Firebase Analytics disabled`

**Solution**:
- Created dummy `android/app/google-services.json`
- For production: Replace with real Firebase configuration
- To disable Firebase temporarily, remove Firebase dependencies from pubspec.yaml

### 4. Resource ID Not Found
**Error**: `No package ID 71 found for resource ID 0x710b000f`

**Common Causes**:
- Resource conflicts between libraries
- Outdated build cache
- Package name mismatches

**Solutions**:
1. Clean build: `./scripts/clean-rebuild.sh`
2. Update dependencies: `flutter pub upgrade`
3. Check for duplicate resources in android/app/src/main/res/

### 5. Gradle Build Failures

**If Gradle sync fails**:
```bash
cd android
./gradlew --stop
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**If out of memory**:
Increase heap size in `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G
```

### 6. Emulator Performance Issues

**Symptoms**: 
- `Skipped 42 frames! The application may be doing too much work on its main thread`
- Slow app startup

**Solutions**:
1. Enable hardware acceleration in emulator
2. Increase emulator RAM
3. Use physical device for testing
4. Disable animations during development:
   ```dart
   // In main.dart
   if (kDebugMode) {
     debugDisableAnimations = true;
   }
   ```

## Platform-Specific Issues

### macOS Development

**JDK Path Issues**:
```bash
# Check Java version
java -version

# Set JAVA_HOME
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home

# Add to ~/.zshrc or ~/.bashrc
```

### Windows Development

**Long Path Issues**:
Enable long paths in Windows:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```

### Linux Development

**Android SDK Permissions**:
```bash
sudo chown -R $USER:$USER ~/Android/Sdk
chmod -R 755 ~/Android/Sdk
```

## Dependency Issues

### Version Conflicts
```bash
# Check for dependency conflicts
flutter pub deps

# Force resolve
flutter pub upgrade --major-versions
```

### Package Not Found
```bash
# Clear pub cache
flutter pub cache clean
flutter pub get
```

## Build Issues

### Debug Build
```bash
flutter build apk --debug --verbose
```

### Release Build
```bash
flutter build apk --release --verbose
```

### Build Fails with ProGuard
Add to `android/app/proguard-rules.pro`:
```
-keep class com.example.** { *; }
-keep class io.flutter.** { *; }
```

## IDE Issues

### Android Studio
1. File → Invalidate Caches → Invalidate and Restart
2. File → Sync Project with Gradle Files
3. Build → Clean Project

### VS Code
1. Ctrl+Shift+P → Flutter: Clean
2. Ctrl+Shift+P → Developer: Reload Window
3. Delete .dart_tool folder

## Performance Optimization

### Reduce APK Size
```bash
flutter build apk --split-per-abi
```

### Enable R8 (ProGuard successor)
In `android/app/build.gradle.kts`:
```kotlin
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

## Logging and Debugging

### Enable Verbose Logging
```bash
flutter run --verbose
```

### Android Logs
```bash
adb logcat | grep flutter
```

### Performance Profiling
```bash
flutter run --profile
```

## Emergency Fixes

### Complete Reset
```bash
# WARNING: This will delete all build artifacts
rm -rf ~/.gradle/caches/
rm -rf ~/.pub-cache/
rm -rf android/.gradle/
rm -rf build/
rm -rf .dart_tool/
flutter clean
flutter pub cache clean
flutter pub get
```

### Downgrade Flutter (if needed)
```bash
flutter downgrade
flutter doctor
```

## Authentication Issues

### Login Response Parsing Error
**Error**: `type 'Null' is not a subtype of type 'bool' in type cast`

**Cause**: Backend response missing required fields or using different field names

**Solution**:
1. Updated `UserModel` with proper JSON mapping:
   ```dart
   @JsonKey(name: '_id', defaultValue: '')
   final String id;
   @JsonKey(name: 'profileCompleted', defaultValue: false)
   final bool profileCompleted;
   @JsonKey(name: 'autoRegistered', defaultValue: false)
   final bool autoRegistered;
   ```

2. Regenerate JSON serialization:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### NDK Version Conflicts
**Error**: `NDK from ndk.dir had version [27.0.12077973] which disagrees with android.ndkVersion [25.1.8937393]`

**Solution**:
1. Force specific packages to use correct NDK version in `gradle.properties`:
   ```properties
   rive.ndk.version=27.0.12077973
   android.ndk.suppressMinSdkVersionError=21
   ```

2. Update all subprojects in `build.gradle.kts`:
   ```kotlin
   subprojects {
     project.pluginManager.withPlugin("com.android.library") {
       project.extensions.configure<com.android.build.gradle.LibraryExtension> {
         if (project.name != "rive_common") {
           ndkVersion = "27.0.12077973"
         }
       }
     }
   }
   ```

## Build Environment Issues

### Multiple Environment Builds
**Setup**: Configure Flutter Flavors for dev/staging/prod

**Build Commands**:
```bash
# Development
flutter build apk --debug --flavor dev -t lib/main_dev.dart

# Staging
flutter build apk --debug --flavor staging -t lib/main_staging.dart

# Production
flutter build apk --release --flavor prod -t lib/main_prod.dart

# Using build script
./scripts/build.sh -p android -f dev -t debug
```

### Widgetbook API Changes
**Error**: Various API compatibility issues with Widgetbook 3.x

**Solutions**:
1. Replace deprecated `knobs.number` with type-specific methods:
   ```dart
   // Old
   context.knobs.number(label: 'Size', initialValue: 4)
   
   // New
   context.knobs.int.slider(label: 'Size', initialValue: 4, min: 1, max: 10)
   ```

2. Remove unsupported integrations
3. Update device names for DeviceFrameAddon

## Testing Issues

### Golden Test Failures
**Error**: `'MaterialInkControllerState' isn't a type`

**Solution**: Remove complex state testing from golden tests, focus on visual regression

### Coverage Report Generation
**Commands**:
```bash
# Generate coverage
flutter test --coverage

# View coverage report
./scripts/test_coverage.sh

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

## Getting Help

1. Check Flutter doctor: `flutter doctor -v`
2. Search issues: https://github.com/flutter/flutter/issues
3. Flutter Community: https://flutter.dev/community
4. Project-specific: Check `/docs` folder

---

**Last Updated**: 2025-05-27
**Version**: 1.1.0