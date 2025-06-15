/**
 * 饮食限制和偏好常量定义
 * @module constants/dietaryRestrictions
 */

// 民族饮食习惯
const ETHNIC_DIETARY = {
  HAN: 'han',              // 汉族
  HUI: 'hui',              // 回族（清真）
  TIBETAN: 'tibetan',      // 藏族
  UYGHUR: 'uyghur',        // 维吾尔族
  MONGOLIAN: 'mongolian',  // 蒙古族
  ZHUANG: 'zhuang',        // 壮族
  MANCHU: 'manchu',        // 满族
  YI: 'yi',                // 彝族
  MIAO: 'miao',            // 苗族
  DAI: 'dai'               // 傣族
};

// 宗教饮食要求
const RELIGIOUS_DIETARY = {
  HALAL: 'halal',          // 清真（伊斯兰教）
  BUDDHIST: 'buddhist',    // 佛教素食
  HINDU: 'hindu',          // 印度教
  JEWISH: 'jewish',        // 犹太洁食
  CHRISTIAN: 'christian',  // 基督教（一般无特殊限制）
  TAOIST: 'taoist'         // 道教
};

// 饮食类型
const DIETARY_TYPES = {
  OMNIVORE: 'omnivore',           // 杂食
  VEGETARIAN: 'vegetarian',       // 素食（可吃蛋奶）
  VEGAN: 'vegan',                 // 纯素食
  PESCATARIAN: 'pescatarian',     // 鱼素食
  FLEXITARIAN: 'flexitarian',     // 弹性素食
  LACTO_VEGETARIAN: 'lacto_vegetarian',       // 奶素
  OVO_VEGETARIAN: 'ovo_vegetarian',           // 蛋素
  LACTO_OVO_VEGETARIAN: 'lacto_ovo_vegetarian', // 蛋奶素
  RAW_FOOD: 'raw_food',           // 生食
  PALEO: 'paleo',                 // 原始饮食
  KETO: 'keto',                   // 生酮饮食
  LOW_CARB: 'low_carb',           // 低碳水
  MEDITERRANEAN: 'mediterranean'   // 地中海饮食
};

// 口味强度级别
const TASTE_INTENSITY = {
  SPICY: {
    NONE: 0,      // 不吃辣
    MILD: 1,      // 微辣
    MEDIUM: 2,    // 中辣
    HOT: 3,       // 特辣
    EXTREME: 4    // 变态辣
  },
  SALTY: {
    LIGHT: 0,     // 清淡
    NORMAL: 1,    // 适中
    HEAVY: 2      // 偏咸
  },
  SWEET: {
    NONE: 0,      // 不喜甜
    MILD: 1,      // 微甜
    HEAVY: 2      // 嗜甜
  },
  SOUR: {
    NONE: 0,      // 不喜酸
    NORMAL: 1,    // 适度
    HEAVY: 2      // 嗜酸
  },
  OIL: {
    LIGHT: 0,     // 少油
    NORMAL: 1,    // 适中
    HEAVY: 2      // 重油
  }
};

// 运动类型
const EXERCISE_TYPES = {
  // 耐力运动
  RUNNING: 'running',              // 跑步
  CYCLING: 'cycling',              // 骑行
  SWIMMING: 'swimming',            // 游泳
  // 力量训练
  GYM: 'gym',                      // 健身房训练
  BODYWEIGHT: 'bodyweight',        // 自重训练
  // 球类运动
  BASKETBALL: 'basketball',        // 篮球
  FOOTBALL: 'football',            // 足球
  BADMINTON: 'badminton',          // 羽毛球
  TABLE_TENNIS: 'table_tennis',    // 乒乓球
  TENNIS: 'tennis',                // 网球
  // 搏击类
  BOXING: 'boxing',                // 拳击
  MARTIAL_ARTS: 'martial_arts',    // 武术
  // 其他
  YOGA: 'yoga',                    // 瑜伽
  PILATES: 'pilates',              // 普拉提
  DANCE: 'dance',                  // 舞蹈
  TEAM_SPORTS: 'team_sports',      // 团队运动
  OUTDOOR: 'outdoor'               // 户外运动
};

// 训练强度
const TRAINING_INTENSITY = {
  LOW: 'low',                      // 低强度
  MODERATE: 'moderate',            // 中等强度
  HIGH: 'high',                    // 高强度
  VERY_HIGH: 'very_high'           // 极高强度
};

// 活动水平详细说明
const ACTIVITY_LEVEL_DETAILS = {
  LESS_THAN_30MIN: 'less_than_30min',           // 每天活动<30分钟（久坐办公）
  THIRTY_TO_60MIN: '30_to_60min',               // 每天30-60分钟（轻度活动）
  ONE_TO_2HOURS: '1_to_2hours',                 // 每天1-2小时（中度活动）
  TWO_TO_3HOURS: '2_to_3hours',                 // 每天2-3小时（高强度活动）
  MORE_THAN_3HOURS: 'more_than_3hours',         // 每天>3小时（极高强度）
  PROFESSIONAL_ATHLETE: 'professional_athlete'   // 专业运动员
};

// 健康目标类型
const HEALTH_GOALS = {
  // 体重管理
  WEIGHT_LOSS: 'weight_loss',               // 减重
  WEIGHT_GAIN: 'weight_gain',               // 增重
  WEIGHT_MAINTAIN: 'weight_maintain',       // 保持体重
  // 身体成分
  FAT_LOSS: 'fat_loss',                     // 减脂
  MUSCLE_GAIN: 'muscle_gain',               // 增肌
  BODY_RECOMPOSITION: 'body_recomposition', // 塑形
  // 慢性病管理
  BLOOD_SUGAR_CONTROL: 'blood_sugar_control',     // 血糖控制
  BLOOD_PRESSURE_CONTROL: 'blood_pressure_control', // 血压管理
  CHOLESTEROL_MANAGEMENT: 'cholesterol_management', // 血脂管理
  // 特殊生理期
  PREGNANCY: 'pregnancy',                   // 孕期营养
  LACTATION: 'lactation',                   // 哺乳期营养
  MENOPAUSE: 'menopause',                   // 更年期营养
  // 消化健康
  GUT_HEALTH: 'gut_health',                 // 肠道健康
  DIGESTION_IMPROVEMENT: 'digestion_improvement', // 改善消化
  // 其他
  IMMUNITY_BOOST: 'immunity_boost',         // 提升免疫力
  ENERGY_BOOST: 'energy_boost',             // 提升能量
  SPORTS_PERFORMANCE: 'sports_performance', // 运动表现
  ANTI_AGING: 'anti_aging',                 // 抗衰老
  MENTAL_HEALTH: 'mental_health'            // 心理健康
};

// 标签映射
const DIETARY_LABELS = {
  // 民族饮食
  [ETHNIC_DIETARY.HAN]: '汉族',
  [ETHNIC_DIETARY.HUI]: '回族',
  [ETHNIC_DIETARY.TIBETAN]: '藏族',
  [ETHNIC_DIETARY.UYGHUR]: '维吾尔族',
  [ETHNIC_DIETARY.MONGOLIAN]: '蒙古族',
  [ETHNIC_DIETARY.ZHUANG]: '壮族',
  [ETHNIC_DIETARY.MANCHU]: '满族',
  [ETHNIC_DIETARY.YI]: '彝族',
  [ETHNIC_DIETARY.MIAO]: '苗族',
  [ETHNIC_DIETARY.DAI]: '傣族',
  // 宗教饮食
  [RELIGIOUS_DIETARY.HALAL]: '清真饮食',
  [RELIGIOUS_DIETARY.BUDDHIST]: '佛教素食',
  [RELIGIOUS_DIETARY.HINDU]: '印度教饮食',
  [RELIGIOUS_DIETARY.JEWISH]: '犹太洁食',
  [RELIGIOUS_DIETARY.CHRISTIAN]: '基督教',
  [RELIGIOUS_DIETARY.TAOIST]: '道教饮食',
  // 活动水平详情
  [ACTIVITY_LEVEL_DETAILS.LESS_THAN_30MIN]: '久坐办公（每天活动<30分钟）',
  [ACTIVITY_LEVEL_DETAILS.THIRTY_TO_60MIN]: '轻度活动（每天30-60分钟）',
  [ACTIVITY_LEVEL_DETAILS.ONE_TO_2HOURS]: '中度活动（每天1-2小时）',
  [ACTIVITY_LEVEL_DETAILS.TWO_TO_3HOURS]: '高强度活动（每天2-3小时）',
  [ACTIVITY_LEVEL_DETAILS.MORE_THAN_3HOURS]: '极高强度（每天>3小时）',
  [ACTIVITY_LEVEL_DETAILS.PROFESSIONAL_ATHLETE]: '专业运动员',
  // 饮食类型
  [DIETARY_TYPES.OMNIVORE]: '杂食',
  [DIETARY_TYPES.VEGETARIAN]: '素食',
  [DIETARY_TYPES.VEGAN]: '纯素食',
  [DIETARY_TYPES.PESCATARIAN]: '鱼素食',
  [DIETARY_TYPES.FLEXITARIAN]: '弹性素食',
  [DIETARY_TYPES.LACTO_VEGETARIAN]: '奶素',
  [DIETARY_TYPES.OVO_VEGETARIAN]: '蛋素',
  [DIETARY_TYPES.LACTO_OVO_VEGETARIAN]: '蛋奶素',
  [DIETARY_TYPES.RAW_FOOD]: '生食',
  [DIETARY_TYPES.PALEO]: '原始饮食',
  [DIETARY_TYPES.KETO]: '生酮饮食',
  [DIETARY_TYPES.LOW_CARB]: '低碳水',
  [DIETARY_TYPES.MEDITERRANEAN]: '地中海饮食'
};

module.exports = {
  ETHNIC_DIETARY,
  RELIGIOUS_DIETARY,
  DIETARY_TYPES,
  TASTE_INTENSITY,
  EXERCISE_TYPES,
  TRAINING_INTENSITY,
  ACTIVITY_LEVEL_DETAILS,
  HEALTH_GOALS,
  DIETARY_LABELS
};