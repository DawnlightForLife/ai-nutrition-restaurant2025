/**
 * ✅ 模块名：schemaValidationMiddleware.js
 * ✅ 命名风格统一：camelCase
 * ✅ 功能概览：
 *   - validateObjectId：验证请求中指定字段是否为有效 MongoDB ObjectId
 *   - validateSchema：基于 Mongoose Schema 同步验证传入数据结构（已弃用）
 *   - validateRequiredFields：检查请求体中是否缺少必填字段
 * ✅ 错误处理：
 *   - 使用 AppError 抛出结构化错误（类型为 VALIDATION_ERROR）
 * ✅ 注意事项：
 *   - validateSchema 中通过 new mongoose.Model({}, schema) 会抛弃现有模型定义逻辑，不推荐使用
 * ✅ 推荐 future：
 *   - 用 Ajv 或 Joi 替代 validateSchema（避免动态 new Model 带来的验证不确定性）
 *   - validateObjectId 支持多个字段同时验证
 */
const mongoose = require('mongoose');
const { AppError, ErrorTypes } = require('../core/errorHandlingMiddleware');


/**
 * validateObjectId(idField = 'id')
 * - 检查 req.params/body/query 中的指定字段是否为有效的 ObjectId
 * - 若不存在该字段，跳过；若格式非法则抛错
 */
const validateObjectId = (idField = 'id') => {
  return (req, res, next) => {
    const id = req.params[idField] || req.body[idField] || req.query[idField];
    
    if (!id) {
      return next();
    }
    
    if (!mongoose.Types.ObjectId.isValid(id)) {
      throw new AppError(
        `无效的ID格式: ${id}`,
        400,
        ErrorTypes.VALIDATION_ERROR,
        { field: idField }
      );
    }
    
    next();
  };
};

/**
 * validateSchema(schema)
 * - 使用 mongoose.Model 临时验证请求体结构（不推荐）
 * - 若验证失败，则整理错误信息并统一抛出 AppError
 * - TODO: 使用 ajv/joi 等替代更具可控性
 */
const validateSchema = (schema) => {
  return (req, res, next) => {
    try {
      // TODO: 替换为 Joi/Ajv 静态 schema 校验，移除动态 mongoose.Model 使用
      const newDoc = new mongoose.Model({}, schema);
      const validationError = newDoc.validateSync();
      
      if (validationError) {
        const errors = Object.keys(validationError.errors).map(field => ({
          field,
          message: validationError.errors[field].message
        }));
        
        throw new AppError(
          'Schema验证失败',
          400,
          ErrorTypes.VALIDATION_ERROR,
          { errors }
        );
      }
      
      next();
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }
      
      next(error);
    }
  };
};

/**
 * validateRequiredFields(fields)
 * - 检查 req.body 中是否缺少必填字段（undefined/null/空字符串均视为缺失）
 * - 若缺失，则抛出带字段列表的结构化错误
 */
const validateRequiredFields = (fields = []) => {
  return (req, res, next) => {
    const missingFields = fields.filter(field => {
      const value = req.body[field];
      return value === undefined || value === null || value === '';
    });
    
    if (missingFields.length > 0) {
      throw new AppError(
        '缺少必填字段',
        400,
        ErrorTypes.VALIDATION_ERROR,
        { 
          fields: missingFields,
          message: `缺少必填字段: ${missingFields.join(', ')}` 
        }
      );
    }
    
    next();
  };
};

module.exports = {
  validateObjectId,
  validateSchema,
  validateRequiredFields
}; 