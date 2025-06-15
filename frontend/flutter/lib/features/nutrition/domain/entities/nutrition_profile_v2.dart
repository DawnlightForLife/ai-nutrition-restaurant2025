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
    createdAt,
    updatedAt,
  ];
}