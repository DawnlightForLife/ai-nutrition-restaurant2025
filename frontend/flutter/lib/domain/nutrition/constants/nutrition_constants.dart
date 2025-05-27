/// 营养档案相关常量
class NutritionConstants {
  // 性别选项
  static const genderOptions = {
    'male': '男',
    'female': '女',
    'other': '其他',
  };

  // 年龄段选项
  static const ageGroupOptions = {
    'under18': '18岁以下',
    '18to30': '18-30岁',
    '31to45': '31-45岁',
    '46to60': '46-60岁',
    'over60': '60岁以上',
  };

  // 活动水平选项
  static const activityLevelOptions = {
    'sedentary': '久坐少动',
    'light': '轻度活动',
    'moderate': '中度活动',
    'active': '经常运动',
    'veryActive': '高强度运动',
  };

  // 健康目标
  static const healthGoalOptions = {
    'loseWeight': '减脂瘦身',
    'gainMuscle': '增肌塑形',
    'maintainWeight': '保持体重',
    'improveHealth': '改善健康',
    'balancedNutrition': '均衡营养',
    'sportPerformance': '运动表现',
  };

  // 饮食偏好（多选）
  static const dietaryPreferenceOptions = {
    'vegetarian': '素食',
    'vegan': '纯素食',
    'light': '清淡',
    'noSpicy': '不吃辣',
    'highProtein': '高蛋白',
    'lowCarb': '低碳水',
    'lowFat': '低脂肪',
    'lowSodium': '低钠',
    'glutenFree': '无麸质',
    'lactoseFree': '无乳糖',
  };

  // 运动频率
  static const exerciseFrequencyOptions = {
    'never': '从不运动',
    'occasional': '偶尔运动（每周1-2次）',
    'regular': '规律运动（每周3-4次）',
    'frequent': '经常运动（每周5-6次）',
    'daily': '每天运动',
  };

  // 营养偏向
  static const nutritionPreferenceOptions = {
    'balanced': '均衡营养',
    'highProtein': '高蛋白质',
    'highFiber': '高膳食纤维',
    'lowGI': '低升糖指数',
    'antiInflammatory': '抗炎饮食',
    'mediterranean': '地中海饮食',
    'keto': '生酮饮食',
  };

  // 特殊状态
  static const specialStatusOptions = {
    'pregnancy': '孕期',
    'lactation': '哺乳期',
    'athlete': '运动员',
    'elderly': '老年人',
    'teenager': '青少年',
    'nightShift': '夜班工作者',
  };

  // 常见疾病
  static const medicalConditionOptions = {
    'diabetes': '糖尿病',
    'hypertension': '高血压',
    'hyperlipidemia': '高血脂',
    'gout': '痛风',
    'kidneyDisease': '肾脏疾病',
    'liverDisease': '肝脏疾病',
    'heartDisease': '心脏病',
    'digestiveDisorder': '消化系统疾病',
    'anemia': '贫血',
    'osteoporosis': '骨质疏松',
  };

  // 常见过敏原
  static const allergyOptions = {
    'milk': '牛奶',
    'eggs': '鸡蛋',
    'peanuts': '花生',
    'treeNuts': '坚果',
    'wheat': '小麦',
    'soy': '大豆',
    'fish': '鱼类',
    'shellfish': '贝类',
    'sesame': '芝麻',
  };

  // 禁忌食材
  static const forbiddenIngredientOptions = {
    'pork': '猪肉',
    'beef': '牛肉',
    'chicken': '鸡肉',
    'seafood': '海鲜',
    'mushroom': '蘑菇',
    'onion': '洋葱',
    'garlic': '大蒜',
    'coriander': '香菜',
    'greenPepper': '青椒',
    'chili': '辣椒',
  };
}