// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workbench_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  OverallStats get overall => throw _privateConstructorUsedError;
  TodayStats get today => throw _privateConstructorUsedError;
  Map<String, dynamic> get recentTrends => throw _privateConstructorUsedError;
  List<UpcomingConsultation> get upcomingConsultations =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DashboardStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DashboardStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DashboardStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
          DashboardStats value, $Res Function(DashboardStats) then) =
      _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call(
      {OverallStats overall,
      TodayStats today,
      Map<String, dynamic> recentTrends,
      List<UpcomingConsultation> upcomingConsultations});

  $OverallStatsCopyWith<$Res> get overall;
  $TodayStatsCopyWith<$Res> get today;
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overall = null,
    Object? today = null,
    Object? recentTrends = null,
    Object? upcomingConsultations = null,
  }) {
    return _then(_value.copyWith(
      overall: null == overall
          ? _value.overall
          : overall // ignore: cast_nullable_to_non_nullable
              as OverallStats,
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as TodayStats,
      recentTrends: null == recentTrends
          ? _value.recentTrends
          : recentTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      upcomingConsultations: null == upcomingConsultations
          ? _value.upcomingConsultations
          : upcomingConsultations // ignore: cast_nullable_to_non_nullable
              as List<UpcomingConsultation>,
    ) as $Val);
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverallStatsCopyWith<$Res> get overall {
    return $OverallStatsCopyWith<$Res>(_value.overall, (value) {
      return _then(_value.copyWith(overall: value) as $Val);
    });
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TodayStatsCopyWith<$Res> get today {
    return $TodayStatsCopyWith<$Res>(_value.today, (value) {
      return _then(_value.copyWith(today: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(_$DashboardStatsImpl value,
          $Res Function(_$DashboardStatsImpl) then) =
      __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OverallStats overall,
      TodayStats today,
      Map<String, dynamic> recentTrends,
      List<UpcomingConsultation> upcomingConsultations});

  @override
  $OverallStatsCopyWith<$Res> get overall;
  @override
  $TodayStatsCopyWith<$Res> get today;
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
      _$DashboardStatsImpl _value, $Res Function(_$DashboardStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overall = null,
    Object? today = null,
    Object? recentTrends = null,
    Object? upcomingConsultations = null,
  }) {
    return _then(_$DashboardStatsImpl(
      overall: null == overall
          ? _value.overall
          : overall // ignore: cast_nullable_to_non_nullable
              as OverallStats,
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as TodayStats,
      recentTrends: null == recentTrends
          ? _value._recentTrends
          : recentTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      upcomingConsultations: null == upcomingConsultations
          ? _value._upcomingConsultations
          : upcomingConsultations // ignore: cast_nullable_to_non_nullable
              as List<UpcomingConsultation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl(
      {required this.overall,
      required this.today,
      final Map<String, dynamic> recentTrends = const {},
      final List<UpcomingConsultation> upcomingConsultations = const []})
      : _recentTrends = recentTrends,
        _upcomingConsultations = upcomingConsultations;

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  final OverallStats overall;
  @override
  final TodayStats today;
  final Map<String, dynamic> _recentTrends;
  @override
  @JsonKey()
  Map<String, dynamic> get recentTrends {
    if (_recentTrends is EqualUnmodifiableMapView) return _recentTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_recentTrends);
  }

  final List<UpcomingConsultation> _upcomingConsultations;
  @override
  @JsonKey()
  List<UpcomingConsultation> get upcomingConsultations {
    if (_upcomingConsultations is EqualUnmodifiableListView)
      return _upcomingConsultations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingConsultations);
  }

  @override
  String toString() {
    return 'DashboardStats(overall: $overall, today: $today, recentTrends: $recentTrends, upcomingConsultations: $upcomingConsultations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.overall, overall) || other.overall == overall) &&
            (identical(other.today, today) || other.today == today) &&
            const DeepCollectionEquality()
                .equals(other._recentTrends, _recentTrends) &&
            const DeepCollectionEquality()
                .equals(other._upcomingConsultations, _upcomingConsultations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      overall,
      today,
      const DeepCollectionEquality().hash(_recentTrends),
      const DeepCollectionEquality().hash(_upcomingConsultations));

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DashboardStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DashboardStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DashboardStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(
      this,
    );
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats(
          {required final OverallStats overall,
          required final TodayStats today,
          final Map<String, dynamic> recentTrends,
          final List<UpcomingConsultation> upcomingConsultations}) =
      _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  OverallStats get overall;
  @override
  TodayStats get today;
  @override
  Map<String, dynamic> get recentTrends;
  @override
  List<UpcomingConsultation> get upcomingConsultations;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverallStats _$OverallStatsFromJson(Map<String, dynamic> json) {
  return _OverallStats.fromJson(json);
}

/// @nodoc
mixin _$OverallStats {
  int get totalConsultations => throw _privateConstructorUsedError;
  int get totalClients => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OverallStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OverallStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OverallStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OverallStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverallStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverallStatsCopyWith<OverallStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverallStatsCopyWith<$Res> {
  factory $OverallStatsCopyWith(
          OverallStats value, $Res Function(OverallStats) then) =
      _$OverallStatsCopyWithImpl<$Res, OverallStats>;
  @useResult
  $Res call(
      {int totalConsultations,
      int totalClients,
      double averageRating,
      double totalRevenue});
}

/// @nodoc
class _$OverallStatsCopyWithImpl<$Res, $Val extends OverallStats>
    implements $OverallStatsCopyWith<$Res> {
  _$OverallStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverallStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? totalClients = null,
    Object? averageRating = null,
    Object? totalRevenue = null,
  }) {
    return _then(_value.copyWith(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      totalClients: null == totalClients
          ? _value.totalClients
          : totalClients // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverallStatsImplCopyWith<$Res>
    implements $OverallStatsCopyWith<$Res> {
  factory _$$OverallStatsImplCopyWith(
          _$OverallStatsImpl value, $Res Function(_$OverallStatsImpl) then) =
      __$$OverallStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalConsultations,
      int totalClients,
      double averageRating,
      double totalRevenue});
}

/// @nodoc
class __$$OverallStatsImplCopyWithImpl<$Res>
    extends _$OverallStatsCopyWithImpl<$Res, _$OverallStatsImpl>
    implements _$$OverallStatsImplCopyWith<$Res> {
  __$$OverallStatsImplCopyWithImpl(
      _$OverallStatsImpl _value, $Res Function(_$OverallStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverallStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? totalClients = null,
    Object? averageRating = null,
    Object? totalRevenue = null,
  }) {
    return _then(_$OverallStatsImpl(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      totalClients: null == totalClients
          ? _value.totalClients
          : totalClients // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverallStatsImpl implements _OverallStats {
  const _$OverallStatsImpl(
      {this.totalConsultations = 0,
      this.totalClients = 0,
      this.averageRating = 0.0,
      this.totalRevenue = 0.0});

  factory _$OverallStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverallStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalConsultations;
  @override
  @JsonKey()
  final int totalClients;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final double totalRevenue;

  @override
  String toString() {
    return 'OverallStats(totalConsultations: $totalConsultations, totalClients: $totalClients, averageRating: $averageRating, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverallStatsImpl &&
            (identical(other.totalConsultations, totalConsultations) ||
                other.totalConsultations == totalConsultations) &&
            (identical(other.totalClients, totalClients) ||
                other.totalClients == totalClients) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalConsultations, totalClients,
      averageRating, totalRevenue);

  /// Create a copy of OverallStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverallStatsImplCopyWith<_$OverallStatsImpl> get copyWith =>
      __$$OverallStatsImplCopyWithImpl<_$OverallStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OverallStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OverallStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OverallStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OverallStatsImplToJson(
      this,
    );
  }
}

abstract class _OverallStats implements OverallStats {
  const factory _OverallStats(
      {final int totalConsultations,
      final int totalClients,
      final double averageRating,
      final double totalRevenue}) = _$OverallStatsImpl;

  factory _OverallStats.fromJson(Map<String, dynamic> json) =
      _$OverallStatsImpl.fromJson;

  @override
  int get totalConsultations;
  @override
  int get totalClients;
  @override
  double get averageRating;
  @override
  double get totalRevenue;

  /// Create a copy of OverallStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverallStatsImplCopyWith<_$OverallStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TodayStats _$TodayStatsFromJson(Map<String, dynamic> json) {
  return _TodayStats.fromJson(json);
}

/// @nodoc
mixin _$TodayStats {
  int get consultations => throw _privateConstructorUsedError;
  int get completedConsultations => throw _privateConstructorUsedError;
  int get newClients => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TodayStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TodayStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TodayStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TodayStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodayStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodayStatsCopyWith<TodayStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayStatsCopyWith<$Res> {
  factory $TodayStatsCopyWith(
          TodayStats value, $Res Function(TodayStats) then) =
      _$TodayStatsCopyWithImpl<$Res, TodayStats>;
  @useResult
  $Res call(
      {int consultations,
      int completedConsultations,
      int newClients,
      double totalIncome});
}

/// @nodoc
class _$TodayStatsCopyWithImpl<$Res, $Val extends TodayStats>
    implements $TodayStatsCopyWith<$Res> {
  _$TodayStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodayStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultations = null,
    Object? completedConsultations = null,
    Object? newClients = null,
    Object? totalIncome = null,
  }) {
    return _then(_value.copyWith(
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      newClients: null == newClients
          ? _value.newClients
          : newClients // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodayStatsImplCopyWith<$Res>
    implements $TodayStatsCopyWith<$Res> {
  factory _$$TodayStatsImplCopyWith(
          _$TodayStatsImpl value, $Res Function(_$TodayStatsImpl) then) =
      __$$TodayStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int consultations,
      int completedConsultations,
      int newClients,
      double totalIncome});
}

/// @nodoc
class __$$TodayStatsImplCopyWithImpl<$Res>
    extends _$TodayStatsCopyWithImpl<$Res, _$TodayStatsImpl>
    implements _$$TodayStatsImplCopyWith<$Res> {
  __$$TodayStatsImplCopyWithImpl(
      _$TodayStatsImpl _value, $Res Function(_$TodayStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodayStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultations = null,
    Object? completedConsultations = null,
    Object? newClients = null,
    Object? totalIncome = null,
  }) {
    return _then(_$TodayStatsImpl(
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      newClients: null == newClients
          ? _value.newClients
          : newClients // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodayStatsImpl implements _TodayStats {
  const _$TodayStatsImpl(
      {this.consultations = 0,
      this.completedConsultations = 0,
      this.newClients = 0,
      this.totalIncome = 0.0});

  factory _$TodayStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodayStatsImplFromJson(json);

  @override
  @JsonKey()
  final int consultations;
  @override
  @JsonKey()
  final int completedConsultations;
  @override
  @JsonKey()
  final int newClients;
  @override
  @JsonKey()
  final double totalIncome;

  @override
  String toString() {
    return 'TodayStats(consultations: $consultations, completedConsultations: $completedConsultations, newClients: $newClients, totalIncome: $totalIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayStatsImpl &&
            (identical(other.consultations, consultations) ||
                other.consultations == consultations) &&
            (identical(other.completedConsultations, completedConsultations) ||
                other.completedConsultations == completedConsultations) &&
            (identical(other.newClients, newClients) ||
                other.newClients == newClients) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, consultations,
      completedConsultations, newClients, totalIncome);

  /// Create a copy of TodayStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayStatsImplCopyWith<_$TodayStatsImpl> get copyWith =>
      __$$TodayStatsImplCopyWithImpl<_$TodayStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TodayStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TodayStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TodayStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TodayStatsImplToJson(
      this,
    );
  }
}

abstract class _TodayStats implements TodayStats {
  const factory _TodayStats(
      {final int consultations,
      final int completedConsultations,
      final int newClients,
      final double totalIncome}) = _$TodayStatsImpl;

  factory _TodayStats.fromJson(Map<String, dynamic> json) =
      _$TodayStatsImpl.fromJson;

  @override
  int get consultations;
  @override
  int get completedConsultations;
  @override
  int get newClients;
  @override
  double get totalIncome;

  /// Create a copy of TodayStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodayStatsImplCopyWith<_$TodayStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpcomingConsultation _$UpcomingConsultationFromJson(Map<String, dynamic> json) {
  return _UpcomingConsultation.fromJson(json);
}

/// @nodoc
mixin _$UpcomingConsultation {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  DateTime? get appointmentTime => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpcomingConsultation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UpcomingConsultation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpcomingConsultation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UpcomingConsultation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpcomingConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpcomingConsultationCopyWith<UpcomingConsultation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpcomingConsultationCopyWith<$Res> {
  factory $UpcomingConsultationCopyWith(UpcomingConsultation value,
          $Res Function(UpcomingConsultation) then) =
      _$UpcomingConsultationCopyWithImpl<$Res, UpcomingConsultation>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? username,
      DateTime? appointmentTime,
      String? status,
      String? topic});
}

/// @nodoc
class _$UpcomingConsultationCopyWithImpl<$Res,
        $Val extends UpcomingConsultation>
    implements $UpcomingConsultationCopyWith<$Res> {
  _$UpcomingConsultationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpcomingConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? appointmentTime = freezed,
    Object? status = freezed,
    Object? topic = freezed,
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
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentTime: freezed == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpcomingConsultationImplCopyWith<$Res>
    implements $UpcomingConsultationCopyWith<$Res> {
  factory _$$UpcomingConsultationImplCopyWith(_$UpcomingConsultationImpl value,
          $Res Function(_$UpcomingConsultationImpl) then) =
      __$$UpcomingConsultationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? username,
      DateTime? appointmentTime,
      String? status,
      String? topic});
}

/// @nodoc
class __$$UpcomingConsultationImplCopyWithImpl<$Res>
    extends _$UpcomingConsultationCopyWithImpl<$Res, _$UpcomingConsultationImpl>
    implements _$$UpcomingConsultationImplCopyWith<$Res> {
  __$$UpcomingConsultationImplCopyWithImpl(_$UpcomingConsultationImpl _value,
      $Res Function(_$UpcomingConsultationImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpcomingConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? appointmentTime = freezed,
    Object? status = freezed,
    Object? topic = freezed,
  }) {
    return _then(_$UpcomingConsultationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentTime: freezed == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpcomingConsultationImpl implements _UpcomingConsultation {
  const _$UpcomingConsultationImpl(
      {required this.id,
      required this.userId,
      this.username,
      this.appointmentTime,
      this.status,
      this.topic});

  factory _$UpcomingConsultationImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpcomingConsultationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? username;
  @override
  final DateTime? appointmentTime;
  @override
  final String? status;
  @override
  final String? topic;

  @override
  String toString() {
    return 'UpcomingConsultation(id: $id, userId: $userId, username: $username, appointmentTime: $appointmentTime, status: $status, topic: $topic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpcomingConsultationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.topic, topic) || other.topic == topic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, username, appointmentTime, status, topic);

  /// Create a copy of UpcomingConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpcomingConsultationImplCopyWith<_$UpcomingConsultationImpl>
      get copyWith =>
          __$$UpcomingConsultationImplCopyWithImpl<_$UpcomingConsultationImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UpcomingConsultation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UpcomingConsultation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UpcomingConsultation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UpcomingConsultationImplToJson(
      this,
    );
  }
}

abstract class _UpcomingConsultation implements UpcomingConsultation {
  const factory _UpcomingConsultation(
      {required final String id,
      required final String userId,
      final String? username,
      final DateTime? appointmentTime,
      final String? status,
      final String? topic}) = _$UpcomingConsultationImpl;

  factory _UpcomingConsultation.fromJson(Map<String, dynamic> json) =
      _$UpcomingConsultationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get username;
  @override
  DateTime? get appointmentTime;
  @override
  String? get status;
  @override
  String? get topic;

  /// Create a copy of UpcomingConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpcomingConsultationImplCopyWith<_$UpcomingConsultationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkbenchTask _$WorkbenchTaskFromJson(Map<String, dynamic> json) {
  return _WorkbenchTask.fromJson(json);
}

/// @nodoc
mixin _$WorkbenchTask {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkbenchTask value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkbenchTask value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkbenchTask value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkbenchTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkbenchTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkbenchTaskCopyWith<WorkbenchTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkbenchTaskCopyWith<$Res> {
  factory $WorkbenchTaskCopyWith(
          WorkbenchTask value, $Res Function(WorkbenchTask) then) =
      _$WorkbenchTaskCopyWithImpl<$Res, WorkbenchTask>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String description,
      String priority,
      DateTime createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$WorkbenchTaskCopyWithImpl<$Res, $Val extends WorkbenchTask>
    implements $WorkbenchTaskCopyWith<$Res> {
  _$WorkbenchTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkbenchTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkbenchTaskImplCopyWith<$Res>
    implements $WorkbenchTaskCopyWith<$Res> {
  factory _$$WorkbenchTaskImplCopyWith(
          _$WorkbenchTaskImpl value, $Res Function(_$WorkbenchTaskImpl) then) =
      __$$WorkbenchTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String description,
      String priority,
      DateTime createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$WorkbenchTaskImplCopyWithImpl<$Res>
    extends _$WorkbenchTaskCopyWithImpl<$Res, _$WorkbenchTaskImpl>
    implements _$$WorkbenchTaskImplCopyWith<$Res> {
  __$$WorkbenchTaskImplCopyWithImpl(
      _$WorkbenchTaskImpl _value, $Res Function(_$WorkbenchTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkbenchTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_$WorkbenchTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkbenchTaskImpl implements _WorkbenchTask {
  const _$WorkbenchTaskImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      required this.priority,
      required this.createdAt,
      final Map<String, dynamic>? data})
      : _data = data;

  factory _$WorkbenchTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkbenchTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String title;
  @override
  final String description;
  @override
  final String priority;
  @override
  final DateTime createdAt;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WorkbenchTask(id: $id, type: $type, title: $title, description: $description, priority: $priority, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkbenchTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, description,
      priority, createdAt, const DeepCollectionEquality().hash(_data));

  /// Create a copy of WorkbenchTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkbenchTaskImplCopyWith<_$WorkbenchTaskImpl> get copyWith =>
      __$$WorkbenchTaskImplCopyWithImpl<_$WorkbenchTaskImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkbenchTask value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkbenchTask value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkbenchTask value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkbenchTaskImplToJson(
      this,
    );
  }
}

abstract class _WorkbenchTask implements WorkbenchTask {
  const factory _WorkbenchTask(
      {required final String id,
      required final String type,
      required final String title,
      required final String description,
      required final String priority,
      required final DateTime createdAt,
      final Map<String, dynamic>? data}) = _$WorkbenchTaskImpl;

  factory _WorkbenchTask.fromJson(Map<String, dynamic> json) =
      _$WorkbenchTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get title;
  @override
  String get description;
  @override
  String get priority;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of WorkbenchTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkbenchTaskImplCopyWith<_$WorkbenchTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkbenchConsultation _$WorkbenchConsultationFromJson(
    Map<String, dynamic> json) {
  return _WorkbenchConsultation.fromJson(json);
}

/// @nodoc
mixin _$WorkbenchConsultation {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  DateTime? get appointmentTime => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  Map<String, dynamic>? get userInfo => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkbenchConsultation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkbenchConsultation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkbenchConsultation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkbenchConsultation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkbenchConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkbenchConsultationCopyWith<WorkbenchConsultation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkbenchConsultationCopyWith<$Res> {
  factory $WorkbenchConsultationCopyWith(WorkbenchConsultation value,
          $Res Function(WorkbenchConsultation) then) =
      _$WorkbenchConsultationCopyWithImpl<$Res, WorkbenchConsultation>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? username,
      String? topic,
      String? status,
      DateTime? appointmentTime,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? duration,
      double? price,
      Map<String, dynamic>? userInfo});
}

/// @nodoc
class _$WorkbenchConsultationCopyWithImpl<$Res,
        $Val extends WorkbenchConsultation>
    implements $WorkbenchConsultationCopyWith<$Res> {
  _$WorkbenchConsultationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkbenchConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? topic = freezed,
    Object? status = freezed,
    Object? appointmentTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? duration = freezed,
    Object? price = freezed,
    Object? userInfo = freezed,
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
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentTime: freezed == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkbenchConsultationImplCopyWith<$Res>
    implements $WorkbenchConsultationCopyWith<$Res> {
  factory _$$WorkbenchConsultationImplCopyWith(
          _$WorkbenchConsultationImpl value,
          $Res Function(_$WorkbenchConsultationImpl) then) =
      __$$WorkbenchConsultationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? username,
      String? topic,
      String? status,
      DateTime? appointmentTime,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? duration,
      double? price,
      Map<String, dynamic>? userInfo});
}

/// @nodoc
class __$$WorkbenchConsultationImplCopyWithImpl<$Res>
    extends _$WorkbenchConsultationCopyWithImpl<$Res,
        _$WorkbenchConsultationImpl>
    implements _$$WorkbenchConsultationImplCopyWith<$Res> {
  __$$WorkbenchConsultationImplCopyWithImpl(_$WorkbenchConsultationImpl _value,
      $Res Function(_$WorkbenchConsultationImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkbenchConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? topic = freezed,
    Object? status = freezed,
    Object? appointmentTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? duration = freezed,
    Object? price = freezed,
    Object? userInfo = freezed,
  }) {
    return _then(_$WorkbenchConsultationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentTime: freezed == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      userInfo: freezed == userInfo
          ? _value._userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkbenchConsultationImpl implements _WorkbenchConsultation {
  const _$WorkbenchConsultationImpl(
      {required this.id,
      required this.userId,
      this.username,
      this.topic,
      this.status,
      this.appointmentTime,
      this.createdAt,
      this.updatedAt,
      this.duration,
      this.price,
      final Map<String, dynamic>? userInfo})
      : _userInfo = userInfo;

  factory _$WorkbenchConsultationImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkbenchConsultationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? username;
  @override
  final String? topic;
  @override
  final String? status;
  @override
  final DateTime? appointmentTime;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final int? duration;
  @override
  final double? price;
  final Map<String, dynamic>? _userInfo;
  @override
  Map<String, dynamic>? get userInfo {
    final value = _userInfo;
    if (value == null) return null;
    if (_userInfo is EqualUnmodifiableMapView) return _userInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WorkbenchConsultation(id: $id, userId: $userId, username: $username, topic: $topic, status: $status, appointmentTime: $appointmentTime, createdAt: $createdAt, updatedAt: $updatedAt, duration: $duration, price: $price, userInfo: $userInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkbenchConsultationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._userInfo, _userInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      username,
      topic,
      status,
      appointmentTime,
      createdAt,
      updatedAt,
      duration,
      price,
      const DeepCollectionEquality().hash(_userInfo));

  /// Create a copy of WorkbenchConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkbenchConsultationImplCopyWith<_$WorkbenchConsultationImpl>
      get copyWith => __$$WorkbenchConsultationImplCopyWithImpl<
          _$WorkbenchConsultationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkbenchConsultation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkbenchConsultation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkbenchConsultation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkbenchConsultationImplToJson(
      this,
    );
  }
}

abstract class _WorkbenchConsultation implements WorkbenchConsultation {
  const factory _WorkbenchConsultation(
      {required final String id,
      required final String userId,
      final String? username,
      final String? topic,
      final String? status,
      final DateTime? appointmentTime,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final int? duration,
      final double? price,
      final Map<String, dynamic>? userInfo}) = _$WorkbenchConsultationImpl;

  factory _WorkbenchConsultation.fromJson(Map<String, dynamic> json) =
      _$WorkbenchConsultationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get username;
  @override
  String? get topic;
  @override
  String? get status;
  @override
  DateTime? get appointmentTime;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int? get duration;
  @override
  double? get price;
  @override
  Map<String, dynamic>? get userInfo;

  /// Create a copy of WorkbenchConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkbenchConsultationImplCopyWith<_$WorkbenchConsultationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  Map<String, dynamic> get workingHours => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get vacations =>
      throw _privateConstructorUsedError;
  List<Appointment> get appointments => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Schedule value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Schedule value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Schedule value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call(
      {Map<String, dynamic> workingHours,
      List<Map<String, dynamic>> vacations,
      List<Appointment> appointments});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingHours = null,
    Object? vacations = null,
    Object? appointments = null,
  }) {
    return _then(_value.copyWith(
      workingHours: null == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      vacations: null == vacations
          ? _value.vacations
          : vacations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      appointments: null == appointments
          ? _value.appointments
          : appointments // ignore: cast_nullable_to_non_nullable
              as List<Appointment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleImplCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$$ScheduleImplCopyWith(
          _$ScheduleImpl value, $Res Function(_$ScheduleImpl) then) =
      __$$ScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> workingHours,
      List<Map<String, dynamic>> vacations,
      List<Appointment> appointments});
}

/// @nodoc
class __$$ScheduleImplCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$ScheduleImpl>
    implements _$$ScheduleImplCopyWith<$Res> {
  __$$ScheduleImplCopyWithImpl(
      _$ScheduleImpl _value, $Res Function(_$ScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingHours = null,
    Object? vacations = null,
    Object? appointments = null,
  }) {
    return _then(_$ScheduleImpl(
      workingHours: null == workingHours
          ? _value._workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      vacations: null == vacations
          ? _value._vacations
          : vacations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      appointments: null == appointments
          ? _value._appointments
          : appointments // ignore: cast_nullable_to_non_nullable
              as List<Appointment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleImpl implements _Schedule {
  const _$ScheduleImpl(
      {final Map<String, dynamic> workingHours = const {},
      final List<Map<String, dynamic>> vacations = const [],
      final List<Appointment> appointments = const []})
      : _workingHours = workingHours,
        _vacations = vacations,
        _appointments = appointments;

  factory _$ScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleImplFromJson(json);

  final Map<String, dynamic> _workingHours;
  @override
  @JsonKey()
  Map<String, dynamic> get workingHours {
    if (_workingHours is EqualUnmodifiableMapView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_workingHours);
  }

  final List<Map<String, dynamic>> _vacations;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get vacations {
    if (_vacations is EqualUnmodifiableListView) return _vacations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vacations);
  }

  final List<Appointment> _appointments;
  @override
  @JsonKey()
  List<Appointment> get appointments {
    if (_appointments is EqualUnmodifiableListView) return _appointments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appointments);
  }

  @override
  String toString() {
    return 'Schedule(workingHours: $workingHours, vacations: $vacations, appointments: $appointments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleImpl &&
            const DeepCollectionEquality()
                .equals(other._workingHours, _workingHours) &&
            const DeepCollectionEquality()
                .equals(other._vacations, _vacations) &&
            const DeepCollectionEquality()
                .equals(other._appointments, _appointments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workingHours),
      const DeepCollectionEquality().hash(_vacations),
      const DeepCollectionEquality().hash(_appointments));

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      __$$ScheduleImplCopyWithImpl<_$ScheduleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Schedule value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Schedule value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Schedule value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleImplToJson(
      this,
    );
  }
}

abstract class _Schedule implements Schedule {
  const factory _Schedule(
      {final Map<String, dynamic> workingHours,
      final List<Map<String, dynamic>> vacations,
      final List<Appointment> appointments}) = _$ScheduleImpl;

  factory _Schedule.fromJson(Map<String, dynamic> json) =
      _$ScheduleImpl.fromJson;

  @override
  Map<String, dynamic> get workingHours;
  @override
  List<Map<String, dynamic>> get vacations;
  @override
  List<Appointment> get appointments;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Appointment value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Appointment value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Appointment value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
          Appointment value, $Res Function(Appointment) then) =
      _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime start,
      DateTime end,
      String? status,
      String? type});
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? start = null,
    Object? end = null,
    Object? status = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
          _$AppointmentImpl value, $Res Function(_$AppointmentImpl) then) =
      __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime start,
      DateTime end,
      String? status,
      String? type});
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
      _$AppointmentImpl _value, $Res Function(_$AppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? start = null,
    Object? end = null,
    Object? status = freezed,
    Object? type = freezed,
  }) {
    return _then(_$AppointmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl(
      {required this.id,
      required this.title,
      required this.start,
      required this.end,
      this.status,
      this.type});

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  final String? status;
  @override
  final String? type;

  @override
  String toString() {
    return 'Appointment(id: $id, title: $title, start: $start, end: $end, status: $status, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, start, end, status, type);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Appointment value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Appointment value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Appointment value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(
      this,
    );
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment(
      {required final String id,
      required final String title,
      required final DateTime start,
      required final DateTime end,
      final String? status,
      final String? type}) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get start;
  @override
  DateTime get end;
  @override
  String? get status;
  @override
  String? get type;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomeDetails _$IncomeDetailsFromJson(Map<String, dynamic> json) {
  return _IncomeDetails.fromJson(json);
}

/// @nodoc
mixin _$IncomeDetails {
  List<IncomeItem> get items => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IncomeDetails value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IncomeDetails value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IncomeDetails value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IncomeDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomeDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeDetailsCopyWith<IncomeDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeDetailsCopyWith<$Res> {
  factory $IncomeDetailsCopyWith(
          IncomeDetails value, $Res Function(IncomeDetails) then) =
      _$IncomeDetailsCopyWithImpl<$Res, IncomeDetails>;
  @useResult
  $Res call(
      {List<IncomeItem> items,
      double totalAmount,
      int totalCount,
      int? page,
      int? limit});
}

/// @nodoc
class _$IncomeDetailsCopyWithImpl<$Res, $Val extends IncomeDetails>
    implements $IncomeDetailsCopyWith<$Res> {
  _$IncomeDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalAmount = null,
    Object? totalCount = null,
    Object? page = freezed,
    Object? limit = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<IncomeItem>,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeDetailsImplCopyWith<$Res>
    implements $IncomeDetailsCopyWith<$Res> {
  factory _$$IncomeDetailsImplCopyWith(
          _$IncomeDetailsImpl value, $Res Function(_$IncomeDetailsImpl) then) =
      __$$IncomeDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<IncomeItem> items,
      double totalAmount,
      int totalCount,
      int? page,
      int? limit});
}

/// @nodoc
class __$$IncomeDetailsImplCopyWithImpl<$Res>
    extends _$IncomeDetailsCopyWithImpl<$Res, _$IncomeDetailsImpl>
    implements _$$IncomeDetailsImplCopyWith<$Res> {
  __$$IncomeDetailsImplCopyWithImpl(
      _$IncomeDetailsImpl _value, $Res Function(_$IncomeDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalAmount = null,
    Object? totalCount = null,
    Object? page = freezed,
    Object? limit = freezed,
  }) {
    return _then(_$IncomeDetailsImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<IncomeItem>,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomeDetailsImpl implements _IncomeDetails {
  const _$IncomeDetailsImpl(
      {final List<IncomeItem> items = const [],
      this.totalAmount = 0.0,
      this.totalCount = 0,
      this.page,
      this.limit})
      : _items = items;

  factory _$IncomeDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomeDetailsImplFromJson(json);

  final List<IncomeItem> _items;
  @override
  @JsonKey()
  List<IncomeItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final int totalCount;
  @override
  final int? page;
  @override
  final int? limit;

  @override
  String toString() {
    return 'IncomeDetails(items: $items, totalAmount: $totalAmount, totalCount: $totalCount, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeDetailsImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      totalAmount,
      totalCount,
      page,
      limit);

  /// Create a copy of IncomeDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeDetailsImplCopyWith<_$IncomeDetailsImpl> get copyWith =>
      __$$IncomeDetailsImplCopyWithImpl<_$IncomeDetailsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IncomeDetails value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IncomeDetails value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IncomeDetails value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomeDetailsImplToJson(
      this,
    );
  }
}

abstract class _IncomeDetails implements IncomeDetails {
  const factory _IncomeDetails(
      {final List<IncomeItem> items,
      final double totalAmount,
      final int totalCount,
      final int? page,
      final int? limit}) = _$IncomeDetailsImpl;

  factory _IncomeDetails.fromJson(Map<String, dynamic> json) =
      _$IncomeDetailsImpl.fromJson;

  @override
  List<IncomeItem> get items;
  @override
  double get totalAmount;
  @override
  int get totalCount;
  @override
  int? get page;
  @override
  int? get limit;

  /// Create a copy of IncomeDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeDetailsImplCopyWith<_$IncomeDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomeItem _$IncomeItemFromJson(Map<String, dynamic> json) {
  return _IncomeItem.fromJson(json);
}

/// @nodoc
mixin _$IncomeItem {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IncomeItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IncomeItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IncomeItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IncomeItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeItemCopyWith<IncomeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeItemCopyWith<$Res> {
  factory $IncomeItemCopyWith(
          IncomeItem value, $Res Function(IncomeItem) then) =
      _$IncomeItemCopyWithImpl<$Res, IncomeItem>;
  @useResult
  $Res call(
      {String id,
      String type,
      double amount,
      DateTime date,
      String? description,
      String? relatedId,
      String? status});
}

/// @nodoc
class _$IncomeItemCopyWithImpl<$Res, $Val extends IncomeItem>
    implements $IncomeItemCopyWith<$Res> {
  _$IncomeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? date = null,
    Object? description = freezed,
    Object? relatedId = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeItemImplCopyWith<$Res>
    implements $IncomeItemCopyWith<$Res> {
  factory _$$IncomeItemImplCopyWith(
          _$IncomeItemImpl value, $Res Function(_$IncomeItemImpl) then) =
      __$$IncomeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      double amount,
      DateTime date,
      String? description,
      String? relatedId,
      String? status});
}

/// @nodoc
class __$$IncomeItemImplCopyWithImpl<$Res>
    extends _$IncomeItemCopyWithImpl<$Res, _$IncomeItemImpl>
    implements _$$IncomeItemImplCopyWith<$Res> {
  __$$IncomeItemImplCopyWithImpl(
      _$IncomeItemImpl _value, $Res Function(_$IncomeItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? date = null,
    Object? description = freezed,
    Object? relatedId = freezed,
    Object? status = freezed,
  }) {
    return _then(_$IncomeItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomeItemImpl implements _IncomeItem {
  const _$IncomeItemImpl(
      {required this.id,
      required this.type,
      required this.amount,
      required this.date,
      this.description,
      this.relatedId,
      this.status});

  factory _$IncomeItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomeItemImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final double amount;
  @override
  final DateTime date;
  @override
  final String? description;
  @override
  final String? relatedId;
  @override
  final String? status;

  @override
  String toString() {
    return 'IncomeItem(id: $id, type: $type, amount: $amount, date: $date, description: $description, relatedId: $relatedId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, amount, date, description, relatedId, status);

  /// Create a copy of IncomeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeItemImplCopyWith<_$IncomeItemImpl> get copyWith =>
      __$$IncomeItemImplCopyWithImpl<_$IncomeItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IncomeItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IncomeItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IncomeItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomeItemImplToJson(
      this,
    );
  }
}

abstract class _IncomeItem implements IncomeItem {
  const factory _IncomeItem(
      {required final String id,
      required final String type,
      required final double amount,
      required final DateTime date,
      final String? description,
      final String? relatedId,
      final String? status}) = _$IncomeItemImpl;

  factory _IncomeItem.fromJson(Map<String, dynamic> json) =
      _$IncomeItemImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  double get amount;
  @override
  DateTime get date;
  @override
  String? get description;
  @override
  String? get relatedId;
  @override
  String? get status;

  /// Create a copy of IncomeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeItemImplCopyWith<_$IncomeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BatchMessageResult _$BatchMessageResultFromJson(Map<String, dynamic> json) {
  return _BatchMessageResult.fromJson(json);
}

/// @nodoc
mixin _$BatchMessageResult {
  int get totalClients => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  int get failCount => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchMessageResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchMessageResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchMessageResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BatchMessageResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchMessageResultCopyWith<BatchMessageResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchMessageResultCopyWith<$Res> {
  factory $BatchMessageResultCopyWith(
          BatchMessageResult value, $Res Function(BatchMessageResult) then) =
      _$BatchMessageResultCopyWithImpl<$Res, BatchMessageResult>;
  @useResult
  $Res call({int totalClients, int successCount, int failCount});
}

/// @nodoc
class _$BatchMessageResultCopyWithImpl<$Res, $Val extends BatchMessageResult>
    implements $BatchMessageResultCopyWith<$Res> {
  _$BatchMessageResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalClients = null,
    Object? successCount = null,
    Object? failCount = null,
  }) {
    return _then(_value.copyWith(
      totalClients: null == totalClients
          ? _value.totalClients
          : totalClients // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failCount: null == failCount
          ? _value.failCount
          : failCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchMessageResultImplCopyWith<$Res>
    implements $BatchMessageResultCopyWith<$Res> {
  factory _$$BatchMessageResultImplCopyWith(_$BatchMessageResultImpl value,
          $Res Function(_$BatchMessageResultImpl) then) =
      __$$BatchMessageResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalClients, int successCount, int failCount});
}

/// @nodoc
class __$$BatchMessageResultImplCopyWithImpl<$Res>
    extends _$BatchMessageResultCopyWithImpl<$Res, _$BatchMessageResultImpl>
    implements _$$BatchMessageResultImplCopyWith<$Res> {
  __$$BatchMessageResultImplCopyWithImpl(_$BatchMessageResultImpl _value,
      $Res Function(_$BatchMessageResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalClients = null,
    Object? successCount = null,
    Object? failCount = null,
  }) {
    return _then(_$BatchMessageResultImpl(
      totalClients: null == totalClients
          ? _value.totalClients
          : totalClients // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failCount: null == failCount
          ? _value.failCount
          : failCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchMessageResultImpl implements _BatchMessageResult {
  const _$BatchMessageResultImpl(
      {required this.totalClients,
      required this.successCount,
      required this.failCount});

  factory _$BatchMessageResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchMessageResultImplFromJson(json);

  @override
  final int totalClients;
  @override
  final int successCount;
  @override
  final int failCount;

  @override
  String toString() {
    return 'BatchMessageResult(totalClients: $totalClients, successCount: $successCount, failCount: $failCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchMessageResultImpl &&
            (identical(other.totalClients, totalClients) ||
                other.totalClients == totalClients) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failCount, failCount) ||
                other.failCount == failCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalClients, successCount, failCount);

  /// Create a copy of BatchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchMessageResultImplCopyWith<_$BatchMessageResultImpl> get copyWith =>
      __$$BatchMessageResultImplCopyWithImpl<_$BatchMessageResultImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchMessageResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchMessageResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchMessageResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchMessageResultImplToJson(
      this,
    );
  }
}

abstract class _BatchMessageResult implements BatchMessageResult {
  const factory _BatchMessageResult(
      {required final int totalClients,
      required final int successCount,
      required final int failCount}) = _$BatchMessageResultImpl;

  factory _BatchMessageResult.fromJson(Map<String, dynamic> json) =
      _$BatchMessageResultImpl.fromJson;

  @override
  int get totalClients;
  @override
  int get successCount;
  @override
  int get failCount;

  /// Create a copy of BatchMessageResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchMessageResultImplCopyWith<_$BatchMessageResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickAction _$QuickActionFromJson(Map<String, dynamic> json) {
  return _QuickAction.fromJson(json);
}

/// @nodoc
mixin _$QuickAction {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  int? get badge => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QuickAction value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QuickAction value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QuickAction value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this QuickAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickActionCopyWith<QuickAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionCopyWith<$Res> {
  factory $QuickActionCopyWith(
          QuickAction value, $Res Function(QuickAction) then) =
      _$QuickActionCopyWithImpl<$Res, QuickAction>;
  @useResult
  $Res call(
      {String id,
      String title,
      String icon,
      String action,
      String color,
      int? badge});
}

/// @nodoc
class _$QuickActionCopyWithImpl<$Res, $Val extends QuickAction>
    implements $QuickActionCopyWith<$Res> {
  _$QuickActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? icon = null,
    Object? action = null,
    Object? color = null,
    Object? badge = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickActionImplCopyWith<$Res>
    implements $QuickActionCopyWith<$Res> {
  factory _$$QuickActionImplCopyWith(
          _$QuickActionImpl value, $Res Function(_$QuickActionImpl) then) =
      __$$QuickActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String icon,
      String action,
      String color,
      int? badge});
}

/// @nodoc
class __$$QuickActionImplCopyWithImpl<$Res>
    extends _$QuickActionCopyWithImpl<$Res, _$QuickActionImpl>
    implements _$$QuickActionImplCopyWith<$Res> {
  __$$QuickActionImplCopyWithImpl(
      _$QuickActionImpl _value, $Res Function(_$QuickActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? icon = null,
    Object? action = null,
    Object? color = null,
    Object? badge = freezed,
  }) {
    return _then(_$QuickActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickActionImpl implements _QuickAction {
  const _$QuickActionImpl(
      {required this.id,
      required this.title,
      required this.icon,
      required this.action,
      required this.color,
      this.badge});

  factory _$QuickActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickActionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String icon;
  @override
  final String action;
  @override
  final String color;
  @override
  final int? badge;

  @override
  String toString() {
    return 'QuickAction(id: $id, title: $title, icon: $icon, action: $action, color: $color, badge: $badge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.badge, badge) || other.badge == badge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, icon, action, color, badge);

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickActionImplCopyWith<_$QuickActionImpl> get copyWith =>
      __$$QuickActionImplCopyWithImpl<_$QuickActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QuickAction value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QuickAction value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QuickAction value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickActionImplToJson(
      this,
    );
  }
}

abstract class _QuickAction implements QuickAction {
  const factory _QuickAction(
      {required final String id,
      required final String title,
      required final String icon,
      required final String action,
      required final String color,
      final int? badge}) = _$QuickActionImpl;

  factory _QuickAction.fromJson(Map<String, dynamic> json) =
      _$QuickActionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get icon;
  @override
  String get action;
  @override
  String get color;
  @override
  int? get badge;

  /// Create a copy of QuickAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickActionImplCopyWith<_$QuickActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnlineStatusResult _$OnlineStatusResultFromJson(Map<String, dynamic> json) {
  return _OnlineStatusResult.fromJson(json);
}

/// @nodoc
mixin _$OnlineStatusResult {
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  Map<String, dynamic>? get onlineStatus => throw _privateConstructorUsedError;
  Map<String, dynamic>? get nutritionist => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnlineStatusResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnlineStatusResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnlineStatusResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OnlineStatusResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnlineStatusResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnlineStatusResultCopyWith<OnlineStatusResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnlineStatusResultCopyWith<$Res> {
  factory $OnlineStatusResultCopyWith(
          OnlineStatusResult value, $Res Function(OnlineStatusResult) then) =
      _$OnlineStatusResultCopyWithImpl<$Res, OnlineStatusResult>;
  @useResult
  $Res call(
      {bool isOnline,
      bool isAvailable,
      Map<String, dynamic>? onlineStatus,
      Map<String, dynamic>? nutritionist});
}

/// @nodoc
class _$OnlineStatusResultCopyWithImpl<$Res, $Val extends OnlineStatusResult>
    implements $OnlineStatusResultCopyWith<$Res> {
  _$OnlineStatusResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnlineStatusResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? onlineStatus = freezed,
    Object? nutritionist = freezed,
  }) {
    return _then(_value.copyWith(
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      onlineStatus: freezed == onlineStatus
          ? _value.onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      nutritionist: freezed == nutritionist
          ? _value.nutritionist
          : nutritionist // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnlineStatusResultImplCopyWith<$Res>
    implements $OnlineStatusResultCopyWith<$Res> {
  factory _$$OnlineStatusResultImplCopyWith(_$OnlineStatusResultImpl value,
          $Res Function(_$OnlineStatusResultImpl) then) =
      __$$OnlineStatusResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOnline,
      bool isAvailable,
      Map<String, dynamic>? onlineStatus,
      Map<String, dynamic>? nutritionist});
}

/// @nodoc
class __$$OnlineStatusResultImplCopyWithImpl<$Res>
    extends _$OnlineStatusResultCopyWithImpl<$Res, _$OnlineStatusResultImpl>
    implements _$$OnlineStatusResultImplCopyWith<$Res> {
  __$$OnlineStatusResultImplCopyWithImpl(_$OnlineStatusResultImpl _value,
      $Res Function(_$OnlineStatusResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnlineStatusResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? onlineStatus = freezed,
    Object? nutritionist = freezed,
  }) {
    return _then(_$OnlineStatusResultImpl(
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      onlineStatus: freezed == onlineStatus
          ? _value._onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      nutritionist: freezed == nutritionist
          ? _value._nutritionist
          : nutritionist // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnlineStatusResultImpl implements _OnlineStatusResult {
  const _$OnlineStatusResultImpl(
      {required this.isOnline,
      required this.isAvailable,
      final Map<String, dynamic>? onlineStatus,
      final Map<String, dynamic>? nutritionist})
      : _onlineStatus = onlineStatus,
        _nutritionist = nutritionist;

  factory _$OnlineStatusResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnlineStatusResultImplFromJson(json);

  @override
  final bool isOnline;
  @override
  final bool isAvailable;
  final Map<String, dynamic>? _onlineStatus;
  @override
  Map<String, dynamic>? get onlineStatus {
    final value = _onlineStatus;
    if (value == null) return null;
    if (_onlineStatus is EqualUnmodifiableMapView) return _onlineStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _nutritionist;
  @override
  Map<String, dynamic>? get nutritionist {
    final value = _nutritionist;
    if (value == null) return null;
    if (_nutritionist is EqualUnmodifiableMapView) return _nutritionist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OnlineStatusResult(isOnline: $isOnline, isAvailable: $isAvailable, onlineStatus: $onlineStatus, nutritionist: $nutritionist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnlineStatusResultImpl &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality()
                .equals(other._onlineStatus, _onlineStatus) &&
            const DeepCollectionEquality()
                .equals(other._nutritionist, _nutritionist));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isOnline,
      isAvailable,
      const DeepCollectionEquality().hash(_onlineStatus),
      const DeepCollectionEquality().hash(_nutritionist));

  /// Create a copy of OnlineStatusResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnlineStatusResultImplCopyWith<_$OnlineStatusResultImpl> get copyWith =>
      __$$OnlineStatusResultImplCopyWithImpl<_$OnlineStatusResultImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnlineStatusResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnlineStatusResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnlineStatusResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OnlineStatusResultImplToJson(
      this,
    );
  }
}

abstract class _OnlineStatusResult implements OnlineStatusResult {
  const factory _OnlineStatusResult(
      {required final bool isOnline,
      required final bool isAvailable,
      final Map<String, dynamic>? onlineStatus,
      final Map<String, dynamic>? nutritionist}) = _$OnlineStatusResultImpl;

  factory _OnlineStatusResult.fromJson(Map<String, dynamic> json) =
      _$OnlineStatusResultImpl.fromJson;

  @override
  bool get isOnline;
  @override
  bool get isAvailable;
  @override
  Map<String, dynamic>? get onlineStatus;
  @override
  Map<String, dynamic>? get nutritionist;

  /// Create a copy of OnlineStatusResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnlineStatusResultImplCopyWith<_$OnlineStatusResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
