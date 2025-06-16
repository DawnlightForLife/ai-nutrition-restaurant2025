/**
 * AI营养推荐服务
 * 负责与Python AI服务通信
 */
const axios = require('axios');
const logger = require('../../config/modules/logger');

class AINutritionService {
  constructor() {
    this.aiServiceUrl = process.env.AI_SERVICE_URL || 'http://localhost:8001';
    this.timeout = 30000; // 30秒超时
    
    // 创建axios实例
    this.client = axios.create({
      baseURL: this.aiServiceUrl,
      timeout: this.timeout,
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    // 添加请求拦截器
    this.client.interceptors.request.use(
      config => {
        logger.info('AI服务请求', {
          method: config.method,
          url: config.url,
          data: config.data
        });
        return config;
      },
      error => {
        logger.error('AI服务请求错误', error);
        return Promise.reject(error);
      }
    );
    
    // 添加响应拦截器
    this.client.interceptors.response.use(
      response => {
        logger.info('AI服务响应', {
          status: response.status,
          data: response.data
        });
        return response;
      },
      error => {
        logger.error('AI服务响应错误', {
          message: error.message,
          response: error.response?.data
        });
        return Promise.reject(error);
      }
    );
  }

  /**
   * 生成营养推荐
   */
  async generateRecommendation(profileData) {
    try {
      // 构建请求数据
      const requestData = {
        user_id: profileData.userId,
        profile_name: profileData.profileName,
        gender: profileData.gender,
        age_group: profileData.ageGroup,
        height: profileData.height,
        weight: profileData.weight,
        health_goals: profileData.healthGoals || [],
        dietary_preferences: profileData.dietaryPreferences || [],
        medical_conditions: profileData.medicalConditions || [],
        exercise_frequency: profileData.exerciseFrequency,
        allergies: profileData.allergies || [],
        forbidden_ingredients: profileData.forbiddenIngredients || [],
        nutrition_preferences: profileData.nutritionPreferences || [],
        special_status: profileData.specialStatus || []
      };
      
      // 调用AI服务
      const response = await this.client.post('/api/v1/nutrition/recommendations', requestData);
      
      // 转换响应格式
      return this._transformResponse(response.data);
      
    } catch (error) {
      // AI服务失败时的处理
      if (error.code === 'ECONNREFUSED' || error.code === 'ETIMEDOUT') {
        logger.warn('AI服务不可用，使用fallback推荐');
        return this._fallbackRecommendation(profileData);
      }
      
      // 其他错误直接抛出
      throw new Error(`AI推荐生成失败: ${error.message}`);
    }
  }

  /**
   * 提交用户反馈
   */
  async submitFeedback({ recommendationId, rating, comments, isAccepted, adjustments }) {
    try {
      const response = await this.client.post(
        `/api/v1/nutrition/recommendations/${recommendationId}/feedback`,
        {
          rating,
          comments,
          is_accepted: isAccepted,
          adjustments
        }
      );
      
      return response.data;
    } catch (error) {
      // 反馈提交失败不应该影响主流程，记录日志即可
      logger.error('提交AI推荐反馈失败', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * 健康检查
   */
  async healthCheck() {
    try {
      const response = await this.client.get('/api/v1/health');
      return response.data;
    } catch (error) {
      return {
        status: 'unhealthy',
        error: error.message
      };
    }
  }

  /**
   * 转换AI服务响应为后端格式
   */
  _transformResponse(aiResponse) {
    return {
      id: aiResponse.recommendation_id,
      profileId: aiResponse.profile_id,
      nutritionTargets: {
        dailyCalories: aiResponse.nutrition_targets.daily_calories,
        hydrationGoal: aiResponse.nutrition_targets.hydration_goal,
        mealFrequency: aiResponse.nutrition_targets.meal_frequency,
        macroRatio: aiResponse.nutrition_targets.macro_ratios,
        vitaminTargets: aiResponse.nutrition_targets.vitamin_targets,
        mineralTargets: aiResponse.nutrition_targets.mineral_targets
      },
      explanations: aiResponse.explanations,
      confidence: aiResponse.confidence,
      source: aiResponse.source,
      processingTimeMs: aiResponse.processing_time_ms,
      createdAt: new Date(aiResponse.created_at)
    };
  }

  /**
   * Fallback推荐（当AI服务不可用时）
   */
  _fallbackRecommendation(profileData) {
    // 基础的营养计算
    const { gender, weight, height, ageGroup, healthGoals = [] } = profileData;
    
    // 简化的BMR计算
    const age = this._ageGroupToNumber(ageGroup);
    let bmr;
    if (gender === 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    
    // 简化的热量计算
    let tdee = bmr * 1.55; // 中等活动水平
    
    // 根据健康目标调整
    if (healthGoals.includes('weight_loss')) {
      tdee *= 0.85;
    } else if (healthGoals.includes('weight_gain') || healthGoals.includes('muscle_gain')) {
      tdee *= 1.15;
    }
    
    return {
      id: `fallback_${Date.now()}`,
      profileId: profileData.userId,
      nutritionTargets: {
        dailyCalories: Math.round(tdee),
        hydrationGoal: Math.round(weight * 35),
        mealFrequency: 3,
        macroRatio: {
          protein: 0.25,
          fat: 0.30,
          carbs: 0.45
        },
        vitaminTargets: this._getDefaultVitaminTargets(gender, age),
        mineralTargets: this._getDefaultMineralTargets(gender, age)
      },
      explanations: [{
        category: '系统推荐',
        field: 'all',
        explanation: 'AI服务暂时不可用，使用基础营养学公式计算',
        reasoning: '基于BMR和活动水平的标准计算'
      }],
      confidence: 0.5,
      source: 'fallback',
      processingTimeMs: 100,
      createdAt: new Date()
    };
  }

  _ageGroupToNumber(ageGroup) {
    const mapping = {
      'under18': 16,
      '18to25': 22,
      '26to35': 30,
      '36to45': 40,
      '46to55': 50,
      '56to65': 60,
      'above65': 70
    };
    return mapping[ageGroup] || 30;
  }

  _getDefaultVitaminTargets(gender, age) {
    const isMale = gender === 'male';
    return {
      vitaminA: isMale ? 900 : 700,
      vitaminC: isMale ? 90 : 75,
      vitaminD: age > 70 ? 800 : 600,
      vitaminE: 15,
      vitaminK: isMale ? 120 : 90,
      vitaminB1: isMale ? 1.2 : 1.1,
      vitaminB2: isMale ? 1.3 : 1.1,
      vitaminB6: age > 50 ? 1.7 : 1.3,
      vitaminB12: 2.4,
      folate: 400,
      niacin: isMale ? 16 : 14
    };
  }

  _getDefaultMineralTargets(gender, age) {
    const isMale = gender === 'male';
    return {
      calcium: age > 50 ? 1200 : 1000,
      iron: isMale ? 8 : (age > 50 ? 8 : 18),
      magnesium: isMale ? 400 : 310,
      phosphorus: 700,
      potassium: 3500,
      sodium: 2300,
      zinc: isMale ? 11 : 8,
      selenium: 55
    };
  }
}

// 创建单例
const aiNutritionService = new AINutritionService();

module.exports = aiNutritionService;