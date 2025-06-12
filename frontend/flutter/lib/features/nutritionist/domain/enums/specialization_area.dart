/// 专业领域枚举
enum SpecializationArea {
  /// 临床营养
  clinicalNutrition('clinical_nutrition', '临床营养'),
  
  /// 公共营养
  publicNutrition('public_nutrition', '公共营养'),
  
  /// 食品营养
  foodNutrition('food_nutrition', '食品营养'),
  
  /// 运动营养
  sportsNutrition('sports_nutrition', '运动营养'),
  
  /// 妇幼营养
  maternalChild('maternal_child', '妇幼营养'),
  
  /// 老年营养
  elderlyNutrition('elderly_nutrition', '老年营养'),
  
  /// 体重管理
  weightManagement('weight_management', '体重管理');

  final String value;
  final String label;

  const SpecializationArea(this.value, this.label);

  /// 从字符串值获取枚举
  static SpecializationArea fromValue(String value) {
    return SpecializationArea.values.firstWhere(
      (area) => area.value == value,
      orElse: () => SpecializationArea.publicNutrition,
    );
  }

  /// 获取图标名称
  String get iconName {
    switch (this) {
      case SpecializationArea.clinicalNutrition:
        return 'medical_services';
      case SpecializationArea.publicNutrition:
        return 'groups';
      case SpecializationArea.foodNutrition:
        return 'restaurant';
      case SpecializationArea.sportsNutrition:
        return 'fitness_center';
      case SpecializationArea.maternalChild:
        return 'child_care';
      case SpecializationArea.elderlyNutrition:
        return 'elderly';
      case SpecializationArea.weightManagement:
        return 'monitor_weight';
    }
  }

  /// 获取描述
  String get description {
    switch (this) {
      case SpecializationArea.clinicalNutrition:
        return '医院临床营养支持，疾病营养治疗';
      case SpecializationArea.publicNutrition:
        return '社区营养教育，公共健康促进';
      case SpecializationArea.foodNutrition:
        return '食品营养成分分析，配方研发';
      case SpecializationArea.sportsNutrition:
        return '运动员营养支持，健身营养指导';
      case SpecializationArea.maternalChild:
        return '孕产妇及婴幼儿营养管理';
      case SpecializationArea.elderlyNutrition:
        return '老年人营养评估与干预';
      case SpecializationArea.weightManagement:
        return '肥胖与体重控制营养方案';
    }
  }
}