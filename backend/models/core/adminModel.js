const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const ModelFactory = require('../modelFactory');

const adminSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true,
    minlength: 4,
    maxlength: 30
  },
  password: {
    type: String,
    required: true,
    minlength: 8
  },
  name: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: function(v) {
        return /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v);
      },
      message: props => `${props.value} 不是有效的邮箱地址!`
    }
  },
  phone: {
    type: String,
    validate: {
      validator: function(v) {
        return /^1[3-9]\d{9}$/.test(v);
      },
      message: props => `${props.value} 不是有效的手机号!`
    }
  },
  // 角色和权限
  role: {
    type: String,
    enum: ['super_admin', 'content_admin', 'user_admin', 'merchant_admin', 'data_admin', 'read_only'],
    default: 'read_only'
  },
  permissions: [{
    type: String,
    enum: [
      'manage_users', 
      'manage_merchants', 
      'manage_nutritionists', 
      'manage_content', 
      'manage_orders',
      'view_analytics', 
      'manage_settings',
      'manage_admins',
      'view_logs',
      'manage_health_data'
    ]
  }],
  // 双因素认证
  two_factor_auth: {
    enabled: {
      type: Boolean,
      default: false
    },
    type: {
      type: String,
      enum: ['app', 'sms', 'email'],
      default: 'app'
    },
    secret: {
      type: String,
      default: ''
    },
    backup_codes: [{
      code: String,
      used: {
        type: Boolean,
        default: false
      }
    }]
  },
  // 账户状态
  is_active: {
    type: Boolean,
    default: true
  },
  // 安全相关
  password_reset_token: String,
  password_reset_expires: Date,
  password_changed_at: Date,
  password_history: [{
    password: String,
    changed_at: Date
  }],
  failed_login_attempts: {
    type: Number,
    default: 0
  },
  account_locked_until: Date,
  // IP访问限制（可限定特定IP范围）
  allowed_ip_addresses: [{
    type: String
  }],
  // 管理员访问分级
  data_access_level: {
    type: Number,
    enum: [1, 2, 3], // 1=可访问高敏感数据, 2=可访问中敏感数据, 3=仅可访问低敏感数据
    default: 2
  },
  // 审计跟踪
  is_super_admin: {
    type: Boolean,
    default: false
  },
  created_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin'
  },
  last_login: {
    type: Date
  },
  login_history: [{
    timestamp: Date,
    ip_address: String,
    user_agent: String,
    success: Boolean
  }],
  // 授权的操作范围
  authorized_operations: {
    can_approve_merchants: {
      type: Boolean,
      default: false
    },
    can_approve_nutritionists: {
      type: Boolean,
      default: false
    },
    can_manage_payments: {
      type: Boolean,
      default: false
    },
    can_delete_user_data: {
      type: Boolean,
      default: false
    }
  },
  // 时间戳
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引
adminSchema.index({ username: 1 }, { unique: true });
adminSchema.index({ email: 1 }, { unique: true });
adminSchema.index({ role: 1 });
adminSchema.index({ is_active: 1 });
adminSchema.index({ data_access_level: 1 });
adminSchema.index({ is_super_admin: 1 });
adminSchema.index({ last_login: -1 });
adminSchema.index({ created_at: -1 });

// 保存前加密密码
adminSchema.pre('save', async function(next) {
  const admin = this;
  
  // 更新时间戳
  admin.updated_at = Date.now();
  
  // 仅在密码被修改时才加密
  if (!admin.isModified('password')) return next();
  
  try {
    // 生成salt并加密
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(admin.password, salt);
    
    // 保存密码历史
    if (!admin.password_history) {
      admin.password_history = [];
    }
    
    admin.password_history.push({
      password: hashedPassword,
      changed_at: Date.now()
    });
    
    // 只保留最近5次密码记录
    if (admin.password_history.length > 5) {
      admin.password_history = admin.password_history.slice(-5);
    }
    
    // 替换明文密码为加密后的hash
    admin.password = hashedPassword;
    admin.password_changed_at = Date.now();
    
    // 根据角色自动分配权限
    if (admin.isModified('role')) {
      switch (admin.role) {
        case 'super_admin':
          admin.permissions = [
            'manage_users', 'manage_merchants', 'manage_nutritionists', 
            'manage_content', 'manage_orders', 'view_analytics', 
            'manage_settings', 'manage_admins', 'view_logs', 'manage_health_data'
          ];
          break;
        case 'content_admin':
          admin.permissions = ['manage_content', 'view_analytics'];
          break;
        case 'user_admin':
          admin.permissions = ['manage_users', 'manage_nutritionists', 'view_logs'];
          break;
        case 'merchant_admin':
          admin.permissions = ['manage_merchants', 'manage_orders', 'view_analytics'];
          break;
        case 'data_admin':
          admin.permissions = ['view_analytics', 'view_logs', 'manage_health_data'];
          break;
        case 'read_only':
          admin.permissions = ['view_analytics'];
          break;
      }
    }
    
    next();
  } catch (error) {
    return next(error);
  }
});

// 比较密码的实例方法
adminSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// 检查密码是否在历史中
adminSchema.methods.isPasswordInHistory = async function(newPassword) {
  if (!this.password_history || this.password_history.length === 0) {
    return false;
  }
  
  for (const historyItem of this.password_history) {
    if (await bcrypt.compare(newPassword, historyItem.password)) {
      return true;
    }
  }
  
  return false;
};

// 生成密码重置令牌
adminSchema.methods.createPasswordResetToken = function() {
  const resetToken = crypto.randomBytes(32).toString('hex');
  
  this.password_reset_token = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');
    
  // 令牌1小时内有效
  this.password_reset_expires = Date.now() + 3600000;
  
  return resetToken;
};

// 记录登录
adminSchema.methods.recordLogin = function(success, ipAddress, userAgent) {
  const loginRecord = {
    timestamp: Date.now(),
    ip_address: ipAddress,
    user_agent: userAgent,
    success: success
  };
  
  if (!this.login_history) {
    this.login_history = [];
  }
  
  this.login_history.push(loginRecord);
  
  // 只保留最近20次登录记录
  if (this.login_history.length > 20) {
    this.login_history = this.login_history.slice(-20);
  }
  
  if (success) {
    this.last_login = Date.now();
    this.failed_login_attempts = 0;
  } else {
    this.failed_login_attempts = (this.failed_login_attempts || 0) + 1;
    
    // 如果失败次数超过5次，锁定账户1小时
    if (this.failed_login_attempts >= 5) {
      this.account_locked_until = Date.now() + 3600000; // 1小时
    }
  }
  
  return this.save();
};

// 检查IP地址是否允许访问
adminSchema.methods.isIpAllowed = function(ipAddress) {
  // 如果没有设置IP限制，则允许所有IP
  if (!this.allowed_ip_addresses || this.allowed_ip_addresses.length === 0) {
    return true;
  }
  
  return this.allowed_ip_addresses.includes(ipAddress);
};

// 使用ModelFactory创建支持读写分离的模型
const Admin = ModelFactory.createModel('Admin', adminSchema);

// 添加缓存支持的方法
Admin.findByUsernameWithCache = async function(username) {
  if (global.cacheService) {
    const cacheKey = `admin:username:${username}`;
    const cachedAdmin = await global.cacheService.get(cacheKey);
    
    if (cachedAdmin) {
      return cachedAdmin;
    }
    
    const admin = await this.findOne({ username });
    
    if (admin) {
      // 不缓存密码和敏感信息
      const adminToCache = admin.toObject();
      delete adminToCache.password;
      delete adminToCache.password_history;
      delete adminToCache.password_reset_token;
      delete adminToCache.two_factor_auth.secret;
      delete adminToCache.two_factor_auth.backup_codes;
      
      // 设置缓存，5分钟过期
      await global.cacheService.set(cacheKey, adminToCache, 300);
    }
    
    return admin;
  }
  
  return this.findOne({ username });
};

// 清除管理员缓存
Admin.clearCache = async function(admin) {
  if (global.cacheService) {
    if (admin.username) {
      await global.cacheService.del(`admin:username:${admin.username}`);
    }
    if (admin._id) {
      await global.cacheService.del(`admin:id:${admin._id}`);
    }
    if (admin.email) {
      await global.cacheService.del(`admin:email:${admin.email}`);
    }
  }
};

// 缓存相关的保存方法重写
const originalSave = Admin.prototype.save;
Admin.prototype.save = async function(options) {
  const result = await originalSave.call(this, options);
  
  // 保存后清除缓存
  await Admin.clearCache(this);
  
  return result;
};

module.exports = Admin; 