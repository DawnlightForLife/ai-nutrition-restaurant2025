import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ai_service_interface.dart';

/// OpenAI服务实现
/// 基于OpenAI GPT模型的AI服务提供者
/// 用作备用AI服务或对比测试
class OpenAIService implements AIServiceInterface {
  bool _isInitialized = false;
  late http.Client _httpClient;
  
  // OpenAI配置
  static const String _baseUrl = 'https://api.openai.com/v1';
  String _apiKey = '';
  String _model = 'gpt-3.5-turbo'; // 默认模型
  
  // 营养专业提示词模板
  static const String _nutritionSystemPrompt = '''
你是一位专业的注册营养师，具有丰富的临床营养经验。
请基于科学的营养学原理为用户提供专业、准确、实用的营养建议。
回复应该：
1. 基于科学证据
2. 考虑个体差异
3. 提供具体可行的建议
4. 使用专业但易懂的语言
5. 必要时建议咨询医生

请用中文回复。
''';

  @override
  String get providerName => 'openai';

  @override
  bool get isAvailable => _isInitialized && _apiKey.isNotEmpty;

  @override
  Future<void> initialize() async {
    debugPrint('正在初始化OpenAI服务...');
    
    try {
      _httpClient = http.Client();
      
      // 从配置加载API密钥
      await _loadConfiguration();
      
      // 测试API连接
      if (_apiKey.isNotEmpty) {
        await _testConnection();
      }
      
      _isInitialized = true;
      debugPrint('OpenAI服务初始化完成');
    } catch (e) {
      debugPrint('OpenAI服务初始化失败: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
    _isInitialized = false;
    debugPrint('OpenAI服务已释放');
  }

  @override
  Future<NutritionPlanResponse> generateNutritionPlan({
    required ClientInfo clientInfo,
    required NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  }) async {
    if (!isAvailable) {
      return NutritionPlanResponse(
        success: false,
        error: 'OpenAI服务不可用',
      );
    }

    try {
      final prompt = _buildNutritionPlanPrompt(
        clientInfo, 
        nutritionGoals, 
        preferences, 
        restrictions
      );
      
      final response = await _generateCompletion(prompt, 'nutrition_plan');
      
      if (response['success'] == true) {
        final plan = _parseNutritionPlanFromText(response['content']);
        
        return NutritionPlanResponse(
          success: true,
          plan: plan,
          metadata: {
            'model': _model,
            'generated_at': DateTime.now().toIso8601String(),
            'tokens_used': response['usage']?['total_tokens'],
          },
        );
      } else {
        return NutritionPlanResponse(
          success: false,
          error: response['error'] ?? 'OpenAI请求失败',
        );
      }
    } catch (e) {
      debugPrint('OpenAI营养方案生成失败: $e');
      return NutritionPlanResponse(
        success: false,
        error: '请求失败: $e',
      );
    }
  }

  @override
  Future<ConsultationReplyResponse> generateConsultationReply({
    required String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  }) async {
    if (!isAvailable) {
      return ConsultationReplyResponse(
        success: false,
        error: 'OpenAI服务不可用',
      );
    }

    try {
      final prompt = _buildConsultationReplyPrompt(
        question, 
        context, 
        nutritionistProfile
      );
      
      final response = await _generateCompletion(prompt, 'consultation_reply');
      
      if (response['success'] == true) {
        final reply = response['content'];
        
        return ConsultationReplyResponse(
          success: true,
          reply: reply,
          suggestions: _extractSuggestions(reply),
          tone: 'professional',
          metadata: {
            'model': _model,
            'generated_at': DateTime.now().toIso8601String(),
            'tokens_used': response['usage']?['total_tokens'],
          },
        );
      } else {
        return ConsultationReplyResponse(
          success: false,
          error: response['error'] ?? 'OpenAI请求失败',
        );
      }
    } catch (e) {
      debugPrint('OpenAI咨询回复生成失败: $e');
      return ConsultationReplyResponse(
        success: false,
        error: '请求失败: $e',
      );
    }
  }

  @override
  Future<DietAnalysisResponse> analyzeDiet({
    required List<FoodRecord> foodRecords,
    DietAnalysisType analysisType = DietAnalysisType.comprehensive,
  }) async {
    if (!isAvailable) {
      return DietAnalysisResponse(
        success: false,
        error: 'OpenAI服务不可用',
      );
    }

    try {
      final prompt = _buildDietAnalysisPrompt(foodRecords, analysisType);
      
      final response = await _generateCompletion(prompt, 'diet_analysis');
      
      if (response['success'] == true) {
        final analysis = _parseDietAnalysisFromText(response['content']);
        
        return DietAnalysisResponse(
          success: true,
          analysis: analysis,
          metadata: {
            'model': _model,
            'analysis_type': analysisType.name,
            'generated_at': DateTime.now().toIso8601String(),
            'tokens_used': response['usage']?['total_tokens'],
          },
        );
      } else {
        return DietAnalysisResponse(
          success: false,
          error: response['error'] ?? 'OpenAI请求失败',
        );
      }
    } catch (e) {
      debugPrint('OpenAI饮食分析失败: $e');
      return DietAnalysisResponse(
        success: false,
        error: '请求失败: $e',
      );
    }
  }

  @override
  Future<RecipeResponse> generateRecipe({
    required RecipeRequirements requirements,
  }) async {
    if (!isAvailable) {
      return RecipeResponse(
        success: false,
        error: 'OpenAI服务不可用',
      );
    }

    try {
      final prompt = _buildRecipePrompt(requirements);
      
      final response = await _generateCompletion(prompt, 'recipe_generation');
      
      if (response['success'] == true) {
        final recipe = _parseRecipeFromText(response['content']);
        
        return RecipeResponse(
          success: true,
          recipe: recipe,
          metadata: {
            'model': _model,
            'generated_at': DateTime.now().toIso8601String(),
            'tokens_used': response['usage']?['total_tokens'],
          },
        );
      } else {
        return RecipeResponse(
          success: false,
          error: response['error'] ?? 'OpenAI请求失败',
        );
      }
    } catch (e) {
      debugPrint('OpenAI食谱生成失败: $e');
      return RecipeResponse(
        success: false,
        error: '请求失败: $e',
      );
    }
  }

  @override
  Stream<String> streamChat({
    required List<ChatMessage> messages,
    required AIAssistantType assistantType,
  }) async* {
    if (!isAvailable) {
      yield 'OpenAI服务不可用';
      return;
    }

    try {
      final systemPrompt = _getSystemPromptForAssistantType(assistantType);
      final chatMessages = [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map((msg) => {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.content,
        }),
      ];

      final requestBody = {
        'model': _model,
        'messages': chatMessages,
        'stream': true,
        'max_tokens': 1000,
        'temperature': 0.7,
      };

      final request = http.Request('POST', Uri.parse('$_baseUrl/chat/completions'));
      request.headers.addAll(_getHeaders());
      request.body = jsonEncode(requestBody);

      final streamedResponse = await _httpClient.send(request);
      
      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          final lines = chunk.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data.trim() != '[DONE]' && data.trim().isNotEmpty) {
                try {
                  final json = jsonDecode(data);
                  final delta = json['choices']?[0]?['delta']?['content'];
                  if (delta != null) {
                    yield delta;
                  }
                } catch (e) {
                  // 忽略JSON解析错误
                }
              }
            }
          }
        }
      } else {
        yield 'OpenAI流式聊天请求失败: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      yield 'OpenAI流式聊天连接失败: $e';
    }
  }

  @override
  AICapabilities get capabilities => AICapabilities(
    supportsNutritionPlanning: true,
    supportsConsultationReply: true,
    supportsDietAnalysis: true,
    supportsRecipeGeneration: true,
    supportsStreamingChat: true,
    supportedLanguages: ['zh-CN', 'en-US', 'ja-JP', 'ko-KR'],
    additionalCapabilities: {
      'openai_gpt': true,
      'multilingual': true,
      'general_knowledge': true,
    },
  );

  // 配置方法

  Future<void> updateApiKey(String apiKey) async {
    _apiKey = apiKey;
    if (_isInitialized) {
      try {
        await _testConnection();
        debugPrint('OpenAI API密钥已更新');
      } catch (e) {
        debugPrint('API密钥更新后连接测试失败: $e');
      }
    }
  }

  void updateModel(String model) {
    _model = model;
    debugPrint('OpenAI模型已切换到: $model');
  }

  // 私有方法

  Future<void> _loadConfiguration() async {
    // TODO: 从安全存储加载API密钥
    // 注意：生产环境中应该从环境变量或安全存储加载
    
    // 示例：从环境变量加载
    // _apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';
    
    // 临时示例配置
    _apiKey = ''; // 需要配置真实的API密钥
  }

  Future<void> _testConnection() async {
    if (_apiKey.isEmpty) {
      throw AIServiceException(message: 'OpenAI API密钥未配置');
    }

    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/models'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw AIServiceException(
          message: 'OpenAI API连接失败',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw AIServiceException(message: 'OpenAI连接测试失败: $e');
    }
  }

  Future<Map<String, dynamic>> _generateCompletion(String prompt, String type) async {
    try {
      final requestBody = {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': _nutritionSystemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 2000,
        'temperature': 0.7,
      };

      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/chat/completions'),
            headers: _getHeaders(),
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'] ?? '';
        
        return {
          'success': true,
          'content': content,
          'usage': data['usage'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['error']?['message'] ?? 'OpenAI API错误',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'OpenAI请求异常: $e',
      };
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
  }

  String _getSystemPromptForAssistantType(AIAssistantType assistantType) {
    switch (assistantType) {
      case AIAssistantType.nutritionPlan:
        return '$_nutritionSystemPrompt\n专注于制定个性化营养方案。';
      case AIAssistantType.consultationReply:
        return '$_nutritionSystemPrompt\n专注于回复客户的营养咨询问题。';
      case AIAssistantType.dietAnalysis:
        return '$_nutritionSystemPrompt\n专注于分析饮食记录和营养状况。';
      case AIAssistantType.recipeGenerator:
        return '$_nutritionSystemPrompt\n专注于生成健康营养的食谱。';
      default:
        return _nutritionSystemPrompt;
    }
  }

  // 提示词构建方法

  String _buildNutritionPlanPrompt(
    ClientInfo clientInfo,
    NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  ) {
    return '''
请为以下客户制定个性化营养方案：

客户信息：
- 年龄：${clientInfo.age}岁
- 性别：${clientInfo.gender}
- 身高：${clientInfo.height}cm
- 体重：${clientInfo.weight}kg
- 活动水平：${clientInfo.activityLevel ?? '中等'}
- 健康状况：${clientInfo.healthConditions?.join(', ') ?? '良好'}

营养目标：
- 主要目标：${nutritionGoals.primaryGoal}
- 目标体重：${nutritionGoals.targetWeight ?? '保持当前'}kg
- 时间框架：${nutritionGoals.timeframe ?? '长期'}天

饮食偏好：${preferences?.join(', ') ?? '无特殊偏好'}
饮食限制：${restrictions?.join(', ') ?? '无特殊限制'}

请提供：
1. 每日营养目标（热量、蛋白质、脂肪、碳水化合物）
2. 三餐及加餐的具体搭配建议
3. 营养建议和注意事项

请以结构化的格式回复。
''';
  }

  String _buildConsultationReplyPrompt(
    String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  ) {
    return '''
客户咨询问题：$question

${context != null ? '背景信息：$context' : ''}

${nutritionistProfile != null ? 
  '营养师信息：${nutritionistProfile.name}，专业领域：${nutritionistProfile.specialization}，经验：${nutritionistProfile.yearsOfExperience}年' 
  : ''}

请以专业营养师的身份回复这个问题，提供准确、实用的建议。
回复应该专业但易懂，体现关怀和专业性。
''';
  }

  String _buildDietAnalysisPrompt(
    List<FoodRecord> foodRecords,
    DietAnalysisType analysisType,
  ) {
    final recordsText = foodRecords.map((record) {
      final foodsText = record.foods.map((food) => 
        '${food.name} ${food.quantity}${food.unit}').join(', ');
      return '${record.mealType}：$foodsText';
    }).join('\n');

    return '''
请分析以下饮食记录：

$recordsText

分析类型：${analysisType.name}

请提供：
1. 营养摄入总结（热量、蛋白质、脂肪、碳水化合物等）
2. 饮食优点
3. 存在的问题
4. 改善建议

请以结构化的格式回复。
''';
  }

  String _buildRecipePrompt(RecipeRequirements requirements) {
    return '''
请生成一个健康食谱，要求如下：

- 菜系：${requirements.cuisine ?? '不限'}
- 餐次：${requirements.mealType ?? '不限'}
- 份量：${requirements.servings ?? 2}人份
- 准备时间：${requirements.preparationTime ?? '不限'}分钟内
- 难度：${requirements.difficulty ?? '中等'}
- 包含食材：${requirements.includedIngredients?.join(', ') ?? '不限'}
- 避免食材：${requirements.excludedIngredients?.join(', ') ?? '无'}
- 饮食限制：${requirements.dietaryRestrictions?.join(', ') ?? '无'}

请提供：
1. 食谱名称和描述
2. 所需食材和用量
3. 详细制作步骤
4. 营养价值分析
5. 制作小贴士

请以结构化的格式回复。
''';
  }

  // 文本解析方法（简化实现）

  NutritionPlan _parseNutritionPlanFromText(String text) {
    // 这里是简化的解析实现
    // 实际应用中可能需要更复杂的文本解析逻辑
    return NutritionPlan(
      id: 'openai_plan_${DateTime.now().millisecondsSinceEpoch}',
      title: '个性化营养方案',
      description: text.split('\n').first,
      dailyNutritionTargets: {
        'calories': 1800.0,
        'protein': 90.0,
        'fat': 60.0,
        'carbs': 225.0,
      },
      mealPlans: [], // 简化实现
      recommendations: ['请遵循营养师建议'],
      notes: ['基于OpenAI GPT生成'],
    );
  }

  DietAnalysis _parseDietAnalysisFromText(String text) {
    return DietAnalysis(
      nutritionSummary: {
        'calories': 1800.0,
        'protein': 75.0,
        'fat': 65.0,
        'carbs': 200.0,
      },
      strengths: ['营养均衡'],
      weaknesses: ['需要改善'],
      recommendations: ['增加蔬菜摄入'],
      detailedAnalysis: {'summary': text},
    );
  }

  Recipe _parseRecipeFromText(String text) {
    return Recipe(
      id: 'openai_recipe_${DateTime.now().millisecondsSinceEpoch}',
      name: '健康食谱',
      description: text.split('\n').first,
      ingredients: [],
      instructions: ['按照AI建议制作'],
      preparationTime: 30,
      cookingTime: 20,
      servings: 2,
      difficulty: 'medium',
      nutrition: {},
    );
  }

  List<String> _extractSuggestions(String reply) {
    // 简化实现：从回复中提取建议
    return ['定期跟进', '保持联系'];
  }
}