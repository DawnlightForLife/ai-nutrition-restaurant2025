import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();
  
  const factory ChatMessageModel({
    @JsonKey(name: '_id') required String id,
    required String consultationId,
    required String senderId,
    required String senderName,
    required MessageSenderType senderType,
    required MessageType messageType,
    required String content,
    @Default([]) List<MessageAttachmentModel> attachments,
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
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => 
      _$ChatMessageModelFromJson(json);
}

@freezed
class MessageAttachmentModel with _$MessageAttachmentModel {
  const factory MessageAttachmentModel({
    required String id,
    required String url,
    required AttachmentType type,
    required String fileName,
    required int fileSize,
    @Default('') String mimeType,
    @Default({}) Map<String, dynamic> metadata,
  }) = _MessageAttachmentModel;

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentModelFromJson(json);
}

// Extension methods to convert between models and entities
extension ChatMessageModelX on ChatMessageModel {
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      consultationId: consultationId,
      senderId: senderId,
      senderName: senderName,
      senderType: senderType,
      messageType: messageType,
      content: content,
      attachments: attachments.map((a) => a.toEntity()).toList(),
      isRead: isRead,
      readAt: readAt,
      isEdited: isEdited,
      editedAt: editedAt,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
      replyToMessageId: replyToMessageId,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MessageAttachmentModelX on MessageAttachmentModel {
  MessageAttachment toEntity() {
    return MessageAttachment(
      id: id,
      url: url,
      type: type,
      fileName: fileName,
      fileSize: fileSize,
      mimeType: mimeType,
      metadata: metadata,
    );
  }
}