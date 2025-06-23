import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_models.freezed.dart';
part 'client_models.g.dart';

/// 营养师客户模型
@freezed
class NutritionistClient with _$NutritionistClient {
  const factory NutritionistClient({
    required String id,
    required String nutritionistId,
    required String userId,
    required String nickname,
    int? age,
    String? gender,
    HealthOverview? healthOverview,
    DateTime? lastConsultation,
    int? consultationCount,
    double? totalSpent,
    List<Progress>? progressHistory,
    List<Goal>? goals,
    List<Reminder>? reminders,
    List<String>? nutritionPlanIds,
    List<String>? tags,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NutritionistClient;

  factory NutritionistClient.fromJson(Map<String, dynamic> json) =>
      _$NutritionistClientFromJson(json);
}

/// 健康概况
@freezed
class HealthOverview with _$HealthOverview {
  const factory HealthOverview({
    double? currentWeight,
    double? targetWeight,
    double? height,
    double? currentBMI,
    double? targetBMI,
    double? bodyFatPercentage,
    double? muscleMass,
    List<String>? medicalConditions,
    List<String>? medications,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
  }) = _HealthOverview;

  factory HealthOverview.fromJson(Map<String, dynamic> json) =>
      _$HealthOverviewFromJson(json);
}

/// 进展记录
@freezed
class Progress with _$Progress {
  const factory Progress({
    required DateTime date,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    Map<String, double>? measurements,
    String? notes,
    List<String>? photos,
  }) = _Progress;

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
}

/// 目标
@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String type,
    required String description,
    double? targetValue,
    double? currentValue,
    DateTime? targetDate,
    required String status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) =>
      _$GoalFromJson(json);
}

/// 提醒
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String type,
    required String title,
    String? description,
    required DateTime reminderDate,
    bool? isRecurring,
    String? recurringPattern,
    bool? isCompleted,
    DateTime? completedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}

/// 客户详情（包含咨询历史）
@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    required NutritionistClient client,
    @Default([]) List<ConsultationHistory> consultationHistory,
    ClientStats? stats,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}

/// 咨询历史
@freezed
class ConsultationHistory with _$ConsultationHistory {
  const factory ConsultationHistory({
    required String id,
    required DateTime date,
    String? topic,
    String? summary,
    double? duration,
    double? price,
    String? status,
    double? rating,
    String? feedback,
  }) = _ConsultationHistory;

  factory ConsultationHistory.fromJson(Map<String, dynamic> json) =>
      _$ConsultationHistoryFromJson(json);
}

/// 客户统计
@freezed
class ClientStats with _$ClientStats {
  const factory ClientStats({
    @Default(0) int totalConsultations,
    @Default(0.0) double totalRevenue,
    @Default(0.0) double averageRating,
    @Default(0) int goalsAchieved,
    @Default(0) int activeDays,
    double? weightProgress,
    double? adherenceRate,
    DateTime? firstConsultation,
    DateTime? lastConsultation,
  }) = _ClientStats;

  factory ClientStats.fromJson(Map<String, dynamic> json) =>
      _$ClientStatsFromJson(json);
}

/// 客户列表参数
@freezed
class ClientListParams with _$ClientListParams {
  const factory ClientListParams({
    String? search,
    String? tag,
    String? sortBy,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _ClientListParams;
}

/// 批量消息参数
@freezed
class BatchMessageParams with _$BatchMessageParams {
  const factory BatchMessageParams({
    required List<String> clientIds,
    required String message,
    @Default('notification') String type,
  }) = _BatchMessageParams;
}

/// 进展更新参数
@freezed
class ProgressUpdateParams with _$ProgressUpdateParams {
  const factory ProgressUpdateParams({
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    Map<String, double>? measurements,
    String? notes,
    List<String>? photos,
  }) = _ProgressUpdateParams;
}