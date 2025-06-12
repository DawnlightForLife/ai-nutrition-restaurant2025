import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/nutritionist_certification.dart';
import '../models/nutritionist_certification_model.dart';

/// 营养师认证服务
/// 处理营养师认证相关的API调用
class NutritionistCertificationService {
  final ApiClient _apiClient;

  NutritionistCertificationService(this._apiClient);

  /// 创建认证申请
  Future<NutritionistCertification> createApplication(
    Map<String, dynamic> data,
  ) async {
    try {
      print('[DEBUG] NutritionistCertificationService.createApplication() called');
      print('[DEBUG] Data: $data');
      print('[DEBUG] Endpoint: ${ApiEndpoints.nutritionistCertificationApplications}');
      
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.nutritionistCertificationApplications,
        data: data,
      );
      print('[DEBUG] Response received: ${response.data}');
      
      final model = NutritionistCertificationModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      final entity = model.toEntity();
      print('[DEBUG] Entity created: ${entity.id}');
      return entity;
    } catch (e) {
      print('[DEBUG] Error in createApplication: $e');
      throw _handleError(e);
    }
  }

  /// 创建认证申请（直接使用Map数据）
  Future<NutritionistCertification> createApplicationFromMap(
    Map<String, dynamic> data,
  ) async {
    // 转换前端数据格式为后端期望格式
    final transformedData = _transformFormDataToApiFormat(data);
    return createApplication(transformedData);
  }

  /// 更新认证申请
  Future<NutritionistCertification> updateApplication(
    String applicationId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.nutritionistCertificationDetail.replaceAll('{id}', applicationId),
        data: data,
      );
      final model = NutritionistCertificationModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      return model.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 更新认证申请（直接使用Map数据）
  Future<NutritionistCertification> updateApplicationFromMap(
    String applicationId,
    Map<String, dynamic> data,
  ) async {
    // 转换前端数据格式为后端期望格式
    final transformedData = _transformFormDataToApiFormat(data);
    return updateApplication(applicationId, transformedData);
  }

  /// 提交认证申请
  Future<NutritionistCertification> submitApplication(
    String applicationId,
  ) async {
    try {
      print('[DEBUG] NutritionistCertificationService.submitApplication() called');
      print('[DEBUG] Application ID: $applicationId');
      
      final endpoint = ApiEndpoints.nutritionistCertificationSubmit.replaceAll('{id}', applicationId);
      print('[DEBUG] Submit endpoint: $endpoint');
      
      final response = await _apiClient.post<Map<String, dynamic>>(
        endpoint,
      );
      print('[DEBUG] Submit response received: ${response.data}');
      
      final model = NutritionistCertificationModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      final entity = model.toEntity();
      print('[DEBUG] Submit entity created: ${entity.id}');
      return entity;
    } catch (e) {
      print('[DEBUG] Error in submitApplication: $e');
      throw _handleError(e);
    }
  }

  /// 获取用户的认证申请列表
  Future<List<NutritionistCertification>> getUserApplications() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.nutritionistCertificationApplications,
      );
      final List<dynamic> data = response.data!['data'] as List<dynamic>;
      return data
          .map((json) => NutritionistCertificationModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取认证申请详情
  Future<NutritionistCertification> getApplicationDetail(
    String applicationId,
  ) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.nutritionistCertificationDetail.replaceAll('{id}', applicationId),
      );
      final model = NutritionistCertificationModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      return model.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 上传文档
  Future<Map<String, dynamic>> uploadDocument(
    String applicationId,
    String documentType,
    String filePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'documentType': documentType,
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post<Map<String, dynamic>>(
        '${ApiEndpoints.nutritionistCertificationApplications}/$applicationId/documents',
        data: formData,
      );
      return response.data!['data'] as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 删除文档
  Future<void> deleteDocument(
    String applicationId,
    String documentType,
  ) async {
    try {
      await _apiClient.delete<void>(
        '${ApiEndpoints.nutritionistCertificationApplications}/$applicationId/documents/$documentType',
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取认证常量
  Future<Map<String, dynamic>> getCertificationConstants() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.nutritionistCertificationConstants,
      );
      return response.data!['data'] as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 转换前端表单数据为后端API期望的格式
  Map<String, dynamic> _transformFormDataToApiFormat(Map<String, dynamic> formData) {
    print('[DEBUG] Transforming form data: $formData');
    
    // 提取各部分数据
    final personalInfo = formData['personalInfo'] as Map<String, dynamic>? ?? {};
    final education = formData['education'] as Map<String, dynamic>? ?? {};
    final certificationInfo = formData['certificationInfo'] as Map<String, dynamic>? ?? {};
    final documents = formData['documents'] as List<Map<String, dynamic>>? ?? [];
    
    // 构建后端期望的数据结构
    final transformedData = <String, dynamic>{
      'personalInfo': {
        'fullName': personalInfo['fullName']?.toString() ?? '',
        'idNumber': personalInfo['idNumber']?.toString() ?? '',
        'phone': personalInfo['phone']?.toString() ?? '',
      },
      'certificationInfo': {
        'specializationAreas': (certificationInfo['specializationAreas'] as List<dynamic>?)?.cast<String>() ?? [],
        'workYearsInNutrition': certificationInfo['workYearsInNutrition'] as int? ?? 0,
      },
      'documents': documents.map((doc) => {
        'documentType': doc['documentType']?.toString() ?? '',
        'fileName': doc['fileName']?.toString() ?? '',
        'fileUrl': doc['fileUrl']?.toString() ?? '',
        'fileSize': doc['fileSize'] as int? ?? 0,
        'mimeType': doc['mimeType']?.toString() ?? '',
      }).toList(),
    };
    
    // 可选：包含教育信息（如果后端也需要）
    if (education.isNotEmpty) {
      transformedData['education'] = {
        'degree': education['degree']?.toString(),
        'major': education['major']?.toString(),
        'school': education['school']?.toString(),
      };
    }
    
    print('[DEBUG] Transformed data: $transformedData');
    return transformedData;
  }

  /// 处理错误
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data['message'] ?? error.message;
      return Exception(message);
    }
    return Exception('未知错误: $error');
  }
}

/// 营养师认证服务提供者
final nutritionistCertificationServiceProvider = Provider<NutritionistCertificationService>((ref) {
  final apiClient = ApiClient();
  return NutritionistCertificationService(apiClient);
});