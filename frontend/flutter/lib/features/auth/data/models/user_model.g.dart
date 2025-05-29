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

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('userId', instance.altUserId);
  val['phone'] = instance.phone;
  val['username'] = instance.username;
  val['nickname'] = instance.nickname;
  val['avatar'] = instance.avatar;
  val['role'] = instance.role;
  val['profileCompleted'] = instance.profileCompleted;
  val['autoRegistered'] = instance.autoRegistered;
  writeNotNull('franchiseStoreId', instance.franchiseStoreId);
  writeNotNull('userType', instance.userType);
  writeNotNull('realName', instance.realName);
  writeNotNull('email', instance.email);
  writeNotNull('avatarUrl', instance.avatarUrl);
  writeNotNull('gender', instance.gender);
  writeNotNull('birthDate', instance.birthDate?.toIso8601String());
  writeNotNull('height', instance.height);
  writeNotNull('weight', instance.weight);
  writeNotNull('age', instance.age);
  writeNotNull('healthGoal', instance.healthGoal);
  writeNotNull('activityLevel', instance.activityLevel);
  writeNotNull('authType', instance.authType);
  writeNotNull('accountStatus', instance.accountStatus);
  writeNotNull('lastLogin', instance.lastLogin?.toIso8601String());
  writeNotNull(
      'privacySettings', _privacySettingsToJson(instance.privacySettings));
  return val;
}
