const User = require('../../models/user/userModel');
const NutritionistModel = require('../../models/nutrition/nutritionistModel');
const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
const Consultation = require('../../models/consult/consultationModel');
const AIRecommendation = require('../../models/nutrition/aiRecommendationModel');
const NutritionPlan = require('../../models/nutrition/nutritionPlanModel');
const responseHelper = require('../../utils/responseHelper');

/**
 * 营养师统计管理控制器
 * 提供营养师相关的统计数据和管理功能
 */

/**
 * 获取营养师总体概况
 */
exports.getOverviewStats = async (req, res) => {
  try {
    // 获取所有营养师数量
    const totalNutritionists = await NutritionistModel.countDocuments();
    
    // 获取认证通过的营养师数量
    const certifiedNutritionists = await NutritionistCertification.countDocuments({
      status: 'approved'
    });
    
    // 获取活跃营养师数量（最近30天有咨询记录）
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const activeNutritionists = await Consultation.distinct('nutritionistId', {
      createdAt: { $gte: thirtyDaysAgo }
    });
    
    // 获取营养师等级分布
    const levelDistribution = await NutritionistModel.aggregate([
      {
        $group: {
          _id: '$level',
          count: { $sum: 1 }
        }
      },
      {
        $project: {
          level: '$_id',
          count: 1,
          _id: 0
        }
      }
    ]);
    
    // 获取本月新增营养师
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);
    
    const newNutritionistsThisMonth = await NutritionistModel.countDocuments({
      createdAt: { $gte: startOfMonth }
    });
    
    return responseHelper.success(res, {
      totalNutritionists,
      certifiedNutritionists,
      activeNutritionists: activeNutritionists.length,
      newNutritionistsThisMonth,
      levelDistribution
    });
  } catch (error) {
    console.error('Error in getOverviewStats:', error);
    return responseHelper.error(res, '获取营养师概况统计失败', 500);
  }
};

/**
 * 获取咨询服务数据
 */
exports.getConsultationStats = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    const dateFilter = {};
    
    if (startDate) {
      dateFilter.createdAt = { $gte: new Date(startDate) };
    }
    if (endDate) {
      dateFilter.createdAt = { ...dateFilter.createdAt, $lte: new Date(endDate) };
    }
    
    // 总咨询数量
    const totalConsultations = await Consultation.countDocuments(dateFilter);
    
    // 咨询响应时间统计
    const responseTimeStats = await Consultation.aggregate([
      { $match: { ...dateFilter, firstReplyTime: { $exists: true } } },
      {
        $project: {
          responseTime: {
            $subtract: ['$firstReplyTime', '$createdAt']
          }
        }
      },
      {
        $group: {
          _id: null,
          avgResponseTime: { $avg: '$responseTime' },
          minResponseTime: { $min: '$responseTime' },
          maxResponseTime: { $max: '$responseTime' }
        }
      }
    ]);
    
    // 每日咨询趋势（最近7天）
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const dailyConsultations = await Consultation.aggregate([
      {
        $match: {
          createdAt: { $gte: sevenDaysAgo }
        }
      },
      {
        $group: {
          _id: {
            year: { $year: '$createdAt' },
            month: { $month: '$createdAt' },
            day: { $dayOfMonth: '$createdAt' }
          },
          count: { $sum: 1 }
        }
      },
      {
        $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 }
      },
      {
        $project: {
          date: {
            $concat: [
              { $toString: '$_id.year' }, '-',
              { $toString: '$_id.month' }, '-',
              { $toString: '$_id.day' }
            ]
          },
          count: 1,
          _id: 0
        }
      }
    ]);
    
    // 用户评分分布
    const ratingDistribution = await Consultation.aggregate([
      { $match: { rating: { $exists: true } } },
      {
        $group: {
          _id: '$rating',
          count: { $sum: 1 }
        }
      },
      {
        $project: {
          rating: '$_id',
          count: 1,
          _id: 0
        }
      },
      { $sort: { rating: -1 } }
    ]);
    
    // 计算好评率（4分及以上）
    const totalRated = await Consultation.countDocuments({ rating: { $exists: true } });
    const goodRatings = await Consultation.countDocuments({ rating: { $gte: 4 } });
    const goodRatingRate = totalRated > 0 ? (goodRatings / totalRated * 100).toFixed(2) : 0;
    
    return responseHelper.success(res, {
      totalConsultations,
      responseTimeStats: responseTimeStats[0] || {
        avgResponseTime: 0,
        minResponseTime: 0,
        maxResponseTime: 0
      },
      dailyConsultations,
      ratingDistribution,
      goodRatingRate: parseFloat(goodRatingRate)
    });
  } catch (error) {
    console.error('Error in getConsultationStats:', error);
    return responseHelper.error(res, '获取咨询服务统计失败', 500);
  }
};

/**
 * 获取营养推荐行为分析
 */
exports.getRecommendationStats = async (req, res) => {
  try {
    // 总推荐次数
    const totalRecommendations = await AIRecommendation.countDocuments();
    
    // 推荐成功率（用户采纳的推荐）
    const acceptedRecommendations = await AIRecommendation.countDocuments({
      status: 'accepted'
    });
    const successRate = totalRecommendations > 0 
      ? (acceptedRecommendations / totalRecommendations * 100).toFixed(2) 
      : 0;
    
    // 推荐档案覆盖率（每位营养师服务过的用户数）
    const nutritionistCoverage = await Consultation.aggregate([
      {
        $group: {
          _id: '$nutritionistId',
          uniqueUsers: { $addToSet: '$userId' }
        }
      },
      {
        $project: {
          nutritionistId: '$_id',
          userCount: { $size: '$uniqueUsers' },
          _id: 0
        }
      },
      {
        $group: {
          _id: null,
          avgUsersPerNutritionist: { $avg: '$userCount' },
          maxUsersPerNutritionist: { $max: '$userCount' },
          minUsersPerNutritionist: { $min: '$userCount' }
        }
      }
    ]);
    
    // 推荐内容类型分布
    const recommendationTypes = await NutritionPlan.aggregate([
      {
        $group: {
          _id: '$planType',
          count: { $sum: 1 }
        }
      },
      {
        $project: {
          type: '$_id',
          count: 1,
          _id: 0
        }
      }
    ]);
    
    // AI vs 人工推荐比例
    const aiRecommendations = await AIRecommendation.countDocuments({ source: 'ai' });
    const manualRecommendations = await AIRecommendation.countDocuments({ source: 'manual' });
    
    return responseHelper.success(res, {
      totalRecommendations,
      acceptedRecommendations,
      successRate: parseFloat(successRate),
      nutritionistCoverage: nutritionistCoverage[0] || {
        avgUsersPerNutritionist: 0,
        maxUsersPerNutritionist: 0,
        minUsersPerNutritionist: 0
      },
      recommendationTypes,
      recommendationSource: {
        ai: aiRecommendations,
        manual: manualRecommendations
      }
    });
  } catch (error) {
    console.error('Error in getRecommendationStats:', error);
    return responseHelper.error(res, '获取推荐行为统计失败', 500);
  }
};

/**
 * 获取收入与分成统计
 */
exports.getIncomeStats = async (req, res) => {
  try {
    const { nutritionistId, startDate, endDate } = req.query;
    const filter = {};
    
    if (nutritionistId) {
      filter.nutritionistId = nutritionistId;
    }
    
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }
    
    // 咨询服务收入统计
    const consultationIncome = await Consultation.aggregate([
      { $match: { ...filter, status: 'completed', amount: { $exists: true } } },
      {
        $group: {
          _id: null,
          totalIncome: { $sum: '$amount' },
          totalCount: { $sum: 1 },
          avgIncome: { $avg: '$amount' }
        }
      }
    ]);
    
    // 本月结算金额
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);
    
    const monthlySettlement = await Consultation.aggregate([
      {
        $match: {
          createdAt: { $gte: startOfMonth },
          status: 'completed',
          amount: { $exists: true }
        }
      },
      {
        $group: {
          _id: '$nutritionistId',
          totalAmount: { $sum: '$amount' },
          consultationCount: { $sum: 1 }
        }
      },
      {
        $lookup: {
          from: 'nutritionists',
          localField: '_id',
          foreignField: '_id',
          as: 'nutritionist'
        }
      },
      {
        $unwind: '$nutritionist'
      },
      {
        $project: {
          nutritionistId: '$_id',
          nutritionistName: '$nutritionist.name',
          totalAmount: 1,
          consultationCount: 1,
          commissionRate: { $ifNull: ['$nutritionist.commissionRate', 0.7] },
          settlementAmount: {
            $multiply: ['$totalAmount', { $ifNull: ['$nutritionist.commissionRate', 0.7] }]
          },
          _id: 0
        }
      },
      {
        $sort: { settlementAmount: -1 }
      }
    ]);
    
    // 提现记录统计（假设有提现记录模型）
    // 这里暂时返回模拟数据，实际需要根据提现记录模型查询
    const withdrawalStats = {
      totalWithdrawals: 0,
      pendingWithdrawals: 0,
      completedWithdrawals: 0,
      totalWithdrawnAmount: 0
    };
    
    return responseHelper.success(res, {
      consultationIncome: consultationIncome[0] || {
        totalIncome: 0,
        totalCount: 0,
        avgIncome: 0
      },
      monthlySettlement,
      withdrawalStats
    });
  } catch (error) {
    console.error('Error in getIncomeStats:', error);
    return responseHelper.error(res, '获取收入统计失败', 500);
  }
};

/**
 * 获取营养师排行榜
 */
exports.getNutritionistRanking = async (req, res) => {
  try {
    const { type = 'consultation', limit = 10 } = req.query;
    let ranking = [];
    
    switch (type) {
      case 'consultation':
        // 按咨询数量排名
        ranking = await Consultation.aggregate([
          { $match: { status: 'completed' } },
          {
            $group: {
              _id: '$nutritionistId',
              consultationCount: { $sum: 1 },
              totalIncome: { $sum: '$amount' },
              avgRating: { $avg: '$rating' }
            }
          },
          {
            $lookup: {
              from: 'nutritionists',
              localField: '_id',
              foreignField: '_id',
              as: 'nutritionist'
            }
          },
          {
            $unwind: '$nutritionist'
          },
          {
            $project: {
              nutritionistId: '$_id',
              nutritionistName: '$nutritionist.name',
              avatar: '$nutritionist.avatar',
              consultationCount: 1,
              totalIncome: 1,
              avgRating: { $round: ['$avgRating', 1] },
              _id: 0
            }
          },
          { $sort: { consultationCount: -1 } },
          { $limit: parseInt(limit) }
        ]);
        break;
        
      case 'rating':
        // 按评分排名
        ranking = await Consultation.aggregate([
          { $match: { rating: { $exists: true } } },
          {
            $group: {
              _id: '$nutritionistId',
              avgRating: { $avg: '$rating' },
              ratingCount: { $sum: 1 }
            }
          },
          { $match: { ratingCount: { $gte: 5 } } }, // 至少5个评价
          {
            $lookup: {
              from: 'nutritionists',
              localField: '_id',
              foreignField: '_id',
              as: 'nutritionist'
            }
          },
          {
            $unwind: '$nutritionist'
          },
          {
            $project: {
              nutritionistId: '$_id',
              nutritionistName: '$nutritionist.name',
              avatar: '$nutritionist.avatar',
              avgRating: { $round: ['$avgRating', 1] },
              ratingCount: 1,
              _id: 0
            }
          },
          { $sort: { avgRating: -1 } },
          { $limit: parseInt(limit) }
        ]);
        break;
        
      case 'income':
        // 按收入排名
        ranking = await Consultation.aggregate([
          { $match: { status: 'completed', amount: { $exists: true } } },
          {
            $group: {
              _id: '$nutritionistId',
              totalIncome: { $sum: '$amount' },
              consultationCount: { $sum: 1 }
            }
          },
          {
            $lookup: {
              from: 'nutritionists',
              localField: '_id',
              foreignField: '_id',
              as: 'nutritionist'
            }
          },
          {
            $unwind: '$nutritionist'
          },
          {
            $project: {
              nutritionistId: '$_id',
              nutritionistName: '$nutritionist.name',
              avatar: '$nutritionist.avatar',
              totalIncome: 1,
              consultationCount: 1,
              avgIncomePerConsultation: {
                $divide: ['$totalIncome', '$consultationCount']
              },
              _id: 0
            }
          },
          { $sort: { totalIncome: -1 } },
          { $limit: parseInt(limit) }
        ]);
        break;
    }
    
    return responseHelper.success(res, { ranking, type });
  } catch (error) {
    console.error('Error in getNutritionistRanking:', error);
    return responseHelper.error(res, '获取营养师排行榜失败', 500);
  }
};

/**
 * 获取营养师详细信息
 */
exports.getNutritionistDetail = async (req, res) => {
  try {
    const { nutritionistId } = req.params;
    
    // 获取营养师基本信息
    const nutritionist = await NutritionistModel.findById(nutritionistId)
      .populate('userId', 'phone email name avatar');
    
    if (!nutritionist) {
      return responseHelper.error(res, '营养师不存在', 404);
    }
    
    // 获取认证信息
    const certification = await NutritionistCertification.findOne({
      nutritionistId: nutritionistId
    });
    
    // 获取统计数据
    const stats = await Consultation.aggregate([
      { $match: { nutritionistId: nutritionistId } },
      {
        $group: {
          _id: null,
          totalConsultations: { $sum: 1 },
          completedConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] }
          },
          totalIncome: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, '$amount', 0] }
          },
          avgRating: { $avg: '$rating' },
          totalRatings: {
            $sum: { $cond: [{ $ne: ['$rating', null] }, 1, 0] }
          }
        }
      }
    ]);
    
    // 获取最近的咨询记录
    const recentConsultations = await Consultation.find({
      nutritionistId: nutritionistId
    })
      .populate('userId', 'name avatar')
      .sort({ createdAt: -1 })
      .limit(10);
    
    return responseHelper.success(res, {
      nutritionist,
      certification,
      stats: stats[0] || {
        totalConsultations: 0,
        completedConsultations: 0,
        totalIncome: 0,
        avgRating: 0,
        totalRatings: 0
      },
      recentConsultations
    });
  } catch (error) {
    console.error('Error in getNutritionistDetail:', error);
    return responseHelper.error(res, '获取营养师详情失败', 500);
  }
};