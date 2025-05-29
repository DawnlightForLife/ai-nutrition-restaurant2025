# 用户模块 (User)

## 📋 模块概述

用户模块负责用户账户管理、个人信息维护、偏好设置等核心功能，是整个应用的基础模块。

### 核心功能
- 👤 个人资料管理
- 🔐 账户安全设置
- 🎯 偏好配置
- 📍 地址管理
- 🔔 通知设置

## 🎯 主要功能

### 1. 账户管理
- **基本信息**：姓名、头像、联系方式
- **健康档案**：身高、体重、过敏史
- **饮食偏好**：口味、禁忌、特殊需求
- **地址管理**：配送地址维护
- **隐私设置**：数据共享、可见性控制

### 2. 用户角色
- `user` - 普通用户
- `nutritionist` - 营养师
- `merchant` - 商家
- `admin` - 管理员
- `vip` - VIP会员

## 🔌 状态管理

```dart
@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserProfile> build() async {
    final useCase = ref.read(getUserProfileUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => profile,
    );
  }

  Future<void> updateProfile(ProfileUpdateRequest request) async { /* ... */ }
  Future<void> updateAvatar(File imageFile) async { /* ... */ }
  Future<void> addAddress(AddressInfo address) async { /* ... */ }
  Future<void> updatePreferences(UserPreferences prefs) async { /* ... */ }
}
```

## 📱 核心组件

- **ProfileCard**: 用户信息卡片
- **ProfileEditor**: 资料编辑表单
- **AddressManager**: 地址管理列表
- **PreferenceSettings**: 偏好设置面板
- **SecuritySettings**: 安全设置组件

## 🚀 使用示例

```dart
class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileControllerProvider);
    
    return AsyncView<UserProfile>(
      value: profileState,
      data: (profile) => ProfileView(
        profile: profile,
        onEditProfile: () => context.go('/user/edit'),
        onManageAddresses: () => context.go('/user/addresses'),
        onSettings: () => context.go('/user/settings'),
      ),
    );
  }
}
```

---

**📚 相关文档**
- [用户权限体系](./docs/USER_PERMISSIONS.md)
- [隐私保护政策](./docs/PRIVACY_POLICY.md)
