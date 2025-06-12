import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist_certification.dart';

part 'nutritionist_certification_model.freezed.dart';
part 'nutritionist_certification_model.g.dart';

@freezed
class PersonalInfoModel with _$PersonalInfoModel {
  const PersonalInfoModel._();
  const factory PersonalInfoModel({
    required String fullName,
    required String idNumber,
    required String phone,
    // Keep for backward compatibility
    String? gender,
    DateTime? birthDate,
    String? email,
    AddressModel? address,
  }) = _PersonalInfoModel;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);

  static PersonalInfoModel fromEntity(PersonalInfo entity) {
    return PersonalInfoModel(
      fullName: entity.fullName,
      idNumber: entity.idNumber,
      phone: entity.phone,
      gender: entity.gender,
      birthDate: entity.birthDate,
      email: entity.email,
      address: entity.address != null ? AddressModel.fromEntity(entity.address!) : null,
    );
  }
}

extension PersonalInfoModelX on PersonalInfoModel {
  PersonalInfo toEntity() {
    return PersonalInfo(
      fullName: fullName,
      idNumber: idNumber,
      phone: phone,
      gender: gender,
      birthDate: birthDate,
      email: email,
      address: address?.toEntity(),
    );
  }
}

@freezed
class AddressModel with _$AddressModel {
  const AddressModel._();
  const factory AddressModel({
    required String province,
    required String city,
    required String district,
    required String detailed,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  static AddressModel fromEntity(Address entity) {
    return AddressModel(
      province: entity.province,
      city: entity.city,
      district: entity.district,
      detailed: entity.detailed,
    );
  }
}

extension AddressModelX on AddressModel {
  Address toEntity() {
    return Address(
      province: province,
      city: city,
      district: district,
      detailed: detailed,
    );
  }
}

@freezed
class EducationModel with _$EducationModel {
  const EducationModel._();
  const factory EducationModel({
    required String degree,
    required String major,
    required String school,
    required int graduationYear,
    double? gpa,
  }) = _EducationModel;

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);

  static EducationModel fromEntity(Education entity) {
    return EducationModel(
      degree: entity.degree,
      major: entity.major,
      school: entity.school,
      graduationYear: entity.graduationYear,
      gpa: entity.gpa,
    );
  }
}

extension EducationModelX on EducationModel {
  Education toEntity() {
    return Education(
      degree: degree,
      major: major,
      school: school,
      graduationYear: graduationYear,
      gpa: gpa,
    );
  }
}

@freezed
class WorkExperienceModel with _$WorkExperienceModel {
  const WorkExperienceModel._();
  const factory WorkExperienceModel({
    required int totalYears,
    required String currentPosition,
    required String currentEmployer,
    required String workDescription,
    required List<PreviousExperienceModel> previousExperiences,
  }) = _WorkExperienceModel;

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceModelFromJson(json);

  static WorkExperienceModel fromEntity(WorkExperience entity) {
    return WorkExperienceModel(
      totalYears: entity.totalYears,
      currentPosition: entity.currentPosition,
      currentEmployer: entity.currentEmployer,
      workDescription: entity.workDescription,
      previousExperiences: entity.previousExperiences
          .map((e) => PreviousExperienceModel.fromEntity(e))
          .toList(),
    );
  }
}

extension WorkExperienceModelX on WorkExperienceModel {
  WorkExperience toEntity() {
    return WorkExperience(
      totalYears: totalYears,
      currentPosition: currentPosition,
      currentEmployer: currentEmployer,
      workDescription: workDescription,
      previousExperiences: previousExperiences.map((e) => e.toEntity()).toList(),
    );
  }
}

@freezed
class PreviousExperienceModel with _$PreviousExperienceModel {
  const PreviousExperienceModel._();
  const factory PreviousExperienceModel({
    required String position,
    required String employer,
    required DateTime startDate,
    DateTime? endDate,
    String? responsibilities,
  }) = _PreviousExperienceModel;

  factory PreviousExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousExperienceModelFromJson(json);

  static PreviousExperienceModel fromEntity(PreviousExperience entity) {
    return PreviousExperienceModel(
      position: entity.position,
      employer: entity.employer,
      startDate: entity.startDate,
      endDate: entity.endDate,
      responsibilities: entity.responsibilities,
    );
  }
}

extension PreviousExperienceModelX on PreviousExperienceModel {
  PreviousExperience toEntity() {
    return PreviousExperience(
      position: position,
      employer: employer,
      startDate: startDate,
      endDate: endDate,
      responsibilities: responsibilities,
    );
  }
}

@freezed
class CertificationInfoModel with _$CertificationInfoModel {
  const CertificationInfoModel._();
  const factory CertificationInfoModel({
    required List<String> specializationAreas,
    required int workYearsInNutrition,
    // Keep backward compatibility
    String? targetLevel,
    String? motivationStatement,
    bool? hasExistingCertificate,
    String? existingCertificateType,
    String? careerGoals,
  }) = _CertificationInfoModel;

  factory CertificationInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationInfoModelFromJson(json);

  static CertificationInfoModel fromEntity(CertificationInfo entity) {
    return CertificationInfoModel(
      specializationAreas: entity.specializationAreas,
      workYearsInNutrition: entity.workYearsInNutrition,
      targetLevel: entity.targetLevel,
      motivationStatement: entity.motivationStatement,
      hasExistingCertificate: entity.hasExistingCertificate,
      existingCertificateType: entity.existingCertificateType,
      careerGoals: entity.careerGoals,
    );
  }
}

extension CertificationInfoModelX on CertificationInfoModel {
  CertificationInfo toEntity() {
    return CertificationInfo(
      specializationAreas: specializationAreas,
      workYearsInNutrition: workYearsInNutrition,
      targetLevel: targetLevel,
      motivationStatement: motivationStatement,
      hasExistingCertificate: hasExistingCertificate,
      existingCertificateType: existingCertificateType,
      careerGoals: careerGoals,
    );
  }
}

@freezed
class UploadedDocumentModel with _$UploadedDocumentModel {
  const UploadedDocumentModel._();
  const factory UploadedDocumentModel({
    required String documentType,
    required String fileName,
    required String fileUrl,
    required int fileSize,
    required String mimeType,
    required DateTime uploadedAt,
    required bool verified,
  }) = _UploadedDocumentModel;

  factory UploadedDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$UploadedDocumentModelFromJson(json);

  static UploadedDocumentModel fromEntity(UploadedDocument entity) {
    return UploadedDocumentModel(
      documentType: entity.documentType,
      fileName: entity.fileName,
      fileUrl: entity.fileUrl,
      fileSize: entity.fileSize,
      mimeType: entity.mimeType,
      uploadedAt: entity.uploadedAt,
      verified: entity.verified,
    );
  }
}

extension UploadedDocumentModelX on UploadedDocumentModel {
  UploadedDocument toEntity() {
    return UploadedDocument(
      documentType: documentType,
      fileName: fileName,
      fileUrl: fileUrl,
      fileSize: fileSize,
      mimeType: mimeType,
      uploadedAt: uploadedAt,
      verified: verified,
    );
  }
}

@freezed
class ReviewInfoModel with _$ReviewInfoModel {
  const ReviewInfoModel._();
  const factory ReviewInfoModel({
    required String status,
    DateTime? submittedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNotes,
    String? rejectionReason,
    DateTime? approvalValidUntil,
    required int resubmissionCount,
    DateTime? lastResubmissionDate,
  }) = _ReviewInfoModel;

  factory ReviewInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewInfoModelFromJson(json);

  static ReviewInfoModel fromEntity(ReviewInfo entity) {
    return ReviewInfoModel(
      status: entity.status,
      submittedAt: entity.submittedAt,
      reviewedBy: entity.reviewedBy,
      reviewedAt: entity.reviewedAt,
      reviewNotes: entity.reviewNotes,
      rejectionReason: entity.rejectionReason,
      approvalValidUntil: entity.approvalValidUntil,
      resubmissionCount: entity.resubmissionCount,
      lastResubmissionDate: entity.lastResubmissionDate,
    );
  }
}

extension ReviewInfoModelX on ReviewInfoModel {
  ReviewInfo toEntity() {
    return ReviewInfo(
      status: status,
      submittedAt: submittedAt,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
      reviewNotes: reviewNotes,
      rejectionReason: rejectionReason,
      approvalValidUntil: approvalValidUntil,
      resubmissionCount: resubmissionCount,
      lastResubmissionDate: lastResubmissionDate,
    );
  }
}

@freezed
class NutritionistCertificationModel with _$NutritionistCertificationModel {
  const NutritionistCertificationModel._();
  const factory NutritionistCertificationModel({
    required String id,
    required String userId,
    required String applicationNumber,
    required PersonalInfoModel personalInfo,
    required CertificationInfoModel certificationInfo,
    required List<UploadedDocumentModel> documents,
    required ReviewInfoModel review,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Keep for backward compatibility but mark as optional
    EducationModel? education,
    WorkExperienceModel? workExperience,
  }) = _NutritionistCertificationModel;

  factory NutritionistCertificationModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionistCertificationModelFromJson(json);

  static NutritionistCertificationModel fromEntity(NutritionistCertification entity) {
    return NutritionistCertificationModel(
      id: entity.id,
      userId: entity.userId,
      applicationNumber: entity.applicationNumber,
      personalInfo: PersonalInfoModel.fromEntity(entity.personalInfo),
      certificationInfo: CertificationInfoModel.fromEntity(entity.certificationInfo),
      documents: entity.documents.map((e) => UploadedDocumentModel.fromEntity(e)).toList(),
      review: ReviewInfoModel.fromEntity(entity.review),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      education: entity.education != null ? EducationModel.fromEntity(entity.education!) : null,
      workExperience: entity.workExperience != null ? WorkExperienceModel.fromEntity(entity.workExperience!) : null,
    );
  }
}

extension NutritionistCertificationModelX on NutritionistCertificationModel {
  NutritionistCertification toEntity() {
    return NutritionistCertification(
      id: id,
      userId: userId,
      applicationNumber: applicationNumber,
      personalInfo: personalInfo.toEntity(),
      certificationInfo: certificationInfo.toEntity(),
      documents: documents.map((e) => e.toEntity()).toList(),
      review: review.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      education: education?.toEntity(),
      workExperience: workExperience?.toEntity(),
    );
  }
}

@freezed
class NutritionistCertificationRequestModel with _$NutritionistCertificationRequestModel {
  const NutritionistCertificationRequestModel._();
  const factory NutritionistCertificationRequestModel({
    required PersonalInfoModel personalInfo,
    required CertificationInfoModel certificationInfo,
    // Keep for backward compatibility
    EducationModel? education,
    WorkExperienceModel? workExperience,
  }) = _NutritionistCertificationRequestModel;

  factory NutritionistCertificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionistCertificationRequestModelFromJson(json);

  static NutritionistCertificationRequestModel fromEntity(NutritionistCertificationRequest entity) {
    return NutritionistCertificationRequestModel(
      personalInfo: PersonalInfoModel.fromEntity(entity.personalInfo),
      certificationInfo: CertificationInfoModel.fromEntity(entity.certificationInfo),
      education: entity.education != null ? EducationModel.fromEntity(entity.education!) : null,
      workExperience: entity.workExperience != null ? WorkExperienceModel.fromEntity(entity.workExperience!) : null,
    );
  }
}

extension NutritionistCertificationRequestModelX on NutritionistCertificationRequestModel {
  NutritionistCertificationRequest toEntity() {
    return NutritionistCertificationRequest(
      personalInfo: personalInfo.toEntity(),
      certificationInfo: certificationInfo.toEntity(),
      education: education?.toEntity(),
      workExperience: workExperience?.toEntity(),
    );
  }
}