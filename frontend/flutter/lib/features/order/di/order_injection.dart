/// Order 模块依赖注入
/// 
/// 管理 Order 模块的所有依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/datasources/order_remote_datasource.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/get_orders_usecase.dart';
import '../application/facades/order_facade.dart';

/// Order 模块依赖注入容器
class OrderInjection {
  OrderInjection._();

  // ========== Data Sources ==========
  
  /// Order 远程数据源
  static final orderRemoteDataSourceProvider = 
      createServiceProvider<OrderRemoteDataSource>((ref) {
    final dio = ref.watch(InjectionContainer.dioClientProvider);
    return OrderRemoteDataSourceImpl(dio);
  });

  // ========== Repositories ==========
  
  /// Order 仓库
  static final orderRepositoryProvider = createRepositoryProvider<OrderRepository>((ref) {
    return OrderRepositoryImpl(
      remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
      networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
    );
  });

  // ========== Use Cases ==========
  
  /// 获取订单列表用例
  static final getOrdersUseCaseProvider = createUseCaseProvider<GetOrdersUseCase>((ref) {
    return GetOrdersUseCase(
      repository: ref.watch(orderRepositoryProvider),
    );
  });

  // TODO: 添加其他订单相关用例
  // static final createOrderUseCaseProvider = ...
  // static final cancelOrderUseCaseProvider = ...
  // static final payOrderUseCaseProvider = ...

  // ========== Facades ==========
  
  /// Order 业务门面
  static final orderFacadeProvider = Provider<OrderFacade>((ref) {
    return OrderFacade(
      getOrdersUseCase: ref.watch(getOrdersUseCaseProvider),
      // TODO: 添加其他用例依赖
    );
  });
}

// 占位实现（实际开发时替换）
abstract class OrderRemoteDataSource {}
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl(DioClient dio);
}