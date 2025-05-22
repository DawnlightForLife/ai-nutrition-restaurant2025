/**
 * Schema JSON转换服务模块（SchemaJsonConverter）
 * 用于将 Mongoose 模型结构转换为符合 JSON Schema 标准的对象格式
 * 支持字段描述、验证规则、引用结构等扩展
 * 同时支持从 JSON Schema 生成 MongoDB 数据验证规则
 * 提供 convertToJsonSchema / convertAllModelsToJsonSchema / convertToMongoDBValidation 等方法
 * @module services/core/schemaJsonConverter
 */

const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * Schema JSON转换器类 - 将Mongoose Schema转换为JSON Schema
 */
class SchemaJsonConverter {
  constructor() {
    this.logger = logger.child({ service: 'SchemaJsonConverter' });
    this.logger.info('SchemaJsonConverter服务已初始化');
    
    // JSON Schema版本
    this.jsonSchemaVersion = '2020-12';
    
    // MongoDB类型到JSON Schema类型的映射
    this.typeMapping = {
      String: { type: 'string' },
      Number: { type: 'number' },
      Date: { type: 'string', format: 'date-time' },
      Boolean: { type: 'boolean' },
      Buffer: { type: 'string', format: 'byte' },
      ObjectId: { type: 'string', format: 'objectid' },
      Mixed: { type: 'object' },
      Array: { type: 'array' },
      Map: { type: 'object' },
      Decimal128: { type: 'number', format: 'decimal128' }
    };
  }

  /**
   * 将Mongoose模型转换为JSON Schema
   * @param {Object|String} model - Mongoose模型对象或模型名称
   * @param {Object} options - 转换选项
   * @param {Boolean} options.includeComments - 是否包含注释信息
   * @param {Boolean} options.includeValidation - 是否包含验证规则
   * @param {Boolean} options.includeRefs - 是否包含引用信息
   * @returns {Object} JSON Schema对象
   */
  convertToJsonSchema(model, options = {}) {
    try {
      // 处理模型参数，支持模型名称或模型对象
      const modelObj = typeof model === 'string' ? mongoose.model(model) : model;
      if (!modelObj || !modelObj.schema) {
        throw new Error('无效的Mongoose模型');
      }

      const { 
        includeComments = true, 
        includeValidation = true,
        includeRefs = true 
      } = options;
      
      // 创建基本JSON Schema结构
      const jsonSchema = {
        $schema: `https://json-schema.org/draft/${this.jsonSchemaVersion}/schema`,
        title: modelObj.modelName,
        description: `MongoDB ${modelObj.collection.name} 集合的JSON Schema`,
        type: 'object',
        properties: {},
        required: []
      };

      // 转换所有路径
      this._convertPaths(modelObj.schema.paths, jsonSchema, { 
        includeComments, 
        includeValidation,
        includeRefs 
      });

      return jsonSchema;
    } catch (error) {
      this.logger.error('转换模型到 JSON Schema 时出错', { error });
      throw error;
    }
  }

  /**
   * 转换所有Mongoose模型为JSON Schema
   * @param {Object} options - 转换选项
   * @returns {Object} 包含所有模型JSON Schema的对象
   */
  convertAllModelsToJsonSchema(options = {}) {
    try {
      const modelNames = mongoose.modelNames();
      const result = {};

      modelNames.forEach(modelName => {
        result[modelName] = this.convertToJsonSchema(modelName, options);
      });

      return result;
    } catch (error) {
      this.logger.error('转换所有模型到 JSON Schema 时出错', { error });
      throw error;
    }
  }

  /**
   * 转换Mongoose Schema路径到JSON Schema属性
   * @private
   * @param {Object} paths - Mongoose Schema路径对象
   * @param {Object} jsonSchema - 目标JSON Schema对象
   * @param {Object} options - 转换选项
   */
  _convertPaths(paths, jsonSchema, options) {
    Object.keys(paths).forEach(pathName => {
      // 跳过Mongoose内部字段
      if (pathName === '__v') {
        return;
      }

      const path = paths[pathName];
      const schemaProperty = this._convertPath(path, options);
      
      // 添加到属性中
      jsonSchema.properties[pathName] = schemaProperty;
      
      // 处理必填字段
      if (path.isRequired) {
        jsonSchema.required.push(pathName);
      }
    });
    
    // 如果没有必填字段，删除required数组
    if (jsonSchema.required.length === 0) {
      delete jsonSchema.required;
    }
  }

  /**
   * 转换单个Mongoose路径到JSON Schema属性
   * @private
   * @param {Object} path - Mongoose路径对象
   * @param {Object} options - 转换选项
   * @returns {Object} JSON Schema属性定义
   */
  _convertPath(path, options) {
    const { includeComments, includeValidation, includeRefs } = options;
    const property = {};
    
    // 处理字段类型
    this._handleType(path, property);
    
    // 处理验证规则（如果启用）
    if (includeValidation) {
      this._addValidationRules(path, property);
    }
    
    // 处理描述（如果启用）
    if (includeComments && path.options && path.options.description) {
      property.description = path.options.description;
    }
    
    // 处理引用（如果启用）
    if (includeRefs && path.options && path.options.ref) {
      property.format = 'objectid';
      property['x-ref'] = path.options.ref;
    }
    
    return property;
  }

  /**
   * 处理字段类型转换
   * @private
   * @param {Object} path - Mongoose路径对象
   * @param {Object} property - JSON Schema属性对象
   */
  _handleType(path, property) {
    // 处理默认值
    if (path.defaultValue !== undefined && typeof path.defaultValue !== 'function') {
      property.default = path.defaultValue;
    }

    // 根据实例类型设置JSON Schema类型
    if (path.instance === 'Array') {
      property.type = 'array';
      
      // 处理数组项的类型
      if (path.caster) {
        // 处理基本类型数组
        property.items = this._getJsonSchemaType(path.caster.instance);
        
        // 处理数组项的引用
        if (path.caster.options && path.caster.options.ref) {
          property.items.format = 'objectid';
          property.items['x-ref'] = path.caster.options.ref;
        }
      } else if (path.schema) {
        // 处理子文档数组
        property.items = {
          type: 'object',
          properties: {}
        };
        
        // 转换子文档的所有字段
        this._convertPaths(path.schema.paths, property.items, { 
          includeComments: true, 
          includeValidation: true,
          includeRefs: true 
        });
      } else {
        // 默认为Mixed类型
        property.items = { type: 'object' };
      }
    } else if (path.instance === 'Embedded' || path.instance === 'Mixed') {
      // 处理嵌入式文档
      property.type = 'object';
      
      if (path.schema) {
        property.properties = {};
        
        // 转换子文档的所有字段
        this._convertPaths(path.schema.paths, property, { 
          includeComments: true, 
          includeValidation: true,
          includeRefs: true 
        });
      }
    } else {
      // 处理基本类型
      const typeInfo = this._getJsonSchemaType(path.instance);
      Object.assign(property, typeInfo);
    }
  }

  /**
   * 获取JSON Schema类型
   * @private
   * @param {String} mongooseType - Mongoose类型名称
   * @returns {Object} JSON Schema类型定义
   */
  _getJsonSchemaType(mongooseType) {
    return this.typeMapping[mongooseType] || { type: 'object' };
  }

  /**
   * 添加验证规则
   * @private
   * @param {Object} path - Mongoose路径对象
   * @param {Object} property - JSON Schema属性对象
   */
  _addValidationRules(path, property) {
    const options = path.options || {};
    
    // 处理枚举
    if (options.enum) {
      property.enum = options.enum;
    }
    
    // 处理最小/最大值（数字）
    if (property.type === 'number') {
      if (options.min !== undefined) {
        property.minimum = options.min;
      }
      
      if (options.max !== undefined) {
        property.maximum = options.max;
      }
    }
    
    // 处理最小/最大长度（字符串）
    if (property.type === 'string') {
      if (options.minlength !== undefined) {
        property.minLength = options.minlength;
      }
      
      if (options.maxlength !== undefined) {
        property.maxLength = options.maxlength;
      }
      
      // 处理正则表达式模式
      if (options.match) {
        const pattern = options.match.toString();
        // 从/^pattern$/形式中提取实际模式
        const patternString = pattern.slice(1, pattern.lastIndexOf('/'));
        property.pattern = patternString;
      }
      
      // 处理常见格式
      if (options.lowercase) {
        property['x-lowercase'] = true;
      }
      
      if (options.uppercase) {
        property['x-uppercase'] = true;
      }
      
      if (options.trim) {
        property['x-trim'] = true;
      }
    }
    
    // 处理唯一性约束
    if (options.unique) {
      property['x-unique'] = true;
    }
  }

  /**
   * 将JSON Schema转换回MongoDB验证对象
   * @param {Object} jsonSchema - JSON Schema对象
   * @returns {Object} MongoDB验证对象
   */
  convertToMongoDBValidation(jsonSchema) {
    try {
      // 创建MongoDB验证对象
      const validationObj = {
        $jsonSchema: {
          bsonType: "object",
          required: jsonSchema.required || [],
          properties: {}
        }
      };

      // 转换属性
      Object.keys(jsonSchema.properties).forEach(propName => {
        const prop = jsonSchema.properties[propName];
        validationObj.$jsonSchema.properties[propName] = this._convertJsonSchemaPropertyToMongoDB(prop);
      });

      return validationObj;
    } catch (error) {
      this.logger.error('转换 JSON Schema 为 MongoDB 验证对象时出错', { error });
      throw error;
    }
  }

  /**
   * 将JSON Schema属性转换为MongoDB验证属性
   * @private
   * @param {Object} property - JSON Schema属性
   * @returns {Object} MongoDB验证属性
   */
  _convertJsonSchemaPropertyToMongoDB(property) {
    const result = {};
    
    // 转换类型
    if (property.type === 'string') {
      result.bsonType = 'string';
    } else if (property.type === 'number') {
      result.bsonType = 'number';
    } else if (property.type === 'boolean') {
      result.bsonType = 'bool';
    } else if (property.type === 'object') {
      result.bsonType = 'object';
      
      if (property.properties) {
        result.properties = {};
        Object.keys(property.properties).forEach(propName => {
          result.properties[propName] = this._convertJsonSchemaPropertyToMongoDB(property.properties[propName]);
        });
        
        if (property.required) {
          result.required = property.required;
        }
      }
    } else if (property.type === 'array') {
      result.bsonType = 'array';
      
      if (property.items) {
        result.items = this._convertJsonSchemaPropertyToMongoDB(property.items);
      }
    }
    
    // 转换验证规则
    if (property.enum) {
      result.enum = property.enum;
    }
    
    if (property.minimum !== undefined) {
      result.minimum = property.minimum;
    }
    
    if (property.maximum !== undefined) {
      result.maximum = property.maximum;
    }
    
    if (property.minLength !== undefined) {
      result.minLength = property.minLength;
    }
    
    if (property.maxLength !== undefined) {
      result.maxLength = property.maxLength;
    }
    
    if (property.pattern) {
      result.pattern = property.pattern;
    }
    
    return result;
  }
}

module.exports = { SchemaJsonConverter };