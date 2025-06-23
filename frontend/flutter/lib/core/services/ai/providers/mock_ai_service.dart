import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../ai_service_interface.dart';

/// 模拟AI服务实现
/// 用于开发和测试阶段，提供模拟的AI响应数据
class MockAIService implements AIServiceInterface {
  bool _isInitialized = false;
  late Random _random;

  @override
  String get providerName => 'mock';

  @override
  bool get isAvailable => _isInitialized;

  @override
  Future<void> initialize() async {
    debugPrint('正在初始化模拟AI服务...');
    _random = Random();
    // 模拟初始化延迟
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    debugPrint('模拟AI服务初始化完成');
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
    debugPrint('模拟AI服务已释放');
  }

  @override
  Future<NutritionPlanResponse> generateNutritionPlan({
    required ClientInfo clientInfo,
    required NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  }) async {
    // 模拟网络延迟
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));

    try {
      final plan = _generateMockNutritionPlan(clientInfo, nutritionGoals);
      
      return NutritionPlanResponse(
        success: true,
        plan: plan,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'version': '1.0.0',
          'provider': providerName,
        },
      );
    } catch (e) {
      return NutritionPlanResponse(
        success: false,
        error: '生成营养方案失败: $e',
      );
    }
  }

  @override
  Future<ConsultationReplyResponse> generateConsultationReply({
    required String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  }) async {
    // 模拟网络延迟
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1500)));

    try {
      final reply = _generateMockConsultationReply(question, context);
      final suggestions = _generateMockSuggestions(question);
      
      return ConsultationReplyResponse(
        success: true,
        reply: reply,
        suggestions: suggestions,
        tone: 'professional_friendly',
        metadata: {
          'confidence': 0.85 + _random.nextDouble() * 0.15,
          'generated_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      return ConsultationReplyResponse(
        success: false,
        error: '生成咨询回复失败: $e',
      );
    }
  }

  @override
  Future<DietAnalysisResponse> analyzeDiet({
    required List<FoodRecord> foodRecords,
    DietAnalysisType analysisType = DietAnalysisType.comprehensive,
  }) async {
    // 模拟网络延迟
    await Future.delayed(Duration(milliseconds: 1200 + _random.nextInt(1800)));

    try {
      final analysis = _generateMockDietAnalysis(foodRecords, analysisType);
      
      return DietAnalysisResponse(
        success: true,
        analysis: analysis,
        metadata: {
          'analysis_type': analysisType.name,
          'records_count': foodRecords.length,
          'generated_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      return DietAnalysisResponse(
        success: false,
        error: '饮食分析失败: $e',
      );
    }
  }

  @override
  Future<RecipeResponse> generateRecipe({
    required RecipeRequirements requirements,
  }) async {
    // 模拟网络延迟
    await Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(2500)));

    try {
      final recipe = _generateMockRecipe(requirements);
      
      return RecipeResponse(
        success: true,
        recipe: recipe,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'requirements': requirements.toJson(),
        },
      );
    } catch (e) {
      return RecipeResponse(
        success: false,
        error: '生成食谱失败: $e',
      );
    }
  }

  @override
  Stream<String> streamChat({
    required List<ChatMessage> messages,
    required AIAssistantType assistantType,
  }) async* {
    // 模拟流式响应
    final response = _generateMockStreamResponse(messages, assistantType);
    final words = response.split(' ');
    
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(200)));
      if (i == 0) {
        yield words[i];
      } else {
        yield ' ${words[i]}';
      }
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
      'mock_mode': true,
      'response_delay': true,
      'confidence_simulation': true,
    },
  );

  // 私有方法 - 生成模拟数据

  NutritionPlan _generateMockNutritionPlan(ClientInfo clientInfo, NutritionGoals nutritionGoals) {
    // 根据客户信息计算基础代谢率
    final bmr = _calculateBMR(clientInfo);
    final dailyCalories = bmr * 1.5; // 简化的活动系数

    return NutritionPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      title: '${clientInfo.gender == 'female' ? '女性' : '男性'}${nutritionGoals.primaryGoal == 'weight_loss' ? '减重' : '健康'}营养方案',
      description: '基于您的个人信息和目标制定的个性化营养方案',
      dailyNutritionTargets: {
        'calories': dailyCalories,
        'protein': dailyCalories * 0.20 / 4, // 20%热量来自蛋白质
        'fat': dailyCalories * 0.25 / 9, // 25%热量来自脂肪
        'carbs': dailyCalories * 0.55 / 4, // 55%热量来自碳水化合物
        'fiber': 25.0,
        'water': 2000.0, // ml
      },
      mealPlans: [
        MealPlan(
          mealType: '早餐',
          description: '营养均衡的早餐搭配',
          foods: ['燕麦粥(40g)', '香蕉(1根)', '坚果(15g)', '脱脂牛奶(200ml)'],
          nutrition: {
            'calories': dailyCalories * 0.3,
            'protein': 15.0,
            'fat': 8.0,
            'carbs': 45.0,
          },
          preparationTips: '燕麦可以提前一晚浸泡，早上加热即可食用',
        ),
        MealPlan(
          mealType: '午餐',
          description: '丰富的午餐组合',
          foods: ['糙米饭(80g)', '鸡胸肉(100g)', '西兰花(150g)', '橄榄油(5ml)'],
          nutrition: {
            'calories': dailyCalories * 0.4,
            'protein': 28.0,
            'fat': 12.0,
            'carbs': 55.0,
          },
          preparationTips: '蔬菜可以焯水后用橄榄油简单调味',
        ),
        MealPlan(
          mealType: '晚餐',
          description: '清淡的晚餐选择',
          foods: ['紫薯(100g)', '豆腐(100g)', '菠菜(100g)', '芝麻油(3ml)'],
          nutrition: {
            'calories': dailyCalories * 0.25,
            'protein': 12.0,
            'fat': 8.0,
            'carbs': 30.0,
          },
          preparationTips: '晚餐建议在睡前3小时完成',
        ),
        MealPlan(
          mealType: '加餐',
          description: '健康的零食选择',
          foods: ['苹果(1个)', '酸奶(100g)'],
          nutrition: {
            'calories': dailyCalories * 0.05,
            'protein': 3.0,
            'fat': 2.0,
            'carbs': 15.0,
          },
          preparationTips: '可以在上午或下午适量加餐',
        ),
      ],
      recommendations: [
        '每日饮水量保持在2000ml以上',
        '餐后30分钟内避免剧烈运动',
        '建议配合适量有氧运动',
        '每周监测体重变化',
        '如有不适请及时调整方案',
      ],
      notes: [
        '此方案为个性化建议，具体执行可根据实际情况调整',
        '建议定期复查身体指标',
        '如有特殊疾病请咨询医生',
      ],
    );
  }

  String _generateMockConsultationReply(String question, String? context) {
    final responses = [
      '感谢您的咨询。根据您描述的情况，我建议您首先调整饮食结构，增加优质蛋白质和新鲜蔬菜的摄入。同时，建议您保持规律的作息和适量的运动。',
      '您的问题很有代表性。针对这种情况，建议您采用少食多餐的方式，每天5-6次进食，每次适量。这样可以更好地控制血糖和体重。',
      '基于您提供的信息，我认为您需要重新评估当前的营养摄入。建议增加膳食纤维的摄入，可以选择全谷物、豆类和蔬菜作为主要食物来源。',
      '这是一个很好的问题。我建议您从以下几个方面入手：1. 调整餐食时间；2. 优化食物搭配；3. 增加水分摄入；4. 适当补充维生素和矿物质。',
    ];
    
    return responses[_random.nextInt(responses.length)];
  }

  List<String> _generateMockSuggestions(String question) {
    return [
      '建议制定详细的饮食记录',
      '可以考虑增加运动量',
      '定期监测相关指标',
      '如有疑问随时沟通',
    ];
  }

  DietAnalysis _generateMockDietAnalysis(List<FoodRecord> foodRecords, DietAnalysisType analysisType) {
    return DietAnalysis(
      nutritionSummary: {
        'total_calories': 1850.0 + _random.nextInt(400),
        'protein': 75.0 + _random.nextInt(30),
        'fat': 65.0 + _random.nextInt(20),
        'carbs': 180.0 + _random.nextInt(50),
        'fiber': 18.0 + _random.nextInt(10),
        'sodium': 2100.0 + _random.nextInt(800),
      },
      strengths: [
        '蛋白质摄入充足',
        '蔬菜种类丰富',
        '饮水量适宜',
      ],
      weaknesses: [
        '精制糖摄入偏高',
        '膳食纤维略显不足',
        '钠摄入量超标',
      ],
      recommendations: [
        '减少加工食品的摄入',
        '增加全谷物食品',
        '控制烹饪用盐量',
        '多选择新鲜水果作为甜品',
      ],
      detailedAnalysis: {
        'meal_timing': '用餐时间较规律',
        'food_diversity': '食物多样性良好',
        'hydration_status': '水分摄入充足',
        'micronutrient_status': '维生素和矿物质基本满足需求',
      },
    );
  }

  Recipe _generateMockRecipe(RecipeRequirements requirements) {
    final recipes = [
      Recipe(
        id: 'recipe_${DateTime.now().millisecondsSinceEpoch}',
        name: '彩虹蔬菜沙拉',
        description: '营养丰富、色彩缤纷的健康沙拉',
        ingredients: [
          Ingredient(name: '生菜', quantity: 100, unit: 'g'),
          Ingredient(name: '胡萝卜', quantity: 50, unit: 'g'),
          Ingredient(name: '紫甘蓝', quantity: 50, unit: 'g'),
          Ingredient(name: '小番茄', quantity: 80, unit: 'g'),
          Ingredient(name: '黄瓜', quantity: 60, unit: 'g'),
          Ingredient(name: '橄榄油', quantity: 10, unit: 'ml'),
          Ingredient(name: '柠檬汁', quantity: 5, unit: 'ml'),
        ],
        instructions: [
          '将所有蔬菜清洗干净',
          '生菜撕成小片，胡萝卜和黄瓜切丝',
          '紫甘蓝切细丝，小番茄对半切开',
          '将所有蔬菜混合在大碗中',
          '淋上橄榄油和柠檬汁',
          '轻轻拌匀即可享用',
        ],
        preparationTime: 10,
        cookingTime: 0,
        servings: requirements.servings ?? 2,
        difficulty: 'easy',
        nutrition: {
          'calories': 120.0,
          'protein': 3.0,
          'fat': 8.0,
          'carbs': 12.0,
          'fiber': 4.0,
        },
        tags: ['健康', '素食', '低卡', '快手'],
      ),
      Recipe(
        id: 'recipe_${DateTime.now().millisecondsSinceEpoch}',
        name: '蒸蛋羹配时蔬',
        description: '嫩滑营养的蒸蛋羹',
        ingredients: [
          Ingredient(name: '鸡蛋', quantity: 2, unit: '个'),
          Ingredient(name: '温水', quantity: 150, unit: 'ml'),
          Ingredient(name: '西兰花', quantity: 80, unit: 'g'),
          Ingredient(name: '胡萝卜', quantity: 30, unit: 'g'),
          Ingredient(name: '香菇', quantity: 2, unit: '朵'),
          Ingredient(name: '盐', quantity: 2, unit: 'g'),
          Ingredient(name: '香油', quantity: 3, unit: 'ml'),
        ],
        instructions: [
          '鸡蛋打散，加入温水和盐搅拌均匀',
          '过筛去除泡沫，倒入蒸碗中',
          '蒸锅水开后放入蒸碗，中火蒸8-10分钟',
          '蔬菜切小粒，焯水备用',
          '蒸蛋表面铺上蔬菜粒',
          '继续蒸2-3分钟，淋上香油即可',
        ],
        preparationTime: 10,
        cookingTime: 15,
        servings: requirements.servings ?? 1,
        difficulty: 'easy',
        nutrition: {
          'calories': 180.0,
          'protein': 14.0,
          'fat': 12.0,
          'carbs': 6.0,
          'fiber': 2.0,
        },
        tags: ['高蛋白', '易消化', '营养', '蒸制'],
      ),
    ];
    
    return recipes[_random.nextInt(recipes.length)];
  }

  String _generateMockStreamResponse(List<ChatMessage> messages, AIAssistantType assistantType) {
    final responses = {
      AIAssistantType.nutritionPlan: [
        '根据您提供的信息，我为您制定了一个个性化的营养方案。这个方案考虑了您的年龄、性别、活动水平和健康目标。',
        '建议您每日摄入热量控制在1800-2000卡路里之间，其中蛋白质占20%，脂肪占25%，碳水化合物占55%。',
        '请注意保持规律的用餐时间，建议三餐加两次健康加餐。同时要保证充足的水分摄入，每日至少2000毫升。',
      ],
      AIAssistantType.consultationReply: [
        '感谢您的详细描述。根据您的情况，我建议您首先从调整饮食结构开始。',
        '建议增加新鲜蔬菜和优质蛋白质的摄入，同时减少精制食品和添加糖的摄入。',
        '如果您需要更详细的指导，我们可以进一步讨论具体的实施方案。',
      ],
      AIAssistantType.dietAnalysis: [
        '基于您提供的饮食记录，我进行了详细的营养分析。',
        '您的蛋白质摄入比较充足，但膳食纤维的摄入略显不足。建议增加全谷物和蔬菜的摄入。',
        '总体而言，您的饮食结构基本合理，只需要在一些细节上进行调整。',
      ],
      AIAssistantType.recipeGenerator: [
        '我为您推荐一道营养均衡的健康食谱。这道菜不仅美味，而且能够满足您的营养需求。',
        '制作过程简单易学，适合忙碌的现代生活。所用食材都是常见的，容易采购。',
        '这道菜富含优质蛋白质和维生素，是很好的营养补充选择。',
      ],
      AIAssistantType.general: [
        '我很高兴为您提供营养方面的咨询服务。请告诉我您具体的需求和问题。',
        '作为专业的营养助手，我会根据科学的营养学原理为您提供建议。',
        '如果您有任何疑问，请随时与我交流。',
      ],
    };
    
    final responseList = responses[assistantType] ?? responses[AIAssistantType.general]!;
    return responseList[_random.nextInt(responseList.length)];
  }

  double _calculateBMR(ClientInfo clientInfo) {
    // 使用Harris-Benedict公式计算基础代谢率
    if (clientInfo.gender.toLowerCase() == 'male') {
      return 88.362 + (13.397 * clientInfo.weight) + (4.799 * clientInfo.height) - (5.677 * clientInfo.age);
    } else {
      return 447.593 + (9.247 * clientInfo.weight) + (3.098 * clientInfo.height) - (4.330 * clientInfo.age);
    }
  }
}