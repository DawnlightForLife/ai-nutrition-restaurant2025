import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_entity.freezed.dart';
part 'consultation_entity.g.dart';

@freezed
class ConsultationEntity with _$ConsultationEntity {
  const factory ConsultationEntity({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String nutritionistId,
    required String orderNumber,
    required ConsultationStatus status,
    required ConsultationType type,
    required String title,
    required String description,
    @Default([]) List<String> tags,
    required DateTime scheduledStartTime,
    required DateTime scheduledEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    required int duration, // in minutes
    required double price,
    @Default('') String meetingUrl,
    @Default('') String meetingId,
    @Default('') String meetingPassword,
    @Default({}) Map<String, dynamic> paymentInfo,
    double? rating,
    @Default('') String feedback,
    @Default('') String summary,
    @Default([]) List<String> attachments,
    String? nutritionPlanId,
    String? aiRecommendationId,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ConsultationEntity;

  factory ConsultationEntity.fromJson(Map<String, dynamic> json) =>
      _$ConsultationEntityFromJson(json);
}

// 咨询状态枚举
enum ConsultationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('missed')
  missed,
}

// 咨询类型枚举
enum ConsultationType {
  @JsonValue('text')
  text,
  @JsonValue('voice')
  voice,
  @JsonValue('video')
  video,
  @JsonValue('offline')
  offline,
}

// Extension methods
extension ConsultationStatusX on ConsultationStatus {
  String get displayName {
    switch (this) {
      case ConsultationStatus.pending:
        return '待确认';
      case ConsultationStatus.scheduled:
        return '已预约';
      case ConsultationStatus.inProgress:
        return '进行中';
      case ConsultationStatus.completed:
        return '已完成';
      case ConsultationStatus.cancelled:
        return '已取消';
      case ConsultationStatus.missed:
        return '已错过';
    }
  }

  String get value {
    return name;
  }
}

extension ConsultationTypeX on ConsultationType {
  String get displayName {
    switch (this) {
      case ConsultationType.text:
        return '文字咨询';
      case ConsultationType.voice:
        return '语音咨询';
      case ConsultationType.video:
        return '视频咨询';
      case ConsultationType.offline:
        return '线下咨询';
    }
  }

  String get icon {
    switch (this) {
      case ConsultationType.text:
        return '💬';
      case ConsultationType.voice:
        return '🎤';
      case ConsultationType.video:
        return '📹';
      case ConsultationType.offline:
        return '🏥';
    }
  }
}