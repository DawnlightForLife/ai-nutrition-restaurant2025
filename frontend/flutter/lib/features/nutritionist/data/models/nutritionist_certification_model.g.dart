// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutritionist_certification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonalInfoModelImpl _$$PersonalInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonalInfoModelImpl(
      fullName: json['full_name'] as String,
      idNumber: json['id_number'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      email: json['email'] as String?,
      address: json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PersonalInfoModelImplToJson(
        _$PersonalInfoModelImpl instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'id_number': instance.idNumber,
      'phone': instance.phone,
      if (instance.gender case final value?) 'gender': value,
      if (instance.birthDate?.toIso8601String() case final value?)
        'birth_date': value,
      if (instance.email case final value?) 'email': value,
      if (instance.address?.toJson() case final value?) 'address': value,
    };

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      province: json['province'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      detailed: json['detailed'] as String,
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'detailed': instance.detailed,
    };

_$EducationModelImpl _$$EducationModelImplFromJson(Map<String, dynamic> json) =>
    _$EducationModelImpl(
      degree: json['degree'] as String,
      major: json['major'] as String,
      school: json['school'] as String,
      graduationYear: (json['graduation_year'] as num).toInt(),
      gpa: (json['gpa'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$EducationModelImplToJson(
        _$EducationModelImpl instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'major': instance.major,
      'school': instance.school,
      'graduation_year': instance.graduationYear,
      if (instance.gpa case final value?) 'gpa': value,
    };

_$WorkExperienceModelImpl _$$WorkExperienceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkExperienceModelImpl(
      totalYears: (json['total_years'] as num).toInt(),
      currentPosition: json['current_position'] as String,
      currentEmployer: json['current_employer'] as String,
      workDescription: json['work_description'] as String,
      previousExperiences: (json['previous_experiences'] as List<dynamic>)
          .map((e) =>
              PreviousExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkExperienceModelImplToJson(
        _$WorkExperienceModelImpl instance) =>
    <String, dynamic>{
      'total_years': instance.totalYears,
      'current_position': instance.currentPosition,
      'current_employer': instance.currentEmployer,
      'work_description': instance.workDescription,
      'previous_experiences':
          instance.previousExperiences.map((e) => e.toJson()).toList(),
    };

_$PreviousExperienceModelImpl _$$PreviousExperienceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PreviousExperienceModelImpl(
      position: json['position'] as String,
      employer: json['employer'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      responsibilities: json['responsibilities'] as String?,
    );

Map<String, dynamic> _$$PreviousExperienceModelImplToJson(
        _$PreviousExperienceModelImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'employer': instance.employer,
      'start_date': instance.startDate.toIso8601String(),
      if (instance.endDate?.toIso8601String() case final value?)
        'end_date': value,
      if (instance.responsibilities case final value?)
        'responsibilities': value,
    };

_$CertificationInfoModelImpl _$$CertificationInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CertificationInfoModelImpl(
      specializationAreas: (json['specialization_areas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      workYearsInNutrition: (json['work_years_in_nutrition'] as num).toInt(),
      targetLevel: json['target_level'] as String?,
      motivationStatement: json['motivation_statement'] as String?,
      hasExistingCertificate: json['has_existing_certificate'] as bool?,
      existingCertificateType: json['existing_certificate_type'] as String?,
      careerGoals: json['career_goals'] as String?,
    );

Map<String, dynamic> _$$CertificationInfoModelImplToJson(
        _$CertificationInfoModelImpl instance) =>
    <String, dynamic>{
      'specialization_areas': instance.specializationAreas,
      'work_years_in_nutrition': instance.workYearsInNutrition,
      if (instance.targetLevel case final value?) 'target_level': value,
      if (instance.motivationStatement case final value?)
        'motivation_statement': value,
      if (instance.hasExistingCertificate case final value?)
        'has_existing_certificate': value,
      if (instance.existingCertificateType case final value?)
        'existing_certificate_type': value,
      if (instance.careerGoals case final value?) 'career_goals': value,
    };

_$UploadedDocumentModelImpl _$$UploadedDocumentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UploadedDocumentModelImpl(
      documentType: json['document_type'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$$UploadedDocumentModelImplToJson(
        _$UploadedDocumentModelImpl instance) =>
    <String, dynamic>{
      'document_type': instance.documentType,
      'file_name': instance.fileName,
      'file_url': instance.fileUrl,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'verified': instance.verified,
    };

_$ReviewInfoModelImpl _$$ReviewInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewInfoModelImpl(
      status: json['status'] as String,
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewNotes: json['review_notes'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      approvalValidUntil: json['approval_valid_until'] == null
          ? null
          : DateTime.parse(json['approval_valid_until'] as String),
      resubmissionCount: (json['resubmission_count'] as num).toInt(),
      lastResubmissionDate: json['last_resubmission_date'] == null
          ? null
          : DateTime.parse(json['last_resubmission_date'] as String),
    );

Map<String, dynamic> _$$ReviewInfoModelImplToJson(
        _$ReviewInfoModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      if (instance.submittedAt?.toIso8601String() case final value?)
        'submitted_at': value,
      if (instance.reviewedBy case final value?) 'reviewed_by': value,
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      if (instance.reviewNotes case final value?) 'review_notes': value,
      if (instance.rejectionReason case final value?) 'rejection_reason': value,
      if (instance.approvalValidUntil?.toIso8601String() case final value?)
        'approval_valid_until': value,
      'resubmission_count': instance.resubmissionCount,
      if (instance.lastResubmissionDate?.toIso8601String() case final value?)
        'last_resubmission_date': value,
    };

_$NutritionistCertificationModelImpl
    _$$NutritionistCertificationModelImplFromJson(Map<String, dynamic> json) =>
        _$NutritionistCertificationModelImpl(
          id: json['id'] as String,
          userId: json['user_id'] as String,
          applicationNumber: json['application_number'] as String,
          personalInfo: PersonalInfoModel.fromJson(
              json['personal_info'] as Map<String, dynamic>),
          certificationInfo: CertificationInfoModel.fromJson(
              json['certification_info'] as Map<String, dynamic>),
          documents: (json['documents'] as List<dynamic>)
              .map((e) =>
                  UploadedDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          review:
              ReviewInfoModel.fromJson(json['review'] as Map<String, dynamic>),
          createdAt: DateTime.parse(json['created_at'] as String),
          updatedAt: DateTime.parse(json['updated_at'] as String),
          education: json['education'] == null
              ? null
              : EducationModel.fromJson(
                  json['education'] as Map<String, dynamic>),
          workExperience: json['work_experience'] == null
              ? null
              : WorkExperienceModel.fromJson(
                  json['work_experience'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$NutritionistCertificationModelImplToJson(
        _$NutritionistCertificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'application_number': instance.applicationNumber,
      'personal_info': instance.personalInfo.toJson(),
      'certification_info': instance.certificationInfo.toJson(),
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'review': instance.review.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      if (instance.education?.toJson() case final value?) 'education': value,
      if (instance.workExperience?.toJson() case final value?)
        'work_experience': value,
    };

_$NutritionistCertificationRequestModelImpl
    _$$NutritionistCertificationRequestModelImplFromJson(
            Map<String, dynamic> json) =>
        _$NutritionistCertificationRequestModelImpl(
          personalInfo: PersonalInfoModel.fromJson(
              json['personal_info'] as Map<String, dynamic>),
          certificationInfo: CertificationInfoModel.fromJson(
              json['certification_info'] as Map<String, dynamic>),
          education: json['education'] == null
              ? null
              : EducationModel.fromJson(
                  json['education'] as Map<String, dynamic>),
          workExperience: json['work_experience'] == null
              ? null
              : WorkExperienceModel.fromJson(
                  json['work_experience'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$NutritionistCertificationRequestModelImplToJson(
        _$NutritionistCertificationRequestModelImpl instance) =>
    <String, dynamic>{
      'personal_info': instance.personalInfo.toJson(),
      'certification_info': instance.certificationInfo.toJson(),
      if (instance.education?.toJson() case final value?) 'education': value,
      if (instance.workExperience?.toJson() case final value?)
        'work_experience': value,
    };
