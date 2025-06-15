/// 营养相关常量定义
class NutritionConstants {
  // 营养档案相关
  static const int maxProfiles = 5;
  static const int minAge = 1;
  static const int maxAge = 120;
  static const double minHeight = 50.0;
  static const double maxHeight = 250.0;
  static const double minWeight = 20.0;
  static const double maxWeight = 200.0;
  
  // 性别选项
  static const Map<String, String> genderOptions = {
    'male': '男',
    'female': '女',
    'other': '其他',
  };
  
  // 年龄段
  static const Map<String, String> ageGroupOptions = {
    'under18': '18岁以下',
    '18to25': '18-25岁',
    '26to35': '26-35岁',
    '36to45': '36-45岁',
    '46to55': '46-55岁',
    '56to65': '56-65岁',
    'above65': '65岁以上',
  };
  
  // 活动水平
  static const Map<String, String> activityLevels = {
    'sedentary': '久坐（每天活动<30分钟）',
    'light': '轻度活动（每天30-60分钟）',
    'moderate': '中度活动（每天1-2小时）',
    'active': '高强度活动（每天2-3小时）',
    'very_active': '极高强度活动（每天>3小时）',
    'professional': '专业运动员',
  };
  
  /// 活动水平详细说明
  static const Map<String, String> activityLevelDetails = {
    'less_than_30min': '久坐办公（每天活动<30分钟）',
    '30_to_60min': '轻度活动（每天30-60分钟）',
    '1_to_2hours': '中度活动（每天1-2小时）',
    '2_to_3hours': '高强度活动（每天2-3小时）',
    'more_than_3hours': '极高强度（每天>3小时）',
    'professional_athlete': '专业运动员',
  };
  
  // 饮食类型
  static const Map<String, String> dietaryTypes = {
    'omnivore': '杂食',
    'vegetarian': '素食',
    'vegan': '纯素食',
    'pescatarian': '鱼素食',
    'flexitarian': '弹性素食',
    'lacto_vegetarian': '奶素',
    'ovo_vegetarian': '蛋素',
    'lacto_ovo_vegetarian': '蛋奶素',
    'raw_food': '生食',
    'paleo': '原始饮食',
    'keto': '生酮饮食',
    'low_carb': '低碳水',
    'mediterranean': '地中海饮食',
  };
  
  // 八大菜系
  static const Map<String, String> majorCuisines = {
    'sichuan': '川菜',
    'cantonese': '粤菜',
    'shandong': '鲁菜',
    'jiangsu': '苏菜',
    'zhejiang': '浙菜',
    'fujian': '闽菜',
    'hunan': '湘菜',
    'anhui': '徽菜',
  };
  
  // 地方特色菜系
  static const Map<String, String> regionalCuisines = {
    'northeast': '东北菜',
    'northwest': '西北菜',
    'yunnan': '云南菜',
    'guizhou': '贵州菜',
    'jiangxi': '江西菜',
    'taiwan': '台湾菜',
    'beijing': '京菜',
    'shanghai': '沪菜',
    'xinjiang': '新疆菜',
    'tibet': '藏菜',
    'inner_mongolia': '内蒙菜',
  };
  
  // 民族饮食习惯
  static const Map<String, String> ethnicDietary = {
    'han': '汉族',
    'hui': '回族（清真）',
    'tibetan': '藏族',
    'uyghur': '维吾尔族',
    'mongolian': '蒙古族',
    'zhuang': '壮族',
    'manchu': '满族',
    'yi': '彝族',
    'miao': '苗族',
    'dai': '傣族',
  };
  
  // 宗教饮食要求
  static const Map<String, String> religiousDietary = {
    'halal': '清真饮食',
    'buddhist': '佛教素食',
    'hindu': '印度教饮食',
    'jewish': '犹太洁食',
    'christian': '基督教',
    'taoist': '道教饮食',
  };
  
  // 口味强度级别
  static const Map<String, List<String>> tasteIntensity = {
    'spicy': ['不吃辣', '微辣', '中辣', '特辣', '变态辣'],
    'salty': ['清淡', '适中', '偏咸'],
    'sweet': ['不喜甜', '微甜', '嗜甜'],
    'sour': ['不喜酸', '适度', '嗜酸'],
    'oily': ['少油', '适中', '重油'],
  };
  
  // 运动类型
  static const Map<String, String> exerciseTypes = {
    // 耐力运动
    'running': '跑步',
    'cycling': '骑行',
    'swimming': '游泳',
    // 力量训练
    'gym': '健身房训练',
    'bodyweight': '自重训练',
    // 球类运动
    'basketball': '篮球',
    'football': '足球',
    'badminton': '羽毛球',
    'table_tennis': '乒乓球',
    'tennis': '网球',
    // 搏击类
    'boxing': '拳击',
    'martial_arts': '武术',
    // 其他
    'yoga': '瑜伽',
    'pilates': '普拉提',
    'dance': '舞蹈',
    'team_sports': '团队运动',
    'outdoor': '户外运动',
  };
  
  // 训练强度
  static const Map<String, String> trainingIntensity = {
    'low': '低强度',
    'moderate': '中等强度',
    'high': '高强度',
    'very_high': '极高强度',
  };
  
  // 健康目标
  static const Map<String, String> healthGoalOptions = {
    // 体重管理
    'weight_loss': '减重',
    'weight_gain': '增重',
    'weight_maintain': '保持体重',
    // 身体成分
    'fat_loss': '减脂',
    'muscle_gain': '增肌',
    'body_recomposition': '塑形',
    // 慢性病管理
    'blood_sugar_control': '血糖控制',
    'blood_pressure_control': '血压管理',
    'cholesterol_management': '血脂管理',
    // 特殊生理期
    'pregnancy': '孕期营养',
    'lactation': '哺乳期营养',
    'menopause': '更年期营养',
    // 消化健康
    'gut_health': '肠道健康',
    'digestion_improvement': '改善消化',
    // 其他
    'immunity_boost': '提升免疫力',
    'energy_boost': '提升能量',
    'sports_performance': '运动表现',
    'anti_aging': '抗衰老',
    'mental_health': '心理健康',
  };
  
  // 运动频率
  static const Map<String, String> exerciseFrequency = {
    'none': '不运动',
    'occasional': '偶尔运动',
    'regular': '规律运动',
    'intense': '高强度运动',
    'frequent': '频繁运动',
    'daily': '每天运动',
  };
  
  // 运动时段偏好
  static const Map<String, String> exerciseTimePreference = {
    'morning': '早晨',
    'noon': '中午',
    'afternoon': '下午',
    'evening': '晚上',
    'night': '深夜',
  };
  
  // 糖尿病类型
  static const Map<String, String> diabetesTypes = {
    'type1': '1型糖尿病',
    'type2': '2型糖尿病',
    'gestational': '妊娠期糖尿病',
    'none': '无糖尿病',
  };
  
  // 用药情况
  static const Map<String, String> medicationStatus = {
    'insulin': '胰岛素',
    'oral': '口服药',
    'diet_only': '仅饮食控制',
    'none': '无用药',
  };
  
  // 监测频率
  static const Map<String, String> monitoringFrequency = {
    'daily': '每日',
    'weekly': '每周',
    'monthly': '每月',
  };
  
  // 高血压分级
  static const Map<String, String> hypertensionGrades = {
    'normal': '正常',
    'elevated': '偏高',
    'stage1': '1级高血压',
    'stage2': '2级高血压',
    'stage3': '3级高血压',
  };
  
  // 体重管理目标类型
  static const Map<String, String> weightGoalTypes = {
    'loss': '减重',
    'gain': '增重',
    'maintain': '维持',
    'recomposition': '重塑',
  };
  
  // 目标速度
  static const Map<String, String> targetSpeeds = {
    'conservative': '保守(0.5kg/周)',
    'moderate': '标准(1kg/周)',
    'aggressive': '激进(1.5kg/周)',
  };
  
  // 常见过敏原
  static const List<String> commonAllergens = [
    '牛奶',
    '鸡蛋',
    '花生',
    '树坚果',
    '大豆',
    '小麦/麸质',
    '鱼类',
    '贝类',
    '芝麻',
  ];
  
  // 消化系统症状
  static const Map<String, String> digestiveSymptoms = {
    'bloating': '腹胀',
    'constipation': '便秘',
    'diarrhea': '腹泻',
    'acid_reflux': '反酸',
    'ibs': '肠易激综合征',
    'ibd': '炎症性肠病',
  };

  // 饮食偏好选项
  static const Map<String, String> dietaryPreferenceOptions = {
    'vegetarian': '素食',
    'vegan': '纯素食',
    'lowCarb': '低碳水',
    'glutenFree': '无麸质',
    'dairyFree': '无乳制品',
    'keto': '生酮',
    'paleo': '原始饮食',
    'halal': '清真',
    'kosher': '犹太洁食',
  };

  // 疾病史选项
  static const Map<String, String> medicalConditionOptions = {
    'diabetes': '糖尿病',
    'hypertension': '高血压',
    'heart_disease': '心脏病',
    'kidney_disease': '肾病',
    'liver_disease': '肝病',
    'gastric_issues': '胃病',
    'thyroid': '甲状腺疾病',
    'cancer': '癌症',
    'other': '其他',
  };

  // 运动频率选项
  static const Map<String, String> exerciseFrequencyOptions = {
    'never': '从不运动',
    'rarely': '很少运动（每周1次以下）',
    'sometimes': '偶尔运动（每周1-2次）',
    'moderate': '适度运动（每周3-4次）',
    'frequent': '经常运动（每周5-6次）',
    'daily': '每天运动',
  };

  // 营养偏向选项
  static const Map<String, String> nutritionPreferenceOptions = {
    'high_protein': '高蛋白',
    'low_fat': '低脂肪',
    'high_fiber': '高纤维',
    'low_sodium': '低钠',
    'balanced': '均衡',
    'plant_based': '植物性',
  };

  // 特殊状态选项
  static const Map<String, String> specialStatusOptions = {
    'pregnancy': '怀孕',
    'lactation': '哺乳期',
    'athlete': '运动员',
    'elderly': '老年人',
    'recovery': '康复期',
    'none': '无',
  };

  // 过敏原选项
  static const Map<String, String> allergyOptions = {
    'milk': '牛奶',
    'eggs': '鸡蛋',
    'peanuts': '花生',
    'tree_nuts': '坚果',
    'soy': '大豆',
    'wheat': '小麦',
    'fish': '鱼类',
    'shellfish': '贝类',
    'sesame': '芝麻',
  };

  // 禁忌食材选项
  static const Map<String, String> forbiddenIngredientOptions = {
    'pork': '猪肉',
    'beef': '牛肉',
    'alcohol': '酒精',
    'caffeine': '咖啡因',
    'spicy': '辛辣',
    'garlic': '大蒜',
    'onion': '洋葱',
    'mushroom': '蘑菇',
  };
}