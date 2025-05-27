import '../../common/entities/entity.dart';
import '../../user/value_objects/user_id.dart';

/// 营养档案实体
class NutritionProfile extends Entity {
  final UserId userId;
  final double? height; // 身高(cm)
  final double? weight; // 体重(kg)
  final DateTime? birthDate; // 出生日期
  final String? gender; // 性别
  final String? activityLevel; // 活动水平
  final List<String> allergies; // 过敏原
  final List<String> dietaryRestrictions; // 饮食限制
  final List<String> healthConditions; // 健康状况
  final Map<String, dynamic> nutritionGoals; // 营养目标
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionProfile({
    required this.userId,
    this.height,
    this.weight,
    this.birthDate,
    this.gender,
    this.activityLevel,
    this.allergies = const [],
    this.dietaryRestrictions = const [],
    this.healthConditions = const [],
    this.nutritionGoals = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建默认营养档案
  factory NutritionProfile.createDefault({required UserId userId}) {
    final now = DateTime.now();
    return NutritionProfile(
      userId: userId,
      allergies: const [],
      dietaryRestrictions: const [],
      healthConditions: const [],
      nutritionGoals: const {
        'dailyCalories': 2000,
        'proteinRatio': 0.3,
        'carbsRatio': 0.4,
        'fatRatio': 0.3,
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 计算BMI
  double? get bmi {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// 计算年龄
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month || 
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  /// 是否完整填写
  bool get isComplete {
    return height != null &&
           weight != null &&
           birthDate != null &&
           gender != null &&
           activityLevel != null;
  }

  /// 创建副本
  NutritionProfile copyWith({
    UserId? userId,
    double? height,
    double? weight,
    DateTime? birthDate,
    String? gender,
    String? activityLevel,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    List<String>? healthConditions,
    Map<String, dynamic>? nutritionGoals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfile(
      userId: userId ?? this.userId,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      allergies: allergies ?? this.allergies,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      healthConditions: healthConditions ?? this.healthConditions,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        userId,
        height,
        weight,
        birthDate,
        gender,
        activityLevel,
        allergies,
        dietaryRestrictions,
        healthConditions,
        nutritionGoals,
        createdAt,
        updatedAt,
      ];
} 