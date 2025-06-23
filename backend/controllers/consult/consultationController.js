/**
 * 咨询管理控制器
 * 处理营养咨询的增删改查
 */

const Consultation = require('../../models/consult/consultationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const User = require('../../models/user/userModel');
const { responseHelper } = require('../../utils');
const { cacheService } = require('../../services');

/**
 * 获取咨询列表
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getConsultationList = async (req, res) => {
  try {
    const {
      userId,
      nutritionistId, 
      status,
      startDate,
      endDate,
      page = 1,
      limit = 20,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // 生成缓存键
    const cacheKey = `consultations:${req.user._id}:${JSON.stringify({
      userId, nutritionistId, status, startDate, endDate, page, limit, sortBy, sortOrder
    })}`;

    // 尝试从缓存获取
    try {
      const cachedResult = await cacheService.get(cacheKey);
      if (cachedResult) {
        return responseHelper.success(res, cachedResult);
      }
    } catch (cacheError) {
      // 缓存失败不影响主流程
      console.warn('Cache retrieval failed:', cacheError.message);
    }

    // 构建查询条件
    const query = {};
    
    // 根据用户角色决定查询条件
    if (req.user && req.user.role === 'nutritionist') {
      // 营养师查看自己的咨询
      const nutritionist = await Nutritionist.findOne({ userId: req.user._id });
      if (nutritionist) {
        query.nutritionistId = nutritionist._id;
      } else {
        return responseHelper.success(res, {
          consultations: [],
          pagination: {
            total: 0,
            page: parseInt(page),
            limit: parseInt(limit),
            totalPages: 0
          }
        });
      }
    } else if (userId) {
      // 用户查看自己的咨询
      query.userId = userId;
    } else if (nutritionistId) {
      // 查看特定营养师的咨询
      query.nutritionistId = nutritionistId;
    } else if (req.user && req.user._id) {
      // 默认查看当前用户的咨询
      query.userId = req.user._id;
    }

    // 状态筛选
    if (status) {
      query.status = status;
    }

    // 时间范围筛选
    if (startDate || endDate) {
      query.createdAt = {};
      if (startDate) query.createdAt.$gte = new Date(startDate);
      if (endDate) query.createdAt.$lte = new Date(endDate);
    }

    // 计算分页
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const sort = { [sortBy]: sortOrder === 'asc' ? 1 : -1 };

    // 执行查询 - 优化：减少复杂的 populate 操作
    const [consultations, total] = await Promise.all([
      Consultation.find(query)
        .sort(sort)
        .skip(skip)
        .limit(parseInt(limit))
        .populate('userId', 'username nickname avatar')
        .populate('nutritionistId', 'name avatar specializations ratings')
        .select('-messages -sensitiveInfo') // 排除大字段
        .lean(),
      Consultation.countDocuments(query)
    ]);

    // 格式化返回数据 - 优化：简化数据处理
    const formattedConsultations = consultations.map(consultation => ({
      id: consultation._id,
      userId: consultation.userId?._id,
      userName: consultation.userId?.nickname || consultation.userId?.username,
      userAvatar: consultation.userId?.avatar,
      nutritionistId: consultation.nutritionistId?._id,
      nutritionistName: consultation.nutritionistId?.name,
      nutritionistAvatar: consultation.nutritionistId?.avatar,
      consultationType: consultation.consultationType,
      status: consultation.status,
      scheduledTime: consultation.scheduledTime,
      startTime: consultation.startTime,
      endTime: consultation.endTime,
      topic: consultation.topic,
      // 移除复杂的消息处理，单独API获取
      messagesCount: 0,
      unreadCount: 0,
      lastMessage: null,
      payment: consultation.payment,
      userRating: consultation.userRating,
      requiresFollowUp: consultation.requiresFollowUp,
      createdAt: consultation.createdAt,
      updatedAt: consultation.updatedAt
    }));

    // 准备返回数据
    const result = {
      consultations: formattedConsultations,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / parseInt(limit))
      }
    };

    // 存储到缓存（5分钟TTL）
    try {
      await cacheService.set(cacheKey, result, 300);
    } catch (cacheError) {
      // 缓存失败不影响主流程
      console.warn('Cache storage failed:', cacheError.message);
    }

    return responseHelper.success(res, result);

  } catch (error) {
    console.error('获取咨询列表失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 创建咨询
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const createConsultation = async (req, res) => {
  try {
    const {
      nutritionistId,
      consultationType = 'text',
      topic,
      scheduledTime,
      paymentInfo
    } = req.body;

    // 获取当前用户ID
    const userId = req.user._id;

    // 验证营养师是否存在
    const nutritionist = await Nutritionist.findById(nutritionistId);
    if (!nutritionist) {
      return responseHelper.error(res, { message: '营养师不存在' }, 404);
    }

    // 创建咨询
    const consultation = await Consultation.createConsultation(
      userId,
      nutritionistId,
      {
        consultationType,
        topic: topic || '营养咨询',
        scheduledTime: scheduledTime ? new Date(scheduledTime) : null,
        paymentInfo
      }
    );

    // 加载关联数据
    await consultation.populate('userId', 'username nickname avatar phone');
    await consultation.populate({
      path: 'nutritionistId',
      select: 'userId name avatar specializations qualifications',
      populate: {
        path: 'userId',
        select: 'username nickname avatar'
      }
    });

    // 格式化返回数据
    const formattedConsultation = {
      id: consultation._id,
      userId: consultation.userId._id,
      userName: consultation.userId.nickname || consultation.userId.username,
      userAvatar: consultation.userId.avatar,
      nutritionistId: consultation.nutritionistId._id,
      nutritionistName: consultation.nutritionistId.name || consultation.nutritionistId.userId?.nickname,
      nutritionistAvatar: consultation.nutritionistId.avatar || consultation.nutritionistId.userId?.avatar,
      consultationType: consultation.consultationType,
      status: consultation.status,
      scheduledTime: consultation.scheduledTime,
      topic: consultation.topic,
      messages: consultation.messages,
      payment: consultation.payment,
      createdAt: consultation.createdAt,
      updatedAt: consultation.updatedAt
    };

    return responseHelper.success(res, formattedConsultation, '咨询创建成功');

  } catch (error) {
    console.error('创建咨询失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 获取咨询详情
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getConsultationDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const consultation = await Consultation.findById(id)
      .populate('userId', 'username nickname avatar phone')
      .populate({
        path: 'nutritionistId',
        select: 'userId name avatar specializations qualifications ratings',
        populate: {
          path: 'userId',
          select: 'username nickname avatar'
        }
      });

    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }

    // 检查权限
    const isUser = req.user._id.toString() === consultation.userId._id.toString();
    const isNutritionist = req.user.role === 'nutritionist' && 
      consultation.nutritionistId?.userId?._id.toString() === req.user._id.toString();

    if (!isUser && !isNutritionist && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权查看此咨询' }, 403);
    }

    // 格式化返回数据
    const formattedConsultation = {
      id: consultation._id,
      userId: consultation.userId._id,
      userName: consultation.userId.nickname || consultation.userId.username,
      userAvatar: consultation.userId.avatar,
      nutritionistId: consultation.nutritionistId?._id,
      nutritionistName: consultation.nutritionistId?.name || consultation.nutritionistId?.userId?.nickname,
      nutritionistAvatar: consultation.nutritionistId?.avatar || consultation.nutritionistId?.userId?.avatar,
      consultationType: consultation.consultationType,
      status: consultation.status,
      scheduledTime: consultation.scheduledTime,
      startTime: consultation.startTime,
      endTime: consultation.endTime,
      topic: consultation.topic,
      messages: consultation.messages,
      professionalFeedback: consultation.professionalFeedback,
      followUpRecommendations: consultation.followUpRecommendations,
      requiresFollowUp: consultation.requiresFollowUp,
      payment: consultation.payment,
      userRating: consultation.userRating,
      createdAt: consultation.createdAt,
      updatedAt: consultation.updatedAt
    };

    return responseHelper.success(res, formattedConsultation);

  } catch (error) {
    console.error('获取咨询详情失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 更新咨询状态
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const updateConsultationStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const consultation = await Consultation.findById(id);
    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }

    // 检查权限
    const isNutritionist = req.user.role === 'nutritionist';
    const nutritionist = isNutritionist ? await Nutritionist.findOne({ userId: req.user._id }) : null;
    const isConsultationNutritionist = nutritionist && 
      consultation.nutritionistId.toString() === nutritionist._id.toString();

    if (!isConsultationNutritionist && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权更新此咨询状态' }, 403);
    }

    // 更新状态
    consultation.status = status;
    if (status === 'inProgress' && !consultation.startTime) {
      consultation.startTime = new Date();
    }
    if (status === 'completed' && !consultation.endTime) {
      consultation.endTime = new Date();
    }

    await consultation.save();

    return responseHelper.success(res, consultation, '咨询状态更新成功');

  } catch (error) {
    console.error('更新咨询状态失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 获取咨询市场列表（公开的咨询）
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getConsultationMarket = async (req, res) => {
  try {
    const {
      specialization,
      minRating,
      maxPrice,
      page = 1,
      limit = 20
    } = req.query;

    // 构建营养师查询条件
    const nutritionistQuery = {};
    if (specialization) {
      nutritionistQuery['specializations'] = specialization;
    }
    if (minRating) {
      nutritionistQuery['ratings.averageRating'] = { $gte: parseFloat(minRating) };
    }

    // 查找符合条件的营养师
    const nutritionists = await Nutritionist.find(nutritionistQuery)
      .populate('userId', 'username nickname avatar')
      .lean();

    const nutritionistIds = nutritionists.map(n => n._id);

    // 构建咨询查询条件
    const consultationQuery = {
      nutritionistId: { $in: nutritionistIds },
      status: 'scheduled',
      scheduledTime: { $gte: new Date() },
      'payment.status': 'pending'
    };

    if (maxPrice) {
      consultationQuery['payment.amount'] = { $lte: parseFloat(maxPrice) };
    }

    // 查询可用的咨询
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    const [consultations, total] = await Promise.all([
      Consultation.find(consultationQuery)
        .sort({ scheduledTime: 1 })
        .skip(skip)
        .limit(parseInt(limit))
        .populate('nutritionistId')
        .lean(),
      Consultation.countDocuments(consultationQuery)
    ]);

    // 格式化返回数据
    const formattedConsultations = consultations.map(consultation => {
      const nutritionist = nutritionists.find(
        n => n._id.toString() === consultation.nutritionistId.toString()
      );

      return {
        id: consultation._id,
        nutritionistId: consultation.nutritionistId,
        nutritionistName: nutritionist?.name || nutritionist?.userId?.nickname,
        nutritionistAvatar: nutritionist?.avatar || nutritionist?.userId?.avatar,
        specializations: nutritionist?.specializations || [],
        rating: nutritionist?.ratings?.averageRating || 0,
        consultationType: consultation.consultationType,
        scheduledTime: consultation.scheduledTime,
        topic: consultation.topic,
        price: consultation.payment?.amount || 0,
        createdAt: consultation.createdAt
      };
    });

    return responseHelper.success(res, {
      consultations: formattedConsultations,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('获取咨询市场列表失败:', error);
    return responseHelper.error(res, error);
  }
};

// 导出控制器方法
module.exports = {
  getConsultationList,
  createConsultation,
  getConsultationDetail,
  updateConsultationStatus,
  getConsultationMarket
};
