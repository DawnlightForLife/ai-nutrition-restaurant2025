/**
 * 商家控制器
 * 处理商家基本信息相关的所有请求，包括商家注册、信息更新等
 * @module controllers/merchant/merchantController
 */

const { merchantService } = require('../../services');
const catchAsync = require('../../utils/catchAsync');

/**
 * 创建商家
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建商家的JSON响应
 */
exports.createMerchant = catchAsync(async (req, res) => {
  const data = req.body;
  
  // 确保userId来自已认证的用户
  data.userId = req.user.id;
  
  const result = await merchantService.createMerchant(data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(201).json({
    success: true,
    message: '商家注册成功',
    data: result.data
  });
});

/**
 * 获取商家列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含商家列表的JSON响应
 */
exports.getMerchantList = catchAsync(async (req, res) => {
  const { 
    businessType,
    city,
    hasNutritionist,
    specialtyDiet, 
    limit = 10, 
    skip = 0, 
    sortBy = 'stats.avgRating', 
    sortOrder = -1 
  } = req.query;
  
  const options = {
    businessType,
    city,
    hasNutritionist: hasNutritionist === 'true',
    specialtyDiet,
    limit: parseInt(limit),
    skip: parseInt(skip),
    sort: { [sortBy]: parseInt(sortOrder) }
  };
  
  const result = await merchantService.getMerchants(options);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取商家列表成功',
    data: result.data,
    pagination: result.pagination
  });
});

/**
 * 获取单个商家详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个商家的JSON响应
 */
exports.getMerchantById = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  const result = await merchantService.getMerchantById(id);
  
  if (!result.success) {
    return res.status(404).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取商家详情成功',
    data: result.data
  });
});

/**
 * 更新商家
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后商家的JSON响应
 */
exports.updateMerchant = catchAsync(async (req, res) => {
  const { id } = req.params;
  const data = req.body;
  
  // 确保只有商家本人或管理员可以更新
  const merchant = await merchantService.getMerchantById(id);
  
  if (!merchant.success) {
    return res.status(404).json({
      success: false,
      message: merchant.message
    });
  }
  
  // 验证用户权限
  if (merchant.data.userId.toString() !== req.user.id && req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权更新此商家信息'
    });
  }
  
  // 防止更新某些字段
  delete data.userId;
  delete data.verification;
  delete data.accountStatus;
  delete data.stats;
  
  const result = await merchantService.updateMerchant(id, data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '商家信息更新成功',
    data: result.data
  });
});

/**
 * 删除商家
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.deleteMerchant = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  // 确保只有商家本人或管理员可以删除
  const merchant = await merchantService.getMerchantById(id);
  
  if (!merchant.success) {
    return res.status(404).json({
      success: false,
      message: merchant.message
    });
  }
  
  // 验证用户权限
  if (merchant.data.userId.toString() !== req.user.id && req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权删除此商家信息'
    });
  }
  
  const result = await merchantService.deleteMerchant(id);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '商家信息删除成功'
  });
});

/**
 * 审核商家资质
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.verifyMerchant = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { verificationStatus, rejectionReason } = req.body;
  
  // 只有管理员可以审核
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: '无权进行此操作'
    });
  }
  
  const result = await merchantService.verifyMerchant(id, {
    verificationStatus,
    rejectionReason,
    verifiedBy: req.user.id,
    verifiedAt: new Date()
  });
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '商家审核完成',
    data: result.data
  });
});
