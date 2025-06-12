import 'package:json_annotation/json_annotation.dart';

part 'user_permission_model.g.dart';

@JsonSerializable()
class UserPermissionModel {
  @JsonKey(name: '_id')
  final String id;
  
  final String userId;
  final String permissionType;
  final String status;
  final String? grantedBy;
  final DateTime? grantedAt;
  final ApplicationDataModel? applicationData;
  final ReviewDataModel? reviewData;
  final DateTime? expiresAt;
  final String? remark;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserPermissionModel({
    required this.id,
    required this.userId,
    required this.permissionType,
    required this.status,
    this.grantedBy,
    this.grantedAt,
    this.applicationData,
    this.reviewData,
    this.expiresAt,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPermissionModel.fromJson(Map<String, dynamic> json) =>
      _$UserPermissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPermissionModelToJson(this);
}

@JsonSerializable()
class ApplicationDataModel {
  final String? reason;
  final ContactInfoModel? contactInfo;
  final String? qualifications;
  final DateTime? appliedAt;

  const ApplicationDataModel({
    this.reason,
    this.contactInfo,
    this.qualifications,
    this.appliedAt,
  });

  factory ApplicationDataModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDataModelToJson(this);
}

@JsonSerializable()
class ContactInfoModel {
  final String? phone;
  final String? email;
  final String? wechat;

  const ContactInfoModel({
    this.phone,
    this.email,
    this.wechat,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoModelToJson(this);
}

@JsonSerializable()
class ReviewDataModel {
  final String? reviewComment;
  final DateTime? reviewedAt;
  final String? reviewedBy;

  const ReviewDataModel({
    this.reviewComment,
    this.reviewedAt,
    this.reviewedBy,
  });

  factory ReviewDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDataModelToJson(this);
}

@JsonSerializable()
class PermissionStatsModel {
  final PermissionTypeStatsModel merchant;
  final PermissionTypeStatsModel nutritionist;

  const PermissionStatsModel({
    required this.merchant,
    required this.nutritionist,
  });

  factory PermissionStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionStatsModelToJson(this);
}

@JsonSerializable()
class PermissionTypeStatsModel {
  final int pending;
  final int approved;
  final int rejected;
  final int revoked;

  const PermissionTypeStatsModel({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.revoked,
  });

  factory PermissionTypeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionTypeStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionTypeStatsModelToJson(this);
}

// 权限申请请求模型
@JsonSerializable()
class PermissionApplicationRequest {
  final String permissionType;
  final String reason;
  final ContactInfoModel? contactInfo;
  final String? qualifications;

  const PermissionApplicationRequest({
    required this.permissionType,
    required this.reason,
    this.contactInfo,
    this.qualifications,
  });

  factory PermissionApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$PermissionApplicationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionApplicationRequestToJson(this);
}

// 权限审核请求模型
@JsonSerializable()
class PermissionReviewRequest {
  final String action;
  final String? comment;

  const PermissionReviewRequest({
    required this.action,
    this.comment,
  });

  factory PermissionReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$PermissionReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionReviewRequestToJson(this);
}

// 批量审核请求模型
@JsonSerializable()
class BatchReviewRequest {
  final List<String> permissionIds;
  final String action;
  final String? comment;

  const BatchReviewRequest({
    required this.permissionIds,
    required this.action,
    this.comment,
  });

  factory BatchReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BatchReviewRequestToJson(this);
}

// 枚举定义
enum PermissionType {
  @JsonValue('merchant')
  merchant,
  @JsonValue('nutritionist')
  nutritionist,
}

enum PermissionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('revoked')
  revoked,
}

enum ReviewAction {
  @JsonValue('approve')
  approve,
  @JsonValue('reject')
  reject,
}

// 扩展方法
extension PermissionTypeExtension on PermissionType {
  String get displayName {
    switch (this) {
      case PermissionType.merchant:
        return '商家权限';
      case PermissionType.nutritionist:
        return '营养师权限';
    }
  }
}

extension PermissionStatusExtension on PermissionStatus {
  String get displayName {
    switch (this) {
      case PermissionStatus.pending:
        return '待审核';
      case PermissionStatus.approved:
        return '已通过';
      case PermissionStatus.rejected:
        return '已拒绝';
      case PermissionStatus.revoked:
        return '已撤销';
    }
  }
}

extension ReviewActionExtension on ReviewAction {
  String get displayName {
    switch (this) {
      case ReviewAction.approve:
        return '通过';
      case ReviewAction.reject:
        return '拒绝';
    }
  }
}