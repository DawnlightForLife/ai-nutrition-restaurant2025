/**
 * 访问轨迹追踪服务 - 记录用户访问行为并检测异常模式
 * @module services/security/accessTrackService
 */

// ✅ 命名规范已统一为 camelCase
// ✅ 所有函数保持 async / await
// ✅ 日志结构标准，异常处理清晰

const mongoose = require('mongoose');
const redis = require('redis');
const { promisify } = require('util');
const geoip = require('geoip-lite');
const UAParser = require('ua-parser-js');
const logger = require('../../utils/logger/winstonLogger.js');
const EventEmitter = require('events');

/**
 * 访问轨迹追踪服务类
 */
class AccessTrackService extends EventEmitter {
  /**
   * 构造函数
   * @param {Object} options - 配置选项
   */
  constructor(options = {}) {
    super();
    
    this.options = {
      // Redis配置
      redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
      // 轨迹保留时间（秒）
      trackingTTL: parseInt(process.env.ACCESS_TRACKING_TTL || '604800', 10), // 默认7天
      // 异常检测阈值
      thresholds: {
        // 单IP每分钟最大请求数
        requestsPerMinute: parseInt(process.env.MAX_REQUESTS_PER_MINUTE || '120', 10),
        // 单用户每分钟最大请求数
        userRequestsPerMinute: parseInt(process.env.MAX_USER_REQUESTS_PER_MINUTE || '60', 10),
        // 单用户访问资源ID数量阈值（在短时间内）
        resourceAccessCount: parseInt(process.env.RESOURCE_ACCESS_THRESHOLD || '50', 10),
        // IP切换阈值（同一用户在短时间内切换IP的次数）
        ipSwitchCount: parseInt(process.env.IP_SWITCH_THRESHOLD || '3', 10),
        // 检测窗口大小（秒）
        detectionWindow: parseInt(process.env.DETECTION_WINDOW_SECONDS || '300', 10), // 默认5分钟
      },
      ...options
    };
    
    this.logger = logger.child({ service: 'AccessTrack' });
    this.redisClient = null;
    this.redisCommands = {};
    this.initialized = false;
    
    // 访问轨迹模型缓存
    this.accessTrackModel = null;
    
    this.logger.info('访问轨迹追踪服务已创建', {
      thresholds: this.options.thresholds
    });
  }
  
  /**
   * 初始化服务
   */
  async initialize() {
    if (this.initialized) {
      this.logger.warn('访问轨迹追踪服务已经初始化过');
      return;
    }
    
    this.logger.info('正在初始化访问轨迹追踪服务...');
    
    try {
      // 连接Redis
      await this._connectRedis();
      
      // 设置访问轨迹模型
      this._setupAccessTrackModel();
      
      // 初始化完成
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('访问轨迹追踪服务初始化完成');
    } catch (error) {
      this.logger.error('初始化访问轨迹追踪服务失败:', error);
      throw error;
    }
  }
  
  /**
   * 关闭服务
   */
  async shutdown() {
    if (!this.initialized) {
      return;
    }
    
    if (this.redisClient) {
      await this.redisClient.quit();
      this.redisClient = null;
    }
    
    this.initialized = false;
    this.emit('shutdown');
    this.logger.info('访问轨迹追踪服务已关闭');
  }
  
  /**
   * 记录用户访问
   * @param {Object} req - Express请求对象
   * @param {Object} options - 额外选项
   * @returns {Promise<Object>} 轨迹对象和检测结果
   */
  async trackAccess(req, options = {}) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      // 获取访问信息
      const accessData = this._extractAccessData(req, options);
      
      // 记录访问轨迹
      const trackId = await this._recordAccessTrack(accessData);
      
      // 检测异常行为
      const detectionResult = await this._detectAnomalies(accessData);
      
      // 发出事件
      if (detectionResult.anomalies.length > 0) {
        this.emit('anomaly_detected', {
          trackId,
          accessData,
          detectionResult
        });
      }
      
      return {
        trackId,
        accessData,
        detectionResult
      };
    } catch (error) {
      this.logger.error('记录访问轨迹失败:', error);
      throw error;
    }
  }
  
  /**
   * 获取用户访问历史
   * @param {String} userId - 用户ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 访问历史记录
   */
  async getUserAccessHistory(userId, options = {}) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    const query = { userId };
    const limit = options.limit || 100;
    const skip = options.skip || 0;
    const sort = options.sort || { timestamp: -1 };
    
    try {
      const history = await this.accessTrackModel.find(query)
        .sort(sort)
        .limit(limit)
        .skip(skip);
      
      return history;
    } catch (error) {
      this.logger.error(`获取用户访问历史失败: ${userId}`, error);
      throw error;
    }
  }
  
  /**
   * 获取资源访问历史
   * @param {String} resourceType - 资源类型
   * @param {String} resourceId - 资源ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 访问历史记录
   */
  async getResourceAccessHistory(resourceType, resourceId, options = {}) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    const query = {
      'resource.type': resourceType,
      'resource.id': resourceId
    };
    
    const limit = options.limit || 100;
    const skip = options.skip || 0;
    const sort = options.sort || { timestamp: -1 };
    
    try {
      const history = await this.accessTrackModel.find(query)
        .sort(sort)
        .limit(limit)
        .skip(skip);
      
      return history;
    } catch (error) {
      this.logger.error(`获取资源访问历史失败: ${resourceType}/${resourceId}`, error);
      throw error;
    }
  }
  
  /**
   * 封禁IP地址
   * @param {String} ip - IP地址
   * @param {Number} duration - 封禁时长（秒）
   * @param {String} reason - 封禁原因
   * @returns {Promise<Boolean>} 是否成功
   */
  async banIP(ip, duration = 3600, reason = 'anomaly_detected') {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      const key = `banned_ip:${ip}`;
      const value = JSON.stringify({
        ip,
        reason,
        timestamp: new Date().toISOString(),
        expiresAt: new Date(Date.now() + duration * 1000).toISOString()
      });
      
      await this.redisCommands.setEx(key, duration, value);
      
      this.logger.info(`已封禁IP: ${ip}，持续时间: ${duration}秒，原因: ${reason}`);
      
      // 发出封禁事件
      this.emit('ip_banned', {
        ip,
        duration,
        reason,
        timestamp: new Date()
      });
      
      return true;
    } catch (error) {
      this.logger.error(`封禁IP失败: ${ip}`, error);
      return false;
    }
  }
  
  /**
   * 检查IP是否被封禁
   * @param {String} ip - IP地址
   * @returns {Promise<Object|null>} 封禁信息或null
   */
  async checkIPBan(ip) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      const key = `banned_ip:${ip}`;
      const value = await this.redisCommands.get(key);
      
      if (!value) {
        return null;
      }
      
      return JSON.parse(value);
    } catch (error) {
      this.logger.error(`检查IP封禁状态失败: ${ip}`, error);
      return null;
    }
  }
  
  /**
   * 解封IP地址
   * @param {String} ip - IP地址
   * @returns {Promise<Boolean>} 是否成功
   */
  async unbanIP(ip) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      const key = `banned_ip:${ip}`;
      await this.redisCommands.del(key);
      
      this.logger.info(`已解封IP: ${ip}`);
      
      // 发出解封事件
      this.emit('ip_unbanned', {
        ip,
        timestamp: new Date()
      });
      
      return true;
    } catch (error) {
      this.logger.error(`解封IP失败: ${ip}`, error);
      return false;
    }
  }
  
  /**
   * 获取用户资源访问统计
   * @param {String} userId - 用户ID
   * @param {String} resourceType - 资源类型
   * @param {Number} timeWindow - 时间窗口（秒）
   * @returns {Promise<Object>} 访问统计信息
   */
  async getUserResourceAccessStats(userId, resourceType, timeWindow = 3600) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    const now = new Date();
    const startTime = new Date(now.getTime() - (timeWindow * 1000));
    
    try {
      // 使用MongoDB聚合查询获取统计信息
      const pipeline = [
        {
          $match: {
            userId,
            'resource.type': resourceType,
            timestamp: { $gte: startTime }
          }
        },
        {
          $group: {
            _id: '$resource.id',
            count: { $sum: 1 },
            firstAccess: { $min: '$timestamp' },
            lastAccess: { $max: '$timestamp' },
            methods: { $addToSet: '$method' }
          }
        },
        {
          $sort: { count: -1 }
        }
      ];
      
      const stats = await this.accessTrackModel.aggregate(pipeline);
      
      // 计算总体统计信息
      const totalAccesses = stats.reduce((sum, item) => sum + item.count, 0);
      const uniqueResources = stats.length;
      
      return {
        userId,
        resourceType,
        timeWindow,
        totalAccesses,
        uniqueResources,
        resources: stats
      };
    } catch (error) {
      this.logger.error(`获取用户资源访问统计失败: ${userId}/${resourceType}`, error);
      throw error;
    }
  }
  
  /**
   * 内部方法：连接Redis
   * @private
   */
  async _connectRedis() {
    this.logger.debug(`正在连接Redis: ${this.options.redisUrl}`);
    
    try {
      // 创建Redis客户端
      this.redisClient = redis.createClient({
        url: this.options.redisUrl
      });
      
      // 包装Redis命令为Promise
      this.redisCommands = {
        get: promisify(this.redisClient.get).bind(this.redisClient),
        set: promisify(this.redisClient.set).bind(this.redisClient),
        setEx: promisify(this.redisClient.setex).bind(this.redisClient),
        del: promisify(this.redisClient.del).bind(this.redisClient),
        incr: promisify(this.redisClient.incr).bind(this.redisClient),
        expire: promisify(this.redisClient.expire).bind(this.redisClient),
        hGet: promisify(this.redisClient.hget).bind(this.redisClient),
        hSet: promisify(this.redisClient.hset).bind(this.redisClient),
        hGetAll: promisify(this.redisClient.hgetall).bind(this.redisClient),
        zAdd: promisify(this.redisClient.zadd).bind(this.redisClient),
        zRange: promisify(this.redisClient.zrange).bind(this.redisClient),
        zRangeByScore: promisify(this.redisClient.zrangebyscore).bind(this.redisClient),
        zRem: promisify(this.redisClient.zrem).bind(this.redisClient),
        zCount: promisify(this.redisClient.zcount).bind(this.redisClient)
      };
      
      // 设置错误处理
      this.redisClient.on('error', (error) => {
        this.logger.error('Redis连接错误:', error);
        this.emit('redis_error', error);
      });
      
      // 连接成功事件
      this.redisClient.on('connect', () => {
        this.logger.info('Redis连接成功');
        this.emit('redis_connected');
      });
      
      this.logger.info('Redis客户端创建成功');
    } catch (error) {
      this.logger.error('连接Redis失败:', error);
      throw error;
    }
  }
  
  /**
   * 内部方法：设置访问轨迹模型
   * @private
   */
  _setupAccessTrackModel() {
    // 检查模型是否已存在
    if (mongoose.models.AccessTrack) {
      this.accessTrackModel = mongoose.model('AccessTrack');
      return;
    }
    
    // 创建访问轨迹Schema
    const accessTrackSchema = new mongoose.Schema({
      userId: { type: String, sparse: true, index: true },
      sessionId: { type: String, sparse: true, index: true },
      ip: { type: String, required: true, index: true },
      method: { type: String, required: true },
      path: { type: String, required: true },
      query: { type: Object },
      resource: {
        type: { type: String, index: true },
        id: { type: String, index: true }
      },
      userAgent: {
        browser: { type: String },
        device: { type: String },
        os: { type: String }
      },
      location: {
        country: { type: String },
        region: { type: String },
        city: { type: String }
      },
      timestamp: { type: Date, default: Date.now, index: true },
      responseStatus: { type: Number },
      responseTime: { type: Number },
      referrer: { type: String },
      anomalyScore: { type: Number, default: 0 }
    }, {
      timestamps: true
    });
    
    // 创建复合索引
    accessTrackSchema.index({ userId: 1, timestamp: -1 });
    accessTrackSchema.index({ ip: 1, timestamp: -1 });
    accessTrackSchema.index({ 'resource.type': 1, 'resource.id': 1, timestamp: -1 });
    
    // 创建模型
    this.accessTrackModel = mongoose.model('AccessTrack', accessTrackSchema);
    this.logger.info('访问轨迹模型已创建');
  }
  
  /**
   * 内部方法：提取访问数据
   * @param {Object} req - Express请求对象
   * @param {Object} options - 额外选项
   * @returns {Object} 结构化的访问数据
   * @private
   */
  _extractAccessData(req, options = {}) {
    // 提取IP地址
    const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    
    // 提取用户代理信息
    const userAgent = req.headers['user-agent'];
    const uaParser = new UAParser(userAgent);
    const uaResult = uaParser.getResult();
    
    // 尝试获取位置信息
    const geoData = geoip.lookup(ip) || {};
    
    // 提取资源类型和ID
    const resourceType = options.resourceType || this._guessResourceType(req);
    const resourceId = options.resourceId || this._guessResourceId(req);
    
    return {
      userId: req.user ? req.user.id : null,
      sessionId: req.session ? req.session.id : null,
      ip,
      method: req.method,
      path: req.path,
      query: req.query,
      resource: {
        type: resourceType,
        id: resourceId
      },
      userAgent: {
        browser: `${uaResult.browser.name} ${uaResult.browser.version}`,
        device: uaResult.device.type || 'unknown',
        os: `${uaResult.os.name} ${uaResult.os.version}`
      },
      location: {
        country: geoData.country,
        region: geoData.region,
        city: geoData.city
      },
      timestamp: new Date(),
      responseStatus: options.responseStatus,
      responseTime: options.responseTime,
      referrer: req.headers.referer || req.headers.referrer
    };
  }
  
  /**
   * 内部方法：记录访问轨迹
   * @param {Object} accessData - 访问数据
   * @returns {Promise<String>} 轨迹ID
   * @private
   */
  async _recordAccessTrack(accessData) {
    // 保存到MongoDB
    const accessTrack = new this.accessTrackModel(accessData);
    await accessTrack.save();
    
    // 更新Redis中的访问计数器
    const timestamp = Math.floor(Date.now() / 1000);
    const minute = Math.floor(timestamp / 60) * 60; // 按分钟计数
    
    // IP访问计数
    const ipKey = `access:ip:${accessData.ip}:${minute}`;
    await this.redisCommands.incr(ipKey);
    await this.redisCommands.expire(ipKey, 3600); // 保留1小时
    
    // 用户访问计数
    if (accessData.userId) {
      const userKey = `access:user:${accessData.userId}:${minute}`;
      await this.redisCommands.incr(userKey);
      await this.redisCommands.expire(userKey, 3600); // 保留1小时
      
      // 记录用户访问的资源ID集合
      if (accessData.resource.id) {
        const resourceKey = `access:user:${accessData.userId}:${accessData.resource.type}:resources`;
        await this.redisCommands.zAdd(resourceKey, timestamp, accessData.resource.id);
        await this.redisCommands.expire(resourceKey, this.options.thresholds.detectionWindow);
      }
      
      // 记录用户的IP地址
      const userIpKey = `access:user:${accessData.userId}:ips`;
      await this.redisCommands.zAdd(userIpKey, timestamp, accessData.ip);
      await this.redisCommands.expire(userIpKey, this.options.thresholds.detectionWindow);
    }
    
    return accessTrack._id.toString();
  }
  
  /**
   * 内部方法：检测异常行为
   * @param {Object} accessData - 访问数据
   * @returns {Promise<Object>} 检测结果
   * @private
   */
  async _detectAnomalies(accessData) {
    const anomalies = [];
    let anomalyScore = 0;
    
    // 获取当前时间戳
    const timestamp = Math.floor(Date.now() / 1000);
    const minute = Math.floor(timestamp / 60) * 60; // 按分钟计数
    
    // 检测1：IP频率限制
    const ipKey = `access:ip:${accessData.ip}:${minute}`;
    const ipCount = await this.redisCommands.get(ipKey);
    
    if (ipCount && parseInt(ipCount) > this.options.thresholds.requestsPerMinute) {
      anomalies.push({
        type: 'high_frequency_ip',
        details: `IP ${accessData.ip} 在一分钟内发送了 ${ipCount} 个请求，超过阈值 ${this.options.thresholds.requestsPerMinute}`
      });
      anomalyScore += 30;
    }
    
    // 有用户ID才进行用户相关检测
    if (accessData.userId) {
      // 检测2：用户请求频率
      const userKey = `access:user:${accessData.userId}:${minute}`;
      const userCount = await this.redisCommands.get(userKey);
      
      if (userCount && parseInt(userCount) > this.options.thresholds.userRequestsPerMinute) {
        anomalies.push({
          type: 'high_frequency_user',
          details: `用户 ${accessData.userId} 在一分钟内发送了 ${userCount} 个请求，超过阈值 ${this.options.thresholds.userRequestsPerMinute}`
        });
        anomalyScore += 25;
      }
      
      // 检测3：资源访问暴力遍历
      if (accessData.resource.type && accessData.resource.id) {
        const resourceKey = `access:user:${accessData.userId}:${accessData.resource.type}:resources`;
        const windowStart = timestamp - this.options.thresholds.detectionWindow;
        
        const resourceCount = await this.redisCommands.zCount(resourceKey, windowStart, '+inf');
        
        if (resourceCount > this.options.thresholds.resourceAccessCount) {
          anomalies.push({
            type: 'resource_enumeration',
            details: `用户 ${accessData.userId} 在 ${this.options.thresholds.detectionWindow}秒 内访问了 ${resourceCount} 个不同的 ${accessData.resource.type} 资源，超过阈值 ${this.options.thresholds.resourceAccessCount}`
          });
          anomalyScore += 50;
        }
      }
      
      // 检测4：IP切换
      const userIpKey = `access:user:${accessData.userId}:ips`;
      const windowStart = timestamp - this.options.thresholds.detectionWindow;
      
      // 获取时间窗口内用户使用的IP
      const userIps = await this.redisCommands.zRangeByScore(userIpKey, windowStart, '+inf');
      
      // 检查是否有多个IP
      if (userIps && userIps.length > this.options.thresholds.ipSwitchCount) {
        anomalies.push({
          type: 'ip_switching',
          details: `用户 ${accessData.userId} 在 ${this.options.thresholds.detectionWindow}秒 内使用了 ${userIps.length} 个不同的IP地址，超过阈值 ${this.options.thresholds.ipSwitchCount}`
        });
        anomalyScore += 40;
      }
    }
    
    // 返回检测结果
    return {
      timestamp: new Date(),
      anomalies,
      anomalyScore,
      thresholds: this.options.thresholds
    };
  }
  
  /**
   * 内部方法：猜测资源类型
   * @param {Object} req - Express请求对象
   * @returns {String} 资源类型
   * @private
   */
  _guessResourceType(req) {
    const path = req.path.toLowerCase();

    // 根据路径前缀判断资源类型
    if (path.startsWith('/api/users')) return 'user';
    if (path.startsWith('/api/nutrition-profiles')) return 'nutritionProfile';
    if (path.startsWith('/api/dishes')) return 'dish';
    if (path.startsWith('/api/stores')) return 'store';
    if (path.startsWith('/api/recommendations')) return 'recommendation';
    if (path.startsWith('/api/health-data')) return 'healthData';
    if (path.startsWith('/api/orders')) return 'order';
    if (path.startsWith('/api/payments')) return 'payment';

    // 默认未知资源类型
    return 'unknown';
  }
  
  /**
   * 内部方法：猜测资源ID
   * @param {Object} req - Express请求对象
   * @returns {String|null} 资源ID
   * @private
   */
  _guessResourceId(req) {
    const path = req.path;
    
    // 尝试从路径中提取ID
    // 常见模式：/api/resource_type/:id
    const segments = path.split('/').filter(Boolean);
    if (segments.length >= 3) {
      // 取最后一个段作为ID
      return segments[segments.length - 1];
    }
    
    // 尝试从查询参数中提取ID
    if (req.query.id) return req.query.id;
    if (req.query.userId) return req.query.userId;
    if (req.query.profileId) return req.query.profileId;
    
    return null;
  }
}

module.exports = AccessTrackService; 