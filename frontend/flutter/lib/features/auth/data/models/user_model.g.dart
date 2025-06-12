// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      shareNutritionDataWithNutritionist:
          json['shareNutritionDataWithNutritionist'] as bool? ?? false,
      shareOrderHistoryWithMerchant:
          json['shareOrderHistoryWithMerchant'] as bool? ?? false,
      shareProfileInCommunity: json['shareProfileInCommunity'] as bool? ?? true,
      allowRecommendationBasedOnHistory:
          json['allowRecommendationBasedOnHistory'] as bool? ?? true,
      dataDeletionRequested: json['dataDeletionRequested'] as bool? ?? false,
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      'shareNutritionDataWithNutritionist':
          instance.shareNutritionDataWithNutritionist,
      'shareOrderHistoryWithMerchant': instance.shareOrderHistoryWithMerchant,
      'shareProfileInCommunity': instance.shareProfileInCommunity,
      'allowRecommendationBasedOnHistory':
          instance.allowRecommendationBasedOnHistory,
      'dataDeletionRequested': instance.dataDeletionRequested,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      altUserId: json['userId'] as String?,
      phone: json['phone'] as String,
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      autoRegistered: json['autoRegistered'] as bool? ?? false,
      franchiseStoreId: json['franchiseStoreId'] as String?,
      userType: json['userType'] as String?,
      realName: json['realName'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      healthGoal: json['healthGoal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      authType: json['authType'] as String?,
      accountStatus: json['accountStatus'] as String?,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      privacySettings: _privacySettingsFromJson(json['privacySettings']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      if (instance.altUserId case final value?) 'userId': value,
      'phone': instance.phone,
      'username': instance.username,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'role': instance.role,
      'profileCompleted': instance.profileCompleted,
      'autoRegistered': instance.autoRegistered,
      if (instance.franchiseStoreId case final value?)
        'franchiseStoreId': value,
      if (instance.userType case final value?) 'userType': value,
      if (instance.realName case final value?) 'realName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.avatarUrl case final value?) 'avatarUrl': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.birthDate?.toIso8601String() case final value?)
        'birthDate': value,
      if (instance.height case final value?) 'height': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.age case final value?) 'age': value,
      if (instance.healthGoal case final value?) 'healthGoal': value,
      if (instance.activityLevel case final value?) 'activityLevel': value,
      if (instance.authType case final value?) 'authType': value,
      if (instance.accountStatus case final value?) 'accountStatus': value,
      if (instance.lastLogin?.toIso8601String() case final value?)
        'lastLogin': value,
      if (_privacySettingsToJson(instance.privacySettings) case final value?)
        'privacySettings': value,
    };
