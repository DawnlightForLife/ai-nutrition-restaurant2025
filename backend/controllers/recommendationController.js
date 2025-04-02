const mongoose = require('mongoose');
const AIRecommendation = require('../models/aiRecommendationModel');
const NutritionProfile = require('../models/nutritionProfileModel');
const AppError = require('../utils/AppError');

// 获取推荐预览
const getRecommendationPreview = async (req, res) => {
  try {
    const { profileId } = req.query;
    const userId = req.user ? req.user.userId : null;

    if (!userId) {
      console.warn('获取推荐预览失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    console.log(`获取推荐预览 - 用户ID: ${userId}, 档案ID: ${profileId || '未指定'}`);

    // 如果指定了档案ID，验证格式
    if (profileId && !mongoose.Types.ObjectId.isValid(profileId)) {
      console.warn(`获取推荐预览失败: 无效的档案ID格式 "${profileId}"`);
      return res.status(400).json({
        success: false,
        message: '无效的档案ID格式'
      });
    }

    // 获取用户的档案
    let profile;
    if (profileId) {
      profile = await NutritionProfile.findById(profileId);
      
      // 验证档案存在且属于当前用户
      if (!profile) {
        console.warn(`获取推荐预览失败: 未找到档案ID ${profileId}`);
        return res.status(404).json({
          success: false,
          message: '未找到指定的营养档案'
        });
      }
      
      if (profile.user_id.toString() !== userId) {
        console.warn(`获取推荐预览失败: 用户ID不匹配，用户=${userId}，档案所有者=${profile.user_id}`);
        return res.status(403).json({
          success: false,
          message: '您无权访问此档案的推荐'
        });
      }
    } else {
      // 没有指定档案ID，获取用户的默认档案
      profile = await NutritionProfile.findOne({ user_id: userId });
      
      if (!profile) {
        console.warn(`获取推荐预览失败: 用户 ${userId} 没有营养档案`);
        return res.status(404).json({
          success: false,
          message: '未找到营养档案，请先创建一个档案'
        });
      }
    }

    // 构造预览数据 (示例数据，实际应用中应根据档案进行AI生成)
    const previewData = {
      success: true,
      profile_id: profile._id,
      profile_name: profile.name,
      preview: {
        recommendation_types: [
          {
            type: "dish",
            description: "单品菜品推荐",
            preview: "根据您的营养需求，我们将为您推荐适合的菜品。"
          },
          {
            type: "meal",
            description: "套餐推荐",
            preview: "组合多种菜品，满足您的每日营养均衡。"
          },
          {
            type: "meal_plan",
            description: "膳食计划",
            preview: "为您规划一周的饮食安排，帮助您实现健康目标。"
          }
        ],
        estimated_time: "10-15秒",
        health_focus: profile.health_goals || []
      }
    };

    console.log(`成功生成推荐预览 - 用户ID: ${userId}, 档案ID: ${profile._id}`);
    res.json(previewData);
  } catch (error) {
    console.error('获取推荐预览失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法获取推荐预览'
    });
  }
};

// 生成推荐
const generateRecommendation = async (req, res) => {
  try {
    const { profile_id, health_params } = req.body;
    const userId = req.user ? req.user.userId : null;

    if (!userId) {
      console.warn('生成推荐失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    if (!profile_id) {
      console.warn('生成推荐失败: 未提供档案ID');
      return res.status(400).json({
        success: false,
        message: '请提供营养档案ID'
      });
    }

    if (!mongoose.Types.ObjectId.isValid(profile_id)) {
      console.warn(`生成推荐失败: 无效的档案ID格式 "${profile_id}"`);
      return res.status(400).json({
        success: false,
        message: '无效的档案ID格式'
      });
    }

    console.log(`生成推荐 - 用户ID: ${userId}, 档案ID: ${profile_id}`);

    // 获取用户的档案
    const profile = await NutritionProfile.findById(profile_id);
    
    // 验证档案存在且属于当前用户
    if (!profile) {
      console.warn(`生成推荐失败: 未找到档案ID ${profile_id}`);
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }
    
    if (profile.user_id.toString() !== userId) {
      console.warn(`生成推荐失败: 用户ID不匹配，用户=${userId}，档案所有者=${profile.user_id}`);
      return res.status(403).json({
        success: false,
        message: '您无权为此档案生成推荐'
      });
    }

    // 示例数据，实际应用中应调用AI服务生成推荐
    const recommendation = new AIRecommendation({
      user_id: userId,
      nutrition_profile_id: profile_id,
      recommendation_type: 'meal',
      recommendation_time: 'any',
      context: {
        location: 'any',
        time_constraint: 'normal'
      },
      // 添加其他必要字段...
      analysis: {
        current_diet_analysis: '基于您的档案信息分析...',
        nutrition_gaps: ['蛋白质摄入不足', '维生素D缺乏'],
        health_insights: ['增加蛋白质摄入有助于肌肉恢复']
      },
      overall_score: 85,
      created_at: new Date(),
      updated_at: new Date()
    });

    await recommendation.save();

    console.log(`成功生成推荐 - 用户ID: ${userId}, 档案ID: ${profile_id}, 推荐ID: ${recommendation._id}`);
    res.status(201).json({
      success: true,
      message: '推荐生成成功',
      recommendation_id: recommendation._id
    });
  } catch (error) {
    console.error('生成推荐失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法生成推荐'
    });
  }
};

// 获取推荐历史记录
const getRecommendationHistory = async (req, res) => {
  try {
    const { profileId } = req.query;
    const userId = req.user ? req.user.userId : null;

    if (!userId) {
      console.warn('获取推荐历史失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    console.log(`获取推荐历史 - 用户ID: ${userId}, 档案ID: ${profileId || '所有档案'}`);

    // 构建查询条件
    const query = { user_id: userId };
    
    // 如果指定了档案ID，添加到查询条件
    if (profileId) {
      if (!mongoose.Types.ObjectId.isValid(profileId)) {
        console.warn(`获取推荐历史失败: 无效的档案ID格式 "${profileId}"`);
        return res.status(400).json({
          success: false,
          message: '无效的档案ID格式'
        });
      }
      query.nutrition_profile_id = profileId;
    }

    // 获取推荐历史记录
    const history = await AIRecommendation.find(query)
      .sort({ created_at: -1 })
      .limit(20);

    console.log(`成功获取推荐历史 - 用户ID: ${userId}, 找到 ${history.length} 条记录`);
    res.json({
      success: true,
      count: history.length,
      history: history
    });
  } catch (error) {
    console.error('获取推荐历史失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法获取推荐历史记录'
    });
  }
};

// 获取所有推荐记录
const getAllRecommendations = async (req, res) => {
  try {
    const userId = req.user ? req.user.userId : null;
    const { profileId } = req.query;

    if (!userId) {
      console.warn('获取推荐记录失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    console.log(`获取所有推荐记录 - 用户ID: ${userId}, 档案ID参数: ${profileId || '未指定'}`);

    // 如果指定了档案ID，调用按档案查询的方法
    if (profileId) {
      return getRecommendationsByProfileId(req, res);
    }

    // 查询条件：用户所有的推荐记录
    const query = { user_id: userId };

    // 获取推荐记录
    const recommendations = await AIRecommendation.find(query)
      .sort({ created_at: -1 })
      .limit(50);

    console.log(`成功获取推荐记录 - 用户ID: ${userId}, 找到 ${recommendations.length} 条记录`);
    
    // 规范化响应格式
    res.json({
      success: true,
      count: recommendations.length,
      recommendations: recommendations.map(recommendation => ({
        id: recommendation._id.toString(),
        profileId: recommendation.nutrition_profile_id.toString(),
        type: recommendation.recommendation_type,
        timestamp: recommendation.created_at,
        status: recommendation.status || 'completed',
        score: recommendation.overall_score || 0,
        analysis: recommendation.analysis || {},
        hasBeenOrdered: recommendation.has_been_ordered || false,
        followThrough: recommendation.follow_through
      }))
    });
  } catch (error) {
    console.error('获取所有推荐记录失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法获取推荐记录'
    });
  }
};

// 按档案ID获取推荐记录
const getRecommendationsByProfileId = async (req, res) => {
  try {
    const userId = req.user ? req.user.userId : null;
    const { profileId } = req.query;

    if (!userId) {
      console.warn('获取推荐记录失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    if (!profileId) {
      console.warn('获取推荐记录失败: 未提供档案ID');
      return res.status(400).json({
        success: false,
        message: '请提供健康档案ID'
      });
    }

    // 验证档案ID格式
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      console.warn(`获取推荐记录失败: 无效的档案ID格式 "${profileId}"`);
      return res.status(400).json({
        success: false,
        message: '无效的档案ID格式'
      });
    }

    console.log(`按档案ID获取推荐记录 - 用户ID: ${userId}, 档案ID: ${profileId}`);

    // 查询条件：指定档案的推荐记录
    const query = { 
      user_id: userId,
      nutrition_profile_id: profileId
    };

    // 获取推荐记录
    const recommendations = await AIRecommendation.find(query)
      .sort({ created_at: -1 })
      .limit(50);

    console.log(`成功获取档案推荐记录 - 用户ID: ${userId}, 档案ID: ${profileId}, 找到 ${recommendations.length} 条记录`);
    
    // 规范化响应格式
    res.json({
      success: true,
      count: recommendations.length,
      recommendations: recommendations.map(recommendation => ({
        id: recommendation._id.toString(),
        profileId: recommendation.nutrition_profile_id.toString(),
        type: recommendation.recommendation_type,
        timestamp: recommendation.created_at,
        status: recommendation.status || 'completed',
        score: recommendation.overall_score || 0,
        analysis: recommendation.analysis || {},
        hasBeenOrdered: recommendation.has_been_ordered || false,
        followThrough: recommendation.follow_through
      }))
    });
  } catch (error) {
    console.error('获取档案推荐记录失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法获取推荐记录'
    });
  }
};

// 获取单个推荐详情
const getRecommendationDetail = async (req, res) => {
  try {
    const userId = req.user ? req.user.userId : null;
    const { id } = req.params;

    if (!userId) {
      console.warn('获取推荐详情失败: 未提供用户ID');
      return res.status(401).json({
        success: false,
        message: '未授权，请提供有效的认证令牌'
      });
    }

    if (!id) {
      console.warn('获取推荐详情失败: 未提供推荐ID');
      return res.status(400).json({
        success: false,
        message: '请提供推荐ID'
      });
    }

    // 验证ID格式
    if (!mongoose.Types.ObjectId.isValid(id)) {
      console.warn(`获取推荐详情失败: 无效的推荐ID格式 "${id}"`);
      return res.status(400).json({
        success: false,
        message: '无效的推荐ID格式'
      });
    }

    console.log(`获取推荐详情 - 用户ID: ${userId}, 推荐ID: ${id}`);

    // 获取推荐记录
    const recommendation = await AIRecommendation.findById(id);

    if (!recommendation) {
      console.warn(`获取推荐详情失败: 未找到ID为 ${id} 的推荐记录`);
      return res.status(404).json({
        success: false,
        message: '未找到指定的推荐记录'
      });
    }

    // 验证推荐记录所有权
    if (recommendation.user_id.toString() !== userId) {
      console.warn(`获取推荐详情失败: 用户ID不匹配，用户=${userId}，推荐所有者=${recommendation.user_id}`);
      return res.status(403).json({
        success: false,
        message: '您无权访问此推荐记录'
      });
    }

    console.log(`成功获取推荐详情 - 用户ID: ${userId}, 推荐ID: ${id}`);
    
    // 将MongoDB对象转换为普通JS对象，并统一字段格式
    const result = recommendation.toObject();
    
    // 确保ID字段统一
    result.id = result._id.toString();
    result.profileId = result.nutrition_profile_id.toString();
    
    // 删除MongoDB特有字段
    delete result._id;
    delete result.__v;
    
    res.json({
      success: true,
      recommendation: result
    });
  } catch (error) {
    console.error('获取推荐详情失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，无法获取推荐详情'
    });
  }
};

module.exports = {
  getRecommendationPreview,
  generateRecommendation,
  getRecommendationHistory,
  getAllRecommendations,
  getRecommendationsByProfileId,
  getRecommendationDetail
}; 