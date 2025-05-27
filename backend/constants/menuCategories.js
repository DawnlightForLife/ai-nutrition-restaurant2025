/**
 * 元气立方统一菜单分类标准
 */
module.exports = {
  // 主分类
  MAIN_CATEGORIES: {
    FITNESS: {
      value: 'fitness',
      label: '健身营养餐',
      icon: 'fitness',
      description: '专为健身人群设计的高蛋白、均衡营养餐',
      subcategories: {
        MUSCLE_BUILDING: {
          value: 'muscle_building',
          label: '增肌餐',
          nutritionFocus: ['high_protein', 'moderate_carb']
        },
        FAT_LOSS: {
          value: 'fat_loss',
          label: '减脂餐',
          nutritionFocus: ['low_fat', 'high_fiber']
        },
        MAINTENANCE: {
          value: 'maintenance',
          label: '塑形餐',
          nutritionFocus: ['balanced']
        },
        PRE_WORKOUT: {
          value: 'pre_workout',
          label: '训前餐',
          nutritionFocus: ['quick_energy', 'moderate_carb']
        },
        POST_WORKOUT: {
          value: 'post_workout',
          label: '训后餐',
          nutritionFocus: ['protein_recovery', 'anti_inflammatory']
        }
      }
    },
    
    PREGNANCY: {
      value: 'pregnancy',
      label: '孕产营养餐',
      icon: 'pregnancy',
      description: '为备孕、孕期、产后女性提供的专业营养餐',
      subcategories: {
        PRE_PREGNANCY: {
          value: 'pre_pregnancy',
          label: '备孕餐',
          nutritionFocus: ['folic_acid', 'iron_rich']
        },
        PREGNANCY_EARLY: {
          value: 'pregnancy_early',
          label: '孕早期餐',
          nutritionFocus: ['anti_nausea', 'light']
        },
        PREGNANCY_MID: {
          value: 'pregnancy_mid',
          label: '孕中期餐',
          nutritionFocus: ['calcium_rich', 'dha']
        },
        PREGNANCY_LATE: {
          value: 'pregnancy_late',
          label: '孕晚期餐',
          nutritionFocus: ['iron_rich', 'fiber']
        },
        POSTPARTUM: {
          value: 'postpartum',
          label: '月子餐',
          nutritionFocus: ['recovery', 'lactation_support']
        }
      }
    },
    
    STUDENT: {
      value: 'student',
      label: '学生营养餐',
      icon: 'student',
      description: '为学生群体提供的成长营养餐',
      subcategories: {
        PRIMARY: {
          value: 'primary',
          label: '小学生餐',
          nutritionFocus: ['growth', 'brain_development']
        },
        MIDDLE: {
          value: 'middle',
          label: '初中生餐',
          nutritionFocus: ['balanced', 'calcium_rich']
        },
        HIGH: {
          value: 'high',
          label: '高中生餐',
          nutritionFocus: ['brain_boost', 'stress_relief']
        },
        EXAM_PREP: {
          value: 'exam_prep',
          label: '考试营养餐',
          nutritionFocus: ['memory_enhance', 'concentration']
        }
      }
    },
    
    WELLNESS: {
      value: 'wellness',
      label: '养生调理餐',
      icon: 'wellness',
      description: '日常养生和特殊调理需求',
      subcategories: {
        IMMUNITY: {
          value: 'immunity',
          label: '免疫力提升',
          nutritionFocus: ['vitamin_c', 'antioxidants']
        },
        ANTI_AGING: {
          value: 'anti_aging',
          label: '抗衰老餐',
          nutritionFocus: ['antioxidants', 'collagen']
        },
        DIGESTIVE: {
          value: 'digestive',
          label: '肠胃调理',
          nutritionFocus: ['probiotics', 'fiber']
        },
        SLEEP_AID: {
          value: 'sleep_aid',
          label: '助眠餐',
          nutritionFocus: ['tryptophan', 'magnesium']
        },
        DETOX: {
          value: 'detox',
          label: '排毒餐',
          nutritionFocus: ['cleansing', 'hydration']
        }
      }
    },
    
    MEDICAL: {
      value: 'medical',
      label: '医疗营养餐',
      icon: 'medical',
      description: '特殊医疗需求的营养配餐',
      subcategories: {
        DIABETES: {
          value: 'diabetes',
          label: '糖尿病餐',
          nutritionFocus: ['low_gi', 'sugar_control']
        },
        HYPERTENSION: {
          value: 'hypertension',
          label: '高血压餐',
          nutritionFocus: ['low_sodium', 'potassium_rich']
        },
        HEART_HEALTHY: {
          value: 'heart_healthy',
          label: '心脏健康餐',
          nutritionFocus: ['low_cholesterol', 'omega3']
        },
        KIDNEY_CARE: {
          value: 'kidney_care',
          label: '肾脏护理餐',
          nutritionFocus: ['low_phosphorus', 'protein_controlled']
        }
      }
    }
  },
  
  // 餐次分类
  MEAL_TYPES: {
    BREAKFAST: {
      value: 'breakfast',
      label: '早餐',
      timeRange: '06:00-10:00'
    },
    LUNCH: {
      value: 'lunch',
      label: '午餐',
      timeRange: '11:00-14:00'
    },
    DINNER: {
      value: 'dinner',
      label: '晚餐',
      timeRange: '17:00-20:00'
    },
    SNACK: {
      value: 'snack',
      label: '加餐/点心',
      timeRange: '全天'
    },
    BEVERAGE: {
      value: 'beverage',
      label: '饮品',
      timeRange: '全天'
    }
  },
  
  // 套餐类型
  COMBO_TYPES: {
    DAILY: {
      value: 'daily',
      label: '日套餐',
      description: '包含一日三餐'
    },
    WEEKLY: {
      value: 'weekly',
      label: '周套餐',
      description: '7天营养计划'
    },
    MONTHLY: {
      value: 'monthly',
      label: '月套餐',
      description: '30天定制方案'
    },
    CUSTOM: {
      value: 'custom',
      label: '定制套餐',
      description: '个性化定制'
    }
  },
  
  // 营养标签
  NUTRITION_TAGS: {
    // 营养成分
    HIGH_PROTEIN: '高蛋白',
    LOW_FAT: '低脂',
    LOW_CARB: '低碳水',
    HIGH_FIBER: '高纤维',
    LOW_SODIUM: '低钠',
    LOW_SUGAR: '低糖',
    
    // 特殊饮食
    GLUTEN_FREE: '无麸质',
    LACTOSE_FREE: '无乳糖',
    VEGETARIAN: '素食',
    VEGAN: '纯素',
    HALAL: '清真',
    
    // 功能性
    ENERGY_BOOST: '提升能量',
    IMMUNE_SUPPORT: '增强免疫',
    BRAIN_HEALTH: '益智健脑',
    BEAUTY: '美容养颜',
    WEIGHT_MANAGEMENT: '体重管理'
  }
};