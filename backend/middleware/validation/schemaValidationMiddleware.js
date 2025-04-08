const mongoose = require('mongoose');
const { AppError, ErrorTypes } = require('../core/errorHandlingMiddleware');

/**
 * Schema验证中间件集合
 * 提供MongoDB Schema验证功能，包括：
 * - 验证数据是否符合指定Schema
 * - 验证ObjectId格式
 * - 验证必填字段
 */

// 验证ObjectId中间件
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

// 验证Schema中间件
const validateSchema = (schema) => {
  return (req, res, next) => {
    try {
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

// 验证必填字段中间件
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