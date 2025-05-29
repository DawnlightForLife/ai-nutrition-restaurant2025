/// 认证模块 Provider 统一导出
/// 
/// 本文件作为认证模块的Provider入口，集中管理认证相关的所有状态

// 核心认证控制器
export 'auth_controller.dart';

// 便捷访问器
export 'auth_accessors.dart';

// 认证相关的特定Provider（如果有）
// export 'oauth_provider.dart';
// export 'biometric_auth_provider.dart';

/// 认证模块Provider集合
/// 
/// 使用方式：
/// ```dart
/// // 在需要认证功能的地方导入
/// import 'package:your_app/features/auth/presentation/providers/auth_providers.dart';
/// 
/// // 使用认证状态
/// final authState = ref.watch(authControllerProvider);
/// final isAuthenticated = ref.watch(isAuthenticatedProvider);
/// final currentUser = ref.watch(currentUserProvider);
/// ```