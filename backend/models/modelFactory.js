const mongoose = require('mongoose');
const config = require('../config');
const logger = require('../utils/logger');

// 正确引用中间件文件
const { getShardKey } = require('../middleware/database/shardingMiddleware');
const { handleReadPreference } = require('../middleware/database/readPreferenceMiddleware');

/**
 * 模型工厂类，用于创建支持读写分离和分片的Mongoose模型
 * 通过代理拦截模型方法调用，实现根据操作类型自动选择适当的数据库连接
 */
class ModelFactory {
  constructor() {
    this.models = {};
    this.connections = {
      single: mongoose.connection, // 默认连接
      write: null,  // 写连接
      read: null    // 读连接
    };
    
    // 写操作方法列表
    this.writeMethods = [
      'save', 'create', 'insertMany', 'updateOne', 'updateMany', 
      'findOneAndUpdate', 'findByIdAndUpdate', 'deleteOne', 'deleteMany',
      'findOneAndDelete', 'findByIdAndDelete', 'remove'
    ];
  }

  /**
   * 初始化连接，根据配置决定是否使用读写分离
   */
  async initConnections() {
    if (config.database.useSplitConnections) {
      // 创建写连接
      this.connections.write = mongoose.createConnection(config.database.writeUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true
      });
      
      // 创建读连接
      this.connections.read = mongoose.createConnection(config.database.readUri, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
        readPreference: 'secondaryPreferred'
      });
      
      logger.info('Database split connections initialized');
    } else {
      logger.info('Using single database connection');
    }
  }

  /**
   * 创建或获取模型
   * @param {string} modelName - 模型名称
   * @param {mongoose.Schema} schema - Mongoose模式对象
   * @param {string} collectionName - 集合名称
   * @param {boolean} useSharding - 是否使用分片
   * @returns {Object} 代理后的模型对象
   */
  createModel(modelName, schema, collectionName, useSharding = false) {
    // 如果模型已存在，直接返回
    if (this.models[modelName]) {
      return this.models[modelName];
    }
    
    // 模型初始化状态
    let isInitialized = false;
    let initializationPromise = null;
    
    // 应用必要的插件和中间件
    if (useSharding) {
      schema.plugin(getShardKey);
    }
    
    // 应用读取偏好中间件
    schema.plugin(handleReadPreference);
    
    // 创建模型(延迟到第一次使用时)
    let model = null;
    let readModel = null;
    let writeModel = null;
    
    // 创建模型代理
    const modelProxy = new Proxy({}, {
      get: (target, prop) => {
        // 初始化模型的函数
        const initializeModel = async () => {
          if (initializationPromise) return initializationPromise;
          
          initializationPromise = (async () => {
            if (config.database.useSplitConnections) {
              // 使用读写分离时创建两个模型实例
              writeModel = this.connections.write.model(
                modelName,
                schema,
                collectionName
              );
              
              readModel = this.connections.read.model(
                modelName,
                schema,
                collectionName
              );
              
              // 主模型指向写模型
              model = writeModel;
            } else {
              // 单连接模式
              model = mongoose.model(modelName, schema, collectionName);
            }
            
            isInitialized = true;
            return true;
          })();
          
          return initializationPromise;
        };
        
        // 1. 处理直接属性访问
        if (prop === 'then' || prop === 'catch' || prop === 'finally') {
          // 支持Promise接口，使模型可等待初始化
          return initializeModel()[prop];
        }
        
        // 2. 返回适当的方法或属性
        return async function(...args) {
          if (!isInitialized) {
            await initializeModel();
          }
          
          // 判断是使用读模型还是写模型
          if (config.database.useSplitConnections) {
            const isWriteMethod = this.writeMethods.includes(prop);
            const targetModel = isWriteMethod ? writeModel : readModel;
            
            // 记录操作日志
            logger.debug(`Using ${isWriteMethod ? 'write' : 'read'} connection for ${modelName}.${prop}`);
            
            return targetModel[prop].apply(targetModel, args);
          } else {
            // 单连接模式
            return model[prop].apply(model, args);
          }
        }.bind(this);  // 绑定this以访问writeMethods
      }
    });
    
    // 缓存并返回代理模型
    this.models[modelName] = modelProxy;
    return modelProxy;
  }

  /**
   * 获取备用模型（不使用代理，用于特殊场景）
   * @param {string} modelName - 模型名称
   * @returns {mongoose.Model} 原始Mongoose模型
   */
  getFallbackModel(modelName) {
    const model = this.models[modelName];
    if (!model) {
      throw new Error(`Model ${modelName} does not exist`);
    }
    
    // 等待模型初始化
    return (async () => {
      await model; // 等待代理模型初始化
      
      // 返回写模型作为备用
      if (config.database.useSplitConnections) {
        return this.connections.write.model(modelName);
      } else {
        return mongoose.model(modelName);
      }
    })();
  }
}

// 导出单例
module.exports = new ModelFactory(); 