/// 营养推荐档案模型类
/// 与账号本身分开，一个账号可建立多个档案（自己、家人等）
class NutritionProfile {
  final String id;
  final String user_id;
  final String name;
  final String? description;
  final double? height;
  final double? weight;
  final int? age;
  final String? gender;
  final String? activityLevel;
  final List<String>? healthConditions;
  final String? goals;
  final List<String>? allergies;
  final List<String>? avoidedIngredients;
  final String? cuisinePreference;
  final String? spicyPreference;
  final DietaryPreferences? dietaryPreferences;
  final bool hasCompletedHealthInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  NutritionProfile({
    required this.id,
    required this.user_id,
    required this.name,
    this.description,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.activityLevel,
    this.healthConditions,
    this.goals,
    this.allergies,
    this.avoidedIngredients,
    this.cuisinePreference,
    this.spicyPreference,
    this.dietaryPreferences,
    this.hasCompletedHealthInfo = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // 计算BMI指数
  double? get bmi {
    if (height != null && weight != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }

  // 从JSON创建NutritionProfile对象
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    return NutritionProfile(
      id: json['_id'] ?? json['id'] ?? '',
      user_id: json['user_id'] ?? json['ownerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      age: json['age'],
      gender: json['gender'],
      activityLevel: json['activityLevel'] ?? json['activity_level'],
      healthConditions: json['healthConditions'] != null 
          ? List<String>.from(json['healthConditions']) 
          : null,
      goals: json['goals'],
      allergies: json['allergies'] != null 
          ? List<String>.from(json['allergies']) 
          : null,
      avoidedIngredients: json['avoidedIngredients'] != null 
          ? List<String>.from(json['avoidedIngredients']) 
          : null,
      cuisinePreference: json['cuisinePreference'] ?? json['cuisine_preference'],
      spicyPreference: json['spicyPreference'] ?? json['spicy_preference'],
      dietaryPreferences: json['dietaryPreferences'] != null 
          ? DietaryPreferences.fromJson(json['dietaryPreferences']) 
          : (json['dietary_preferences'] != null
              ? DietaryPreferences.fromJson(json['dietary_preferences'])
              : null),
      hasCompletedHealthInfo: json['hasCompletedHealthInfo'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : (json['created_at'] != null 
              ? DateTime.parse(json['created_at']) 
              : DateTime.now()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : (json['updated_at'] != null 
              ? DateTime.parse(json['updated_at']) 
              : DateTime.now()),
    );
  }

  // 将NutritionProfile对象转换为JSON
  Map<String, dynamic> toJson() {
    final map = {
      '_id': id,
      'name': name,
      'user_id': user_id,
      'description': description,
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'activityLevel': activityLevel,
      'healthConditions': healthConditions,
      'goals': goals,
      'hasCompletedHealthInfo': hasCompletedHealthInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    
    // 如果有饮食偏好，则添加饮食偏好对象
    if (dietaryPreferences != null) {
      map['dietaryPreferences'] = dietaryPreferences!.toJson();
    } else {
      // 如果没有饮食偏好对象但有单独的偏好字段，则创建饮食偏好对象
      if (cuisinePreference != null || spicyPreference != null || allergies != null || avoidedIngredients != null) {
        map['dietaryPreferences'] = {
          'cuisinePreference': cuisinePreference,
          'spicyPreference': spicyPreference,
          'allergies': allergies,
          'avoidedIngredients': avoidedIngredients,
        };
      }
    }
    
    return map;
  }

  // 返回营养档案的调试信息
  @override
  String toString() {
    return 'NutritionProfile{id: $id, name: $name, user_id: $user_id, '
           'height: $height, weight: $weight, age: $age}';
  }

  // 创建带有更新属性的NutritionProfile副本
  NutritionProfile copyWith({
    String? id,
    String? name,
    String? user_id,
    String? description,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? activityLevel,
    List<String>? healthConditions,
    String? goals,
    List<String>? allergies,
    List<String>? avoidedIngredients,
    String? cuisinePreference,
    String? spicyPreference,
    DietaryPreferences? dietaryPreferences,
    bool? hasCompletedHealthInfo,
  }) {
    return NutritionProfile(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      name: name ?? this.name,
      description: description ?? this.description,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      healthConditions: healthConditions ?? this.healthConditions,
      goals: goals ?? this.goals,
      allergies: allergies ?? this.allergies,
      avoidedIngredients: avoidedIngredients ?? this.avoidedIngredients,
      cuisinePreference: cuisinePreference ?? this.cuisinePreference,
      spicyPreference: spicyPreference ?? this.spicyPreference,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      hasCompletedHealthInfo: hasCompletedHealthInfo ?? this.hasCompletedHealthInfo,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class DietaryPreferences {
  final String? cuisinePreference;
  final String? spicyPreference;
  final List<String>? allergies;
  final List<String>? avoidedIngredients;

  DietaryPreferences({
    this.cuisinePreference,
    this.spicyPreference,
    this.allergies,
    this.avoidedIngredients,
  });

  factory DietaryPreferences.fromJson(Map<String, dynamic> json) {
    return DietaryPreferences(
      cuisinePreference: json['cuisinePreference'],
      spicyPreference: json['spicyPreference'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      avoidedIngredients: json['avoidedIngredients'] != null
          ? List<String>.from(json['avoidedIngredients'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisinePreference': cuisinePreference,
      'spicyPreference': spicyPreference,
      'allergies': allergies,
      'avoidedIngredients': avoidedIngredients,
    };
  }
}
