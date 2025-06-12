/// 认证等级枚举
enum CertificationLevel {
  /// 注册营养师(RD)
  registeredDietitian('registered_dietitian', '注册营养师(RD)'),
  
  /// 注册营养技师(DTR)
  dieteticTechnician('dietetic_technician', '注册营养技师(DTR)'),
  
  /// 公共营养师四级
  publicNutritionistL4('public_nutritionist_l4', '公共营养师四级'),
  
  /// 公共营养师三级
  publicNutritionistL3('public_nutritionist_l3', '公共营养师三级'),
  
  /// 营养管理师
  nutritionManager('nutrition_manager', '营养管理师');

  final String value;
  final String label;

  const CertificationLevel(this.value, this.label);

  /// 从字符串值获取枚举
  static CertificationLevel fromValue(String value) {
    return CertificationLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => CertificationLevel.publicNutritionistL4,
    );
  }

  /// 获取等级排序
  int get sortOrder {
    switch (this) {
      case CertificationLevel.registeredDietitian:
        return 1;
      case CertificationLevel.dieteticTechnician:
        return 2;
      case CertificationLevel.publicNutritionistL3:
        return 3;
      case CertificationLevel.publicNutritionistL4:
        return 4;
      case CertificationLevel.nutritionManager:
        return 5;
    }
  }

  /// 获取所需学历要求
  List<String> get educationRequirements {
    switch (this) {
      case CertificationLevel.registeredDietitian:
        return ['bachelor', 'master', 'doctoral'];
      case CertificationLevel.dieteticTechnician:
        return ['associate', 'bachelor', 'master', 'doctoral'];
      case CertificationLevel.publicNutritionistL3:
        return ['bachelor', 'master', 'doctoral'];
      case CertificationLevel.publicNutritionistL4:
        return ['technical_secondary', 'associate', 'bachelor'];
      case CertificationLevel.nutritionManager:
        return ['associate', 'bachelor', 'master', 'doctoral'];
    }
  }

  /// 获取所需工作经验（年）
  int get workExperienceYears {
    switch (this) {
      case CertificationLevel.registeredDietitian:
        return 2;
      case CertificationLevel.dieteticTechnician:
        return 1;
      case CertificationLevel.publicNutritionistL3:
        return 2;
      case CertificationLevel.publicNutritionistL4:
        return 1;
      case CertificationLevel.nutritionManager:
        return 1;
    }
  }
}