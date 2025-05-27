// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      shareNutritionDataWithNutritionist:
          json['share_nutrition_data_with_nutritionist'] as bool? ?? false,
      shareOrderHistoryWithMerchant:
          json['share_order_history_with_merchant'] as bool? ?? false,
      shareProfileInCommunity:
          json['share_profile_in_community'] as bool? ?? true,
      allowRecommendationBasedOnHistory:
          json['allow_recommendation_based_on_history'] as bool? ?? true,
      dataDeletionRequested: json['data_deletion_requested'] as bool? ?? false,
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      'share_nutrition_data_with_nutritionist':
          instance.shareNutritionDataWithNutritionist,
      'share_order_history_with_merchant':
          instance.shareOrderHistoryWithMerchant,
      'share_profile_in_community': instance.shareProfileInCommunity,
      'allow_recommendation_based_on_history':
          instance.allowRecommendationBasedOnHistory,
      'data_deletion_requested': instance.dataDeletionRequested,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      altUserId: json['userId'] as String?,
      phone: json['phone'] as String,
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      profileCompleted: json['profile_completed'] as bool? ?? false,
      autoRegistered: json['auto_registered'] as bool? ?? false,
      franchiseStoreId: json['franchise_store_id'] as String?,
      userType: json['user_type'] as String?,
      realName: json['real_name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      healthGoal: json['health_goal'] as String?,
      activityLevel: json['activity_level'] as String?,
      authType: json['auth_type'] as String?,
      accountStatus: json['account_status'] as String?,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      privacySettings: _privacySettingsFromJson(json['privacy_settings']),
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
  val['profile_completed'] = instance.profileCompleted;
  val['auto_registered'] = instance.autoRegistered;
  writeNotNull('franchise_store_id', instance.franchiseStoreId);
  writeNotNull('user_type', instance.userType);
  writeNotNull('real_name', instance.realName);
  writeNotNull('email', instance.email);
  writeNotNull('avatar_url', instance.avatarUrl);
  writeNotNull('gender', instance.gender);
  writeNotNull('birth_date', instance.birthDate?.toIso8601String());
  writeNotNull('height', instance.height);
  writeNotNull('weight', instance.weight);
  writeNotNull('age', instance.age);
  writeNotNull('health_goal', instance.healthGoal);
  writeNotNull('activity_level', instance.activityLevel);
  writeNotNull('auth_type', instance.authType);
  writeNotNull('account_status', instance.accountStatus);
  writeNotNull('last_login', instance.lastLogin?.toIso8601String());
  writeNotNull(
      'privacy_settings', _privacySettingsToJson(instance.privacySettings));
  return val;
}
