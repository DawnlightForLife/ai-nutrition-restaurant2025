// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification_review_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CertificationApplicationImpl _$$CertificationApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$CertificationApplicationImpl(
      id: json['id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      nutritionistName: json['nutritionist_name'] as String,
      nutritionistAvatar: json['nutritionist_avatar'] as String?,
      certificationLevel: json['certification_level'] as String,
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewerId: json['reviewer_id'] as String?,
      reviewerName: json['reviewer_name'] as String?,
      reviewNotes: json['review_notes'] as String?,
      priority: json['priority'] as String? ?? 'normal',
      documents: json['documents'] as Map<String, dynamic>?,
      educationInfo: json['education_info'] as Map<String, dynamic>?,
      experienceInfo: json['experience_info'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CertificationApplicationImplToJson(
        _$CertificationApplicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nutritionist_id': instance.nutritionistId,
      'nutritionist_name': instance.nutritionistName,
      if (instance.nutritionistAvatar case final value?)
        'nutritionist_avatar': value,
      'certification_level': instance.certificationLevel,
      'specializations': instance.specializations,
      'status': instance.status,
      'submitted_at': instance.submittedAt.toIso8601String(),
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      if (instance.reviewerId case final value?) 'reviewer_id': value,
      if (instance.reviewerName case final value?) 'reviewer_name': value,
      if (instance.reviewNotes case final value?) 'review_notes': value,
      'priority': instance.priority,
      if (instance.documents case final value?) 'documents': value,
      if (instance.educationInfo case final value?) 'education_info': value,
      if (instance.experienceInfo case final value?) 'experience_info': value,
    };
