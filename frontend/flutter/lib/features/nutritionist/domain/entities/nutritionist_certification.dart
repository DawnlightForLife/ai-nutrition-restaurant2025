import 'package:equatable/equatable.dart';

/// 个人信息实体（超简化版 - 对齐数据库设计）
class PersonalInfo extends Equatable {
  final String fullName;
  final String idNumber;
  final String phone;
  // Keep for backward compatibility
  final String? gender;
  final DateTime? birthDate;
  final String? email;
  final Address? address;

  const PersonalInfo({
    required this.fullName,
    required this.idNumber,
    required this.phone,
    this.gender,
    this.birthDate,
    this.email,
    this.address,
  });

  @override
  List<Object?> get props => [fullName, idNumber, phone, gender, birthDate, email, address];
}

/// 地址实体
class Address extends Equatable {
  final String province;
  final String city;
  final String district;
  final String detailed;

  const Address({
    required this.province,
    required this.city,
    required this.district,
    required this.detailed,
  });

  @override
  List<Object?> get props => [province, city, district, detailed];
}

/// 教育背景实体
class Education extends Equatable {
  final String degree;
  final String major;
  final String school;
  final int graduationYear;
  final double? gpa;

  const Education({
    required this.degree,
    required this.major,
    required this.school,
    required this.graduationYear,
    this.gpa,
  });

  @override
  List<Object?> get props => [degree, major, school, graduationYear, gpa];
}

/// 工作经验实体
class WorkExperience extends Equatable {
  final int totalYears;
  final String currentPosition;
  final String currentEmployer;
  final String workDescription;
  final List<PreviousExperience> previousExperiences;

  const WorkExperience({
    required this.totalYears,
    required this.currentPosition,
    required this.currentEmployer,
    required this.workDescription,
    required this.previousExperiences,
  });

  @override
  List<Object?> get props => [totalYears, currentPosition, currentEmployer, workDescription, previousExperiences];
}

/// 以往工作经验实体
class PreviousExperience extends Equatable {
  final String position;
  final String employer;
  final DateTime startDate;
  final DateTime? endDate;
  final String? responsibilities;

  const PreviousExperience({
    required this.position,
    required this.employer,
    required this.startDate,
    this.endDate,
    this.responsibilities,
  });

  @override
  List<Object?> get props => [position, employer, startDate, endDate, responsibilities];
}

/// 认证信息实体（超简化版 - 对齐数据库设计）
class CertificationInfo extends Equatable {
  final List<String> specializationAreas;
  final int workYearsInNutrition;
  // Keep for backward compatibility
  final String? targetLevel;
  final String? motivationStatement;
  final bool? hasExistingCertificate;
  final String? existingCertificateType;
  final String? careerGoals;

  const CertificationInfo({
    required this.specializationAreas,
    required this.workYearsInNutrition,
    this.targetLevel,
    this.motivationStatement,
    this.hasExistingCertificate,
    this.existingCertificateType,
    this.careerGoals,
  });

  @override
  List<Object?> get props => [specializationAreas, workYearsInNutrition, targetLevel, motivationStatement, hasExistingCertificate, existingCertificateType, careerGoals];
}

/// 上传文档实体
class UploadedDocument extends Equatable {
  final String documentType;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final DateTime uploadedAt;
  final bool verified;

  const UploadedDocument({
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.uploadedAt,
    required this.verified,
  });

  @override
  List<Object?> get props => [documentType, fileName, fileUrl, fileSize, mimeType, uploadedAt, verified];
}

/// 审核信息实体
class ReviewInfo extends Equatable {
  final String status;
  final DateTime? submittedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final String? rejectionReason;
  final DateTime? approvalValidUntil;
  final int resubmissionCount;
  final DateTime? lastResubmissionDate;

  const ReviewInfo({
    required this.status,
    this.submittedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    this.rejectionReason,
    this.approvalValidUntil,
    required this.resubmissionCount,
    this.lastResubmissionDate,
  });

  @override
  List<Object?> get props => [
    status,
    submittedAt,
    reviewedBy,
    reviewedAt,
    reviewNotes,
    rejectionReason,
    approvalValidUntil,
    resubmissionCount,
    lastResubmissionDate,
  ];
}

/// 营养师认证申请主实体（简化版）
class NutritionistCertification extends Equatable {
  final String id;
  final String userId;
  final String applicationNumber;
  final PersonalInfo personalInfo;
  final CertificationInfo certificationInfo;
  final List<UploadedDocument> documents;
  final ReviewInfo review;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Keep for backward compatibility
  final Education? education;
  final WorkExperience? workExperience;

  const NutritionistCertification({
    required this.id,
    required this.userId,
    required this.applicationNumber,
    required this.personalInfo,
    required this.certificationInfo,
    required this.documents,
    required this.review,
    required this.createdAt,
    required this.updatedAt,
    this.education,
    this.workExperience,
  });

  /// 检查是否满足申请条件（简化版）
  bool checkEligibility() {
    final workYears = certificationInfo.workYearsInNutrition;
    final hasSpecialization = certificationInfo.specializationAreas.isNotEmpty;
    
    switch (certificationInfo.targetLevel) {
      case 'registered_dietitian':
        return workYears >= 2 && hasSpecialization;
      case 'dietetic_technician':
        return workYears >= 1 && hasSpecialization;
      case 'public_nutritionist_l4':
        return workYears >= 0 && hasSpecialization;
      case 'public_nutritionist_l3':
        return workYears >= 1 && hasSpecialization;
      case 'nutrition_manager':
        return workYears >= 3 && hasSpecialization;
      default:
        return false;
    }
  }

  /// 是否可以重新提交
  bool canResubmit() {
    return review.status == 'rejected' && review.resubmissionCount < 3;
  }

  /// 是否需要上传更多文档（简化版）
  bool needsMoreDocuments() {
    const requiredTypes = ['id_card', 'nutrition_certificate'];
    final uploadedTypes = documents.map((doc) => doc.documentType).toSet();
    return !requiredTypes.every((type) => uploadedTypes.contains(type));
  }

  /// 获取缺失的必需文档类型（简化版）
  List<String> getMissingRequiredDocuments() {
    const requiredTypes = ['id_card', 'nutrition_certificate'];
    final uploadedTypes = documents.map((doc) => doc.documentType).toSet();
    return requiredTypes.where((type) => !uploadedTypes.contains(type)).toList();
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    applicationNumber,
    personalInfo,
    certificationInfo,
    documents,
    review,
    createdAt,
    updatedAt,
    education,
    workExperience,
  ];
}

/// 营养师认证申请创建请求实体（简化版）
class NutritionistCertificationRequest extends Equatable {
  final PersonalInfo personalInfo;
  final CertificationInfo certificationInfo;
  // Keep for backward compatibility
  final Education? education;
  final WorkExperience? workExperience;

  const NutritionistCertificationRequest({
    required this.personalInfo,
    required this.certificationInfo,
    this.education,
    this.workExperience,
  });

  @override
  List<Object?> get props => [personalInfo, certificationInfo, education, workExperience];
}

/// 文档上传请求实体
class DocumentUploadRequest extends Equatable {
  final String certificationId;
  final String documentType;
  final String fileName;
  final List<int> fileBytes;
  final String mimeType;

  const DocumentUploadRequest({
    required this.certificationId,
    required this.documentType,
    required this.fileName,
    required this.fileBytes,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [certificationId, documentType, fileName, fileBytes, mimeType];
}