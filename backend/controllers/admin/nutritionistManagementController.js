const User = require('../../models/user/userModel');
const NutritionistModel = require('../../models/nutrition/nutritionistModel');
const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
const Consultation = require('../../models/consult/consultationModel');
const responseHelper = require('../../utils/responseHelper');
const { validationResult } = require('express-validator');
const nutritionistManagementCache = require('../../services/cache/nutritionistManagementCacheService');

/**
 * 管理员营养师管理控制器
 * 提供营养师的增删改查、状态管理、批量操作等功能
 */

/**
 * 获取营养师列表（分页、筛选、搜索）
 */
exports.getNutritionists = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      status,
      verificationStatus,
      specialization,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // 构建查询参数对象
    const queryParams = {
      page: parseInt(page),
      limit: parseInt(limit),
      status,
      verificationStatus,
      specialization,
      search,
      sortBy,
      sortOrder
    };

    // 尝试从缓存获取数据
    const cachedResult = await nutritionistManagementCache.getCachedNutritionistsList(queryParams);
    if (cachedResult) {
      return responseHelper.success(res, cachedResult);
    }

    // 构建查询条件
    const query = {};
    
    if (status) {
      query.status = status;
    }
    
    if (verificationStatus) {
      query['verification.verificationStatus'] = verificationStatus;
    }
    
    if (specialization) {
      query['professionalInfo.specializations'] = specialization;
    }

    // 搜索条件（姓名、手机号、证书编号）
    if (search) {
      const searchRegex = new RegExp(search, 'i');
      query.$or = [
        { 'personalInfo.realName': searchRegex },
        { 'qualifications.licenseNumber': searchRegex }
      ];
      
      // 如果搜索内容是手机号，也搜索关联用户
      const userQuery = await User.find({
        $or: [
          { phone: searchRegex },
          { email: searchRegex },
          { name: searchRegex }
        ]
      }).select('_id');
      
      if (userQuery.length > 0) {
        query.$or.push({ userId: { $in: userQuery.map(u => u._id) } });
      }
    }

    // 排序条件
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页参数
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 查询营养师列表
    const nutritionists = await NutritionistModel.find(query)
      .populate('userId', 'phone email name avatar createdAt')
      .sort(sortOptions)
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    // 获取总数
    const total = await NutritionistModel.countDocuments(query);

    // 为每个营养师添加统计信息
    const enrichedNutritionists = await Promise.all(nutritionists.map(async (nutritionist) => {
      const consultationStats = await Consultation.aggregate([
        { $match: { nutritionistId: nutritionist._id } },
        {
          $group: {
            _id: null,
            totalConsultations: { $sum: 1 },
            completedConsultations: {
              $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] }
            },
            avgRating: { $avg: '$rating' },
            totalIncome: {
              $sum: { $cond: [{ $eq: ['$status', 'completed'] }, '$amount', 0] }
            }
          }
        }
      ]);

      const stats = consultationStats[0] || {
        totalConsultations: 0,
        completedConsultations: 0,
        avgRating: 0,
        totalIncome: 0
      };

      return {
        ...nutritionist,
        stats
      };
    }));

    const result = {
      nutritionists: enrichedNutritionists,
      pagination: {
        current: parseInt(page),
        total: Math.ceil(total / parseInt(limit)),
        pageSize: parseInt(limit),
        totalRecords: total
      }
    };

    // 缓存结果
    await nutritionistManagementCache.cacheNutritionistsList(queryParams, result);

    return responseHelper.success(res, result);
  } catch (error) {
    console.error('Error in getNutritionists:', error);
    return responseHelper.error(res, '获取营养师列表失败', 500);
  }
};

/**
 * 获取营养师详细信息
 */
exports.getNutritionist = async (req, res) => {
  try {
    const { id } = req.params;

    // 尝试从缓存获取数据
    const cachedResult = await nutritionistManagementCache.getCachedNutritionistDetail(id);
    if (cachedResult) {
      return responseHelper.success(res, cachedResult);
    }

    const nutritionist = await NutritionistModel.findById(id)
      .populate('userId', 'phone email name avatar createdAt lastLoginAt')
      .lean();

    if (!nutritionist) {
      return responseHelper.error(res, '营养师不存在', 404);
    }

    // 获取认证信息
    const certification = await NutritionistCertification.findOne({
      nutritionistId: id
    }).populate('reviewedBy', 'name');

    // 获取详细统计信息
    const consultationStats = await Consultation.aggregate([
      { $match: { nutritionistId: nutritionist._id } },
      {
        $group: {
          _id: null,
          totalConsultations: { $sum: 1 },
          completedConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] }
          },
          cancelledConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] }
          },
          avgRating: { $avg: '$rating' },
          totalRatings: {
            $sum: { $cond: [{ $ne: ['$rating', null] }, 1, 0] }
          },
          totalIncome: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, '$amount', 0] }
          }
        }
      }
    ]);

    // 获取最近的咨询记录
    const recentConsultations = await Consultation.find({
      nutritionistId: id
    })
      .populate('userId', 'name avatar phone')
      .sort({ createdAt: -1 })
      .limit(10)
      .lean();

    // 获取月度趋势数据
    const monthlyTrend = await Consultation.aggregate([
      {
        $match: {
          nutritionistId: nutritionist._id,
          createdAt: { $gte: new Date(Date.now() - 365 * 24 * 60 * 60 * 1000) }
        }
      },
      {
        $group: {
          _id: {
            year: { $year: '$createdAt' },
            month: { $month: '$createdAt' }
          },
          consultations: { $sum: 1 },
          income: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, '$amount', 0] }
          }
        }
      },
      {
        $sort: { '_id.year': 1, '_id.month': 1 }
      }
    ]);

    const stats = consultationStats[0] || {
      totalConsultations: 0,
      completedConsultations: 0,
      cancelledConsultations: 0,
      avgRating: 0,
      totalRatings: 0,
      totalIncome: 0
    };

    const result = {
      nutritionist,
      certification,
      stats,
      recentConsultations,
      monthlyTrend
    };

    // 缓存结果
    await nutritionistManagementCache.cacheNutritionistDetail(id, result);

    return responseHelper.success(res, result);
  } catch (error) {
    console.error('Error in getNutritionist:', error);
    return responseHelper.error(res, '获取营养师详情失败', 500);
  }
};

/**
 * 更新营养师状态
 */
exports.updateNutritionistStatus = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return responseHelper.error(res, '参数验证失败', 400, errors.array());
    }

    const { id } = req.params;
    const { status, reason } = req.body;
    const adminId = req.user.id;

    const nutritionist = await NutritionistModel.findById(id);
    if (!nutritionist) {
      return responseHelper.error(res, '营养师不存在', 404);
    }

    const oldStatus = nutritionist.status;
    nutritionist.status = status;

    // 添加状态变更记录到审核历史
    nutritionist.verification.verificationHistory.push({
      status: status === 'active' ? 'approved' : 'rejected',
      reason: reason || `状态变更: ${oldStatus} -> ${status}`,
      changedBy: adminId,
      changedAt: new Date()
    });

    // 如果是暂停或禁用，更新在线状态
    if (status === 'suspended' || status === 'inactive') {
      nutritionist.onlineStatus.isOnline = false;
      nutritionist.onlineStatus.isAvailable = false;
    }

    await nutritionist.save();

    // 清除相关缓存
    await nutritionistManagementCache.invalidateNutritionistCache(id);

    return responseHelper.success(res, {
      message: '营养师状态更新成功',
      nutritionist: {
        id: nutritionist._id,
        status: nutritionist.status,
        onlineStatus: nutritionist.onlineStatus
      }
    });
  } catch (error) {
    console.error('Error in updateNutritionistStatus:', error);
    return responseHelper.error(res, '更新营养师状态失败', 500);
  }
};

/**
 * 批量操作营养师
 */
exports.batchUpdateNutritionists = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return responseHelper.error(res, '参数验证失败', 400, errors.array());
    }

    const { nutritionistIds, action, data } = req.body;
    const adminId = req.user.id;

    if (!nutritionistIds || !Array.isArray(nutritionistIds) || nutritionistIds.length === 0) {
      return responseHelper.error(res, '请选择要操作的营养师', 400);
    }

    let updateResult;
    const timestamp = new Date();

    switch (action) {
      case 'updateStatus':
        const { status, reason } = data;
        updateResult = await NutritionistModel.updateMany(
          { _id: { $in: nutritionistIds } },
          {
            $set: { status },
            $push: {
              'verification.verificationHistory': {
                status: status === 'active' ? 'approved' : 'rejected',
                reason: reason || `批量状态变更: ${status}`,
                changedBy: adminId,
                changedAt: timestamp
              }
            }
          }
        );
        break;

      case 'setOffline':
        updateResult = await NutritionistModel.updateMany(
          { _id: { $in: nutritionistIds } },
          {
            $set: {
              'onlineStatus.isOnline': false,
              'onlineStatus.isAvailable': false,
              'onlineStatus.lastActiveAt': timestamp
            }
          }
        );
        break;

      case 'resetPassword':
        // 这里需要重置关联用户的密码，发送重置邮件等
        const nutritionists = await NutritionistModel.find({
          _id: { $in: nutritionistIds }
        }).populate('userId');

        const userIds = nutritionists.map(n => n.userId._id);
        
        // 生成临时密码重置令牌
        updateResult = await User.updateMany(
          { _id: { $in: userIds } },
          {
            $set: {
              passwordResetRequired: true,
              passwordResetToken: null, // 清除现有令牌
              passwordResetExpires: null
            }
          }
        );
        break;

      default:
        return responseHelper.error(res, '不支持的批量操作', 400);
    }

    // 清除相关缓存
    await nutritionistManagementCache.invalidateListCache();
    await nutritionistManagementCache.invalidateOverviewCache();

    return responseHelper.success(res, {
      message: '批量操作完成',
      affected: updateResult.modifiedCount,
      total: nutritionistIds.length
    });
  } catch (error) {
    console.error('Error in batchUpdateNutritionists:', error);
    return responseHelper.error(res, '批量操作失败', 500);
  }
};

/**
 * 获取营养师管理统计概览
 */
exports.getManagementOverview = async (req, res) => {
  try {
    // 尝试从缓存获取数据
    const cachedResult = await nutritionistManagementCache.getCachedManagementOverview();
    if (cachedResult) {
      return responseHelper.success(res, cachedResult);
    }

    // 基础统计
    const totalNutritionists = await NutritionistModel.countDocuments();
    const activeNutritionists = await NutritionistModel.countDocuments({ status: 'active' });
    const pendingVerification = await NutritionistModel.countDocuments({
      'verification.verificationStatus': 'pending'
    });
    const onlineNutritionists = await NutritionistModel.countDocuments({
      'onlineStatus.isOnline': true
    });

    // 状态分布
    const statusDistribution = await NutritionistModel.aggregate([
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 }
        }
      }
    ]);

    // 专业领域分布
    const specializationDistribution = await NutritionistModel.aggregate([
      { $unwind: '$professionalInfo.specializations' },
      {
        $group: {
          _id: '$professionalInfo.specializations',
          count: { $sum: 1 }
        }
      },
      { $sort: { count: -1 } },
      { $limit: 10 }
    ]);

    // 认证等级分布
    const levelDistribution = await NutritionistModel.aggregate([
      {
        $group: {
          _id: '$qualifications.certificationLevel',
          count: { $sum: 1 }
        }
      }
    ]);

    // 最近7天注册趋势
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const registrationTrend = await NutritionistModel.aggregate([
      { $match: { createdAt: { $gte: sevenDaysAgo } } },
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
      { $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 } }
    ]);

    // 活跃度统计（最近30天有咨询的营养师）
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const activeInMonth = await Consultation.distinct('nutritionistId', {
      createdAt: { $gte: thirtyDaysAgo }
    });

    const result = {
      overview: {
        totalNutritionists,
        activeNutritionists,
        pendingVerification,
        onlineNutritionists,
        activeInMonth: activeInMonth.length,
        activityRate: totalNutritionists > 0 ? 
          ((activeInMonth.length / totalNutritionists) * 100).toFixed(1) : 0
      },
      distributions: {
        status: statusDistribution,
        specialization: specializationDistribution,
        level: levelDistribution
      },
      trends: {
        registration: registrationTrend
      }
    };

    // 缓存结果
    await nutritionistManagementCache.cacheManagementOverview(result);

    return responseHelper.success(res, result);
  } catch (error) {
    console.error('Error in getManagementOverview:', error);
    return responseHelper.error(res, '获取管理概览失败', 500);
  }
};

/**
 * 导出营养师数据
 */
exports.exportNutritionists = async (req, res) => {
  try {
    const { format = 'csv', status, verificationStatus } = req.query;

    // 构建查询条件
    const query = {};
    if (status) query.status = status;
    if (verificationStatus) query['verification.verificationStatus'] = verificationStatus;

    const nutritionists = await NutritionistModel.find(query)
      .populate('userId', 'phone email name createdAt')
      .lean();

    // 格式化数据用于导出
    const exportData = nutritionists.map(nutritionist => ({
      ID: nutritionist._id,
      姓名: nutritionist.personalInfo.realName,
      手机号: nutritionist.userId?.phone,
      邮箱: nutritionist.userId?.email,
      证书编号: nutritionist.qualifications.licenseNumber,
      专业等级: nutritionist.qualifications.certificationLevel,
      专业领域: nutritionist.professionalInfo.specializations?.join(', '),
      从业年限: nutritionist.professionalInfo.experienceYears,
      咨询费用: nutritionist.serviceInfo.consultationFee,
      状态: nutritionist.status,
      审核状态: nutritionist.verification.verificationStatus,
      平均评分: nutritionist.ratings.averageRating,
      评价数量: nutritionist.ratings.totalReviews,
      是否在线: nutritionist.onlineStatus.isOnline ? '是' : '否',
      注册时间: nutritionist.createdAt,
      最后活跃: nutritionist.onlineStatus.lastActiveAt
    }));

    if (format === 'json') {
      res.setHeader('Content-Type', 'application/json');
      res.setHeader('Content-Disposition', 'attachment; filename="nutritionists.json"');
      return res.json(exportData);
    }

    // CSV格式导出
    const csvHeaders = Object.keys(exportData[0] || {}).join(',');
    const csvRows = exportData.map(row => 
      Object.values(row).map(value => 
        typeof value === 'string' && value.includes(',') ? `"${value}"` : value
      ).join(',')
    );
    
    const csvContent = [csvHeaders, ...csvRows].join('\n');

    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', 'attachment; filename="nutritionists.csv"');
    res.write('\uFEFF'); // UTF-8 BOM for Excel
    res.end(csvContent);

  } catch (error) {
    console.error('Error in exportNutritionists:', error);
    return responseHelper.error(res, '导出数据失败', 500);
  }
};

/**
 * 搜索营养师（快速搜索）
 */
exports.searchNutritionists = async (req, res) => {
  try {
    const { q, limit = 10 } = req.query;

    if (!q || q.trim().length < 2) {
      return responseHelper.error(res, '搜索关键词至少需要2个字符', 400);
    }

    // 尝试从缓存获取数据
    const cachedResult = await nutritionistManagementCache.getCachedSearchResults(q.trim(), parseInt(limit));
    if (cachedResult) {
      return responseHelper.success(res, cachedResult);
    }

    const searchRegex = new RegExp(q.trim(), 'i');

    // 搜索用户信息
    const users = await User.find({
      $or: [
        { name: searchRegex },
        { phone: searchRegex },
        { email: searchRegex }
      ]
    }).select('_id').limit(parseInt(limit));

    const userIds = users.map(u => u._id);

    // 搜索营养师
    const nutritionists = await NutritionistModel.find({
      $or: [
        { 'personalInfo.realName': searchRegex },
        { 'qualifications.licenseNumber': searchRegex },
        { userId: { $in: userIds } }
      ]
    })
      .populate('userId', 'name phone email avatar')
      .select('personalInfo qualifications professionalInfo status verification onlineStatus')
      .limit(parseInt(limit))
      .lean();

    const results = nutritionists.map(nutritionist => ({
      id: nutritionist._id,
      name: nutritionist.personalInfo.realName,
      phone: nutritionist.userId?.phone,
      email: nutritionist.userId?.email,
      avatar: nutritionist.userId?.avatar,
      licenseNumber: nutritionist.qualifications.licenseNumber,
      specializations: nutritionist.professionalInfo.specializations,
      status: nutritionist.status,
      verificationStatus: nutritionist.verification.verificationStatus,
      isOnline: nutritionist.onlineStatus.isOnline
    }));

    const result = { results, total: results.length };

    // 缓存结果
    await nutritionistManagementCache.cacheSearchResults(q.trim(), parseInt(limit), result);

    return responseHelper.success(res, result);
  } catch (error) {
    console.error('Error in searchNutritionists:', error);
    return responseHelper.error(res, '搜索失败', 500);
  }
};