/**
 * Schema转换器 - 将Mongoose模型转换为可视化工具需要的格式
 * 用于数据库文档建模展示、模型对比、架构分析等自动化处理
 * 适用于Admin后台建模工具、ER图生成、Schema文档展示等场景
 * @module utils/schemaTransformer
 */

const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger');

/**
 * Schema转换器类 - 将Mongoose模型转换为标准化格式以便可视化
 */
class SchemaTransformer {
  /**
   * 获取所有注册的模型并转换为可视化格式
   * @param {Object} options - 配置选项
   * @param {Boolean} options.includeVirtuals - 是否包含虚拟字段
   * @param {Boolean} options.includeIndexes - 是否包含索引信息
   * @returns {Object} 转换后的模型数据
   * 获取所有已注册的Mongoose模型，转换其Schema为可视化格式，并添加模型间关系
   */
  static getAllModelSchemas(options = {}) {
    const { includeVirtuals = true, includeIndexes = true } = options;
    const transformedSchemas = {};
    
    try {
      // 获取所有已注册的Mongoose模型
      const modelNames = mongoose.modelNames();
      
      // 遍历模型并转换
      modelNames.forEach(modelName => {
        const model = mongoose.model(modelName);
        transformedSchemas[modelName] = this.transformModelSchema(model, { includeVirtuals, includeIndexes });
      });
      
      // 添加关系信息
      this._addRelationships(transformedSchemas);
      
      return transformedSchemas;
    } catch (error) {
      logger.error(`转换模型Schema时出错:\n${error.message}`, { error });
      return {};
    }
  }
  
  /**
   * 转换单个Mongoose模型为可视化格式
   * @param {Object} model - Mongoose模型
   * @param {Object} options - 配置选项
   * @param {Boolean} options.includeVirtuals - 是否包含虚拟字段
   * @param {Boolean} options.includeIndexes - 是否包含索引信息
   * @returns {Object} 转换后的模型数据
   * 将指定模型的Schema转换为包含字段、索引及关系信息的标准格式
   */
  static transformModelSchema(model, options = {}) {
    const { includeVirtuals = true, includeIndexes = true } = options;
    
    if (!model || !model.schema) {
      return null;
    }
    
    const schema = model.schema;
    const modelName = model.modelName;
    const result = {
      name: modelName,
      collectionName: model.collection.name,
      fields: {},
      relationships: [],
    };
    
    // 转换字段信息
    this._transformFields(schema.paths, result.fields);
    
    // 添加虚拟字段（如果启用）
    if (includeVirtuals && schema.virtuals) {
      this._transformVirtuals(schema.virtuals, result.fields);
    }
    
    // 添加索引信息（如果启用）
    if (includeIndexes && schema._indexes) {
      result.indexes = this._transformIndexes(schema._indexes);
    }
    
    return result;
  }
  
  /**
   * 转换Schema字段
   * 将Mongoose模型的每个字段路径转换为结构化描述
   * 包括类型、是否必填、是否唯一、默认值、枚举限制、范围限制等
   * @private
   * @param {Object} paths - Schema路径
   * @param {Object} targetFields - 目标字段对象
   */
  static _transformFields(paths, targetFields) {
    Object.keys(paths).forEach(pathName => {
      // 跳过Mongoose内部字段
      if (pathName === '__v') {
        return;
      }
      
      const path = paths[pathName];
      const fieldInfo = {
        type: this._getFieldType(path),
        required: path.isRequired || false,
      };
      
      // 处理引用（ref）
      if (path.options && path.options.ref) {
        fieldInfo.ref = path.options.ref;
      }
      
      // 添加额外属性
      if (path.options) {
        if (path.options.unique) {
          fieldInfo.unique = true;
        }
        
        if (path.options.default !== undefined) {
          fieldInfo.default = path.options.default;
        }
        
        if (path.options.enum) {
          fieldInfo.enum = path.options.enum;
        }
        
        if (path.options.min !== undefined) {
          fieldInfo.min = path.options.min;
        }
        
        if (path.options.max !== undefined) {
          fieldInfo.max = path.options.max;
        }
      }
      
      targetFields[pathName] = fieldInfo;
    });
  }
  
  /**
   * 转换虚拟字段（Virtuals）
   * 标记为虚拟的字段通常用于 populate 映射或逻辑字段
   * 自动提取ref、localField、foreignField等信息
   * @private
   * @param {Object} virtuals - 虚拟字段
   * @param {Object} targetFields - 目标字段对象
   */
  static _transformVirtuals(virtuals, targetFields) {
    Object.keys(virtuals).forEach(virtualName => {
      // 跳过id虚拟字段
      if (virtualName === 'id') {
        return;
      }
      
      const virtual = virtuals[virtualName];
      targetFields[virtualName] = {
        type: 'Virtual',
        isVirtual: true
      };
      
      // 检查是否是虚拟populate
      if (virtual.options && virtual.options.ref) {
        targetFields[virtualName].ref = virtual.options.ref;
        targetFields[virtualName].foreignField = virtual.options.foreignField;
        targetFields[virtualName].localField = virtual.options.localField;
      }
    });
  }
  
  /**
   * 转换索引信息
   * 将 schema._indexes 转换为结构化格式，包含字段组合、唯一性、背景索引等属性
   * @private
   * @param {Array} indexes - 索引数组
   * @returns {Array} 转换后的索引数组
   */
  static _transformIndexes(indexes) {
    return indexes.map(indexData => {
      const [fields, options] = indexData;
      
      return {
        fields,
        unique: options && options.unique ? true : false,
        sparse: options && options.sparse ? true : false,
        background: options && options.background ? true : false,
        name: options && options.name ? options.name : undefined,
      };
    });
  }
  
  /**
   * 字段类型推断工具
   * 支持识别基础类型、数组、嵌入文档、文档数组等
   * @private
   * @param {Object} path - Schema路径
   * @returns {String} 字段类型
   */
  static _getFieldType(path) {
    if (!path || !path.instance) {
      return 'Mixed';
    }
    
    if (path.instance === 'Array') {
      // 处理数组类型，递归获取数组元素类型
      const itemType = path.caster ? this._getFieldType(path.caster) : 'Mixed';
      return `[${itemType}]`;
    } else if (path.instance === 'Embedded') {
      // 处理嵌入式文档类型
      return 'Embedded';
    } else if (path.instance === 'DocumentArray') {
      // 处理文档数组类型（嵌入文档数组）
      return '[Document]';
    } else {
      // 处理基础类型（String, Number, Date, Boolean等）
      return path.instance;
    }
  }
  
  /**
   * 建立模型间的引用关系
   * 遍历字段中的ref引用，建立 hasOne / hasMany 结构的关系信息
   * @private
   * @param {Object} schemas - 转换后的模式对象
   */
  static _addRelationships(schemas) {
    Object.keys(schemas).forEach(modelName => {
      const modelSchema = schemas[modelName];
      
      // 处理引用字段
      Object.keys(modelSchema.fields).forEach(fieldName => {
        const field = modelSchema.fields[fieldName];
        
        if (field.ref && schemas[field.ref]) {
          // 创建关系对象
          const relationship = {
            from: modelName,
            to: field.ref,
            fieldName: fieldName,
            type: field.type.startsWith('[') ? 'hasMany' : 'hasOne'
          };
          
          // 添加到关系数组
          modelSchema.relationships.push(relationship);
        }
      });
    });
  }
  
  /**
   * 获取特定模型的Schema
   * @param {String} modelName - 模型名称
   * @param {Object} options - 配置选项
   * @returns {Object} 转换后的模型数据
   * 获取指定模型名称对应的Schema转换结果，包含字段、索引及关系信息
   */
  static getModelSchema(modelName, options = {}) {
    try {
      const model = mongoose.model(modelName);
      return this.transformModelSchema(model, options);
    } catch (error) {
      logger.error(`获取模型 ${modelName} 的Schema时出错:\n${error.message}`, { error });
      return null;
    }
  }
  
  /**
   * 比较两个Schema版本并生成差异
   * @param {Object} oldSchema - 旧Schema对象
   * @param {Object} newSchema - 新Schema对象
   * @returns {Object} 差异对象
   * 对比两个Schema的字段和索引，输出新增、删除、修改的详细差异
   */
  static compareSchemas(oldSchema, newSchema) {
    if (!oldSchema || !newSchema) {
      return null;
    }
    
    const differences = {
      fields: {
        added: [],
        removed: [],
        modified: []
      },
      indexes: {
        added: [],
        removed: [],
        modified: []
      }
    };
    
    // 比较字段
    this._compareFields(oldSchema.fields, newSchema.fields, differences.fields);
    
    // 比较索引（如果存在）
    if (oldSchema.indexes && newSchema.indexes) {
      this._compareIndexes(oldSchema.indexes, newSchema.indexes, differences.indexes);
    }
    
    return differences;
  }
  
  /**
   * 比较字段差异
   * 识别字段新增、删除、结构修改，便于版本控制与数据库演化
   * @private
   * @param {Object} oldFields - 旧字段对象
   * @param {Object} newFields - 新字段对象
   * @param {Object} differences - 差异对象
   */
  static _compareFields(oldFields, newFields, differences) {
    // 查找新增和修改的字段
    Object.keys(newFields).forEach(fieldName => {
      if (!oldFields[fieldName]) {
        differences.added.push({
          name: fieldName,
          details: newFields[fieldName]
        });
      } else if (JSON.stringify(oldFields[fieldName]) !== JSON.stringify(newFields[fieldName])) {
        differences.modified.push({
          name: fieldName,
          old: oldFields[fieldName],
          new: newFields[fieldName]
        });
      }
    });
    
    // 查找删除的字段
    Object.keys(oldFields).forEach(fieldName => {
      if (!newFields[fieldName]) {
        differences.removed.push({
          name: fieldName,
          details: oldFields[fieldName]
        });
      }
    });
  }
  
  /**
   * 比较索引差异
   * 包括索引新增、删除、属性变化
   * @private
   * @param {Array} oldIndexes - 旧索引数组
   * @param {Array} newIndexes - 新索引数组
   * @param {Object} differences - 差异对象
   */
  static _compareIndexes(oldIndexes, newIndexes, differences) {
    // 创建索引映射（使用JSON字符串作为键）
    const oldIndexMap = new Map();
    const newIndexMap = new Map();
    
    oldIndexes.forEach(index => {
      const key = JSON.stringify(index.fields);
      oldIndexMap.set(key, index);
    });
    
    newIndexes.forEach(index => {
      const key = JSON.stringify(index.fields);
      newIndexMap.set(key, index);
    });
    
    // 查找新增和修改的索引
    for (const [key, newIndex] of newIndexMap.entries()) {
      if (!oldIndexMap.has(key)) {
        differences.added.push(newIndex);
      } else {
        const oldIndex = oldIndexMap.get(key);
        if (JSON.stringify(oldIndex) !== JSON.stringify(newIndex)) {
          differences.modified.push({
            old: oldIndex,
            new: newIndex
          });
        }
      }
    }
    
    // 查找删除的索引
    for (const [key, oldIndex] of oldIndexMap.entries()) {
      if (!newIndexMap.has(key)) {
        differences.removed.push(oldIndex);
      }
    }
  }
}

module.exports = SchemaTransformer; 