import 'package:freezed_annotation/freezed_annotation.dart';

part 'workbench_models.freezed.dart';
part 'workbench_models.g.dart';

/// 工作台统计数据
@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required OverallStats overall,
    required TodayStats today,
    @Default({}) Map<String, dynamic> recentTrends,
    @Default([]) List<UpcomingConsultation> upcomingConsultations,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}

/// 总体统计
@freezed
class OverallStats with _$OverallStats {
  const factory OverallStats({
    @Default(0) int totalConsultations,
    @Default(0) int totalClients,
    @Default(0.0) double averageRating,
    @Default(0.0) double totalRevenue,
  }) = _OverallStats;

  factory OverallStats.fromJson(Map<String, dynamic> json) =>
      _$OverallStatsFromJson(json);
}

/// 今日统计
@freezed
class TodayStats with _$TodayStats {
  const factory TodayStats({
    @Default(0) int consultations,
    @Default(0) int completedConsultations,
    @Default(0) int newClients,
    @Default(0.0) double totalIncome,
  }) = _TodayStats;

  factory TodayStats.fromJson(Map<String, dynamic> json) =>
      _$TodayStatsFromJson(json);
}

/// 即将进行的咨询
@freezed
class UpcomingConsultation with _$UpcomingConsultation {
  const factory UpcomingConsultation({
    required String id,
    required String userId,
    String? username,
    DateTime? appointmentTime,
    String? status,
    String? topic,
  }) = _UpcomingConsultation;

  factory UpcomingConsultation.fromJson(Map<String, dynamic> json) =>
      _$UpcomingConsultationFromJson(json);
}

/// 工作台任务
@freezed
class WorkbenchTask with _$WorkbenchTask {
  const factory WorkbenchTask({
    required String id,
    required String type,
    required String title,
    required String description,
    required String priority,
    required DateTime createdAt,
    Map<String, dynamic>? data,
  }) = _WorkbenchTask;

  factory WorkbenchTask.fromJson(Map<String, dynamic> json) =>
      _$WorkbenchTaskFromJson(json);
}

/// 工作台咨询
@freezed
class WorkbenchConsultation with _$WorkbenchConsultation {
  const factory WorkbenchConsultation({
    required String id,
    required String userId,
    String? username,
    String? topic,
    String? status,
    DateTime? appointmentTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? duration,
    double? price,
    Map<String, dynamic>? userInfo,
  }) = _WorkbenchConsultation;

  factory WorkbenchConsultation.fromJson(Map<String, dynamic> json) =>
      _$WorkbenchConsultationFromJson(json);
}

/// 排班表
@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    @Default({}) Map<String, dynamic> workingHours,
    @Default([]) List<Map<String, dynamic>> vacations,
    @Default([]) List<Appointment> appointments,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

/// 预约
@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String title,
    required DateTime start,
    required DateTime end,
    String? status,
    String? type,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}

/// 收入明细
@freezed
class IncomeDetails with _$IncomeDetails {
  const factory IncomeDetails({
    @Default([]) List<IncomeItem> items,
    @Default(0.0) double totalAmount,
    @Default(0) int totalCount,
    int? page,
    int? limit,
  }) = _IncomeDetails;

  factory IncomeDetails.fromJson(Map<String, dynamic> json) =>
      _$IncomeDetailsFromJson(json);
}

/// 收入项
@freezed
class IncomeItem with _$IncomeItem {
  const factory IncomeItem({
    required String id,
    required String type,
    required double amount,
    required DateTime date,
    String? description,
    String? relatedId,
    String? status,
  }) = _IncomeItem;

  factory IncomeItem.fromJson(Map<String, dynamic> json) =>
      _$IncomeItemFromJson(json);
}

/// 批量消息结果
@freezed
class BatchMessageResult with _$BatchMessageResult {
  const factory BatchMessageResult({
    required int totalClients,
    required int successCount,
    required int failCount,
  }) = _BatchMessageResult;

  factory BatchMessageResult.fromJson(Map<String, dynamic> json) =>
      _$BatchMessageResultFromJson(json);
}

/// 快捷操作
@freezed
class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required String title,
    required String icon,
    required String action,
    required String color,
    int? badge,
  }) = _QuickAction;

  factory QuickAction.fromJson(Map<String, dynamic> json) =>
      _$QuickActionFromJson(json);
}

/// 在线状态结果
@freezed
class OnlineStatusResult with _$OnlineStatusResult {
  const factory OnlineStatusResult({
    required bool isOnline,
    required bool isAvailable,
    Map<String, dynamic>? onlineStatus,
    Map<String, dynamic>? nutritionist,
  }) = _OnlineStatusResult;

  factory OnlineStatusResult.fromJson(Map<String, dynamic> json) =>
      _$OnlineStatusResultFromJson(json);
}