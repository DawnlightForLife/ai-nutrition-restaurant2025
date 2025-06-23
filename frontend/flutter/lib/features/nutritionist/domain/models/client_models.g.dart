// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionistClientImpl _$$NutritionistClientImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionistClientImpl(
      id: json['id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      healthOverview: json['health_overview'] == null
          ? null
          : HealthOverview.fromJson(
              json['health_overview'] as Map<String, dynamic>),
      lastConsultation: json['last_consultation'] == null
          ? null
          : DateTime.parse(json['last_consultation'] as String),
      consultationCount: (json['consultation_count'] as num?)?.toInt(),
      totalSpent: (json['total_spent'] as num?)?.toDouble(),
      progressHistory: (json['progress_history'] as List<dynamic>?)
          ?.map((e) => Progress.fromJson(e as Map<String, dynamic>))
          .toList(),
      goals: (json['goals'] as List<dynamic>?)
          ?.map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList(),
      nutritionPlanIds: (json['nutrition_plan_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionistClientImplToJson(
        _$NutritionistClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nutritionist_id': instance.nutritionistId,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      if (instance.age case final value?) 'age': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.healthOverview?.toJson() case final value?)
        'health_overview': value,
      if (instance.lastConsultation?.toIso8601String() case final value?)
        'last_consultation': value,
      if (instance.consultationCount case final value?)
        'consultation_count': value,
      if (instance.totalSpent case final value?) 'total_spent': value,
      if (instance.progressHistory?.map((e) => e.toJson()).toList()
          case final value?)
        'progress_history': value,
      if (instance.goals?.map((e) => e.toJson()).toList() case final value?)
        'goals': value,
      if (instance.reminders?.map((e) => e.toJson()).toList() case final value?)
        'reminders': value,
      if (instance.nutritionPlanIds case final value?)
        'nutrition_plan_ids': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$HealthOverviewImpl _$$HealthOverviewImplFromJson(Map<String, dynamic> json) =>
    _$HealthOverviewImpl(
      currentWeight: (json['current_weight'] as num?)?.toDouble(),
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      currentBMI: (json['current_b_m_i'] as num?)?.toDouble(),
      targetBMI: (json['target_b_m_i'] as num?)?.toDouble(),
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      medications: (json['medications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietaryRestrictions: (json['dietary_restrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$HealthOverviewImplToJson(
        _$HealthOverviewImpl instance) =>
    <String, dynamic>{
      if (instance.currentWeight case final value?) 'current_weight': value,
      if (instance.targetWeight case final value?) 'target_weight': value,
      if (instance.height case final value?) 'height': value,
      if (instance.currentBMI case final value?) 'current_b_m_i': value,
      if (instance.targetBMI case final value?) 'target_b_m_i': value,
      if (instance.bodyFatPercentage case final value?)
        'body_fat_percentage': value,
      if (instance.muscleMass case final value?) 'muscle_mass': value,
      if (instance.medicalConditions case final value?)
        'medical_conditions': value,
      if (instance.medications case final value?) 'medications': value,
      if (instance.allergies case final value?) 'allergies': value,
      if (instance.dietaryRestrictions case final value?)
        'dietary_restrictions': value,
    };

_$ProgressImpl _$$ProgressImplFromJson(Map<String, dynamic> json) =>
    _$ProgressImpl(
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
      measurements: (json['measurements'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      notes: json['notes'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProgressImplToJson(_$ProgressImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      if (instance.weight case final value?) 'weight': value,
      if (instance.bodyFatPercentage case final value?)
        'body_fat_percentage': value,
      if (instance.muscleMass case final value?) 'muscle_mass': value,
      if (instance.measurements case final value?) 'measurements': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.photos case final value?) 'photos': value,
    };

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      targetValue: (json['target_value'] as num?)?.toDouble(),
      currentValue: (json['current_value'] as num?)?.toDouble(),
      targetDate: json['target_date'] == null
          ? null
          : DateTime.parse(json['target_date'] as String),
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      if (instance.targetValue case final value?) 'target_value': value,
      if (instance.currentValue case final value?) 'current_value': value,
      if (instance.targetDate?.toIso8601String() case final value?)
        'target_date': value,
      'status': instance.status,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.completedAt?.toIso8601String() case final value?)
        'completed_at': value,
    };

_$ReminderImpl _$$ReminderImplFromJson(Map<String, dynamic> json) =>
    _$ReminderImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      reminderDate: DateTime.parse(json['reminder_date'] as String),
      isRecurring: json['is_recurring'] as bool?,
      recurringPattern: json['recurring_pattern'] as String?,
      isCompleted: json['is_completed'] as bool?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$ReminderImplToJson(_$ReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      if (instance.description case final value?) 'description': value,
      'reminder_date': instance.reminderDate.toIso8601String(),
      if (instance.isRecurring case final value?) 'is_recurring': value,
      if (instance.recurringPattern case final value?)
        'recurring_pattern': value,
      if (instance.isCompleted case final value?) 'is_completed': value,
      if (instance.completedAt?.toIso8601String() case final value?)
        'completed_at': value,
    };

_$ClientDetailImpl _$$ClientDetailImplFromJson(Map<String, dynamic> json) =>
    _$ClientDetailImpl(
      client:
          NutritionistClient.fromJson(json['client'] as Map<String, dynamic>),
      consultationHistory: (json['consultation_history'] as List<dynamic>?)
              ?.map((e) =>
                  ConsultationHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stats: json['stats'] == null
          ? null
          : ClientStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ClientDetailImplToJson(_$ClientDetailImpl instance) =>
    <String, dynamic>{
      'client': instance.client.toJson(),
      'consultation_history':
          instance.consultationHistory.map((e) => e.toJson()).toList(),
      if (instance.stats?.toJson() case final value?) 'stats': value,
    };

_$ConsultationHistoryImpl _$$ConsultationHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsultationHistoryImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      topic: json['topic'] as String?,
      summary: json['summary'] as String?,
      duration: (json['duration'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$$ConsultationHistoryImplToJson(
        _$ConsultationHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      if (instance.topic case final value?) 'topic': value,
      if (instance.summary case final value?) 'summary': value,
      if (instance.duration case final value?) 'duration': value,
      if (instance.price case final value?) 'price': value,
      if (instance.status case final value?) 'status': value,
      if (instance.rating case final value?) 'rating': value,
      if (instance.feedback case final value?) 'feedback': value,
    };

_$ClientStatsImpl _$$ClientStatsImplFromJson(Map<String, dynamic> json) =>
    _$ClientStatsImpl(
      totalConsultations: (json['total_consultations'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      goalsAchieved: (json['goals_achieved'] as num?)?.toInt() ?? 0,
      activeDays: (json['active_days'] as num?)?.toInt() ?? 0,
      weightProgress: (json['weight_progress'] as num?)?.toDouble(),
      adherenceRate: (json['adherence_rate'] as num?)?.toDouble(),
      firstConsultation: json['first_consultation'] == null
          ? null
          : DateTime.parse(json['first_consultation'] as String),
      lastConsultation: json['last_consultation'] == null
          ? null
          : DateTime.parse(json['last_consultation'] as String),
    );

Map<String, dynamic> _$$ClientStatsImplToJson(_$ClientStatsImpl instance) =>
    <String, dynamic>{
      'total_consultations': instance.totalConsultations,
      'total_revenue': instance.totalRevenue,
      'average_rating': instance.averageRating,
      'goals_achieved': instance.goalsAchieved,
      'active_days': instance.activeDays,
      if (instance.weightProgress case final value?) 'weight_progress': value,
      if (instance.adherenceRate case final value?) 'adherence_rate': value,
      if (instance.firstConsultation?.toIso8601String() case final value?)
        'first_consultation': value,
      if (instance.lastConsultation?.toIso8601String() case final value?)
        'last_consultation': value,
    };
