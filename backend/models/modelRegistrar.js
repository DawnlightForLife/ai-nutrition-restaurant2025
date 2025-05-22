const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const logger = require('../utils/logger/winstonLogger');
const { getShardKey } = require('../middleware/database/shardingMiddleware');
const { handleReadPreference } = require('../middleware/database/readPreferenceMiddleware');

/**
 * 注册Mongoose模型的辅助函数
 * 提供简化的模型创建和管理功能
 * 
 * @param {string} modelName - 模型名称
 * @param {Object} schemaDefinition - Schema定义对象
 * @param {Object} options - 配置选项
 * @param {boolean} options.timestamps - 是否添加时间戳字段
 * @param {string} options.collectionName - 自定义集合名称
 * @param {boolean} options.useSharding - 是否使用分片
 * @param {boolean} options.logRegister - 是否记录注册日志
 * @param {Object} options.indexes - 要添加的索引定义列表
 * @param {Object} options.plugins - 要应用的插件列表
 * @param {boolean} options.cacheable - 是否为可缓存模型
 * @param {Object} options.validationOptions - 验证选项
 * @param {Object} options.optimizedIndexes - 优化的索引配置
 * @returns {mongoose.Model} Mongoose模型实例
 */
module.exports = function modelRegistrar(modelName, schemaDefinition, options = {}) {
  try {
    if (!modelName || typeof modelName !== 'string') {
      throw new Error('模型名称必须是非空字符串');
    }
    
    if (!schemaDefinition || typeof schemaDefinition !== 'object') {
      throw new Error('必须提供Schema定义对象');
    }
    
    // 默认选项
    const defaultOptions = {
      timestamps: true,
      collectionName: null,
      useSharding: false,
      logRegister: true,
      indexes: [],
      plugins: [],
      cacheable: false,
      validationOptions: { runValidators: true },
      optimizedIndexes: {} // 新增优化索引配置
    };
    
    // 合并选项
    const finalOptions = { ...defaultOptions, ...options };
    
    // 创建Schema
    const schema = new mongoose.Schema(schemaDefinition, { 
      timestamps: finalOptions.timestamps,
      collection: finalOptions.collectionName || modelName.toLowerCase() + 's',
      validateBeforeSave: true,
      ...finalOptions.schemaOptions
    });
    
    // 应用插件（自定义）
    if (finalOptions.plugins && Array.isArray(finalOptions.plugins)) {
      finalOptions.plugins.forEach(plugin => {
        if (typeof plugin === 'function') {
          schema.plugin(plugin);
        } else if (plugin && typeof plugin.plugin === 'function') {
          schema.plugin(plugin.plugin, plugin.options || {});
        }
      });
    }
    
    // 应用基础中间件（分片和读写分离）
    if (finalOptions.useSharding) {
      schema.plugin(getShardKey);
    }
    
    // 应用读取偏好中间件
    schema.plugin(handleReadPreference);
    
    // 添加索引
    if (finalOptions.indexes && Array.isArray(finalOptions.indexes)) {
      finalOptions.indexes.forEach(indexDef => {
        if (indexDef.fields) {
          schema.index(indexDef.fields, indexDef.options || {});
        }
      });
    }
    
    // 添加优化索引 - 新增功能
    if (finalOptions.optimizedIndexes && typeof finalOptions.optimizedIndexes === 'object') {
      // 处理频繁访问的字段索引
      if (finalOptions.optimizedIndexes.frequentFields) {
        finalOptions.optimizedIndexes.frequentFields.forEach(field => {
          schema.index({ [field]: 1 }, { 
            name: `idx_${field}`,
            background: true
          });
        });
      }
      
      // 处理复合索引
      if (finalOptions.optimizedIndexes.compound) {
        finalOptions.optimizedIndexes.compound.forEach(compound => {
          schema.index(compound.fields, { 
            name: compound.name || `idx_comp_${Object.keys(compound.fields).join('_')}`,
            background: true,
            ...compound.options
          });
        });
      }
      
      // 处理部分索引
      if (finalOptions.optimizedIndexes.partial) {
        finalOptions.optimizedIndexes.partial.forEach(partial => {
          schema.index(partial.fields, { 
            partialFilterExpression: partial.filter,
            name: partial.name,
            background: true,
            ...partial.options
          });
        });
      }
      
      // 处理TTL索引
      if (finalOptions.optimizedIndexes.ttl) {
        schema.index(
          { [finalOptions.optimizedIndexes.ttl.field]: 1 }, 
          { 
            expireAfterSeconds: finalOptions.optimizedIndexes.ttl.expireAfterSeconds,
            name: `ttl_${finalOptions.optimizedIndexes.ttl.field}`,
            background: true
          }
        );
      }
      
      // 处理地理空间索引
      if (finalOptions.optimizedIndexes.geo) {
        finalOptions.optimizedIndexes.geo.forEach(geo => {
          schema.index({ [geo.field]: '2dsphere' }, { 
            name: `geo_${geo.field}`,
            background: true
          });
        });
      }
      
      // 处理文本搜索索引
      if (finalOptions.optimizedIndexes.text) {
        const textIndexFields = {};
        finalOptions.optimizedIndexes.text.forEach(textField => {
          if (typeof textField === 'string') {
            textIndexFields[textField] = 'text';
          } else {
            textIndexFields[textField.field] = 'text';
          }
        });
        
        schema.index(textIndexFields, { 
          name: 'text_search_index',
          background: true,
          weights: finalOptions.optimizedIndexes.textWeights || {}
        });
      }
    }
    
    // 添加模型级方法
    if (finalOptions.statics && typeof finalOptions.statics === 'object') {
      Object.keys(finalOptions.statics).forEach(method => {
        schema.statics[method] = finalOptions.statics[method];
      });
    }
    
    // 添加查询帮助方法
    if (finalOptions.query && typeof finalOptions.query === 'object') {
      Object.keys(finalOptions.query).forEach(method => {
        schema.query[method] = finalOptions.query[method];
      });
    }
    
    // 如果是可缓存模型，添加缓存支持
    if (finalOptions.cacheable) {
      // 模型设置缓存标记
      schema.set('cacheable', true);
      
      // 缓存生命周期(默认5分钟)
      schema.set('cacheTTL', finalOptions.cacheTTL || 300);
      
      // 添加缓存控制方法
      schema.statics.clearCache = async function(pattern) {
        // 需要引入缓存服务来实现此功能
        // TODO: 实现缓存清理
        console.log(`[缓存] 清理模型 ${modelName} 的缓存，模式: ${pattern || '*'}`);
      };
    }
    
    // 创建并返回模型
    const model = ModelFactory.createModel(
      modelName, 
      schema, 
      finalOptions.collectionName,
      finalOptions.useSharding
    );
    
    // 记录注册信息
    if (finalOptions.logRegister) {
      logger.info(`模型 ${modelName} 注册成功${finalOptions.useSharding ? ' (启用分片)' : ''}`);
    }
    
    // 检查模型类型是否为构造函数
    if (typeof model !== 'function') {
      logger.error(`警告: ${modelName} 注册成功但不是构造函数 (类型: ${typeof model})，这可能导致使用new ${modelName}()失败`);
      
      // 检查mongoose中是否有正确的模型
      try {
        const mongoose = require('mongoose');
        if (mongoose.models[modelName] && typeof mongoose.models[modelName] === 'function') {
          logger.info(`发现 ${modelName} 在mongoose.models中存在正确类型，考虑直接使用`);
        }
      } catch (err) {
        logger.error(`检查mongoose.models时出错: ${err.message}`);
      }
    } else {
      logger.info(`模型 ${modelName} 是构造函数，可以使用new ${modelName}()`);
    }
    
    return model;
  } catch (error) {
    logger.error(`注册模型 ${modelName} 失败:`, error);
    throw error;
  }
}; 