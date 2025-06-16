import '../entities/nutrition_profile_v2.dart';

/// 营养立方进度服务
class NutritionProgressService {
  /// 添加能量点数
  static NutritionProfileV2 addEnergyPoints(
    NutritionProfileV2 profile,
    int points, {
    String? activityType,
  }) {
    final now = DateTime.now();
    final currentTotal = profile.totalEnergyPoints + points;
    
    // 检查是否需要更新连续天数
    bool shouldUpdateStreak = false;
    int newCurrentStreak = profile.currentStreak;
    int newBestStreak = profile.bestStreak;
    
    if (profile.lastActiveDate == null) {
      // 第一次活动
      shouldUpdateStreak = true;
      newCurrentStreak = 1;
    } else {
      final daysSinceLastActive = now.difference(profile.lastActiveDate!).inDays;
      
      if (daysSinceLastActive == 0) {
        // 同一天，不增加连续天数
        shouldUpdateStreak = false;
      } else if (daysSinceLastActive == 1) {
        // 连续天数+1
        shouldUpdateStreak = true;
        newCurrentStreak = profile.currentStreak + 1;
      } else {
        // 中断了，重新开始
        shouldUpdateStreak = true;
        newCurrentStreak = 1;
      }
    }
    
    // 更新最佳连续天数
    if (newCurrentStreak > newBestStreak) {
      newBestStreak = newCurrentStreak;
    }
    
    // 更新营养进度
    final Map<String, dynamic> updatedProgress = Map<String, dynamic>.from(
      profile.nutritionProgress ?? {}
    );
    
    // 记录今天的活动
    final todayKey = _formatDateKey(now);
    if (!updatedProgress.containsKey(todayKey)) {
      updatedProgress[todayKey] = {
        'date': now.toIso8601String(),
        'activities': <Map<String, dynamic>>[],
        'totalPoints': 0,
      };
    }
    
    // 添加活动记录
    final todayData = updatedProgress[todayKey] as Map<String, dynamic>;
    final activities = List<Map<String, dynamic>>.from(todayData['activities'] ?? []);
    activities.add({
      'type': activityType ?? 'general',
      'points': points,
      'timestamp': now.toIso8601String(),
    });
    
    todayData['activities'] = activities;
    todayData['totalPoints'] = (todayData['totalPoints'] ?? 0) + points;
    
    return profile.copyWith(
      totalEnergyPoints: currentTotal,
      currentStreak: newCurrentStreak,
      bestStreak: newBestStreak,
      lastActiveDate: now,
      nutritionProgress: updatedProgress,
      updatedAt: now,
    );
  }
  
  /// 获取今天的活动点数
  static int getTodayPoints(NutritionProfileV2 profile) {
    if (profile.nutritionProgress == null) return 0;
    
    final todayKey = _formatDateKey(DateTime.now());
    final todayData = profile.nutritionProgress![todayKey];
    
    if (todayData == null) return 0;
    return (todayData['totalPoints'] ?? 0) as int;
  }
  
  /// 获取本周活动天数
  static int getWeeklyActiveDays(NutritionProfileV2 profile) {
    if (profile.nutritionProgress == null) return 0;
    
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    int activeDays = 0;
    
    for (int i = 0; i < 7; i++) {
      final checkDate = weekStart.add(Duration(days: i));
      final dateKey = _formatDateKey(checkDate);
      
      if (profile.nutritionProgress!.containsKey(dateKey)) {
        final dayData = profile.nutritionProgress![dateKey];
        if ((dayData['totalPoints'] ?? 0) > 0) {
          activeDays++;
        }
      }
    }
    
    return activeDays;
  }
  
  /// 获取本月活动天数
  static int getMonthlyActiveDays(NutritionProfileV2 profile) {
    if (profile.nutritionProgress == null) return 0;
    
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    int activeDays = 0;
    
    for (int day = 1; day <= monthEnd.day; day++) {
      final checkDate = DateTime(now.year, now.month, day);
      final dateKey = _formatDateKey(checkDate);
      
      if (profile.nutritionProgress!.containsKey(dateKey)) {
        final dayData = profile.nutritionProgress![dateKey];
        if ((dayData['totalPoints'] ?? 0) > 0) {
          activeDays++;
        }
      }
    }
    
    return activeDays;
  }
  
  /// 获取激励信息
  static String getMotivationalMessage(NutritionProfileV2 profile) {
    final energyLevel = profile.energyLevel;
    final currentStreak = profile.currentStreak;
    final todayPoints = getTodayPoints(profile);
    
    // 基于连续天数的激励
    if (currentStreak >= 30) {
      return '🏆 连续${currentStreak}天！您是真正的营养大师！';
    } else if (currentStreak >= 14) {
      return '🔥 连续${currentStreak}天！您的坚持令人钦佩！';
    } else if (currentStreak >= 7) {
      return '⭐ 连续${currentStreak}天！保持这个节奏！';
    } else if (currentStreak >= 3) {
      return '💪 连续${currentStreak}天！您正在建立好习惯！';
    }
    
    // 基于等级的激励
    switch (energyLevel) {
      case 'diamond':
        return '💎 钻石等级！您已经达到营养管理的巅峰！';
      case 'platinum':
        return '🏆 铂金等级！您的营养知识和实践都很出色！';
      case 'gold':
        return '🥇 黄金等级！您在营养管理方面表现卓越！';
      case 'silver':
        return '🥈 白银等级！继续努力，黄金等级在向您招手！';
      case 'bronze':
        return '🥉 青铜等级！您已经开始建立健康的营养习惯！';
      default:
        return '🌱 新手上路！每一步都是进步的开始！';
    }
  }
  
  /// 获取下一等级所需点数
  static int getPointsToNextLevel(NutritionProfileV2 profile) {
    final currentLevel = profile.energyLevel;
    final currentPoints = profile.totalEnergyPoints;
    
    switch (currentLevel) {
      case 'starter':
        return 100 - currentPoints;
      case 'bronze':
        return 500 - currentPoints;
      case 'silver':
        return 1500 - currentPoints;
      case 'gold':
        return 3000 - currentPoints;
      case 'platinum':
        return 6000 - currentPoints;
      case 'diamond':
        return 0; // 已经是最高等级
      default:
        return 100 - currentPoints;
    }
  }
  
  /// 预设活动类型和对应点数
  static const Map<String, int> activityPoints = {
    'profile_create': 50,      // 创建档案
    'profile_complete': 30,    // 完善档案
    'profile_clone': 30,       // 克隆档案
    'meal_log': 10,           // 记录饮食
    'exercise_log': 15,       // 记录运动
    'weight_log': 10,         // 记录体重
    'goal_achieve': 25,       // 达成目标
    'consultation': 20,       // 营养咨询
    'education_read': 5,      // 阅读营养知识
    'recommendation_follow': 15, // 采纳AI建议
    'streak_bonus': 10,       // 连续活动奖励
  };
  
  /// 格式化日期为键值
  static String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}