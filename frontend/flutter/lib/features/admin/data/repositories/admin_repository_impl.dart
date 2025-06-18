import '../../../../core/network/network_info.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/admin_model.dart';

/// UadminRepository 实现
class UadminRepositoryImpl implements UadminRepository {
  final UadminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UadminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Uadmin>> getUadmins() async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: '网络连接不可用');
    }

    try {
      final models = await remoteDataSource.getUadmins();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ServerException(message: '获取管理员列表失败: $e');
    }
  }

  @override
  Future<Uadmin?> getUadmin(String id) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: '网络连接不可用');
    }

    try {
      final model = await remoteDataSource.getUadmin(id);
      return model.toEntity();
    } catch (e) {
      throw ServerException(message: '获取管理员信息失败: $e');
    }
  }

  @override
  Future<Uadmin> createUadmin(Uadmin admin) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: '网络连接不可用');
    }

    try {
      final model = UadminModel.fromEntity(admin);
      final result = await remoteDataSource.createUadmin(model);
      return result.toEntity();
    } catch (e) {
      throw ServerException(message: '创建管理员失败: $e');
    }
  }

  @override
  Future<Uadmin> updateUadmin(Uadmin admin) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: '网络连接不可用');
    }

    try {
      final model = UadminModel.fromEntity(admin);
      final result = await remoteDataSource.updateUadmin(admin.id, model);
      return result.toEntity();
    } catch (e) {
      throw ServerException(message: '更新管理员信息失败: $e');
    }
  }

  @override
  Future<void> deleteUadmin(String id) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: '网络连接不可用');
    }

    try {
      await remoteDataSource.deleteUadmin(id);
    } catch (e) {
      throw ServerException(message: '删除管理员失败: $e');
    }
  }
}
