import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/models/search_filter_model.dart';
import '../../domain/services/search_filter_service.dart';
import 'nutrition_profile_list_provider.dart';

/// 搜索过滤状态
class SearchFilterState {
  final SearchFilterModel filter;
  final List<NutritionProfileV2> filteredProfiles;
  final List<SearchSuggestion> suggestions;
  final bool isSearching;
  final Map<String, dynamic> stats;
  
  const SearchFilterState({
    this.filter = const SearchFilterModel(),
    this.filteredProfiles = const [],
    this.suggestions = const [],
    this.isSearching = false,
    this.stats = const {},
  });

  // 便利的getter方法
  String get searchQuery => filter.searchQuery;
  bool get hasActiveFilters => filter.hasActiveFilters;
  
  SearchFilterState copyWith({
    SearchFilterModel? filter,
    List<NutritionProfileV2>? filteredProfiles,
    List<SearchSuggestion>? suggestions,
    bool? isSearching,
    Map<String, dynamic>? stats,
  }) {
    return SearchFilterState(
      filter: filter ?? this.filter,
      filteredProfiles: filteredProfiles ?? this.filteredProfiles,
      suggestions: suggestions ?? this.suggestions,
      isSearching: isSearching ?? this.isSearching,
      stats: stats ?? this.stats,
    );
  }
}

/// 搜索过滤状态管理器
class SearchFilterNotifier extends StateNotifier<SearchFilterState> {
  final Ref _ref;
  
  SearchFilterNotifier(this._ref) : super(const SearchFilterState()) {
    // 监听档案列表变化
    _ref.listen(nutritionProfileListProvider, (previous, next) {
      _applyCurrentFilter(next.profiles);
    });
  }
  
  /// 更新搜索查询
  void updateSearchQuery(String query) {
    final newFilter = state.filter.copyWith(searchQuery: query);
    _updateFilter(newFilter);
    
    // 生成搜索建议
    final allProfiles = _ref.read(nutritionProfileListProvider).profiles;
    final suggestions = SearchFilterService.generateSuggestions(allProfiles, query);
    
    state = state.copyWith(
      suggestions: suggestions,
      isSearching: query.isNotEmpty,
    );
  }
  
  /// 清除搜索
  void clearSearch() {
    final newFilter = state.filter.clearSearch();
    _updateFilter(newFilter);
    
    state = state.copyWith(
      suggestions: [],
      isSearching: false,
    );
  }
  
  /// 更新性别过滤器
  void toggleGenderFilter(String gender) {
    final newFilters = Set<String>.from(state.filter.genderFilters);
    if (newFilters.contains(gender)) {
      newFilters.remove(gender);
    } else {
      newFilters.add(gender);
    }
    
    final newFilter = state.filter.copyWith(genderFilters: newFilters);
    _updateFilter(newFilter);
  }
  
  /// 更新年龄组过滤器
  void toggleAgeGroupFilter(String ageGroup) {
    final newFilters = Set<String>.from(state.filter.ageGroupFilters);
    if (newFilters.contains(ageGroup)) {
      newFilters.remove(ageGroup);
    } else {
      newFilters.add(ageGroup);
    }
    
    final newFilter = state.filter.copyWith(ageGroupFilters: newFilters);
    _updateFilter(newFilter);
  }
  
  /// 更新健康目标过滤器
  void toggleHealthGoalFilter(String healthGoal) {
    final newFilters = Set<String>.from(state.filter.healthGoalFilters);
    if (newFilters.contains(healthGoal)) {
      newFilters.remove(healthGoal);
    } else {
      newFilters.add(healthGoal);
    }
    
    final newFilter = state.filter.copyWith(healthGoalFilters: newFilters);
    _updateFilter(newFilter);
  }
  
  /// 更新活动水平过滤器
  void toggleActivityLevelFilter(String activityLevel) {
    final newFilters = Set<String>.from(state.filter.activityLevelFilters);
    if (newFilters.contains(activityLevel)) {
      newFilters.remove(activityLevel);
    } else {
      newFilters.add(activityLevel);
    }
    
    final newFilter = state.filter.copyWith(activityLevelFilters: newFilters);
    _updateFilter(newFilter);
  }
  
  /// 更新排序选项
  void updateSortOption(ProfileSortOption sortOption, {bool? descending}) {
    // 如果是同一个排序选项，切换排序方向
    bool newDescending = descending ?? 
        (state.filter.sortOption == sortOption ? !state.filter.sortDescending : true);
    
    final newFilter = state.filter.copyWith(
      sortOption: sortOption,
      sortDescending: newDescending,
    );
    _updateFilter(newFilter);
  }
  
  /// 切换显示归档档案
  void toggleShowArchived() {
    final newFilter = state.filter.copyWith(
      showArchivedProfiles: !state.filter.showArchivedProfiles,
    );
    _updateFilter(newFilter);
  }
  
  /// 切换只显示主要档案
  void toggleShowPrimaryOnly() {
    final newFilter = state.filter.copyWith(
      showPrimaryOnly: !state.filter.showPrimaryOnly,
    );
    _updateFilter(newFilter);
  }
  
  /// 设置完成度范围
  void setCompletionRange(int? min, int? max) {
    final newFilter = state.filter.copyWith(
      minCompletionPercentage: min,
      maxCompletionPercentage: max,
    );
    _updateFilter(newFilter);
  }
  
  /// 设置创建日期范围
  void setCreatedDateRange(DateTimeRange? range) {
    final newFilter = state.filter.copyWith(createdDateRange: range);
    _updateFilter(newFilter);
  }
  
  /// 应用快速过滤标签
  void applyQuickFilter(QuickFilterTag tag) {
    // 合并当前过滤器和快速过滤器
    final newFilter = SearchFilterModel(
      searchQuery: state.filter.searchQuery, // 保留搜索查询
      genderFilters: tag.filter.genderFilters.isNotEmpty 
          ? tag.filter.genderFilters 
          : state.filter.genderFilters,
      ageGroupFilters: tag.filter.ageGroupFilters.isNotEmpty 
          ? tag.filter.ageGroupFilters 
          : state.filter.ageGroupFilters,
      healthGoalFilters: tag.filter.healthGoalFilters.isNotEmpty 
          ? tag.filter.healthGoalFilters 
          : state.filter.healthGoalFilters,
      activityLevelFilters: tag.filter.activityLevelFilters.isNotEmpty 
          ? tag.filter.activityLevelFilters 
          : state.filter.activityLevelFilters,
      sortOption: tag.filter.sortOption,
      sortDescending: tag.filter.sortDescending,
      showArchivedProfiles: tag.filter.showArchivedProfiles,
      showPrimaryOnly: tag.filter.showPrimaryOnly,
      createdDateRange: tag.filter.createdDateRange ?? state.filter.createdDateRange,
      minCompletionPercentage: tag.filter.minCompletionPercentage ?? state.filter.minCompletionPercentage,
      maxCompletionPercentage: tag.filter.maxCompletionPercentage ?? state.filter.maxCompletionPercentage,
    );
    
    _updateFilter(newFilter);
  }
  
  /// 清除所有过滤器
  void clearAllFilters() {
    _updateFilter(const SearchFilterModel());
    state = state.copyWith(
      suggestions: [],
      isSearching: false,
    );
  }

  /// 清除所有过滤器（别名方法）
  void clearAll() {
    clearAllFilters();
  }

  /// 应用完整的过滤器模型
  void applyFilter(SearchFilterModel filter) {
    _updateFilter(filter);
  }
  
  /// 应用搜索建议
  void applySuggestion(SearchSuggestion suggestion) {
    switch (suggestion.type) {
      case SearchSuggestionType.profileName:
        updateSearchQuery(suggestion.text);
        break;
      case SearchSuggestionType.healthGoal:
        updateSearchQuery(suggestion.text);
        break;
      case SearchSuggestionType.gender:
        toggleGenderFilter(suggestion.text.toLowerCase());
        break;
      case SearchSuggestionType.ageGroup:
        toggleAgeGroupFilter(suggestion.text.toLowerCase());
        break;
      case SearchSuggestionType.activityLevel:
        toggleActivityLevelFilter(suggestion.text.toLowerCase());
        break;
      case SearchSuggestionType.recent:
        updateSortOption(ProfileSortOption.createdDate, descending: true);
        break;
    }
  }
  
  /// 内部方法：更新过滤器并应用
  void _updateFilter(SearchFilterModel newFilter) {
    final allProfiles = _ref.read(nutritionProfileListProvider).profiles;
    _applyFilter(allProfiles, newFilter);
  }
  
  /// 应用当前过滤器
  void _applyCurrentFilter(List<NutritionProfileV2> allProfiles) {
    _applyFilter(allProfiles, state.filter);
  }
  
  /// 应用过滤器
  void _applyFilter(List<NutritionProfileV2> allProfiles, SearchFilterModel filter) {
    final filteredProfiles = SearchFilterService.applyFilters(allProfiles, filter);
    final stats = SearchFilterService.getProfileStats(filteredProfiles);
    
    state = state.copyWith(
      filter: filter,
      filteredProfiles: filteredProfiles,
      stats: stats,
    );
    
    print('🔍 过滤结果: ${filteredProfiles.length}/${allProfiles.length} 个档案');
  }
}

/// 搜索过滤状态提供者
final searchFilterProvider = StateNotifierProvider<SearchFilterNotifier, SearchFilterState>((ref) {
  return SearchFilterNotifier(ref);
});

/// 过滤后的档案列表提供者
final filteredProfilesProvider = Provider<List<NutritionProfileV2>>((ref) {
  return ref.watch(searchFilterProvider).filteredProfiles;
});

/// 搜索建议提供者
final searchSuggestionsProvider = Provider<List<SearchSuggestion>>((ref) {
  return ref.watch(searchFilterProvider).suggestions;
});

/// 档案统计信息提供者
final profileStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(searchFilterProvider).stats;
});

/// 是否有激活的过滤器提供者
final hasActiveFiltersProvider = Provider<bool>((ref) {
  return ref.watch(searchFilterProvider).filter.hasActiveFilters;
});

/// 激活的过滤器数量提供者
final activeFilterCountProvider = Provider<int>((ref) {
  return ref.watch(searchFilterProvider).filter.activeFilterCount;
});