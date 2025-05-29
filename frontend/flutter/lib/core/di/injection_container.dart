/// 依赖注入容器
/// 
/// 统一管理所有模块的依赖注入
/// 提供 Repository、UseCase、Service 等的注册和获取
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

/// 依赖注入容器
/// 
/// 负责管理应用级别的依赖注入
class InjectionContainer {
  InjectionContainer._();

  /// 网络客户端
  static final dioClientProvider = Provider<DioClient>((ref) {
    return DioClient();
  });

  /// 网络状态信息
  static final networkInfoProvider = Provider<NetworkInfo>((ref) {
    return NetworkInfoImpl();
  });

  /// 初始化依赖注入
  static Future<void> init() async {
    // TODO: 初始化第三方服务
    // 例如：SharedPreferences、Database 等
  }
}

/// 基础 Repository Provider 创建器
Provider<T> createRepositoryProvider<T>(
  T Function(Ref ref) create,
) {
  return Provider<T>(create);
}

/// 基础 UseCase Provider 创建器
Provider<T> createUseCaseProvider<T>(
  T Function(Ref ref) create,
) {
  return Provider<T>(create);
}

/// 基础 Service Provider 创建器
Provider<T> createServiceProvider<T>(
  T Function(Ref ref) create,
) {
  return Provider<T>(create);
}