import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// Privacy settings to handle nested booleans
@JsonSerializable()
class PrivacySettings {
  @JsonKey(defaultValue: false)
  final bool shareNutritionDataWithNutritionist;
  
  @JsonKey(defaultValue: false)
  final bool shareOrderHistoryWithMerchant;
  
  @JsonKey(defaultValue: true)
  final bool shareProfileInCommunity;
  
  @JsonKey(defaultValue: true)
  final bool allowRecommendationBasedOnHistory;
  
  @JsonKey(defaultValue: false)
  final bool dataDeletionRequested;
  
  PrivacySettings({
    required this.shareNutritionDataWithNutritionist,
    required this.shareOrderHistoryWithMerchant,
    required this.shareProfileInCommunity,
    required this.allowRecommendationBasedOnHistory,
    required this.dataDeletionRequested,
  });
  
  factory PrivacySettings.fromJson(Map<String, dynamic> json) => _$PrivacySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PrivacySettingsToJson(this);
}

@JsonSerializable()
class UserModel {
  // Handle both _id and userId fields
  @JsonKey(name: '_id')
  final String? id;
  
  @JsonKey(name: 'userId')
  final String? altUserId;
  
  final String phone;
  
  @JsonKey(defaultValue: '')
  final String username;
  
  @JsonKey(defaultValue: '')
  final String nickname;
  
  @JsonKey(defaultValue: '')
  final String avatar;
  
  @JsonKey(defaultValue: 'customer')
  final String role;
  
  @JsonKey(defaultValue: false)
  final bool profileCompleted;
  
  @JsonKey(defaultValue: false)
  final bool autoRegistered;
  
  final String? franchiseStoreId;
  final String? userType;
  
  // 额外的个人信息
  final String? realName;
  final String? email;
  final String? avatarUrl;
  final String? gender;
  final DateTime? birthDate;
  final double? height;
  final double? weight;
  final int? age;
  final String? healthGoal;
  final String? activityLevel;
  final String? authType;
  final String? accountStatus;
  final DateTime? lastLogin;
  
  // Handle privacy settings safely
  @JsonKey(fromJson: _privacySettingsFromJson, toJson: _privacySettingsToJson)
  final PrivacySettings? privacySettings;
  
  // Ignore complex nested objects that might cause issues
  @JsonKey(includeFromJson: false)
  final dynamic verification;
  
  @JsonKey(includeFromJson: false)
  final dynamic region;
  
  @JsonKey(includeFromJson: false)
  final dynamic dietaryPreferences;
  
  @JsonKey(includeFromJson: false)
  final dynamic nutritionistCertification;
  
  @JsonKey(includeFromJson: false)
  final dynamic merchantCertification;
  
  @JsonKey(includeFromJson: false)
  final dynamic cachedData;
  
  @JsonKey(includeFromJson: false)
  final dynamic dataAccessControls;
  
  UserModel({
    this.id,
    this.altUserId,
    required this.phone,
    this.username = '',
    this.nickname = '',
    this.avatar = '',
    this.role = 'customer',
    this.profileCompleted = false,
    this.autoRegistered = false,
    this.franchiseStoreId,
    this.userType,
    this.realName,
    this.email,
    this.avatarUrl,
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.age,
    this.healthGoal,
    this.activityLevel,
    this.authType,
    this.accountStatus,
    this.lastLogin,
    this.privacySettings,
    this.verification,
    this.region,
    this.dietaryPreferences,
    this.nutritionistCertification,
    this.merchantCertification,
    this.cachedData,
    this.dataAccessControls,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 安全地处理所有可能的null值
    final cleanedJson = <String, dynamic>{};
    
    // 基础字段
    cleanedJson['_id'] = json['_id'];
    cleanedJson['userId'] = json['userId'];
    cleanedJson['phone'] = json['phone'] ?? '';
    cleanedJson['username'] = json['username'] ?? '';
    cleanedJson['nickname'] = json['nickname'] ?? '';
    cleanedJson['avatar'] = json['avatar'] ?? '';
    cleanedJson['role'] = json['role'] ?? 'customer';
    
    // 布尔字段，确保不为null
    cleanedJson['profileCompleted'] = json['profileCompleted'] ?? false;
    cleanedJson['autoRegistered'] = json['autoRegistered'] ?? false;
    
    // 其他字段
    cleanedJson['franchiseStoreId'] = json['franchiseStoreId'];
    cleanedJson['userType'] = json['userType'];
    cleanedJson['realName'] = json['realName'];
    cleanedJson['email'] = json['email'];
    cleanedJson['avatarUrl'] = json['avatarUrl'];
    cleanedJson['gender'] = json['gender'];
    cleanedJson['birthDate'] = json['birthDate'];
    cleanedJson['height'] = json['height'];
    cleanedJson['weight'] = json['weight'];
    cleanedJson['age'] = json['age'];
    cleanedJson['healthGoal'] = json['healthGoal'];
    cleanedJson['activityLevel'] = json['activityLevel'];
    cleanedJson['authType'] = json['authType'];
    cleanedJson['accountStatus'] = json['accountStatus'];
    cleanedJson['lastLogin'] = json['lastLogin'];
    
    // 安全地处理privacySettings
    if (json['privacySettings'] != null) {
      cleanedJson['privacySettings'] = json['privacySettings'];
    }
    
    return _$UserModelFromJson(cleanedJson);
  }
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  // 检查是否需要完善资料
  bool get needCompleteProfile => autoRegistered && !profileCompleted;
  
  // 获取显示名称
  String get displayName => nickname.isNotEmpty ? nickname : realName ?? '用户${phone.substring(phone.length - 4)}';
  
  // 获取用户ID（兼容两种格式）
  String get userId => id ?? altUserId ?? '';
  
  // 是否有特殊角色
  bool get hasSpecialRole => role != 'customer' && role != 'user';
}

// Custom converter for privacy settings
PrivacySettings? _privacySettingsFromJson(dynamic json) {
  if (json == null) return null;
  if (json is Map<String, dynamic>) {
    try {
      // 确保所有布尔字段都有默认值
      final cleanedJson = <String, dynamic>{
        'shareNutritionDataWithNutritionist': json['shareNutritionDataWithNutritionist'] ?? false,
        'shareOrderHistoryWithMerchant': json['shareOrderHistoryWithMerchant'] ?? false,
        'shareProfileInCommunity': json['shareProfileInCommunity'] ?? true,
        'allowRecommendationBasedOnHistory': json['allowRecommendationBasedOnHistory'] ?? true,
        'dataDeletionRequested': json['dataDeletionRequested'] ?? false,
      };
      return PrivacySettings.fromJson(cleanedJson);
    } catch (e) {
      print('解析privacySettings失败: $e');
      return null;
    }
  }
  return null;
}

Map<String, dynamic>? _privacySettingsToJson(PrivacySettings? settings) {
  return settings?.toJson();
}