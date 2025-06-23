import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutritionist_management_entity.freezed.dart';
part 'nutritionist_management_entity.g.dart';

@freezed
class NutritionistManagementEntity with _$NutritionistManagementEntity {
  const factory NutritionistManagementEntity({
    required String id,
    required String realName,
    String? phone,
    String? email,
    String? avatar,
    required String licenseNumber,
    required String certificationLevel,
    @Default([]) List<String> specializations,
    required int experienceYears,
    required double consultationFee,
    required String status,
    required String verificationStatus,
    @Default(0.0) double averageRating,
    @Default(0) int totalReviews,
    @Default(false) bool isOnline,
    @Default(false) bool isAvailable,
    DateTime? lastActiveAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    NutritionistStats? stats,
  }) = _NutritionistManagementEntity;

  factory NutritionistManagementEntity.fromJson(Map<String, dynamic> json) =>
      _$NutritionistManagementEntityFromJson(json);
}

@freezed
class NutritionistStats with _$NutritionistStats {
  const factory NutritionistStats({
    @Default(0) int totalConsultations,
    @Default(0) int completedConsultations,
    @Default(0.0) double avgRating,
    @Default(0.0) double totalIncome,
  }) = _NutritionistStats;

  factory NutritionistStats.fromJson(Map<String, dynamic> json) =>
      _$NutritionistStatsFromJson(json);
}

@freezed
class NutritionistManagementResponse with _$NutritionistManagementResponse {
  const factory NutritionistManagementResponse({
    required List<NutritionistManagementEntity> nutritionists,
    required PaginationInfo pagination,
  }) = _NutritionistManagementResponse;

  factory NutritionistManagementResponse.fromJson(Map<String, dynamic> json) =>
      _$NutritionistManagementResponseFromJson(json);
}

@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    required int current,
    required int total,
    required int pageSize,
    required int totalRecords,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}

@freezed
class NutritionistManagementOverview with _$NutritionistManagementOverview {
  const factory NutritionistManagementOverview({
    required OverviewStats overview,
    required DistributionStats distributions,
    required TrendStats trends,
  }) = _NutritionistManagementOverview;

  factory NutritionistManagementOverview.fromJson(Map<String, dynamic> json) =>
      _$NutritionistManagementOverviewFromJson(json);
}

@freezed
class OverviewStats with _$OverviewStats {
  const factory OverviewStats({
    @Default(0) int totalNutritionists,
    @Default(0) int activeNutritionists,
    @Default(0) int pendingVerification,
    @Default(0) int onlineNutritionists,
    @Default(0) int activeInMonth,
    @Default('0') String activityRate,
  }) = _OverviewStats;

  factory OverviewStats.fromJson(Map<String, dynamic> json) =>
      _$OverviewStatsFromJson(json);
}

@freezed
class DistributionStats with _$DistributionStats {
  const factory DistributionStats({
    @Default([]) List<StatusDistribution> status,
    @Default([]) List<SpecializationDistribution> specialization,
    @Default([]) List<LevelDistribution> level,
  }) = _DistributionStats;

  factory DistributionStats.fromJson(Map<String, dynamic> json) =>
      _$DistributionStatsFromJson(json);
}

@freezed
class StatusDistribution with _$StatusDistribution {
  const factory StatusDistribution({
    required String id,
    required int count,
  }) = _StatusDistribution;

  factory StatusDistribution.fromJson(Map<String, dynamic> json) =>
      _$StatusDistributionFromJson(json);
}

@freezed
class SpecializationDistribution with _$SpecializationDistribution {
  const factory SpecializationDistribution({
    required String id,
    required int count,
  }) = _SpecializationDistribution;

  factory SpecializationDistribution.fromJson(Map<String, dynamic> json) =>
      _$SpecializationDistributionFromJson(json);
}

@freezed
class LevelDistribution with _$LevelDistribution {
  const factory LevelDistribution({
    required String id,
    required int count,
  }) = _LevelDistribution;

  factory LevelDistribution.fromJson(Map<String, dynamic> json) =>
      _$LevelDistributionFromJson(json);
}

@freezed
class TrendStats with _$TrendStats {
  const factory TrendStats({
    @Default([]) List<RegistrationTrend> registration,
  }) = _TrendStats;

  factory TrendStats.fromJson(Map<String, dynamic> json) =>
      _$TrendStatsFromJson(json);
}

@freezed
class RegistrationTrend with _$RegistrationTrend {
  const factory RegistrationTrend({
    required TrendId id,
    required int count,
  }) = _RegistrationTrend;

  factory RegistrationTrend.fromJson(Map<String, dynamic> json) =>
      _$RegistrationTrendFromJson(json);
}

@freezed
class TrendId with _$TrendId {
  const factory TrendId({
    required int year,
    required int month,
    required int day,
  }) = _TrendId;

  factory TrendId.fromJson(Map<String, dynamic> json) =>
      _$TrendIdFromJson(json);
}

@freezed
class NutritionistQuickSearchResult with _$NutritionistQuickSearchResult {
  const factory NutritionistQuickSearchResult({
    required String id,
    required String name,
    String? phone,
    String? email,
    String? avatar,
    String? licenseNumber,
    @Default([]) List<String> specializations,
    required String status,
    required String verificationStatus,
    @Default(false) bool isOnline,
  }) = _NutritionistQuickSearchResult;

  factory NutritionistQuickSearchResult.fromJson(Map<String, dynamic> json) =>
      _$NutritionistQuickSearchResultFromJson(json);
}

@freezed
class NutritionistDetailEntity with _$NutritionistDetailEntity {
  const factory NutritionistDetailEntity({
    required NutritionistManagementEntity nutritionist,
    NutritionistCertification? certification,
    required NutritionistDetailStats stats,
    @Default([]) List<RecentConsultation> recentConsultations,
    @Default([]) List<MonthlyTrend> monthlyTrend,
  }) = _NutritionistDetailEntity;

  factory NutritionistDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$NutritionistDetailEntityFromJson(json);
}

@freezed
class NutritionistCertification with _$NutritionistCertification {
  const factory NutritionistCertification({
    required String id,
    required String nutritionistId,
    required String status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNotes,
  }) = _NutritionistCertification;

  factory NutritionistCertification.fromJson(Map<String, dynamic> json) =>
      _$NutritionistCertificationFromJson(json);
}

@freezed
class NutritionistDetailStats with _$NutritionistDetailStats {
  const factory NutritionistDetailStats({
    @Default(0) int totalConsultations,
    @Default(0) int completedConsultations,
    @Default(0) int cancelledConsultations,
    @Default(0.0) double avgRating,
    @Default(0) int totalRatings,
    @Default(0.0) double totalIncome,
  }) = _NutritionistDetailStats;

  factory NutritionistDetailStats.fromJson(Map<String, dynamic> json) =>
      _$NutritionistDetailStatsFromJson(json);
}

@freezed
class RecentConsultation with _$RecentConsultation {
  const factory RecentConsultation({
    required String id,
    required String userId,
    String? userName,
    String? userAvatar,
    String? userPhone,
    required String status,
    required DateTime createdAt,
    double? amount,
    double? rating,
  }) = _RecentConsultation;

  factory RecentConsultation.fromJson(Map<String, dynamic> json) =>
      _$RecentConsultationFromJson(json);
}

@freezed
class MonthlyTrend with _$MonthlyTrend {
  const factory MonthlyTrend({
    required TrendId id,
    @Default(0) int consultations,
    @Default(0.0) double income,
  }) = _MonthlyTrend;

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) =>
      _$MonthlyTrendFromJson(json);
}

@freezed
class BatchOperationResult with _$BatchOperationResult {
  const factory BatchOperationResult({
    required String message,
    required int affected,
    required int total,
  }) = _BatchOperationResult;

  factory BatchOperationResult.fromJson(Map<String, dynamic> json) =>
      _$BatchOperationResultFromJson(json);
}