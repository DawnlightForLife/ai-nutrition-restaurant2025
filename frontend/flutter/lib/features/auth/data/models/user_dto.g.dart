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
      avatarUrl: json['avatar_url'] as String?,
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

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      '_id': instance.id,
      if (instance.email case final value?) 'email': value,
      'phone': instance.phone,
      if (instance.nickname case final value?) 'nickname': value,
      'role': instance.role,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.avatarUrl case final value?) 'avatar_url': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.age case final value?) 'age': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.lastLogin?.toIso8601String() case final value?)
        'last_login': value,
      if (instance.verification?.toJson() case final value?)
        'verification': value,
      if (instance.region?.toJson() case final value?) 'region': value,
      if (instance.dietaryPreferences?.toJson() case final value?)
        'dietary_preferences': value,
      if (instance.nutritionistCertification?.toJson() case final value?)
        'nutritionist_certification': value,
      if (instance.merchantCertification?.toJson() case final value?)
        'merchant_certification': value,
      if (instance.privacySettings?.toJson() case final value?)
        'privacy_settings': value,
      if (instance.cachedData?.toJson() case final value?) 'cached_data': value,
    };

VerificationDto _$VerificationDtoFromJson(Map<String, dynamic> json) =>
    VerificationDto(
      code: json['code'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$VerificationDtoToJson(VerificationDto instance) =>
    <String, dynamic>{
      if (instance.code case final value?) 'code': value,
      if (instance.expiresAt?.toIso8601String() case final value?)
        'expires_at': value,
    };

RegionDto _$RegionDtoFromJson(Map<String, dynamic> json) => RegionDto(
      province: json['province'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$RegionDtoToJson(RegionDto instance) => <String, dynamic>{
      if (instance.province case final value?) 'province': value,
      if (instance.city case final value?) 'city': value,
    };

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
        DietaryPreferencesDto instance) =>
    <String, dynamic>{
      if (instance.cuisinePreference case final value?)
        'cuisine_preference': value,
      if (instance.allergies case final value?) 'allergies': value,
      if (instance.avoidedIngredients case final value?)
        'avoided_ingredients': value,
      if (instance.spicyPreference case final value?) 'spicy_preference': value,
    };

NutritionistCertificationDto _$NutritionistCertificationDtoFromJson(
        Map<String, dynamic> json) =>
    NutritionistCertificationDto(
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$NutritionistCertificationDtoToJson(
        NutritionistCertificationDto instance) =>
    <String, dynamic>{
      if (instance.status case final value?) 'status': value,
      if (instance.rejectionReason case final value?) 'rejection_reason': value,
    };

MerchantCertificationDto _$MerchantCertificationDtoFromJson(
        Map<String, dynamic> json) =>
    MerchantCertificationDto(
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$MerchantCertificationDtoToJson(
        MerchantCertificationDto instance) =>
    <String, dynamic>{
      if (instance.status case final value?) 'status': value,
      if (instance.rejectionReason case final value?) 'rejection_reason': value,
    };

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

Map<String, dynamic> _$PrivacySettingsDtoToJson(PrivacySettingsDto instance) =>
    <String, dynamic>{
      if (instance.shareNutritionDataWithNutritionist case final value?)
        'share_nutrition_data_with_nutritionist': value,
      if (instance.shareOrderHistoryWithMerchant case final value?)
        'share_order_history_with_merchant': value,
      if (instance.shareProfileInCommunity case final value?)
        'share_profile_in_community': value,
      if (instance.allowRecommendationBasedOnHistory case final value?)
        'allow_recommendation_based_on_history': value,
      if (instance.dataDeletionRequested case final value?)
        'data_deletion_requested': value,
    };

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

Map<String, dynamic> _$CachedDataDtoToJson(CachedDataDto instance) =>
    <String, dynamic>{
      if (instance.orderStats?.toJson() case final value?) 'order_stats': value,
      if (instance.nutritionOverview?.toJson() case final value?)
        'nutrition_overview': value,
      if (instance.recommendationStats?.toJson() case final value?)
        'recommendation_stats': value,
    };

OrderStatsDto _$OrderStatsDtoFromJson(Map<String, dynamic> json) =>
    OrderStatsDto(
      totalOrders: (json['total_orders'] as num?)?.toInt(),
      totalSpent: (json['total_spent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderStatsDtoToJson(OrderStatsDto instance) =>
    <String, dynamic>{
      if (instance.totalOrders case final value?) 'total_orders': value,
      if (instance.totalSpent case final value?) 'total_spent': value,
    };

NutritionOverviewDto _$NutritionOverviewDtoFromJson(
        Map<String, dynamic> json) =>
    NutritionOverviewDto(
      nutritionTags: (json['nutrition_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NutritionOverviewDtoToJson(
        NutritionOverviewDto instance) =>
    <String, dynamic>{
      if (instance.nutritionTags case final value?) 'nutrition_tags': value,
    };

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
