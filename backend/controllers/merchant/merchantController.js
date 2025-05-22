/**
 * 商家控制器模块（merchantController）
 * 管理商家相关的所有请求：创建、更新、查询、审核、删除
 * 使用认证中间件 req.user 限制操作权限，确保用户与数据一致性
 * @module controllers/merchant/merchantController
 */

// ✅ 所有方法为 async 函数
// ✅ 返回结构统一：{ success, message, data? }
// ✅ 权限控制逻辑清晰：用户本人或管理员

const { merchantService } = require('../../services');
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 创建商家信息
 * - 用户必须为已认证用户（req.user.id 提供）
 * - 商家信息写入数据库，禁止自行附带 userId
 * - 返回商家创建结果
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
 * - 支持多条件筛选、分页、排序
 * - 返回商家列表及分页信息
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
 * - 根据商家ID查询详细信息
 * - 返回商家详情或错误信息
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
 * 更新商家信息
 * - 用户必须是商家本人或管理员
 * - 禁止修改关键字段，避免越权
 * - 返回更新后的商家信息
 */
// NOTE: 以下字段禁止外部修改，防止越权操作
// - userId / verification / accountStatus / stats
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
 * 删除商家信息
 * - 用户必须是商家本人或管理员
 * - 返回删除操作结果
 */
// NOTE: 以下字段禁止外部修改，防止越权操作
// - userId / verification / accountStatus / stats
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
 * - 仅管理员可执行
 * - 更新审核状态及相关信息
 * - 返回审核结果
 */
// ONLY ADMIN: 仅限管理员角色可执行此操作
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
