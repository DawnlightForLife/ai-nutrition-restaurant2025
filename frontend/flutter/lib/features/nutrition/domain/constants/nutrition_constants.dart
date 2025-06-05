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
  
  // 营养目标
  static const List<String> nutritionGoals = [
    '减重',
    '增重',
    '维持',
    '增肌',
    '塑形',
  ];
  
  // 饮食偏好
  static const List<String> dietaryPreferences = [
    '无偏好',
    '素食',
    '纯素食',
    '低盐',
    '低脂',
    '低糖',
    '高蛋白',
  ];
  
  // 过敏原
  static const List<String> allergens = [
    '无过敏',
    '牛奶',
    '鸡蛋',
    '坚果',
    '海鲜',
    '大豆',
    '麸质',
  ];
  
  // 运动频率
  static const List<String> exerciseFrequency = [
    '久坐不动',
    '轻度活动',
    '中度活动',
    '高度活动',
    '专业运动员',
  ];
}