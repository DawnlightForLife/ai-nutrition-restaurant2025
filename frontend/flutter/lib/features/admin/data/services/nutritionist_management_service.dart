import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/nutritionist_management_entity.dart';

class NutritionistManagementService {
  final DioClient _dioClient;

  NutritionistManagementService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// 获取营养师列表
  Future<NutritionistManagementResponse> getNutritionists({
    int page = 1,
    int limit = 20,
    String? status,
    String? verificationStatus,
    String? specialization,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };

      if (status != null) queryParams['status'] = status;
      if (verificationStatus != null) {
        queryParams['verificationStatus'] = verificationStatus;
      }
      if (specialization != null) queryParams['specialization'] = specialization;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _dioClient.get(
        ApiEndpoints.adminNutritionistManagement,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return NutritionistManagementResponse.fromJson(response.data['data']);
      } else {
        throw Exception('获取营养师列表失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('获取营养师列表失败: $e');
    }
  }

  /// 获取营养师详情
  Future<NutritionistDetailEntity> getNutritionistDetail(
      String nutritionistId) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.adminNutritionistManagement}/$nutritionistId',
      );

      if (response.statusCode == 200) {
        return NutritionistDetailEntity.fromJson(response.data['data']);
      } else {
        throw Exception('获取营养师详情失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('获取营养师详情失败: $e');
    }
  }

  /// 更新营养师状态
  Future<void> updateNutritionistStatus(
    String nutritionistId,
    String status,
    String? reason,
  ) async {
    try {
      final data = <String, dynamic>{
        'status': status,
      };
      if (reason != null && reason.isNotEmpty) {
        data['reason'] = reason;
      }

      final response = await _dioClient.put(
        '${ApiEndpoints.adminNutritionistManagement}/$nutritionistId/status',
        data: data,
      );

      if (response.statusCode != 200) {
        throw Exception('更新营养师状态失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('更新营养师状态失败: $e');
    }
  }

  /// 批量操作营养师
  Future<BatchOperationResult> batchUpdateNutritionists(
    List<String> nutritionistIds,
    String action,
    Map<String, dynamic> data,
  ) async {
    try {
      final requestData = {
        'nutritionistIds': nutritionistIds,
        'action': action,
        'data': data,
      };

      final response = await _dioClient.post(
        '${ApiEndpoints.adminNutritionistManagement}/batch',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return BatchOperationResult.fromJson(response.data['data']);
      } else {
        throw Exception('批量操作失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('批量操作失败: $e');
    }
  }

  /// 获取管理概览数据
  Future<NutritionistManagementOverview> getManagementOverview() async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.adminNutritionistManagement}/overview',
      );

      if (response.statusCode == 200) {
        return NutritionistManagementOverview.fromJson(response.data['data']);
      } else {
        throw Exception('获取管理概览失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('获取管理概览失败: $e');
    }
  }

  /// 快速搜索营养师
  Future<List<NutritionistQuickSearchResult>> searchNutritionists(
    String query, {
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.adminNutritionistManagement}/search',
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['data']['results'];
        return results
            .map((json) => NutritionistQuickSearchResult.fromJson(json))
            .toList();
      } else {
        throw Exception('搜索营养师失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('搜索营养师失败: $e');
    }
  }

  /// 导出营养师数据
  Future<Uint8List> exportNutritionists({
    String format = 'csv',
    String? status,
    String? verificationStatus,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'format': format,
      };

      if (status != null) queryParams['status'] = status;
      if (verificationStatus != null) {
        queryParams['verificationStatus'] = verificationStatus;
      }

      final response = await _dioClient.get(
        '${ApiEndpoints.adminNutritionistManagement}/export',
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('导出数据失败: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('导出数据失败: $e');
    }
  }

  /// 获取专业领域选项
  List<String> getSpecializationOptions() {
    return [
      '临床营养',
      '运动营养',
      '儿童营养',
      '老年营养',
      '慢病营养',
      '减重营养',
      '孕产妇营养',
      '功能性营养',
      '中医营养',
      '食品安全',
    ];
  }

  /// 获取状态选项
  Map<String, String> getStatusOptions() {
    return {
      'active': '活跃',
      'inactive': '不活跃',
      'suspended': '已暂停',
      'pendingVerification': '待审核',
    };
  }

  /// 获取审核状态选项
  Map<String, String> getVerificationStatusOptions() {
    return {
      'pending': '待审核',
      'approved': '已通过',
      'rejected': '已拒绝',
    };
  }

  /// 获取认证等级选项
  Map<String, String> getCertificationLevelOptions() {
    return {
      'junior': '初级',
      'intermediate': '中级',
      'senior': '高级',
      'expert': '专家',
    };
  }

  /// 获取排序选项
  Map<String, String> getSortOptions() {
    return {
      'createdAt': '注册时间',
      'updatedAt': '更新时间',
      'personalInfo.realName': '姓名',
      'ratings.averageRating': '评分',
      'onlineStatus.lastActiveAt': '最后活跃时间',
    };
  }

  /// 格式化营养师状态显示文本
  String formatStatusText(String status) {
    final statusMap = getStatusOptions();
    return statusMap[status] ?? status;
  }

  /// 格式化审核状态显示文本
  String formatVerificationStatusText(String verificationStatus) {
    final statusMap = getVerificationStatusOptions();
    return statusMap[verificationStatus] ?? verificationStatus;
  }

  /// 格式化认证等级显示文本
  String formatCertificationLevelText(String level) {
    final levelMap = getCertificationLevelOptions();
    return levelMap[level] ?? level;
  }

  /// 获取状态颜色
  String getStatusColor(String status) {
    switch (status) {
      case 'active':
        return '#4CAF50'; // 绿色
      case 'inactive':
        return '#9E9E9E'; // 灰色
      case 'suspended':
        return '#F44336'; // 红色
      case 'pendingVerification':
        return '#FF9800'; // 橙色
      default:
        return '#9E9E9E';
    }
  }

  /// 获取审核状态颜色
  String getVerificationStatusColor(String verificationStatus) {
    switch (verificationStatus) {
      case 'approved':
        return '#4CAF50'; // 绿色
      case 'rejected':
        return '#F44336'; // 红色
      case 'pending':
        return '#FF9800'; // 橙色
      default:
        return '#9E9E9E';
    }
  }

  /// 验证批量操作参数
  bool validateBatchOperation(String action, List<String> ids) {
    if (ids.isEmpty) return false;
    
    final validActions = ['updateStatus', 'setOffline', 'resetPassword'];
    return validActions.contains(action);
  }

  /// 格式化文件大小
  String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// 生成导出文件名
  String generateExportFileName(String format) {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'nutritionists_$dateStr.$format';
  }
}