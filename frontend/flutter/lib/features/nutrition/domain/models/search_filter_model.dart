import 'package:flutter/material.dart';

/// 搜索和过滤模型
class SearchFilterModel {
  final String searchQuery;
  final Set<String> genderFilters;
  final Set<String> ageGroupFilters;
  final Set<String> healthGoalFilters;
  final Set<String> activityLevelFilters;
  final ProfileSortOption sortOption;
  final bool sortDescending;
  final bool showArchivedProfiles;
  final bool showPrimaryOnly;
  final DateTimeRange? createdDateRange;
  final int? minCompletionPercentage;
  final int? maxCompletionPercentage;
  
  const SearchFilterModel({
    this.searchQuery = '',
    this.genderFilters = const {},
    this.ageGroupFilters = const {},
    this.healthGoalFilters = const {},
    this.activityLevelFilters = const {},
    this.sortOption = ProfileSortOption.createdDate,
    this.sortDescending = true,
    this.showArchivedProfiles = false,
    this.showPrimaryOnly = false,
    this.createdDateRange,
    this.minCompletionPercentage,
    this.maxCompletionPercentage,
  });
  
  SearchFilterModel copyWith({
    String? searchQuery,
    Set<String>? genderFilters,
    Set<String>? ageGroupFilters,
    Set<String>? healthGoalFilters,
    Set<String>? activityLevelFilters,
    ProfileSortOption? sortOption,
    bool? sortDescending,
    bool? showArchivedProfiles,
    bool? showPrimaryOnly,
    DateTimeRange? createdDateRange,
    int? minCompletionPercentage,
    int? maxCompletionPercentage,
  }) {
    return SearchFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      genderFilters: genderFilters ?? this.genderFilters,
      ageGroupFilters: ageGroupFilters ?? this.ageGroupFilters,
      healthGoalFilters: healthGoalFilters ?? this.healthGoalFilters,
      activityLevelFilters: activityLevelFilters ?? this.activityLevelFilters,
      sortOption: sortOption ?? this.sortOption,
      sortDescending: sortDescending ?? this.sortDescending,
      showArchivedProfiles: showArchivedProfiles ?? this.showArchivedProfiles,
      showPrimaryOnly: showPrimaryOnly ?? this.showPrimaryOnly,
      createdDateRange: createdDateRange ?? this.createdDateRange,
      minCompletionPercentage: minCompletionPercentage ?? this.minCompletionPercentage,
      maxCompletionPercentage: maxCompletionPercentage ?? this.maxCompletionPercentage,
    );
  }
  
  /// 是否有激活的过滤器
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
           genderFilters.isNotEmpty ||
           ageGroupFilters.isNotEmpty ||
           healthGoalFilters.isNotEmpty ||
           activityLevelFilters.isNotEmpty ||
           showArchivedProfiles ||
           showPrimaryOnly ||
           createdDateRange != null ||
           minCompletionPercentage != null ||
           maxCompletionPercentage != null;
  }
  
  /// 激活的过滤器数量
  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (genderFilters.isNotEmpty) count++;
    if (ageGroupFilters.isNotEmpty) count++;
    if (healthGoalFilters.isNotEmpty) count++;
    if (activityLevelFilters.isNotEmpty) count++;
    if (showArchivedProfiles) count++;
    if (showPrimaryOnly) count++;
    if (createdDateRange != null) count++;
    if (minCompletionPercentage != null || maxCompletionPercentage != null) count++;
    return count;
  }
  
  /// 清除所有过滤器
  SearchFilterModel clearAll() {
    return const SearchFilterModel();
  }
  
  /// 清除搜索查询
  SearchFilterModel clearSearch() {
    return copyWith(searchQuery: '');
  }
}

/// 档案排序选项
enum ProfileSortOption {
  createdDate('创建时间'),
  updatedDate('更新时间'),
  profileName('档案名称'),
  completionPercentage('完成度'),
  energyPoints('能量点数'),
  streak('连续天数'),
  lastActiveDate('最后活跃');
  
  const ProfileSortOption(this.displayName);
  final String displayName;
}

/// 快速过滤标签
class QuickFilterTag {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final SearchFilterModel filter;
  
  const QuickFilterTag({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.filter,
  });
  
  /// 预定义的快速过滤标签
  static List<QuickFilterTag> get defaultTags => [
    QuickFilterTag(
      id: 'primary',
      label: '主要档案',
      icon: Icons.star,
      color: Colors.amber,
      filter: const SearchFilterModel(showPrimaryOnly: true),
    ),
    QuickFilterTag(
      id: 'high_completion',
      label: '完整档案',
      icon: Icons.check_circle,
      color: Colors.green,
      filter: const SearchFilterModel(minCompletionPercentage: 80),
    ),
    QuickFilterTag(
      id: 'weight_loss',
      label: '减重目标',
      icon: Icons.trending_down,
      color: Colors.blue,
      filter: SearchFilterModel(healthGoalFilters: {'lose_weight'}),
    ),
    QuickFilterTag(
      id: 'muscle_gain',
      label: '增肌目标',
      icon: Icons.fitness_center,
      color: Colors.orange,
      filter: SearchFilterModel(healthGoalFilters: {'gain_muscle'}),
    ),
    QuickFilterTag(
      id: 'female',
      label: '女性档案',
      icon: Icons.female,
      color: Colors.pink,
      filter: SearchFilterModel(genderFilters: {'female'}),
    ),
    QuickFilterTag(
      id: 'male',
      label: '男性档案',
      icon: Icons.male,
      color: Colors.blue,
      filter: SearchFilterModel(genderFilters: {'male'}),
    ),
    QuickFilterTag(
      id: 'recent',
      label: '最近创建',
      icon: Icons.schedule,
      color: Colors.purple,
      filter: const SearchFilterModel(
        sortOption: ProfileSortOption.createdDate,
        sortDescending: true,
      ),
    ),
    QuickFilterTag(
      id: 'active',
      label: '活跃档案',
      icon: Icons.local_fire_department,
      color: Colors.red,
      filter: const SearchFilterModel(
        sortOption: ProfileSortOption.lastActiveDate,
        sortDescending: true,
      ),
    ),
  ];
}

/// 搜索建议
class SearchSuggestion {
  final String text;
  final String? subtitle;
  final IconData? icon;
  final SearchSuggestionType type;
  
  const SearchSuggestion({
    required this.text,
    this.subtitle,
    this.icon,
    required this.type,
  });
}

/// 搜索建议类型
enum SearchSuggestionType {
  profileName,
  healthGoal,
  gender,
  ageGroup,
  activityLevel,
  recent,
}