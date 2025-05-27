import '../../common/entities/entity.dart';
import '../../user/value_objects/user_id.dart';

/// 营养档案实体V2 - 符合需求的新版本
class NutritionProfileV2 extends Entity {
  final String? id;
  final UserId userId;
  
  // 基本信息（必填）
  final String gender; // 性别
  final String ageGroup; // 年龄段
  final double height; // 身高(cm)
  final double weight; // 体重(kg)
  
  // 健康目标（必填）
  final String healthGoal; // 目标类型（减脂、增肌等）
  final double targetCalories; // 目标热量
  
  // 饮食偏好（必填，多选）
  final List<String> dietaryPreferences; // 素食、清淡、无辣、高蛋白等
  
  // 可选字段
  final List<String> medicalConditions; // 疾病史
  final String? exerciseFrequency; // 运动频率
  final List<String> nutritionPreferences; // 营养偏向
  final List<String> specialStatus; // 特殊状态
  final List<String> forbiddenIngredients; // 禁忌食材
  final List<String> allergies; // 过敏原
  
  // 其他信息
  final double? targetWeight; // 目标体重
  final String? activityLevel; // 活动水平
  final String profileName; // 档案名称
  final bool isPrimary; // 是否为主档案
  final bool archived; // 是否已归档
  
  // 时间戳
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionProfileV2({
    this.id,
    required this.userId,
    required this.gender,
    required this.ageGroup,
    required this.height,
    required this.weight,
    required this.healthGoal,
    required this.targetCalories,
    required this.dietaryPreferences,
    this.medicalConditions = const [],
    this.exerciseFrequency,
    this.nutritionPreferences = const [],
    this.specialStatus = const [],
    this.forbiddenIngredients = const [],
    this.allergies = const [],
    this.targetWeight,
    this.activityLevel,
    required this.profileName,
    this.isPrimary = false,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建默认营养档案
  factory NutritionProfileV2.createDefault({
    required UserId userId,
    String profileName = '我的营养档案',
  }) {
    final now = DateTime.now();
    return NutritionProfileV2(
      userId: userId,
      gender: 'other',
      ageGroup: '18to30',
      height: 170,
      weight: 60,
      healthGoal: 'balancedNutrition',
      targetCalories: 2000,
      dietaryPreferences: ['light'],
      profileName: profileName,
      isPrimary: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 计算BMI
  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// BMI状态
  String get bmiStatus {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return '偏瘦';
    if (bmiValue < 24) return '正常';
    if (bmiValue < 28) return '偏胖';
    return '肥胖';
  }

  /// 是否完整填写必填项
  bool get isRequiredFieldsComplete {
    return gender.isNotEmpty &&
           ageGroup.isNotEmpty &&
           height > 0 &&
           weight > 0 &&
           healthGoal.isNotEmpty &&
           targetCalories > 0 &&
           dietaryPreferences.isNotEmpty;
  }

  /// 计算档案完整度百分比
  int get completionPercentage {
    int filledFields = 0;
    int totalFields = 12; // 总字段数

    // 必填字段（7个）
    if (gender.isNotEmpty) filledFields++;
    if (ageGroup.isNotEmpty) filledFields++;
    if (height > 0) filledFields++;
    if (weight > 0) filledFields++;
    if (healthGoal.isNotEmpty) filledFields++;
    if (targetCalories > 0) filledFields++;
    if (dietaryPreferences.isNotEmpty) filledFields++;

    // 可选字段（5个）
    if (medicalConditions.isNotEmpty) filledFields++;
    if (exerciseFrequency != null && exerciseFrequency!.isNotEmpty) filledFields++;
    if (nutritionPreferences.isNotEmpty) filledFields++;
    if (specialStatus.isNotEmpty) filledFields++;
    if (forbiddenIngredients.isNotEmpty) filledFields++;

    return ((filledFields / totalFields) * 100).round();
  }

  /// 获取缺失的必填信息
  List<String> get missingRequiredFields {
    final missing = <String>[];
    if (gender.isEmpty) missing.add('性别');
    if (ageGroup.isEmpty) missing.add('年龄段');
    if (height <= 0) missing.add('身高');
    if (weight <= 0) missing.add('体重');
    if (healthGoal.isEmpty) missing.add('健康目标');
    if (targetCalories <= 0) missing.add('目标热量');
    if (dietaryPreferences.isEmpty) missing.add('饮食偏好');
    return missing;
  }

  /// 创建副本
  NutritionProfileV2 copyWith({
    String? id,
    UserId? userId,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    String? healthGoal,
    double? targetCalories,
    List<String>? dietaryPreferences,
    List<String>? medicalConditions,
    String? exerciseFrequency,
    List<String>? nutritionPreferences,
    List<String>? specialStatus,
    List<String>? forbiddenIngredients,
    List<String>? allergies,
    double? targetWeight,
    String? activityLevel,
    String? profileName,
    bool? isPrimary,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfileV2(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      healthGoal: healthGoal ?? this.healthGoal,
      targetCalories: targetCalories ?? this.targetCalories,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      nutritionPreferences: nutritionPreferences ?? this.nutritionPreferences,
      specialStatus: specialStatus ?? this.specialStatus,
      forbiddenIngredients: forbiddenIngredients ?? this.forbiddenIngredients,
      allergies: allergies ?? this.allergies,
      targetWeight: targetWeight ?? this.targetWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      profileName: profileName ?? this.profileName,
      isPrimary: isPrimary ?? this.isPrimary,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        gender,
        ageGroup,
        height,
        weight,
        healthGoal,
        targetCalories,
        dietaryPreferences,
        medicalConditions,
        exerciseFrequency,
        nutritionPreferences,
        specialStatus,
        forbiddenIngredients,
        allergies,
        targetWeight,
        activityLevel,
        profileName,
        isPrimary,
        archived,
        createdAt,
        updatedAt,
      ];
}