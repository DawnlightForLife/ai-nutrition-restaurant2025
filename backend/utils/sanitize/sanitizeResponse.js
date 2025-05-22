/**
 * 响应数据敏感字段过滤
 * 根据Mongoose schema中标记的sensitive属性过滤敏感字段
 * 适用于 API 返回数据前自动移除未授权访问的字段，如手机号、身份证号等。
 */

/**
 * 递归检查并清理对象中的敏感字段
 * 根据当前用户权限（是否认证/是否为管理员/是否为数据所有者）决定是否保留字段
 * @param {Object} obj - 需要处理的对象
 * @param {Array} path - 当前处理的路径
 * @param {Object} sensitivityMap - 敏感字段映射
 * @param {Boolean} hasAuthentication - 用户是否已认证
 * @param {String} userId - 当前用户ID
 * @param {Boolean} isAdmin - 当前用户是否为管理员
 * @returns {Object} 处理后的对象
 */
const sanitizeObject = (obj, path = [], sensitivityMap = {}, hasAuthentication = false, userId = null, isAdmin = false) => {
  // 如果不是对象或者是null，直接返回
  if (!obj || typeof obj !== 'object') {
    return obj;
  }

  // 处理数组
  if (Array.isArray(obj)) {
    return obj.map(item => sanitizeObject(item, path, sensitivityMap, hasAuthentication, userId, isAdmin));
  }

  // 检查是否为Mongoose文档，如果是，获取其schema的sensitivityMap
  const modelSensitivityMap = obj.constructor && obj.constructor.schema ? 
    extractSensitivityMap(obj.constructor.schema) : sensitivityMap;

  // 合并敏感字段映射
  const combinedSensitivityMap = { ...sensitivityMap, ...modelSensitivityMap };

  // 创建结果对象
  const result = {};

  // 处理普通对象
  for (const key in obj) {
    // 跳过内部属性和方法
    if (key.startsWith('_') && key !== '_id') continue;
    if (typeof obj[key] === 'function') continue;

    const currentPath = [...path, key];
    const pathString = currentPath.join('.');

    // 检查字段是否敏感
    const isSensitive = combinedSensitivityMap[pathString] || combinedSensitivityMap[key];

    // 敏感字段过滤逻辑
    if (isSensitive) {
      // 情况1：用户未登录，直接过滤
      if (!hasAuthentication) {
        continue;
      }

      // 情况2：若字段归属某用户，需判断是否为本人或管理员
      const dataOwnerId = obj.userId ? (obj.userId._id || obj.userId).toString() : null;

      if (!isAdmin && dataOwnerId && userId && dataOwnerId !== userId.toString()) {
        continue;
      }
    }

    // 递归处理嵌套对象
    result[key] = sanitizeObject(
      obj[key], 
      currentPath, 
      combinedSensitivityMap, 
      hasAuthentication, 
      userId, 
      isAdmin
    );
  }

  return result;
};

/**
 * 从Mongoose schema中提取敏感字段映射表
 * 会递归处理嵌套子Schema和数组Schema
 * @param {Object} schema - Mongoose schema对象
 * @returns {Object} 敏感字段映射
 */
const extractSensitivityMap = (schema) => {
  const sensitivityMap = {};

  // 处理基本路径
  Object.keys(schema.paths).forEach(path => {
    const schemaType = schema.paths[path];
    if (schemaType.options && schemaType.options.sensitive === true) {
      sensitivityMap[path] = true;
    }
  });

  // 处理嵌套schema
  Object.keys(schema.paths).forEach(path => {
    const schemaType = schema.paths[path];
    
    // 处理嵌套schema
    if (schemaType.schema) {
      const nestedMap = extractSensitivityMap(schemaType.schema);
      Object.keys(nestedMap).forEach(nestedPath => {
        sensitivityMap[`${path}.${nestedPath}`] = true;
      });
    }
    
    // 处理数组嵌套schema
    if (schemaType.instance === 'Array' && schemaType.schema) {
      const nestedMap = extractSensitivityMap(schemaType.schema);
      Object.keys(nestedMap).forEach(nestedPath => {
        sensitivityMap[`${path}.${nestedPath}`] = true;
      });
    }
  });

  return sensitivityMap;
};

/**
 * 过滤响应数据中的敏感字段
 * 纯函数，可在任何地方使用，不依赖Express
 * @param {Object} data - 需要过滤的数据
 * @param {Object} options - 过滤选项
 * @param {Boolean} options.hasAuthentication - 用户是否已认证
 * @param {String} options.userId - 当前用户ID
 * @param {Boolean} options.isAdmin - 当前用户是否为管理员
 * @returns {Object} 过滤后的数据
 */
const sanitizeData = (data, options = {}) => {
  const { hasAuthentication = false, userId = null, isAdmin = false } = options;
  
  return sanitizeObject(
    data, 
    [], 
    {}, 
    hasAuthentication, 
    userId, 
    isAdmin
  );
};

/**
 * Express中间件：重写res.json方法，输出前自动过滤敏感字段
 * 会根据req中用户登录信息决定是否显示敏感字段
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @param {Function} next - Express下一个中间件函数
 */
const sanitizeResponseMiddleware = (req, res, next) => {
  // 保存原始的res.json方法
  const originalJson = res.json;

  // 重写res.json方法
  res.json = function(data) {
    // 检查用户登录状态、用户ID、是否管理员
    const hasAuthentication = req.isAuthenticated && req.isAuthenticated();
    const userId = req.user ? req.user.id : null;
    const isAdmin = req.user ? req.user.isAdmin : false;

    // 过滤敏感字段
    const sanitizedData = sanitizeData(data, {
      hasAuthentication,
      userId,
      isAdmin
    });

    // 调用原始的json方法
    return originalJson.call(this, sanitizedData);
  };

  next();
};

// 导出纯函数和中间件
module.exports = sanitizeResponseMiddleware;
module.exports.sanitizeData = sanitizeData;
module.exports.sanitizeObject = sanitizeObject;
module.exports.extractSensitivityMap = extractSensitivityMap;