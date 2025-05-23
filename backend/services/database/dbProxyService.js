/**
 * 数据库代理服务模块
 * 封装数据库操作流程，统一处理缓存、审计、性能监控、读写分离与链式调用
 * 支持自动注册模型代理链、缓存命中优化、预审计与后审计记录
 * 作为系统核心中间层，协调 ModelFactory、缓存、审计、性能模块协作
 * @module services/core/dbProxyService
 */

const { EventEmitter } = require('events');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');
const modelFactory = require('../../models/modelFactory');
const cacheService = require('../cache/cacheService');
const adaptiveShardingService = require('./adaptiveShardingService');
const auditLogService = require('../core/auditLogService');
const performanceMonitoringService = require('../performance/performanceMonitoringService');

class DbProxyService extends EventEmitter {
  constructor() {
    super();
    this.initialized = false;
    this.modulesEnabled = {
      cache: config.modules?.cache?.enabled ?? true,
      sharding: config.modules?.sharding?.enabled ?? true,
      audit: config.modules?.audit?.enabled ?? true,
      logging: config.modules?.logging?.enabled ?? true,
      monitoring: config.modules?.monitoring?.enabled ?? true
    };
    
    // 默认配置
    this.defaultConfig = {
      useCache: true,
      cacheExpiry: 300, // 秒
      enableAudit: true,
      useReadReplica: true,
      trackPerformance: true
    };
  }
  
  /**
   * 初始化代理服务
   */
  async initialize() {
    if (this.initialized) return true;
    
    try {
      logger.info('初始化数据库代理服务...');
      
      // 确保ModelFactory已初始化
      if (!modelFactory.initialized) {
        await modelFactory.initConnections();
      }
      
      this.initialized = true;
      logger.info('数据库代理服务初始化完成');
      return true;
    } catch (error) {
      logger.error('初始化数据库代理服务失败', { error });
      return false;
    }
  }
  
  /**
   * 创建模型代理
   * @param {string} modelName - 模型名称
   * @returns {Object} - 代理对象
   */
  proxy(modelName) {
    if (!this.initialized) {
      throw new Error('数据库代理服务尚未初始化');
    }
    
    // 构建链式操作的上下文
    const context = {
      modelName,
      config: { ...this.defaultConfig },
      operation: null,
      filter: null,
      update: null,
      options: {},
      data: null
    };
    
    // 创建链式接口
    return this._createChainableInterface(context);
  }
  
  /**
   * 创建可链式调用的接口
   * @param {Object} context - 操作上下文
   * @returns {Object} - 链式接口
   */
  _createChainableInterface(context) {
    return {
      // 配置方法
      withCache: (duration) => {
        if (!this.modulesEnabled.cache) return this._createChainableInterface(context);
        context.config.useCache = true;
        if (duration) context.config.cacheExpiry = duration;
        return this._createChainableInterface(context);
      },
      
      withoutCache: () => {
        context.config.useCache = false;
        return this._createChainableInterface(context);
      },
      
      withAudit: () => {
        if (!this.modulesEnabled.audit) return this._createChainableInterface(context);
        context.config.enableAudit = true;
        return this._createChainableInterface(context);
      },
      
      withoutAudit: () => {
        context.config.enableAudit = false;
        return this._createChainableInterface(context);
      },
      
      fromPrimary: () => {
        context.config.useReadReplica = false;
        return this._createChainableInterface(context);
      },
      
      fromReplica: () => {
        context.config.useReadReplica = true;
        return this._createChainableInterface(context);
      },
      
      withPerformanceTracking: () => {
        if (!this.modulesEnabled.monitoring) return this._createChainableInterface(context);
        context.config.trackPerformance = true;
        return this._createChainableInterface(context);
      },
      
      withoutPerformanceTracking: () => {
        context.config.trackPerformance = false;
        return this._createChainableInterface(context);
      },
      
      // 操作方法
      find: (filter = {}, options = {}) => {
        context.operation = 'find';
        context.filter = filter;
        context.options = options;
        return this._executeOperation(context);
      },
      
      findOne: (filter = {}, options = {}) => {
        context.operation = 'findOne';
        context.filter = filter;
        context.options = options;
        return this._executeOperation(context);
      },
      
      findById: (id, options = {}) => {
        context.operation = 'findById';
        context.filter = id;
        context.options = options;
        return this._executeOperation(context);
      },
      
      create: (data, options = {}) => {
        context.operation = 'create';
        context.data = data;
        context.options = options;
        return this._executeOperation(context);
      },
      
      insertMany: (data, options = {}) => {
        context.operation = 'insertMany';
        context.data = data;
        context.options = options;
        return this._executeOperation(context);
      },
      
      updateOne: (filter, update, options = {}) => {
        context.operation = 'updateOne';
        context.filter = filter;
        context.update = update;
        context.options = options;
        return this._executeOperation(context);
      },
      
      updateMany: (filter, update, options = {}) => {
        context.operation = 'updateMany';
        context.filter = filter;
        context.update = update;
        context.options = options;
        return this._executeOperation(context);
      },
      
      deleteOne: (filter, options = {}) => {
        context.operation = 'deleteOne';
        context.filter = filter;
        context.options = options;
        return this._executeOperation(context);
      },
      
      deleteMany: (filter, options = {}) => {
        context.operation = 'deleteMany';
        context.filter = filter;
        context.options = options;
        return this._executeOperation(context);
      },
      
      countDocuments: (filter = {}, options = {}) => {
        context.operation = 'countDocuments';
        context.filter = filter;
        context.options = options;
        return this._executeOperation(context);
      },
      
      aggregate: (pipeline, options = {}) => {
        context.operation = 'aggregate';
        context.filter = pipeline;
        context.options = options;
        return this._executeOperation(context);
      }
    };
  }
  
  /**
   * 执行数据库操作
   * @param {Object} context - 操作上下文
   * @returns {Promise<any>} - 操作结果
   */
  async _executeOperation(context) {
    if (!this.initialized) {
      await this.initialize();
    }
    
    const startTime = Date.now();
    let result = null;
    const model = modelFactory.models[context.modelName];
    
    if (!model) {
      throw new Error(`模型 ${context.modelName} 不存在`);
    }
    
    try {
      // 1. 尝试从缓存获取（仅读操作）
      if (this._isReadOperation(context.operation) && 
          context.config.useCache && 
          this.modulesEnabled.cache) {
        const cacheKey = this._generateCacheKey(context);
        result = await this._getFromCache(cacheKey);
        
        if (result) {
          this._recordPerformance(context, startTime, true);
          return result;
        }
      }
      
      // 2. 审计日志前置记录
      if (context.config.enableAudit && 
          this.modulesEnabled.audit && 
          this._isWriteOperation(context.operation)) {
        await this._auditPreOperation(context);
      }
      
      // 3. 执行实际操作
      result = await this._performDatabaseOperation(context, model);
      
      // 4. 审计日志后置记录
      if (context.config.enableAudit && 
          this.modulesEnabled.audit && 
          this._isWriteOperation(context.operation)) {
        await this._auditPostOperation(context, result);
      }
      
      // 5. 写入缓存（仅读操作）
      if (this._isReadOperation(context.operation) && 
          context.config.useCache && 
          this.modulesEnabled.cache) {
        const cacheKey = this._generateCacheKey(context);
        await this._saveToCache(cacheKey, result, context.config.cacheExpiry);
      }
      
      // 6. 记录性能指标
      this._recordPerformance(context, startTime, false);
      
      return result;
    } catch (error) {
      logger.error(`数据库操作失败 [${context.modelName}.${context.operation}]`, { error });
      this.emit('error', {
        modelName: context.modelName,
        operation: context.operation,
        error
      });
      throw error;
    }
  }
  
  /**
   * 执行实际的数据库操作
   * @param {Object} context - 操作上下文
   * @param {Object} model - 模型实例
   * @returns {Promise<any>} - 操作结果
   */
  async _performDatabaseOperation(context, model) {
    // 根据操作类型调用相应的模型方法
    switch (context.operation) {
      case 'find':
        return model.find(context.filter, null, context.options);
      
      case 'findOne':
        return model.findOne(context.filter, null, context.options);
      
      case 'findById':
        return model.findById(context.filter, null, context.options);
      
      case 'create':
        return model.create(context.data);
      
      case 'insertMany':
        return model.insertMany(context.data, context.options);
      
      case 'updateOne':
        return model.updateOne(context.filter, context.update, context.options);
      
      case 'updateMany':
        return model.updateMany(context.filter, context.update, context.options);
      
      case 'deleteOne':
        return model.deleteOne(context.filter, context.options);
      
      case 'deleteMany':
        return model.deleteMany(context.filter, context.options);
      
      case 'countDocuments':
        return model.countDocuments(context.filter, context.options);
      
      case 'aggregate':
        return model.aggregate(context.filter).option(context.options);
      
      default:
        throw new Error(`不支持的操作类型: ${context.operation}`);
    }
  }
  
  /**
   * 生成缓存键
   * @param {Object} context - 操作上下文
   * @returns {string} - 缓存键
   */
  _generateCacheKey(context) {
    const { modelName, operation, filter, options } = context;
    return cacheService.generateCacheKey(`db:${modelName}:${operation}`, filter, options);
  }
  
  /**
   * 从缓存获取数据
   * @param {string} cacheKey - 缓存键
   * @returns {Promise<any>} - 缓存的数据或null
   */
  async _getFromCache(cacheKey) {
    if (!cacheService.initialized) return null;
    return cacheService.get(cacheKey);
  }
  
  /**
   * 保存数据到缓存
   * @param {string} cacheKey - 缓存键
   * @param {any} data - 要缓存的数据
   * @param {number} expiry - 过期时间(秒)
   * @returns {Promise<boolean>} - 是否成功
   */
  async _saveToCache(cacheKey, data, expiry) {
    if (!cacheService.initialized) return false;
    return cacheService.set(cacheKey, data, expiry);
  }
  
  /**
   * 操作前记录审计日志
   * @param {Object} context - 操作上下文
   */
  async _auditPreOperation(context) {
    try {
      if (!auditLogService.initialized) return;
      
      await auditLogService.logPreOperation({
        model: context.modelName,
        operation: context.operation,
        filter: context.filter,
        update: context.update,
        data: context.data
      });
    } catch (error) {
      logger.error('记录前置审计日志失败', { error });
    }
  }
  
  /**
   * 操作后记录审计日志
   * @param {Object} context - 操作上下文
   * @param {any} result - 操作结果
   */
  async _auditPostOperation(context, result) {
    try {
      if (!auditLogService.initialized) return;
      
      await auditLogService.logPostOperation({
        model: context.modelName,
        operation: context.operation,
        filter: context.filter,
        update: context.update,
        data: context.data,
        result
      });
    } catch (error) {
      logger.error('记录后置审计日志失败', { error });
    }
  }
  
  /**
   * 记录性能指标
   * @param {Object} context - 操作上下文
   * @param {number} startTime - 开始时间戳
   * @param {boolean} fromCache - 是否从缓存获取
   */
  _recordPerformance(context, startTime, fromCache) {
    if (!context.config.trackPerformance || !this.modulesEnabled.monitoring) return;
    
    try {
      const duration = Date.now() - startTime;
      
      performanceMonitoringService.recordDbOperation({
        model: context.modelName,
        operation: context.operation,
        duration,
        fromCache,
        filter: context.filter ? JSON.stringify(context.filter).length : 0,
        time: new Date()
      });
    } catch (error) {
      logger.error('记录性能指标失败', { error });
    }
  }
  
  /**
   * 判断是否为读操作
   * @param {string} operation - 操作类型
   * @returns {boolean} - 是否为读操作
   */
  _isReadOperation(operation) {
    return ['find', 'findOne', 'findById', 'countDocuments', 'aggregate'].includes(operation);
  }
  
  /**
   * 判断是否为写操作
   * @param {string} operation - 操作类型
   * @returns {boolean} - 是否为写操作
   */
  _isWriteOperation(operation) {
    return ['create', 'insertMany', 'updateOne', 'updateMany', 'deleteOne', 'deleteMany'].includes(operation);
  }
  
  /**
   * 获取服务状态
   * @returns {Object} - 状态信息
   */
  getStatus() {
    return {
      initialized: this.initialized,
      modulesEnabled: this.modulesEnabled,
      defaultConfig: this.defaultConfig,
      cacheServiceStatus: cacheService.initialized,
      auditServiceStatus: auditLogService ? auditLogService.initialized : false
    };
  }
}

// 创建单例实例
const dbProxyService = new DbProxyService();

module.exports = dbProxyService; 