/**
 * 营养师控制器
 * 处理营养师相关的所有请求，包括营养师资料、审核等
 * @module controllers/nutrition/nutritionistController
 */

// ✅ 命名风格为 camelCase
// ✅ 所有控制器方法为 async 函数，使用 catchAsync 包装
// ✅ 返回结构统一为 { success, message, data? }
// ✅ 权限校验清晰（本人或 admin）
// ✅ 保护字段已排除更新（userId / verification / ratings）

const { nutritionistService } = require('../../services');
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 创建营养师
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建营养师的JSON响应
 */
// NOTE: 自动从 req.user 读取 userId，确保只能由本人创建
// - 推荐添加字段校验逻辑（服务层/中间件）
// - 建议 future: 日志记录与资质证书文件上传
exports.createNutritionist = catchAsync(async (req, res) => {
  const data = req.body;
  
  // 确保userId来自已认证的用户
  data.userId = req.user.id;
  
  const result = await nutritionistService.createNutritionist(data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(201).json({
    success: true,
    message: '营养师资料创建成功',
    data: result.data
  });
});

/**
 * 获取营养师列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含营养师列表的JSON响应
 */
// NOTE: 支持筛选项：专业方向、评分、价格范围
// - 默认按评分倒序排序
// - 预留排序字段扩展接口
exports.getNutritionistList = catchAsync(async (req, res) => {
  const { 
    specialization, 
    minRating,
    consultationFeeRange,
    limit = 10, 
    skip = 0, 
    sortBy = 'ratings.averageRating', 
    sortOrder = -1 
  } = req.query;
  
  const options = {
    specialization,
    minRating: minRating ? parseFloat(minRating) : undefined,
    consultationFeeRange: consultationFeeRange ? JSON.parse(consultationFeeRange) : undefined,
    limit: parseInt(limit),
    skip: parseInt(skip),
    sort: { [sortBy]: parseInt(sortOrder) }
  };
  
  const result = await nutritionistService.getNutritionists(options);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取营养师列表成功',
    data: result.data,
    pagination: result.pagination
  });
});

/**
 * 获取单个营养师详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个营养师的JSON响应
 */
exports.getNutritionistById = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  const result = await nutritionistService.getNutritionistById(id);
  
  if (!result.success) {
    return res.status(404).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取营养师详情成功',
    data: result.data
  });
});

/**
 * 更新营养师
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后营养师的JSON响应
 */
// NOTE: 仅本人或管理员可修改
// - 禁止更新字段：userId / verification / ratings
// - 推荐 future: 审计日志记录
exports.updateNutritionist = catchAsync(async (req, res) => {
  const { id } = req.params;
  const data = req.body;
  
  // 确保只有营养师本人可以更新
  const nutritionist = await nutritionistService.getNutritionistById(id);
  
  if (!nutritionist.success) {
    return res.status(404).json({
      success: false,
      message: nutritionist.message
    });
  }
  
  // 验证用户权限
  if (nutritionist.data.userId.toString() !== req.user.id && req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权更新此营养师信息'
    });
  }
  
  // 防止更新某些字段
  delete data.userId;
  delete data.verification;
  delete data.ratings;
  
  const result = await nutritionistService.updateNutritionist(id, data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '营养师信息更新成功',
    data: result.data
  });
});

/**
 * 删除营养师
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
// NOTE: 本人或管理员可删除
// - 可采用逻辑删除（如 isDeleted 标记）
exports.deleteNutritionist = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  // 确保只有营养师本人或管理员可以删除
  const nutritionist = await nutritionistService.getNutritionistById(id);
  
  if (!nutritionist.success) {
    return res.status(404).json({
      success: false,
      message: nutritionist.message
    });
  }
  
  // 验证用户权限
  if (nutritionist.data.userId.toString() !== req.user.id && req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权删除此营养师信息'
    });
  }
  
  const result = await nutritionistService.deleteNutritionist(id);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '营养师信息删除成功'
  });
});

/**
 * 审核营养师资质
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
// ONLY ADMIN: 管理员才能执行审核
// - 更新字段：verificationStatus / rejectedReason / reviewedBy / reviewedAt
// - 建议 future: 审核通知推送与记录
exports.verifyNutritionist = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { verificationStatus, rejectedReason } = req.body;
  
  // 只有管理员可以审核
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权进行此操作'
    });
  }
  
  const result = await nutritionistService.verifyNutritionist(id, {
    verificationStatus,
    rejectedReason,
    reviewedBy: req.user.id,
    reviewedAt: new Date()
  });
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '营养师审核完成',
    data: result.data
  });
});

/**
 * 更新营养师在线状态
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新结果的JSON响应
 */
exports.updateOnlineStatus = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { isOnline, isAvailable, statusMessage, availableConsultationTypes } = req.body;
  
  // 获取营养师信息并验证权限
  const nutritionist = await nutritionistService.getNutritionistById(id);
  
  if (!nutritionist.success) {
    return res.status(404).json({
      success: false,
      message: nutritionist.message
    });
  }
  
  // 验证用户权限（只有营养师本人可以更新状态）
  if (nutritionist.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权更新此营养师的在线状态'
    });
  }
  
  const statusData = {
    isOnline,
    isAvailable,
    statusMessage,
    availableConsultationTypes
  };
  
  const result = await nutritionistService.updateOnlineStatus(id, statusData);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '在线状态更新成功',
    data: result.data
  });
});

/**
 * 获取在线营养师列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含在线营养师列表的JSON响应
 */
exports.getOnlineNutritionists = catchAsync(async (req, res) => {
  const { 
    specialization, 
    consultationType,
    limit = 20
  } = req.query;
  
  const options = {
    specialization,
    consultationType,
    limit: parseInt(limit)
  };
  
  const result = await nutritionistService.getOnlineNutritionists(options);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取在线营养师列表成功',
    data: result.data
  });
});

/**
 * 设置营养师可用时间段
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含设置结果的JSON响应
 */
exports.updateAvailabilitySchedule = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { availableTimeSlots } = req.body;
  
  // 获取营养师信息并验证权限
  const nutritionist = await nutritionistService.getNutritionistById(id);
  
  if (!nutritionist.success) {
    return res.status(404).json({
      success: false,
      message: nutritionist.message
    });
  }
  
  // 验证用户权限
  if (nutritionist.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权更新此营养师的时间安排'
    });
  }
  
  const updateData = {
    'serviceInfo.availableTimeSlots': availableTimeSlots
  };
  
  const result = await nutritionistService.updateNutritionist(id, updateData);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '可用时间段更新成功',
    data: result.data
  });
});
