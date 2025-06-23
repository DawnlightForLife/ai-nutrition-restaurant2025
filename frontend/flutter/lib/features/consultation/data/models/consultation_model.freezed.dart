// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsultationModel _$ConsultationModelFromJson(Map<String, dynamic> json) {
  return _ConsultationModel.fromJson(json);
}

/// @nodoc
mixin _$ConsultationModel {
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
  int get duration => throw _privateConstructorUsedError;
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
    TResult Function(_ConsultationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ConsultationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsultationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsultationModelCopyWith<ConsultationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsultationModelCopyWith<$Res> {
  factory $ConsultationModelCopyWith(
          ConsultationModel value, $Res Function(ConsultationModel) then) =
      _$ConsultationModelCopyWithImpl<$Res, ConsultationModel>;
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
class _$ConsultationModelCopyWithImpl<$Res, $Val extends ConsultationModel>
    implements $ConsultationModelCopyWith<$Res> {
  _$ConsultationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsultationModel
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
abstract class _$$ConsultationModelImplCopyWith<$Res>
    implements $ConsultationModelCopyWith<$Res> {
  factory _$$ConsultationModelImplCopyWith(_$ConsultationModelImpl value,
          $Res Function(_$ConsultationModelImpl) then) =
      __$$ConsultationModelImplCopyWithImpl<$Res>;
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
class __$$ConsultationModelImplCopyWithImpl<$Res>
    extends _$ConsultationModelCopyWithImpl<$Res, _$ConsultationModelImpl>
    implements _$$ConsultationModelImplCopyWith<$Res> {
  __$$ConsultationModelImplCopyWithImpl(_$ConsultationModelImpl _value,
      $Res Function(_$ConsultationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsultationModel
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
    return _then(_$ConsultationModelImpl(
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
class _$ConsultationModelImpl extends _ConsultationModel {
  const _$ConsultationModelImpl(
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
        _metadata = metadata,
        super._();

  factory _$ConsultationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsultationModelImplFromJson(json);

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
    return 'ConsultationModel(id: $id, userId: $userId, nutritionistId: $nutritionistId, orderNumber: $orderNumber, status: $status, type: $type, title: $title, description: $description, tags: $tags, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, duration: $duration, price: $price, meetingUrl: $meetingUrl, meetingId: $meetingId, meetingPassword: $meetingPassword, paymentInfo: $paymentInfo, rating: $rating, feedback: $feedback, summary: $summary, attachments: $attachments, nutritionPlanId: $nutritionPlanId, aiRecommendationId: $aiRecommendationId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsultationModelImpl &&
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

  /// Create a copy of ConsultationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsultationModelImplCopyWith<_$ConsultationModelImpl> get copyWith =>
      __$$ConsultationModelImplCopyWithImpl<_$ConsultationModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsultationModelImplToJson(
      this,
    );
  }
}

abstract class _ConsultationModel extends ConsultationModel {
  const factory _ConsultationModel(
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
      final DateTime? updatedAt}) = _$ConsultationModelImpl;
  const _ConsultationModel._() : super._();

  factory _ConsultationModel.fromJson(Map<String, dynamic> json) =
      _$ConsultationModelImpl.fromJson;

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
  int get duration;
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

  /// Create a copy of ConsultationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsultationModelImplCopyWith<_$ConsultationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateConsultationRequest _$CreateConsultationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateConsultationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateConsultationRequest {
  String get userId => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  ConsultationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get scheduledStartTime => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreateConsultationRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreateConsultationRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreateConsultationRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateConsultationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConsultationRequestCopyWith<CreateConsultationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConsultationRequestCopyWith<$Res> {
  factory $CreateConsultationRequestCopyWith(CreateConsultationRequest value,
          $Res Function(CreateConsultationRequest) then) =
      _$CreateConsultationRequestCopyWithImpl<$Res, CreateConsultationRequest>;
  @useResult
  $Res call(
      {String userId,
      String nutritionistId,
      ConsultationType type,
      String title,
      String description,
      DateTime scheduledStartTime,
      int duration,
      double price,
      List<String> tags});
}

/// @nodoc
class _$CreateConsultationRequestCopyWithImpl<$Res,
        $Val extends CreateConsultationRequest>
    implements $CreateConsultationRequestCopyWith<$Res> {
  _$CreateConsultationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nutritionistId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? scheduledStartTime = null,
    Object? duration = null,
    Object? price = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
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
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateConsultationRequestImplCopyWith<$Res>
    implements $CreateConsultationRequestCopyWith<$Res> {
  factory _$$CreateConsultationRequestImplCopyWith(
          _$CreateConsultationRequestImpl value,
          $Res Function(_$CreateConsultationRequestImpl) then) =
      __$$CreateConsultationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String nutritionistId,
      ConsultationType type,
      String title,
      String description,
      DateTime scheduledStartTime,
      int duration,
      double price,
      List<String> tags});
}

/// @nodoc
class __$$CreateConsultationRequestImplCopyWithImpl<$Res>
    extends _$CreateConsultationRequestCopyWithImpl<$Res,
        _$CreateConsultationRequestImpl>
    implements _$$CreateConsultationRequestImplCopyWith<$Res> {
  __$$CreateConsultationRequestImplCopyWithImpl(
      _$CreateConsultationRequestImpl _value,
      $Res Function(_$CreateConsultationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nutritionistId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? scheduledStartTime = null,
    Object? duration = null,
    Object? price = null,
    Object? tags = null,
  }) {
    return _then(_$CreateConsultationRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
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
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConsultationRequestImpl implements _CreateConsultationRequest {
  const _$CreateConsultationRequestImpl(
      {required this.userId,
      required this.nutritionistId,
      required this.type,
      required this.title,
      required this.description,
      required this.scheduledStartTime,
      required this.duration,
      required this.price,
      final List<String> tags = const []})
      : _tags = tags;

  factory _$CreateConsultationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateConsultationRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final String nutritionistId;
  @override
  final ConsultationType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime scheduledStartTime;
  @override
  final int duration;
  @override
  final double price;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'CreateConsultationRequest(userId: $userId, nutritionistId: $nutritionistId, type: $type, title: $title, description: $description, scheduledStartTime: $scheduledStartTime, duration: $duration, price: $price, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConsultationRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      nutritionistId,
      type,
      title,
      description,
      scheduledStartTime,
      duration,
      price,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of CreateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConsultationRequestImplCopyWith<_$CreateConsultationRequestImpl>
      get copyWith => __$$CreateConsultationRequestImplCopyWithImpl<
          _$CreateConsultationRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreateConsultationRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreateConsultationRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreateConsultationRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConsultationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateConsultationRequest implements CreateConsultationRequest {
  const factory _CreateConsultationRequest(
      {required final String userId,
      required final String nutritionistId,
      required final ConsultationType type,
      required final String title,
      required final String description,
      required final DateTime scheduledStartTime,
      required final int duration,
      required final double price,
      final List<String> tags}) = _$CreateConsultationRequestImpl;

  factory _CreateConsultationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateConsultationRequestImpl.fromJson;

  @override
  String get userId;
  @override
  String get nutritionistId;
  @override
  ConsultationType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get scheduledStartTime;
  @override
  int get duration;
  @override
  double get price;
  @override
  List<String> get tags;

  /// Create a copy of CreateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConsultationRequestImplCopyWith<_$CreateConsultationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateConsultationRequest _$UpdateConsultationRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateConsultationRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateConsultationRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ConsultationStatus? get status => throw _privateConstructorUsedError;
  DateTime? get scheduledStartTime => throw _privateConstructorUsedError;
  DateTime? get scheduledEndTime => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateConsultationRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UpdateConsultationRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateConsultationRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UpdateConsultationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConsultationRequestCopyWith<UpdateConsultationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConsultationRequestCopyWith<$Res> {
  factory $UpdateConsultationRequestCopyWith(UpdateConsultationRequest value,
          $Res Function(UpdateConsultationRequest) then) =
      _$UpdateConsultationRequestCopyWithImpl<$Res, UpdateConsultationRequest>;
  @useResult
  $Res call(
      {String? title,
      String? description,
      ConsultationStatus? status,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      String? summary,
      double? rating,
      String? feedback,
      List<String>? tags,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UpdateConsultationRequestCopyWithImpl<$Res,
        $Val extends UpdateConsultationRequest>
    implements $UpdateConsultationRequestCopyWith<$Res> {
  _$UpdateConsultationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? summary = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
    Object? tags = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConsultationStatus?,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateConsultationRequestImplCopyWith<$Res>
    implements $UpdateConsultationRequestCopyWith<$Res> {
  factory _$$UpdateConsultationRequestImplCopyWith(
          _$UpdateConsultationRequestImpl value,
          $Res Function(_$UpdateConsultationRequestImpl) then) =
      __$$UpdateConsultationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      ConsultationStatus? status,
      DateTime? scheduledStartTime,
      DateTime? scheduledEndTime,
      String? summary,
      double? rating,
      String? feedback,
      List<String>? tags,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UpdateConsultationRequestImplCopyWithImpl<$Res>
    extends _$UpdateConsultationRequestCopyWithImpl<$Res,
        _$UpdateConsultationRequestImpl>
    implements _$$UpdateConsultationRequestImplCopyWith<$Res> {
  __$$UpdateConsultationRequestImplCopyWithImpl(
      _$UpdateConsultationRequestImpl _value,
      $Res Function(_$UpdateConsultationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? scheduledStartTime = freezed,
    Object? scheduledEndTime = freezed,
    Object? summary = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
    Object? tags = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UpdateConsultationRequestImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConsultationStatus?,
      scheduledStartTime: freezed == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTime: freezed == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateConsultationRequestImpl implements _UpdateConsultationRequest {
  const _$UpdateConsultationRequestImpl(
      {this.title,
      this.description,
      this.status,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.summary,
      this.rating,
      this.feedback,
      final List<String>? tags,
      final Map<String, dynamic>? metadata})
      : _tags = tags,
        _metadata = metadata;

  factory _$UpdateConsultationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateConsultationRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final ConsultationStatus? status;
  @override
  final DateTime? scheduledStartTime;
  @override
  final DateTime? scheduledEndTime;
  @override
  final String? summary;
  @override
  final double? rating;
  @override
  final String? feedback;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UpdateConsultationRequest(title: $title, description: $description, status: $status, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, summary: $summary, rating: $rating, feedback: $feedback, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConsultationRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.scheduledEndTime, scheduledEndTime) ||
                other.scheduledEndTime == scheduledEndTime) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      status,
      scheduledStartTime,
      scheduledEndTime,
      summary,
      rating,
      feedback,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UpdateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConsultationRequestImplCopyWith<_$UpdateConsultationRequestImpl>
      get copyWith => __$$UpdateConsultationRequestImplCopyWithImpl<
          _$UpdateConsultationRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpdateConsultationRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UpdateConsultationRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpdateConsultationRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateConsultationRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateConsultationRequest implements UpdateConsultationRequest {
  const factory _UpdateConsultationRequest(
      {final String? title,
      final String? description,
      final ConsultationStatus? status,
      final DateTime? scheduledStartTime,
      final DateTime? scheduledEndTime,
      final String? summary,
      final double? rating,
      final String? feedback,
      final List<String>? tags,
      final Map<String, dynamic>? metadata}) = _$UpdateConsultationRequestImpl;

  factory _UpdateConsultationRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateConsultationRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  ConsultationStatus? get status;
  @override
  DateTime? get scheduledStartTime;
  @override
  DateTime? get scheduledEndTime;
  @override
  String? get summary;
  @override
  double? get rating;
  @override
  String? get feedback;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of UpdateConsultationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConsultationRequestImplCopyWith<_$UpdateConsultationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
