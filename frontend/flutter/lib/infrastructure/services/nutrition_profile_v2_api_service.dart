import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../core/network/dio_client.dart';
import '../mappers/nutrition_profile_mapper.dart';

class NutritionProfileV2ApiService {
  final Dio _dio = DioClient.instance.dio;
  static const String _baseUrl = '/nutrition/nutrition-profiles';
  
  // 使用mapper单例
  final _mapper = const NutritionProfileMapper();

  // 获取当前用户的所有营养档案
  Future<Either<Failure, List<NutritionProfileV2>>> getUserProfiles() async {
    try {
      // 获取当前用户信息
      final userResponse = await _dio.get('/auth/me');
      if (userResponse.data?['success'] != true) {
        return left(const ServerFailure(message: '获取用户信息失败'));
      }
      
      final userId = userResponse.data?['user']?['_id'];
      if (userId == null) {
        return left(const ServerFailure(message: '用户ID不存在'));
      }

      // 获取用户的营养档案列表
      final response = await _dio.get('$_baseUrl/user/$userId');
      
      if (response.data?['success'] == true) {
        final List<dynamic> profilesData = response.data?['data'] ?? [];
        final profiles = profilesData
            .map((json) => _mapper.toDomain(
                  NutritionProfile.fromJson(json as Map<String, dynamic>),
                ))
            .toList();
        return right(profiles);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '获取档案列表失败'));
      }
    } catch (e) {
      print('获取营养档案列表失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 获取单个营养档案
  Future<Either<Failure, NutritionProfileV2>> getProfileById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      
      if (response.data?['success'] == true) {
        final dtoProfile = NutritionProfile.fromJson(response.data?['data']);
        final profile = _mapper.toDomain(dtoProfile);
        return right(profile);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '获取档案详情失败'));
      }
    } catch (e) {
      print('获取营养档案详情失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 创建营养档案
  Future<Either<Failure, NutritionProfileV2>> createProfile(NutritionProfileV2 profile) async {
    try {
      final dtoProfile = _mapper.toDto(profile);
      final data = dtoProfile.toJson();
      final response = await _dio.post(_baseUrl, data: data);
      
      if (response.data?['success'] == true) {
        final createdDtoProfile = NutritionProfile.fromJson(response.data?['data']);
        final createdProfile = _mapper.toDomain(createdDtoProfile);
        return right(createdProfile);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '创建档案失败'));
      }
    } catch (e) {
      print('创建营养档案失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 更新营养档案
  Future<Either<Failure, NutritionProfileV2>> updateProfile(String id, NutritionProfileV2 profile) async {
    try {
      final dtoProfile = _mapper.toDto(profile);
      final data = dtoProfile.toJson();
      final response = await _dio.put('$_baseUrl/$id', data: data);
      
      if (response.data?['success'] == true) {
        final updatedDtoProfile = NutritionProfile.fromJson(response.data?['data']);
        final updatedProfile = _mapper.toDomain(updatedDtoProfile);
        return right(updatedProfile);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '更新档案失败'));
      }
    } catch (e) {
      print('更新营养档案失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 删除营养档案
  Future<Either<Failure, Unit>> deleteProfile(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      
      if (response.data?['success'] == true) {
        return right(unit);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '删除档案失败'));
      }
    } catch (e) {
      print('删除营养档案失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 设置主档案
  Future<Either<Failure, Unit>> setPrimaryProfile(String id) async {
    try {
      final response = await _dio.put('$_baseUrl/$id/primary');
      
      if (response.data?['success'] == true) {
        return right(unit);
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '设置主档案失败'));
      }
    } catch (e) {
      print('设置主档案失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }

  // 获取档案完成度统计
  Future<Either<Failure, Map<String, dynamic>>> getCompletionStats() async {
    try {
      final response = await _dio.get('$_baseUrl/stats/completion');
      
      if (response.data?['success'] == true) {
        return right(response.data?['data'] ?? {});
      } else {
        return left(ServerFailure(message: response.data?['message'] ?? '获取统计信息失败'));
      }
    } catch (e) {
      print('获取完成度统计失败: $e');
      return left(ServerFailure(message: e.toString()));
    }
  }
}