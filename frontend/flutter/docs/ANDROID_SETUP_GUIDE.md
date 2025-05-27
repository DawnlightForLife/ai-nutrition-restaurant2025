# Android Setup Guide for Smart Nutrition Restaurant

## Overview
This guide documents the Android configuration setup and solutions for common build issues.

## Fixed Issues

### 1. Assets Directory Error
**Problem**: `Error: unable to find directory entry in pubspec.yaml: lib/modules/`
**Solution**: Removed invalid asset path from pubspec.yaml. Only actual asset directories should be listed.

### 2. Java Compilation Warnings
**Problem**: Java source/target value 8 is obsolete
**Solution**: 
- Updated compileOptions to use Java 17
- Added compiler flags to suppress warnings
- Updated gradle.properties with proper configurations

### 3. Firebase Configuration
**Problem**: Missing google_app_id, Firebase Analytics disabled
**Solution**: 
- Added google-services.json with dummy configuration
- Added Google Services plugin to build.gradle.kts
- For production, replace with actual Firebase project configuration

### 4. Resource ID Not Found
**Problem**: `No package ID 71 found for resource ID 0x710b000f`
**Solution**: This is typically a transient issue that resolves after clean rebuild

## Project Configuration

### Package Name
Current: `com.example.my_flutter_app`
Recommended: `com.smartnutrition.restaurant`

### Build Configuration
```kotlin
android {
    compileSdk = 35
    minSdk = 21
    targetSdk = 34
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
```

### Firebase Setup
1. **Development**: Current setup uses dummy configuration
2. **Production**: 
   - Create Firebase project at https://console.firebase.google.com
   - Download google-services.json
   - Replace the dummy file in android/app/

### Clean Build Steps
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

## Common Issues and Solutions

### Issue: Gradle Sync Failed
```bash
# Clear gradle cache
rm -rf ~/.gradle/caches/
./gradlew --stop
flutter clean
```

### Issue: Resource Conflicts
```bash
# Clean build directories
rm -rf android/app/build
rm -rf build/
flutter clean
```

### Issue: Plugin Version Conflicts
Check versions in:
- `android/settings.gradle.kts`
- `android/app/build.gradle.kts`
- `pubspec.yaml`

## Recommended Actions

### 1. Update Package Name
```kotlin
// In android/app/build.gradle.kts
android {
    namespace = "com.smartnutrition.restaurant"
    defaultConfig {
        applicationId = "com.smartnutrition.restaurant"
    }
}
```

### 2. Update App Name
```xml
<!-- In AndroidManifest.xml -->
<application
    android:label="Smart Nutrition"
    ...>
```

### 3. Configure Signing for Release
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=<key-alias>
storeFile=<path-to-keystore>
```

### 4. Enable ProGuard
```kotlin
buildTypes {
    release {
        minifyEnabled = true
        proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
    }
}
```

## Environment Requirements

- **JDK**: 17 or higher
- **Android SDK**: 34
- **Gradle**: 8.7.0
- **Kotlin**: 1.9.22
- **Flutter**: 3.16.0 or higher

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle
flutter build appbundle
```

## Monitoring

### Performance
- Firebase Performance is configured but requires valid google-services.json
- Enable in Firebase Console after setup

### Crash Reporting
- Firebase Crashlytics is configured
- Requires valid Firebase project

### Analytics
- Firebase Analytics is configured
- Custom events can be tracked after proper setup

---

**Last Updated**: 2025-01-24
**Version**: 1.0.0