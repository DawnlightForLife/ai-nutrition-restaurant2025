const mongoose = require('mongoose');
const dbManager = require('../config/database');

/**
 * 模型工厂类 - 用于创建支持读写分离的模型
 */
class ModelFactory {
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
      'HealthData', 'AiRecommendation', 'AuditLog'
    ];
    
    // 频繁写入的集合列表 (这些集合的操作不区分读写连接，都通过主连接进行)
    const writeHeavyCollections = [
      'AuditLog', 'DbMetrics'
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
              'findByIdAndDelete', 'insertMany'
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
            'findByIdAndDelete', 'insertMany'
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
}

module.exports = ModelFactory; 