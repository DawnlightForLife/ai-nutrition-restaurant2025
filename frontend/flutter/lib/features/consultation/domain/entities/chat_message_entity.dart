import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_entity.freezed.dart';
part 'chat_message_entity.g.dart';

@freezed
class ChatMessageEntity with _$ChatMessageEntity {
  const factory ChatMessageEntity({
    @JsonKey(name: '_id') required String id,
    required String consultationId,
    required String senderId,
    required String senderName,
    required MessageSenderType senderType,
    required MessageType messageType,
    required String content,
    @Default([]) List<MessageAttachment> attachments,
    @Default(false) bool isRead,
    DateTime? readAt,
    @Default(false) bool isEdited,
    DateTime? editedAt,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    String? replyToMessageId,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ChatMessageEntity;

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);
}

@freezed
class MessageAttachment with _$MessageAttachment {
  const factory MessageAttachment({
    required String id,
    required String url,
    required AttachmentType type,
    required String fileName,
    required int fileSize,
    @Default('') String mimeType,
    @Default({}) Map<String, dynamic> metadata,
  }) = _MessageAttachment;

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentFromJson(json);
}

// 发送者类型枚举
enum MessageSenderType {
  @JsonValue('user')
  user,
  @JsonValue('nutritionist')
  nutritionist,
  @JsonValue('system')
  system,
  @JsonValue('ai_assistant')
  aiAssistant,
}

// 消息类型枚举
enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
  @JsonValue('voice')
  voice,
  @JsonValue('video')
  video,
  @JsonValue('nutrition_plan')
  nutritionPlan,
  @JsonValue('food_analysis')
  foodAnalysis,
  @JsonValue('system_notice')
  systemNotice,
}

// 附件类型枚举
enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('document')
  document,
  @JsonValue('audio')
  audio,
  @JsonValue('video')
  video,
  @JsonValue('other')
  other,
}

// Extension methods
extension MessageSenderTypeX on MessageSenderType {
  String get displayName {
    switch (this) {
      case MessageSenderType.user:
        return '用户';
      case MessageSenderType.nutritionist:
        return '营养师';
      case MessageSenderType.system:
        return '系统';
      case MessageSenderType.aiAssistant:
        return 'AI助手';
    }
  }
}

extension MessageTypeX on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return '文本';
      case MessageType.image:
        return '图片';
      case MessageType.file:
        return '文件';
      case MessageType.voice:
        return '语音';
      case MessageType.video:
        return '视频';
      case MessageType.nutritionPlan:
        return '营养方案';
      case MessageType.foodAnalysis:
        return '食物分析';
      case MessageType.systemNotice:
        return '系统通知';
    }
  }

  bool get isMedia {
    return [MessageType.image, MessageType.voice, MessageType.video].contains(this);
  }
}

extension AttachmentTypeX on AttachmentType {
  String get icon {
    switch (this) {
      case AttachmentType.image:
        return '🖼️';
      case AttachmentType.document:
        return '📄';
      case AttachmentType.audio:
        return '🎵';
      case AttachmentType.video:
        return '🎬';
      case AttachmentType.other:
        return '📎';
    }
  }

  bool get isPreviewable {
    return [AttachmentType.image, AttachmentType.video].contains(this);
  }
}