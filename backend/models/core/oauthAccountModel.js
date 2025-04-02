const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const shardAccessService = require('../../services/shardAccessService');
const crypto = require('crypto');

/**
 * OAuth账号绑定模型 - 支持微信、支付宝等第三方账号绑定
 * @version v2.2.0
 * @author AI营养餐厅项目组
 * @description 该模型用于存储用户第三方账号绑定关系
 */

// 定义OAuth账号绑定模型的结构
const oauthAccountSchema = new mongoose.Schema({
  // 关联用户ID
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    sensitivity_level: 2  // 中度敏感数据
  },
  
  // 平台信息
  provider: {
    type: String,
    required: true,
    enum: ['wechat', 'alipay', 'apple', 'google', 'facebook', 'twitter', 'weibo', 'qq'],
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 微信相关字段
  wechat: {
    openid: {
      type: String,
      sparse: true,
      index: true,
      sensitivity_level: 1  // 高度敏感数据
    },
    unionid: {
      type: String, 
      sparse: true,
      index: true,
      sensitivity_level: 1  // 高度敏感数据
    },
    nickname: {
      type: String,
      trim: true,
      sensitivity_level: 2  // 中度敏感数据
    },
    sex: {
      type: Number,
      enum: [0, 1, 2],  // 0:未知, 1:男, 2:女
      default: 0,
      sensitivity_level: 3  // 低度敏感数据
    },
    headimgurl: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    country: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    province: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    city: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    language: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    privilege: [{
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    }]
  },
  
  // 支付宝相关字段
  alipay: {
    user_id: {
      type: String,
      sparse: true,
      index: true,
      sensitivity_level: 1  // 高度敏感数据
    },
    avatar: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    province: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    city: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    nick_name: {
      type: String,
      sensitivity_level: 2  // 中度敏感数据
    },
    gender: {
      type: String,
      enum: ['F', 'M'],  // F:女, M:男
      sensitivity_level: 3  // 低度敏感数据
    },
  },
  
  // 其他平台通用字段
  common: {
    platform_uid: {
      type: String,
      sensitivity_level: 1  // 高度敏感数据
    },
    platform_token: {
      type: String,
      sensitivity_level: 1  // 高度敏感数据
    },
    platform_email: {
      type: String,
      sensitivity_level: 2  // 中度敏感数据
    },
    platform_nickname: {
      type: String,
      sensitivity_level: 2  // 中度敏感数据
    },
    platform_avatar: {
      type: String,
      sensitivity_level: 3  // 低度敏感数据
    },
    profile_data: {
      type: mongoose.Schema.Types.Mixed,
      sensitivity_level: 2  // 中度敏感数据
    }
  },
  
  // 访问凭证
  access_token: {
    type: String,
    sensitivity_level: 1  // 高度敏感数据
  },
  refresh_token: {
    type: String,
    sensitivity_level: 1  // 高度敏感数据
  },
  
  // 过期相关
  access_token_expires_at: {
    type: Date,
    sensitivity_level: 3  // 低度敏感数据
  },
  refresh_token_expires_at: {
    type: Date,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 账号状态
  is_active: {
    type: Boolean,
    default: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  is_primary: {
    type: Boolean,
    default: false,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 时间追踪
  created_at: {
    type: Date,
    default: Date.now,
    sensitivity_level: 3  // 低度敏感数据
  },
  updated_at: {
    type: Date,
    default: Date.now,
    sensitivity_level: 3  // 低度敏感数据
  },
  last_used_at: {
    type: Date,
    default: Date.now,
    sensitivity_level: 3  // 低度敏感数据
  }
}, {
  timestamps: {
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  },
  collection: 'oauth_accounts',
  versionKey: false
});

// 索引设置
oauthAccountSchema.index({ user_id: 1, provider: 1 }, { unique: true }); // 每个用户每个平台只能绑定一次
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
oauthAccountSchema.index({ 'alipay.user_id': 1, provider: 1 }, { 
  unique: true, 
  partialFilterExpression: { 
    'alipay.user_id': { $exists: true },
    provider: 'alipay'
  } 
}); // 支付宝user_id唯一

// 静态方法：通过第三方账号查找用户
oauthAccountSchema.statics.findByPlatformId = async function(provider, fieldPath, fieldValue) {
  const query = { provider };
  query[fieldPath] = fieldValue;
  return await this.findOne(query).populate('user_id');
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
    { user_id: userId, provider },
    { 
      access_token: accessToken,
      refresh_token: refreshToken,
      access_token_expires_at: accessTokenExpiresAt,
      refresh_token_expires_at: refreshTokenExpiresAt,
      last_used_at: new Date()
    },
    { new: true }
  );
};

// 静态方法：检查令牌是否有效
oauthAccountSchema.statics.isTokenValid = async function(userId, provider) {
  const account = await this.findOne({ user_id: userId, provider });
  
  if (!account) return false;
  if (!account.is_active) return false;
  
  // 检查访问令牌是否过期
  const now = new Date();
  return account.access_token_expires_at > now;
};

// 静态方法：解绑第三方账号
oauthAccountSchema.statics.unbindAccount = async function(userId, provider) {
  // 检查用户是否还有其他绑定账号
  const accountCount = await this.countDocuments({ user_id: userId });
  
  if (accountCount <= 1) {
    throw new Error('至少保留一个绑定账号，无法解绑');
  }
  
  return await this.findOneAndDelete({ user_id: userId, provider });
};

// 钩子：保存前的数据加密处理
oauthAccountSchema.pre('save', async function(next) {
  // 对敏感信息进行加密存储
  if (this.isModified('access_token') && this.access_token) {
    this.access_token = encryptSensitiveData(this.access_token);
  }
  
  if (this.isModified('refresh_token') && this.refresh_token) {
    this.refresh_token = encryptSensitiveData(this.refresh_token);
  }
  
  next();
});

// 钩子：查询后的数据解密处理
oauthAccountSchema.post('find', function(docs) {
  if (!docs) return docs;
  
  docs.forEach(doc => {
    if (doc.access_token) {
      doc.access_token = decryptSensitiveData(doc.access_token);
    }
    
    if (doc.refresh_token) {
      doc.refresh_token = decryptSensitiveData(doc.refresh_token);
    }
  });
  
  return docs;
});

oauthAccountSchema.post('findOne', function(doc) {
  if (!doc) return doc;
  
  if (doc.access_token) {
    doc.access_token = decryptSensitiveData(doc.access_token);
  }
  
  if (doc.refresh_token) {
    doc.refresh_token = decryptSensitiveData(doc.refresh_token);
  }
  
  return doc;
});

// 设置分片键（如果使用分片集群）
oauthAccountSchema.set('shardKey', {
  user_id: 1
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
    console.error('加密敏感数据失败:', error);
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
    console.error('解密敏感数据失败:', error);
    return data;
  }
}

// 使用ModelFactory创建模型
const OAuthAccount = ModelFactory.createModel('OAuthAccount', oauthAccountSchema);

// 导出模型
module.exports = OAuthAccount; 