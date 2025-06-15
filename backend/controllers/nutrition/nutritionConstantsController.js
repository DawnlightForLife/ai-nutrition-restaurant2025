/**
 * 营养档案常量控制器
 * 提供营养档案相关的枚举常量API
 * @module controllers/nutrition/nutritionConstantsController
 */

const { 
  ETHNIC_DIETARY, 
  RELIGIOUS_DIETARY, 
  DIETARY_TYPES,
  EXERCISE_TYPES,
  TRAINING_INTENSITY,
  HEALTH_GOALS,
  DIETARY_LABELS
} = require('../../constants/dietaryRestrictions');
const { 
  ALL_CUISINES, 
  CUISINE_LABELS, 
  CUISINE_GROUPS 
} = require('../../constants/cuisineTypes');

/**
 * 获取所有营养档案相关常量
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const getAllConstants = async (req, res) => {
  try {
    res.json({
      success: true,
      data: {
        // 基础信息常量
        genders: [
          { value: 'male', label: '男' },
          { value: 'female', label: '女' },
          { value: 'other', label: '其他' }
        ],
        ageGroups: [
          { value: 'under18', label: '18岁以下' },
          { value: '18to25', label: '18-25岁' },
          { value: '26to35', label: '26-35岁' },
          { value: '36to45', label: '36-45岁' },
          { value: '46to55', label: '46-55岁' },
          { value: '56to65', label: '56-65岁' },
          { value: 'above65', label: '65岁以上' }
        ],
        activityLevels: [
          { value: 'sedentary', label: '久坐办公（每天活动<30分钟）' },
          { value: 'light', label: '轻度活动（每天30-60分钟）' },
          { value: 'moderate', label: '中度活动（每天1-2小时）' },
          { value: 'active', label: '高强度活动（每天>2小时）' },
          { value: 'very_active', label: '极高强度活动' },
          { value: 'professional', label: '专业运动员' }
        ],

        // 饮食偏好常量
        dietaryTypes: Object.entries(DIETARY_TYPES).map(([key, value]) => ({
          value,
          label: DIETARY_LABELS[value] || value
        })),
        ethnicDietary: Object.entries(ETHNIC_DIETARY).map(([key, value]) => ({
          value,
          label: DIETARY_LABELS[value] || value
        })),
        religiousDietary: Object.entries(RELIGIOUS_DIETARY).map(([key, value]) => ({
          value,
          label: DIETARY_LABELS[value] || value
        })),

        // 菜系偏好
        cuisines: {
          all: Object.entries(ALL_CUISINES).map(([key, value]) => ({
            value,
            label: CUISINE_LABELS[value] || value
          })),
          groups: {
            major: CUISINE_GROUPS.major.map(value => ({
              value,
              label: CUISINE_LABELS[value] || value
            })),
            regional: CUISINE_GROUPS.regional.map(value => ({
              value,
              label: CUISINE_LABELS[value] || value
            })),
            international: CUISINE_GROUPS.international.map(value => ({
              value,
              label: CUISINE_LABELS[value] || value
            }))
          }
        },

        // 口味偏好强度
        tasteIntensity: {
          spicy: [
            { value: 0, label: '不吃辣' },
            { value: 1, label: '微辣' },
            { value: 2, label: '中辣' },
            { value: 3, label: '特辣' },
            { value: 4, label: '变态辣' }
          ],
          salty: [
            { value: 0, label: '清淡' },
            { value: 1, label: '适中' },
            { value: 2, label: '偏咸' }
          ],
          sweet: [
            { value: 0, label: '不喜甜' },
            { value: 1, label: '微甜' },
            { value: 2, label: '嗜甜' }
          ],
          sour: [
            { value: 0, label: '不喜酸' },
            { value: 1, label: '适度' },
            { value: 2, label: '嗜酸' }
          ],
          oily: [
            { value: 0, label: '少油' },
            { value: 1, label: '适中' },
            { value: 2, label: '重油' }
          ]
        },

        // 运动相关
        exerciseTypes: Object.entries(EXERCISE_TYPES).map(([key, value]) => ({
          value,
          label: getExerciseTypeLabel(value)
        })),
        trainingIntensity: Object.entries(TRAINING_INTENSITY).map(([key, value]) => ({
          value,
          label: getTrainingIntensityLabel(value)
        })),
        exerciseFrequency: [
          { value: 'none', label: '从不运动' },
          { value: 'occasional', label: '偶尔运动' },
          { value: 'regular', label: '规律运动' },
          { value: 'intense', label: '高强度运动' },
          { value: 'frequent', label: '频繁运动' },
          { value: 'daily', label: '每日运动' }
        ],
        preferredExerciseTime: [
          { value: 'morning', label: '早晨' },
          { value: 'noon', label: '中午' },
          { value: 'afternoon', label: '下午' },
          { value: 'evening', label: '傍晚' },
          { value: 'night', label: '夜晚' }
        ],

        // 健康目标
        healthGoals: Object.entries(HEALTH_GOALS).map(([key, value]) => ({
          value,
          label: getHealthGoalLabel(value),
          category: getHealthGoalCategory(value)
        })),

        // 职业类型
        occupations: [
          { value: 'student', label: '学生' },
          { value: 'officeWorker', label: '办公室职员' },
          { value: 'physicalWorker', label: '体力劳动者' },
          { value: 'retired', label: '退休' },
          { value: 'other', label: '其他' }
        ]
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '获取常量失败',
      error: error.message
    });
  }
};

/**
 * 获取运动类型标签
 */
function getExerciseTypeLabel(value) {
  const labels = {
    running: '跑步',
    cycling: '骑行',
    swimming: '游泳',
    gym: '健身房训练',
    bodyweight: '自重训练',
    basketball: '篮球',
    football: '足球',
    badminton: '羽毛球',
    table_tennis: '乒乓球',
    tennis: '网球',
    boxing: '拳击',
    martial_arts: '武术',
    yoga: '瑜伽',
    pilates: '普拉提',
    dance: '舞蹈',
    team_sports: '团队运动',
    outdoor: '户外运动'
  };
  return labels[value] || value;
}

/**
 * 获取训练强度标签
 */
function getTrainingIntensityLabel(value) {
  const labels = {
    low: '低强度',
    moderate: '中等强度',
    high: '高强度',
    very_high: '极高强度'
  };
  return labels[value] || value;
}

/**
 * 获取健康目标标签
 */
function getHealthGoalLabel(value) {
  const labels = {
    weight_loss: '减重',
    weight_gain: '增重',
    weight_maintain: '保持体重',
    fat_loss: '减脂',
    muscle_gain: '增肌',
    body_recomposition: '塑形',
    blood_sugar_control: '血糖控制',
    blood_pressure_control: '血压管理',
    cholesterol_management: '血脂管理',
    pregnancy: '孕期营养',
    lactation: '哺乳期营养',
    menopause: '更年期营养',
    gut_health: '肠道健康',
    digestion_improvement: '改善消化',
    immunity_boost: '提升免疫力',
    energy_boost: '提升能量',
    sports_performance: '运动表现',
    anti_aging: '抗衰老',
    mental_health: '心理健康'
  };
  return labels[value] || value;
}

/**
 * 获取健康目标分类
 */
function getHealthGoalCategory(value) {
  const categories = {
    weight_loss: '体重管理',
    weight_gain: '体重管理',
    weight_maintain: '体重管理',
    fat_loss: '身体成分',
    muscle_gain: '身体成分',
    body_recomposition: '身体成分',
    blood_sugar_control: '慢性病管理',
    blood_pressure_control: '慢性病管理',
    cholesterol_management: '慢性病管理',
    pregnancy: '特殊生理期',
    lactation: '特殊生理期',
    menopause: '特殊生理期',
    gut_health: '消化健康',
    digestion_improvement: '消化健康',
    immunity_boost: '免疫与抗炎',
    energy_boost: '其他',
    sports_performance: '运动营养',
    anti_aging: '其他',
    mental_health: '其他'
  };
  return categories[value] || '其他';
}

module.exports = {
  getAllConstants
};