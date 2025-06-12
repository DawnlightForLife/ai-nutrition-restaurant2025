/// 营养师认证状态枚举
enum CertificationStatus {
  /// 草稿
  draft,
  
  /// 待审核
  pending,
  
  /// 审核中
  underReview,
  
  /// 审核通过
  approved,
  
  /// 审核拒绝
  rejected,
  
  /// 暂停
  suspended,
  
  /// 过期
  expired,
}

extension CertificationStatusExtension on CertificationStatus {
  String get displayName {
    switch (this) {
      case CertificationStatus.draft:
        return '草稿';
      case CertificationStatus.pending:
        return '待审核';
      case CertificationStatus.underReview:
        return '审核中';
      case CertificationStatus.approved:
        return '审核通过';
      case CertificationStatus.rejected:
        return '审核拒绝';
      case CertificationStatus.suspended:
        return '暂停';
      case CertificationStatus.expired:
        return '过期';
    }
  }

  String get value {
    switch (this) {
      case CertificationStatus.draft:
        return 'draft';
      case CertificationStatus.pending:
        return 'pending';
      case CertificationStatus.underReview:
        return 'under_review';
      case CertificationStatus.approved:
        return 'approved';
      case CertificationStatus.rejected:
        return 'rejected';
      case CertificationStatus.suspended:
        return 'suspended';
      case CertificationStatus.expired:
        return 'expired';
    }
  }
}

/// 认证状态工具类
class CertificationStatusUtils {
  /// 从字符串转换为枚举
  static CertificationStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return CertificationStatus.draft;
      case 'pending':
        return CertificationStatus.pending;
      case 'under_review':
        return CertificationStatus.underReview;
      case 'approved':
        return CertificationStatus.approved;
      case 'rejected':
        return CertificationStatus.rejected;
      case 'suspended':
        return CertificationStatus.suspended;
      case 'expired':
        return CertificationStatus.expired;
      default:
        return CertificationStatus.draft;
    }
  }

  /// 兼容方法
  static CertificationStatus fromValue(String value) {
    return fromString(value);
  }
}