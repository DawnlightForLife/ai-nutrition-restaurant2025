import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_model.freezed.dart';
part 'merchant_model.g.dart';

/// 商家模型
@freezed
class MerchantModel with _$MerchantModel {
  const factory MerchantModel({
    required String id,
    @JsonKey(name: 'businessName') String? businessName,
    @JsonKey(name: 'businessType') String? businessType,
    @JsonKey(name: 'registrationNumber') String? registrationNumber,
    @JsonKey(name: 'taxId') String? taxId,
    ContactInfo? contact,
    AddressInfo? address,
    @JsonKey(name: 'businessProfile') BusinessProfile? businessProfile,
    @JsonKey(name: 'nutritionFeatures') NutritionFeatures? nutritionFeatures,
    VerificationInfo? verification,
    @JsonKey(name: 'accountStatus') AccountStatus? accountStatus,
    MerchantStats? stats,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @JsonKey(name: 'isOpen') @Default(false) bool isOpen,
  }) = _MerchantModel;

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);
}

/// 联系信息
@freezed
class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    String? email,
    String? phone,
    String? alternativePhone,
    String? website,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}

/// 地址信息
@freezed
class AddressInfo with _$AddressInfo {
  const factory AddressInfo({
    String? line1,
    String? line2,
    String? city,
    String? state,
    @JsonKey(name: 'postalCode') String? postalCode,
    @Default('China') String country,
    Coordinates? coordinates,
  }) = _AddressInfo;

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);
}

/// 坐标信息
@freezed
class Coordinates with _$Coordinates {
  const factory Coordinates({
    double? latitude,
    double? longitude,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}

/// 商家简介
@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    String? description,
    @JsonKey(name: 'establishmentYear') int? establishmentYear,
    @JsonKey(name: 'operatingHours') @Default([]) List<String> operatingHours,
    @JsonKey(name: 'cuisineTypes') @Default([]) List<String> cuisineTypes,
    @Default([]) List<String> facilities,
    @Default([]) List<String> images,
    @JsonKey(name: 'logoUrl') String? logoUrl,
    @JsonKey(name: 'averagePriceRange') Map<String, dynamic>? averagePriceRange,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}

/// 营养特色
@freezed
class NutritionFeatures with _$NutritionFeatures {
  const factory NutritionFeatures({
    @JsonKey(name: 'hasNutritionist') @Default(false) bool hasNutritionist,
    @JsonKey(name: 'nutritionCertified') @Default(false) bool nutritionCertified,
    @JsonKey(name: 'certificationDetails') String? certificationDetails,
    @JsonKey(name: 'specialtyDiets') List<String>? specialtyDiets,
  }) = _NutritionFeatures;

  factory NutritionFeatures.fromJson(Map<String, dynamic> json) =>
      _$NutritionFeaturesFromJson(json);
}

/// 认证信息
@freezed
class VerificationInfo with _$VerificationInfo {
  const factory VerificationInfo({
    @JsonKey(name: 'isVerified') @Default(false) bool isVerified,
    @JsonKey(name: 'verificationStatus') @Default('pending') String verificationStatus,
    @JsonKey(name: 'verifiedAt') DateTime? verifiedAt,
    @JsonKey(name: 'verifiedBy') String? verifiedBy,
    @JsonKey(name: 'verificationNotes') String? verificationNotes,
    @JsonKey(name: 'rejectionReason') String? rejectionReason,
    @JsonKey(name: 'verificationDocuments') List<VerificationDocument>? verificationDocuments,
  }) = _VerificationInfo;

  factory VerificationInfo.fromJson(Map<String, dynamic> json) =>
      _$VerificationInfoFromJson(json);
}

/// 认证文档
@freezed
class VerificationDocument with _$VerificationDocument {
  const factory VerificationDocument({
    @JsonKey(name: 'documentType') String? documentType,
    @JsonKey(name: 'documentUrl') String? documentUrl,
    @JsonKey(name: 'uploadedAt') DateTime? uploadedAt,
    @Default('pending') String status,
  }) = _VerificationDocument;

  factory VerificationDocument.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentFromJson(json);
}

/// 账户状态
@freezed
class AccountStatus with _$AccountStatus {
  const factory AccountStatus({
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @JsonKey(name: 'suspensionReason') String? suspensionReason,
    @JsonKey(name: 'suspendedAt') DateTime? suspendedAt,
    @JsonKey(name: 'suspendedBy') String? suspendedBy,
    @JsonKey(name: 'suspensionEndDate') DateTime? suspensionEndDate,
  }) = _AccountStatus;

  factory AccountStatus.fromJson(Map<String, dynamic> json) =>
      _$AccountStatusFromJson(json);
}

/// 商家统计
@freezed
class MerchantStats with _$MerchantStats {
  const factory MerchantStats({
    @JsonKey(name: 'totalOrders') @Default(0) int totalOrders,
    @JsonKey(name: 'totalSales') @Default(0.0) double totalSales,
    @JsonKey(name: 'avgOrderValue') @Default(0.0) double avgOrderValue,
    @JsonKey(name: 'avgRating') @Default(0.0) double avgRating,
    @JsonKey(name: 'ratingCount') @Default(0) int ratingCount,
    @JsonKey(name: 'healthScore') @Default(80) int healthScore,
  }) = _MerchantStats;

  factory MerchantStats.fromJson(Map<String, dynamic> json) =>
      _$MerchantStatsFromJson(json);
}