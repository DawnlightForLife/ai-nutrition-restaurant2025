const AiRecommendation = require('../../models/nutrition/aiRecommendationModel');

const aiRecommendationService = {
  /**
   * 创建AI推荐
   * 
   * @param {Object} data - 推荐数据
   * @returns {Promise<Object>} 创建的推荐
   */
  async createRecommendation(data) {
    try {
      const recommendation = new AiRecommendation(data);
      await recommendation.save();
      return { success: true, data: recommendation };
    } catch (error) {
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
      return { success: false, message: `删除推荐失败: ${error.message}` };
    }
  }
};

module.exports = aiRecommendationService;