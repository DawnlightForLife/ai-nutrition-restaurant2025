/**
 * 商家类型枚举模型
 * 定义系统中支持的所有商家类型常量
 * @module models/merchant/merchantTypeEnum
 */

const mongoose = require('mongoose');

// 商家类型枚举
const merchantTypes = {
  // 健身房类型
  gym: {
    value: 'gym',
    label: '健身房', 
    description: '提供健身设施和营养配餐服务的商家',
    features: ['fitnessEquipment', 'personalTraining', 'nutritionMenu', 'supplements'],
    allowCustomMeals: true
  },
  
  // 月子中心类型
  maternityCenter: {
    value: 'maternityCenter',
    label: '月子中心',
    description: '专为产后妈妈提供营养膳食和护理服务的机构',
    features: ['postpartumCare', 'babyNutrition', 'specialDiet', 'nursingSupport'],
    allowCustomMeals: true
  },
  
  // 营养餐厅类型
  restaurant: {
    value: 'restaurant',
    label: '营养餐厅',
    description: '专注于提供健康、营养平衡膳食的餐厅',
    features: ['healthyMeals', 'calorieCounting', 'specialDiets', 'freshIngredients'],
    allowCustomMeals: false
  },
  
  // 团体用户类型（学校、公司等）
  schoolCompany: {
    value: 'schoolCompany',
    label: '团体用户',
    description: '为学校、公司等团体提供批量营养餐服务的机构',
    features: ['bulkOrders', 'customizedMeals', 'regularSchedule', 'dietaryVariety'],
    allowCustomMeals: true
  }
};

// 枚举值数组（用于验证）
const merchantTypeValues = Object.values(merchantTypes).map(type => type.value);

// 枚举显示标签映射
const merchantTypeLabels = Object.fromEntries(
  Object.values(merchantTypes).map(type => [type.value, type.label])
);

// 按类型获取特征
const getFeaturesByType = (typeValue) => {
  const type = Object.values(merchantTypes).find(t => t.value === typeValue);
  return type ? type.features : [];
};

// 检查类型是否有效
const isValidMerchantType = (type) => merchantTypeValues.includes(type);

// 获取类型标签
const getMerchantTypeLabel = (type) => merchantTypeLabels[type] || '未知类型';

// 导出所有常量和辅助函数
module.exports = {
  merchantTypes,
  merchantTypeValues,
  merchantTypeLabels,
  getFeaturesByType,
  isValidMerchantType,
  getMerchantTypeLabel
}; 