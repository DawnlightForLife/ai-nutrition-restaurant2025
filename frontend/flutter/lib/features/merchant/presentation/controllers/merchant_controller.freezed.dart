// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MerchantState {
  List<Umerchant> get merchants => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Umerchant? get selectedMerchant => throw _privateConstructorUsedError;
  Map<String, List<Umerchant>> get merchantsByCategory =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of MerchantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantStateCopyWith<MerchantState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantStateCopyWith<$Res> {
  factory $MerchantStateCopyWith(
          MerchantState value, $Res Function(MerchantState) then) =
      _$MerchantStateCopyWithImpl<$Res, MerchantState>;
  @useResult
  $Res call(
      {List<Umerchant> merchants,
      bool isLoading,
      String? error,
      Umerchant? selectedMerchant,
      Map<String, List<Umerchant>> merchantsByCategory});
}

/// @nodoc
class _$MerchantStateCopyWithImpl<$Res, $Val extends MerchantState>
    implements $MerchantStateCopyWith<$Res> {
  _$MerchantStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchants = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedMerchant = freezed,
    Object? merchantsByCategory = null,
  }) {
    return _then(_value.copyWith(
      merchants: null == merchants
          ? _value.merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<Umerchant>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedMerchant: freezed == selectedMerchant
          ? _value.selectedMerchant
          : selectedMerchant // ignore: cast_nullable_to_non_nullable
              as Umerchant?,
      merchantsByCategory: null == merchantsByCategory
          ? _value.merchantsByCategory
          : merchantsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Umerchant>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantStateImplCopyWith<$Res>
    implements $MerchantStateCopyWith<$Res> {
  factory _$$MerchantStateImplCopyWith(
          _$MerchantStateImpl value, $Res Function(_$MerchantStateImpl) then) =
      __$$MerchantStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Umerchant> merchants,
      bool isLoading,
      String? error,
      Umerchant? selectedMerchant,
      Map<String, List<Umerchant>> merchantsByCategory});
}

/// @nodoc
class __$$MerchantStateImplCopyWithImpl<$Res>
    extends _$MerchantStateCopyWithImpl<$Res, _$MerchantStateImpl>
    implements _$$MerchantStateImplCopyWith<$Res> {
  __$$MerchantStateImplCopyWithImpl(
      _$MerchantStateImpl _value, $Res Function(_$MerchantStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchants = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedMerchant = freezed,
    Object? merchantsByCategory = null,
  }) {
    return _then(_$MerchantStateImpl(
      merchants: null == merchants
          ? _value._merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<Umerchant>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedMerchant: freezed == selectedMerchant
          ? _value.selectedMerchant
          : selectedMerchant // ignore: cast_nullable_to_non_nullable
              as Umerchant?,
      merchantsByCategory: null == merchantsByCategory
          ? _value._merchantsByCategory
          : merchantsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Umerchant>>,
    ));
  }
}

/// @nodoc

class _$MerchantStateImpl extends _MerchantState {
  const _$MerchantStateImpl(
      {final List<Umerchant> merchants = const [],
      this.isLoading = false,
      this.error,
      this.selectedMerchant,
      final Map<String, List<Umerchant>> merchantsByCategory = const {}})
      : _merchants = merchants,
        _merchantsByCategory = merchantsByCategory,
        super._();

  final List<Umerchant> _merchants;
  @override
  @JsonKey()
  List<Umerchant> get merchants {
    if (_merchants is EqualUnmodifiableListView) return _merchants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_merchants);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final Umerchant? selectedMerchant;
  final Map<String, List<Umerchant>> _merchantsByCategory;
  @override
  @JsonKey()
  Map<String, List<Umerchant>> get merchantsByCategory {
    if (_merchantsByCategory is EqualUnmodifiableMapView)
      return _merchantsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantsByCategory);
  }

  @override
  String toString() {
    return 'MerchantState(merchants: $merchants, isLoading: $isLoading, error: $error, selectedMerchant: $selectedMerchant, merchantsByCategory: $merchantsByCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantStateImpl &&
            const DeepCollectionEquality()
                .equals(other._merchants, _merchants) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedMerchant, selectedMerchant) ||
                other.selectedMerchant == selectedMerchant) &&
            const DeepCollectionEquality()
                .equals(other._merchantsByCategory, _merchantsByCategory));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_merchants),
      isLoading,
      error,
      selectedMerchant,
      const DeepCollectionEquality().hash(_merchantsByCategory));

  /// Create a copy of MerchantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantStateImplCopyWith<_$MerchantStateImpl> get copyWith =>
      __$$MerchantStateImplCopyWithImpl<_$MerchantStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _MerchantState extends MerchantState {
  const factory _MerchantState(
          {final List<Umerchant> merchants,
          final bool isLoading,
          final String? error,
          final Umerchant? selectedMerchant,
          final Map<String, List<Umerchant>> merchantsByCategory}) =
      _$MerchantStateImpl;
  const _MerchantState._() : super._();

  @override
  List<Umerchant> get merchants;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Umerchant? get selectedMerchant;
  @override
  Map<String, List<Umerchant>> get merchantsByCategory;

  /// Create a copy of MerchantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantStateImplCopyWith<_$MerchantStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
