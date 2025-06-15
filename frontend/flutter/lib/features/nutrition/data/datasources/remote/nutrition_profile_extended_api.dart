import 'package:dio/dio.dart';
import '../../models/nutrition_template_model.dart';

/// 营养档案扩展API接口
class NutritionProfileExtendedApi {
  final Dio _dio;
  
  NutritionProfileExtendedApi(this._dio);

  /// 获取营养档案模板
  Future<Response<Map<String, dynamic>>> getTemplates({
    String? category,
    int? page = 1,
    int? limit = 10,
  }) async {
    return await _dio.get('/templates', queryParameters: {
      if (category != null) 'category': category,
      'page': page,
      'limit': limit,
    });
  }

  /// 验证健康目标配置一致性
  Future<Response<Map<String, dynamic>>> validateHealthGoals(
    Map<String, dynamic> healthGoalsData,
  ) async {
    return await _dio.post('/validate-health-goals', data: healthGoalsData);
  }

  /// 智能冲突检测
  Future<Response<Map<String, dynamic>>> detectConflicts(
    Map<String, dynamic> profileData,
  ) async {
    return await _dio.post('/detect-conflicts', data: profileData);
  }

  /// 基于目标生成建议
  Future<Response<Map<String, dynamic>>> generateSuggestions(
    Map<String, dynamic> requestData,
  ) async {
    return await _dio.post('/generate-suggestions', data: requestData);
  }

  /// 获取批量档案建议
  Future<Response<Map<String, dynamic>>> getBatchSuggestions(
    List<Map<String, dynamic>> profiles,
  ) async {
    return await _dio.post('/batch-suggestions', data: {'profiles': profiles});
  }

  /// 档案数据标准化处理
  Future<Response<Map<String, dynamic>>> normalizeProfile(
    Map<String, dynamic> profileData,
  ) async {
    return await _dio.post('/normalize-profile', data: profileData);
  }

  /// 获取AI营养师建议
  Future<Response<Map<String, dynamic>>> getAiNutritionistAdvice(
    Map<String, dynamic> profileData,
  ) async {
    return await _dio.post('/ai-nutritionist-advice', data: profileData);
  }

  /// 获取健康分析报告
  Future<Response<Map<String, dynamic>>> getHealthAnalysis(
    Map<String, dynamic> profileData,
  ) async {
    return await _dio.post('/health-analysis', data: profileData);
  }

  /// 获取冲突解决建议
  Future<Response<Map<String, dynamic>>> resolveConflicts(
    Map<String, dynamic> conflictData,
  ) async {
    return await _dio.post('/resolve-conflicts', data: conflictData);
  }
}

/// 营养档案扩展API服务类
/// 提供更便捷的API调用方法和错误处理
class NutritionProfileExtendedApiService {
  final NutritionProfileExtendedApi _api;
  
  NutritionProfileExtendedApiService(this._api);
  
  /// 获取营养档案模板
  Future<List<Map<String, dynamic>>> getTemplates({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _api.getTemplates(
        category: category,
        page: page,
        limit: limit,
      );
      
      final data = response.data;
      if (data != null && data['code'] == 200 && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']['templates'] ?? []);
      }
      
      // 如果没有真实数据，返回模拟数据
      return _getMockTemplates();
    } on DioException catch (e) {
      // 开发阶段返回模拟数据
      return _getMockTemplates();
    }
  }
  
  /// 验证健康目标配置
  Future<Map<String, dynamic>> validateHealthGoals(Map<String, dynamic> healthGoals) async {
    try {
      final response = await _api.validateHealthGoals(healthGoals);
      
      final data = response.data;
      if (data != null && data['code'] == 200 && data['data'] != null) {
        return data['data'];
      }
      
      throw Exception(data?['message'] ?? '验证失败');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  /// 智能冲突检测
  Future<Map<String, dynamic>> detectConflicts(Map<String, dynamic> profileData) async {
    try {
      final response = await _api.detectConflicts(profileData);
      
      final data = response.data;
      if (data != null && data['code'] == 200 && data['data'] != null) {
        return data['data'];
      }
      
      // 返回模拟数据
      return _getMockConflictResult();
    } on DioException catch (e) {
      // 开发阶段返回模拟数据
      return _getMockConflictResult();
    }
  }
  
  /// 基于目标生成建议
  Future<Map<String, dynamic>> generateSuggestions(Map<String, dynamic> requestData) async {
    try {
      final response = await _api.generateSuggestions(requestData);
      
      final data = response.data;
      if (data != null && data['code'] == 200 && data['data'] != null) {
        return data['data'];
      }
      
      throw Exception(data?['message'] ?? '生成建议失败');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  /// 处理Dio错误
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '网络连接超时';
      case DioExceptionType.connectionError:
        return '网络连接错误';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'];
        return message ?? '请求失败 ($statusCode)';
      default:
        return '网络错误: ${error.message}';
    }
  }

  /// 获取模拟模板数据
  List<Map<String, dynamic>> _getMockTemplates() {
    return [
      {
        'key': 'weightLoss',
        'name': '减重计划',
        'description': '适合需要减重的用户',
        'icon_name': 'trending_down',
        'recommended_for': ['减重', 'BMI超标'],
        'data': {
          'profileName': '减重计划',
          'gender': 'female',
          'ageGroup': '26to35',
          'height': 165.0,
          'weight': 70.0,
          'healthGoal': 'loseWeight',
          'targetCalories': 1500.0,
          'dietaryPreferences': ['lowCarb'],
          'medicalConditions': [],
          'exerciseFrequency': 'daily',
          'nutritionPreferences': [],
          'specialStatus': [],
          'forbiddenIngredients': [],
          'allergies': [],
          'activityDetails': {
            'activityLevelDetail': '30_to_60min',
          },
          'healthGoalDetails': {
            'targetWeight': 60.0,
            'timeframe': '3_months',
          },
        },
      },
      {
        'key': 'fitness',
        'name': '健身增肌',
        'description': '适合健身爱好者',
        'icon_name': 'fitness_center',
        'recommended_for': ['增肌', '运动员'],
        'data': {
          'profileName': '健身增肌',
          'gender': 'male',
          'ageGroup': '18to25',
          'height': 175.0,
          'weight': 70.0,
          'healthGoal': 'gainMuscle',
          'targetCalories': 2800.0,
          'dietaryPreferences': ['highProtein'],
          'medicalConditions': [],
          'exerciseFrequency': 'daily',
          'nutritionPreferences': [],
          'specialStatus': [],
          'forbiddenIngredients': [],
          'allergies': [],
          'activityDetails': {
            'activityLevelDetail': 'over_60min',
          },
          'healthGoalDetails': {
            'targetWeight': 80.0,
            'timeframe': '6_months',
          },
        },
      },
      {
        'key': 'diabetic',
        'name': '糖尿病管理',
        'description': '适合糖尿病患者',
        'icon_name': 'medical_services',
        'recommended_for': ['糖尿病', '血糖控制'],
        'data': {
          'profileName': '糖尿病管理',
          'gender': 'male',
          'ageGroup': '46to55',
          'height': 170.0,
          'weight': 75.0,
          'healthGoal': 'manageDisease',
          'targetCalories': 1800.0,
          'dietaryPreferences': ['lowSugar', 'lowCarb'],
          'medicalConditions': ['diabetes'],
          'exerciseFrequency': 'moderate',
          'nutritionPreferences': [],
          'specialStatus': [],
          'forbiddenIngredients': ['sugar'],
          'allergies': [],
          'activityDetails': {
            'activityLevelDetail': '30_to_60min',
          },
          'healthGoalDetails': {
            'targetBloodSugar': 6.5,
            'timeframe': 'ongoing',
          },
        },
      },
    ];
  }

  /// 获取模拟冲突检测结果
  Map<String, dynamic> _getMockConflictResult() {
    return {
      'success': true,
      'has_conflicts': false,
      'conflicts': [],
    };
  }
}

/// 自定义HttpResponse类（用于兼容）
class HttpResponse<T> {
  final T data;
  final Response response;

  HttpResponse(this.data, this.response);
}