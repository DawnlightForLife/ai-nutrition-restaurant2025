import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../entities/nutrition_profile_v2.dart';
import '../models/search_filter_model.dart';

/// 搜索和过滤服务
class SearchFilterService {
  /// 应用搜索和过滤条件
  static List<NutritionProfileV2> applyFilters(
    List<NutritionProfileV2> profiles,
    SearchFilterModel filter,
  ) {
    var filteredProfiles = profiles.toList();
    
    // 应用搜索查询
    if (filter.searchQuery.isNotEmpty) {
      filteredProfiles = _applySearchQuery(filteredProfiles, filter.searchQuery);
    }
    
    // 应用性别过滤
    if (filter.genderFilters.isNotEmpty) {
      filteredProfiles = filteredProfiles.where((profile) {
        return filter.genderFilters.contains(profile.gender.toLowerCase());
      }).toList();
    }
    
    // 应用年龄组过滤
    if (filter.ageGroupFilters.isNotEmpty) {
      filteredProfiles = filteredProfiles.where((profile) {
        return filter.ageGroupFilters.contains(profile.ageGroup?.toLowerCase());
      }).toList();
    }
    
    // 应用健康目标过滤
    if (filter.healthGoalFilters.isNotEmpty) {
      filteredProfiles = filteredProfiles.where((profile) {
        // 检查主要健康目标
        if (filter.healthGoalFilters.contains(profile.healthGoal.toLowerCase())) {
          return true;
        }
        
        // 检查详细健康目标
        if (profile.healthGoalDetails != null) {
          final goals = List<String>.from(profile.healthGoalDetails!['goals'] ?? []);
          return goals.any((goal) => filter.healthGoalFilters.contains(goal.toLowerCase()));
        }
        
        return false;
      }).toList();
    }
    
    // 应用活动水平过滤
    if (filter.activityLevelFilters.isNotEmpty) {
      filteredProfiles = filteredProfiles.where((profile) {
        return filter.activityLevelFilters.contains(profile.exerciseFrequency?.toLowerCase());
      }).toList();
    }
    
    // 应用主要档案过滤
    if (filter.showPrimaryOnly) {
      filteredProfiles = filteredProfiles.where((profile) => profile.isPrimary).toList();
    }
    
    // 应用归档状态过滤
    if (!filter.showArchivedProfiles) {
      filteredProfiles = filteredProfiles.where((profile) => !profile.archived).toList();
    }
    
    // 应用创建日期范围过滤
    if (filter.createdDateRange != null) {
      final start = filter.createdDateRange!.start;
      final end = filter.createdDateRange!.end.add(const Duration(days: 1));
      
      filteredProfiles = filteredProfiles.where((profile) {
        return profile.createdAt.isAfter(start) && profile.createdAt.isBefore(end);
      }).toList();
    }
    
    // 应用完成度过滤
    if (filter.minCompletionPercentage != null || filter.maxCompletionPercentage != null) {
      filteredProfiles = filteredProfiles.where((profile) {
        final completion = profile.completionPercentage;
        
        if (filter.minCompletionPercentage != null && 
            completion < filter.minCompletionPercentage!) {
          return false;
        }
        
        if (filter.maxCompletionPercentage != null && 
            completion > filter.maxCompletionPercentage!) {
          return false;
        }
        
        return true;
      }).toList();
    }
    
    // 应用排序
    filteredProfiles = _applySorting(filteredProfiles, filter.sortOption, filter.sortDescending);
    
    return filteredProfiles;
  }
  
  /// 应用搜索查询
  static List<NutritionProfileV2> _applySearchQuery(
    List<NutritionProfileV2> profiles,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    
    return profiles.where((profile) {
      // 搜索档案名称
      if (profile.profileName.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      
      // 搜索健康目标
      if (profile.healthGoal.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      
      // 搜索详细健康目标
      if (profile.healthGoalDetails != null) {
        final goals = List<String>.from(profile.healthGoalDetails!['goals'] ?? []);
        if (goals.any((goal) => goal.toLowerCase().contains(lowerQuery))) {
          return true;
        }
      }
      
      // 搜索饮食偏好
      if (profile.dietaryPreferences.any((pref) => pref.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      // 搜索医疗条件
      if (profile.medicalConditions.any((condition) => condition.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      // 搜索营养偏好
      if (profile.nutritionPreferences.any((pref) => pref.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      // 搜索特殊状态
      if (profile.specialStatus.any((status) => status.toLowerCase().contains(lowerQuery))) {
        return true;
      }
      
      return false;
    }).toList();
  }
  
  /// 应用排序
  static List<NutritionProfileV2> _applySorting(
    List<NutritionProfileV2> profiles,
    ProfileSortOption sortOption,
    bool descending,
  ) {
    switch (sortOption) {
      case ProfileSortOption.createdDate:
        profiles.sort((a, b) {
          final comparison = a.createdAt.compareTo(b.createdAt);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.updatedDate:
        profiles.sort((a, b) {
          final comparison = a.updatedAt.compareTo(b.updatedAt);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.profileName:
        profiles.sort((a, b) {
          final comparison = a.profileName.compareTo(b.profileName);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.completionPercentage:
        profiles.sort((a, b) {
          final comparison = a.completionPercentage.compareTo(b.completionPercentage);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.energyPoints:
        profiles.sort((a, b) {
          final comparison = a.totalEnergyPoints.compareTo(b.totalEnergyPoints);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.streak:
        profiles.sort((a, b) {
          final comparison = a.currentStreak.compareTo(b.currentStreak);
          return descending ? -comparison : comparison;
        });
        break;
        
      case ProfileSortOption.lastActiveDate:
        profiles.sort((a, b) {
          final aDate = a.lastActiveDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.lastActiveDate ?? DateTime.fromMillisecondsSinceEpoch(0);
          final comparison = aDate.compareTo(bDate);
          return descending ? -comparison : comparison;
        });
        break;
    }
    
    return profiles;
  }
  
  /// 生成搜索建议
  static List<SearchSuggestion> generateSuggestions(
    List<NutritionProfileV2> profiles,
    String query,
  ) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();
    
    if (query.isEmpty) {
      // 显示常用搜索建议
      suggestions.addAll(_getCommonSuggestions());
    } else {
      // 基于档案名称的建议
      final profileNames = profiles
          .map((p) => p.profileName)
          .where((name) => name.toLowerCase().contains(lowerQuery))
          .take(3)
          .map((name) => SearchSuggestion(
                text: name,
                type: SearchSuggestionType.profileName,
                icon: Icons.folder,
              ));
      suggestions.addAll(profileNames);
      
      // 基于健康目标的建议
      final healthGoals = <String>{};
      for (final profile in profiles) {
        healthGoals.add(profile.healthGoal);
        if (profile.healthGoalDetails != null) {
          final goals = List<String>.from(profile.healthGoalDetails!['goals'] ?? []);
          healthGoals.addAll(goals);
        }
      }
      
      final goalSuggestions = healthGoals
          .where((goal) => goal.toLowerCase().contains(lowerQuery))
          .take(3)
          .map((goal) => SearchSuggestion(
                text: goal,
                subtitle: '健康目标',
                type: SearchSuggestionType.healthGoal,
                icon: Icons.flag,
              ));
      suggestions.addAll(goalSuggestions);
    }
    
    return suggestions.take(8).toList();
  }
  
  /// 获取常用搜索建议
  static List<SearchSuggestion> _getCommonSuggestions() {
    return const [
      SearchSuggestion(
        text: '减重',
        subtitle: '查找减重相关档案',
        type: SearchSuggestionType.healthGoal,
        icon: Icons.trending_down,
      ),
      SearchSuggestion(
        text: '增肌',
        subtitle: '查找增肌相关档案',
        type: SearchSuggestionType.healthGoal,
        icon: Icons.fitness_center,
      ),
      SearchSuggestion(
        text: '糖尿病',
        subtitle: '查找糖尿病管理档案',
        type: SearchSuggestionType.healthGoal,
        icon: Icons.medical_services,
      ),
      SearchSuggestion(
        text: '孕期',
        subtitle: '查找孕期营养档案',
        type: SearchSuggestionType.healthGoal,
        icon: Icons.pregnant_woman,
      ),
    ];
  }
  
  /// 获取档案统计信息
  static Map<String, dynamic> getProfileStats(List<NutritionProfileV2> profiles) {
    if (profiles.isEmpty) {
      return {
        'total': 0,
        'primary': 0,
        'archived': 0,
        'avgCompletion': 0.0,
        'genderDistribution': <String, int>{},
        'healthGoalDistribution': <String, int>{},
      };
    }
    
    final genderCount = <String, int>{};
    final healthGoalCount = <String, int>{};
    var totalCompletion = 0;
    var primaryCount = 0;
    var archivedCount = 0;
    
    for (final profile in profiles) {
      // 统计性别分布
      genderCount[profile.gender] = (genderCount[profile.gender] ?? 0) + 1;
      
      // 统计健康目标分布
      healthGoalCount[profile.healthGoal] = (healthGoalCount[profile.healthGoal] ?? 0) + 1;
      
      // 统计完成度
      totalCompletion += profile.completionPercentage;
      
      // 统计主要档案数量
      if (profile.isPrimary) primaryCount++;
      
      // 统计归档档案数量
      if (profile.archived) archivedCount++;
    }
    
    return {
      'total': profiles.length,
      'primary': primaryCount,
      'archived': archivedCount,
      'avgCompletion': totalCompletion / profiles.length,
      'genderDistribution': genderCount,
      'healthGoalDistribution': healthGoalCount,
    };
  }
}