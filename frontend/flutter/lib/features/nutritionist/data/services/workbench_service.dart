import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../domain/models/workbench_models.dart';

final workbenchServiceProvider = Provider<WorkbenchService>((ref) {
  final dio = ref.watch(dioProvider);
  return WorkbenchService(dio);
});

class WorkbenchService {
  final Dio _dio;

  WorkbenchService(this._dio);

  /// 获取工作台统计数据
  Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await _dio.get('/nutritionist/workbench/dashboard/stats');
      return DashboardStats.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取统计数据失败: $e');
    }
  }

  /// 获取待办任务
  Future<List<WorkbenchTask>> getTasks() async {
    try {
      final response = await _dio.get('/nutritionist/workbench/dashboard/tasks');
      return (response.data['data'] as List)
          .map((json) => WorkbenchTask.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('获取待办任务失败: $e');
    }
  }

  /// 获取营养师视角的咨询列表
  Future<List<WorkbenchConsultation>> getConsultations({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/nutritionist/workbench/consultations',
        queryParameters: {
          if (status != null) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return (response.data['data'] as List)
          .map((json) => WorkbenchConsultation.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('获取咨询列表失败: $e');
    }
  }

  /// 接受咨询
  Future<void> acceptConsultation(String consultationId) async {
    try {
      await _dio.put('/nutritionist/workbench/consultations/$consultationId/accept');
    } catch (e) {
      throw Exception('接受咨询失败: $e');
    }
  }

  /// 拒绝咨询
  Future<void> rejectConsultation(String consultationId, String? reason) async {
    try {
      await _dio.put(
        '/nutritionist/workbench/consultations/$consultationId/reject',
        data: {
          if (reason != null) 'reason': reason,
        },
      );
    } catch (e) {
      throw Exception('拒绝咨询失败: $e');
    }
  }

  /// 完成咨询
  Future<void> completeConsultation(String consultationId, String? summary) async {
    try {
      await _dio.put(
        '/nutritionist/workbench/consultations/$consultationId/complete',
        data: {
          if (summary != null) 'summary': summary,
        },
      );
    } catch (e) {
      throw Exception('完成咨询失败: $e');
    }
  }

  /// 获取排班表
  Future<Schedule> getSchedule({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/nutritionist/workbench/schedule',
        queryParameters: {
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
        },
      );
      return Schedule.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取排班表失败: $e');
    }
  }

  /// 更新排班
  Future<void> updateSchedule({
    Map<String, dynamic>? workingHours,
    List<Map<String, dynamic>>? vacations,
  }) async {
    try {
      await _dio.put(
        '/nutritionist/workbench/schedule',
        data: {
          if (workingHours != null) 'workingHours': workingHours,
          if (vacations != null) 'vacations': vacations,
        },
      );
    } catch (e) {
      throw Exception('更新排班失败: $e');
    }
  }

  /// 获取收入明细
  Future<IncomeDetails> getIncomeDetails({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/nutritionist/workbench/income/details',
        queryParameters: {
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
          'page': page,
          'limit': limit,
        },
      );
      return IncomeDetails.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取收入明细失败: $e');
    }
  }

  /// 批量发送消息给客户
  Future<BatchMessageResult> sendBatchMessage({
    required List<String> clientIds,
    required String message,
    String type = 'notification',
  }) async {
    try {
      final response = await _dio.post(
        '/nutritionist/workbench/clients/batch-message',
        data: {
          'clientIds': clientIds,
          'message': message,
          'type': type,
        },
      );
      return BatchMessageResult.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('批量发送消息失败: $e');
    }
  }

  /// 获取快捷操作
  Future<List<QuickAction>> getQuickActions() async {
    try {
      final response = await _dio.get('/nutritionist/workbench/quick-actions');
      return (response.data['data'] as List)
          .map((json) => QuickAction.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('获取快捷操作失败: $e');
    }
  }

  /// 切换在线状态
  Future<OnlineStatusResult> toggleOnlineStatus() async {
    try {
      final response = await _dio.post('/nutritionist/workbench/toggle-online-status');
      return OnlineStatusResult.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('切换在线状态失败: $e');
    }
  }

  /// 更新可用状态
  Future<OnlineStatusResult> updateAvailability({required bool isAvailable}) async {
    try {
      final response = await _dio.put(
        '/nutritionist/workbench/availability',
        data: {'isAvailable': isAvailable},
      );
      return OnlineStatusResult.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('更新可用状态失败: $e');
    }
  }
}