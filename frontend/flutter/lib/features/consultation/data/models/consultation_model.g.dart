// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsultationModelImpl _$$ConsultationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsultationModelImpl(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      orderNumber: json['order_number'] as String,
      status: $enumDecode(_$ConsultationStatusEnumMap, json['status']),
      type: $enumDecode(_$ConsultationTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      scheduledStartTime:
          DateTime.parse(json['scheduled_start_time'] as String),
      scheduledEndTime: DateTime.parse(json['scheduled_end_time'] as String),
      actualStartTime: json['actual_start_time'] == null
          ? null
          : DateTime.parse(json['actual_start_time'] as String),
      actualEndTime: json['actual_end_time'] == null
          ? null
          : DateTime.parse(json['actual_end_time'] as String),
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      meetingUrl: json['meeting_url'] as String? ?? '',
      meetingId: json['meeting_id'] as String? ?? '',
      meetingPassword: json['meeting_password'] as String? ?? '',
      paymentInfo: json['payment_info'] as Map<String, dynamic>? ?? const {},
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionPlanId: json['nutrition_plan_id'] as String?,
      aiRecommendationId: json['ai_recommendation_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ConsultationModelImplToJson(
        _$ConsultationModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      'nutritionist_id': instance.nutritionistId,
      'order_number': instance.orderNumber,
      'status': _$ConsultationStatusEnumMap[instance.status]!,
      'type': _$ConsultationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'scheduled_start_time': instance.scheduledStartTime.toIso8601String(),
      'scheduled_end_time': instance.scheduledEndTime.toIso8601String(),
      if (instance.actualStartTime?.toIso8601String() case final value?)
        'actual_start_time': value,
      if (instance.actualEndTime?.toIso8601String() case final value?)
        'actual_end_time': value,
      'duration': instance.duration,
      'price': instance.price,
      'meeting_url': instance.meetingUrl,
      'meeting_id': instance.meetingId,
      'meeting_password': instance.meetingPassword,
      'payment_info': instance.paymentInfo,
      if (instance.rating case final value?) 'rating': value,
      'feedback': instance.feedback,
      'summary': instance.summary,
      'attachments': instance.attachments,
      if (instance.nutritionPlanId case final value?)
        'nutrition_plan_id': value,
      if (instance.aiRecommendationId case final value?)
        'ai_recommendation_id': value,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$ConsultationStatusEnumMap = {
  ConsultationStatus.pending: 'pending',
  ConsultationStatus.scheduled: 'scheduled',
  ConsultationStatus.inProgress: 'in_progress',
  ConsultationStatus.completed: 'completed',
  ConsultationStatus.cancelled: 'cancelled',
  ConsultationStatus.missed: 'missed',
};

const _$ConsultationTypeEnumMap = {
  ConsultationType.text: 'text',
  ConsultationType.voice: 'voice',
  ConsultationType.video: 'video',
  ConsultationType.offline: 'offline',
};

_$CreateConsultationRequestImpl _$$CreateConsultationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateConsultationRequestImpl(
      userId: json['user_id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      type: $enumDecode(_$ConsultationTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledStartTime:
          DateTime.parse(json['scheduled_start_time'] as String),
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$CreateConsultationRequestImplToJson(
        _$CreateConsultationRequestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nutritionist_id': instance.nutritionistId,
      'type': _$ConsultationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'scheduled_start_time': instance.scheduledStartTime.toIso8601String(),
      'duration': instance.duration,
      'price': instance.price,
      'tags': instance.tags,
    };

_$UpdateConsultationRequestImpl _$$UpdateConsultationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateConsultationRequestImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$ConsultationStatusEnumMap, json['status']),
      scheduledStartTime: json['scheduled_start_time'] == null
          ? null
          : DateTime.parse(json['scheduled_start_time'] as String),
      scheduledEndTime: json['scheduled_end_time'] == null
          ? null
          : DateTime.parse(json['scheduled_end_time'] as String),
      summary: json['summary'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UpdateConsultationRequestImplToJson(
        _$UpdateConsultationRequestImpl instance) =>
    <String, dynamic>{
      if (instance.title case final value?) 'title': value,
      if (instance.description case final value?) 'description': value,
      if (_$ConsultationStatusEnumMap[instance.status] case final value?)
        'status': value,
      if (instance.scheduledStartTime?.toIso8601String() case final value?)
        'scheduled_start_time': value,
      if (instance.scheduledEndTime?.toIso8601String() case final value?)
        'scheduled_end_time': value,
      if (instance.summary case final value?) 'summary': value,
      if (instance.rating case final value?) 'rating': value,
      if (instance.feedback case final value?) 'feedback': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.metadata case final value?) 'metadata': value,
    };
