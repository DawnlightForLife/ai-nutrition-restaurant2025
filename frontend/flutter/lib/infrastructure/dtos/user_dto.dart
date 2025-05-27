import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// 用户数据传输对象
/// 对应后端API返回的用户数据结构
@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String id;
  final String? email;
  final String phone;
  final String? nickname;
  final String role;
  final String? avatar;
  final String? gender;
  final int? age;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  
  // 嵌套对象
  final VerificationDto? verification;
  final RegionDto? region;
  final DietaryPreferencesDto? dietaryPreferences;
  final NutritionistCertificationDto? nutritionistCertification;
  final MerchantCertificationDto? merchantCertification;
  final PrivacySettingsDto? privacySettings;
  final CachedDataDto? cachedData;

  const UserDto({
    required this.id,
    this.email,
    required this.phone,
    this.nickname,
    required this.role,
    this.avatar,
    this.gender,
    this.age,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.verification,
    this.region,
    this.dietaryPreferences,
    this.nutritionistCertification,
    this.merchantCertification,
    this.privacySettings,
    this.cachedData,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable()
class VerificationDto {
  final String? code;
  final DateTime? expiresAt;

  const VerificationDto({
    this.code,
    this.expiresAt,
  });

  factory VerificationDto.fromJson(Map<String, dynamic> json) => _$VerificationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationDtoToJson(this);
}

@JsonSerializable()
class RegionDto {
  final String? province;
  final String? city;

  const RegionDto({
    this.province,
    this.city,
  });

  factory RegionDto.fromJson(Map<String, dynamic> json) => _$RegionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegionDtoToJson(this);
}

@JsonSerializable()
class DietaryPreferencesDto {
  final String? cuisinePreference;
  final List<String>? allergies;
  final List<String>? avoidedIngredients;
  final String? spicyPreference;

  const DietaryPreferencesDto({
    this.cuisinePreference,
    this.allergies,
    this.avoidedIngredients,
    this.spicyPreference,
  });

  factory DietaryPreferencesDto.fromJson(Map<String, dynamic> json) => _$DietaryPreferencesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DietaryPreferencesDtoToJson(this);
}

@JsonSerializable()
class NutritionistCertificationDto {
  final String? status;
  final String? rejectionReason;

  const NutritionistCertificationDto({
    this.status,
    this.rejectionReason,
  });

  factory NutritionistCertificationDto.fromJson(Map<String, dynamic> json) => _$NutritionistCertificationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionistCertificationDtoToJson(this);
}

@JsonSerializable()
class MerchantCertificationDto {
  final String? status;
  final String? rejectionReason;

  const MerchantCertificationDto({
    this.status,
    this.rejectionReason,
  });

  factory MerchantCertificationDto.fromJson(Map<String, dynamic> json) => _$MerchantCertificationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantCertificationDtoToJson(this);
}

@JsonSerializable()
class PrivacySettingsDto {
  final bool? shareNutritionDataWithNutritionist;
  final bool? shareOrderHistoryWithMerchant;
  final bool? shareProfileInCommunity;
  final bool? allowRecommendationBasedOnHistory;
  final bool? dataDeletionRequested;

  const PrivacySettingsDto({
    this.shareNutritionDataWithNutritionist,
    this.shareOrderHistoryWithMerchant,
    this.shareProfileInCommunity,
    this.allowRecommendationBasedOnHistory,
    this.dataDeletionRequested,
  });

  factory PrivacySettingsDto.fromJson(Map<String, dynamic> json) => _$PrivacySettingsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PrivacySettingsDtoToJson(this);
}

@JsonSerializable()
class CachedDataDto {
  final OrderStatsDto? orderStats;
  final NutritionOverviewDto? nutritionOverview;
  final RecommendationStatsDto? recommendationStats;

  const CachedDataDto({
    this.orderStats,
    this.nutritionOverview,
    this.recommendationStats,
  });

  factory CachedDataDto.fromJson(Map<String, dynamic> json) => _$CachedDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CachedDataDtoToJson(this);
}

@JsonSerializable()
class OrderStatsDto {
  final int? totalOrders;
  final double? totalSpent;

  const OrderStatsDto({
    this.totalOrders,
    this.totalSpent,
  });

  factory OrderStatsDto.fromJson(Map<String, dynamic> json) => _$OrderStatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStatsDtoToJson(this);
}

@JsonSerializable()
class NutritionOverviewDto {
  final List<String>? nutritionTags;

  const NutritionOverviewDto({
    this.nutritionTags,
  });

  factory NutritionOverviewDto.fromJson(Map<String, dynamic> json) => _$NutritionOverviewDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionOverviewDtoToJson(this);
}

@JsonSerializable()
class RecommendationStatsDto {
  const RecommendationStatsDto();

  factory RecommendationStatsDto.fromJson(Map<String, dynamic> json) => _$RecommendationStatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationStatsDtoToJson(this);
}

/// 认证响应DTO
@JsonSerializable()
class AuthResponseDto {
  final bool success;
  final String message;
  final String token;
  final UserDto user;

  const AuthResponseDto({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) => _$AuthResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
} 