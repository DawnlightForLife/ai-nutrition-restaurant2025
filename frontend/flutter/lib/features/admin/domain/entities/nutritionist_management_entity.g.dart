// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutritionist_management_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionistManagementEntityImpl _$$NutritionistManagementEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistManagementEntityImpl(
      id: json['id'] as String,
      realName: json['real_name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      licenseNumber: json['license_number'] as String,
      certificationLevel: json['certification_level'] as String,
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      experienceYears: (json['experience_years'] as num).toInt(),
      consultationFee: (json['consultation_fee'] as num).toDouble(),
      status: json['status'] as String,
      verificationStatus: json['verification_status'] as String,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      isOnline: json['is_online'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? false,
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : NutritionistStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NutritionistManagementEntityImplToJson(
        _$NutritionistManagementEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'real_name': instance.realName,
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.avatar case final value?) 'avatar': value,
      'license_number': instance.licenseNumber,
      'certification_level': instance.certificationLevel,
      'specializations': instance.specializations,
      'experience_years': instance.experienceYears,
      'consultation_fee': instance.consultationFee,
      'status': instance.status,
      'verification_status': instance.verificationStatus,
      'average_rating': instance.averageRating,
      'total_reviews': instance.totalReviews,
      'is_online': instance.isOnline,
      'is_available': instance.isAvailable,
      if (instance.lastActiveAt?.toIso8601String() case final value?)
        'last_active_at': value,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.stats?.toJson() case final value?) 'stats': value,
    };

_$NutritionistStatsImpl _$$NutritionistStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistStatsImpl(
      totalConsultations: (json['total_consultations'] as num?)?.toInt() ?? 0,
      completedConsultations:
          (json['completed_consultations'] as num?)?.toInt() ?? 0,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$NutritionistStatsImplToJson(
        _$NutritionistStatsImpl instance) =>
    <String, dynamic>{
      'total_consultations': instance.totalConsultations,
      'completed_consultations': instance.completedConsultations,
      'avg_rating': instance.avgRating,
      'total_income': instance.totalIncome,
    };

_$NutritionistManagementResponseImpl
    _$$NutritionistManagementResponseImplFromJson(Map<String, dynamic> json) =>
        _$NutritionistManagementResponseImpl(
          nutritionists: (json['nutritionists'] as List<dynamic>)
              .map((e) => NutritionistManagementEntity.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          pagination: PaginationInfo.fromJson(
              json['pagination'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$NutritionistManagementResponseImplToJson(
        _$NutritionistManagementResponseImpl instance) =>
    <String, dynamic>{
      'nutritionists': instance.nutritionists.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      current: (json['current'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      totalRecords: (json['total_records'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'total': instance.total,
      'page_size': instance.pageSize,
      'total_records': instance.totalRecords,
    };

_$NutritionistManagementOverviewImpl
    _$$NutritionistManagementOverviewImplFromJson(Map<String, dynamic> json) =>
        _$NutritionistManagementOverviewImpl(
          overview:
              OverviewStats.fromJson(json['overview'] as Map<String, dynamic>),
          distributions: DistributionStats.fromJson(
              json['distributions'] as Map<String, dynamic>),
          trends: TrendStats.fromJson(json['trends'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$NutritionistManagementOverviewImplToJson(
        _$NutritionistManagementOverviewImpl instance) =>
    <String, dynamic>{
      'overview': instance.overview.toJson(),
      'distributions': instance.distributions.toJson(),
      'trends': instance.trends.toJson(),
    };

_$OverviewStatsImpl _$$OverviewStatsImplFromJson(Map<String, dynamic> json) =>
    _$OverviewStatsImpl(
      totalNutritionists: (json['total_nutritionists'] as num?)?.toInt() ?? 0,
      activeNutritionists: (json['active_nutritionists'] as num?)?.toInt() ?? 0,
      pendingVerification: (json['pending_verification'] as num?)?.toInt() ?? 0,
      onlineNutritionists: (json['online_nutritionists'] as num?)?.toInt() ?? 0,
      activeInMonth: (json['active_in_month'] as num?)?.toInt() ?? 0,
      activityRate: json['activity_rate'] as String? ?? '0',
    );

Map<String, dynamic> _$$OverviewStatsImplToJson(_$OverviewStatsImpl instance) =>
    <String, dynamic>{
      'total_nutritionists': instance.totalNutritionists,
      'active_nutritionists': instance.activeNutritionists,
      'pending_verification': instance.pendingVerification,
      'online_nutritionists': instance.onlineNutritionists,
      'active_in_month': instance.activeInMonth,
      'activity_rate': instance.activityRate,
    };

_$DistributionStatsImpl _$$DistributionStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$DistributionStatsImpl(
      status: (json['status'] as List<dynamic>?)
              ?.map(
                  (e) => StatusDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      specialization: (json['specialization'] as List<dynamic>?)
              ?.map((e) => SpecializationDistribution.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      level: (json['level'] as List<dynamic>?)
              ?.map(
                  (e) => LevelDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DistributionStatsImplToJson(
        _$DistributionStatsImpl instance) =>
    <String, dynamic>{
      'status': instance.status.map((e) => e.toJson()).toList(),
      'specialization': instance.specialization.map((e) => e.toJson()).toList(),
      'level': instance.level.map((e) => e.toJson()).toList(),
    };

_$StatusDistributionImpl _$$StatusDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$StatusDistributionImpl(
      id: json['id'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$StatusDistributionImplToJson(
        _$StatusDistributionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
    };

_$SpecializationDistributionImpl _$$SpecializationDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$SpecializationDistributionImpl(
      id: json['id'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$SpecializationDistributionImplToJson(
        _$SpecializationDistributionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
    };

_$LevelDistributionImpl _$$LevelDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$LevelDistributionImpl(
      id: json['id'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$LevelDistributionImplToJson(
        _$LevelDistributionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
    };

_$TrendStatsImpl _$$TrendStatsImplFromJson(Map<String, dynamic> json) =>
    _$TrendStatsImpl(
      registration: (json['registration'] as List<dynamic>?)
              ?.map(
                  (e) => RegistrationTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TrendStatsImplToJson(_$TrendStatsImpl instance) =>
    <String, dynamic>{
      'registration': instance.registration.map((e) => e.toJson()).toList(),
    };

_$RegistrationTrendImpl _$$RegistrationTrendImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationTrendImpl(
      id: TrendId.fromJson(json['id'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$RegistrationTrendImplToJson(
        _$RegistrationTrendImpl instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'count': instance.count,
    };

_$TrendIdImpl _$$TrendIdImplFromJson(Map<String, dynamic> json) =>
    _$TrendIdImpl(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
    );

Map<String, dynamic> _$$TrendIdImplToJson(_$TrendIdImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };

_$NutritionistQuickSearchResultImpl
    _$$NutritionistQuickSearchResultImplFromJson(Map<String, dynamic> json) =>
        _$NutritionistQuickSearchResultImpl(
          id: json['id'] as String,
          name: json['name'] as String,
          phone: json['phone'] as String?,
          email: json['email'] as String?,
          avatar: json['avatar'] as String?,
          licenseNumber: json['license_number'] as String?,
          specializations: (json['specializations'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          status: json['status'] as String,
          verificationStatus: json['verification_status'] as String,
          isOnline: json['is_online'] as bool? ?? false,
        );

Map<String, dynamic> _$$NutritionistQuickSearchResultImplToJson(
        _$NutritionistQuickSearchResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.licenseNumber case final value?) 'license_number': value,
      'specializations': instance.specializations,
      'status': instance.status,
      'verification_status': instance.verificationStatus,
      'is_online': instance.isOnline,
    };

_$NutritionistDetailEntityImpl _$$NutritionistDetailEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistDetailEntityImpl(
      nutritionist: NutritionistManagementEntity.fromJson(
          json['nutritionist'] as Map<String, dynamic>),
      certification: json['certification'] == null
          ? null
          : NutritionistCertification.fromJson(
              json['certification'] as Map<String, dynamic>),
      stats: NutritionistDetailStats.fromJson(
          json['stats'] as Map<String, dynamic>),
      recentConsultations: (json['recent_consultations'] as List<dynamic>?)
              ?.map(
                  (e) => RecentConsultation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      monthlyTrend: (json['monthly_trend'] as List<dynamic>?)
              ?.map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NutritionistDetailEntityImplToJson(
        _$NutritionistDetailEntityImpl instance) =>
    <String, dynamic>{
      'nutritionist': instance.nutritionist.toJson(),
      if (instance.certification?.toJson() case final value?)
        'certification': value,
      'stats': instance.stats.toJson(),
      'recent_consultations':
          instance.recentConsultations.map((e) => e.toJson()).toList(),
      'monthly_trend': instance.monthlyTrend.map((e) => e.toJson()).toList(),
    };

_$NutritionistCertificationImpl _$$NutritionistCertificationImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistCertificationImpl(
      id: json['id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      status: json['status'] as String,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewNotes: json['review_notes'] as String?,
    );

Map<String, dynamic> _$$NutritionistCertificationImplToJson(
        _$NutritionistCertificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nutritionist_id': instance.nutritionistId,
      'status': instance.status,
      if (instance.reviewedBy case final value?) 'reviewed_by': value,
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      if (instance.reviewNotes case final value?) 'review_notes': value,
    };

_$NutritionistDetailStatsImpl _$$NutritionistDetailStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistDetailStatsImpl(
      totalConsultations: (json['total_consultations'] as num?)?.toInt() ?? 0,
      completedConsultations:
          (json['completed_consultations'] as num?)?.toInt() ?? 0,
      cancelledConsultations:
          (json['cancelled_consultations'] as num?)?.toInt() ?? 0,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['total_ratings'] as num?)?.toInt() ?? 0,
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$NutritionistDetailStatsImplToJson(
        _$NutritionistDetailStatsImpl instance) =>
    <String, dynamic>{
      'total_consultations': instance.totalConsultations,
      'completed_consultations': instance.completedConsultations,
      'cancelled_consultations': instance.cancelledConsultations,
      'avg_rating': instance.avgRating,
      'total_ratings': instance.totalRatings,
      'total_income': instance.totalIncome,
    };

_$RecentConsultationImpl _$$RecentConsultationImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentConsultationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      userPhone: json['user_phone'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      amount: (json['amount'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$RecentConsultationImplToJson(
        _$RecentConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      if (instance.userName case final value?) 'user_name': value,
      if (instance.userAvatar case final value?) 'user_avatar': value,
      if (instance.userPhone case final value?) 'user_phone': value,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.amount case final value?) 'amount': value,
      if (instance.rating case final value?) 'rating': value,
    };

_$MonthlyTrendImpl _$$MonthlyTrendImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyTrendImpl(
      id: TrendId.fromJson(json['id'] as Map<String, dynamic>),
      consultations: (json['consultations'] as num?)?.toInt() ?? 0,
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$MonthlyTrendImplToJson(_$MonthlyTrendImpl instance) =>
    <String, dynamic>{
      'id': instance.id.toJson(),
      'consultations': instance.consultations,
      'income': instance.income,
    };

_$BatchOperationResultImpl _$$BatchOperationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchOperationResultImpl(
      message: json['message'] as String,
      affected: (json['affected'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$BatchOperationResultImplToJson(
        _$BatchOperationResultImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'affected': instance.affected,
      'total': instance.total,
    };
