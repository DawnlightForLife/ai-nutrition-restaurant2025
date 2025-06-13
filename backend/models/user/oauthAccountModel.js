const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const shardAccessService = require('../../services/database/shardAccessService');
const crypto = require('crypto');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * OAuth账号绑定模型 - 支持微信、支付宝等第三方账号绑定
 * @version v2.2.0
 * @author AI营养餐厅项目组
 * @description 该模型用于存储用户第三方账号绑定关系
 */

// 定义OAuth账号绑定模型的结构
const oauthAccountSchema = new mongoose.Schema({
  // 关联用户ID
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    sensitivityLevel: 2,  // 中度敏感数据
    description: '绑定的用户 ID'
  },
  
  // 平台信息
  provider: {
    type: String,
    required: true,
    enum: ['wechat', 'alipay', 'apple', 'google', 'facebook', 'twitter', 'weibo', 'qq'],
    index: true,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '第三方平台类型（如微信、支付宝）'
  },
  
  // 微信相关字段
  wechat: {
    openid: {
      type: String,
      sparse: true,
      index: true,
      sensitivityLevel: 1,  // 高度敏感数据
      description: '微信 openid'
    },
    unionid: {
      type: String, 
      sparse: true,
      index: true,
      sensitivityLevel: 1,  // 高度敏感数据
      description: '微信 unionid'
    },
    nickname: {
      type: String,
      trim: true,
      sensitivityLevel: 2,  // 中度敏感数据
      description: '微信昵称'
    },
    sex: {
      type: Number,
      enum: [0, 1, 2],  // 0:未知, 1:男, 2:女
      default: 0,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '性别'
    },
    headimgurl: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '头像'
    },
    country: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '国家'
    },
    province: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '省份'
    },
    city: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '城市'
    },
    language: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '语言'
    },
    privilege: [{
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '用户特权信息'
    }]
  },
  
  // 支付宝相关字段
  alipay: {
    userId: {
      type: String,
      sparse: true,
      index: true,
      sensitivityLevel: 1,  // 高度敏感数据
      description: '支付宝用户 ID'
    },
    avatarUrl: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '支付宝头像'
    },
    province: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '省份'
    },
    city: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '城市'
    },
    nickname: {
      type: String,
      sensitivityLevel: 2,  // 中度敏感数据
      description: '支付宝昵称'
    },
    gender: {
      type: String,
      enum: ['F', 'M'],  // F:女, M:男
      sensitivityLevel: 3,  // 低度敏感数据
      description: '性别'
    },
  },
  
  // 其他平台通用字段
  common: {
    platformUid: {
      type: String,
      sensitivityLevel: 1,  // 高度敏感数据
      description: '第三方平台用户 ID'
    },
    platformToken: {
      type: String,
      sensitivityLevel: 1,  // 高度敏感数据
      description: '第三方平台访问令牌'
    },
    platformEmail: {
      type: String,
      sensitivityLevel: 2,  // 中度敏感数据
      description: '第三方平台邮箱'
    },
    platformNickname: {
      type: String,
      sensitivityLevel: 2,  // 中度敏感数据
      description: '第三方平台昵称'
    },
    platformAvatar: {
      type: String,
      sensitivityLevel: 3,  // 低度敏感数据
      description: '第三方平台头像'
    },
    profileData: {
      type: mongoose.Schema.Types.Mixed,
      sensitivityLevel: 2,  // 中度敏感数据
      description: '第三方平台用户资料数据'
    }
  },
  
  // 访问凭证
  accessToken: {
    type: String,
    sensitivityLevel: 1,  // 高度敏感数据
    description: '访问令牌'
  },
  refreshToken: {
    type: String,
    sensitivityLevel: 1,  // 高度敏感数据
    description: '刷新令牌'
  },
  
  // 过期相关
  accessTokenExpiresAt: {
    type: Date,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '访问令牌过期时间'
  },
  refreshTokenExpiresAt: {
    type: Date,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '刷新令牌过期时间'
  },
  
  // 账号状态
  isActive: {
    type: Boolean,
    default: true,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '是否激活'
  },
  isPrimary: {
    type: Boolean,
    default: false,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '是否为主账号'
  },
  
  // 时间追踪
  lastUsedAt: {
    type: Date,
    default: Date.now,
    sensitivityLevel: 3,  // 低度敏感数据
    description: '最近使用时间'
  }
}, {
  timestamps: true,
  collection: 'oauth_accounts',
  versionKey: false
});

// 索引设置
oauthAccountSchema.index({ userId: 1, provider: 1 }, { unique: true }); // 每个用户每个平台只能绑定一次
oauthAccountSchema.index({ 'wechat.openid': 1, provider: 1 }, { 
  unique: true, 
  partialFilterExpression: { 
    'wechat.openid': { $exists: true },
    provider: 'wechat'
  } 
}); // 微信openid唯一
oauthAccountSchema.index({ 'wechat.unionid': 1, provider: 1 }, { 
  sparse: true,
  partialFilterExpression: { 
    'wechat.unionid': { $exists: true },
    provider: 'wechat'
  }
}); // 微信unionid索引
oauthAccountSchema.index({ 'alipay.userId': 1, provider: 1 }, { 
  unique: true, 
  partialFilterExpression: { 
    'alipay.userId': { $exists: true },
    provider: 'alipay'
  } 
}); // 支付宝user_id唯一

// 静态方法：通过第三方账号查找用户
oauthAccountSchema.statics.findByPlatformId = async function(provider, fieldPath, fieldValue) {
  const query = { provider };
  query[fieldPath] = fieldValue;
  return await this.findOne(query).populate('userId');
};

// 静态方法：更新令牌信息
oauthAccountSchema.statics.updateTokens = async function(userId, provider, tokenData) {
  const { accessToken, refreshToken, accessExpiresIn, refreshExpiresIn } = tokenData;
  
  // 计算过期时间
  const accessTokenExpiresAt = new Date(Date.now() + accessExpiresIn * 1000);
  const refreshTokenExpiresAt = refreshExpiresIn 
    ? new Date(Date.now() + refreshExpiresIn * 1000) 
    : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 默认30天
  
  return await this.findOneAndUpdate(
    { userId: userId, provider },
    { 
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
      lastUsedAt: new Date()
    },
    { new: true }
  );
};

// 静态方法：检查令牌是否有效
oauthAccountSchema.statics.isTokenValid = async function(userId, provider) {
  const account = await this.findOne({ userId: userId, provider });
  
  if (!account) return false;
  if (!account.isActive) return false;
  
  // 检查访问令牌是否过期
  const now = new Date();
  return account.accessTokenExpiresAt > now;
};

// 静态方法：解绑第三方账号
oauthAccountSchema.statics.unbindAccount = async function(userId, provider) {
  // 检查用户是否还有其他绑定账号
  const accountCount = await this.countDocuments({ userId: userId });
  
  if (accountCount <= 1) {
    throw new Error('至少保留一个绑定账号，无法解绑');
  }
  
  return await this.findOneAndDelete({ userId: userId, provider });
};

// 钩子：保存前的数据加密处理
oauthAccountSchema.pre('save', async function(next) {
  // 对敏感信息进行加密存储
  if (this.isModified('accessToken') && this.accessToken) {
    this.accessToken = encryptSensitiveData(this.accessToken);
  }
  
  if (this.isModified('refreshToken') && this.refreshToken) {
    this.refreshToken = encryptSensitiveData(this.refreshToken);
  }
  
  next();
});

// 钩子：查询后的数据解密处理
oauthAccountSchema.post('find', function(docs) {
  if (!docs) return docs;
  
  docs.forEach(doc => {
    if (doc.accessToken) {
      doc.accessToken = decryptSensitiveData(doc.accessToken);
    }
    
    if (doc.refreshToken) {
      doc.refreshToken = decryptSensitiveData(doc.refreshToken);
    }
  });
  
  return docs;
});

oauthAccountSchema.post('findOne', function(doc) {
  if (!doc) return doc;
  
  if (doc.accessToken) {
    doc.accessToken = decryptSensitiveData(doc.accessToken);
  }
  
  if (doc.refreshToken) {
    doc.refreshToken = decryptSensitiveData(doc.refreshToken);
  }
  
  return doc;
});

// 设置分片键（如果使用分片集群）
oauthAccountSchema.set('shardKey', {
  userId: 1
});

// 辅助函数：加密敏感数据
function encryptSensitiveData(data) {
  try {
    const algorithm = 'aes-256-cbc';
    const key = Buffer.from(process.env.OAUTH_ENCRYPTION_KEY || 'ai-nutrition-restaurant-secret-key-32c', 'utf8');
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv(algorithm, key, iv);
    let encrypted = cipher.update(data, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return iv.toString('hex') + ':' + encrypted;
  } catch (error) {
    logger.error('加密敏感数据失败:', error);
    return data;
  }
}

// 辅助函数：解密敏感数据
function decryptSensitiveData(data) {
  try {
    const algorithm = 'aes-256-cbc';
    const key = Buffer.from(process.env.OAUTH_ENCRYPTION_KEY || 'ai-nutrition-restaurant-secret-key-32c', 'utf8');
    const parts = data.split(':');
    const iv = Buffer.from(parts[0], 'hex');
    const encryptedText = parts[1];
    const decipher = crypto.createDecipheriv(algorithm, key, iv);
    let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
  } catch (error) {
    logger.error('解密敏感数据失败:', error);
    return data;
  }
}

// 使用ModelFactory创建模型
const OAuthAccount = ModelFactory.createModel('OAuthAccount', oauthAccountSchema);

// 导出模型
module.exports = OAuthAccount; 