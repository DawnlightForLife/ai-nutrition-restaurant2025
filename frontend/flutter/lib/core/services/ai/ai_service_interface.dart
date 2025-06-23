
/// AI服务接口定义
/// 定义所有AI功能的标准接口，支持热更换不同的AI实现
abstract class AIServiceInterface {
  /// 服务提供者名称
  String get providerName;
  
  /// 服务状态
  bool get isAvailable;
  
  /// 初始化服务
  Future<void> initialize();
  
  /// 释放资源
  Future<void> dispose();
  
  /// 生成营养方案
  /// [clientInfo] 客户基本信息
  /// [nutritionGoals] 营养目标
  /// [preferences] 饮食偏好
  /// [restrictions] 饮食限制
  Future<NutritionPlanResponse> generateNutritionPlan({
    required ClientInfo clientInfo,
    required NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  });
  
  /// 生成咨询回复
  /// [question] 客户问题
  /// [context] 上下文信息
  /// [nutritionistProfile] 营养师资料
  Future<ConsultationReplyResponse> generateConsultationReply({
    required String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  });
  
  /// 分析饮食记录
  /// [foodRecords] 饮食记录列表
  /// [analysisType] 分析类型
  Future<DietAnalysisResponse> analyzeDiet({
    required List<FoodRecord> foodRecords,
    DietAnalysisType analysisType = DietAnalysisType.comprehensive,
  });
  
  /// 生成食谱
  /// [requirements] 食谱要求
  Future<RecipeResponse> generateRecipe({
    required RecipeRequirements requirements,
  });
  
  /// 实时聊天对话
  /// [messages] 对话历史
  /// [assistantType] 助手类型
  Stream<String> streamChat({
    required List<ChatMessage> messages,
    required AIAssistantType assistantType,
  });
  
  /// 获取AI能力信息
  AICapabilities get capabilities;
}

/// 客户基本信息
class ClientInfo {
  final String? id;
  final int age;
  final String gender;
  final double height; // cm
  final double weight; // kg
  final String? activityLevel;
  final List<String>? healthConditions;
  final Map<String, dynamic>? additionalInfo;

  ClientInfo({
    this.id,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.activityLevel,
    this.healthConditions,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'age': age,
    'gender': gender,
    'height': height,
    'weight': weight,
    'activityLevel': activityLevel,
    'healthConditions': healthConditions,
    'additionalInfo': additionalInfo,
  };
}

/// 营养目标
class NutritionGoals {
  final String primaryGoal; // weight_loss, muscle_gain, health_maintenance, etc.
  final double? targetWeight;
  final int? timeframe; // days
  final List<String>? specificNeeds;
  final Map<String, dynamic>? customGoals;

  NutritionGoals({
    required this.primaryGoal,
    this.targetWeight,
    this.timeframe,
    this.specificNeeds,
    this.customGoals,
  });

  Map<String, dynamic> toJson() => {
    'primaryGoal': primaryGoal,
    'targetWeight': targetWeight,
    'timeframe': timeframe,
    'specificNeeds': specificNeeds,
    'customGoals': customGoals,
  };
}

/// 营养师资料
class NutritionistProfile {
  final String id;
  final String name;
  final String? specialization;
  final int yearsOfExperience;
  final List<String>? certifications;
  final String? workingStyle;

  NutritionistProfile({
    required this.id,
    required this.name,
    this.specialization,
    required this.yearsOfExperience,
    this.certifications,
    this.workingStyle,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'yearsOfExperience': yearsOfExperience,
    'certifications': certifications,
    'workingStyle': workingStyle,
  };
}

/// 饮食记录
class FoodRecord {
  final String id;
  final DateTime timestamp;
  final String mealType; // breakfast, lunch, dinner, snack
  final List<FoodItem> foods;
  final String? notes;

  FoodRecord({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.foods,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'mealType': mealType,
    'foods': foods.map((f) => f.toJson()).toList(),
    'notes': notes,
  };
}

/// 食物项目
class FoodItem {
  final String name;
  final double quantity;
  final String unit;
  final Map<String, double>? nutrition; // calories, protein, fat, carbs, etc.

  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    this.nutrition,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'nutrition': nutrition,
  };
}

/// 食谱要求
class RecipeRequirements {
  final String? cuisine;
  final String? mealType;
  final int? servings;
  final int? preparationTime; // minutes
  final String? difficulty; // easy, medium, hard
  final List<String>? includedIngredients;
  final List<String>? excludedIngredients;
  final List<String>? dietaryRestrictions;
  final Map<String, double>? nutritionTargets;

  RecipeRequirements({
    this.cuisine,
    this.mealType,
    this.servings,
    this.preparationTime,
    this.difficulty,
    this.includedIngredients,
    this.excludedIngredients,
    this.dietaryRestrictions,
    this.nutritionTargets,
  });

  Map<String, dynamic> toJson() => {
    'cuisine': cuisine,
    'mealType': mealType,
    'servings': servings,
    'preparationTime': preparationTime,
    'difficulty': difficulty,
    'includedIngredients': includedIngredients,
    'excludedIngredients': excludedIngredients,
    'dietaryRestrictions': dietaryRestrictions,
    'nutritionTargets': nutritionTargets,
  };
}

/// 聊天消息
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? messageType;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.messageType,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'messageType': messageType,
    'metadata': metadata,
  };
}

/// AI响应基类
abstract class AIResponse {
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  AIResponse({
    required this.success,
    this.error,
    this.metadata,
  });
}

/// 营养方案响应
class NutritionPlanResponse extends AIResponse {
  final NutritionPlan? plan;

  NutritionPlanResponse({
    required super.success,
    super.error,
    super.metadata,
    this.plan,
  });
}

/// 营养方案
class NutritionPlan {
  final String id;
  final String title;
  final String description;
  final Map<String, double> dailyNutritionTargets;
  final List<MealPlan> mealPlans;
  final List<String> recommendations;
  final List<String> notes;

  NutritionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.dailyNutritionTargets,
    required this.mealPlans,
    required this.recommendations,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dailyNutritionTargets': dailyNutritionTargets,
    'mealPlans': mealPlans.map((m) => m.toJson()).toList(),
    'recommendations': recommendations,
    'notes': notes,
  };
}

/// 餐食计划
class MealPlan {
  final String mealType;
  final String description;
  final List<String> foods;
  final Map<String, double> nutrition;
  final String? preparationTips;

  MealPlan({
    required this.mealType,
    required this.description,
    required this.foods,
    required this.nutrition,
    this.preparationTips,
  });

  Map<String, dynamic> toJson() => {
    'mealType': mealType,
    'description': description,
    'foods': foods,
    'nutrition': nutrition,
    'preparationTips': preparationTips,
  };
}

/// 咨询回复响应
class ConsultationReplyResponse extends AIResponse {
  final String? reply;
  final List<String>? suggestions;
  final String? tone;

  ConsultationReplyResponse({
    required super.success,
    super.error,
    super.metadata,
    this.reply,
    this.suggestions,
    this.tone,
  });
}

/// 饮食分析响应
class DietAnalysisResponse extends AIResponse {
  final DietAnalysis? analysis;

  DietAnalysisResponse({
    required super.success,
    super.error,
    super.metadata,
    this.analysis,
  });
}

/// 饮食分析结果
class DietAnalysis {
  final Map<String, double> nutritionSummary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final Map<String, dynamic> detailedAnalysis;

  DietAnalysis({
    required this.nutritionSummary,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.detailedAnalysis,
  });

  Map<String, dynamic> toJson() => {
    'nutritionSummary': nutritionSummary,
    'strengths': strengths,
    'weaknesses': weaknesses,
    'recommendations': recommendations,
    'detailedAnalysis': detailedAnalysis,
  };
}

/// 食谱响应
class RecipeResponse extends AIResponse {
  final Recipe? recipe;

  RecipeResponse({
    required super.success,
    super.error,
    super.metadata,
    this.recipe,
  });
}

/// 食谱
class Recipe {
  final String id;
  final String name;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final int preparationTime;
  final int cookingTime;
  final int servings;
  final String difficulty;
  final Map<String, double> nutrition;
  final List<String>? tags;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.preparationTime,
    required this.cookingTime,
    required this.servings,
    required this.difficulty,
    required this.nutrition,
    this.tags,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'instructions': instructions,
    'preparationTime': preparationTime,
    'cookingTime': cookingTime,
    'servings': servings,
    'difficulty': difficulty,
    'nutrition': nutrition,
    'tags': tags,
  };
}

/// 食材
class Ingredient {
  final String name;
  final double quantity;
  final String unit;
  final String? notes;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'notes': notes,
  };
}

/// AI能力信息
class AICapabilities {
  final bool supportsNutritionPlanning;
  final bool supportsConsultationReply;
  final bool supportsDietAnalysis;
  final bool supportsRecipeGeneration;
  final bool supportsStreamingChat;
  final List<String> supportedLanguages;
  final Map<String, dynamic>? additionalCapabilities;

  AICapabilities({
    required this.supportsNutritionPlanning,
    required this.supportsConsultationReply,
    required this.supportsDietAnalysis,
    required this.supportsRecipeGeneration,
    required this.supportsStreamingChat,
    required this.supportedLanguages,
    this.additionalCapabilities,
  });
}

/// 饮食分析类型
enum DietAnalysisType {
  comprehensive, // 综合分析
  nutritional, // 营养分析
  caloric, // 热量分析
  macronutrient, // 宏量营养素分析
  micronutrient, // 微量营养素分析
}

/// AI助手类型
enum AIAssistantType {
  nutritionPlan, // 营养方案助手
  consultationReply, // 咨询回复助手
  dietAnalysis, // 饮食分析助手
  recipeGenerator, // 食谱生成助手
  general, // 通用助手
}

/// AI服务异常
class AIServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AIServiceException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AIServiceException: $message${code != null ? ' (Code: $code)' : ''}';
}