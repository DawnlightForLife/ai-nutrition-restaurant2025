# Flutter构建问题解决方案

## 问题描述
1. 运行 `flutter run` 时报错："Gradle build failed to produce an .apk file"
2. 项目配置了多个productFlavors（dev、staging、prod），导致Flutter不知道使用哪个变体

## 解决方案

### 1. 使用特定的flavor运行
```bash
# 运行dev环境
flutter run --flavor dev

# 运行staging环境
flutter run --flavor staging  

# 运行prod环境
flutter run --flavor prod
```

### 2. 使用提供的脚本运行
```bash
# 运行dev环境的便捷脚本
./run_flutter_dev.sh
```

### 3. 清理并重建项目
```bash
# 清理旧的构建文件
flutter clean

# 获取依赖
flutter pub get

# 生成代码
dart run build_runner build --delete-conflicting-outputs

# 运行应用（指定flavor）
flutter run --flavor dev
```

## 已完成的修改

1. **user_model.dart**: 添加了@JsonKey注解来处理JSON字段映射问题
2. **build.gradle.kts**: 优化了构建配置，确保APK输出路径一致
3. **代码生成**: 重新运行了build_runner来生成最新的.g.dart文件

## 关于debug版本进度不同步

如果你之前运行的是不带flavor的版本，那么新的dev flavor会创建新的应用ID（com.ainutrition.restaurant.dev），这会被视为一个全新的应用：

- **原应用ID**: com.ainutrition.restaurant
- **Dev应用ID**: com.ainutrition.restaurant.dev
- **Staging应用ID**: com.ainutrition.restaurant.staging

这意味着：
1. 数据不会在不同flavor之间共享
2. 需要重新登录和设置
3. 本地存储的数据（SharedPreferences、数据库等）都是独立的

## 建议

1. 开发时始终使用 `--flavor dev`
2. 测试时使用 `--flavor staging`
3. 发布时使用 `--flavor prod`

这样可以确保不同环境的数据隔离，避免开发数据影响生产环境。