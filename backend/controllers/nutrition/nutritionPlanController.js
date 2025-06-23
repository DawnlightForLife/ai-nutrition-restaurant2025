/**
 * 营养计划管理控制器
 * 处理用户营养计划的增删改查
 */

const NutritionPlan = require('../../models/nutrition/nutritionPlanModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const User = require('../../models/user/userModel');
const { responseHelper } = require('../../utils');

/**
 * 获取营养计划列表
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getNutritionPlanList = async (req, res) => {
  try {
    const {
      userId,
      nutritionistId,
      status,
      visibility,
      page = 1,
      limit = 20,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // 构建查询条件
    const query = {};
    
    // 根据用户角色决定查询条件
    if (req.user && req.user.role === 'nutritionist') {
      // 营养师查看自己创建的计划
      const nutritionist = await Nutritionist.findOne({ userId: req.user._id });
      if (nutritionist && nutritionistId) {
        query['createdBy.nutritionistId'] = nutritionist._id;
      }
    } else if (userId) {
      // 用户查看自己的计划
      query.userId = userId;
    } else if (req.user && req.user._id) {
      // 默认查看当前用户的计划
      query.userId = req.user._id;
    }

    // 状态筛选
    if (status) {
      query.status = status;
    }

    // 可见性筛选
    if (visibility) {
      query.visibility = visibility;
    }

    // 计算分页
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const sort = { [sortBy]: sortOrder === 'asc' ? 1 : -1 };

    // 执行查询
    const [plans, total] = await Promise.all([
      NutritionPlan.find(query)
        .sort(sort)
        .skip(skip)
        .limit(parseInt(limit))
        .populate('userId', 'username nickname avatar')
        .populate('createdBy.userId', 'username nickname avatar')
        .populate('createdBy.nutritionistId', 'name avatar specializations')
        .lean(),
      NutritionPlan.countDocuments(query)
    ]);

    // 格式化返回数据
    const formattedPlans = plans.map(plan => ({
      id: plan._id,
      userId: plan.userId?._id,
      userName: plan.userId?.nickname || plan.userId?.username,
      userAvatar: plan.userId?.avatar,
      name: plan.name,
      description: plan.description,
      status: plan.status,
      visibility: plan.visibility,
      startDate: plan.startDate,
      endDate: plan.endDate,
      goals: plan.goals,
      progress: plan.progress,
      nutritionistId: plan.createdBy?.nutritionistId?._id,
      nutritionistName: plan.createdBy?.nutritionistId?.name,
      createdBy: plan.createdBy?.type,
      createdAt: plan.createdAt,
      updatedAt: plan.updatedAt
    }));

    return responseHelper.success(res, {
      plans: formattedPlans,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('获取营养计划列表失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 创建营养计划
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const createNutritionPlan = async (req, res) => {
  try {
    const {
      name,
      description,
      startDate,
      endDate,
      goals,
      dailyPlans,
      targetUserId
    } = req.body;

    // 确定计划的用户ID
    const userId = targetUserId || req.user._id;

    // 验证用户是否存在
    const user = await User.findById(userId);
    if (!user) {
      return responseHelper.error(res, { message: '用户不存在' }, 404);
    }

    // 创建者信息
    const createdBy = { type: 'user', userId: req.user._id };
    
    // 如果是营养师创建
    if (req.user.role === 'nutritionist') {
      const nutritionist = await Nutritionist.findOne({ userId: req.user._id });
      if (nutritionist) {
        createdBy.type = 'nutritionist';
        createdBy.nutritionistId = nutritionist._id;
      }
    }

    // 创建营养计划
    const nutritionPlan = new NutritionPlan({
      userId,
      name,
      description,
      status: 'draft',
      visibility: 'private',
      startDate: new Date(startDate),
      endDate: new Date(endDate),
      goals: goals || [],
      dailyPlans: dailyPlans || [],
      createdBy,
      notifications: {
        reminder: true,
        progress: true,
        recommendation: true
      }
    });

    await nutritionPlan.save();

    // 加载关联数据
    await nutritionPlan.populate('userId', 'username nickname avatar');
    await nutritionPlan.populate('createdBy.userId', 'username nickname avatar');
    await nutritionPlan.populate('createdBy.nutritionistId', 'name avatar specializations');

    // 格式化返回数据
    const formattedPlan = {
      id: nutritionPlan._id,
      userId: nutritionPlan.userId._id,
      userName: nutritionPlan.userId.nickname || nutritionPlan.userId.username,
      userAvatar: nutritionPlan.userId.avatar,
      name: nutritionPlan.name,
      description: nutritionPlan.description,
      status: nutritionPlan.status,
      visibility: nutritionPlan.visibility,
      startDate: nutritionPlan.startDate,
      endDate: nutritionPlan.endDate,
      goals: nutritionPlan.goals,
      dailyPlans: nutritionPlan.dailyPlans,
      createdBy: nutritionPlan.createdBy,
      createdAt: nutritionPlan.createdAt,
      updatedAt: nutritionPlan.updatedAt
    };

    return responseHelper.success(res, formattedPlan, '营养计划创建成功');

  } catch (error) {
    console.error('创建营养计划失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 获取营养计划详情
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getNutritionPlanDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const plan = await NutritionPlan.findById(id)
      .populate('userId', 'username nickname avatar')
      .populate('createdBy.userId', 'username nickname avatar')
      .populate('createdBy.nutritionistId', 'name avatar specializations');

    if (!plan) {
      return responseHelper.error(res, { message: '营养计划不存在' }, 404);
    }

    // 检查权限
    const isOwner = req.user._id.toString() === plan.userId._id.toString();
    const isCreator = plan.createdBy?.userId?._id.toString() === req.user._id.toString();
    
    if (!isOwner && !isCreator && plan.visibility === 'private' && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权查看此营养计划' }, 403);
    }

    // 格式化返回数据
    const formattedPlan = {
      id: plan._id,
      userId: plan.userId._id,
      userName: plan.userId.nickname || plan.userId.username,
      userAvatar: plan.userId.avatar,
      name: plan.name,
      description: plan.description,
      status: plan.status,
      visibility: plan.visibility,
      startDate: plan.startDate,
      endDate: plan.endDate,
      goals: plan.goals,
      dailyPlans: plan.dailyPlans,
      progress: plan.progress,
      analytics: plan.analytics,
      notifications: plan.notifications,
      createdBy: plan.createdBy,
      createdAt: plan.createdAt,
      updatedAt: plan.updatedAt
    };

    return responseHelper.success(res, formattedPlan);

  } catch (error) {
    console.error('获取营养计划详情失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 更新营养计划
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const updateNutritionPlan = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    const plan = await NutritionPlan.findById(id);
    if (!plan) {
      return responseHelper.error(res, { message: '营养计划不存在' }, 404);
    }

    // 检查权限
    const isOwner = req.user._id.toString() === plan.userId.toString();
    const isCreator = plan.createdBy?.userId?.toString() === req.user._id.toString();

    if (!isOwner && !isCreator && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权更新此营养计划' }, 403);
    }

    // 更新计划
    Object.assign(plan, updates);
    await plan.save();

    return responseHelper.success(res, plan, '营养计划更新成功');

  } catch (error) {
    console.error('更新营养计划失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 删除营养计划
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const deleteNutritionPlan = async (req, res) => {
  try {
    const { id } = req.params;

    const plan = await NutritionPlan.findById(id);
    if (!plan) {
      return responseHelper.error(res, { message: '营养计划不存在' }, 404);
    }

    // 检查权限
    const isOwner = req.user._id.toString() === plan.userId.toString();
    if (!isOwner && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权删除此营养计划' }, 403);
    }

    await plan.remove();

    return responseHelper.success(res, null, '营养计划删除成功');

  } catch (error) {
    console.error('删除营养计划失败:', error);
    return responseHelper.error(res, error);
  }
};

// 导出控制器方法
module.exports = {
  getNutritionPlanList,
  createNutritionPlan,
  getNutritionPlanDetail,
  updateNutritionPlan,
  deleteNutritionPlan
};
