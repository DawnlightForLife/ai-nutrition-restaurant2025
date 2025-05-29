// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminState {
  List<Uadmin> get admins => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Uadmin? get selectedAdmin => throw _privateConstructorUsedError;
  Map<String, List<Uadmin>> get adminsByRole =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get systemStats => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AdminState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AdminState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AdminState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AdminState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminStateCopyWith<AdminState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStateCopyWith<$Res> {
  factory $AdminStateCopyWith(
          AdminState value, $Res Function(AdminState) then) =
      _$AdminStateCopyWithImpl<$Res, AdminState>;
  @useResult
  $Res call(
      {List<Uadmin> admins,
      bool isLoading,
      String? error,
      Uadmin? selectedAdmin,
      Map<String, List<Uadmin>> adminsByRole,
      Map<String, dynamic> systemStats});
}

/// @nodoc
class _$AdminStateCopyWithImpl<$Res, $Val extends AdminState>
    implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? admins = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedAdmin = freezed,
    Object? adminsByRole = null,
    Object? systemStats = null,
  }) {
    return _then(_value.copyWith(
      admins: null == admins
          ? _value.admins
          : admins // ignore: cast_nullable_to_non_nullable
              as List<Uadmin>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedAdmin: freezed == selectedAdmin
          ? _value.selectedAdmin
          : selectedAdmin // ignore: cast_nullable_to_non_nullable
              as Uadmin?,
      adminsByRole: null == adminsByRole
          ? _value.adminsByRole
          : adminsByRole // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Uadmin>>,
      systemStats: null == systemStats
          ? _value.systemStats
          : systemStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminStateImplCopyWith<$Res>
    implements $AdminStateCopyWith<$Res> {
  factory _$$AdminStateImplCopyWith(
          _$AdminStateImpl value, $Res Function(_$AdminStateImpl) then) =
      __$$AdminStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Uadmin> admins,
      bool isLoading,
      String? error,
      Uadmin? selectedAdmin,
      Map<String, List<Uadmin>> adminsByRole,
      Map<String, dynamic> systemStats});
}

/// @nodoc
class __$$AdminStateImplCopyWithImpl<$Res>
    extends _$AdminStateCopyWithImpl<$Res, _$AdminStateImpl>
    implements _$$AdminStateImplCopyWith<$Res> {
  __$$AdminStateImplCopyWithImpl(
      _$AdminStateImpl _value, $Res Function(_$AdminStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdminState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? admins = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedAdmin = freezed,
    Object? adminsByRole = null,
    Object? systemStats = null,
  }) {
    return _then(_$AdminStateImpl(
      admins: null == admins
          ? _value._admins
          : admins // ignore: cast_nullable_to_non_nullable
              as List<Uadmin>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedAdmin: freezed == selectedAdmin
          ? _value.selectedAdmin
          : selectedAdmin // ignore: cast_nullable_to_non_nullable
              as Uadmin?,
      adminsByRole: null == adminsByRole
          ? _value._adminsByRole
          : adminsByRole // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Uadmin>>,
      systemStats: null == systemStats
          ? _value._systemStats
          : systemStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$AdminStateImpl extends _AdminState {
  const _$AdminStateImpl(
      {final List<Uadmin> admins = const [],
      this.isLoading = false,
      this.error,
      this.selectedAdmin,
      final Map<String, List<Uadmin>> adminsByRole = const {},
      final Map<String, dynamic> systemStats = const {}})
      : _admins = admins,
        _adminsByRole = adminsByRole,
        _systemStats = systemStats,
        super._();

  final List<Uadmin> _admins;
  @override
  @JsonKey()
  List<Uadmin> get admins {
    if (_admins is EqualUnmodifiableListView) return _admins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_admins);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final Uadmin? selectedAdmin;
  final Map<String, List<Uadmin>> _adminsByRole;
  @override
  @JsonKey()
  Map<String, List<Uadmin>> get adminsByRole {
    if (_adminsByRole is EqualUnmodifiableMapView) return _adminsByRole;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_adminsByRole);
  }

  final Map<String, dynamic> _systemStats;
  @override
  @JsonKey()
  Map<String, dynamic> get systemStats {
    if (_systemStats is EqualUnmodifiableMapView) return _systemStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_systemStats);
  }

  @override
  String toString() {
    return 'AdminState(admins: $admins, isLoading: $isLoading, error: $error, selectedAdmin: $selectedAdmin, adminsByRole: $adminsByRole, systemStats: $systemStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminStateImpl &&
            const DeepCollectionEquality().equals(other._admins, _admins) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedAdmin, selectedAdmin) ||
                other.selectedAdmin == selectedAdmin) &&
            const DeepCollectionEquality()
                .equals(other._adminsByRole, _adminsByRole) &&
            const DeepCollectionEquality()
                .equals(other._systemStats, _systemStats));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_admins),
      isLoading,
      error,
      selectedAdmin,
      const DeepCollectionEquality().hash(_adminsByRole),
      const DeepCollectionEquality().hash(_systemStats));

  /// Create a copy of AdminState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminStateImplCopyWith<_$AdminStateImpl> get copyWith =>
      __$$AdminStateImplCopyWithImpl<_$AdminStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AdminState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AdminState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AdminState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _AdminState extends AdminState {
  const factory _AdminState(
      {final List<Uadmin> admins,
      final bool isLoading,
      final String? error,
      final Uadmin? selectedAdmin,
      final Map<String, List<Uadmin>> adminsByRole,
      final Map<String, dynamic> systemStats}) = _$AdminStateImpl;
  const _AdminState._() : super._();

  @override
  List<Uadmin> get admins;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Uadmin? get selectedAdmin;
  @override
  Map<String, List<Uadmin>> get adminsByRole;
  @override
  Map<String, dynamic> get systemStats;

  /// Create a copy of AdminState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminStateImplCopyWith<_$AdminStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
