// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageEntityImpl _$$ChatMessageEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageEntityImpl(
      id: json['_id'] as String,
      consultationId: json['consultation_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      senderType: $enumDecode(_$MessageSenderTypeEnumMap, json['sender_type']),
      messageType: $enumDecode(_$MessageTypeEnumMap, json['message_type']),
      content: json['content'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map(
                  (e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      isEdited: json['is_edited'] as bool? ?? false,
      editedAt: json['edited_at'] == null
          ? null
          : DateTime.parse(json['edited_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      replyToMessageId: json['reply_to_message_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChatMessageEntityImplToJson(
        _$ChatMessageEntityImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'consultation_id': instance.consultationId,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'sender_type': _$MessageSenderTypeEnumMap[instance.senderType]!,
      'message_type': _$MessageTypeEnumMap[instance.messageType]!,
      'content': instance.content,
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'is_read': instance.isRead,
      if (instance.readAt?.toIso8601String() case final value?)
        'read_at': value,
      'is_edited': instance.isEdited,
      if (instance.editedAt?.toIso8601String() case final value?)
        'edited_at': value,
      'is_deleted': instance.isDeleted,
      if (instance.deletedAt?.toIso8601String() case final value?)
        'deleted_at': value,
      if (instance.replyToMessageId case final value?)
        'reply_to_message_id': value,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$MessageSenderTypeEnumMap = {
  MessageSenderType.user: 'user',
  MessageSenderType.nutritionist: 'nutritionist',
  MessageSenderType.system: 'system',
  MessageSenderType.aiAssistant: 'ai_assistant',
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.video: 'video',
  MessageType.nutritionPlan: 'nutrition_plan',
  MessageType.foodAnalysis: 'food_analysis',
  MessageType.systemNotice: 'system_notice',
};

_$MessageAttachmentImpl _$$MessageAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageAttachmentImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
      fileName: json['file_name'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$MessageAttachmentImplToJson(
        _$MessageAttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'metadata': instance.metadata,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.document: 'document',
  AttachmentType.audio: 'audio',
  AttachmentType.video: 'video',
  AttachmentType.other: 'other',
};
