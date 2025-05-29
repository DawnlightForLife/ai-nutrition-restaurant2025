import '../entities/nutrition_profile.dart';

/// 热量需求值对象
class CalorieRequirement {
  final double basalMetabolicRate; // 基础代谢率
  final double totalDailyEnergyExpenditure; // 每日总能量消耗

  const CalorieRequirement({
    required this.basalMetabolicRate,
    required this.totalDailyEnergyExpenditure,
  });

  /// 根据基本信息计算热量需求
  factory CalorieRequirement.calculate(BasicInfo basicInfo) {
    // 使用Mifflin-St Jeor公式计算基础代谢率
    double bmr;
    if (basicInfo.gender == Gender.male) {
      bmr = 10 * basicInfo.weight + 6.25 * basicInfo.height - 5 * basicInfo.age + 5;
    } else {
      bmr = 10 * basicInfo.weight + 6.25 * basicInfo.height - 5 * basicInfo.age - 161;
    }

    // 根据活动水平计算每日总能量消耗
    double activityFactor;
    switch (basicInfo.activityLevel) {
      case ActivityLevel.sedentary:
        activityFactor = 1.2;
        break;
      case ActivityLevel.light:
        activityFactor = 1.375;
        break;
      case ActivityLevel.moderate:
        activityFactor = 1.55;
        break;
      case ActivityLevel.active:
        activityFactor = 1.725;
        break;
      case ActivityLevel.veryActive:
        activityFactor = 1.9;
        break;
    }

    final tdee = bmr * activityFactor;

    return CalorieRequirement(
      basalMetabolicRate: bmr,
      totalDailyEnergyExpenditure: tdee,
    );
  }

  /// 减重目标的每日热量
  double get weightLossCalories => totalDailyEnergyExpenditure - 500;

  /// 增重目标的每日热量
  double get weightGainCalories => totalDailyEnergyExpenditure + 500;

  /// 维持体重的每日热量
  double get maintenanceCalories => totalDailyEnergyExpenditure;
}