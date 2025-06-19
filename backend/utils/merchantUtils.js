/**
 * 商家相关的通用工具函数
 * 提供数据隔离和权限检查
 */

/**
 * 获取商家ID（基于用户权限的安全版本）
 * @param {Object} req Express请求对象
 * @returns {string} 商家ID
 */
function getMerchantId(req) {
  // 超级管理员可以通过query参数指定商家ID（用于管理功能）
  if (req.user.role === 'super_admin' && req.query.merchantId) {
    return req.query.merchantId;
  }
  
  // 商家管理员只能访问自己的数据
  if (req.user.role === 'store_manager') {
    return req.user.merchantId || req.user.franchiseStoreId || req.user.id;
  }
  
  // 系统管理员可以通过query参数指定商家ID
  if (req.user.role === 'admin' && req.query.merchantId) {
    return req.query.merchantId;
  }
  
  // 商家角色只能访问自己的数据
  if (req.user.role === 'merchant') {
    return req.user.merchantId || req.user.franchiseStoreId || req.user.id;
  }
  
  // 默认返回用户关联的商家ID
  return req.user.merchantId || req.user.franchiseStoreId || req.user.id;
}

/**
 * 检查用户是否可以访问指定商家的数据
 * @param {Object} req Express请求对象
 * @param {string} targetMerchantId 目标商家ID
 * @returns {boolean} 是否有权限访问
 */
function canAccessMerchantData(req, targetMerchantId) {
  // 超级管理员和系统管理员可以访问所有商家数据
  if (['super_admin', 'admin'].includes(req.user.role)) {
    return true;
  }
  
  // 商家管理员和商家只能访问自己的数据
  const userMerchantId = req.user.merchantId || req.user.franchiseStoreId || req.user.id;
  return userMerchantId === targetMerchantId;
}

/**
 * 验证商家数据访问权限的中间件
 */
function validateMerchantAccess(req, res, next) {
  try {
    const merchantId = getMerchantId(req);
    
    if (!merchantId) {
      return res.status(403).json({
        success: false,
        message: '无法确定商家身份，请联系管理员'
      });
    }
    
    // 将商家ID添加到请求对象中，供后续使用
    req.merchantId = merchantId;
    next();
  } catch (error) {
    console.error('商家权限验证错误:', error);
    res.status(500).json({
      success: false,
      message: '权限验证失败'
    });
  }
}

module.exports = {
  getMerchantId,
  canAccessMerchantData,
  validateMerchantAccess
};