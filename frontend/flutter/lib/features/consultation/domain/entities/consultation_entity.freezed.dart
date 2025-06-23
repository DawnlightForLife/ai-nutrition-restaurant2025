// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsultationEntity _$ConsultationEntityFromJson(Map<String, dynamic> json) {
  return _ConsultationEntity.fromJson(json);
}

/// @nodoc
mixin _$ConsultationEntity {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  ConsultationStatus get status => throw _privateConstructorUsedError;
  ConsultationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get scheduledStartTime => throw _privateConstructorUsedError;
  DateTime get scheduledEndTime => throw _privateConstructorUsedError;
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // in minutes
  double get price => throw _privateConstructorUsedError;
  String get meetingUrl => throw _privateConstructorUsedError;
  String get meetingId => throw _privateConstructorUsedError;
  String get meetingPassword => throw _privateConstructorUsedError;
  Map<String, dynamic> get paymentInfo => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  String get feedback => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  String? get nutritionPlanId => throw _privateConstructorUsedError;
  String? get aiRecommendationId => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ConsultationEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsultationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsultationEntityCopyWith<ConsultationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsultationEntityCopyWith<$Res> {
  factory $ConsultationEntityCopyWith(
          ConsultationEntity value, $Res Function(ConsultationEntity) then) =
      _$ConsultationEntityCopyWithImpl<$Res, ConsultationEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String nutritionistId,
      String orderNumber,
      ConsultationStatus status,
      ConsultationType type,
      String title,
      String description,
      List<String> tags,
      DateTime scheduledStartTime,
      DateTime scheduledEndTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      int duration,
      double price,
      String meetingUrl,
      String meetingId,
      String meetingPassword,
      Map<String, dynamic> paymentInfo,
      double? rating,
      String feedback,
      String summary,
      List<String> attachments,
      String? nutritionPlanId,
      String? aiRecommendationId,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ConsultationEntityCopyWithImpl<$Res, $Val extends ConsultationEntity>
    implements $ConsultationEntityCopyWith<$Res> {
  _$ConsultationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsultationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nutritionistId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? tags = null,
    Object? scheduledStartTime = null,
    Object? scheduledEndTime = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? duration = null,
    Object? price = null,
    Object? meetingUrl = null,
    Object? meetingId = null,
    Object? meetingPassword = null,
    Object? paymentInfo = null,
    Object? rating = freezed,
    Object? feedback = null,
    Object? summary = null,
    Object? attachments = null,
    Object? nutritionPlanId = freezed,
    Object? aiRecommendationId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConsultationStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConsultationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEndTime: null == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      meetingUrl: null == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      meetingPassword: null == meetingPassword
          ? _value.meetingPassword
          : meetingPassword // ignore: cast_nullable_to_non_nullable
              as String,
      paymentInfo: null == paymentInfo
          ? _value.paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionPlanId: freezed == nutritionPlanId
          ? _value.nutritionPlanId
          : nutritionPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
      aiRecommendationId: freezed == aiRecommendationId
          ? _value.aiRecommendationId
          : aiRecommendationId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ConsultationEntityImplCopyWith<$Res>
    implements $ConsultationEntityCopyWith<$Res> {
  factory _$$ConsultationEntityImplCopyWith(_$ConsultationEntityImpl value,
          $Res Function(_$ConsultationEntityImpl) then) =
      __$$ConsultationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String nutritionistId,
      String orderNumber,
      ConsultationStatus status,
      ConsultationType type,
      String title,
      String description,
      List<String> tags,
      DateTime scheduledStartTime,
      DateTime scheduledEndTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      int duration,
      double price,
      String meetingUrl,
      String meetingId,
      String meetingPassword,
      Map<String, dynamic> paymentInfo,
      double? rating,
      String feedback,
      String summary,
      List<String> attachments,
      String? nutritionPlanId,
      String? aiRecommendationId,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ConsultationEntityImplCopyWithImpl<$Res>
    extends _$ConsultationEntityCopyWithImpl<$Res, _$ConsultationEntityImpl>
    implements _$$ConsultationEntityImplCopyWith<$Res> {
  __$$ConsultationEntityImplCopyWithImpl(_$ConsultationEntityImpl _value,
      $Res Function(_$ConsultationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsultationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nutritionistId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? tags = null,
    Object? scheduledStartTime = null,
    Object? scheduledEndTime = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? duration = null,
    Object? price = null,
    Object? meetingUrl = null,
    Object? meetingId = null,
    Object? meetingPassword = null,
    Object? paymentInfo = null,
    Object? rating = freezed,
    Object? feedback = null,
    Object? summary = null,
    Object? attachments = null,
    Object? nutritionPlanId = freezed,
    Object? aiRecommendationId = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ConsultationEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConsultationStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConsultationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEndTime: null == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      meetingUrl: null == meetingUrl
          ? _value.meetingUrl
          : meetingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as String,
      meetingPassword: null == meetingPassword
          ? _value.meetingPassword
          : meetingPassword // ignore: cast_nullable_to_non_nullable
              as String,
      paymentInfo: null == paymentInfo
          ? _value._paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionPlanId: freezed == nutritionPlanId
          ? _value.nutritionPlanId
          : nutritionPlanId // ignore: cast_nullable_to_non_nullable
              as String?,
      aiRecommendationId: freezed == aiRecommendationId
          ? _value.aiRecommendationId
          : aiRecommendationId // ignore: cast_nullable_to_non_nullable
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
class _$ConsultationEntityImpl implements _ConsultationEntity {
  const _$ConsultationEntityImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.userId,
      required this.nutritionistId,
      required this.orderNumber,
      required this.status,
      required this.type,
      required this.title,
      required this.description,
      final List<String> tags = const [],
      required this.scheduledStartTime,
      required this.scheduledEndTime,
      this.actualStartTime,
      this.actualEndTime,
      required this.duration,
      required this.price,
      this.meetingUrl = '',
      this.meetingId = '',
      this.meetingPassword = '',
      final Map<String, dynamic> paymentInfo = const {},
      this.rating,
      this.feedback = '',
      this.summary = '',
      final List<String> attachments = const [],
      this.nutritionPlanId,
      this.aiRecommendationId,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      this.updatedAt})
      : _tags = tags,
        _paymentInfo = paymentInfo,
        _attachments = attachments,
        _metadata = metadata;

  factory _$ConsultationEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsultationEntityImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String nutritionistId;
  @override
  final String orderNumber;
  @override
  final ConsultationStatus status;
  @override
  final ConsultationType type;
  @override
  final String title;
  @override
  final String description;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime scheduledStartTime;
  @override
  final DateTime scheduledEndTime;
  @override
  final DateTime? actualStartTime;
  @override
  final DateTime? actualEndTime;
  @override
  final int duration;
// in minutes
  @override
  final double price;
  @override
  @JsonKey()
  final String meetingUrl;
  @override
  @JsonKey()
  final String meetingId;
  @override
  @JsonKey()
  final String meetingPassword;
  final Map<String, dynamic> _paymentInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get paymentInfo {
    if (_paymentInfo is EqualUnmodifiableMapView) return _paymentInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_paymentInfo);
  }

  @override
  final double? rating;
  @override
  @JsonKey()
  final String feedback;
  @override
  @JsonKey()
  final String summary;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? nutritionPlanId;
  @override
  final String? aiRecommendationId;
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
    return 'ConsultationEntity(id: $id, userId: $userId, nutritionistId: $nutritionistId, orderNumber: $orderNumber, status: $status, type: $type, title: $title, description: $description, tags: $tags, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, duration: $duration, price: $price, meetingUrl: $meetingUrl, meetingId: $meetingId, meetingPassword: $meetingPassword, paymentInfo: $paymentInfo, rating: $rating, feedback: $feedback, summary: $summary, attachments: $attachments, nutritionPlanId: $nutritionPlanId, aiRecommendationId: $aiRecommendationId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsultationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.scheduledEndTime, scheduledEndTime) ||
                other.scheduledEndTime == scheduledEndTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.meetingUrl, meetingUrl) ||
                other.meetingUrl == meetingUrl) &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId) &&
            (identical(other.meetingPassword, meetingPassword) ||
                other.meetingPassword == meetingPassword) &&
            const DeepCollectionEquality()
                .equals(other._paymentInfo, _paymentInfo) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.nutritionPlanId, nutritionPlanId) ||
                other.nutritionPlanId == nutritionPlanId) &&
            (identical(other.aiRecommendationId, aiRecommendationId) ||
                other.aiRecommendationId == aiRecommendationId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        nutritionistId,
        orderNumber,
        status,
        type,
        title,
        description,
        const DeepCollectionEquality().hash(_tags),
        scheduledStartTime,
        scheduledEndTime,
        actualStartTime,
        actualEndTime,
        duration,
        price,
        meetingUrl,
        meetingId,
        meetingPassword,
        const DeepCollectionEquality().hash(_paymentInfo),
        rating,
        feedback,
        summary,
        const DeepCollectionEquality().hash(_attachments),
        nutritionPlanId,
        aiRecommendationId,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ConsultationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsultationEntityImplCopyWith<_$ConsultationEntityImpl> get copyWith =>
      __$$ConsultationEntityImplCopyWithImpl<_$ConsultationEntityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsultationEntityImplToJson(
      this,
    );
  }
}

abstract class _ConsultationEntity implements ConsultationEntity {
  const factory _ConsultationEntity(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      required final String nutritionistId,
      required final String orderNumber,
      required final ConsultationStatus status,
      required final ConsultationType type,
      required final String title,
      required final String description,
      final List<String> tags,
      required final DateTime scheduledStartTime,
      required final DateTime scheduledEndTime,
      final DateTime? actualStartTime,
      final DateTime? actualEndTime,
      required final int duration,
      required final double price,
      final String meetingUrl,
      final String meetingId,
      final String meetingPassword,
      final Map<String, dynamic> paymentInfo,
      final double? rating,
      final String feedback,
      final String summary,
      final List<String> attachments,
      final String? nutritionPlanId,
      final String? aiRecommendationId,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ConsultationEntityImpl;

  factory _ConsultationEntity.fromJson(Map<String, dynamic> json) =
      _$ConsultationEntityImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get nutritionistId;
  @override
  String get orderNumber;
  @override
  ConsultationStatus get status;
  @override
  ConsultationType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get tags;
  @override
  DateTime get scheduledStartTime;
  @override
  DateTime get scheduledEndTime;
  @override
  DateTime? get actualStartTime;
  @override
  DateTime? get actualEndTime;
  @override
  int get duration; // in minutes
  @override
  double get price;
  @override
  String get meetingUrl;
  @override
  String get meetingId;
  @override
  String get meetingPassword;
  @override
  Map<String, dynamic> get paymentInfo;
  @override
  double? get rating;
  @override
  String get feedback;
  @override
  String get summary;
  @override
  List<String> get attachments;
  @override
  String? get nutritionPlanId;
  @override
  String? get aiRecommendationId;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ConsultationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsultationEntityImplCopyWith<_$ConsultationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
