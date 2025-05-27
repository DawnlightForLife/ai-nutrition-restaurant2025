// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['_id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String?,
      role: json['role'] as String,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      verification: json['verification'] == null
          ? null
          : VerificationDto.fromJson(
              json['verification'] as Map<String, dynamic>),
      region: json['region'] == null
          ? null
          : RegionDto.fromJson(json['region'] as Map<String, dynamic>),
      dietaryPreferences: json['dietary_preferences'] == null
          ? null
          : DietaryPreferencesDto.fromJson(
              json['dietary_preferences'] as Map<String, dynamic>),
      nutritionistCertification: json['nutritionist_certification'] == null
          ? null
          : NutritionistCertificationDto.fromJson(
              json['nutritionist_certification'] as Map<String, dynamic>),
      merchantCertification: json['merchant_certification'] == null
          ? null
          : MerchantCertificationDto.fromJson(
              json['merchant_certification'] as Map<String, dynamic>),
      privacySettings: json['privacy_settings'] == null
          ? null
          : PrivacySettingsDto.fromJson(
              json['privacy_settings'] as Map<String, dynamic>),
      cachedData: json['cached_data'] == null
          ? null
          : CachedDataDto.fromJson(json['cached_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  val['phone'] = instance.phone;
  writeNotNull('nickname', instance.nickname);
  val['role'] = instance.role;
  writeNotNull('avatar', instance.avatar);
  writeNotNull('gender', instance.gender);
  writeNotNull('age', instance.age);
  writeNotNull('is_active', instance.isActive);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  writeNotNull('last_login', instance.lastLogin?.toIso8601String());
  writeNotNull('verification', instance.verification?.toJson());
  writeNotNull('region', instance.region?.toJson());
  writeNotNull('dietary_preferences', instance.dietaryPreferences?.toJson());
  writeNotNull('nutritionist_certification',
      instance.nutritionistCertification?.toJson());
  writeNotNull(
      'merchant_certification', instance.merchantCertification?.toJson());
  writeNotNull('privacy_settings', instance.privacySettings?.toJson());
  writeNotNull('cached_data', instance.cachedData?.toJson());
  return val;
}

VerificationDto _$VerificationDtoFromJson(Map<String, dynamic> json) =>
    VerificationDto(
      code: json['code'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$VerificationDtoToJson(VerificationDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('expires_at', instance.expiresAt?.toIso8601String());
  return val;
}

RegionDto _$RegionDtoFromJson(Map<String, dynamic> json) => RegionDto(
      province: json['province'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$RegionDtoToJson(RegionDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('province', instance.province);
  writeNotNull('city', instance.city);
  return val;
}

DietaryPreferencesDto _$DietaryPreferencesDtoFromJson(
        Map<String, dynamic> json) =>
    DietaryPreferencesDto(
      cuisinePreference: json['cuisine_preference'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      avoidedIngredients: (json['avoided_ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spicyPreference: json['spicy_preference'] as String?,
    );

Map<String, dynamic> _$DietaryPreferencesDtoToJson(
    DietaryPreferencesDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cuisine_preference', instance.cuisinePreference);
  writeNotNull('allergies', instance.allergies);
  writeNotNull('avoided_ingredients', instance.avoidedIngredients);
  writeNotNull('spicy_preference', instance.spicyPreference);
  return val;
}

NutritionistCertificationDto _$NutritionistCertificationDtoFromJson(
        Map<String, dynamic> json) =>
    NutritionistCertificationDto(
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$NutritionistCertificationDtoToJson(
    NutritionistCertificationDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('rejection_reason', instance.rejectionReason);
  return val;
}

MerchantCertificationDto _$MerchantCertificationDtoFromJson(
        Map<String, dynamic> json) =>
    MerchantCertificationDto(
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$MerchantCertificationDtoToJson(
    MerchantCertificationDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('rejection_reason', instance.rejectionReason);
  return val;
}

PrivacySettingsDto _$PrivacySettingsDtoFromJson(Map<String, dynamic> json) =>
    PrivacySettingsDto(
      shareNutritionDataWithNutritionist:
          json['share_nutrition_data_with_nutritionist'] as bool?,
      shareOrderHistoryWithMerchant:
          json['share_order_history_with_merchant'] as bool?,
      shareProfileInCommunity: json['share_profile_in_community'] as bool?,
      allowRecommendationBasedOnHistory:
          json['allow_recommendation_based_on_history'] as bool?,
      dataDeletionRequested: json['data_deletion_requested'] as bool?,
    );

Map<String, dynamic> _$PrivacySettingsDtoToJson(PrivacySettingsDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('share_nutrition_data_with_nutritionist',
      instance.shareNutritionDataWithNutritionist);
  writeNotNull('share_order_history_with_merchant',
      instance.shareOrderHistoryWithMerchant);
  writeNotNull('share_profile_in_community', instance.shareProfileInCommunity);
  writeNotNull('allow_recommendation_based_on_history',
      instance.allowRecommendationBasedOnHistory);
  writeNotNull('data_deletion_requested', instance.dataDeletionRequested);
  return val;
}

CachedDataDto _$CachedDataDtoFromJson(Map<String, dynamic> json) =>
    CachedDataDto(
      orderStats: json['order_stats'] == null
          ? null
          : OrderStatsDto.fromJson(json['order_stats'] as Map<String, dynamic>),
      nutritionOverview: json['nutrition_overview'] == null
          ? null
          : NutritionOverviewDto.fromJson(
              json['nutrition_overview'] as Map<String, dynamic>),
      recommendationStats: json['recommendation_stats'] == null
          ? null
          : RecommendationStatsDto.fromJson(
              json['recommendation_stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CachedDataDtoToJson(CachedDataDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('order_stats', instance.orderStats?.toJson());
  writeNotNull('nutrition_overview', instance.nutritionOverview?.toJson());
  writeNotNull('recommendation_stats', instance.recommendationStats?.toJson());
  return val;
}

OrderStatsDto _$OrderStatsDtoFromJson(Map<String, dynamic> json) =>
    OrderStatsDto(
      totalOrders: (json['total_orders'] as num?)?.toInt(),
      totalSpent: (json['total_spent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderStatsDtoToJson(OrderStatsDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total_orders', instance.totalOrders);
  writeNotNull('total_spent', instance.totalSpent);
  return val;
}

NutritionOverviewDto _$NutritionOverviewDtoFromJson(
        Map<String, dynamic> json) =>
    NutritionOverviewDto(
      nutritionTags: (json['nutrition_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NutritionOverviewDtoToJson(
    NutritionOverviewDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('nutrition_tags', instance.nutritionTags);
  return val;
}

RecommendationStatsDto _$RecommendationStatsDtoFromJson(
        Map<String, dynamic> json) =>
    RecommendationStatsDto();

Map<String, dynamic> _$RecommendationStatsDtoToJson(
        RecommendationStatsDto instance) =>
    <String, dynamic>{};

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      token: json['token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseDtoToJson(AuthResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'token': instance.token,
      'user': instance.user.toJson(),
    };
