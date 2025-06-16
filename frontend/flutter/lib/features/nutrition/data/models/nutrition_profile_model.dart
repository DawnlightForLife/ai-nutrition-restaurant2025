import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/nutrition_profile.dart' as domain;

part 'nutrition_profile_model.g.dart';

/// 营养档案数据模型
@JsonSerializable(explicitToJson: true)
class NutritionProfileModel {
  @JsonKey(name: '_id')
  final String? id;
  
  final String userId;
  final String profileName;
  final String gender;
  final String? ageGroup;
  final double? height;
  final double? weight;
  final String? activityLevel;
  @JsonKey(name: 'activityLevelDetail')
  final String? activityLevelDetail;
  final double? bodyFatPercentage;
  
  // 饮食偏好
  final DietaryPreferencesModel? dietaryPreferences;
  
  // 生活方式
  final LifestyleModel? lifestyle;
  
  // 营养目标
  final List<String> nutritionGoals;
  
  // 健康目标详细配置
  final HealthGoalDetailsModel? healthGoalDetails;
  
  // 活动详情
  final Map<String, dynamic>? activityDetails;
  
  // 其他字段
  final double? targetWeight;
  final double? dailyCalorieTarget;
  final double? hydrationGoal;
  final List<String>? medicalConditions;
  final List<String>? preferredMealTimes;
  final int? mealFrequency;
  final int? cookingTimeBudget;
  final RegionModel? region;
  final String? occupation;
  final NutritionStatusModel? nutritionStatus;
  final List<String>? relatedHealthRecords;
  final bool isPrimary;
  final bool archived;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // 营养立方进度追踪
  final Map<String, dynamic>? nutritionProgress;
  final int totalEnergyPoints;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActiveDate;

  NutritionProfileModel({
    this.id,
    required this.userId,
    required this.profileName,
    required this.gender,
    this.ageGroup,
    this.height,
    this.weight,
    this.activityLevel,
    this.activityLevelDetail,
    this.bodyFatPercentage,
    this.dietaryPreferences,
    this.lifestyle,
    this.nutritionGoals = const [],
    this.healthGoalDetails,
    this.activityDetails,
    this.targetWeight,
    this.dailyCalorieTarget,
    this.hydrationGoal,
    this.medicalConditions,
    this.preferredMealTimes,
    this.mealFrequency,
    this.cookingTimeBudget,
    this.region,
    this.occupation,
    this.nutritionStatus,
    this.relatedHealthRecords,
    this.isPrimary = false,
    this.archived = false,
    this.createdAt,
    this.updatedAt,
    this.nutritionProgress,
    this.totalEnergyPoints = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
  });

  factory NutritionProfileModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionProfileModelToJson(this);

  /// 计算BMI
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// 计算完成度
  int get completionPercentage {
    int completedFields = 0;
    int totalFields = 15;

    if (profileName.isNotEmpty) completedFields++;
    if (gender.isNotEmpty) completedFields++;
    if (ageGroup != null && ageGroup!.isNotEmpty) completedFields++;
    if (height != null && height! > 0) completedFields++;
    if (weight != null && weight! > 0) completedFields++;
    if (activityLevel != null && activityLevel!.isNotEmpty) completedFields++;
    if (nutritionGoals.isNotEmpty) completedFields++;
    if (targetWeight != null && targetWeight! > 0) completedFields++;
    if (dietaryPreferences != null) completedFields++;
    if (lifestyle != null) completedFields++;
    if (healthGoalDetails != null) completedFields++;
    if (medicalConditions?.isNotEmpty == true) completedFields++;
    if (dailyCalorieTarget != null && dailyCalorieTarget! > 0) completedFields++;
    if (hydrationGoal != null && hydrationGoal! > 0) completedFields++;
    if (region != null) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }

  /// 获取能量等级
  String get energyLevel {
    if (totalEnergyPoints < 100) return 'starter';
    if (totalEnergyPoints < 500) return 'bronze';
    if (totalEnergyPoints < 1500) return 'silver';
    if (totalEnergyPoints < 3000) return 'gold';
    if (totalEnergyPoints < 6000) return 'platinum';
    return 'diamond';
  }

  /// 获取能量等级显示名称
  String get energyLevelName {
    switch (energyLevel) {
      case 'starter': return '新手';
      case 'bronze': return '青铜';
      case 'silver': return '白银';
      case 'gold': return '黄金';
      case 'platinum': return '铂金';
      case 'diamond': return '钻石';
      default: return '未知';
    }
  }

  /// 获取当前等级进度百分比
  double get energyLevelProgress {
    final currentLevel = energyLevel;
    int currentThreshold = 0;
    int nextThreshold = 100;
    
    switch (currentLevel) {
      case 'starter':
        currentThreshold = 0;
        nextThreshold = 100;
        break;
      case 'bronze':
        currentThreshold = 100;
        nextThreshold = 500;
        break;
      case 'silver':
        currentThreshold = 500;
        nextThreshold = 1500;
        break;
      case 'gold':
        currentThreshold = 1500;
        nextThreshold = 3000;
        break;
      case 'platinum':
        currentThreshold = 3000;
        nextThreshold = 6000;
        break;
      case 'diamond':
        return 1.0; // 最高等级
    }
    
    if (totalEnergyPoints <= currentThreshold) return 0.0;
    if (totalEnergyPoints >= nextThreshold) return 1.0;
    
    return (totalEnergyPoints - currentThreshold) / (nextThreshold - currentThreshold);
  }

  /// 检查连续天数
  bool get isStreakActive {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final lastActive = lastActiveDate!;
    final difference = now.difference(lastActive).inDays;
    return difference <= 1; // 昨天或今天活跃算连续
  }

  /// 复制并更新
  NutritionProfileModel copyWith({
    String? id,
    String? userId,
    String? profileName,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    String? activityLevel,
    String? activityLevelDetail,
    double? bodyFatPercentage,
    DietaryPreferencesModel? dietaryPreferences,
    LifestyleModel? lifestyle,
    List<String>? nutritionGoals,
    HealthGoalDetailsModel? healthGoalDetails,
    Map<String, dynamic>? activityDetails,
    double? targetWeight,
    double? dailyCalorieTarget,
    double? hydrationGoal,
    List<String>? medicalConditions,
    List<String>? preferredMealTimes,
    int? mealFrequency,
    int? cookingTimeBudget,
    RegionModel? region,
    String? occupation,
    NutritionStatusModel? nutritionStatus,
    List<String>? relatedHealthRecords,
    bool? isPrimary,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? nutritionProgress,
    int? totalEnergyPoints,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
  }) {
    return NutritionProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileName: profileName ?? this.profileName,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      activityLevelDetail: activityLevelDetail ?? this.activityLevelDetail,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      lifestyle: lifestyle ?? this.lifestyle,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      healthGoalDetails: healthGoalDetails ?? this.healthGoalDetails,
      activityDetails: activityDetails ?? this.activityDetails,
      targetWeight: targetWeight ?? this.targetWeight,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      preferredMealTimes: preferredMealTimes ?? this.preferredMealTimes,
      mealFrequency: mealFrequency ?? this.mealFrequency,
      cookingTimeBudget: cookingTimeBudget ?? this.cookingTimeBudget,
      region: region ?? this.region,
      occupation: occupation ?? this.occupation,
      nutritionStatus: nutritionStatus ?? this.nutritionStatus,
      relatedHealthRecords: relatedHealthRecords ?? this.relatedHealthRecords,
      isPrimary: isPrimary ?? this.isPrimary,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nutritionProgress: nutritionProgress ?? this.nutritionProgress,
      totalEnergyPoints: totalEnergyPoints ?? this.totalEnergyPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}

/// 饮食偏好模型
@JsonSerializable()
class DietaryPreferencesModel {
  final String? dietaryType;
  final List<String>? cuisinePreferences;
  final String? ethnicDietary;
  final String? religiousDietary;
  final TastePreferencesModel? tastePreferences;
  final List<String>? taboos;
  final List<String>? allergies;
  final List<String>? specialRequirements;
  final List<String>? forbiddenIngredients;
  final List<String>? nutritionPreferences;
  final bool? vegetarian;
  final bool? vegan;
  final bool? lowCarb;
  final bool? glutenFree;
  final bool? dairyFree;
  final bool? keto;
  final bool? paleo;
  final bool? halal;
  final bool? kosher;

  DietaryPreferencesModel({
    this.dietaryType,
    this.cuisinePreferences,
    this.ethnicDietary,
    this.religiousDietary,
    this.tastePreferences,
    this.taboos,
    this.allergies,
    this.specialRequirements,
    this.forbiddenIngredients,
    this.nutritionPreferences,
    this.vegetarian,
    this.vegan,
    this.lowCarb,
    this.glutenFree,
    this.dairyFree,
    this.keto,
    this.paleo,
    this.halal,
    this.kosher,
  });

  factory DietaryPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$DietaryPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$DietaryPreferencesModelToJson(this);
}

/// 口味偏好模型
@JsonSerializable()
class TastePreferencesModel {
  final int? spicy;  // 0-4
  final int? salty;  // 0-2
  final int? sweet;  // 0-2
  final int? sour;   // 0-2
  final int? oily;   // 0-2

  TastePreferencesModel({
    this.spicy,
    this.salty,
    this.sweet,
    this.sour,
    this.oily,
  });

  factory TastePreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$TastePreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$TastePreferencesModelToJson(this);
}

/// 生活方式模型
@JsonSerializable()
class LifestyleModel {
  final bool? smoking;
  final bool? drinking;
  final double? sleepDuration;
  final String? exerciseFrequency;
  final List<String>? exerciseTypes;
  final String? trainingIntensity;
  final double? weeklyExerciseHours;
  final String? preferredExerciseTime;
  final List<String>? specialStatus;

  LifestyleModel({
    this.smoking,
    this.drinking,
    this.sleepDuration,
    this.exerciseFrequency,
    this.exerciseTypes,
    this.trainingIntensity,
    this.weeklyExerciseHours,
    this.preferredExerciseTime,
    this.specialStatus,
  });

  factory LifestyleModel.fromJson(Map<String, dynamic> json) =>
      _$LifestyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$LifestyleModelToJson(this);
}

/// 地区模型
@JsonSerializable()
class RegionModel {
  final String? province;
  final String? city;

  RegionModel({
    this.province,
    this.city,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
}

/// 营养状态模型
@JsonSerializable()
class NutritionStatusModel {
  final List<String>? chronicDiseases;
  final List<String>? specialConditions;
  final List<String>? allergies;
  final String? notes;
  final Map<String, dynamic>? nutritionalBiomarkers;
  final Map<String, dynamic>? micronutrientStatus;
  final MetabolicIndicatorsModel? metabolicIndicators;
  final BodyCompositionModel? bodyComposition;

  NutritionStatusModel({
    this.chronicDiseases,
    this.specialConditions,
    this.allergies,
    this.notes,
    this.nutritionalBiomarkers,
    this.micronutrientStatus,
    this.metabolicIndicators,
    this.bodyComposition,
  });

  factory NutritionStatusModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionStatusModelToJson(this);
}

/// 代谢指标模型
@JsonSerializable()
class MetabolicIndicatorsModel {
  final BloodGlucoseModel? bloodGlucose;
  final LipidProfileModel? lipidProfile;

  MetabolicIndicatorsModel({
    this.bloodGlucose,
    this.lipidProfile,
  });

  factory MetabolicIndicatorsModel.fromJson(Map<String, dynamic> json) =>
      _$MetabolicIndicatorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetabolicIndicatorsModelToJson(this);
}

/// 血糖模型
@JsonSerializable()
class BloodGlucoseModel {
  final double? fasting;
  final double? postprandial;
  final double? hba1c;
  final DateTime? lastUpdated;

  BloodGlucoseModel({
    this.fasting,
    this.postprandial,
    this.hba1c,
    this.lastUpdated,
  });

  factory BloodGlucoseModel.fromJson(Map<String, dynamic> json) =>
      _$BloodGlucoseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BloodGlucoseModelToJson(this);
}

/// 血脂模型
@JsonSerializable()
class LipidProfileModel {
  final double? totalCholesterol;
  final double? hdl;
  final double? ldl;
  final double? triglycerides;
  final DateTime? lastUpdated;

  LipidProfileModel({
    this.totalCholesterol,
    this.hdl,
    this.ldl,
    this.triglycerides,
    this.lastUpdated,
  });

  factory LipidProfileModel.fromJson(Map<String, dynamic> json) =>
      _$LipidProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$LipidProfileModelToJson(this);
}

/// 身体成分模型
@JsonSerializable()
class BodyCompositionModel {
  final double? bodyFatPercentage;
  final double? muscleMass;
  final double? visceralFat;
  final double? boneDensity;
  final DateTime? lastUpdated;

  BodyCompositionModel({
    this.bodyFatPercentage,
    this.muscleMass,
    this.visceralFat,
    this.boneDensity,
    this.lastUpdated,
  });

  factory BodyCompositionModel.fromJson(Map<String, dynamic> json) =>
      _$BodyCompositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$BodyCompositionModelToJson(this);
}

/// 健康目标详细配置模型
@JsonSerializable()
class HealthGoalDetailsModel {
  final BloodSugarControlModel? bloodSugarControl;
  final BloodPressureControlModel? bloodPressureControl;
  final CholesterolManagementModel? cholesterolManagement;
  final WeightManagementModel? weightManagement;
  final SportsNutritionModel? sportsNutrition;
  final SpecialPhysiologicalModel? specialPhysiological;
  final DigestiveHealthModel? digestiveHealth;
  final ImmunityBoostModel? immunityBoost;

  HealthGoalDetailsModel({
    this.bloodSugarControl,
    this.bloodPressureControl,
    this.cholesterolManagement,
    this.weightManagement,
    this.sportsNutrition,
    this.specialPhysiological,
    this.digestiveHealth,
    this.immunityBoost,
  });

  factory HealthGoalDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HealthGoalDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthGoalDetailsModelToJson(this);
}

/// 血糖控制模型
@JsonSerializable()
class BloodSugarControlModel {
  final double? fastingGlucose;
  final double? postprandialGlucose;
  final double? hba1c;
  final String? diabetesType;
  final String? medicationStatus;
  final String? monitoringFrequency;

  BloodSugarControlModel({
    this.fastingGlucose,
    this.postprandialGlucose,
    this.hba1c,
    this.diabetesType,
    this.medicationStatus,
    this.monitoringFrequency,
  });

  factory BloodSugarControlModel.fromJson(Map<String, dynamic> json) =>
      _$BloodSugarControlModelFromJson(json);

  Map<String, dynamic> toJson() => _$BloodSugarControlModelToJson(this);
}

/// 血压管理模型
@JsonSerializable()
class BloodPressureControlModel {
  final double? systolic;
  final double? diastolic;
  final String? hypertensionGrade;
  final List<String>? medications;
  final bool? hasComplication;

  BloodPressureControlModel({
    this.systolic,
    this.diastolic,
    this.hypertensionGrade,
    this.medications,
    this.hasComplication,
  });

  factory BloodPressureControlModel.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureControlModelFromJson(json);

  Map<String, dynamic> toJson() => _$BloodPressureControlModelToJson(this);
}

/// 胆固醇管理模型
@JsonSerializable()
class CholesterolManagementModel {
  final double? totalCholesterol;
  final double? triglycerides;
  final double? ldlCholesterol;
  final double? hdlCholesterol;
  final bool? onStatins;

  CholesterolManagementModel({
    this.totalCholesterol,
    this.triglycerides,
    this.ldlCholesterol,
    this.hdlCholesterol,
    this.onStatins,
  });

  factory CholesterolManagementModel.fromJson(Map<String, dynamic> json) =>
      _$CholesterolManagementModelFromJson(json);

  Map<String, dynamic> toJson() => _$CholesterolManagementModelToJson(this);
}

/// 体重管理模型
@JsonSerializable()
class WeightManagementModel {
  final double? targetWeight;
  final double? targetBodyFat;
  final String? targetType;
  final String? targetSpeed;
  final DateTime? targetDate;
  final List<WeightHistoryModel>? weightHistory;

  WeightManagementModel({
    this.targetWeight,
    this.targetBodyFat,
    this.targetType,
    this.targetSpeed,
    this.targetDate,
    this.weightHistory,
  });

  factory WeightManagementModel.fromJson(Map<String, dynamic> json) =>
      _$WeightManagementModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeightManagementModelToJson(this);
}

/// 体重历史模型
@JsonSerializable()
class WeightHistoryModel {
  final DateTime? date;
  final double? weight;

  WeightHistoryModel({
    this.date,
    this.weight,
  });

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$WeightHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeightHistoryModelToJson(this);
}

/// 运动营养模型
@JsonSerializable()
class SportsNutritionModel {
  final List<String>? sportTypes;
  final String? trainingPhase;
  final DateTime? competitionDate;
  final List<SupplementModel>? supplementUse;

  SportsNutritionModel({
    this.sportTypes,
    this.trainingPhase,
    this.competitionDate,
    this.supplementUse,
  });

  factory SportsNutritionModel.fromJson(Map<String, dynamic> json) =>
      _$SportsNutritionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SportsNutritionModelToJson(this);
}

/// 补剂模型
@JsonSerializable()
class SupplementModel {
  final String? name;
  final String? dosage;
  final String? timing;

  SupplementModel({
    this.name,
    this.dosage,
    this.timing,
  });

  factory SupplementModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementModelToJson(this);
}

/// 特殊生理期模型
@JsonSerializable()
class SpecialPhysiologicalModel {
  final int? pregnancyWeek;
  final int? lactationMonth;
  final String? menopauseStage;
  final bool? fertilityPlanning;

  SpecialPhysiologicalModel({
    this.pregnancyWeek,
    this.lactationMonth,
    this.menopauseStage,
    this.fertilityPlanning,
  });

  factory SpecialPhysiologicalModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialPhysiologicalModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialPhysiologicalModelToJson(this);
}

/// 消化健康模型
@JsonSerializable()
class DigestiveHealthModel {
  final List<String>? symptoms;
  final List<String>? foodIntolerances;
  final String? hPyloriStatus;
  final GutMicrobiomeTestModel? gutMicrobiomeTest;

  DigestiveHealthModel({
    this.symptoms,
    this.foodIntolerances,
    this.hPyloriStatus,
    this.gutMicrobiomeTest,
  });

  factory DigestiveHealthModel.fromJson(Map<String, dynamic> json) =>
      _$DigestiveHealthModelFromJson(json);

  Map<String, dynamic> toJson() => _$DigestiveHealthModelToJson(this);
}

/// 肠道微生物检测模型
@JsonSerializable()
class GutMicrobiomeTestModel {
  final bool? tested;
  final DateTime? testDate;
  final String? results;

  GutMicrobiomeTestModel({
    this.tested,
    this.testDate,
    this.results,
  });

  factory GutMicrobiomeTestModel.fromJson(Map<String, dynamic> json) =>
      _$GutMicrobiomeTestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GutMicrobiomeTestModelToJson(this);
}

/// 免疫与抗炎模型
@JsonSerializable()
class ImmunityBoostModel {
  final List<String>? allergens;
  final List<String>? autoimmuneDiseases;
  final InflammationMarkersModel? inflammationMarkers;
  final String? infectionFrequency;

  ImmunityBoostModel({
    this.allergens,
    this.autoimmuneDiseases,
    this.inflammationMarkers,
    this.infectionFrequency,
  });

  factory ImmunityBoostModel.fromJson(Map<String, dynamic> json) =>
      _$ImmunityBoostModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImmunityBoostModelToJson(this);
}

/// 炎症标志物模型
@JsonSerializable()
class InflammationMarkersModel {
  final double? crp;
  final double? esr;

  InflammationMarkersModel({
    this.crp,
    this.esr,
  });

  factory InflammationMarkersModel.fromJson(Map<String, dynamic> json) =>
      _$InflammationMarkersModelFromJson(json);

  Map<String, dynamic> toJson() => _$InflammationMarkersModelToJson(this);
}