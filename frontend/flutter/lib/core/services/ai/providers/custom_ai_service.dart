import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ai_service_interface.dart';

/// 自定义AI服务实现
/// 连接到您训练的专用营养AI模型
/// 支持热更换API端点和模型版本
class CustomAIService implements AIServiceInterface {
  bool _isInitialized = false;
  late http.Client _httpClient;
  
  // 可配置的服务端点
  String _baseUrl = 'http://localhost:8000/api/v1'; // 默认本地服务
  String _apiKey = '';
  String _modelVersion = 'v1.0';
  
  // 配置选项
  final Map<String, dynamic> _config = {
    'timeout': 30000, // 30秒超时
    'max_retries': 3,
    'retry_delay': 1000, // 1秒重试延迟
  };

  @override
  String get providerName => 'custom';

  @override
  bool get isAvailable => _isInitialized;

  @override
  Future<void> initialize() async {
    debugPrint('正在初始化自定义AI服务...');
    
    try {
      _httpClient = http.Client();
      
      // 从配置中加载服务端点
      await _loadConfiguration();
      
      // 测试服务连接
      await _testConnection();
      
      _isInitialized = true;
      debugPrint('自定义AI服务初始化完成');
    } catch (e) {
      debugPrint('自定义AI服务初始化失败: $e');
      // 如果初始化失败，仍然标记为已初始化但不可用
      // 这样可以在后续尝试重新连接
      _isInitialized = false;
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
    _isInitialized = false;
    debugPrint('自定义AI服务已释放');
  }

  @override
  Future<NutritionPlanResponse> generateNutritionPlan({
    required ClientInfo clientInfo,
    required NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  }) async {
    if (!_isInitialized) {
      return NutritionPlanResponse(
        success: false,
        error: '服务未初始化',
      );
    }

    try {
      final requestBody = {
        'action': 'generate_nutrition_plan',
        'client_info': clientInfo.toJson(),
        'nutrition_goals': nutritionGoals.toJson(),
        'preferences': preferences ?? [],
        'restrictions': restrictions ?? [],
        'model_version': _modelVersion,
      };

      final response = await _makeRequest('/nutrition/plan', requestBody);
      
      if (response['success'] == true) {
        final planData = response['data'];
        final plan = _parseNutritionPlan(planData);
        
        return NutritionPlanResponse(
          success: true,
          plan: plan,
          metadata: response['metadata'],
        );
      } else {
        return NutritionPlanResponse(
          success: false,
          error: response['error'] ?? '生成营养方案失败',
        );
      }
    } catch (e) {
      debugPrint('生成营养方案请求失败: $e');
      return NutritionPlanResponse(
        success: false,
        error: '网络请求失败: $e',
      );
    }
  }

  @override
  Future<ConsultationReplyResponse> generateConsultationReply({
    required String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  }) async {
    if (!_isInitialized) {
      return ConsultationReplyResponse(
        success: false,
        error: '服务未初始化',
      );
    }

    try {
      final requestBody = {
        'action': 'generate_consultation_reply',
        'question': question,
        'context': context,
        'nutritionist_profile': nutritionistProfile?.toJson(),
        'model_version': _modelVersion,
      };

      final response = await _makeRequest('/consultation/reply', requestBody);
      
      if (response['success'] == true) {
        final data = response['data'];
        
        return ConsultationReplyResponse(
          success: true,
          reply: data['reply'],
          suggestions: List<String>.from(data['suggestions'] ?? []),
          tone: data['tone'],
          metadata: response['metadata'],
        );
      } else {
        return ConsultationReplyResponse(
          success: false,
          error: response['error'] ?? '生成咨询回复失败',
        );
      }
    } catch (e) {
      debugPrint('生成咨询回复请求失败: $e');
      return ConsultationReplyResponse(
        success: false,
        error: '网络请求失败: $e',
      );
    }
  }

  @override
  Future<DietAnalysisResponse> analyzeDiet({
    required List<FoodRecord> foodRecords,
    DietAnalysisType analysisType = DietAnalysisType.comprehensive,
  }) async {
    if (!_isInitialized) {
      return DietAnalysisResponse(
        success: false,
        error: '服务未初始化',
      );
    }

    try {
      final requestBody = {
        'action': 'analyze_diet',
        'food_records': foodRecords.map((record) => record.toJson()).toList(),
        'analysis_type': analysisType.name,
        'model_version': _modelVersion,
      };

      final response = await _makeRequest('/diet/analysis', requestBody);
      
      if (response['success'] == true) {
        final analysisData = response['data'];
        final analysis = _parseDietAnalysis(analysisData);
        
        return DietAnalysisResponse(
          success: true,
          analysis: analysis,
          metadata: response['metadata'],
        );
      } else {
        return DietAnalysisResponse(
          success: false,
          error: response['error'] ?? '饮食分析失败',
        );
      }
    } catch (e) {
      debugPrint('饮食分析请求失败: $e');
      return DietAnalysisResponse(
        success: false,
        error: '网络请求失败: $e',
      );
    }
  }

  @override
  Future<RecipeResponse> generateRecipe({
    required RecipeRequirements requirements,
  }) async {
    if (!_isInitialized) {
      return RecipeResponse(
        success: false,
        error: '服务未初始化',
      );
    }

    try {
      final requestBody = {
        'action': 'generate_recipe',
        'requirements': requirements.toJson(),
        'model_version': _modelVersion,
      };

      final response = await _makeRequest('/recipe/generate', requestBody);
      
      if (response['success'] == true) {
        final recipeData = response['data'];
        final recipe = _parseRecipe(recipeData);
        
        return RecipeResponse(
          success: true,
          recipe: recipe,
          metadata: response['metadata'],
        );
      } else {
        return RecipeResponse(
          success: false,
          error: response['error'] ?? '生成食谱失败',
        );
      }
    } catch (e) {
      debugPrint('生成食谱请求失败: $e');
      return RecipeResponse(
        success: false,
        error: '网络请求失败: $e',
      );
    }
  }

  @override
  Stream<String> streamChat({
    required List<ChatMessage> messages,
    required AIAssistantType assistantType,
  }) async* {
    if (!_isInitialized) {
      yield '服务未初始化';
      return;
    }

    try {
      final requestBody = {
        'action': 'stream_chat',
        'messages': messages.map((msg) => msg.toJson()).toList(),
        'assistant_type': assistantType.name,
        'model_version': _modelVersion,
        'stream': true,
      };

      final request = http.Request('POST', Uri.parse('$_baseUrl/chat/stream'));
      request.headers.addAll(_getHeaders());
      request.body = jsonEncode(requestBody);

      final streamedResponse = await _httpClient.send(request);
      
      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          // 处理服务端发送的流式数据
          final lines = chunk.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data.trim().isNotEmpty && data != '[DONE]') {
                try {
                  final json = jsonDecode(data);
                  if (json['delta'] != null) {
                    yield json['delta'];
                  }
                } catch (e) {
                  // 忽略JSON解析错误
                }
              }
            }
          }
        }
      } else {
        yield '流式聊天请求失败: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      yield '流式聊天连接失败: $e';
    }
  }

  @override
  AICapabilities get capabilities => AICapabilities(
    supportsNutritionPlanning: true,
    supportsConsultationReply: true,
    supportsDietAnalysis: true,
    supportsRecipeGeneration: true,
    supportsStreamingChat: true,
    supportedLanguages: ['zh-CN', 'en-US'],
    additionalCapabilities: {
      'custom_model': true,
      'hot_swap': true,
      'version_control': true,
      'real_time_training': false, // 可根据实际情况调整
    },
  );

  // 配置和管理方法

  /// 更新服务配置
  Future<void> updateConfiguration({
    String? baseUrl,
    String? apiKey,
    String? modelVersion,
    Map<String, dynamic>? additionalConfig,
  }) async {
    if (baseUrl != null) _baseUrl = baseUrl;
    if (apiKey != null) _apiKey = apiKey;
    if (modelVersion != null) _modelVersion = modelVersion;
    if (additionalConfig != null) _config.addAll(additionalConfig);
    
    // 重新测试连接
    try {
      await _testConnection();
      debugPrint('自定义AI服务配置已更新');
    } catch (e) {
      debugPrint('配置更新后连接测试失败: $e');
    }
  }

  /// 获取当前配置
  Map<String, dynamic> getCurrentConfiguration() {
    return {
      'base_url': _baseUrl,
      'model_version': _modelVersion,
      'config': Map.from(_config),
      'is_initialized': _isInitialized,
    };
  }

  /// 热更换模型版本
  Future<bool> switchModelVersion(String newVersion) async {
    final oldVersion = _modelVersion;
    _modelVersion = newVersion;
    
    try {
      await _testConnection();
      debugPrint('已切换到模型版本: $newVersion');
      return true;
    } catch (e) {
      _modelVersion = oldVersion; // 回滚
      debugPrint('切换模型版本失败: $e');
      return false;
    }
  }

  // 私有方法

  Future<void> _loadConfiguration() async {
    // TODO: 从配置文件或环境变量加载配置
    // 这里可以添加从本地存储、配置文件或远程配置服务加载设置的逻辑
    
    // 示例配置
    const config = {
      'base_url': 'http://localhost:8000/api/v1',
      'api_key': 'your-api-key-here',
      'model_version': 'v1.0',
    };
    
    _baseUrl = config['base_url'] ?? _baseUrl;
    _apiKey = config['api_key'] ?? _apiKey;
    _modelVersion = config['model_version'] ?? _modelVersion;
  }

  Future<void> _testConnection() async {
    try {
      final response = await _makeRequest('/health', {'action': 'ping'});
      if (response['status'] != 'ok') {
        throw AIServiceException(message: '服务健康检查失败');
      }
    } catch (e) {
      throw AIServiceException(message: '连接测试失败: $e');
    }
  }

  Future<Map<String, dynamic>> _makeRequest(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = _getHeaders();
    
    int retries = 0;
    const maxRetries = 3;
    
    while (retries < maxRetries) {
      try {
        final response = await _httpClient
            .post(uri, headers: headers, body: jsonEncode(body))
            .timeout(Duration(milliseconds: _config['timeout']));
        
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          throw AIServiceException(
            message: '请求失败: ${response.statusCode}',
            code: response.statusCode.toString(),
          );
        }
      } catch (e) {
        retries++;
        if (retries < maxRetries) {
          await Future.delayed(Duration(milliseconds: _config['retry_delay']));
        } else {
          rethrow;
        }
      }
    }
    
    throw AIServiceException(message: '达到最大重试次数');
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
      'X-Model-Version': _modelVersion,
      'User-Agent': 'NutritionApp/1.0',
    };
  }

  // 数据解析方法

  NutritionPlan _parseNutritionPlan(Map<String, dynamic> data) {
    return NutritionPlan(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dailyNutritionTargets: Map<String, double>.from(data['daily_nutrition_targets'] ?? {}),
      mealPlans: (data['meal_plans'] as List? ?? [])
          .map((plan) => _parseMealPlan(plan))
          .toList(),
      recommendations: List<String>.from(data['recommendations'] ?? []),
      notes: List<String>.from(data['notes'] ?? []),
    );
  }

  MealPlan _parseMealPlan(Map<String, dynamic> data) {
    return MealPlan(
      mealType: data['meal_type'] ?? '',
      description: data['description'] ?? '',
      foods: List<String>.from(data['foods'] ?? []),
      nutrition: Map<String, double>.from(data['nutrition'] ?? {}),
      preparationTips: data['preparation_tips'],
    );
  }

  DietAnalysis _parseDietAnalysis(Map<String, dynamic> data) {
    return DietAnalysis(
      nutritionSummary: Map<String, double>.from(data['nutrition_summary'] ?? {}),
      strengths: List<String>.from(data['strengths'] ?? []),
      weaknesses: List<String>.from(data['weaknesses'] ?? []),
      recommendations: List<String>.from(data['recommendations'] ?? []),
      detailedAnalysis: Map<String, dynamic>.from(data['detailed_analysis'] ?? {}),
    );
  }

  Recipe _parseRecipe(Map<String, dynamic> data) {
    return Recipe(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      ingredients: (data['ingredients'] as List? ?? [])
          .map((ing) => _parseIngredient(ing))
          .toList(),
      instructions: List<String>.from(data['instructions'] ?? []),
      preparationTime: data['preparation_time'] ?? 0,
      cookingTime: data['cooking_time'] ?? 0,
      servings: data['servings'] ?? 1,
      difficulty: data['difficulty'] ?? 'medium',
      nutrition: Map<String, double>.from(data['nutrition'] ?? {}),
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
    );
  }

  Ingredient _parseIngredient(Map<String, dynamic> data) {
    return Ingredient(
      name: data['name'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      notes: data['notes'],
    );
  }
}