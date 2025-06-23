// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutritionist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonalInfoModelImpl _$$PersonalInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalInfoModelImpl(
      realName: json['real_name'] as String,
      idCardNumber: json['id_card_number'] as String,
    );

Map<String, dynamic> _$$PersonalInfoModelImplToJson(
        _$PersonalInfoModelImpl instance) =>
    <String, dynamic>{
      'real_name': instance.realName,
      'id_card_number': instance.idCardNumber,
    };

_$QualificationsModelImpl _$$QualificationsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QualificationsModelImpl(
      licenseNumber: json['license_number'] as String,
      licenseImageUrl: json['license_image_url'] as String?,
      certificationImages: (json['certification_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      professionalTitle: json['professional_title'] as String?,
      certificationLevel: json['certification_level'] as String?,
      issuingAuthority: json['issuing_authority'] as String?,
      issueDate: json['issue_date'] == null
          ? null
          : DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      verified: json['verified'] as bool? ?? false,
    );

Map<String, dynamic> _$$QualificationsModelImplToJson(
        _$QualificationsModelImpl instance) =>
    <String, dynamic>{
      'license_number': instance.licenseNumber,
      if (instance.licenseImageUrl case final value?)
        'license_image_url': value,
      'certification_images': instance.certificationImages,
      if (instance.professionalTitle case final value?)
        'professional_title': value,
      if (instance.certificationLevel case final value?)
        'certification_level': value,
      if (instance.issuingAuthority case final value?)
        'issuing_authority': value,
      if (instance.issueDate?.toIso8601String() case final value?)
        'issue_date': value,
      if (instance.expiryDate?.toIso8601String() case final value?)
        'expiry_date': value,
      'verified': instance.verified,
    };

_$ProfessionalInfoModelImpl _$$ProfessionalInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfessionalInfoModelImpl(
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      experienceYears: (json['experience_years'] as num?)?.toInt() ?? 0,
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$$ProfessionalInfoModelImplToJson(
        _$ProfessionalInfoModelImpl instance) =>
    <String, dynamic>{
      'specializations': instance.specializations,
      'experience_years': instance.experienceYears,
      'education': instance.education,
      'languages': instance.languages,
      if (instance.bio case final value?) 'bio': value,
    };

_$ServiceInfoModelImpl _$$ServiceInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceInfoModelImpl(
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 0,
      consultationDuration:
          (json['consultation_duration'] as num?)?.toInt() ?? 60,
      availableOnline: json['available_online'] as bool? ?? true,
      availableInPerson: json['available_in_person'] as bool? ?? false,
      inPersonLocations: (json['in_person_locations'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      serviceTags: (json['service_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availableTimeSlots: (json['available_time_slots'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ServiceInfoModelImplToJson(
        _$ServiceInfoModelImpl instance) =>
    <String, dynamic>{
      'consultation_fee': instance.consultationFee,
      'consultation_duration': instance.consultationDuration,
      'available_online': instance.availableOnline,
      'available_in_person': instance.availableInPerson,
      'in_person_locations': instance.inPersonLocations,
      'service_tags': instance.serviceTags,
      'available_time_slots': instance.availableTimeSlots,
    };

_$RatingsModelImpl _$$RatingsModelImplFromJson(Map<String, dynamic> json) =>
    _$RatingsModelImpl(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RatingsModelImplToJson(_$RatingsModelImpl instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRating,
      'total_reviews': instance.totalReviews,
    };

_$VerificationModelImpl _$$VerificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationModelImpl(
      verificationStatus: json['verification_status'] as String? ?? 'pending',
      rejectedReason: json['rejected_reason'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      verificationHistory: (json['verification_history'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$VerificationModelImplToJson(
        _$VerificationModelImpl instance) =>
    <String, dynamic>{
      'verification_status': instance.verificationStatus,
      if (instance.rejectedReason case final value?) 'rejected_reason': value,
      if (instance.reviewedBy case final value?) 'reviewed_by': value,
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      'verification_history': instance.verificationHistory,
    };

_$OnlineStatusModelImpl _$$OnlineStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OnlineStatusModelImpl(
      isOnline: json['is_online'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? false,
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
      statusMessage: json['status_message'] as String?,
      availableConsultationTypes:
          (json['available_consultation_types'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      averageResponseTime:
          (json['average_response_time'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$OnlineStatusModelImplToJson(
        _$OnlineStatusModelImpl instance) =>
    <String, dynamic>{
      'is_online': instance.isOnline,
      'is_available': instance.isAvailable,
      if (instance.lastActiveAt?.toIso8601String() case final value?)
        'last_active_at': value,
      if (instance.statusMessage case final value?) 'status_message': value,
      'available_consultation_types': instance.availableConsultationTypes,
      'average_response_time': instance.averageResponseTime,
      if (instance.lastUpdated?.toIso8601String() case final value?)
        'last_updated': value,
    };

_$NutritionistModelImpl _$$NutritionistModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistModelImpl(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      certificationApplicationId:
          json['certification_application_id'] as String?,
      personalInfo: PersonalInfoModel.fromJson(
          json['personal_info'] as Map<String, dynamic>),
      qualifications: QualificationsModel.fromJson(
          json['qualifications'] as Map<String, dynamic>),
      professionalInfo: ProfessionalInfoModel.fromJson(
          json['professional_info'] as Map<String, dynamic>),
      serviceInfo: ServiceInfoModel.fromJson(
          json['service_info'] as Map<String, dynamic>),
      ratings: RatingsModel.fromJson(json['ratings'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'pendingVerification',
      verification: VerificationModel.fromJson(
          json['verification'] as Map<String, dynamic>),
      affiliations: (json['affiliations'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      onlineStatus: json['online_status'] == null
          ? null
          : OnlineStatusModel.fromJson(
              json['online_status'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionistModelImplToJson(
        _$NutritionistModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      if (instance.certificationApplicationId case final value?)
        'certification_application_id': value,
      'personal_info': instance.personalInfo.toJson(),
      'qualifications': instance.qualifications.toJson(),
      'professional_info': instance.professionalInfo.toJson(),
      'service_info': instance.serviceInfo.toJson(),
      'ratings': instance.ratings.toJson(),
      'status': instance.status,
      'verification': instance.verification.toJson(),
      'affiliations': instance.affiliations,
      if (instance.onlineStatus?.toJson() case final value?)
        'online_status': value,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
