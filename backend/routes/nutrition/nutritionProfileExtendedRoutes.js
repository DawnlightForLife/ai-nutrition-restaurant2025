/**
 * 营养档案扩展路由
 * 提供营养档案的高级功能
 * @module routes/nutrition/nutritionProfileExtendedRoutes
 */

const express = require('express');
const router = express.Router();
const { authenticateUser } = require('../../middleware/auth/authMiddleware');

// 获取档案模板
router.get('/templates', authenticateUser, async (req, res) => {
  try {
    const templates = {
      diabetic: {
        name: '糖尿病患者',
        data: {
          nutritionGoals: ['blood_sugar_control'],
          healthGoalDetails: {
            bloodSugarControl: {
              diabetesType: 'type2',
              medicationStatus: 'oral',
              monitoringFrequency: 'daily'
            }
          },
          dietaryPreferences: {
            dietaryType: 'low_carb',
            tastePreferences: {
              sweet: 0,
              salty: 1,
              spicy: 1,
              sour: 1,
              oily: 0
            }
          }
        }
      },
      fitness: {
        name: '健身增肌',
        data: {
          nutritionGoals: ['muscle_gain', 'sports_performance'],
          activityLevel: 'very_active',
          activityLevelDetail: 'more_than_3hours',
          healthGoalDetails: {
            weightManagement: {
              targetType: 'gain',
              targetSpeed: 'moderate'
            },
            sportsNutrition: {
              sportTypes: ['gym', 'bodyweight'],
              trainingPhase: 'pre_season'
            }
          }
        }
      },
      pregnancy: {
        name: '孕期营养',
        data: {
          gender: 'female',
          nutritionGoals: ['pregnancy'],
          healthGoalDetails: {
            specialPhysiological: {
              pregnancyWeek: 12
            }
          },
          dietaryPreferences: {
            dietaryType: 'omnivore',
            specialRequirements: ['孕期营养需求', '叶酸补充']
          }
        }
      },
      weightLoss: {
        name: '健康减重',
        data: {
          nutritionGoals: ['weight_loss', 'fat_loss'],
          healthGoalDetails: {
            weightManagement: {
              targetType: 'loss',
              targetSpeed: 'moderate'
            }
          },
          dietaryPreferences: {
            dietaryType: 'low_carb',
            tastePreferences: {
              oily: 0,
              sweet: 0
            }
          }
        }
      }
    };
    
    res.json({
      success: true,
      templates
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '获取模板失败',
      error: error.message
    });
  }
});

// 验证健康目标配置一致性
router.post('/validate-health-goals', authenticateUser, async (req, res) => {
  try {
    const { nutritionGoals, healthGoalDetails } = req.body;
    
    // 简单的验证逻辑
    if (!nutritionGoals || !Array.isArray(nutritionGoals) || nutritionGoals.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请至少选择一个营养目标',
        field: 'nutritionGoals'
      });
    }
    
    // 检查是否有互斥的目标
    const hasWeightLoss = nutritionGoals.includes('weight_loss');
    const hasMuscleGain = nutritionGoals.includes('muscle_gain');
    
    if (hasWeightLoss && hasMuscleGain) {
      return res.status(400).json({
        success: false,
        message: '减重和增肌目标存在冲突，建议选择体重管理或塑形目标',
        field: 'nutritionGoals'
      });
    }
    
    res.json({
      success: true,
      message: '健康目标配置验证通过'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '验证失败',
      error: error.message
    });
  }
});

// 智能冲突检测
router.post('/detect-conflicts', authenticateUser, async (req, res) => {
  try {
    const profileData = req.body;
    const conflicts = [];
    
    // 检测目标冲突
    const goals = profileData.nutritionGoals || [];
    if (goals.includes('weight_loss') && goals.includes('muscle_gain')) {
      conflicts.push({
        type: 'goal',
        message: '减重和增肌目标存在冲突，建议选择塑形目标'
      });
    }
    
    // 检测饮食类型与民族/宗教冲突
    if (profileData.dietaryPreferences) {
      const { dietaryType, religiousDietary, ethnicDietary } = profileData.dietaryPreferences;
      
      if (religiousDietary === 'halal' && dietaryType === 'omnivore') {
        conflicts.push({
          type: 'dietary',
          message: '清真饮食需要特殊的饮食限制'
        });
      }
      
      if (religiousDietary === 'buddhist' && !['vegetarian', 'vegan'].includes(dietaryType)) {
        conflicts.push({
          type: 'dietary',
          message: '佛教素食通常需要选择素食或纯素食'
        });
      }
    }
    
    // 检测运动与目标冲突
    if (profileData.activityLevel === 'sedentary' && goals.includes('sports_performance')) {
      conflicts.push({
        type: 'activity',
        message: '久坐生活方式与运动表现目标不匹配'
      });
    }
    
    res.json({
      success: true,
      hasConflicts: conflicts.length > 0,
      conflicts
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '冲突检测失败',
      error: error.message
    });
  }
});

// 基于目标生成建议
router.post('/generate-suggestions', authenticateUser, async (req, res) => {
  try {
    const { nutritionGoals, activityLevel, gender, ageGroup } = req.body;
    const suggestions = {
      dietaryType: [],
      tastePreferences: {},
      dailyCalorieTarget: null,
      macroRatios: {}
    };
    
    // 根据目标推荐饮食类型
    if (nutritionGoals.includes('weight_loss')) {
      suggestions.dietaryType.push('low_carb', 'mediterranean');
      suggestions.dailyCalorieTarget = gender === 'male' ? 1800 : 1500;
      suggestions.macroRatios = { protein: 0.3, fat: 0.35, carbs: 0.35 };
    }
    
    if (nutritionGoals.includes('muscle_gain')) {
      suggestions.dietaryType.push('omnivore');
      suggestions.dailyCalorieTarget = gender === 'male' ? 2800 : 2200;
      suggestions.macroRatios = { protein: 0.35, fat: 0.25, carbs: 0.4 };
    }
    
    if (nutritionGoals.includes('blood_sugar_control')) {
      suggestions.dietaryType.push('low_carb', 'keto');
      suggestions.tastePreferences = { sweet: 0, oily: 1 };
      suggestions.macroRatios = { protein: 0.25, fat: 0.5, carbs: 0.25 };
    }
    
    // 根据活动水平调整热量
    const activityMultiplier = {
      sedentary: 1.2,
      light: 1.375,
      moderate: 1.55,
      active: 1.725,
      very_active: 1.9,
      professional: 2.2
    };
    
    if (suggestions.dailyCalorieTarget && activityLevel) {
      const baseCal = suggestions.dailyCalorieTarget;
      suggestions.dailyCalorieTarget = Math.round(baseCal * (activityMultiplier[activityLevel] / 1.55));
    }
    
    res.json({
      success: true,
      suggestions
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '生成建议失败',
      error: error.message
    });
  }
});

module.exports = router;