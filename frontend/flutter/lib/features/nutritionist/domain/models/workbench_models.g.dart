// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workbench_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      overall: OverallStats.fromJson(json['overall'] as Map<String, dynamic>),
      today: TodayStats.fromJson(json['today'] as Map<String, dynamic>),
      recentTrends: json['recent_trends'] as Map<String, dynamic>? ?? const {},
      upcomingConsultations: (json['upcoming_consultations'] as List<dynamic>?)
              ?.map((e) =>
                  UpcomingConsultation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
        _$DashboardStatsImpl instance) =>
    <String, dynamic>{
      'overall': instance.overall.toJson(),
      'today': instance.today.toJson(),
      'recent_trends': instance.recentTrends,
      'upcoming_consultations':
          instance.upcomingConsultations.map((e) => e.toJson()).toList(),
    };

_$OverallStatsImpl _$$OverallStatsImplFromJson(Map<String, dynamic> json) =>
    _$OverallStatsImpl(
      totalConsultations: (json['total_consultations'] as num?)?.toInt() ?? 0,
      totalClients: (json['total_clients'] as num?)?.toInt() ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$OverallStatsImplToJson(_$OverallStatsImpl instance) =>
    <String, dynamic>{
      'total_consultations': instance.totalConsultations,
      'total_clients': instance.totalClients,
      'average_rating': instance.averageRating,
      'total_revenue': instance.totalRevenue,
    };

_$TodayStatsImpl _$$TodayStatsImplFromJson(Map<String, dynamic> json) =>
    _$TodayStatsImpl(
      consultations: (json['consultations'] as num?)?.toInt() ?? 0,
      completedConsultations:
          (json['completed_consultations'] as num?)?.toInt() ?? 0,
      newClients: (json['new_clients'] as num?)?.toInt() ?? 0,
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TodayStatsImplToJson(_$TodayStatsImpl instance) =>
    <String, dynamic>{
      'consultations': instance.consultations,
      'completed_consultations': instance.completedConsultations,
      'new_clients': instance.newClients,
      'total_income': instance.totalIncome,
    };

_$UpcomingConsultationImpl _$$UpcomingConsultationImplFromJson(
        Map<String, dynamic> json) =>
    _$UpcomingConsultationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String?,
      appointmentTime: json['appointment_time'] == null
          ? null
          : DateTime.parse(json['appointment_time'] as String),
      status: json['status'] as String?,
      topic: json['topic'] as String?,
    );

Map<String, dynamic> _$$UpcomingConsultationImplToJson(
        _$UpcomingConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      if (instance.username case final value?) 'username': value,
      if (instance.appointmentTime?.toIso8601String() case final value?)
        'appointment_time': value,
      if (instance.status case final value?) 'status': value,
      if (instance.topic case final value?) 'topic': value,
    };

_$WorkbenchTaskImpl _$$WorkbenchTaskImplFromJson(Map<String, dynamic> json) =>
    _$WorkbenchTaskImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WorkbenchTaskImplToJson(_$WorkbenchTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.data case final value?) 'data': value,
    };

_$WorkbenchConsultationImpl _$$WorkbenchConsultationImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkbenchConsultationImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String?,
      topic: json['topic'] as String?,
      status: json['status'] as String?,
      appointmentTime: json['appointment_time'] == null
          ? null
          : DateTime.parse(json['appointment_time'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      userInfo: json['user_info'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WorkbenchConsultationImplToJson(
        _$WorkbenchConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      if (instance.username case final value?) 'username': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.status case final value?) 'status': value,
      if (instance.appointmentTime?.toIso8601String() case final value?)
        'appointment_time': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.duration case final value?) 'duration': value,
      if (instance.price case final value?) 'price': value,
      if (instance.userInfo case final value?) 'user_info': value,
    };

_$ScheduleImpl _$$ScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleImpl(
      workingHours: json['working_hours'] as Map<String, dynamic>? ?? const {},
      vacations: (json['vacations'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      appointments: (json['appointments'] as List<dynamic>?)
              ?.map((e) => Appointment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScheduleImplToJson(_$ScheduleImpl instance) =>
    <String, dynamic>{
      'working_hours': instance.workingHours,
      'vacations': instance.vacations,
      'appointments': instance.appointments.map((e) => e.toJson()).toList(),
    };

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      status: json['status'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      if (instance.status case final value?) 'status': value,
      if (instance.type case final value?) 'type': value,
    };

_$IncomeDetailsImpl _$$IncomeDetailsImplFromJson(Map<String, dynamic> json) =>
    _$IncomeDetailsImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => IncomeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$IncomeDetailsImplToJson(_$IncomeDetailsImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_amount': instance.totalAmount,
      'total_count': instance.totalCount,
      if (instance.page case final value?) 'page': value,
      if (instance.limit case final value?) 'limit': value,
    };

_$IncomeItemImpl _$$IncomeItemImplFromJson(Map<String, dynamic> json) =>
    _$IncomeItemImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      relatedId: json['related_id'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$IncomeItemImplToJson(_$IncomeItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      if (instance.description case final value?) 'description': value,
      if (instance.relatedId case final value?) 'related_id': value,
      if (instance.status case final value?) 'status': value,
    };

_$BatchMessageResultImpl _$$BatchMessageResultImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchMessageResultImpl(
      totalClients: (json['total_clients'] as num).toInt(),
      successCount: (json['success_count'] as num).toInt(),
      failCount: (json['fail_count'] as num).toInt(),
    );

Map<String, dynamic> _$$BatchMessageResultImplToJson(
        _$BatchMessageResultImpl instance) =>
    <String, dynamic>{
      'total_clients': instance.totalClients,
      'success_count': instance.successCount,
      'fail_count': instance.failCount,
    };

_$QuickActionImpl _$$QuickActionImplFromJson(Map<String, dynamic> json) =>
    _$QuickActionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      action: json['action'] as String,
      color: json['color'] as String,
      badge: (json['badge'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuickActionImplToJson(_$QuickActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'action': instance.action,
      'color': instance.color,
      if (instance.badge case final value?) 'badge': value,
    };

_$OnlineStatusResultImpl _$$OnlineStatusResultImplFromJson(
        Map<String, dynamic> json) =>
    _$OnlineStatusResultImpl(
      isOnline: json['is_online'] as bool,
      isAvailable: json['is_available'] as bool,
      onlineStatus: json['online_status'] as Map<String, dynamic>?,
      nutritionist: json['nutritionist'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$OnlineStatusResultImplToJson(
        _$OnlineStatusResultImpl instance) =>
    <String, dynamic>{
      'is_online': instance.isOnline,
      'is_available': instance.isAvailable,
      if (instance.onlineStatus case final value?) 'online_status': value,
      if (instance.nutritionist case final value?) 'nutritionist': value,
    };
