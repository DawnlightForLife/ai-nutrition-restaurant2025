/**
 * AI 营养推荐服务模块（aiRecommendationService）
 * 提供 AI 营养推荐的增删改查、分页查询、用户反馈提交等功能
 * 与 aiRecommendationModel 配合，为用户营养分析与个性化建议提供支持
 * 所有方法统一返回 { success, data, message } 结构
 * 后续支持与 AI 模型服务对接，实现动态生成个性推荐
 * @module services/nutrition/aiRecommendationService
 */
const AiRecommendation = require('../../models/nutrition/aiRecommendationModel');
const logger = require('../../utils/logger/winstonLogger.js');
const aiNutritionService = require('../ai/aiNutritionService');
const NutritionProfile = require('../../models/nutrition/nutritionProfileModel');

const aiRecommendationService = {
  /**
   * 创建AI推荐
   * 
   * @param {Object} data - 推荐数据
   * @returns {Promise<Object>} 创建的推荐
   */
  async createRecommendation(data) {
    try {
      // 获取用户的营养档案
      const nutritionProfile = await NutritionProfile.findOne({ userId: data.userId });
      
      if (!nutritionProfile) {
        return { success: false, message: '用户尚未创建营养档案' };
      }

      // 准备AI服务需要的数据
      const profileData = {
        gender: nutritionProfile.gender,
        age: nutritionProfile.age,
        height: nutritionProfile.height,
        weight: nutritionProfile.weight,
        activity_level: nutritionProfile.activityLevel,
        health_goal: nutritionProfile.healthGoal,
        dietary_restrictions: nutritionProfile.dietaryRestrictions || [],
        health_conditions: nutritionProfile.healthConditions || [],
        allergies: nutritionProfile.allergies || []
      };

      // 调用AI服务生成推荐
      const aiResponse = await aiNutritionService.generateRecommendation(profileData);

      if (!aiResponse.success) {
        logger.error('AI服务生成推荐失败', { error: aiResponse.error, data });
        return { success: false, message: 'AI服务暂时不可用，使用默认推荐' };
      }

      // 创建推荐记录
      const recommendationData = {
        userId: data.userId,
        profileId: nutritionProfile._id,
        recommendationType: data.recommendationType || 'diet_suggestion',
        status: 'generated',
        
        // 填充分析数据
        analysis: {
          currentDietAnalysis: aiResponse.data.recommendations.join('\n'),
          nutritionGaps: aiResponse.data.recommendations.filter(r => r.includes('不足') || r.includes('缺乏')),
          healthInsights: aiResponse.data.recommendations.filter(r => r.includes('健康') || r.includes('改善')),
          improvementAreas: aiResponse.data.recommendations.filter(r => r.includes('建议') || r.includes('需要'))
        },
        
        // 填充推荐数据
        recommendationData: {
          dietSuggestions: aiResponse.data.recommendations.map((suggestion, index) => ({
            suggestion: suggestion,
            reasoning: aiResponse.data.meal_suggestions[index] || '基于您的营养需求',
            scientificBasis: '基于科学营养计算',
            priority: index < 3 ? 5 : 3
          })),
          summary: {
            dailyCalories: aiResponse.data.targets.calories,
            proteinPercentage: Math.round((aiResponse.data.targets.protein * 4 / aiResponse.data.targets.calories) * 100),
            carbsPercentage: Math.round((aiResponse.data.targets.carbs * 4 / aiResponse.data.targets.calories) * 100),
            fatPercentage: Math.round((aiResponse.data.targets.fat * 9 / aiResponse.data.targets.calories) * 100),
            keyBenefits: [
              `每日推荐热量: ${aiResponse.data.targets.calories}卡路里`,
              `蛋白质目标: ${aiResponse.data.targets.protein}克`,
              `碳水化合物目标: ${aiResponse.data.targets.carbs}克`,
              `脂肪目标: ${aiResponse.data.targets.fat}克`
            ]
          }
        },
        
        // 算法信息
        algorithmInfo: {
          version: aiResponse.data.metadata.model_version,
          modelUsed: 'nutrition_calculator_v1',
          featuresConsidered: ['gender', 'age', 'height', 'weight', 'activity_level', 'health_goal'],
          confidence: aiResponse.data.metadata.calculation_method === 'scientific' ? 0.95 : 0.8
        },
        
        // 总体得分
        overallScore: 85
      };

      const recommendation = new AiRecommendation(recommendationData);
      await recommendation.save();
      
      return { success: true, data: recommendation };
    } catch (error) {
      logger.error('创建AI推荐失败', { error, data });
      return { success: false, message: `创建AI推荐失败: ${error.message}` };
    }
  },

  /**
   * 根据用户ID获取推荐列表
   * 
   * @param {string} userId - 用户ID
   * @param {Object} options - 选项
   * @returns {Promise<Object>} 推荐列表
   */
  async getRecommendationsByUserId(userId, options = {}) {
    try {
      const { 
        recommendationType, 
        limit = 10, 
        skip = 0, 
        sort = { createdAt: -1 } 
      } = options;

      const query = { userId };
      
      if (recommendationType) {
        query.recommendationType = recommendationType;
      }

      const [recommendations, total] = await Promise.all([
        AiRecommendation.find(query)
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .populate('user', 'username'),
        AiRecommendation.countDocuments(query)
      ]);

      return {
        success: true,
        data: recommendations,
        pagination: {
          total,
          limit,
          skip,
          hasMore: total > skip + limit
        }
      };
    } catch (error) {
      logger.error('获取推荐列表失败', { error, userId, options });
      return { success: false, message: `获取推荐列表失败: ${error.message}` };
    }
  },

  /**
   * 根据ID获取推荐详情
   * 
   * @param {string} id - 推荐ID
   * @returns {Promise<Object>} 推荐详情
   */
  async getRecommendationById(id) {
    try {
      const recommendation = await AiRecommendation.findById(id);
      
      if (!recommendation) {
        return { success: false, message: '找不到指定的推荐' };
      }
      
      return { success: true, data: recommendation };
    } catch (error) {
      logger.error('获取推荐详情失败', { error, id });
      return { success: false, message: `获取推荐详情失败: ${error.message}` };
    }
  },

  /**
   * 更新推荐
   * 
   * @param {string} id - 推荐ID
   * @param {Object} data - 更新数据
   * @returns {Promise<Object>} 更新后的推荐
   */
  async updateRecommendation(id, data) {
    try {
      const recommendation = await AiRecommendation.findById(id);
      
      if (!recommendation) {
        return { success: false, message: '找不到指定的推荐' };
      }
      
      Object.assign(recommendation, data);
      await recommendation.save();
      
      return { success: true, data: recommendation };
    } catch (error) {
      logger.error('更新推荐失败', { error, id, data });
      return { success: false, message: `更新推荐失败: ${error.message}` };
    }
  },

  /**
   * 提交推荐反馈
   * 
   * @param {string} id - 推荐ID
   * @param {Object} feedbackData - 反馈数据
   * @returns {Promise<Object>} 更新后的推荐
   */
  async submitFeedback(id, feedbackData) {
    try {
      const recommendation = await AiRecommendation.findById(id);
      
      if (!recommendation) {
        return { success: false, message: '找不到指定的推荐' };
      }
      
      recommendation.updateFeedback(feedbackData);
      recommendation.feedbackStatus = 'accepted';
      await recommendation.save();
      
      return { success: true, data: recommendation };
    } catch (error) {
      logger.error('提交反馈失败', { error, id, feedbackData });
      return { success: false, message: `提交反馈失败: ${error.message}` };
    }
  },

  /**
   * 删除推荐
   * 
   * @param {string} id - 推荐ID
   * @returns {Promise<Object>} 结果
   */
  async deleteRecommendation(id) {
    try {
      const result = await AiRecommendation.findByIdAndDelete(id);
      
      if (!result) {
        return { success: false, message: '找不到指定的推荐' };
      }
      
      return { success: true, message: '推荐已成功删除' };
    } catch (error) {
      logger.error('删除推荐失败', { error, id });
      return { success: false, message: `删除推荐失败: ${error.message}` };
    }
  },

  /**
   * 根据营养档案ID生成推荐
   * 
   * @param {string} profileId - 营养档案ID
   * @returns {Promise<Object>} 生成的推荐
   */
  async generateRecommendationByProfileId(profileId) {
    try {
      // 获取营养档案
      const nutritionProfile = await NutritionProfile.findById(profileId);
      
      if (!nutritionProfile) {
        return { success: false, message: '找不到指定的营养档案' };
      }

      // 使用营养档案的userId创建推荐
      return await this.createRecommendation({
        userId: nutritionProfile.userId,
        recommendationType: 'daily_nutrition'
      });
    } catch (error) {
      logger.error('根据档案生成推荐失败', { error, profileId });
      return { success: false, message: `生成推荐失败: ${error.message}` };
    }
  }
};

module.exports = aiRecommendationService;