const mongoose = require('mongoose');
const config = require('../config');
const logger = require('../utils/logger/winstonLogger');
// 引入缓存服务
const cacheService = require('../services/cache/cacheService');
// 引入批处理服务
const batchProcessService = require('../services/performance/batchProcessService');
// 引入自适应分片服务
const adaptiveShardingService = require('../services/database/adaptiveShardingService');
const crypto = require('crypto');

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
    
    // 连接池状态
    this.connectionPool = {
      maxPoolSize: config.database.maxPoolSize || 10,
      minPoolSize: config.database.minPoolSize || 2,
      currentConnections: 0
    };
    
    // 写操作方法列表
    this.writeMethods = [
      'save', 'create', 'insertMany', 'updateOne', 'updateMany', 
      'findOneAndUpdate', 'findByIdAndUpdate', 'deleteOne', 'deleteMany',
      'findOneAndDelete', 'findByIdAndDelete', 'remove'
    ];
    
    // 读操作方法列表（可缓存）
    this.readMethods = [
      'find', 'findOne', 'findById', 'count', 'countDocuments', 
      'estimatedDocumentCount', 'distinct', 'aggregate'
    ];
    
    // 可以批处理的方法
    this.batchableMethods = {
      'insertMany': true,
      'updateMany': true,
      'deleteMany': true
    };
    
    // 默认缓存TTL（秒）
    this.defaultCacheTTL = (config.cache && config.cache.defaultTTL) || 300; // 默认5分钟
    
    // 不缓存的集合列表
    this.nonCacheableCollections = (config.cache && config.cache.excludedCollections) || [];
    
    // 初始化错误处理和连接监控
    this._setupErrorHandling();
    
    // 初始化缓存服务
    this._initializeCacheService();
  }

  /**
   * 初始化缓存服务
   * @private
   */
  async _initializeCacheService() {
    if (config.cache && config.cache.enabled) {
      try {
        await cacheService.initialize();
        logger.info('模型工厂已启用缓存');
      } catch (error) {
        logger.error('初始化缓存服务失败:', error);
      }
    }
  }

  /**
   * 检查操作是否可缓存
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 操作参数
   * @returns {boolean} 是否可缓存
   * @private
   */
  _isCacheable(modelName, operation, args) {
    // 缓存未启用
    if (!config.cache || !config.cache.enabled) {
      return false;
    }
    
    // 不是读操作
    if (!this.readMethods.includes(operation)) {
      return false;
    }
    
    // 排除的集合
    if (this.nonCacheableCollections.includes(modelName)) {
      return false;
    }
    
    // 获取模型的缓存设置
    const modelCacheSettings = this._getModelCacheSettings(modelName);
    if (modelCacheSettings && modelCacheSettings.disableCache) {
      return false;
    }
    
    // 检查查询参数是否包含特定标记
    if (args[0] && typeof args[0] === 'object') {
      // 如果查询明确指定不缓存
      if (args[0].$noCache) {
        return false;
      }
      
      // 如果查询包含实时标志
      if (args[0].$realtime) {
        return false;
      }
      
      // 检查是否为分页查询，只缓存第一页
      if (args[0].page && args[0].page > 1) {
        return false;
      }
      
      // 如果查询包含时间条件且时间很近，表示可能需要实时数据
      const timeFields = ['updatedAt', 'createdAt', 'timestamp', 'date'];
      
      for (const timeField of timeFields) {
        if (args[0][timeField] && args[0][timeField].$gt) {
          const recentThreshold = new Date();
          recentThreshold.setMinutes(recentThreshold.getMinutes() - 10); // 10分钟内的数据不缓存
          
          if (new Date(args[0][timeField].$gt) > recentThreshold) {
            return false;
          }
        }
      }
    }
    
    return true;
  }
  
  /**
   * 获取模型的缓存设置
   * @param {string} modelName - 模型名称
   * @returns {Object} 缓存设置
   * @private
   */
  _getModelCacheSettings(modelName) {
    // 针对不同模型定制缓存设置（统一为小驼峰命名）
    const cacheSettings = {
      user: {
        ttl: 1800, // 30分钟
        disableCache: false,
        volatileFields: ['password', 'lastLoginAt']
      },
      merchant: {
        ttl: 3600, // 1小时
        disableCache: false,
        volatileFields: ['averageRating']
      },
      nutritionProfile: {
        ttl: 300, // 5分钟
        disableCache: false
      },
      aiRecommendation: {
        ttl: 1800, // 30分钟
        disableCache: false
      },
      dbMetrics: {
        ttl: 60, // 1分钟
        disableCache: false
      },
      order: {
        ttl: 300, // 5分钟
        disableCache: false,
        volatileFields: ['status', 'paymentStatus']
      }
    };
    // 使用小驼峰命名进行查找，避免因命名不一致导致缓存配置缺失
    const camelName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
    return cacheSettings[camelName] || {
      ttl: this.defaultCacheTTL,
      disableCache: false
    };
  }
  
  /**
   * 检查操作是否可批处理
   * @param {string} operation - 操作名称
   * @param {Array} args - 操作参数
   * @returns {boolean} 是否可批处理
   * @private
   */
  _isBatchable(operation, args) {
    // 批处理服务未启用
    if (!config.database || !config.database.enableBatchProcessing) {
      return false;
    }
    
    // 不是可批处理的方法
    if (!this.batchableMethods[operation]) {
      return false;
    }
    
    // 特定参数检查
    if (args[0] && typeof args[0] === 'object') {
      // 如果操作明确指定不批处理
      if (args[0].$noBatch) {
        return false;
      }
    }
    
    return true;
  }
  
  /**
   * 生成缓存键
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 操作参数
   * @returns {string} 缓存键
   * @private
   */
  _generateCacheKey(modelName, operation, args) {
    try {
      // 过滤缓存键不敏感参数
      const filteredArgs = args.map(arg => {
        if (!arg) return arg;
        
        // 创建参数的浅拷贝
        const argCopy = { ...arg };
        
        // 删除不影响查询结果的控制参数
        if (typeof argCopy === 'object') {
          delete argCopy.$noCache;
          delete argCopy.$realtime;
          
          // 删除与缓存无关的分页参数
          if (operation === 'find' && argCopy.sort) {
            // 保留排序方向但不保留详细排序
            argCopy._sortDir = typeof argCopy.sort === 'object' ? 
              Object.keys(argCopy.sort).map(k => `${k}_${argCopy.sort[k]}`) : 
              'default';
            delete argCopy.sort;
          }
        }
        
        // 处理ObjectId
        if (arg && arg._id) {
          if (arg._id instanceof mongoose.Types.ObjectId) {
            argCopy._id = arg._id.toString();
          }
        } else if (arg instanceof mongoose.Types.ObjectId) {
          return arg.toString();
        }
        
        return argCopy;
      });
      
      // 在用户查询中添加版本标记，以便在用户资料更新时自动失效缓存
      if (modelName === 'User' && args[0] && args[0]._id) {
        const userId = args[0]._id instanceof mongoose.Types.ObjectId ? 
          args[0]._id.toString() : args[0]._id;
          
        const modelSettings = this._getModelCacheSettings(modelName);
        const cacheVersion = `v${this._getUserCacheVersion(userId) || '1'}`;
        
        // 创建包含操作和版本的对象
        const keyObj = {
          model: modelName,
          op: operation,
          args: filteredArgs,
          version: cacheVersion
        };
        
        const serialized = JSON.stringify(keyObj);
        const hash = crypto.createHash('md5').update(serialized).digest('hex');
        
        return `db:${modelName}:${operation}:${userId}:${hash}`;
      }
      
      // 常规键生成
      const keyObj = {
        model: modelName,
        op: operation,
        args: filteredArgs
      };
      
      // 将对象序列化并哈希
      const serialized = JSON.stringify(keyObj);
      const hash = crypto.createHash('md5').update(serialized).digest('hex');
      
      // 对于基于ID的查询，直接包含ID以便于缓存清理
      if (operation === 'findById' && args[0]) {
        const id = args[0] instanceof mongoose.Types.ObjectId ? 
          args[0].toString() : args[0];
        return `db:${modelName}:${operation}:${id}:${hash.substring(0, 8)}`;
      }
      
      if (operation === 'findOne' && args[0] && args[0]._id) {
        const id = args[0]._id instanceof mongoose.Types.ObjectId ? 
          args[0]._id.toString() : args[0]._id;
        return `db:${modelName}:${operation}:${id}:${hash.substring(0, 8)}`;
      }
      
      return `db:${modelName}:${operation}:${hash}`;
    } catch (error) {
      logger.error('生成缓存键时出错:', error);
      return null;
    }
  }
  
  /**
   * 获取用户缓存版本
   * @param {string} userId - 用户ID
   * @returns {string} 缓存版本
   * @private
   */
  async _getUserCacheVersion(userId) {
    try {
      // 从缓存中获取用户版本
      const versionKey = `user:${userId}:cache_version`;
      const version = await cacheService.get(versionKey);
      
      if (version) {
        return version;
      }
      
      // 如果缓存中没有，创建一个新版本
      const newVersion = Date.now().toString();
      await cacheService.set(versionKey, newVersion, 86400); // 24小时
      return newVersion;
    } catch (error) {
      logger.error('获取用户缓存版本时出错:', error);
      return '1';
    }
  }
  
  /**
   * 更新用户缓存版本以使所有缓存失效
   * @param {string} userId - 用户ID
   * @returns {Promise<boolean>} 是否成功
   */
  async invalidateUserCache(userId) {
    try {
      const versionKey = `user:${userId}:cache_version`;
      const newVersion = Date.now().toString();
      await cacheService.set(versionKey, newVersion, 86400); // 24小时
      
      logger.debug(`用户 ${userId} 的缓存版本已更新为 ${newVersion}`);
      return true;
    } catch (error) {
      logger.error('更新用户缓存版本时出错:', error);
      return false;
    }
  }
  
  /**
   * 清除特定模型相关的所有缓存
   * @param {string} modelName - 模型名称
   * @param {string} [id] - 可选的文档ID
   * @returns {Promise<number>} 清除的缓存条目数
   */
  async clearModelCache(modelName, id = null) {
    try {
      let pattern;
      
      if (id) {
        // 清除特定文档相关的缓存
        pattern = `db:${modelName}:*:${id}:*`;
      } else {
        // 清除整个模型的缓存
        pattern = `db:${modelName}:*`;
      }
      
      const count = await cacheService.deleteByPattern(pattern);
      logger.info(`已清除 ${modelName} 的 ${count} 个缓存条目${id ? ` (ID: ${id})` : ''}`);
      return count;
    } catch (error) {
      logger.error(`清除 ${modelName} 缓存时出错:`, error);
      return 0;
    }
  }

  /**
   * 设置错误处理和连接监控
   * @private
   */
  _setupErrorHandling() {
    // 记录连接池使用情况
    setInterval(() => {
      if (config.database.logConnectionPoolStatus) {
        logger.debug(`数据库连接池状态: ${this.connectionPool.currentConnections}/${this.connectionPool.maxPoolSize} 连接已使用`);
      }
    }, 60000); // 每分钟记录一次
    
    // 处理连接错误
    process.on('unhandledRejection', (reason, promise) => {
      if (reason instanceof mongoose.Error) {
        logger.error('未处理的Mongoose异常:', reason);
        // 尝试恢复连接
        this._attemptConnectionRecovery();
      }
    });
  }
  
  /**
   * 尝试恢复数据库连接
   * @private
   */
  async _attemptConnectionRecovery() {
    try {
      logger.info('尝试恢复数据库连接...');
      await this.initConnections();
      await this.reinitializeAllModels();
      logger.info('数据库连接恢复成功');
    } catch (error) {
      logger.error('数据库连接恢复失败:', error);
    }
  }

  /**
   * 初始化连接，根据配置决定是否使用读写分离
   */
  async initConnections() {
    try {
      if (config.database.useSplitConnections) {
        // 创建写连接
        this.connections.write = await mongoose.createConnection(config.database.writeUri, {
          useNewUrlParser: true,
          useUnifiedTopology: true,
          maxPoolSize: this.connectionPool.maxPoolSize,
          minPoolSize: this.connectionPool.minPoolSize,
          connectTimeoutMS: 5000,
          socketTimeoutMS: 45000,
          serverSelectionTimeoutMS: 5000,
          heartbeatFrequencyMS: 10000
        });
        
        // 创建读连接
        this.connections.read = await mongoose.createConnection(config.database.readUri, {
          useNewUrlParser: true,
          useUnifiedTopology: true,
          maxPoolSize: this.connectionPool.maxPoolSize,
          minPoolSize: this.connectionPool.minPoolSize,
          readPreference: 'secondaryPreferred',
          connectTimeoutMS: 5000,
          socketTimeoutMS: 45000,
          serverSelectionTimeoutMS: 5000,
          heartbeatFrequencyMS: 10000
        });
        
        // 设置连接监听
        this._setupConnectionListeners(this.connections.write, 'write');
        this._setupConnectionListeners(this.connections.read, 'read');
        
        logger.info('数据库读写分离连接初始化成功');
      } else {
        // 设置默认连接监听
        this._setupConnectionListeners(mongoose.connection, 'single');
        logger.info('使用单一数据库连接');
      }
      
      return true;
    } catch (error) {
      logger.error('初始化数据库连接失败:', error);
      throw error;
    }
  }
  
  /**
   * 设置数据库连接事件监听
   * @param {mongoose.Connection} connection 连接对象
   * @param {string} connectionType 连接类型
   * @private
   */
  _setupConnectionListeners(connection, connectionType) {
    connection.on('connected', () => {
      logger.info(`数据库${connectionType}连接成功`);
    });
    
    connection.on('disconnected', () => {
      logger.warn(`数据库${connectionType}连接断开`);
    });
    
    connection.on('error', (err) => {
      logger.error(`数据库${connectionType}连接错误:`, err);
    });
    
    connection.on('reconnected', () => {
      logger.info(`数据库${connectionType}连接已重新建立`);
    });
  }

  /**
   * 验证模型创建参数
   * @param {string} modelName 模型名称
   * @param {mongoose.Schema} schema Schema对象
   * @returns {boolean} 验证结果
   * @private
   */
  _validateModelParams(modelName, schema) {
    if (!modelName || typeof modelName !== 'string') {
      throw new Error('模型名称必须是非空字符串');
    }
    
    if (!schema || !(schema instanceof mongoose.Schema)) {
      throw new Error('必须提供有效的Schema对象');
    }
    
    return true;
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
    try {
      // 1. 验证参数
      this._validateModelParams(modelName, schema);
      
      // 2. 检查模型是否已经存在
      if (this.models[modelName]) {
        logger.warn(`模型 ${modelName} 已存在，返回现有模型`);
        return this.models[modelName];
      }
      
      // 3. 添加集合名
      const collection = collectionName || modelName.toLowerCase() + 's';
      
      // 4. 应用中间件
      if (useSharding) {
        schema.plugin(getShardKey);
      }
      
      // 添加读写分离中间件
      schema.plugin(handleReadPreference);
      
      // 5. 创建实际模型
      let baseModel = mongoose.model(modelName, schema, collection);
      
      // 检查模型是否是构造函数
      logger.info(`创建模型 ${modelName} 的类型: ${typeof baseModel}`);
      if (typeof baseModel !== 'function') {
        logger.error(`警告: ${modelName} 模型不是构造函数!`);
      }
      
      // 构建增强模型
      const initializeModel = async () => {
        try {
          // 检查分片设置
          if (useSharding && config.database.enableSharding) {
            // 应用分片策略
            await adaptiveShardingService.setupSharding(modelName, collection, schema);
          }
          
          // 其他初始化操作...
        } catch (err) {
          logger.error(`初始化模型 ${modelName} 失败:`, err);
        }
      };
      
      // 异步初始化模型
      initializeModel();
      
      // 6. 保存并返回模型
      this.models[modelName] = baseModel;
      return baseModel;
    } catch (error) {
      logger.error(`创建模型 ${modelName} 时出错:`, error);
      throw error;
    }
  }

  /**
   * 获取备用模型（不使用代理，用于特殊场景）
   * @param {string} modelName - a模型名称
   * @returns {mongoose.Model} 原始Mongoose模型
   */
  async getFallbackModel(modelName) {
    if (!modelName || typeof modelName !== 'string') {
      throw new Error('模型名称必须是非空字符串');
    }
    
    const model = this.models[modelName];
    if (!model) {
      throw new Error(`模型 ${modelName} 不存在`);
    }
    
    try {
      // 等待模型初始化
      await model; // 等待代理模型初始化
      
      // 返回写模型作为备用
      if (config.database.useSplitConnections) {
        return this.connections.write.model(modelName);
      } else {
        return mongoose.model(modelName);
      }
    } catch (error) {
      logger.error(`获取备用模型 ${modelName} 失败:`, error);
      throw error;
    }
  }

  /**
   * 重新初始化所有已创建的模型
   * 在连接变更或数据库操作需要刷新时使用
   * @returns {Object} 包含重新初始化结果的对象
   */
  async reinitializeAllModels() {
    const results = {
      success: [],
      failed: []
    };

    // 遍历所有模型
    for (const modelName in this.models) {
      try {
        // 获取模型
        const model = this.models[modelName];
        
        // 等待初始化
        await model;
        
        // 记录成功
        results.success.push(modelName);
        logger.info(`模型 ${modelName} 重新初始化成功`);
      } catch (error) {
        // 记录失败
        results.failed.push({
          modelName,
          error: error.message
        });
        logger.error(`重新初始化模型 ${modelName} 失败: ${error.message}`);
      }
    }
    
    return results;
  }
  
  /**
   * 关闭所有数据库连接
   * @returns {Promise<void>}
   */
  async closeConnections() {
    try {
      if (this.connections.write) {
        await this.connections.write.close();
        logger.info('写数据库连接已关闭');
      }
      
      if (this.connections.read) {
        await this.connections.read.close();
        logger.info('读数据库连接已关闭');
      }
      
      logger.info('所有数据库连接已关闭');
    } catch (error) {
      logger.error('关闭数据库连接时出错:', error);
      throw error;
    }
  }
  
  /**
   * 获取模型统计信息
   * @returns {Object} 模型统计信息
   */
  getModelStats() {
    return {
      totalModels: Object.keys(this.models).length,
      modelNames: Object.keys(this.models),
      connectionStatus: {
        write: this.connections.write ? this.connections.write.readyState : 0,
        read: this.connections.read ? this.connections.read.readyState : 0,
        single: mongoose.connection.readyState
      },
      cacheStats: cacheService.enabled ? cacheService.getStats() : null,
      batchStats: batchProcessService.getStats(),
      adaptiveShardingEnabled: config.database.enableAdaptiveSharding || false
    };
  }
  
  /**
   * 清除所有模型缓存
   * @returns {Promise<boolean>} 是否成功
   */
  async clearAllModelCaches() {
    if (!cacheService.enabled || !cacheService.initialized) {
      return false;
    }
    
    try {
      await cacheService.clearPattern('db:*');
      logger.info('所有模型缓存已清除');
      return true;
    } catch (error) {
      logger.error('清除所有模型缓存时出错:', error);
      return false;
    }
  }
  
  /**
   * 强制执行所有挂起的批处理操作
   * @returns {Promise<boolean>} 是否成功
   */
  async flushAllBatches() {
    try {
      await batchProcessService.flushAll();
      logger.info('所有批处理操作已执行');
      return true;
    } catch (error) {
      logger.error('执行批处理操作时出错:', error);
      return false;
    }
  }
  
  /**
   * 获取所有集合的分片键建议
   * @returns {Object} 分片键建议
   */
  getShardingRecommendations() {
    if (!config.database.enableAdaptiveSharding) {
      return { enabled: false };
    }
    
    return {
      enabled: true,
      recommendations: adaptiveShardingService.getAllRecommendations(),
      stats: adaptiveShardingService.getStats()
    };
  }
  
  /**
   * 动态调整连接池大小
   * @param {Object} poolSizes - 包含读写连接池大小的对象
   * @returns {Promise<boolean>} 是否成功
   */
  async adjustConnectionPoolSizes(poolSizes = {}) {
    try {
      const { readPoolSize, writePoolSize } = poolSizes;
      
      if (writePoolSize && this.connections.write) {
        this.connections.write.setMaxPoolSize(writePoolSize);
        logger.info(`写连接池大小已调整为 ${writePoolSize}`);
      }
      
      if (readPoolSize && this.connections.read) {
        this.connections.read.setMaxPoolSize(readPoolSize);
        logger.info(`读连接池大小已调整为 ${readPoolSize}`);
      }
      
      this.connectionPool.maxPoolSize = Math.max(
        writePoolSize || this.connectionPool.maxPoolSize,
        readPoolSize || this.connectionPool.maxPoolSize
      );
      
      return true;
    } catch (error) {
      logger.error('调整连接池大小时出错:', error);
      return false;
    }
  }
}

// 导出单例
module.exports = new ModelFactory(); 