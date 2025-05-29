# 智能营养餐厅 Flutter 应用部署指南

## 📋 目录

- [环境要求](#环境要求)
- [开发环境设置](#开发环境设置)
- [多环境配置](#多环境配置)
- [构建流程](#构建流程)
- [部署流程](#部署流程)
- [CI/CD 配置](#cicd-配置)
- [故障排除](#故障排除)

## 🛠️ 环境要求

### 基础环境
```bash
# Flutter SDK
Flutter 3.19.0+ (推荐最新稳定版)
Dart 3.3.0+

# 开发工具
Android Studio 2023.1+
Xcode 15.0+ (iOS开发)
VS Code (可选)

# Android 开发
Android SDK 34
Android NDK 27.0.12077973
Java 17

# iOS 开发 (macOS)
Xcode 15.0+
CocoaPods 1.11.0+
iOS 12.0+ (最低支持版本)
```

### 系统要求
- **Windows**: Windows 10 64位 或更高版本
- **macOS**: macOS 10.15 或更高版本
- **Linux**: Ubuntu 18.04+ 或等效发行版

## ⚙️ 开发环境设置

### 1. Flutter 环境配置
```bash
# 检查 Flutter 安装
flutter doctor -v

# 确保所有检查项都通过
flutter doctor --android-licenses
```

### 2. 项目依赖安装
```bash
# 进入项目目录
cd ai-nutrition-restaurant2025/frontend/flutter

# 安装依赖
flutter pub get

# 生成代码
dart run build_runner build --delete-conflicting-outputs

# 验证项目配置
flutter analyze
```

### 3. Android 配置
```bash
# 设置 Android NDK 版本
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/27.0.12077973

# 检查 Android 配置
flutter doctor --android-licenses
```

### 4. iOS 配置 (仅 macOS)
```bash
# 安装 CocoaPods 依赖
cd ios && pod install && cd ..

# 检查 iOS 配置
flutter doctor
```

## 🌍 多环境配置

项目支持三个环境：**开发(dev)**、**测试(staging)**、**生产(prod)**

### 环境配置文件
```
lib/config/
├── app_config.dart      # 应用配置基类
├── flavor_config.dart   # Flavor 配置
└── environments/
    ├── dev_config.dart      # 开发环境
    ├── staging_config.dart  # 测试环境
    └── prod_config.dart     # 生产环境
```

### Android 环境配置
文件：`android/app/build.gradle.kts`
```kotlin
android {
    flavorDimensions += "environment"
    
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "元气营养(开发)")
        }
        
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "元气营养(测试)")
        }
        
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "元气营养")
        }
    }
}
```

### iOS 环境配置
使用 Xcode Schemes 配置不同环境：
- **Dev**: 开发环境配置
- **Staging**: 测试环境配置
- **Prod**: 生产环境配置

## 🔨 构建流程

### 开发环境构建
```bash
# Android 开发版本
flutter run --flavor dev --debug

# iOS 开发版本 (macOS)
flutter run --flavor dev --debug
```

### 测试环境构建
```bash
# Android 测试版本
flutter build apk --flavor staging --debug
flutter build appbundle --flavor staging --debug

# iOS 测试版本 (macOS)
flutter build ios --flavor staging --debug
```

### 生产环境构建
```bash
# Android 生产版本
flutter build apk --flavor prod --release
flutter build appbundle --flavor prod --release

# iOS 生产版本 (macOS)
flutter build ios --flavor prod --release
```

### 使用构建脚本
```bash
# 使用项目提供的构建脚本
./scripts/build.sh --platform android --flavor dev --type debug
./scripts/build.sh --platform android --flavor prod --type release
./scripts/build.sh --platform ios --flavor prod --type release
```

## 🚀 部署流程

### Android 部署

#### 1. 生成签名密钥
```bash
# 生成签名密钥 (仅首次)
keytool -genkey -v -keystore ~/upload-keystore.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload
```

#### 2. 配置签名
创建 `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

#### 3. 构建发布版本
```bash
# 构建 AAB (推荐用于 Google Play)
flutter build appbundle --flavor prod --release

# 构建 APK (用于其他分发渠道)
flutter build apk --flavor prod --release
```

#### 4. 上传到应用商店
- **Google Play**: 上传 `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- **其他渠道**: 分发 `build/app/outputs/flutter-apk/app-prod-release.apk`

### iOS 部署

#### 1. 证书配置
- 在 Apple Developer 中心配置 App ID
- 创建分发证书和 Provisioning Profile
- 在 Xcode 中配置签名

#### 2. 构建发布版本
```bash
# 构建 iOS 应用
flutter build ios --flavor prod --release

# 在 Xcode 中打开项目
open ios/Runner.xcworkspace
```

#### 3. 上传到 App Store
- 在 Xcode 中选择 "Product" > "Archive"
- 使用 Xcode Organizer 上传到 App Store Connect

### Web 部署
```bash
# 构建 Web 版本
flutter build web --release

# 部署到服务器
# 将 build/web/ 目录内容上传到 Web 服务器
```

## 🔄 CI/CD 配置

### GitHub Actions 配置

创建 `.github/workflows/flutter-ci.yml`:
```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
      working-directory: frontend/flutter
    
    - name: Generate code
      run: dart run build_runner build --delete-conflicting-outputs
      working-directory: frontend/flutter
    
    - name: Run tests
      run: flutter test
      working-directory: frontend/flutter
    
    - name: Analyze code
      run: flutter analyze
      working-directory: frontend/flutter

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
    
    - name: Setup Android
      uses: android-actions/setup-android@v2
    
    - name: Install dependencies
      run: flutter pub get
      working-directory: frontend/flutter
    
    - name: Build APK
      run: flutter build apk --flavor prod --release
      working-directory: frontend/flutter
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: android-apk
        path: frontend/flutter/build/app/outputs/flutter-apk/

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
    
    - name: Install dependencies
      run: flutter pub get
      working-directory: frontend/flutter
    
    - name: Build iOS
      run: flutter build ios --flavor prod --release --no-codesign
      working-directory: frontend/flutter
```

### Fastlane 配置

#### Android Fastlane (`android/fastlane/Fastfile`)
```ruby
default_platform(:android)

platform :android do
  desc "Build development APK"
  lane :build_dev do
    sh("cd ../.. && flutter build apk --flavor dev --debug")
  end

  desc "Build staging APK"
  lane :build_staging do
    sh("cd ../.. && flutter build apk --flavor staging --debug")
  end

  desc "Build and deploy to Google Play"
  lane :deploy_prod do
    sh("cd ../.. && flutter build appbundle --flavor prod --release")
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/prodRelease/app-prod-release.aab'
    )
  end
end
```

#### iOS Fastlane (`ios/fastlane/Fastfile`)
```ruby
default_platform(:ios)

platform :ios do
  desc "Build development IPA"
  lane :build_dev do
    sh("cd ../.. && flutter build ios --flavor dev --debug --no-codesign")
  end

  desc "Build and deploy to App Store"
  lane :deploy_prod do
    sh("cd ../.. && flutter build ios --flavor prod --release --no-codesign")
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Prod",
      export_method: "app-store"
    )
    upload_to_app_store(
      force: true,
      reject_if_possible: true,
      skip_metadata: false,
      skip_screenshots: false,
      submit_for_review: false
    )
  end
end
```

## 🛠️ 故障排除

### 常见构建问题

#### 1. Gradle 同步失败
```bash
# 清理 Gradle 缓存
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
```

#### 2. NDK 版本不匹配
```bash
# 确保使用正确的 NDK 版本
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/27.0.12077973
```

#### 3. iOS 构建失败
```bash
# 清理 iOS 构建缓存
cd ios && pod deintegrate && pod install && cd ..
flutter clean
flutter pub get
```

#### 4. 代码生成错误
```bash
# 重新生成所有代码
flutter packages pub run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### 5. Flavor 配置问题
```bash
# 确保使用正确的 flavor
flutter run --flavor dev    # 开发环境
flutter run --flavor staging # 测试环境
flutter run --flavor prod   # 生产环境
```

### 性能优化建议

#### 1. 构建优化
```bash
# 启用 R8 代码缩减 (Android)
# 在 android/app/build.gradle.kts 中
android {
    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
```

#### 2. 应用包大小优化
```bash
# 分析 APK 大小
flutter build apk --analyze-size

# 构建分架构 APK
flutter build apk --split-per-abi
```

### 环境变量配置

创建 `.env` 文件：
```bash
# 开发环境
DEV_API_BASE_URL=https://dev-api.nutrition-ai.com
DEV_WS_URL=wss://dev-ws.nutrition-ai.com

# 测试环境
STAGING_API_BASE_URL=https://staging-api.nutrition-ai.com
STAGING_WS_URL=wss://staging-ws.nutrition-ai.com

# 生产环境
PROD_API_BASE_URL=https://api.nutrition-ai.com
PROD_WS_URL=wss://ws.nutrition-ai.com
```

### 监控和日志

#### 1. 崩溃报告
- 集成 Firebase Crashlytics
- 配置 Sentry (可选)

#### 2. 性能监控
- 集成 Firebase Performance
- 自定义性能指标

#### 3. 用户分析
- 集成 Firebase Analytics
- 自定义事件追踪

---

## 📚 相关文档

- [Flutter 官方部署指南](https://flutter.dev/docs/deployment)
- [Android 应用签名](https://developer.android.com/studio/publish/app-signing)
- [iOS 应用分发](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Fastlane 文档](https://docs.fastlane.tools/)

---

**📝 更新日志**
- v1.0.0 (2025-01-28): 初始版本
- 包含多环境配置、CI/CD 流程和故障排除指南