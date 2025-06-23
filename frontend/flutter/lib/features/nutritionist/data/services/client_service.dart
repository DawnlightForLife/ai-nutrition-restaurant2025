import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../domain/models/client_models.dart';

final clientServiceProvider = Provider<ClientService>((ref) {
  final dio = ref.watch(dioProvider);
  return ClientService(dio);
});

class ClientService {
  final Dio _dio;

  ClientService(this._dio);

  /// 获取客户列表
  Future<List<NutritionistClient>> getClients({
    String? search,
    String? tag,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/nutritionist-clients',
        queryParameters: {
          if (search != null) 'search': search,
          if (tag != null) 'tag': tag,
          if (sortBy != null) 'sortBy': sortBy,
          'page': page,
          'limit': limit,
        },
      );

      return (response.data['data'] as List)
          .map((json) => NutritionistClient.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('获取客户列表失败: $e');
    }
  }

  /// 获取客户详情
  Future<ClientDetail> getClientDetail(String clientId) async {
    try {
      final response = await _dio.get('/nutritionist-clients/$clientId');
      return ClientDetail.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取客户详情失败: $e');
    }
  }

  /// 添加客户
  Future<NutritionistClient> addClient({
    required String nickname,
    int? age,
    String? gender,
    HealthOverview? healthOverview,
    List<String>? tags,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '/nutritionist-clients',
        data: {
          'nickname': nickname,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
          if (healthOverview != null) 'healthOverview': healthOverview.toJson(),
          if (tags != null) 'tags': tags,
          if (notes != null) 'notes': notes,
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('添加客户失败: $e');
    }
  }

  /// 更新客户信息
  Future<NutritionistClient> updateClient(
    String clientId, {
    String? nickname,
    int? age,
    String? gender,
    HealthOverview? healthOverview,
    List<String>? tags,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.put(
        '/nutritionist-clients/$clientId',
        data: {
          if (nickname != null) 'nickname': nickname,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
          if (healthOverview != null) 'healthOverview': healthOverview.toJson(),
          if (tags != null) 'tags': tags,
          if (notes != null) 'notes': notes,
          if (isActive != null) 'isActive': isActive,
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('更新客户信息失败: $e');
    }
  }

  /// 更新客户进展
  Future<NutritionistClient> updateProgress(
    String clientId,
    ProgressUpdateParams params,
  ) async {
    try {
      final response = await _dio.post(
        '/nutritionist-clients/$clientId/progress',
        data: {
          if (params.weight != null) 'weight': params.weight,
          if (params.bodyFatPercentage != null) 'bodyFatPercentage': params.bodyFatPercentage,
          if (params.muscleMass != null) 'muscleMass': params.muscleMass,
          if (params.measurements != null) 'measurements': params.measurements,
          if (params.notes != null) 'notes': params.notes,
          if (params.photos != null) 'photos': params.photos,
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('更新进展失败: $e');
    }
  }

  /// 添加目标
  Future<NutritionistClient> addGoal(
    String clientId, {
    required String type,
    required String description,
    double? targetValue,
    DateTime? targetDate,
  }) async {
    try {
      final response = await _dio.post(
        '/nutritionist-clients/$clientId/goals',
        data: {
          'type': type,
          'description': description,
          if (targetValue != null) 'targetValue': targetValue,
          if (targetDate != null) 'targetDate': targetDate.toIso8601String(),
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('添加目标失败: $e');
    }
  }

  /// 更新目标
  Future<NutritionistClient> updateGoal(
    String clientId,
    String goalId, {
    double? currentValue,
    String? status,
  }) async {
    try {
      final response = await _dio.put(
        '/nutritionist-clients/$clientId/goals/$goalId',
        data: {
          if (currentValue != null) 'currentValue': currentValue,
          if (status != null) 'status': status,
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('更新目标失败: $e');
    }
  }

  /// 添加提醒
  Future<NutritionistClient> addReminder(
    String clientId, {
    required String type,
    required String title,
    String? description,
    required DateTime reminderDate,
    bool? isRecurring,
    String? recurringPattern,
  }) async {
    try {
      final response = await _dio.post(
        '/nutritionist-clients/$clientId/reminders',
        data: {
          'type': type,
          'title': title,
          if (description != null) 'description': description,
          'reminderDate': reminderDate.toIso8601String(),
          if (isRecurring != null) 'isRecurring': isRecurring,
          if (recurringPattern != null) 'recurringPattern': recurringPattern,
        },
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('添加提醒失败: $e');
    }
  }

  /// 标记提醒完成
  Future<NutritionistClient> completeReminder(
    String clientId,
    String reminderId,
  ) async {
    try {
      final response = await _dio.put(
        '/nutritionist-clients/$clientId/reminders/$reminderId/complete',
      );

      return NutritionistClient.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('标记提醒失败: $e');
    }
  }

  /// 获取客户统计
  Future<ClientStats> getClientStats(String clientId) async {
    try {
      final response = await _dio.get('/nutritionist-clients/$clientId/stats');
      return ClientStats.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取客户统计失败: $e');
    }
  }

  /// 搜索潜在客户
  Future<List<Map<String, dynamic>>> searchPotentialClients(String keyword) async {
    try {
      final response = await _dio.get(
        '/nutritionist-clients/search-potential',
        queryParameters: {'keyword': keyword},
      );

      return (response.data['data'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('搜索潜在客户失败: $e');
    }
  }
}