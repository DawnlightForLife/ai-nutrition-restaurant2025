const config = require('../../config');
const { cacheManager } = require('./cacheOptimizationMiddleware');
const { logger } = require('../core/loggingMiddleware');
const { metrics } = require('./advancedPerformanceMiddleware');

/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 提供完整的 Mongoose 查询缓存机制
 * ✅ 自动注入 Schema 插件并覆盖 exec 方法，透明接管 find/findOne 等操作
 * ✅ 支持动态缓存 TTL、禁用缓存、模型级缓存清理、全局缓存清理
 * ✅ 集成慢查询日志记录与性能指标监控
 * ✅ 额外提供 Express 中间件用于清除缓存与查看缓存状态
 * ✅ 建议 future：支持缓存标签、支持缓存预热策略、提供缓存命中详情页面
 */

// 创建Mongoose查询缓存插件
class QueryCache {
  constructor() {
    this.enabled = config.cache && config.cache.enabled;
    this.ttl = (config.cache && config.cache.queryTtl) || 300; // 默认5分钟
    this.excludedCollections = (config.cache && config.cache.excludedCollections) || [];
    this.ignoredParams = (config.cache && config.cache.ignoredQueryParams) || [];
    this.queryCache = cacheManager;
    
    // 记录缓存统计
    this.stats = {
      hits: 0,
      misses: 0,
      errors: 0,
      lastReset: new Date()
    };
  }

  /**
   * 生成缓存键
   * @param {Object} query - Mongoose查询对象
   * @returns {string} 缓存键
   */
  generateCacheKey(query) {
    try {
      // 缓存键包括：模型名、操作类型、查询条件、字段投影、选项、分页、排序
      // 从查询对象提取关键信息
      const modelName = query.model.modelName;
      const operation = query.op;
      const conditions = JSON.stringify(query._conditions || {});
      const options = JSON.stringify(query.options || {});
      const projection = JSON.stringify(query._fields || {});
      const skip = query.options.skip || 0;
      const limit = query.options.limit || 0;
      const sort = JSON.stringify(query.options.sort || {});
      
      // 组合缓存键
      return `query:${modelName}:${operation}:${conditions}:${projection}:${options}:${skip}:${limit}:${sort}`;
    } catch (error) {
      logger.error('生成缓存键时出错:', error);
      return null;
    }
  }

  /**
   * 是否应该缓存该查询
   * @param {Object} query - Mongoose查询对象
   * @returns {boolean} 是否应该缓存
   */
  shouldCache(query) {
    if (!this.enabled) return false;
    
    try {
      // 只缓存查找操作
      if (!['find', 'findOne', 'findById', 'countDocuments', 'count'].includes(query.op)) {
        return false;
      }
      
      // 不缓存排除的集合
      const modelName = query.model.modelName;
      if (this.excludedCollections.includes(modelName)) {
        return false;
      }
      
      // 不缓存配置了不缓存的查询
      if (query._mongooseOptions && query._mongooseOptions.disableCache) {
        return false;
      }
      
      return true;
    } catch (error) {
      logger.error('检查是否应该缓存查询时出错:', error);
      return false;
    }
  }

  /**
   * 从缓存获取查询结果
   * @param {Object} query - Mongoose查询对象
   * @returns {Promise<Object|null>} 缓存结果或null
   */
  async getFromCache(query) {
    if (!this.shouldCache(query)) return null;
    
    const cacheKey = this.generateCacheKey(query);
    if (!cacheKey) return null;
    
    try {
      const cachedResult = await this.queryCache.get(cacheKey);
      if (cachedResult) {
        this.stats.hits++;
        metrics.increment('mongoose_query_cache_hit');
        return cachedResult;
      }
      
      this.stats.misses++;
      metrics.increment('mongoose_query_cache_miss');
      return null;
    } catch (error) {
      this.stats.errors++;
      logger.error('从缓存获取查询结果时出错:', error);
      return null;
    }
  }

  /**
   * 将查询结果存入缓存
   * @param {Object} query - Mongoose查询对象
   * @param {Object} result - 查询结果
   * @returns {Promise<boolean>} 是否成功缓存
   */
  async saveToCache(query, result) {
    if (!this.shouldCache(query)) return false;
    
    const cacheKey = this.generateCacheKey(query);
    if (!cacheKey) return false;
    
    try {
      // 获取缓存TTL，优先使用查询自定义的TTL，否则使用默认TTL
      const ttl = query._mongooseOptions && query._mongooseOptions.cacheTTL 
        ? query._mongooseOptions.cacheTTL 
        : this.ttl;
      
      await this.queryCache.set(cacheKey, result, ttl);
      metrics.increment('mongoose_query_cache_store');
      return true;
    } catch (error) {
      this.stats.errors++;
      logger.error('将查询结果存入缓存时出错:', error);
      return false;
    }
  }

  /**
   * 清除与模型相关的所有缓存
   * @param {string} modelName - 模型名称
   * @returns {Promise<boolean>} 是否成功清除
   */
  async clearModelCache(modelName) {
    try {
      // TODO: 支持按标签清除缓存，例如 user:123:recommendations
      await this.queryCache.clear(`query:${modelName}:*`);
      logger.info(`已清除模型 ${modelName} 的缓存`);
      metrics.increment('mongoose_query_cache_clear');
      return true;
    } catch (error) {
      logger.error(`清除模型 ${modelName} 缓存时出错:`, error);
      return false;
    }
  }

  /**
   * 清除所有查询缓存
   * @returns {Promise<boolean>} 是否成功清除
   */
  async clearAllCache() {
    try {
      // TODO: 支持按标签清除缓存，例如 user:123:recommendations
      await this.queryCache.clear('query:*');
      logger.info('已清除所有查询缓存');
      metrics.increment('mongoose_query_cache_clear_all');
      return true;
    } catch (error) {
      logger.error('清除所有查询缓存时出错:', error);
      return false;
    }
  }

  /**
   * 获取缓存统计信息
   * @returns {Object} 统计信息
   */
  getStats() {
    return {
      ...this.stats,
      hitRate: (this.stats.hits + this.stats.misses > 0)
        ? (this.stats.hits / (this.stats.hits + this.stats.misses) * 100).toFixed(2)
        : 0,
      enabled: this.enabled
    };
  }

  /**
   * 重置统计数据
   */
  resetStats() {
    this.stats = {
      hits: 0,
      misses: 0,
      errors: 0,
      lastReset: new Date()
    };
  }
}

// 创建查询缓存实例
const queryCache = new QueryCache();

/**
 * 创建Mongoose查询缓存中间件
 * @returns {Function} Mongoose插件函数
 */
/**
 * 插件功能：
 * - 自动覆盖 exec 方法
 * - 执行前尝试缓存命中
 * - 执行后缓存写入
 * - 慢查询记录
 */
const createMongooseQueryCachePlugin = () => {
  return function(schema) {
    // 保存原始查询执行方法
    const originalExec = schema.Query.prototype.exec;
    
    // 重写exec方法以支持缓存
    schema.Query.prototype.exec = async function() {
      // 如果禁用了缓存，直接执行原始查询
      if (!queryCache.enabled || !queryCache.shouldCache(this)) {
        return originalExec.apply(this, arguments);
      }
      
      // 尝试从缓存获取结果
      const cachedResult = await queryCache.getFromCache(this);
      if (cachedResult) {
        return Array.isArray(cachedResult)
          ? cachedResult.map(doc => this.model.hydrate(doc))
          : (typeof cachedResult === 'object' && cachedResult !== null)
            ? this.model.hydrate(cachedResult)
            : cachedResult;
      }
      
      // 执行原始查询
      const startTime = Date.now();
      const result = await originalExec.apply(this, arguments);
      const duration = Date.now() - startTime;
      
      // 记录慢查询
      if (duration > (config.database.slowQueryThreshold || 500)) {
        logger.warn(`慢查询 [${duration}ms]: ${this.model.modelName}.${this.op}()`);
        metrics.timing('slow_query_duration', duration);
        metrics.increment('slow_query_count');
      }
      
      // 缓存查询结果
      await queryCache.saveToCache(this, result);
      
      return result;
    };
    
    // 添加跳过缓存的方法
    schema.Query.prototype.disableCache = function() {
      this._mongooseOptions = this._mongooseOptions || {};
      this._mongooseOptions.disableCache = true;
      return this;
    };
    
    // 添加设置缓存TTL的方法
    schema.Query.prototype.withCacheTTL = function(ttl) {
      this._mongooseOptions = this._mongooseOptions || {};
      this._mongooseOptions.cacheTTL = ttl;
      return this;
    };
    
    // 添加模型方法用于清除该模型的缓存
    schema.statics.clearCache = async function() {
      return queryCache.clearModelCache(this.modelName);
    };
  };
};

// 创建Mongoose缓存插件
const mongooseQueryCachePlugin = createMongooseQueryCachePlugin();

/**
 * 针对写操作的自动清理缓存中间件（POST/PUT/PATCH/DELETE）
 * - 默认清除所有缓存
 * - 可指定模型清除
 */
const clearQueryCacheMiddleware = (modelNames = []) => {
  return async (req, res, next) => {
    if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH' || req.method === 'DELETE') {
      try {
        if (modelNames.length > 0) {
          // 清除特定模型的缓存
          await Promise.all(modelNames.map(modelName => queryCache.clearModelCache(modelName)));
          logger.info(`已清除模型的查询缓存: ${modelNames.join(', ')}`);
        } else {
          // 清除所有查询缓存
          await queryCache.clearAllCache();
          logger.info('已清除所有查询缓存');
        }
      } catch (error) {
        logger.error('清除查询缓存时出错:', error);
      }
    }
    next();
  };
};

/**
 * 提供缓存统计信息接口（GET /api/cache/query-stats）
 * - 返回命中率、命中次数、失败次数、是否启用等状态
 */
const queryCacheStatsMiddleware = (req, res, next) => {
  if (req.path === '/api/cache/query-stats') {
    const stats = queryCache.getStats();
    return res.json(stats);
  }
  next();
};

module.exports = {
  QueryCache,
  queryCache,
  mongooseQueryCachePlugin,
  clearQueryCacheMiddleware,
  queryCacheStatsMiddleware
};