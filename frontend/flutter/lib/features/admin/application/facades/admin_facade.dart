/// 管理员模块统一业务门面
/// 
/// 聚合管理员相关的所有用例和业务逻辑
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/admin.dart';
import '../../domain/usecases/get_admins_usecase.dart';

/// 管理员业务门面
class AdminFacade {
  const AdminFacade({
    required this.getAdminsUseCase,
  });

  final GetAdminsUseCase getAdminsUseCase;

  /// 获取管理员列表
  Future<Either<AdminFailure, List<Admin>>> getAdmins({
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取管理员列表的业务逻辑
    throw UnimplementedError('getAdmins 待实现');
  }

  /// 获取管理员详情
  Future<Either<AdminFailure, Admin>> getAdminDetail({
    required String adminId,
  }) async {
    // TODO: 实现获取管理员详情的业务逻辑
    throw UnimplementedError('getAdminDetail 待实现');
  }

  /// 更新管理员权限
  Future<Either<AdminFailure, Admin>> updateAdminPermissions({
    required String adminId,
    required List<String> permissions,
  }) async {
    // TODO: 实现更新管理员权限的业务逻辑
    throw UnimplementedError('updateAdminPermissions 待实现');
  }

  /// 获取系统统计数据
  Future<Either<AdminFailure, SystemStats>> getSystemStats() async {
    // TODO: 实现获取系统统计数据的业务逻辑
    throw UnimplementedError('getSystemStats 待实现');
  }
}

/// 管理员业务失败类型
abstract class AdminFailure {}

/// 系统统计数据
abstract class SystemStats {}