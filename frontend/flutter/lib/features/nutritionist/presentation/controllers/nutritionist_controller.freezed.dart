// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionistState {
  List<Unutritionist> get nutritionists => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Unutritionist? get selectedNutritionist => throw _privateConstructorUsedError;
  Map<String, List<Unutritionist>> get nutritionistsBySpecialty =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistStateCopyWith<NutritionistState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistStateCopyWith<$Res> {
  factory $NutritionistStateCopyWith(
          NutritionistState value, $Res Function(NutritionistState) then) =
      _$NutritionistStateCopyWithImpl<$Res, NutritionistState>;
  @useResult
  $Res call(
      {List<Unutritionist> nutritionists,
      bool isLoading,
      String? error,
      Unutritionist? selectedNutritionist,
      Map<String, List<Unutritionist>> nutritionistsBySpecialty});
}

/// @nodoc
class _$NutritionistStateCopyWithImpl<$Res, $Val extends NutritionistState>
    implements $NutritionistStateCopyWith<$Res> {
  _$NutritionistStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedNutritionist = freezed,
    Object? nutritionistsBySpecialty = null,
  }) {
    return _then(_value.copyWith(
      nutritionists: null == nutritionists
          ? _value.nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<Unutritionist>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedNutritionist: freezed == selectedNutritionist
          ? _value.selectedNutritionist
          : selectedNutritionist // ignore: cast_nullable_to_non_nullable
              as Unutritionist?,
      nutritionistsBySpecialty: null == nutritionistsBySpecialty
          ? _value.nutritionistsBySpecialty
          : nutritionistsBySpecialty // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Unutritionist>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistStateImplCopyWith<$Res>
    implements $NutritionistStateCopyWith<$Res> {
  factory _$$NutritionistStateImplCopyWith(_$NutritionistStateImpl value,
          $Res Function(_$NutritionistStateImpl) then) =
      __$$NutritionistStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Unutritionist> nutritionists,
      bool isLoading,
      String? error,
      Unutritionist? selectedNutritionist,
      Map<String, List<Unutritionist>> nutritionistsBySpecialty});
}

/// @nodoc
class __$$NutritionistStateImplCopyWithImpl<$Res>
    extends _$NutritionistStateCopyWithImpl<$Res, _$NutritionistStateImpl>
    implements _$$NutritionistStateImplCopyWith<$Res> {
  __$$NutritionistStateImplCopyWithImpl(_$NutritionistStateImpl _value,
      $Res Function(_$NutritionistStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedNutritionist = freezed,
    Object? nutritionistsBySpecialty = null,
  }) {
    return _then(_$NutritionistStateImpl(
      nutritionists: null == nutritionists
          ? _value._nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<Unutritionist>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedNutritionist: freezed == selectedNutritionist
          ? _value.selectedNutritionist
          : selectedNutritionist // ignore: cast_nullable_to_non_nullable
              as Unutritionist?,
      nutritionistsBySpecialty: null == nutritionistsBySpecialty
          ? _value._nutritionistsBySpecialty
          : nutritionistsBySpecialty // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Unutritionist>>,
    ));
  }
}

/// @nodoc

class _$NutritionistStateImpl extends _NutritionistState {
  const _$NutritionistStateImpl(
      {final List<Unutritionist> nutritionists = const [],
      this.isLoading = false,
      this.error,
      this.selectedNutritionist,
      final Map<String, List<Unutritionist>> nutritionistsBySpecialty =
          const {}})
      : _nutritionists = nutritionists,
        _nutritionistsBySpecialty = nutritionistsBySpecialty,
        super._();

  final List<Unutritionist> _nutritionists;
  @override
  @JsonKey()
  List<Unutritionist> get nutritionists {
    if (_nutritionists is EqualUnmodifiableListView) return _nutritionists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionists);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final Unutritionist? selectedNutritionist;
  final Map<String, List<Unutritionist>> _nutritionistsBySpecialty;
  @override
  @JsonKey()
  Map<String, List<Unutritionist>> get nutritionistsBySpecialty {
    if (_nutritionistsBySpecialty is EqualUnmodifiableMapView)
      return _nutritionistsBySpecialty;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionistsBySpecialty);
  }

  @override
  String toString() {
    return 'NutritionistState(nutritionists: $nutritionists, isLoading: $isLoading, error: $error, selectedNutritionist: $selectedNutritionist, nutritionistsBySpecialty: $nutritionistsBySpecialty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistStateImpl &&
            const DeepCollectionEquality()
                .equals(other._nutritionists, _nutritionists) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedNutritionist, selectedNutritionist) ||
                other.selectedNutritionist == selectedNutritionist) &&
            const DeepCollectionEquality().equals(
                other._nutritionistsBySpecialty, _nutritionistsBySpecialty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nutritionists),
      isLoading,
      error,
      selectedNutritionist,
      const DeepCollectionEquality().hash(_nutritionistsBySpecialty));

  /// Create a copy of NutritionistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistStateImplCopyWith<_$NutritionistStateImpl> get copyWith =>
      __$$NutritionistStateImplCopyWithImpl<_$NutritionistStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionistState extends NutritionistState {
  const factory _NutritionistState(
          {final List<Unutritionist> nutritionists,
          final bool isLoading,
          final String? error,
          final Unutritionist? selectedNutritionist,
          final Map<String, List<Unutritionist>> nutritionistsBySpecialty}) =
      _$NutritionistStateImpl;
  const _NutritionistState._() : super._();

  @override
  List<Unutritionist> get nutritionists;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Unutritionist? get selectedNutritionist;
  @override
  Map<String, List<Unutritionist>> get nutritionistsBySpecialty;

  /// Create a copy of NutritionistState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistStateImplCopyWith<_$NutritionistStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
