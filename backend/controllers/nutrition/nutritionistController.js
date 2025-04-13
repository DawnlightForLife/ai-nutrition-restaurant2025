/**
 * 营养师控制器
 * 处理营养师相关的所有请求，包括营养师资料、审核等
 * @module controllers/nutrition/nutritionistController
 */

const { nutritionistService } = require('../../services');
const catchAsync = require('../../utils/catchAsync');

/**
 * 创建营养师
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建营养师的JSON响应
 */
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
