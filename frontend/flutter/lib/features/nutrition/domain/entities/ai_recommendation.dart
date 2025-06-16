import 'package:equatable/equatable.dart';

/// AI营养推荐实体
class AIRecommendation extends Equatable {
  final String? id;
  final String profileId;
  final NutritionTargets nutritionTargets;
  final List<RecommendationExplanation> explanations;
  final double confidence;
  final RecommendationSource source;
  final DateTime createdAt;
  final Map<String, dynamic>? userAdjustments;

  const AIRecommendation({
    this.id,
    required this.profileId,
    required this.nutritionTargets,
    required this.explanations,
    required this.confidence,
    required this.source,
    required this.createdAt,
    this.userAdjustments,
  });

  AIRecommendation copyWith({
    String? id,
    String? profileId,
    NutritionTargets? nutritionTargets,
    List<RecommendationExplanation>? explanations,
    double? confidence,
    RecommendationSource? source,
    DateTime? createdAt,
    Map<String, dynamic>? userAdjustments,
  }) {
    return AIRecommendation(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      nutritionTargets: nutritionTargets ?? this.nutritionTargets,
      explanations: explanations ?? this.explanations,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      userAdjustments: userAdjustments ?? this.userAdjustments,
    );
  }

  @override
  List<Object?> get props => [
        id,
        profileId,
        nutritionTargets,
        explanations,
        confidence,
        source,
        createdAt,
        userAdjustments,
      ];
}

/// 营养目标
class NutritionTargets extends Equatable {
  final double dailyCalories;
  final MacronutrientRatio macroRatio;
  final double hydrationGoal;
  final int mealFrequency;
  final Map<String, double> vitaminTargets;
  final Map<String, double> mineralTargets;

  const NutritionTargets({
    required this.dailyCalories,
    required this.macroRatio,
    required this.hydrationGoal,
    required this.mealFrequency,
    required this.vitaminTargets,
    required this.mineralTargets,
  });

  NutritionTargets copyWith({
    double? dailyCalories,
    MacronutrientRatio? macroRatio,
    double? hydrationGoal,
    int? mealFrequency,
    Map<String, double>? vitaminTargets,
    Map<String, double>? mineralTargets,
  }) {
    return NutritionTargets(
      dailyCalories: dailyCalories ?? this.dailyCalories,
      macroRatio: macroRatio ?? this.macroRatio,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
      mealFrequency: mealFrequency ?? this.mealFrequency,
      vitaminTargets: vitaminTargets ?? this.vitaminTargets,
      mineralTargets: mineralTargets ?? this.mineralTargets,
    );
  }

  @override
  List<Object?> get props => [
        dailyCalories,
        macroRatio,
        hydrationGoal,
        mealFrequency,
        vitaminTargets,
        mineralTargets,
      ];
}

/// 宏量营养素比例
class MacronutrientRatio extends Equatable {
  final double protein; // 蛋白质比例 (0.0-1.0)
  final double fat; // 脂肪比例 (0.0-1.0)
  final double carbs; // 碳水化合物比例 (0.0-1.0)

  const MacronutrientRatio({
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  /// 验证比例总和是否为1
  bool get isValid => (protein + fat + carbs - 1.0).abs() < 0.01;

  MacronutrientRatio copyWith({
    double? protein,
    double? fat,
    double? carbs,
  }) {
    return MacronutrientRatio(
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
    );
  }

  @override
  List<Object?> get props => [protein, fat, carbs];
}

/// 推荐解释
class RecommendationExplanation extends Equatable {
  final String category; // 分类：宏量营养素、维生素、矿物质等
  final String field; // 具体字段
  final String explanation; // 解释说明
  final String reasoning; // 推理依据

  const RecommendationExplanation({
    required this.category,
    required this.field,
    required this.explanation,
    required this.reasoning,
  });

  @override
  List<Object?> get props => [category, field, explanation, reasoning];
}

/// 推荐来源
enum RecommendationSource {
  mock('模拟AI'),
  deepseek('DeepSeek模型'),
  ruleBased('规则引擎'),
  hybrid('混合推荐');

  const RecommendationSource(this.displayName);
  final String displayName;
}