import 'package:equatable/equatable.dart';
import '../../../user/domain/value_objects/user_id.dart';

/// 营养档案V2实体 - 支持更详细的配置
class NutritionProfileV2 extends Equatable {
  final String? id;
  final UserId userId;
  final String profileName;
  final bool isPrimary;
  
  // 基本信息
  final String gender;
  final String ageGroup;
  final double height;
  final double weight;
  
  // 健康目标
  final String healthGoal;
  final double targetCalories;
  final Map<String, dynamic>? healthGoalDetails; // 新增：健康目标详细配置
  
  // 活动水平
  final String? exerciseFrequency;
  final Map<String, dynamic>? activityDetails; // 新增：活动水平详细信息
  
  // 饮食偏好
  final List<String> dietaryPreferences;
  final List<String> nutritionPreferences;
  
  // 健康状况
  final List<String> medicalConditions;
  final List<String> specialStatus;
  
  // 禁忌与过敏
  final List<String> forbiddenIngredients;
  final List<String> allergies;
  
  // AI推荐相关 (新增字段)
  final String? aiRecommendationId;
  final Map<String, double>? aiNutritionTargets;
  final bool hasAIRecommendation;
  
  // 营养立方进度跟踪 (新增字段)
  final Map<String, dynamic>? nutritionProgress; // 营养目标进度
  final int totalEnergyPoints; // 总能量点数
  final int currentStreak; // 当前连续天数
  final int bestStreak; // 最佳连续记录
  final DateTime? lastActiveDate; // 最后活跃日期
  final Map<String, int>? weeklyProgress; // 周进度统计
  
  // 时间戳
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionProfileV2({
    this.id,
    required this.userId,
    required this.profileName,
    this.isPrimary = false,
    required this.gender,
    required this.ageGroup,
    required this.height,
    required this.weight,
    required this.healthGoal,
    required this.targetCalories,
    this.healthGoalDetails,
    this.exerciseFrequency,
    this.activityDetails,
    required this.dietaryPreferences,
    this.nutritionPreferences = const [],
    this.medicalConditions = const [],
    this.specialStatus = const [],
    this.forbiddenIngredients = const [],
    this.allergies = const [],
    // AI推荐字段
    this.aiRecommendationId,
    this.aiNutritionTargets,
    this.hasAIRecommendation = false,
    // 营养立方进度跟踪字段
    this.nutritionProgress,
    this.totalEnergyPoints = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
    this.weeklyProgress,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 复制并更新部分字段
  NutritionProfileV2 copyWith({
    String? id,
    UserId? userId,
    String? profileName,
    bool? isPrimary,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    String? healthGoal,
    double? targetCalories,
    Map<String, dynamic>? healthGoalDetails,
    String? exerciseFrequency,
    Map<String, dynamic>? activityDetails,
    List<String>? dietaryPreferences,
    List<String>? nutritionPreferences,
    List<String>? medicalConditions,
    List<String>? specialStatus,
    List<String>? forbiddenIngredients,
    List<String>? allergies,
    // AI推荐字段
    String? aiRecommendationId,
    Map<String, double>? aiNutritionTargets,
    bool? hasAIRecommendation,
    // 营养立方进度跟踪字段
    Map<String, dynamic>? nutritionProgress,
    int? totalEnergyPoints,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
    Map<String, int>? weeklyProgress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfileV2(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileName: profileName ?? this.profileName,
      isPrimary: isPrimary ?? this.isPrimary,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      healthGoal: healthGoal ?? this.healthGoal,
      targetCalories: targetCalories ?? this.targetCalories,
      healthGoalDetails: healthGoalDetails ?? this.healthGoalDetails,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      activityDetails: activityDetails ?? this.activityDetails,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      nutritionPreferences: nutritionPreferences ?? this.nutritionPreferences,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      specialStatus: specialStatus ?? this.specialStatus,
      forbiddenIngredients: forbiddenIngredients ?? this.forbiddenIngredients,
      allergies: allergies ?? this.allergies,
      // AI推荐字段
      aiRecommendationId: aiRecommendationId ?? this.aiRecommendationId,
      aiNutritionTargets: aiNutritionTargets ?? this.aiNutritionTargets,
      hasAIRecommendation: hasAIRecommendation ?? this.hasAIRecommendation,
      // 营养立方进度跟踪字段
      nutritionProgress: nutritionProgress ?? this.nutritionProgress,
      totalEnergyPoints: totalEnergyPoints ?? this.totalEnergyPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 计算BMI
  double get bmi {
    if (height <= 0 || weight <= 0) return 0;
    final heightInM = height / 100;
    return weight / (heightInM * heightInM);
  }

  /// 计算档案完整度
  int get completionPercentage {
    int filledFields = 0;
    int totalFields = 8; // 必填字段总数

    // 检查必填字段
    if (profileName.isNotEmpty) filledFields++;
    if (gender.isNotEmpty) filledFields++;
    if (ageGroup.isNotEmpty) filledFields++;
    if (height > 0) filledFields++;
    if (weight > 0) filledFields++;
    if (healthGoal.isNotEmpty) filledFields++;
    if (targetCalories > 0) filledFields++;
    if (dietaryPreferences.isNotEmpty) filledFields++;

    // 计算可选字段的完整度（权重较低）
    int optionalFilledFields = 0;
    int optionalTotalFields = 6;
    
    if (medicalConditions.isNotEmpty) optionalFilledFields++;
    if (exerciseFrequency != null) optionalFilledFields++;
    if (nutritionPreferences.isNotEmpty) optionalFilledFields++;
    if (specialStatus.isNotEmpty) optionalFilledFields++;
    if (forbiddenIngredients.isNotEmpty) optionalFilledFields++;
    if (allergies.isNotEmpty) optionalFilledFields++;

    // 必填字段占80%权重，可选字段占20%权重
    final requiredPercentage = (filledFields / totalFields) * 80;
    final optionalPercentage = (optionalFilledFields / optionalTotalFields) * 20;
    
    return (requiredPercentage + optionalPercentage).round();
  }

  /// 营养立方能量等级
  String get energyLevel {
    if (totalEnergyPoints < 100) return 'starter'; // 初学者
    if (totalEnergyPoints < 500) return 'bronze'; // 青铜
    if (totalEnergyPoints < 1000) return 'silver'; // 白银
    if (totalEnergyPoints < 2000) return 'gold'; // 黄金
    if (totalEnergyPoints < 5000) return 'platinum'; // 铂金
    return 'diamond'; // 钻石
  }

  /// 能量等级显示名称
  String get energyLevelName {
    switch (energyLevel) {
      case 'starter': return '初学者';
      case 'bronze': return '青铜立方';
      case 'silver': return '白银立方';
      case 'gold': return '黄金立方';
      case 'platinum': return '铂金立方';
      case 'diamond': return '钻石立方';
      default: return '神秘立方';
    }
  }

  /// 当前能量立方填充百分比
  double get cubeFilledPercentage {
    final currentLevelPoints = _getCurrentLevelPoints();
    final nextLevelPoints = _getNextLevelPoints();
    if (nextLevelPoints == currentLevelPoints) return 1.0;
    return ((totalEnergyPoints - currentLevelPoints) / (nextLevelPoints - currentLevelPoints)).clamp(0.0, 1.0);
  }

  /// 距离下一等级还需要的能量点数
  int get pointsToNextLevel {
    final nextLevelPoints = _getNextLevelPoints();
    return (nextLevelPoints - totalEnergyPoints).clamp(0, double.infinity).toInt();
  }

  /// 获取当前等级起始点数
  int _getCurrentLevelPoints() {
    switch (energyLevel) {
      case 'starter': return 0;
      case 'bronze': return 100;
      case 'silver': return 500;
      case 'gold': return 1000;
      case 'platinum': return 2000;
      case 'diamond': return 5000;
      default: return 0;
    }
  }

  /// 获取下一等级所需点数
  int _getNextLevelPoints() {
    switch (energyLevel) {
      case 'starter': return 100;
      case 'bronze': return 500;
      case 'silver': return 1000;
      case 'gold': return 2000;
      case 'platinum': return 5000;
      case 'diamond': return 10000; // 钻石等级的下一级
      default: return 10000;
    }
  }

  /// 是否活跃用户（最近7天内有活动）
  bool get isActiveUser {
    if (lastActiveDate == null) return false;
    final daysSinceActive = DateTime.now().difference(lastActiveDate!).inDays;
    return daysSinceActive <= 7;
  }

  /// 连续天数等级
  String get streakLevel {
    if (currentStreak < 3) return 'beginner';
    if (currentStreak < 7) return 'consistent';
    if (currentStreak < 21) return 'dedicated';
    if (currentStreak < 50) return 'champion';
    return 'master';
  }

  /// 连续天数等级显示名称
  String get streakLevelName {
    switch (streakLevel) {
      case 'beginner': return '新手';
      case 'consistent': return '坚持者';
      case 'dedicated': return '专注者';
      case 'champion': return '冠军';
      case 'master': return '大师';
      default: return '未知';
    }
  }

  /// 能量等级进度（0.0-1.0）
  double get energyLevelProgress {
    final currentLevelPoints = _getCurrentLevelPoints();
    final nextLevelPoints = _getNextLevelPoints();
    if (nextLevelPoints == currentLevelPoints) return 1.0;
    return ((totalEnergyPoints - currentLevelPoints) / (nextLevelPoints - currentLevelPoints)).clamp(0.0, 1.0);
  }

  /// 连续记录是否活跃
  bool get isStreakActive {
    if (lastActiveDate == null) return false;
    final today = DateTime.now();
    final lastActive = lastActiveDate!;
    final daysDifference = today.difference(DateTime(lastActive.year, lastActive.month, lastActive.day)).inDays;
    return daysDifference <= 1; // 今天或昨天有活动才算活跃
  }

  /// 是否已归档（暂时返回false，后续可根据需要实现）
  bool get archived => false;

  @override
  List<Object?> get props => [
    id,
    userId,
    profileName,
    isPrimary,
    gender,
    ageGroup,
    height,
    weight,
    healthGoal,
    targetCalories,
    healthGoalDetails,
    exerciseFrequency,
    activityDetails,
    dietaryPreferences,
    nutritionPreferences,
    medicalConditions,
    specialStatus,
    forbiddenIngredients,
    allergies,
    aiRecommendationId,
    aiNutritionTargets,
    hasAIRecommendation,
    nutritionProgress,
    totalEnergyPoints,
    currentStreak,
    bestStreak,
    lastActiveDate,
    weeklyProgress,
    createdAt,
    updatedAt,
  ];
}