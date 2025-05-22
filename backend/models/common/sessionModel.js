/**
 * 用户会话模型
 * 用于管理和跟踪用户会话数据
 * @module models/session/sessionModel
 */

const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');
const crypto = require('crypto');

// 定义用户会话模型
const sessionSchema = new mongoose.Schema({
  // 会话标识信息
  sessionId: {
    type: String,
    required: true,
    unique: true,
    index: true,
    description: '会话唯一标识'
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    index: true,
    description: '关联用户ID，匿名用户为null'
  },
  anonymousId: {
    type: String,
    sparse: true,
    index: true,
    description: '匿名用户标识符'
  },
  
  // 会话状态
  status: {
    type: String,
    enum: ['active', 'expired', 'terminated', 'idle'],
    default: 'active',
    index: true,
    description: '会话状态'
  },
  
  // 会话数据
  data: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
    description: '会话数据'
  },
  
  // 设备和客户端信息
  device: {
    type: {
      type: String,
      enum: ['mobile', 'tablet', 'desktop', 'tv', 'wearable', 'other'],
      description: '设备类型'
    },
    brand: {
      type: String,
      description: '设备品牌'
    },
    model: {
      type: String,
      description: '设备型号'
    },
    os: {
      name: {
        type: String,
        description: '操作系统名称'
      },
      version: {
        type: String,
        description: '操作系统版本'
      }
    },
    screenSize: {
      width: {
        type: Number,
        description: '屏幕宽度'
      },
      height: {
        type: Number,
        description: '屏幕高度'
      }
    },
    uniqueId: {
      type: String,
      description: '设备唯一标识'
    }
  },
  
  // 浏览器信息
  browser: {
    name: {
      type: String,
      description: '浏览器名称'
    },
    version: {
      type: String,
      description: '浏览器版本'
    },
    engine: {
      type: String,
      description: '渲染引擎'
    },
    language: {
      type: String,
      description: '浏览器语言'
    },
    userAgent: {
      type: String,
      description: '用户代理字符串'
    }
  },
  
  // 应用信息
  app: {
    version: {
      type: String,
      description: '应用版本'
    },
    buildNumber: {
      type: String,
      description: '应用构建号'
    },
    platform: {
      type: String,
      enum: ['web', 'ios', 'android', 'desktop', 'other'],
      description: '应用平台'
    },
    environment: {
      type: String,
      enum: ['production', 'staging', 'development', 'testing'],
      default: 'production',
      description: '应用环境'
    }
  },
  
  // 地理位置信息
  location: {
    coordinates: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point'
      },
      coordinates: {
        type: [Number],
        description: '坐标，[经度, 纬度]'
      }
    },
    country: {
      type: String,
      description: '国家'
    },
    region: {
      type: String,
      description: '地区/省份'
    },
    city: {
      type: String,
      description: '城市'
    },
    ip: {
      type: String,
      description: 'IP地址'
    },
    lastUpdated: {
      type: Date,
      description: '位置最后更新时间'
    }
  },
  
  // 会话活动
  activity: {
    lastActive: {
      type: Date,
      default: Date.now,
      description: '最后活动时间'
    },
    totalRequests: {
      type: Number,
      default: 0,
      description: '总请求次数'
    },
    pageViews: {
      type: Number,
      default: 0,
      description: '页面访问次数'
    },
    events: {
      type: Number,
      default: 0,
      description: '触发事件次数'
    },
    path: {
      current: {
        type: String,
        description: '当前页面路径'
      },
      previous: {
        type: String,
        description: '上一页面路径'
      }
    },
    referrer: {
      type: String,
      description: '来源URL'
    },
    entryPoint: {
      type: String,
      description: '进入点(首个访问页面)'
    },
    duration: {
      type: Number,
      default: 0,
      description: '会话持续时间(秒)'
    }
  },
  
  // 认证信息
  auth: {
    isAuthenticated: {
      type: Boolean,
      default: false,
      description: '是否已认证'
    },
    method: {
      type: String,
      enum: ['password', 'oauth', 'token', 'sso', 'mfa', 'none'],
      default: 'none',
      description: '认证方式'
    },
    provider: {
      type: String,
      description: '认证提供商'
    },
    authenticatedAt: {
      type: Date,
      description: '认证时间'
    },
    expiresAt: {
      type: Date,
      description: '认证过期时间'
    },
    lastVerifiedAt: {
      type: Date,
      description: '最后验证时间'
    }
  },
  
  // 安全信息
  security: {
    token: {
      type: String,
      description: '会话令牌'
    },
    csrfToken: {
      type: String,
      description: 'CSRF令牌'
    },
    fingerprint: {
      type: String,
      description: '浏览器指纹'
    },
    riskScore: {
      type: Number,
      min: 0,
      max: 100,
      default: 0,
      description: '风险评分(0-100)'
    },
    riskFactors: [{
      type: String,
      description: '风险因素'
    }],
    suspicious: {
      type: Boolean,
      default: false,
      description: '是否可疑会话'
    },
    lastIpChange: {
      type: Date,
      description: '最后IP变更时间'
    }
  },
  
  // 性能指标
  performance: {
    loadTime: {
      type: Number,
      description: '平均页面加载时间(ms)'
    },
    responseTime: {
      type: Number,
      description: '平均服务器响应时间(ms)'
    },
    networkLatency: {
      type: Number,
      description: '网络延迟(ms)'
    },
    cacheHitRate: {
      type: Number,
      description: '缓存命中率(%)'
    }
  },
  
  // 会话元数据
  preferences: {
    language: {
      type: String,
      description: '语言偏好'
    },
    theme: {
      type: String,
      description: '主题偏好'
    },
    timezone: {
      type: String,
      description: '时区'
    },
    notifications: {
      type: Boolean,
      description: '是否接收通知'
    },
    viewMode: {
      type: String,
      enum: ['list', 'grid', 'compact', 'detailed'],
      description: '视图模式'
    },
    savedFilters: {
      type: mongoose.Schema.Types.Mixed,
      description: '保存的过滤器'
    },
    customSettings: {
      type: mongoose.Schema.Types.Mixed,
      description: '自定义设置'
    }
  },
  
  // 会话限制和控制
  restrictions: {
    isRestricted: {
      type: Boolean,
      default: false,
      description: '是否受限'
    },
    rateLimited: {
      type: Boolean,
      default: false,
      description: '是否被限流'
    },
    accessLevel: {
      type: String,
      enum: ['full', 'limited', 'readonly', 'blocked'],
      default: 'full',
      description: '访问级别'
    },
    reason: {
      type: String,
      description: '限制原因'
    },
    limitExpiresAt: {
      type: Date,
      description: '限制过期时间'
    }
  },
  
  // 会话来源与归因
  attribution: {
    source: {
      type: String,
      description: '来源渠道'
    },
    campaign: {
      type: String,
      description: '活动名称'
    },
    medium: {
      type: String,
      description: '媒介'
    },
    term: {
      type: String,
      description: '关键词'
    },
    content: {
      type: String,
      description: '内容标识'
    },
    referrerDomain: {
      type: String,
      description: '来源域名'
    },
    utmParams: {
      type: mongoose.Schema.Types.Mixed,
      description: 'UTM参数'
    }
  },
  
  // 时间信息
  createdAt: {
    type: Date,
    default: Date.now,
    description: '会话创建时间'
  },
  expiresAt: {
    type: Date,
    required: true,
    description: '会话过期时间'
  },
  terminatedAt: {
    type: Date,
    description: '会话终止时间'
  }
}, {
  timestamps: true,
  collection: 'sessions',
  versionKey: false
});

// 创建索引
sessionSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 }); // TTL索引，自动删除过期会话
sessionSchema.index({ userId: 1, status: 1 });
sessionSchema.index({ 'device.uniqueId': 1 });
sessionSchema.index({ 'security.fingerprint': 1 });
sessionSchema.index({ 'location.ip': 1 });
sessionSchema.index({ 'activity.lastActive': 1 });
sessionSchema.index({ createdAt: 1 });
sessionSchema.index({ anonymousId: 1, status: 1 });

// 地理位置索引
sessionSchema.index({ 'location.coordinates': '2dsphere' });

// 添加虚拟字段
sessionSchema.virtual('isExpired').get(function() {
  return new Date() > this.expiresAt;
});

sessionSchema.virtual('isAnonymous').get(function() {
  return !this.userId && !!this.anonymousId;
});

sessionSchema.virtual('deviceInfo').get(function() {
  const deviceInfo = [];
  if (this.device.brand) deviceInfo.push(this.device.brand);
  if (this.device.model) deviceInfo.push(this.device.model);
  if (this.device.os && this.device.os.name) {
    let os = this.device.os.name;
    if (this.device.os.version) os += ` ${this.device.os.version}`;
    deviceInfo.push(os);
  }
  return deviceInfo.join(' - ');
});

// 实例方法
// 更新会话活动
sessionSchema.methods.updateActivity = async function(activityData) {
  const now = new Date();
  
  // 更新最后活动时间
  this.activity.lastActive = now;
  
  // 增加请求计数
  this.activity.totalRequests += 1;
  
  // 更新路径信息
  if (activityData.path) {
    this.activity.path.previous = this.activity.path.current;
    this.activity.path.current = activityData.path;
    
    // 如果是页面访问，增加计数
    if (activityData.isPageView) {
      this.activity.pageViews += 1;
    }
  }
  
  // 更新事件计数
  if (activityData.isEvent) {
    this.activity.events += 1;
  }
  
  // 更新会话持续时间
  if (this.createdAt) {
    this.activity.duration = Math.round((now - this.createdAt) / 1000);
  }
  
  // 如果有IP变更，记录
  if (activityData.ip && this.location.ip && activityData.ip !== this.location.ip) {
    this.security.lastIpChange = now;
    
    // 更新IP和可能的地理位置
    this.location.ip = activityData.ip;
    if (activityData.geoLocation) {
      this.location.country = activityData.geoLocation.country;
      this.location.region = activityData.geoLocation.region;
      this.location.city = activityData.geoLocation.city;
      
      if (activityData.geoLocation.coordinates && 
          activityData.geoLocation.coordinates.length === 2) {
        this.location.coordinates.coordinates = activityData.geoLocation.coordinates;
      }
      
      this.location.lastUpdated = now;
    }
  }
  
  // 更新会话过期时间（延期）
  const sessionTimeout = 30 * 60 * 1000; // 30分钟
  this.expiresAt = new Date(now.getTime() + sessionTimeout);
  
  return await this.save();
};

// 设置会话认证
sessionSchema.methods.setAuthenticated = async function(userId, authMethod, provider = null) {
  const now = new Date();
  
  // 设置认证信息
  this.userId = userId;
  this.auth.isAuthenticated = true;
  this.auth.method = authMethod;
  this.auth.provider = provider;
  this.auth.authenticatedAt = now;
  this.auth.lastVerifiedAt = now;
  
  // 设置认证过期时间（24小时）
  const authTimeout = 24 * 60 * 60 * 1000; // 24小时
  this.auth.expiresAt = new Date(now.getTime() + authTimeout);
  
  // 更新会话过期时间
  const sessionTimeout = 30 * 60 * 1000; // 30分钟
  this.expiresAt = new Date(now.getTime() + sessionTimeout);
  
  return await this.save();
};

// 更新会话数据
sessionSchema.methods.updateData = async function(key, value) {
  if (!this.data) {
    this.data = {};
  }
  
  // 设置或更新数据
  if (value === undefined || value === null) {
    // 删除键
    delete this.data[key];
  } else {
    // 设置键值
    this.data[key] = value;
  }
  
  return await this.save();
};

// 设置会话偏好
sessionSchema.methods.setPreference = async function(key, value) {
  if (!this.preferences) {
    this.preferences = {};
  }
  
  // 为已知偏好设置值
  if (key === 'language' || key === 'theme' || key === 'timezone' ||
      key === 'notifications' || key === 'viewMode') {
    this.preferences[key] = value;
  } else {
    // 其他偏好设置为自定义设置
    if (!this.preferences.customSettings) {
      this.preferences.customSettings = {};
    }
    this.preferences.customSettings[key] = value;
  }
  
  return await this.save();
};

// 终止会话
sessionSchema.methods.terminate = async function(reason = 'user_logout') {
  this.status = 'terminated';
  this.terminatedAt = new Date();
  
  // 记录终止原因
  if (!this.data) {
    this.data = {};
  }
  this.data.terminationReason = reason;
  
  // 设置过期时间为立即过期
  this.expiresAt = new Date();
  
  return await this.save();
};

// 设置会话限制
sessionSchema.methods.restrict = async function(options = {}) {
  const { 
    accessLevel = 'limited', 
    reason = 'security_policy', 
    duration = 24 * 60 * 60 * 1000 // 默认24小时
  } = options;
  
  this.restrictions.isRestricted = true;
  this.restrictions.accessLevel = accessLevel;
  this.restrictions.reason = reason;
  
  if (duration) {
    this.restrictions.limitExpiresAt = new Date(Date.now() + duration);
  }
  
  return await this.save();
};

// 设置安全风险评分
sessionSchema.methods.setRiskScore = async function(score, factors = []) {
  if (score < 0) score = 0;
  if (score > 100) score = 100;
  
  this.security.riskScore = score;
  
  if (Array.isArray(factors) && factors.length > 0) {
    this.security.riskFactors = factors;
  }
  
  // 如果风险评分高，标记为可疑
  if (score >= 70) {
    this.security.suspicious = true;
  }
  
  return await this.save();
};

// 静态方法
// 创建新会话
sessionSchema.statics.createSession = async function(sessionData) {
  // 生成唯一会话ID
  const sessionId = crypto.randomBytes(16).toString('hex');
  
  // 设置默认过期时间（30分钟）
  const expiresAt = new Date(Date.now() + 30 * 60 * 1000);
  
  // 基本会话数据
  const session = new this({
    sessionId,
    expiresAt,
    ...sessionData
  });
  
  // 如果没有明确的匿名ID和用户ID，生成匿名ID
  if (!session.userId && !session.anonymousId) {
    session.anonymousId = 'anon-' + crypto.randomBytes(8).toString('hex');
  }
  
  // 如果指定了用户ID，则标记为已认证
  if (session.userId) {
    session.auth.isAuthenticated = true;
    session.auth.authenticatedAt = new Date();
    session.auth.lastVerifiedAt = new Date();
    session.auth.method = sessionData.auth?.method || 'token';
    session.auth.expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24小时
  }
  
  // 生成会话令牌
  if (!session.security.token) {
    session.security.token = crypto.randomBytes(32).toString('hex');
  }
  
  // 生成CSRF令牌
  if (!session.security.csrfToken) {
    session.security.csrfToken = crypto.randomBytes(16).toString('hex');
  }
  
  return await session.save();
};

// 根据ID查找活跃会话
sessionSchema.statics.findActiveById = function(sessionId) {
  return this.findOne({
    sessionId,
    status: 'active',
    expiresAt: { $gt: new Date() }
  });
};

// 查找用户的所有活跃会话
sessionSchema.statics.findByUser = function(userId, options = {}) {
  const { includeExpired = false, limit = 10, skip = 0 } = options;
  
  const query = { userId };
  
  if (!includeExpired) {
    query.status = 'active';
    query.expiresAt = { $gt: new Date() };
  }
  
  return this.find(query)
    .sort({ 'activity.lastActive': -1 })
    .skip(skip)
    .limit(limit);
};

// 查找过期但未终止的会话
sessionSchema.statics.findExpiredSessions = function() {
  const now = new Date();
  
  return this.find({
    status: 'active',
    expiresAt: { $lte: now },
    terminatedAt: { $exists: false }
  });
};

// 查找可能的可疑会话
sessionSchema.statics.findSuspiciousSessions = function() {
  return this.find({
    'security.suspicious': true,
    status: 'active'
  });
};

// 根据设备ID查找会话
sessionSchema.statics.findByDeviceId = function(deviceId) {
  return this.find({
    'device.uniqueId': deviceId,
    status: 'active'
  });
};

// 清理所有过期会话
sessionSchema.statics.cleanupExpiredSessions = async function() {
  const now = new Date();
  
  const updateResult = await this.updateMany(
    { 
      status: 'active', 
      expiresAt: { $lte: now } 
    },
    { 
      $set: { 
        status: 'expired',
        terminatedAt: now
      } 
    }
  );
  
  return {
    processed: updateResult.nModified
  };
};

// 前置钩子 - 验证数据
sessionSchema.pre('save', function(next) {
  // 如果有地理位置坐标但没有类型，设置默认类型
  if (this.location && 
      this.location.coordinates && 
      this.location.coordinates.coordinates && 
      !this.location.coordinates.type) {
    this.location.coordinates.type = 'Point';
  }
  
  next();
});

// 使用ModelFactory创建模型
const Session = ModelFactory.createModel('Session', sessionSchema);

// 添加分片支持的保存方法
const originalSave = Session.prototype.save;
Session.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.Session) {
    // 按创建月份分片
    const date = this.createdAt || new Date();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const shardKey = `${year}-${month.toString().padStart(2, '0')}`;
    
    const shardCollection = shardingService.getShardName('Session', shardKey);
    console.log(`将会话保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = Session; 