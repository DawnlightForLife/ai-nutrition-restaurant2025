class User {
  final String id;
  final String phone;
  final String nickname;
  final String role; // user / merchant / nutritionist / admin
  final String? avatarUrl;
  final String? province;
  final String? city;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;
  final String? activityLevel;
  final bool hasCompletedHealthInfo;
  final String? wechatOpenId;
  
  // 饮食偏好
  final String? cuisinePreference;
  final String? spicyPreference;
  final List<String>? allergies;
  final List<String>? avoidedIngredients;
  
  // 健康数据
  final bool? hasRecentMedicalReport;
  final String? medicalReportUrl;
  final List<String>? healthIssues;

  User({
    required this.id,
    required this.phone,
    this.nickname = '',
    this.role = 'user',
    this.avatarUrl,
    this.province,
    this.city,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.activityLevel,
    this.hasCompletedHealthInfo = false,
    this.wechatOpenId,
    this.cuisinePreference,
    this.spicyPreference,
    this.allergies,
    this.avoidedIngredients,
    this.hasRecentMedicalReport,
    this.medicalReportUrl,
    this.healthIssues,
  });

  // 从 JSON 构造 User 对象
  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> region = json['region'] ?? {};
    Map<String, dynamic> dietaryPreferences = json['dietaryPreferences'] ?? {};
    Map<String, dynamic> healthData = json['healthData'] ?? {};
    
    return User(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      nickname: json['nickname'] ?? '',
      role: json['role'] ?? 'user',
      avatarUrl: json['avatarUrl'],
      province: region['province'],
      city: region['city'],
      age: json['age'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      gender: json['gender'],
      activityLevel: json['activityLevel'],
      hasCompletedHealthInfo: json['hasCompletedHealthInfo'] ?? false,
      wechatOpenId: json['wechatOpenId'],
      cuisinePreference: dietaryPreferences['cuisinePreference'],
      spicyPreference: dietaryPreferences['spicyPreference'],
      allergies: dietaryPreferences['allergies'] != null 
          ? List<String>.from(dietaryPreferences['allergies']) 
          : null,
      avoidedIngredients: dietaryPreferences['avoidedIngredients'] != null 
          ? List<String>.from(dietaryPreferences['avoidedIngredients']) 
          : null,
      hasRecentMedicalReport: healthData['hasRecentMedicalReport'],
      medicalReportUrl: healthData['medicalReportUrl'],
      healthIssues: healthData['healthIssues'] != null 
          ? List<String>.from(healthData['healthIssues']) 
          : null,
    );
  }

  // 将 User 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'nickname': nickname,
      'role': role,
      'avatarUrl': avatarUrl,
      'region': {
        'province': province,
        'city': city,
      },
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'activityLevel': activityLevel,
      'hasCompletedHealthInfo': hasCompletedHealthInfo,
      'wechatOpenId': wechatOpenId,
      'dietaryPreferences': {
        'cuisinePreference': cuisinePreference,
        'spicyPreference': spicyPreference,
        'allergies': allergies,
        'avoidedIngredients': avoidedIngredients,
      },
      'healthData': {
        'hasRecentMedicalReport': hasRecentMedicalReport,
        'medicalReportUrl': medicalReportUrl,
        'healthIssues': healthIssues,
      }
    };
  }
}
