// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_management_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionistManagementState {
  List<NutritionistManagementEntity> get nutritionists =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalRecords => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  String? get statusFilter => throw _privateConstructorUsedError;
  String? get verificationStatusFilter => throw _privateConstructorUsedError;
  String? get specializationFilter => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  String get sortOrder => throw _privateConstructorUsedError;
  Set<String> get selectedNutritionists => throw _privateConstructorUsedError;
  bool get isPerformingBatchOperation => throw _privateConstructorUsedError;
  NutritionistManagementOverview? get overview =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistManagementStateCopyWith<NutritionistManagementState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistManagementStateCopyWith<$Res> {
  factory $NutritionistManagementStateCopyWith(
          NutritionistManagementState value,
          $Res Function(NutritionistManagementState) then) =
      _$NutritionistManagementStateCopyWithImpl<$Res,
          NutritionistManagementState>;
  @useResult
  $Res call(
      {List<NutritionistManagementEntity> nutritionists,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int totalPages,
      int totalRecords,
      int pageSize,
      String? error,
      String? searchQuery,
      String? statusFilter,
      String? verificationStatusFilter,
      String? specializationFilter,
      String sortBy,
      String sortOrder,
      Set<String> selectedNutritionists,
      bool isPerformingBatchOperation,
      NutritionistManagementOverview? overview});

  $NutritionistManagementOverviewCopyWith<$Res>? get overview;
}

/// @nodoc
class _$NutritionistManagementStateCopyWithImpl<$Res,
        $Val extends NutritionistManagementState>
    implements $NutritionistManagementStateCopyWith<$Res> {
  _$NutritionistManagementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalRecords = null,
    Object? pageSize = null,
    Object? error = freezed,
    Object? searchQuery = freezed,
    Object? statusFilter = freezed,
    Object? verificationStatusFilter = freezed,
    Object? specializationFilter = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? selectedNutritionists = null,
    Object? isPerformingBatchOperation = null,
    Object? overview = freezed,
  }) {
    return _then(_value.copyWith(
      nutritionists: null == nutritionists
          ? _value.nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<NutritionistManagementEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalRecords: null == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatusFilter: freezed == verificationStatusFilter
          ? _value.verificationStatusFilter
          : verificationStatusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      specializationFilter: freezed == specializationFilter
          ? _value.specializationFilter
          : specializationFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
      selectedNutritionists: null == selectedNutritionists
          ? _value.selectedNutritionists
          : selectedNutritionists // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isPerformingBatchOperation: null == isPerformingBatchOperation
          ? _value.isPerformingBatchOperation
          : isPerformingBatchOperation // ignore: cast_nullable_to_non_nullable
              as bool,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as NutritionistManagementOverview?,
    ) as $Val);
  }

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistManagementOverviewCopyWith<$Res>? get overview {
    if (_value.overview == null) {
      return null;
    }

    return $NutritionistManagementOverviewCopyWith<$Res>(_value.overview!,
        (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistManagementStateImplCopyWith<$Res>
    implements $NutritionistManagementStateCopyWith<$Res> {
  factory _$$NutritionistManagementStateImplCopyWith(
          _$NutritionistManagementStateImpl value,
          $Res Function(_$NutritionistManagementStateImpl) then) =
      __$$NutritionistManagementStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NutritionistManagementEntity> nutritionists,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int totalPages,
      int totalRecords,
      int pageSize,
      String? error,
      String? searchQuery,
      String? statusFilter,
      String? verificationStatusFilter,
      String? specializationFilter,
      String sortBy,
      String sortOrder,
      Set<String> selectedNutritionists,
      bool isPerformingBatchOperation,
      NutritionistManagementOverview? overview});

  @override
  $NutritionistManagementOverviewCopyWith<$Res>? get overview;
}

/// @nodoc
class __$$NutritionistManagementStateImplCopyWithImpl<$Res>
    extends _$NutritionistManagementStateCopyWithImpl<$Res,
        _$NutritionistManagementStateImpl>
    implements _$$NutritionistManagementStateImplCopyWith<$Res> {
  __$$NutritionistManagementStateImplCopyWithImpl(
      _$NutritionistManagementStateImpl _value,
      $Res Function(_$NutritionistManagementStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalRecords = null,
    Object? pageSize = null,
    Object? error = freezed,
    Object? searchQuery = freezed,
    Object? statusFilter = freezed,
    Object? verificationStatusFilter = freezed,
    Object? specializationFilter = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? selectedNutritionists = null,
    Object? isPerformingBatchOperation = null,
    Object? overview = freezed,
  }) {
    return _then(_$NutritionistManagementStateImpl(
      nutritionists: null == nutritionists
          ? _value._nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<NutritionistManagementEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalRecords: null == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatusFilter: freezed == verificationStatusFilter
          ? _value.verificationStatusFilter
          : verificationStatusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      specializationFilter: freezed == specializationFilter
          ? _value.specializationFilter
          : specializationFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
      selectedNutritionists: null == selectedNutritionists
          ? _value._selectedNutritionists
          : selectedNutritionists // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isPerformingBatchOperation: null == isPerformingBatchOperation
          ? _value.isPerformingBatchOperation
          : isPerformingBatchOperation // ignore: cast_nullable_to_non_nullable
              as bool,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as NutritionistManagementOverview?,
    ));
  }
}

/// @nodoc

class _$NutritionistManagementStateImpl
    implements _NutritionistManagementState {
  const _$NutritionistManagementStateImpl(
      {final List<NutritionistManagementEntity> nutritionists = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.currentPage = 1,
      this.totalPages = 1,
      this.totalRecords = 0,
      this.pageSize = 20,
      this.error,
      this.searchQuery,
      this.statusFilter,
      this.verificationStatusFilter,
      this.specializationFilter,
      this.sortBy = 'createdAt',
      this.sortOrder = 'desc',
      final Set<String> selectedNutritionists = const {},
      this.isPerformingBatchOperation = false,
      this.overview})
      : _nutritionists = nutritionists,
        _selectedNutritionists = selectedNutritionists;

  final List<NutritionistManagementEntity> _nutritionists;
  @override
  @JsonKey()
  List<NutritionistManagementEntity> get nutritionists {
    if (_nutritionists is EqualUnmodifiableListView) return _nutritionists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionists);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int totalRecords;
  @override
  @JsonKey()
  final int pageSize;
  @override
  final String? error;
  @override
  final String? searchQuery;
  @override
  final String? statusFilter;
  @override
  final String? verificationStatusFilter;
  @override
  final String? specializationFilter;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final String sortOrder;
  final Set<String> _selectedNutritionists;
  @override
  @JsonKey()
  Set<String> get selectedNutritionists {
    if (_selectedNutritionists is EqualUnmodifiableSetView)
      return _selectedNutritionists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedNutritionists);
  }

  @override
  @JsonKey()
  final bool isPerformingBatchOperation;
  @override
  final NutritionistManagementOverview? overview;

  @override
  String toString() {
    return 'NutritionistManagementState(nutritionists: $nutritionists, isLoading: $isLoading, isLoadingMore: $isLoadingMore, currentPage: $currentPage, totalPages: $totalPages, totalRecords: $totalRecords, pageSize: $pageSize, error: $error, searchQuery: $searchQuery, statusFilter: $statusFilter, verificationStatusFilter: $verificationStatusFilter, specializationFilter: $specializationFilter, sortBy: $sortBy, sortOrder: $sortOrder, selectedNutritionists: $selectedNutritionists, isPerformingBatchOperation: $isPerformingBatchOperation, overview: $overview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistManagementStateImpl &&
            const DeepCollectionEquality()
                .equals(other._nutritionists, _nutritionists) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.statusFilter, statusFilter) ||
                other.statusFilter == statusFilter) &&
            (identical(
                    other.verificationStatusFilter, verificationStatusFilter) ||
                other.verificationStatusFilter == verificationStatusFilter) &&
            (identical(other.specializationFilter, specializationFilter) ||
                other.specializationFilter == specializationFilter) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality()
                .equals(other._selectedNutritionists, _selectedNutritionists) &&
            (identical(other.isPerformingBatchOperation,
                    isPerformingBatchOperation) ||
                other.isPerformingBatchOperation ==
                    isPerformingBatchOperation) &&
            (identical(other.overview, overview) ||
                other.overview == overview));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nutritionists),
      isLoading,
      isLoadingMore,
      currentPage,
      totalPages,
      totalRecords,
      pageSize,
      error,
      searchQuery,
      statusFilter,
      verificationStatusFilter,
      specializationFilter,
      sortBy,
      sortOrder,
      const DeepCollectionEquality().hash(_selectedNutritionists),
      isPerformingBatchOperation,
      overview);

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistManagementStateImplCopyWith<_$NutritionistManagementStateImpl>
      get copyWith => __$$NutritionistManagementStateImplCopyWithImpl<
          _$NutritionistManagementStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionistManagementState
    implements NutritionistManagementState {
  const factory _NutritionistManagementState(
          {final List<NutritionistManagementEntity> nutritionists,
          final bool isLoading,
          final bool isLoadingMore,
          final int currentPage,
          final int totalPages,
          final int totalRecords,
          final int pageSize,
          final String? error,
          final String? searchQuery,
          final String? statusFilter,
          final String? verificationStatusFilter,
          final String? specializationFilter,
          final String sortBy,
          final String sortOrder,
          final Set<String> selectedNutritionists,
          final bool isPerformingBatchOperation,
          final NutritionistManagementOverview? overview}) =
      _$NutritionistManagementStateImpl;

  @override
  List<NutritionistManagementEntity> get nutritionists;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get totalRecords;
  @override
  int get pageSize;
  @override
  String? get error;
  @override
  String? get searchQuery;
  @override
  String? get statusFilter;
  @override
  String? get verificationStatusFilter;
  @override
  String? get specializationFilter;
  @override
  String get sortBy;
  @override
  String get sortOrder;
  @override
  Set<String> get selectedNutritionists;
  @override
  bool get isPerformingBatchOperation;
  @override
  NutritionistManagementOverview? get overview;

  /// Create a copy of NutritionistManagementState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistManagementStateImplCopyWith<_$NutritionistManagementStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NutritionistFilters {
  String? get status => throw _privateConstructorUsedError;
  String? get verificationStatus => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  String get sortOrder => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistFilters value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistFilters value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistFilters value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionistFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistFiltersCopyWith<NutritionistFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistFiltersCopyWith<$Res> {
  factory $NutritionistFiltersCopyWith(
          NutritionistFilters value, $Res Function(NutritionistFilters) then) =
      _$NutritionistFiltersCopyWithImpl<$Res, NutritionistFilters>;
  @useResult
  $Res call(
      {String? status,
      String? verificationStatus,
      String? specialization,
      String sortBy,
      String sortOrder});
}

/// @nodoc
class _$NutritionistFiltersCopyWithImpl<$Res, $Val extends NutritionistFilters>
    implements $NutritionistFiltersCopyWith<$Res> {
  _$NutritionistFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? verificationStatus = freezed,
    Object? specialization = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistFiltersImplCopyWith<$Res>
    implements $NutritionistFiltersCopyWith<$Res> {
  factory _$$NutritionistFiltersImplCopyWith(_$NutritionistFiltersImpl value,
          $Res Function(_$NutritionistFiltersImpl) then) =
      __$$NutritionistFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? status,
      String? verificationStatus,
      String? specialization,
      String sortBy,
      String sortOrder});
}

/// @nodoc
class __$$NutritionistFiltersImplCopyWithImpl<$Res>
    extends _$NutritionistFiltersCopyWithImpl<$Res, _$NutritionistFiltersImpl>
    implements _$$NutritionistFiltersImplCopyWith<$Res> {
  __$$NutritionistFiltersImplCopyWithImpl(_$NutritionistFiltersImpl _value,
      $Res Function(_$NutritionistFiltersImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? verificationStatus = freezed,
    Object? specialization = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
  }) {
    return _then(_$NutritionistFiltersImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NutritionistFiltersImpl implements _NutritionistFilters {
  const _$NutritionistFiltersImpl(
      {this.status,
      this.verificationStatus,
      this.specialization,
      this.sortBy = 'createdAt',
      this.sortOrder = 'desc'});

  @override
  final String? status;
  @override
  final String? verificationStatus;
  @override
  final String? specialization;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final String sortOrder;

  @override
  String toString() {
    return 'NutritionistFilters(status: $status, verificationStatus: $verificationStatus, specialization: $specialization, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistFiltersImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, verificationStatus,
      specialization, sortBy, sortOrder);

  /// Create a copy of NutritionistFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistFiltersImplCopyWith<_$NutritionistFiltersImpl> get copyWith =>
      __$$NutritionistFiltersImplCopyWithImpl<_$NutritionistFiltersImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistFilters value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistFilters value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistFilters value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionistFilters implements NutritionistFilters {
  const factory _NutritionistFilters(
      {final String? status,
      final String? verificationStatus,
      final String? specialization,
      final String sortBy,
      final String sortOrder}) = _$NutritionistFiltersImpl;

  @override
  String? get status;
  @override
  String? get verificationStatus;
  @override
  String? get specialization;
  @override
  String get sortBy;
  @override
  String get sortOrder;

  /// Create a copy of NutritionistFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistFiltersImplCopyWith<_$NutritionistFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
