// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ForumState {
  List<Uforum> get forums => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Uforum? get selectedForum => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ForumState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ForumState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ForumState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ForumState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForumStateCopyWith<ForumState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForumStateCopyWith<$Res> {
  factory $ForumStateCopyWith(
          ForumState value, $Res Function(ForumState) then) =
      _$ForumStateCopyWithImpl<$Res, ForumState>;
  @useResult
  $Res call(
      {List<Uforum> forums,
      bool isLoading,
      String? error,
      Uforum? selectedForum});
}

/// @nodoc
class _$ForumStateCopyWithImpl<$Res, $Val extends ForumState>
    implements $ForumStateCopyWith<$Res> {
  _$ForumStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForumState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forums = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedForum = freezed,
  }) {
    return _then(_value.copyWith(
      forums: null == forums
          ? _value.forums
          : forums // ignore: cast_nullable_to_non_nullable
              as List<Uforum>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedForum: freezed == selectedForum
          ? _value.selectedForum
          : selectedForum // ignore: cast_nullable_to_non_nullable
              as Uforum?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForumStateImplCopyWith<$Res>
    implements $ForumStateCopyWith<$Res> {
  factory _$$ForumStateImplCopyWith(
          _$ForumStateImpl value, $Res Function(_$ForumStateImpl) then) =
      __$$ForumStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Uforum> forums,
      bool isLoading,
      String? error,
      Uforum? selectedForum});
}

/// @nodoc
class __$$ForumStateImplCopyWithImpl<$Res>
    extends _$ForumStateCopyWithImpl<$Res, _$ForumStateImpl>
    implements _$$ForumStateImplCopyWith<$Res> {
  __$$ForumStateImplCopyWithImpl(
      _$ForumStateImpl _value, $Res Function(_$ForumStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForumState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forums = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedForum = freezed,
  }) {
    return _then(_$ForumStateImpl(
      forums: null == forums
          ? _value._forums
          : forums // ignore: cast_nullable_to_non_nullable
              as List<Uforum>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedForum: freezed == selectedForum
          ? _value.selectedForum
          : selectedForum // ignore: cast_nullable_to_non_nullable
              as Uforum?,
    ));
  }
}

/// @nodoc

class _$ForumStateImpl extends _ForumState {
  const _$ForumStateImpl(
      {final List<Uforum> forums = const [],
      this.isLoading = false,
      this.error,
      this.selectedForum})
      : _forums = forums,
        super._();

  final List<Uforum> _forums;
  @override
  @JsonKey()
  List<Uforum> get forums {
    if (_forums is EqualUnmodifiableListView) return _forums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forums);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final Uforum? selectedForum;

  @override
  String toString() {
    return 'ForumState(forums: $forums, isLoading: $isLoading, error: $error, selectedForum: $selectedForum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForumStateImpl &&
            const DeepCollectionEquality().equals(other._forums, _forums) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedForum, selectedForum) ||
                other.selectedForum == selectedForum));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_forums),
      isLoading,
      error,
      selectedForum);

  /// Create a copy of ForumState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForumStateImplCopyWith<_$ForumStateImpl> get copyWith =>
      __$$ForumStateImplCopyWithImpl<_$ForumStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ForumState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ForumState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ForumState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _ForumState extends ForumState {
  const factory _ForumState(
      {final List<Uforum> forums,
      final bool isLoading,
      final String? error,
      final Uforum? selectedForum}) = _$ForumStateImpl;
  const _ForumState._() : super._();

  @override
  List<Uforum> get forums;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Uforum? get selectedForum;

  /// Create a copy of ForumState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForumStateImplCopyWith<_$ForumStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
