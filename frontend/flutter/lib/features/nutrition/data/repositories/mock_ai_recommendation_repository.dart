import 'dart:math';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/repositories/ai_recommendation_repository.dart';

/// Mock AI推荐仓库实现
/// 提供基于规则的营养推荐，为DeepSeek模型接入做准备
class MockAIRecommendationRepository implements AIRecommendationRepository {
  // 临时存储推荐记录
  static final List<AIRecommendation> _recommendations = [];
  static int _idCounter = 1;

  @override
  Future<AIRecommendation> generateRecommendation({
    required NutritionProfileV2 profile,
    String? requestId,
  }) async {
    // 模拟AI分析延迟
    await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(1000)));

    final nutritionTargets = _calculateNutritionTargets(profile);
    final explanations = _generateExplanations(profile, nutritionTargets);
    final confidence = _calculateConfidence(profile);

    final recommendation = AIRecommendation(
      id: 'ai_rec_${_idCounter++}',
      profileId: profile.id ?? 'unknown',
      nutritionTargets: nutritionTargets,
      explanations: explanations,
      confidence: confidence,
      source: RecommendationSource.mock,
      createdAt: DateTime.now(),
    );

    _recommendations.add(recommendation);
    return recommendation;
  }

  @override
  Future<List<AIRecommendation>> getRecommendationHistory(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _recommendations
        .where((rec) => rec.profileId == profileId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> submitFeedback({
    required String recommendationId,
    required int rating,
    String? comments,
    required bool isAccepted,
    Map<String, dynamic>? adjustments,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock实现：记录反馈但不做实际处理
    print('Feedback submitted for $recommendationId: rating=$rating, accepted=$isAccepted');
  }

  @override
  Future<AIRecommendation> saveUserAdjustments({
    required String recommendationId,
    required Map<String, dynamic> adjustments,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _recommendations.indexWhere((rec) => rec.id == recommendationId);
    if (index != -1) {
      final updated = _recommendations[index].copyWith(
        userAdjustments: adjustments,
      );
      _recommendations[index] = updated;
      return updated;
    }
    
    throw Exception('Recommendation not found: $recommendationId');
  }

  @override
  Future<bool> validateRecommendation(AIRecommendation recommendation) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // 基础验证规则
    final targets = recommendation.nutritionTargets;
    
    // 检查热量合理性 (800-4000 kcal)
    if (targets.dailyCalories < 800 || targets.dailyCalories > 4000) {
      return false;
    }
    
    // 检查宏量营养素比例
    if (!targets.macroRatio.isValid) {
      return false;
    }
    
    // 检查饮水量合理性 (1000-4000ml)
    if (targets.hydrationGoal < 1000 || targets.hydrationGoal > 4000) {
      return false;
    }
    
    return true;
  }

  /// 计算营养目标（基于科学公式）
  NutritionTargets _calculateNutritionTargets(NutritionProfileV2 profile) {
    // 计算基础代谢率 (Mifflin-St Jeor方程)
    final age = _ageGroupToNumber(profile.ageGroup);
    double bmr;
    
    if (profile.gender == 'male') {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * age + 5;
    } else {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * age - 161;
    }

    // 活动水平系数
    final activityMultiplier = _getActivityMultiplier(profile.exerciseFrequency);
    double tdee = bmr * activityMultiplier;

    // 根据健康目标调整
    tdee = _adjustForHealthGoal(tdee, profile.healthGoal);

    // 计算宏量营养素比例
    final macroRatio = _calculateMacroRatio(profile);

    // 计算维生素和矿物质需求
    final vitaminTargets = _calculateVitaminTargets(profile);
    final mineralTargets = _calculateMineralTargets(profile);

    // 计算饮水量
    final hydrationGoal = _calculateHydrationGoal(profile);

    // 推荐用餐频次
    final mealFrequency = _recommendMealFrequency(profile);

    return NutritionTargets(
      dailyCalories: tdee.round().toDouble(),
      macroRatio: macroRatio,
      hydrationGoal: hydrationGoal,
      mealFrequency: mealFrequency,
      vitaminTargets: vitaminTargets,
      mineralTargets: mineralTargets,
    );
  }

  /// 年龄组转数字
  int _ageGroupToNumber(String ageGroup) {
    switch (ageGroup) {
      case 'under18': return 16;
      case '18to25': return 22;
      case '26to35': return 30;
      case '36to45': return 40;
      case '46to55': return 50;
      case '56to65': return 60;
      case 'above65': return 70;
      default: return 30;
    }
  }

  /// 活动水平系数
  double _getActivityMultiplier(String? exerciseFrequency) {
    switch (exerciseFrequency) {
      case 'none': return 1.2;
      case 'occasional': return 1.375;
      case 'regular': return 1.55;
      case 'intense': return 1.725;
      case 'frequent':
      case 'daily': return 1.9;
      default: return 1.55;
    }
  }

  /// 根据健康目标调整热量
  double _adjustForHealthGoal(double tdee, String healthGoal) {
    switch (healthGoal) {
      case 'weight_loss': return tdee * 0.85; // 减少15%
      case 'weight_gain':
      case 'muscle_gain': return tdee * 1.15; // 增加15%
      case 'weight_maintain':
      default: return tdee;
    }
  }

  /// 计算宏量营养素比例
  MacronutrientRatio _calculateMacroRatio(NutritionProfileV2 profile) {
    // 根据健康目标和用户偏好调整比例
    switch (profile.healthGoal) {
      case 'weight_loss':
        return const MacronutrientRatio(protein: 0.30, fat: 0.25, carbs: 0.45);
      case 'muscle_gain':
        return const MacronutrientRatio(protein: 0.35, fat: 0.25, carbs: 0.40);
      case 'weight_maintain':
      default:
        return const MacronutrientRatio(protein: 0.25, fat: 0.30, carbs: 0.45);
    }
  }

  /// 计算维生素需求
  Map<String, double> _calculateVitaminTargets(NutritionProfileV2 profile) {
    final age = _ageGroupToNumber(profile.ageGroup);
    final isMale = profile.gender == 'male';
    
    return {
      'vitaminA': isMale ? 900.0 : 700.0, // μg RAE
      'vitaminC': 90.0, // mg
      'vitaminD': age > 70 ? 800.0 : 600.0, // IU
      'vitaminE': 15.0, // mg
      'vitaminK': isMale ? 120.0 : 90.0, // μg
      'vitaminB1': isMale ? 1.2 : 1.1, // mg
      'vitaminB2': isMale ? 1.3 : 1.1, // mg
      'vitaminB6': age > 50 ? 1.7 : 1.3, // mg
      'vitaminB12': 2.4, // μg
      'folate': 400.0, // μg
      'niacin': isMale ? 16.0 : 14.0, // mg
    };
  }

  /// 计算矿物质需求
  Map<String, double> _calculateMineralTargets(NutritionProfileV2 profile) {
    final age = _ageGroupToNumber(profile.ageGroup);
    final isMale = profile.gender == 'male';
    
    return {
      'calcium': age > 50 ? 1200.0 : 1000.0, // mg
      'iron': isMale ? 8.0 : (age > 50 ? 8.0 : 18.0), // mg
      'magnesium': isMale ? 400.0 : 310.0, // mg
      'phosphorus': 700.0, // mg
      'potassium': 3500.0, // mg
      'sodium': 2300.0, // mg (上限)
      'zinc': isMale ? 11.0 : 8.0, // mg
      'selenium': 55.0, // μg
    };
  }

  /// 计算饮水需求
  double _calculateHydrationGoal(NutritionProfileV2 profile) {
    // 基础需求：体重(kg) × 35ml
    double baseHydration = profile.weight * 35;
    
    // 根据运动强度调整
    final activityMultiplier = _getActivityMultiplier(profile.exerciseFrequency);
    if (activityMultiplier > 1.55) {
      baseHydration *= 1.2; // 高强度运动增加20%
    }
    
    return baseHydration.clamp(1500.0, 4000.0);
  }

  /// 推荐用餐频次
  int _recommendMealFrequency(NutritionProfileV2 profile) {
    switch (profile.healthGoal) {
      case 'weight_loss': return 5; // 少食多餐
      case 'muscle_gain': return 6; // 频繁进食
      case 'weight_maintain':
      default: return 3; // 常规三餐
    }
  }

  /// 生成推荐解释
  List<RecommendationExplanation> _generateExplanations(
    NutritionProfileV2 profile,
    NutritionTargets targets,
  ) {
    final explanations = <RecommendationExplanation>[];

    // 热量解释
    explanations.add(RecommendationExplanation(
      category: '热量需求',
      field: 'dailyCalories',
      explanation: '基于您的身高${profile.height.toInt()}cm、体重${profile.weight.toInt()}kg和活动水平，推荐每日摄入${targets.dailyCalories.toInt()}千卡',
      reasoning: '使用Mifflin-St Jeor方程计算基础代谢率，结合活动水平和健康目标调整',
    ));

    // 蛋白质解释
    explanations.add(RecommendationExplanation(
      category: '宏量营养素',
      field: 'protein',
      explanation: '蛋白质建议占总热量的${(targets.macroRatio.protein * 100).toInt()}%',
      reasoning: profile.healthGoal == 'muscle_gain' 
          ? '肌肉增长目标需要更高的蛋白质摄入' 
          : '维持正常身体功能和肌肉量',
    ));

    // 饮水解释
    explanations.add(RecommendationExplanation(
      category: '水分需求',
      field: 'hydrationGoal',
      explanation: '建议每日饮水${targets.hydrationGoal.toInt()}毫升',
      reasoning: '基于体重计算基础需求，结合运动强度调整',
    ));

    return explanations;
  }

  /// 计算推荐置信度
  double _calculateConfidence(NutritionProfileV2 profile) {
    double confidence = 0.7; // 基础置信度

    // 信息完整性加分
    if (profile.medicalConditions.isNotEmpty) confidence += 0.1;
    if (profile.exerciseFrequency?.isNotEmpty == true) confidence += 0.1;
    if (profile.nutritionPreferences.isNotEmpty) confidence += 0.05;
    if (profile.allergies.isNotEmpty) confidence += 0.05;

    return confidence.clamp(0.0, 1.0);
  }
}