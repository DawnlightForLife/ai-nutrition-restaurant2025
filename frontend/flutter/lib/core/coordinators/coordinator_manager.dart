import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/coordinators/auth_flow_coordinator.dart';
import '../../features/consultation/presentation/coordinators/consultation_flow_coordinator.dart';
import '../../features/nutrition/presentation/coordinators/nutrition_flow_coordinator.dart';
import '../../features/order/presentation/coordinators/order_flow_coordinator.dart';
import 'base_coordinator.dart';

/// Coordinator 管理器
/// 集中管理所有的 Coordinator，提供统一的访问接口
class CoordinatorManager {
  final Ref ref;
  
  // Coordinator 实例缓存
  final Map<Type, BaseCoordinator> _coordinators = {};
  
  CoordinatorManager(this.ref);
  
  /// 获取 AuthFlowCoordinator
  AuthFlowCoordinator get auth => _getCoordinator<AuthFlowCoordinator>(
    () => AuthFlowCoordinator(ref),
  );
  
  /// 获取 NutritionFlowCoordinator
  NutritionFlowCoordinator get nutrition => _getCoordinator<NutritionFlowCoordinator>(
    () => NutritionFlowCoordinator(ref),
  );
  
  /// 获取 OrderFlowCoordinator
  OrderFlowCoordinator get order => _getCoordinator<OrderFlowCoordinator>(
    () => OrderFlowCoordinator(ref),
  );
  
  /// 获取 ConsultationFlowCoordinator
  ConsultationFlowCoordinator get consultation => _getCoordinator<ConsultationFlowCoordinator>(
    () => ConsultationFlowCoordinator(ref),
  );
  
  /// 获取或创建 Coordinator
  T _getCoordinator<T extends BaseCoordinator>(T Function() factory) {
    return _coordinators.putIfAbsent(T, factory) as T;
  }
  
  /// 清理所有 Coordinator
  void dispose() {
    for (final coordinator in _coordinators.values) {
      coordinator.dispose();
    }
    _coordinators.clear();
  }
}

/// Provider
final coordinatorManagerProvider = Provider((ref) {
  final manager = CoordinatorManager(ref);
  
  // 当 Provider 被销毁时清理资源
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});