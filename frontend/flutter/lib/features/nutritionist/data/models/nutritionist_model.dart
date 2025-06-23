import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist.dart';

part 'nutritionist_model.freezed.dart';
part 'nutritionist_model.g.dart';

@freezed
class PersonalInfoModel with _$PersonalInfoModel {
  const factory PersonalInfoModel({
    required String realName,
    required String idCardNumber,
  }) = _PersonalInfoModel;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);
}

@freezed
class QualificationsModel with _$QualificationsModel {
  const factory QualificationsModel({
    required String licenseNumber,
    String? licenseImageUrl,
    @Default([]) List<String> certificationImages,
    String? professionalTitle,
    String? certificationLevel,
    String? issuingAuthority,
    DateTime? issueDate,
    DateTime? expiryDate,
    @Default(false) bool verified,
  }) = _QualificationsModel;

  factory QualificationsModel.fromJson(Map<String, dynamic> json) =>
      _$QualificationsModelFromJson(json);
}

@freezed
class ProfessionalInfoModel with _$ProfessionalInfoModel {
  const factory ProfessionalInfoModel({
    @Default([]) List<String> specializations,
    @Default(0) int experienceYears,
    @Default([]) List<Map<String, dynamic>> education,
    @Default([]) List<String> languages,
    String? bio,
  }) = _ProfessionalInfoModel;

  factory ProfessionalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalInfoModelFromJson(json);
}

@freezed
class ServiceInfoModel with _$ServiceInfoModel {
  const factory ServiceInfoModel({
    @Default(0) double consultationFee,
    @Default(60) int consultationDuration,
    @Default(true) bool availableOnline,
    @Default(false) bool availableInPerson,
    @Default([]) List<Map<String, dynamic>> inPersonLocations,
    @Default([]) List<String> serviceTags,
    @Default([]) List<Map<String, dynamic>> availableTimeSlots,
  }) = _ServiceInfoModel;

  factory ServiceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceInfoModelFromJson(json);
}

@freezed
class RatingsModel with _$RatingsModel {
  const factory RatingsModel({
    @Default(0.0) double averageRating,
    @Default(0) int totalReviews,
  }) = _RatingsModel;

  factory RatingsModel.fromJson(Map<String, dynamic> json) =>
      _$RatingsModelFromJson(json);
}

@freezed
class VerificationModel with _$VerificationModel {
  const factory VerificationModel({
    @Default('pending') String verificationStatus,
    String? rejectedReason,
    String? reviewedBy,
    DateTime? reviewedAt,
    @Default([]) List<Map<String, dynamic>> verificationHistory,
  }) = _VerificationModel;

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationModelFromJson(json);
}

@freezed
class OnlineStatusModel with _$OnlineStatusModel {
  const factory OnlineStatusModel({
    @Default(false) bool isOnline,
    @Default(false) bool isAvailable,
    DateTime? lastActiveAt,
    String? statusMessage,
    @Default([]) List<String> availableConsultationTypes,
    @Default(0.0) double averageResponseTime,
    DateTime? lastUpdated,
  }) = _OnlineStatusModel;

  factory OnlineStatusModel.fromJson(Map<String, dynamic> json) =>
      _$OnlineStatusModelFromJson(json);
}

/// Nutritionist 数据模型
@freezed
class NutritionistModel with _$NutritionistModel {
  const factory NutritionistModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    String? certificationApplicationId,
    required PersonalInfoModel personalInfo,
    required QualificationsModel qualifications,
    required ProfessionalInfoModel professionalInfo,
    required ServiceInfoModel serviceInfo,
    required RatingsModel ratings,
    @Default('pendingVerification') String status,
    required VerificationModel verification,
    @Default([]) List<Map<String, dynamic>> affiliations,
    OnlineStatusModel? onlineStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _NutritionistModel;

  factory NutritionistModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionistModelFromJson(json);
      
  const NutritionistModel._();
  
  /// 转换为实体
  Nutritionist toEntity() {
    // 解析可用咨询类型
    final availableTypes = <ConsultationType>[];
    if (onlineStatus?.availableConsultationTypes != null) {
      for (final type in onlineStatus!.availableConsultationTypes) {
        switch (type) {
          case 'text':
            availableTypes.add(ConsultationType.text);
            break;
          case 'voice':
            availableTypes.add(ConsultationType.voice);
            break;
          case 'video':
            availableTypes.add(ConsultationType.video);
            break;
          case 'offline':
            availableTypes.add(ConsultationType.offline);
            break;
        }
      }
    }

    return Nutritionist(
      id: id,
      userId: userId,
      name: personalInfo.realName,
      specializations: professionalInfo.specializations,
      experienceYears: professionalInfo.experienceYears,
      bio: professionalInfo.bio ?? '',
      avatarUrl: '',
      rating: ratings.averageRating,
      reviewCount: ratings.totalReviews,
      consultationFee: serviceInfo.consultationFee,
      languages: professionalInfo.languages,
      certifications: qualifications.certificationImages,
      isOnlineAvailable: serviceInfo.availableOnline,
      isInPersonAvailable: serviceInfo.availableInPerson,
      verificationStatus: verification.verificationStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      // 在线状态字段
      isOnline: onlineStatus?.isOnline ?? false,
      isAvailable: onlineStatus?.isAvailable ?? false,
      lastActiveAt: onlineStatus?.lastActiveAt,
      statusMessage: onlineStatus?.statusMessage,
      availableConsultationTypes: availableTypes,
      responseTime: onlineStatus?.averageResponseTime ?? 0.0,
    );
  }
  
  /// 从实体创建
  factory NutritionistModel.fromEntity(Nutritionist entity) {
    // 转换咨询类型
    final consultationTypes = entity.availableConsultationTypes.map((type) {
      switch (type) {
        case ConsultationType.text:
          return 'text';
        case ConsultationType.voice:
          return 'voice';
        case ConsultationType.video:
          return 'video';
        case ConsultationType.offline:
          return 'offline';
      }
    }).toList();

    return NutritionistModel(
      id: entity.id,
      userId: entity.userId,
      personalInfo: PersonalInfoModel(
        realName: entity.name,
        idCardNumber: '', // 需要从其他地方获取
      ),
      qualifications: QualificationsModel(
        licenseNumber: '', // 需要从其他地方获取
        certificationImages: entity.certifications,
      ),
      professionalInfo: ProfessionalInfoModel(
        specializations: entity.specializations,
        experienceYears: entity.experienceYears,
        bio: entity.bio,
        languages: entity.languages,
      ),
      serviceInfo: ServiceInfoModel(
        consultationFee: entity.consultationFee,
        availableOnline: entity.isOnlineAvailable,
        availableInPerson: entity.isInPersonAvailable,
      ),
      ratings: RatingsModel(
        averageRating: entity.rating,
        totalReviews: entity.reviewCount,
      ),
      verification: VerificationModel(
        verificationStatus: entity.verificationStatus,
      ),
      onlineStatus: OnlineStatusModel(
        isOnline: entity.isOnline,
        isAvailable: entity.isAvailable,
        lastActiveAt: entity.lastActiveAt,
        statusMessage: entity.statusMessage,
        availableConsultationTypes: consultationTypes,
        averageResponseTime: entity.responseTime,
      ),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
