import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../presentation/providers/certification_review_provider.dart';

final certificationReviewServiceProvider = Provider<CertificationReviewService>((ref) {
  final dio = ref.watch(dioProvider);
  return CertificationReviewService(dio);
});

class CertificationReviewService {
  final Dio _dio;

  CertificationReviewService(this._dio);

  /// 获取认证申请列表
  Future<List<CertificationApplication>> getApplications(
    CertificationFilterParams params,
  ) async {
    try {
      final queryParams = <String, dynamic>{
        'page': params.page,
        'limit': params.limit,
        'status': params.status,
      };

      if (params.certificationLevel != null) {
        queryParams['certificationLevel'] = params.certificationLevel;
      }
      if (params.specialization != null) {
        queryParams['specialization'] = params.specialization;
      }
      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        queryParams['search'] = params.searchQuery;
      }

      final response = await _dio.get(
        '/api/admin/nutritionist-certification-review/applications',
        queryParameters: queryParams,
      );

      final applications = (response.data['data']['applications'] as List)
          .map((json) => CertificationApplication.fromJson(json))
          .toList();

      return applications;
    } catch (e) {
      throw Exception('获取认证申请列表失败: $e');
    }
  }

  /// 获取认证申请详情
  Future<CertificationApplication> getApplicationDetail(String applicationId) async {
    try {
      final response = await _dio.get(
        '/api/admin/nutritionist-certification-review/applications/$applicationId',
      );

      return CertificationApplication.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('获取认证申请详情失败: $e');
    }
  }

  /// 审核申请
  Future<void> reviewApplication({
    required String applicationId,
    required String decision,
    required String reviewNotes,
  }) async {
    try {
      await _dio.post(
        '/api/admin/nutritionist-certification-review/applications/$applicationId/review',
        data: {
          'decision': decision,
          'reviewNotes': reviewNotes,
          'reviewerId': 'current_admin', // TODO: Get from auth state
        },
      );
    } catch (e) {
      throw Exception('审核申请失败: $e');
    }
  }

  /// 批量审核
  Future<void> batchReview({
    required List<String> applicationIds,
    required String decision,
    required String reviewNotes,
  }) async {
    try {
      await _dio.post(
        '/api/admin/nutritionist-certification-review/batch-review',
        data: {
          'applicationIds': applicationIds,
          'decision': decision,
          'reviewNotes': reviewNotes,
          'reviewerId': 'current_admin', // TODO: Get from auth state
        },
      );
    } catch (e) {
      throw Exception('批量审核失败: $e');
    }
  }

  /// 获取审核统计
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _dio.get(
        '/api/admin/nutritionist-certification-review/statistics',
      );

      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('获取审核统计失败: $e');
    }
  }

  /// 获取审核历史
  Future<List<Map<String, dynamic>>> getReviewHistory(String applicationId) async {
    try {
      final response = await _dio.get(
        '/api/admin/nutritionist-certification-review/applications/$applicationId/history',
      );

      return (response.data['data'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('获取审核历史失败: $e');
    }
  }

  /// 更新申请优先级
  Future<void> updateApplicationPriority({
    required String applicationId,
    required String priority,
  }) async {
    try {
      await _dio.put(
        '/api/admin/nutritionist-certification-review/applications/$applicationId/priority',
        data: {'priority': priority},
      );
    } catch (e) {
      throw Exception('更新优先级失败: $e');
    }
  }

  /// 分配审核员
  Future<void> assignReviewer({
    required String applicationId,
    required String reviewerId,
  }) async {
    try {
      await _dio.put(
        '/api/admin/nutritionist-certification-review/applications/$applicationId/assign',
        data: {'reviewerId': reviewerId},
      );
    } catch (e) {
      throw Exception('分配审核员失败: $e');
    }
  }
}