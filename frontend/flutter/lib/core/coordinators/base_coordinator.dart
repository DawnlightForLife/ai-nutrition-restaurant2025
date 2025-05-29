import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router/router_manager.dart';

/// Coordinator 基类
/// 处理跨模块的业务流程编排
abstract class BaseCoordinator {
  final Ref ref;
  late final RouterManager _routerManager;
  
  BaseCoordinator(this.ref) {
    _routerManager = ref.read(routerManagerProvider);
  }
  
  /// 获取路由管理器
  RouterManager get router => _routerManager;
  
  /// 开始协调流程
  Future<void> start();
  
  /// 清理资源
  void dispose() {
    // 子类可以重写此方法进行清理
  }
}