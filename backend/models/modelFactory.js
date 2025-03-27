const mongoose = require('mongoose');
const dbManager = require('../config/database');

/**
 * 模型工厂类 - 负责创建支持读写分离和分片的Mongoose模型
 */
class ModelFactory {
  constructor() {
    this.models = {};
    // 保存已创建的Mongoose模型
    this.mongooseModels = {};
    this.fallbackModels = {};
  }

  /**
   * 创建或获取模型
   * @param {string} name 模型名称
   * @param {mongoose.Schema} schema 模式定义
   * @returns {mongoose.Model} Mongoose模型
   */
  model(name, schema) {
    // 如果已经创建过，直接返回
    if (this.mongooseModels[name]) {
      return this.mongooseModels[name];
    }

    try {
      // 尝试直接使用mongoose全局连接创建模型
      let model;

      // 先检查mongoose.models中是否已存在该模型
      if (mongoose.models[name]) {
        model = mongoose.models[name];
      } else if (schema) {
        // 如果提供了schema，则创建新模型
        model = mongoose.model(name, schema);
      } else {
        // 没有schema，尝试获取已存在的模型
        try {
          model = mongoose.model(name);
        } catch (err) {
          console.error(`无法获取模型 ${name}，错误:`, err);
          
          // 创建一个备用的空模式
          const fallbackSchema = new mongoose.Schema({});
          const fallbackModel = mongoose.model(`Fallback_${name}`, fallbackSchema);
          this.fallbackModels[name] = fallbackModel;
          
          console.warn(`已为 ${name} 创建备用模型`);
          return fallbackModel;
        }
      }

      // 保存模型引用
      this.mongooseModels[name] = model;
      return model;
    } catch (error) {
      console.error(`初始化模型 ${name} 失败:`, error);
      
      // 创建一个备用的空模式
      const fallbackSchema = schema || new mongoose.Schema({});
      let fallbackModel;
      
      try {
        fallbackModel = mongoose.model(`Fallback_${name}`, fallbackSchema);
      } catch (err) {
        console.error(`创建备用模型失败:`, err);
        // 最后的拯救尝试 - 使用全局连接直接创建模型
        try {
          fallbackModel = mongoose.model(name, fallbackSchema);
        } catch (finalErr) {
          console.error(`无法创建任何类型的模型:`, finalErr);
          throw new Error(`无法为 ${name} 创建模型`);
        }
      }
      
      // 保存备用模型引用
      this.fallbackModels[name] = fallbackModel;
      console.warn(`已为 ${name} 创建备用模型`);
      return fallbackModel;
    }
  }

  /**
   * 创建一个模型并配置读写操作的连接
   * @param {String} name 模型名称
   * @param {Schema} schema 模型Schema
   * @param {Object} options 模型选项
   * @returns {Object} 包含读写操作模型的对象
   */
  static createModel(name, schema, options = {}) {
    // 需要读写分离的集合列表
    const readWriteSeparatedCollections = [
      'User', 'Order', 'Merchant', 'Dish', 
      'HealthData', 'AiRecommendation', 'AuditLog',
      'Store', 'StoreDish', 'NutritionProfile',
      'UserFavorite', 'Subscription', 'Nutritionist',
      'ForumPost', 'ForumComment', 'Consultation'
    ];
    
    // 频繁写入的集合列表 (这些集合的操作不区分读写连接，都通过主连接进行)
    const writeHeavyCollections = [
      'AuditLog', 'DbMetrics', 'MerchantStats',
      'DataAccessControl'
    ];
    
    // 创建延迟初始化的模型 - 延迟到实际使用时再创建连接
    const lazyModelInitializer = async () => {
      try {
        // 准备在主连接上注册模型
        const primaryConn = await dbManager.getPrimaryConnection();
        const primaryModel = primaryConn.model(name, schema, options);
        
        // 检查是否需要读写分离
        if (!readWriteSeparatedCollections.includes(name)) {
          // 对于不需要读写分离的模型，直接返回主连接模型
          console.log(`模型 ${name} 使用单一连接模式`);
          return { type: 'single', model: primaryModel };
        }
        
        // 对于频繁写入的集合，总是使用主连接
        if (writeHeavyCollections.includes(name)) {
          console.log(`模型 ${name} 是频繁写入集合，使用主连接`);
          return { type: 'single', model: primaryModel };
        }
        
        // 为读操作准备副本连接模型
        console.log(`模型 ${name} 使用读写分离模式`);
        const replicaConn = await dbManager.getReplicaConnection();
        const replicaModel = replicaConn.model(name, schema, options);
        
        return { 
          type: 'split',
          primaryModel,
          replicaModel
        };
      } catch (error) {
        console.error(`初始化模型 ${name} 失败:`, error.message);
        
        // 失败时返回一个有效的降级模型结构，避免后续的空引用错误
        console.log(`模型 ${name} 初始化失败，使用降级模型`);
        
        // 创建一个内存模型作为降级方案
        const fallbackSchema = new mongoose.Schema(schema.obj || {}, schema.options || {});
        const fallbackModel = mongoose.model(`Fallback_${name}`, fallbackSchema);
        
        return {
          type: 'single',
          model: fallbackModel,
          _isFallback: true
        };
      }
    };
    
    // 创建代理对象，根据操作类型使用不同的连接
    // 并且延迟模型初始化直到首次使用
    let modelInstance = null;
    let initializationPromise = null;
    
    return new Proxy({}, {
      get(target, prop) {
        // 处理已经初始化的情况
        if (modelInstance) {
          if (modelInstance.type === 'split') {
            // 定义写操作方法列表
            const writeMethods = [
              'create', 'save', 'updateOne', 'updateMany', 
              'findOneAndUpdate', 'findByIdAndUpdate',
              'deleteOne', 'deleteMany', 'findOneAndDelete', 
              'findByIdAndDelete', 'insertMany', 'bulkWrite',
              'replaceOne', 'createIndexes', 'collection'
            ];
            
            // 为写操作使用主连接
            if (writeMethods.includes(prop)) {
              return modelInstance.primaryModel[prop].bind(modelInstance.primaryModel);
            }
            
            // 读操作使用副本连接
            if (typeof modelInstance.replicaModel[prop] === 'function') {
              return modelInstance.replicaModel[prop].bind(modelInstance.replicaModel);
            }
            
            // 其他属性直接从副本模型获取
            return modelInstance.replicaModel[prop];
          } else if (modelInstance.type === 'single' && modelInstance.model) {
            // 单一连接模式，所有操作使用同一个模型
            if (typeof modelInstance.model[prop] === 'function') {
              return modelInstance.model[prop].bind(modelInstance.model);
            }
            return modelInstance.model[prop];
          }
        }
        
        // 原始方法的异步包装
        // 这将在首次调用时异步初始化模型
        return async function(...args) {
          // 如果还没有初始化，但已经有一个初始化Promise，等待它完成
          if (!modelInstance && initializationPromise) {
            try {
              modelInstance = await initializationPromise;
            } catch (error) {
              console.error(`等待模型 ${name} 初始化时出错:`, error);
              throw error;
            }
          }
          
          // 如果还没有初始化，也没有初始化Promise，开始初始化
          if (!modelInstance && !initializationPromise) {
            initializationPromise = lazyModelInitializer();
            try {
              modelInstance = await initializationPromise;
            } catch (error) {
              console.error(`初始化模型 ${name} 失败:`, error);
              initializationPromise = null;
              throw error;
            }
          }
          
          // 现在模型应该已经初始化好了，根据操作类型调用原始方法
          const writeMethods = [
            'create', 'save', 'updateOne', 'updateMany', 
            'findOneAndUpdate', 'findByIdAndUpdate',
            'deleteOne', 'deleteMany', 'findOneAndDelete', 
            'findByIdAndDelete', 'insertMany', 'bulkWrite',
            'replaceOne', 'createIndexes', 'collection'
          ];
          
          if (!modelInstance) {
            throw new Error(`模型 ${name} 初始化失败，无法执行操作 ${prop}`);
          }
          
          if (modelInstance.type === 'split') {
            // 为写操作使用主连接
            if (writeMethods.includes(prop)) {
              return modelInstance.primaryModel[prop].apply(modelInstance.primaryModel, args);
            }
            
            // 读操作使用副本连接
            return modelInstance.replicaModel[prop].apply(modelInstance.replicaModel, args);
          } else if (modelInstance.type === 'single' && modelInstance.model) {
            // 单一连接模式，所有操作使用同一个模型
            return modelInstance.model[prop].apply(modelInstance.model, args);
          } else {
            throw new Error(`模型 ${name} 结构异常，无法执行操作 ${prop}`);
          }
        };
      }
    });
  }
  
  /**
   * 从给定的Schema创建模型的静态帮助方法
   * @param {String} modelName 模型名称
   * @param {Schema} schema Mongoose Schema
   * @param {String} collection 集合名称(可选)
   * @returns {Model} Mongoose模型
   */
  static model(modelName, schema, collection = null) {
    const options = collection ? { collection } : {};
    return this.createModel(modelName, schema, options);
  }
  
  /**
   * 重新初始化已经创建的模型（在连接中断恢复后调用）
   * @param {String} modelName 模型名称
   * @returns {Promise<Boolean>} 操作结果
   */
  static async reinitializeModel(modelName) {
    try {
      // 触发重新初始化的逻辑
      const model = mongoose.models[modelName];
      if (model) {
        // 尝试进行一个无害的操作，触发连接重建
        await model.findOne({}).limit(1).exec();
        console.log(`模型 ${modelName} 重新初始化成功`);
        return true;
      }
      return false;
    } catch (error) {
      console.error(`重新初始化模型 ${modelName} 失败:`, error);
      return false;
    }
  }
  
  /**
   * 重新初始化所有模型
   * @returns {Promise<Object>} 操作结果统计
   */
  static async reinitializeAllModels() {
    const results = {
      success: 0,
      failed: 0,
      models: {}
    };
    
    // 获取所有注册的模型名称
    const modelNames = Object.keys(mongoose.models);
    
    // 对每个模型执行重新初始化
    for (const modelName of modelNames) {
      try {
        const success = await this.reinitializeModel(modelName);
        results.models[modelName] = success;
        
        if (success) {
          results.success++;
        } else {
          results.failed++;
        }
      } catch (error) {
        results.models[modelName] = false;
        results.failed++;
        console.error(`重新初始化模型 ${modelName} 时出错:`, error);
      }
    }
    
    console.log(`所有模型重新初始化完成: ${results.success} 成功, ${results.failed} 失败`);
    return results;
  }
  
  /**
   * 为集合名创建一个分片键
   * @param {String} collectionName 集合名称
   * @param {Object} document 文档对象
   * @returns {String} 分片键
   */
  static getShardKey(collectionName, document) {
    // 根据不同集合类型返回合适的分片键
    switch(collectionName) {
      case 'User':
      case 'NutritionProfile':
      case 'HealthData':
        // 用户相关数据按用户ID分片
        return document.user_id ? document.user_id.toString() : 'default';
        
      case 'Merchant':
      case 'Dish':
      case 'MerchantStats':
        // 商家相关数据按商家ID分片
        return document.merchant_id ? document.merchant_id.toString() : 'default';
        
      case 'Order':
        // 订单可以按用户ID或订单时间范围分片
        return document.user_id ? document.user_id.toString() : 'default';
        
      case 'Store':
      case 'StoreDish':
        // 门店数据按地理位置分片
        if (document.location && document.location.coordinates) {
          // 简化的地理哈希算法
          const [lng, lat] = document.location.coordinates;
          // 将经纬度转换为网格坐标（粗略划分）
          const geoKey = `${Math.floor(lng)}:${Math.floor(lat)}`;
          return geoKey;
        }
        return 'default';
        
      default:
        // 默认返回_id作为分片键
        return document._id ? document._id.toString() : 'default';
    }
  }
}

// 创建单例实例
const modelFactory = new ModelFactory();

module.exports = modelFactory; 