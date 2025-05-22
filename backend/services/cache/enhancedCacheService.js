/**
 * 增强版缓存服务模块（EnhancedCacheService）
 * 提供高性能缓存机制，支持模型级别配置、版本控制、依赖图清理与缓存分层
 * 与 ModelFactory 深度集成，适用于 AI 推荐、营养档案、订单等高频访问模型
 * 支持 Redis 后端缓存，可动态配置 TTL、层级策略与命中统计
 * @module services/core/enhancedCacheService
 */
const redis = require('redis');
const { promisify } = require('util');
const crypto = require('crypto');
const config = require('../../config');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 增强版缓存服务
 * 提供高级缓存功能和更好的ModelFactory集成
 */
class EnhancedCacheService {
  constructor() {
    this.client = null;
    this.enabled = config.cache && config.cache.enabled;
    this.defaultTTL = (config.cache && config.cache.defaultTTL) || 300; // 默认5分钟
    this.initialized = false;
    
    // 缓存统计
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      errors: 0,
      invalidations: 0,
      lastReset: Date.now()
    };
    
    // 模型特定缓存设置
    this.modelSettings = {
      'User': {
        ttl: 1800, // 30分钟
        disableCache: false,
        volatileFields: ['password', 'lastLoginAt']
      },
      'Merchant': {
        ttl: 3600, // 1小时
        disableCache: false,
        volatileFields: ['averageRating']
      },
      'NutritionProfile': {
        ttl: 300, // 5分钟
        disableCache: false
      },
      'AiRecommendation': {
        ttl: 1800, // 30分钟
        disableCache: false
      },
      'DbMetrics': {
        ttl: 60, // 1分钟
        disableCache: false
      },
      'Order': {
        ttl: 300, // 5分钟
        disableCache: false,
        volatileFields: ['status', 'paymentStatus']
      }
    };
    
    // 缓存依赖关系图（模型间的依赖）
    this.dependencyGraph = {
      'User': ['Order', 'NutritionData', 'Preference'],
      'Merchant': ['Dish', 'Order', 'Review'],
      'Order': ['OrderItem'],
      'Dish': ['MenuItem', 'NutritionInfo']
    };
    
    // 缓存分层设置
    this.cacheTiers = {
      // 一级缓存 - 超频繁访问，短TTL (1分钟)
      tier1: ['User.basicProfile', 'Merchant.basicInfo', 'Dish.basicInfo'],
      // 二级缓存 - 常规访问，中TTL (5-15分钟)
      tier2: ['User.fullProfile', 'Order', 'Merchant.detailedInfo'],
      // 三级缓存 - 低频访问，长TTL (1小时+)
      tier3: ['AiRecommendation', 'NutritionData', 'NutritionInfo']
    };
  }

  /**
   * 初始化Redis连接
   * @returns {Promise<boolean>} 连接是否成功
   */
  async initialize() {
    if (!this.enabled) {
      logger.info('增强版缓存服务已禁用');
      return false;
    }
    
    if (this.initialized) {
      return true;
    }
    
    try {
      // 创建Redis客户端
      this.client = redis.createClient({
        url: config.cache.redisUrl || 'redis://localhost:6379',
        password: config.cache.redisPassword || '',
        database: config.cache.redisDb || 0,
        retry_strategy: (options) => {
          if (options.error && options.error.code === 'ECONNREFUSED') {
            // 连接被拒绝，5秒后重试
            return 5000;
          }
          if (options.total_retry_time > 1000 * 60 * 60) {
            // 连接超时（1小时），不再尝试
            return new Error('重试时间已用尽，Redis连接失败');
          }
          // 指数级增长的重试延迟
          return Math.min(options.attempt * 100, 3000);
        }
      });
      
      // 将回调式API转换为Promise风格
      this.getAsync = promisify(this.client.get).bind(this.client);
      this.setAsync = promisify(this.client.set).bind(this.client);
      this.delAsync = promisify(this.client.del).bind(this.client);
      this.keysAsync = promisify(this.client.keys).bind(this.client);
      this.existsAsync = promisify(this.client.exists).bind(this.client);
      this.ttlAsync = promisify(this.client.ttl).bind(this.client);
      this.expireAsync = promisify(this.client.expire).bind(this.client);
      this.scanAsync = promisify(this.client.scan).bind(this.client);
      this.mgetAsync = promisify(this.client.mget).bind(this.client);
      this.hsetAsync = promisify(this.client.hset).bind(this.client);
      this.hgetAsync = promisify(this.client.hget).bind(this.client);
      this.hmsetAsync = promisify(this.client.hmset).bind(this.client);
      this.hmgetAsync = promisify(this.client.hmget).bind(this.client);
      this.hkeysAsync = promisify(this.client.hkeys).bind(this.client);
      this.hgetallAsync = promisify(this.client.hgetall).bind(this.client);
      
      // 设置事件监听器
      this.client.on('error', (error) => {
        logger.error('Redis连接错误', { error });
        this.stats.errors++;
      });
      
      this.client.on('ready', () => {
        logger.info('Redis连接已就绪');
        this.initialized = true;
      });
      
      this.client.on('reconnecting', () => {
        logger.info('正在重新连接Redis...');
      });
      
      return true;
    } catch (error) {
      logger.error('初始化Redis客户端失败', { error });
      this.stats.errors++;
      return false;
    }
  }
  
  /**
   * 获取模型的缓存设置
   * @param {string} modelName - 模型名称
   * @returns {Object} 缓存设置
   */
  getModelCacheSettings(modelName) {
    return this.modelSettings[modelName] || {
      ttl: this.defaultTTL,
      disableCache: false
    };
  }
  
  /**
   * 检查操作是否可缓存
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 操作参数
   * @returns {boolean} 是否可缓存
   */
  isCacheable(modelName, operation, args) {
    // 缓存未启用
    if (!this.enabled || !this.initialized) {
      return false;
    }
    
    // 不是读操作
    const readMethods = ['find', 'findOne', 'findById', 'count', 'countDocuments', 
      'estimatedDocumentCount', 'distinct', 'aggregate'];
    if (!readMethods.includes(operation)) {
      return false;
    }
    
    // 排除的集合
    if (config.cache.excludedCollections?.includes(modelName)) {
      return false;
    }
    
    // 获取模型的缓存设置
    const modelCacheSettings = this.getModelCacheSettings(modelName);
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
   * 生成缓存键
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 操作参数
   * @returns {string} 缓存键
   */
  generateCacheKey(modelName, operation, args) {
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
        
        return argCopy;
      });
      
      // 在用户查询中添加版本标记，以便在用户资料更新时自动失效缓存
      if (modelName === 'User' && args[0] && args[0]._id) {
        const userId = args[0]._id.toString ? args[0]._id.toString() : args[0]._id;
          
        // 创建包含操作和版本的对象
        const keyObj = {
          model: modelName,
          op: operation,
          args: filteredArgs,
          version: this._getCachedVersion(`user:${userId}:version`) || '1'
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
        const id = args[0].toString ? args[0].toString() : args[0];
        return `db:${modelName}:${operation}:${id}:${hash.substring(0, 8)}`;
      }
      
      if (operation === 'findOne' && args[0] && args[0]._id) {
        const id = args[0]._id.toString ? args[0]._id.toString() : args[0]._id;
        return `db:${modelName}:${operation}:${id}:${hash.substring(0, 8)}`;
      }
      
      return `db:${modelName}:${operation}:${hash}`;
    } catch (error) {
      logger.error('生成缓存键时出错', { error });
      return null;
    }
  }
  
  /**
   * 获取缓存版本
   * @param {string} versionKey - 版本键
   * @returns {Promise<string>} 缓存版本
   * @private
   */
  async _getCachedVersion(versionKey) {
    try {
      const version = await this.getAsync(versionKey);
      
      if (version) {
        return version;
      }
      
      // 如果缓存中没有，创建一个新版本
      const newVersion = Date.now().toString();
      await this.setAsync(versionKey, newVersion, 'EX', 86400); // 24小时
      return newVersion;
    } catch (error) {
      logger.error(`获取缓存版本时出错 [${versionKey}]`, { error });
      return '1';
    }
  }
  
  /**
   * 更新缓存版本
   * @param {string} versionKey - 版本键
   * @returns {Promise<boolean>} 是否成功
   */
  async updateCacheVersion(versionKey) {
    try {
      const newVersion = Date.now().toString();
      await this.setAsync(versionKey, newVersion, 'EX', 86400); // 24小时
      
      logger.debug(`缓存版本已更新为 ${newVersion}`);
      return true;
    } catch (error) {
      logger.error(`更新缓存版本时出错 [${versionKey}]`, { error });
      return false;
    }
  }
  
  /**
   * 从缓存获取数据
   * @param {string} key - 缓存键
   * @returns {Promise<Object|null>} 缓存的数据或null
   */
  async get(key) {
    if (!this.enabled || !this.initialized) {
      return null;
    }
    
    try {
      const cachedData = await this.getAsync(key);
      
      if (cachedData) {
        this.stats.hits++;
        // 解析JSON数据
        return JSON.parse(cachedData);
      } else {
        this.stats.misses++;
        return null;
      }
    } catch (error) {
      logger.error(`缓存获取错误 [${key}]`, { error });
      this.stats.errors++;
      return null;
    }
  }
  
  /**
   * 将数据存入缓存
   * @param {string} key - 缓存键
   * @param {Object} data - 要缓存的数据
   * @param {number} ttl - 过期时间(秒)
   * @returns {Promise<boolean>} 是否成功
   */
  async set(key, data, ttl = this.defaultTTL) {
    if (!this.enabled || !this.initialized) {
      return false;
    }
    
    try {
      // 将数据转换为JSON字符串
      const jsonData = JSON.stringify(data);
      
      // 设置带过期时间的缓存
      await this.setAsync(key, jsonData, 'EX', ttl);
      
      this.stats.sets++;
      return true;
    } catch (error) {
      logger.error(`缓存设置错误 [${key}]`, { error });
      this.stats.errors++;
      return false;
    }
  }
  
  /**
   * 批量获取缓存数据
   * @param {Array<string>} keys - 缓存键数组
   * @returns {Promise<Array>} 缓存数据数组
   */
  async mget(keys) {
    if (!this.enabled || !this.initialized || !keys.length) {
      return [];
    }
    
    try {
      const cachedResults = await this.mgetAsync(keys);
      
      return cachedResults.map(item => {
        if (item) {
          this.stats.hits++;
          return JSON.parse(item);
        } else {
          this.stats.misses++;
          return null;
        }
      });
    } catch (error) {
      logger.error('批量获取缓存错误', { error });
      this.stats.errors++;
      return new Array(keys.length).fill(null);
    }
  }
  
  /**
   * 缓存模型查询结果
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 查询参数
   * @param {*} result - 查询结果
   * @returns {Promise<boolean>} 是否成功
   */
  async cacheModelResult(modelName, operation, args, result) {
    if (!this.isCacheable(modelName, operation, args)) {
      return false;
    }
    
    const cacheKey = this.generateCacheKey(modelName, operation, args);
    if (!cacheKey) {
      return false;
    }
    
    // 获取适当的TTL
    let ttl = this.defaultTTL;
    
    // 根据模型和操作类型确定TTL
    const modelSettings = this.getModelCacheSettings(modelName);
    if (modelSettings) {
      ttl = modelSettings.ttl;
    }
    
    // 根据缓存分层调整TTL
    if (this.cacheTiers.tier1.includes(`${modelName}.${operation}`)) {
      ttl = Math.min(ttl, 60); // 1分钟
    } else if (this.cacheTiers.tier2.includes(`${modelName}.${operation}`)) {
      ttl = Math.min(ttl, 900); // 15分钟
    } else if (this.cacheTiers.tier3.includes(`${modelName}.${operation}`)) {
      ttl = Math.max(ttl, 3600); // 1小时
    }
    
    // 缓存结果
    return this.set(cacheKey, result, ttl);
  }
  
  /**
   * 获取模型缓存的结果
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作名称
   * @param {Array} args - 查询参数
   * @returns {Promise<*>} 缓存的结果或null
   */
  async getModelResult(modelName, operation, args) {
    if (!this.isCacheable(modelName, operation, args)) {
      return null;
    }
    
    const cacheKey = this.generateCacheKey(modelName, operation, args);
    if (!cacheKey) {
      return null;
    }
    
    return this.get(cacheKey);
  }
  
  /**
   * 清除模型相关的缓存
   * @param {string} modelName - 模型名称
   * @param {string} [id] - 文档ID
   * @returns {Promise<number>} 清除的键数量
   */
  async invalidateModel(modelName, id = null) {
    if (!this.enabled || !this.initialized) {
      return 0;
    }
    
    try {
      let pattern;
      let deletedKeys = 0;
      
      if (id) {
        // 清除特定文档相关的缓存
        pattern = `db:${modelName}:*:${id}:*`;
        deletedKeys = await this.clearPattern(pattern);
      } else {
        // 清除整个模型的缓存
        pattern = `db:${modelName}:*`;
        deletedKeys = await this.clearPattern(pattern);
      }
      
      // 清除依赖项的缓存
      const dependencies = this.dependencyGraph[modelName] || [];
      for (const dep of dependencies) {
        const depPattern = `db:${dep}:*`;
        const depKeys = await this.clearPattern(depPattern);
        deletedKeys += depKeys;
      }
      
      this.stats.invalidations += deletedKeys;
      return deletedKeys;
    } catch (error) {
      logger.error(`清除模型缓存时出错 [${modelName}]`, { error });
      return 0;
    }
  }
  
  /**
   * 清除指定模式的所有缓存
   * @param {string} pattern - 键模式，如"users:*"
   * @returns {Promise<number>} 删除的键数量
   */
  async clearPattern(pattern) {
    if (!this.enabled || !this.initialized) {
      return 0;
    }
    
    try {
      // 查找匹配模式的键
      const keys = await this.keysAsync(pattern);
      
      if (keys && keys.length > 0) {
        // 批量删除
        await this.delAsync(keys);
        return keys.length;
      }
      
      return 0;
    } catch (error) {
      logger.error(`清除缓存模式错误 [${pattern}]`, { error });
      this.stats.errors++;
      return 0;
    }
  }
  
  /**
   * 获取缓存统计信息
   * @returns {Object} 缓存统计
   */
  getStats() {
    const hitRatio = this.stats.hits + this.stats.misses > 0 
      ? this.stats.hits / (this.stats.hits + this.stats.misses) 
      : 0;
    
    return {
      ...this.stats,
      hitRatio,
      hitRatioPercentage: (hitRatio * 100).toFixed(2) + '%',
      cached: {
        models: this.modelSettings,
        tiers: this.cacheTiers
      },
      redis: this.client ? {
        connected: this.client.connected,
        serverInfo: this.client.server_info
      } : null,
      timestamp: new Date()
    };
  }
  
  /**
   * 重置统计信息
   */
  resetStats() {
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      errors: 0,
      invalidations: 0,
      lastReset: Date.now()
    };
  }
  
  /**
   * 关闭Redis客户端
   */
  async close() {
    if (this.client) {
      await this.client.quit();
      this.initialized = false;
      logger.info('Redis客户端已关闭');
    }
  }
}

// 创建单例
const enhancedCacheService = new EnhancedCacheService();

module.exports = enhancedCacheService; 