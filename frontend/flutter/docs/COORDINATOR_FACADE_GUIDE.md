# Coordinator 与 Facade 职责边界指南

## 📋 问题分析

当前架构中存在 Coordinator 和 Facade 职责重叠的问题，需要明确分工以避免代码混乱。

## 🎯 职责划分

### Coordinator（协调器）- 流程控制层
**位置**: `lib/core/coordinators/`  
**职责**: 跨页面导航与用户流程控制

```dart
/// 用户注册流程协调器
class UserRegistrationCoordinator {
  /// 协调整个注册流程
  Future<bool> startRegistrationFlow(BuildContext context) async {
    // 1. 导航到手机验证页
    final phone = await _navigateToPhoneVerification(context);
    if (phone == null) return false;
    
    // 2. 导航到验证码输入页
    final verified = await _navigateToCodeVerification(context, phone);
    if (!verified) return false;
    
    // 3. 导航到信息完善页
    final completed = await _navigateToProfileCompletion(context);
    
    return completed;
  }
  
  Future<String?> _navigateToPhoneVerification(BuildContext context) { /* */ }
  Future<bool> _navigateToCodeVerification(BuildContext context, String phone) { /* */ }
  Future<bool> _navigateToProfileCompletion(BuildContext context) { /* */ }
}
```

**特点**:
- 管理页面跳转逻辑
- 协调多步骤用户流程
- 持有 BuildContext 或 Router 引用
- 无业务逻辑，只做流程编排

### Facade（门面）- 业务聚合层
**位置**: `lib/features/{module}/application/facades/`  
**职责**: 聚合多个 UseCase/Provider，为 UI 提供一站式接口

```dart
/// 营养档案业务门面
class NutritionProfileFacade {
  final CreateNutritionProfileUseCase _createUseCase;
  final UpdateNutritionProfileUseCase _updateUseCase;
  final GetNutritionProfileUseCase _getUseCase;
  final DeleteNutritionProfileUseCase _deleteUseCase;
  
  /// 创建完整的营养档案
  Future<Either<Failure, NutritionProfile>> createCompleteProfile({
    required BasicInfo basicInfo,
    required HealthGoals healthGoals,
    required DietaryPreferences preferences,
  }) async {
    // 聚合多个业务操作
    final profileResult = await _createUseCase(CreateProfileParams(
      basicInfo: basicInfo,
    ));
    
    if (profileResult.isLeft()) return profileResult;
    
    final profile = profileResult.getOrElse(() => throw Exception());
    
    // 添加健康目标
    await _updateUseCase(UpdateProfileParams(
      profileId: profile.id,
      healthGoals: healthGoals,
    ));
    
    // 添加饮食偏好
    await _updateUseCase(UpdateProfileParams(
      profileId: profile.id,
      preferences: preferences,
    ));
    
    return Right(profile);
  }
}
```

**特点**:
- 聚合相关的 UseCase
- 提供高级业务操作
- 无导航逻辑
- 返回业务结果，不关心 UI 状态

## 🏗️ 新的目录结构

```
lib/
├── core/
│   ├── coordinators/              # 全局流程协调器
│   │   ├── base_coordinator.dart  # 协调器基类
│   │   ├── onboarding_coordinator.dart # 用户引导流程
│   │   └── payment_coordinator.dart    # 支付流程
│   └── navigation/
│       └── app_router.dart        # 路由配置
├── features/
│   └── {module}/
│       ├── application/
│       │   ├── facades/           # 业务门面
│       │   │   └── {module}_facade.dart
│       │   └── usecases/          # 用例
│       │       ├── create_{entity}_usecase.dart
│       │       └── update_{entity}_usecase.dart
│       ├── domain/
│       └── presentation/
│           ├── coordinators/      # 模块内页面协调器
│           │   └── {module}_page_coordinator.dart
│           └── providers/
```

## 🔄 重构指南

### 1. 识别现有代码
- **流程控制** → 移至 Coordinator
- **业务聚合** → 移至 Facade
- **页面跳转** → 移至 Coordinator
- **数据组合** → 移至 Facade

### 2. 重构步骤
1. 将导航逻辑提取到 Coordinator
2. 将业务聚合逻辑提取到 Facade
3. Provider 只调用 Facade，不直接调用 UseCase
4. 页面只调用 Coordinator 进行导航

### 3. 使用示例

#### 在 Provider 中使用 Facade
```dart
@riverpod
class NutritionProfileController extends _$NutritionProfileController {
  @override
  Future<NutritionProfile?> build() async {
    final facade = ref.read(nutritionProfileFacadeProvider);
    final result = await facade.getCurrentUserProfile();
    return result.fold((failure) => null, (profile) => profile);
  }
  
  Future<void> createProfile(CreateProfileRequest request) async {
    state = const AsyncValue.loading();
    
    final facade = ref.read(nutritionProfileFacadeProvider);
    final result = await facade.createCompleteProfile(
      basicInfo: request.basicInfo,
      healthGoals: request.healthGoals,
      preferences: request.preferences,
    );
    
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
  }
}
```

#### 在页面中使用 Coordinator
```dart
class NutritionProfileSetupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final coordinator = ref.read(nutritionSetupCoordinatorProvider);
              final success = await coordinator.startProfileSetup(context);
              if (success) {
                // 显示成功消息
              }
            },
            child: Text('开始设置营养档案'),
          ),
        ],
      ),
    );
  }
}
```

## 📏 判断标准

### 应该使用 Coordinator 的场景
- 需要跨多个页面的流程
- 包含用户交互决策点
- 需要根据用户操作进行页面跳转
- 处理回退逻辑

### 应该使用 Facade 的场景
- 需要调用多个 UseCase
- 业务逻辑需要组合
- 需要事务性操作
- 为 UI 提供简化的业务接口

## 🚀 迁移计划

1. **第一阶段**: 明确现有代码的归属
2. **第二阶段**: 创建新的 Facade 和 Coordinator
3. **第三阶段**: 重构现有代码
4. **第四阶段**: 删除冗余的双重目录

通过这样的职责分离，可以让代码更加清晰，测试更加容易，维护更加简单。