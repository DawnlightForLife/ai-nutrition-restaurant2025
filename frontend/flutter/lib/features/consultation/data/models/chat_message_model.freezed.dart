// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return _ChatMessageModel.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get consultationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  MessageSenderType get senderType => throw _privateConstructorUsedError;
  MessageType get messageType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<MessageAttachmentModel> get attachments =>
      throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChatMessageModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChatMessageModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChatMessageModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) then) =
      _$ChatMessageModelCopyWithImpl<$Res, ChatMessageModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String consultationId,
      String senderId,
      String senderName,
      MessageSenderType senderType,
      MessageType messageType,
      String content,
      List<MessageAttachmentModel> attachments,
      bool isRead,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      bool isDeleted,
      DateTime? deletedAt,
      String? replyToMessageId,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res, $Val extends ChatMessageModel>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultationId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderType = null,
    Object? messageType = null,
    Object? content = null,
    Object? attachments = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? replyToMessageId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: null == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderType: null == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as MessageSenderType,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<MessageAttachmentModel>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageModelImplCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$$ChatMessageModelImplCopyWith(_$ChatMessageModelImpl value,
          $Res Function(_$ChatMessageModelImpl) then) =
      __$$ChatMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String consultationId,
      String senderId,
      String senderName,
      MessageSenderType senderType,
      MessageType messageType,
      String content,
      List<MessageAttachmentModel> attachments,
      bool isRead,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      bool isDeleted,
      DateTime? deletedAt,
      String? replyToMessageId,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ChatMessageModelImplCopyWithImpl<$Res>
    extends _$ChatMessageModelCopyWithImpl<$Res, _$ChatMessageModelImpl>
    implements _$$ChatMessageModelImplCopyWith<$Res> {
  __$$ChatMessageModelImplCopyWithImpl(_$ChatMessageModelImpl _value,
      $Res Function(_$ChatMessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultationId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderType = null,
    Object? messageType = null,
    Object? content = null,
    Object? attachments = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? replyToMessageId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChatMessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: null == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderType: null == senderType
          ? _value.senderType
          : senderType // ignore: cast_nullable_to_non_nullable
              as MessageSenderType,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<MessageAttachmentModel>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageModelImpl extends _ChatMessageModel {
  const _$ChatMessageModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.consultationId,
      required this.senderId,
      required this.senderName,
      required this.senderType,
      required this.messageType,
      required this.content,
      final List<MessageAttachmentModel> attachments = const [],
      this.isRead = false,
      this.readAt,
      this.isEdited = false,
      this.editedAt,
      this.isDeleted = false,
      this.deletedAt,
      this.replyToMessageId,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      this.updatedAt})
      : _attachments = attachments,
        _metadata = metadata,
        super._();

  factory _$ChatMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String consultationId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final MessageSenderType senderType;
  @override
  final MessageType messageType;
  @override
  final String content;
  final List<MessageAttachmentModel> _attachments;
  @override
  @JsonKey()
  List<MessageAttachmentModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? readAt;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  final DateTime? editedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? deletedAt;
  @override
  final String? replyToMessageId;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, consultationId: $consultationId, senderId: $senderId, senderName: $senderName, senderType: $senderType, messageType: $messageType, content: $content, attachments: $attachments, isRead: $isRead, readAt: $readAt, isEdited: $isEdited, editedAt: $editedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, replyToMessageId: $replyToMessageId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.consultationId, consultationId) ||
                other.consultationId == consultationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderType, senderType) ||
                other.senderType == senderType) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      consultationId,
      senderId,
      senderName,
      senderType,
      messageType,
      content,
      const DeepCollectionEquality().hash(_attachments),
      isRead,
      readAt,
      isEdited,
      editedAt,
      isDeleted,
      deletedAt,
      replyToMessageId,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      __$$ChatMessageModelImplCopyWithImpl<_$ChatMessageModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChatMessageModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChatMessageModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChatMessageModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageModelImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageModel extends ChatMessageModel {
  const factory _ChatMessageModel(
      {@JsonKey(name: '_id') required final String id,
      required final String consultationId,
      required final String senderId,
      required final String senderName,
      required final MessageSenderType senderType,
      required final MessageType messageType,
      required final String content,
      final List<MessageAttachmentModel> attachments,
      final bool isRead,
      final DateTime? readAt,
      final bool isEdited,
      final DateTime? editedAt,
      final bool isDeleted,
      final DateTime? deletedAt,
      final String? replyToMessageId,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ChatMessageModelImpl;
  const _ChatMessageModel._() : super._();

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$ChatMessageModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get consultationId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  MessageSenderType get senderType;
  @override
  MessageType get messageType;
  @override
  String get content;
  @override
  List<MessageAttachmentModel> get attachments;
  @override
  bool get isRead;
  @override
  DateTime? get readAt;
  @override
  bool get isEdited;
  @override
  DateTime? get editedAt;
  @override
  bool get isDeleted;
  @override
  DateTime? get deletedAt;
  @override
  String? get replyToMessageId;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageAttachmentModel _$MessageAttachmentModelFromJson(
    Map<String, dynamic> json) {
  return _MessageAttachmentModel.fromJson(json);
}

/// @nodoc
mixin _$MessageAttachmentModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  AttachmentType get type => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MessageAttachmentModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MessageAttachmentModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MessageAttachmentModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MessageAttachmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageAttachmentModelCopyWith<MessageAttachmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageAttachmentModelCopyWith<$Res> {
  factory $MessageAttachmentModelCopyWith(MessageAttachmentModel value,
          $Res Function(MessageAttachmentModel) then) =
      _$MessageAttachmentModelCopyWithImpl<$Res, MessageAttachmentModel>;
  @useResult
  $Res call(
      {String id,
      String url,
      AttachmentType type,
      String fileName,
      int fileSize,
      String mimeType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$MessageAttachmentModelCopyWithImpl<$Res,
        $Val extends MessageAttachmentModel>
    implements $MessageAttachmentModelCopyWith<$Res> {
  _$MessageAttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? type = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttachmentType,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageAttachmentModelImplCopyWith<$Res>
    implements $MessageAttachmentModelCopyWith<$Res> {
  factory _$$MessageAttachmentModelImplCopyWith(
          _$MessageAttachmentModelImpl value,
          $Res Function(_$MessageAttachmentModelImpl) then) =
      __$$MessageAttachmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      AttachmentType type,
      String fileName,
      int fileSize,
      String mimeType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$MessageAttachmentModelImplCopyWithImpl<$Res>
    extends _$MessageAttachmentModelCopyWithImpl<$Res,
        _$MessageAttachmentModelImpl>
    implements _$$MessageAttachmentModelImplCopyWith<$Res> {
  __$$MessageAttachmentModelImplCopyWithImpl(
      _$MessageAttachmentModelImpl _value,
      $Res Function(_$MessageAttachmentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? type = null,
    Object? fileName = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? metadata = null,
  }) {
    return _then(_$MessageAttachmentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttachmentType,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageAttachmentModelImpl implements _MessageAttachmentModel {
  const _$MessageAttachmentModelImpl(
      {required this.id,
      required this.url,
      required this.type,
      required this.fileName,
      required this.fileSize,
      this.mimeType = '',
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$MessageAttachmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageAttachmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final AttachmentType type;
  @override
  final String fileName;
  @override
  final int fileSize;
  @override
  @JsonKey()
  final String mimeType;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'MessageAttachmentModel(id: $id, url: $url, type: $type, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageAttachmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, type, fileName,
      fileSize, mimeType, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of MessageAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageAttachmentModelImplCopyWith<_$MessageAttachmentModelImpl>
      get copyWith => __$$MessageAttachmentModelImplCopyWithImpl<
          _$MessageAttachmentModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MessageAttachmentModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MessageAttachmentModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MessageAttachmentModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageAttachmentModelImplToJson(
      this,
    );
  }
}

abstract class _MessageAttachmentModel implements MessageAttachmentModel {
  const factory _MessageAttachmentModel(
      {required final String id,
      required final String url,
      required final AttachmentType type,
      required final String fileName,
      required final int fileSize,
      final String mimeType,
      final Map<String, dynamic> metadata}) = _$MessageAttachmentModelImpl;

  factory _MessageAttachmentModel.fromJson(Map<String, dynamic> json) =
      _$MessageAttachmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  AttachmentType get type;
  @override
  String get fileName;
  @override
  int get fileSize;
  @override
  String get mimeType;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of MessageAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageAttachmentModelImplCopyWith<_$MessageAttachmentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
