// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPermissionModel _$UserPermissionModelFromJson(Map<String, dynamic> json) =>
    UserPermissionModel(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      permissionType: json['permission_type'] as String,
      status: json['status'] as String,
      grantedBy: json['granted_by'] as String?,
      grantedAt: json['granted_at'] == null
          ? null
          : DateTime.parse(json['granted_at'] as String),
      applicationData: json['application_data'] == null
          ? null
          : ApplicationDataModel.fromJson(
              json['application_data'] as Map<String, dynamic>),
      reviewData: json['review_data'] == null
          ? null
          : ReviewDataModel.fromJson(
              json['review_data'] as Map<String, dynamic>),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      remark: json['remark'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserPermissionModelToJson(
        UserPermissionModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      'permission_type': instance.permissionType,
      'status': instance.status,
      if (instance.grantedBy case final value?) 'granted_by': value,
      if (instance.grantedAt?.toIso8601String() case final value?)
        'granted_at': value,
      if (instance.applicationData?.toJson() case final value?)
        'application_data': value,
      if (instance.reviewData?.toJson() case final value?) 'review_data': value,
      if (instance.expiresAt?.toIso8601String() case final value?)
        'expires_at': value,
      if (instance.remark case final value?) 'remark': value,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ApplicationDataModel _$ApplicationDataModelFromJson(
        Map<String, dynamic> json) =>
    ApplicationDataModel(
      reason: json['reason'] as String?,
      contactInfo: json['contact_info'] == null
          ? null
          : ContactInfoModel.fromJson(
              json['contact_info'] as Map<String, dynamic>),
      qualifications: json['qualifications'] as String?,
      appliedAt: json['applied_at'] == null
          ? null
          : DateTime.parse(json['applied_at'] as String),
    );

Map<String, dynamic> _$ApplicationDataModelToJson(
        ApplicationDataModel instance) =>
    <String, dynamic>{
      if (instance.reason case final value?) 'reason': value,
      if (instance.contactInfo?.toJson() case final value?)
        'contact_info': value,
      if (instance.qualifications case final value?) 'qualifications': value,
      if (instance.appliedAt?.toIso8601String() case final value?)
        'applied_at': value,
    };

ContactInfoModel _$ContactInfoModelFromJson(Map<String, dynamic> json) =>
    ContactInfoModel(
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      wechat: json['wechat'] as String?,
    );

Map<String, dynamic> _$ContactInfoModelToJson(ContactInfoModel instance) =>
    <String, dynamic>{
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.wechat case final value?) 'wechat': value,
    };

ReviewDataModel _$ReviewDataModelFromJson(Map<String, dynamic> json) =>
    ReviewDataModel(
      reviewComment: json['review_comment'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewedBy: json['reviewed_by'] as String?,
    );

Map<String, dynamic> _$ReviewDataModelToJson(ReviewDataModel instance) =>
    <String, dynamic>{
      if (instance.reviewComment case final value?) 'review_comment': value,
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      if (instance.reviewedBy case final value?) 'reviewed_by': value,
    };

PermissionStatsModel _$PermissionStatsModelFromJson(
        Map<String, dynamic> json) =>
    PermissionStatsModel(
      merchant: PermissionTypeStatsModel.fromJson(
          json['merchant'] as Map<String, dynamic>),
      nutritionist: PermissionTypeStatsModel.fromJson(
          json['nutritionist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PermissionStatsModelToJson(
        PermissionStatsModel instance) =>
    <String, dynamic>{
      'merchant': instance.merchant.toJson(),
      'nutritionist': instance.nutritionist.toJson(),
    };

PermissionTypeStatsModel _$PermissionTypeStatsModelFromJson(
        Map<String, dynamic> json) =>
    PermissionTypeStatsModel(
      pending: (json['pending'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
      revoked: (json['revoked'] as num).toInt(),
    );

Map<String, dynamic> _$PermissionTypeStatsModelToJson(
        PermissionTypeStatsModel instance) =>
    <String, dynamic>{
      'pending': instance.pending,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'revoked': instance.revoked,
    };

PermissionApplicationRequest _$PermissionApplicationRequestFromJson(
        Map<String, dynamic> json) =>
    PermissionApplicationRequest(
      permissionType: json['permission_type'] as String,
      reason: json['reason'] as String,
      contactInfo: json['contact_info'] == null
          ? null
          : ContactInfoModel.fromJson(
              json['contact_info'] as Map<String, dynamic>),
      qualifications: json['qualifications'] as String?,
    );

Map<String, dynamic> _$PermissionApplicationRequestToJson(
        PermissionApplicationRequest instance) =>
    <String, dynamic>{
      'permission_type': instance.permissionType,
      'reason': instance.reason,
      if (instance.contactInfo?.toJson() case final value?)
        'contact_info': value,
      if (instance.qualifications case final value?) 'qualifications': value,
    };

PermissionReviewRequest _$PermissionReviewRequestFromJson(
        Map<String, dynamic> json) =>
    PermissionReviewRequest(
      action: json['action'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$PermissionReviewRequestToJson(
        PermissionReviewRequest instance) =>
    <String, dynamic>{
      'action': instance.action,
      if (instance.comment case final value?) 'comment': value,
    };

BatchReviewRequest _$BatchReviewRequestFromJson(Map<String, dynamic> json) =>
    BatchReviewRequest(
      permissionIds: (json['permission_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      action: json['action'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$BatchReviewRequestToJson(BatchReviewRequest instance) =>
    <String, dynamic>{
      'permission_ids': instance.permissionIds,
      'action': instance.action,
      if (instance.comment case final value?) 'comment': value,
    };
