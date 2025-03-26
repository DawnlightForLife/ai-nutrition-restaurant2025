const mongoose = require('mongoose');
const crypto = require('crypto');

// 用于加密敏感健康数据的密钥和IV
const ENCRYPTION_KEY = process.env.HEALTH_DATA_ENCRYPTION_KEY || 'default_key_please_change_in_production';
const ENCRYPTION_IV = process.env.HEALTH_DATA_ENCRYPTION_IV || 'default_iv_12345';

// 加密函数
const encrypt = (text) => {
  if (!text) return null;
  try {
    const cipher = crypto.createCipheriv('aes-256-cbc', 
      Buffer.from(ENCRYPTION_KEY), 
      Buffer.from(ENCRYPTION_IV.slice(0, 16)));
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return encrypted.toString('hex');
  } catch (err) {
    console.error('加密失败:', err);
    return null;
  }
};

// 解密函数
const decrypt = (encryptedText) => {
  if (!encryptedText) return null;
  try {
    const decipher = crypto.createDecipheriv('aes-256-cbc', 
      Buffer.from(ENCRYPTION_KEY), 
      Buffer.from(ENCRYPTION_IV.slice(0, 16)));
    let decrypted = decipher.update(Buffer.from(encryptedText, 'hex'));
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
  } catch (err) {
    console.error('解密失败:', err);
    return null;
  }
};

const healthDataSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  // 基本健康数据
  basic_metrics: {
    height: {
      type: Number,
      min: 50,
      max: 250,
      sensitivity_level: 2 // 中度敏感数据
    },
    weight: {
      type: Number,
      min: 20,
      max: 300,
      sensitivity_level: 2 // 中度敏感数据
    },
    bmi: {
      type: Number,
      min: 10,
      max: 50,
      sensitivity_level: 2 // 中度敏感数据
    },
    blood_pressure: {
      systolic: {
        type: Number,
        min: 50,
        max: 250,
        sensitivity_level: 1 // 高度敏感数据
      },
      diastolic: {
        type: Number,
        min: 30,
        max: 150,
        sensitivity_level: 1 // 高度敏感数据
      }
    },
    heart_rate: {
      type: Number,
      min: 40,
      max: 220,
      sensitivity_level: 1 // 高度敏感数据
    }
  },
  // 血液指标（加密存储）
  blood_metrics: {
    cholesterol: {
      total: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.cholesterol._total');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.cholesterol._total', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _total: { type: String, select: false }, // 加密后的实际存储字段
      hdl: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.cholesterol._hdl');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.cholesterol._hdl', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _hdl: { type: String, select: false }, // 加密后的实际存储字段
      ldl: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.cholesterol._ldl');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.cholesterol._ldl', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _ldl: { type: String, select: false }, // 加密后的实际存储字段
      triglycerides: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.cholesterol._triglycerides');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.cholesterol._triglycerides', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _triglycerides: { type: String, select: false } // 加密后的实际存储字段
    },
    glucose: {
      fasting: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.glucose._fasting');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.glucose._fasting', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _fasting: { type: String, select: false }, // 加密后的实际存储字段
      after_meal: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.glucose._after_meal');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.glucose._after_meal', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _after_meal: { type: String, select: false }, // 加密后的实际存储字段
      hba1c: {
        type: String, // 加密存储
        get: function() {
          const value = this.get('blood_metrics.glucose._hba1c');
          return value ? parseFloat(decrypt(value)) : null;
        },
        set: function(value) {
          this.set('blood_metrics.glucose._hba1c', value ? encrypt(value.toString()) : null);
          return value;
        },
        sensitivity_level: 1 // 高度敏感数据
      },
      _hba1c: { type: String, select: false } // 加密后的实际存储字段
    },
    liver: {
      alt: Number,
      ast: Number,
      alp: Number
    },
    kidney: {
      creatinine: Number,
      urea: Number
    },
    electrolytes: {
      sodium: Number,
      potassium: Number,
      calcium: Number,
      magnesium: Number
    },
    blood_count: {
      wbc: Number,
      rbc: Number,
      hemoglobin: Number,
      platelets: Number
    }
  },
  // 原始体检报告图像与OCR
  medical_report: {
    ocr_image_url: {
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    },
    ocr_processing_status: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      default: 'pending',
      sensitivity_level: 3 // 低度敏感数据
    },
    ocr_raw_text: {
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    },
    report_date: {
      type: Date,
      sensitivity_level: 2 // 中度敏感数据
    },
    hospital_name: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    // 诊断信息（加密存储）
    diagnosis: {
      type: String,
      get: function() {
        const value = this.get('medical_report._diagnosis');
        return value ? decrypt(value) : null;
      },
      set: function(value) {
        this.set('medical_report._diagnosis', value ? encrypt(value) : null);
        return value;
      },
      sensitivity_level: 1 // 高度敏感数据
    },
    _diagnosis: { type: String, select: false } // 加密后的实际存储字段
  },
  // 数据隐私等级（整体数据敏感级别）
  data_privacy_level: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private',
    sensitivity_level: 2 // 中度敏感数据
  },
  // AI分析标志
  ai_analyzed: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  ai_analysis_results: {
    type: String,
    sensitivity_level: 2 // 中度敏感数据
  },
  ai_analysis_date: {
    type: Date,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 记录来源
  data_source: {
    type: String,
    enum: ['user_input', 'ocr', 'wearable_device', 'third_party_app', 'healthcare_provider'],
    default: 'user_input',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 授权记录
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['Nutritionist', 'Merchant', 'HealthProvider']
    },
    granted_at: {
      type: Date,
      default: Date.now
    },
    valid_until: {
      type: Date
    },
    access_level: {
      type: String,
      enum: ['full', 'basic', 'summary'],
      default: 'basic'
    },
    reason: {
      type: String
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: {
      type: Date
    }
  }],
  // 备注
  notes: {
    type: String,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 数据版本控制
  version: {
    type: Number,
    default: 1
  },
  revision_history: [{
    version: Number,
    modified_at: Date,
    modified_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'revision_history.modified_by_type'
    },
    modified_by_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Admin', 'System']
    },
    changes: [String]
  }],
  // 安全和审计
  last_accessed: {
    timestamp: Date,
    accessed_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'last_accessed.accessed_by_type'
    },
    accessed_by_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System']
    }
  },
  access_log: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    accessed_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_log.accessed_by_type'
    },
    accessed_by_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System']
    },
    ip_address: String,
    access_type: {
      type: String,
      enum: ['read', 'write', 'export', 'share']
    }
  }],
  // 数据生命周期管理
  retention_period: {
    type: Number, // 保留天数
    default: 3650 // 默认10年
  },
  scheduled_deletion_date: {
    type: Date
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

// 创建索引用于快速查找用户数据
healthDataSchema.index({ user_id: 1, created_at: -1 });
healthDataSchema.index({ nutrition_profile_id: 1, created_at: -1 });
healthDataSchema.index({ data_privacy_level: 1 });
healthDataSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
healthDataSchema.index({ data_source: 1 });
// 添加TTL索引，使过期的健康数据自动清理
healthDataSchema.index({ scheduled_deletion_date: 1 }, { expireAfterSeconds: 0 });
// 添加部分索引，优化查询性能
healthDataSchema.index(
  { user_id: 1, data_privacy_level: 1 },
  { partialFilterExpression: { data_privacy_level: { $ne: 'private' } } }
);
// 为时间序列健康数据优化查询
healthDataSchema.index({ user_id: 1, 'measurements.date': -1 });
// 添加复合索引，优化常见查询场景
healthDataSchema.index({ user_id: 1, data_source: 1, created_at: -1 });

// 更新前自动更新时间和修订历史
healthDataSchema.pre('save', function(next) {
  const now = Date.now();
  this.updated_at = now;
  
  // 如果是修改操作(非新文档)
  if (!this.isNew) {
    // 增加版本号
    this.version = (this.version || 0) + 1;
    
    // 记录修订历史
    const changedFields = this.modifiedPaths().filter(
      path => !path.startsWith('updated_at') && !path.startsWith('version') && 
              !path.startsWith('last_accessed') && !path.startsWith('access_log')
    );
    
    if (changedFields.length > 0) {
      if (!this.revision_history) {
        this.revision_history = [];
      }
      
      this.revision_history.push({
        version: this.version,
        modified_at: now,
        modified_by: this._current_user_id || this.user_id,
        modified_by_type: this._current_user_type || 'User',
        changes: changedFields
      });
    }
  }
  
  // 如果设置了保留期限，计算自动删除日期
  if (this.retention_period && this.retention_period > 0) {
    const deleteDate = new Date();
    deleteDate.setDate(deleteDate.getDate() + this.retention_period);
    this.scheduled_deletion_date = deleteDate;
  }
  
  next();
});

// 设置数据访问的中间件方法
healthDataSchema.methods.logAccess = async function(userId, userType, ipAddress, accessType = 'read') {
  const now = Date.now();
  
  // 更新最后访问记录
  this.last_accessed = {
    timestamp: now,
    accessed_by: userId,
    accessed_by_type: userType
  };
  
  // 添加到访问日志
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 只保留最近的20条记录
  if (this.access_log.length >= 20) {
    this.access_log = this.access_log.slice(-19);
  }
  
  this.access_log.push({
    timestamp: now,
    accessed_by: userId,
    accessed_by_type: userType,
    ip_address: ipAddress,
    access_type: accessType
  });
  
  await this.save();
};

// 安全获取数据的静态方法
healthDataSchema.statics.secureFind = async function(query, options, user, ipAddress) {
  if (!user) return [];
  
  // 构建基本查询
  let secureQuery = { ...query };
  
  // 用户查询自己的数据
  if (user._id && user._id.equals(query.user_id)) {
    // 用户可以查看自己的所有数据
  } 
  // 营养师查询用户数据
  else if (user.role === 'nutritionist') {
    // 添加营养师的访问条件
    secureQuery = {
      ...secureQuery,
      $or: [
        // 用户显式授权给此营养师
        { 'access_grants.granted_to': user._id, 'access_grants.granted_to_type': 'Nutritionist', 'access_grants.revoked': false },
        // 用户设置为共享给营养师的数据
        { data_privacy_level: 'share_with_nutritionist' }
      ]
    };
  }
  // 其他用户无权访问
  else if (!['admin', 'super_admin'].includes(user.role)) {
    return [];
  }
  
  // 执行查询
  const results = await this.find(secureQuery, options).exec();
  
  // 记录访问日志
  for (const record of results) {
    await record.logAccess(user._id, user.role, ipAddress, 'read');
  }
  
  return results;
};

// 授权访问方法
healthDataSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, accessLevel = 'basic', reason) {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已存在授权
  const existingGrant = this.access_grants.find(
    g => g.granted_to.equals(granteeId) && g.granted_to_type === granteeType && !g.revoked
  );
  
  if (existingGrant) {
    // 更新现有授权
    existingGrant.valid_until = validUntil;
    existingGrant.access_level = accessLevel;
    existingGrant.reason = reason || existingGrant.reason;
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel,
      reason: reason
    });
  }
};

// 撤销授权方法
healthDataSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = Date.now();
      found = true;
    }
  });
  
  return found;
};

// 根据访问者角色过滤敏感字段
healthDataSchema.methods.filterSensitiveData = function(userRole, accessLevel) {
  const data = this.toObject();
  
  // 管理员可以访问所有数据
  if (userRole === 'admin' || userRole === 'super_admin') {
    return data;
  }
  
  // 确定可访问的敏感级别
  let allowedLevel = 3; // 默认只能访问低敏感度数据
  
  // 营养师可以访问中度敏感数据
  if (userRole === 'nutritionist') {
    allowedLevel = 2;
    
    // 如果特别授权可以访问全部数据
    if (accessLevel === 'full') {
      allowedLevel = 1;
    }
  }
  
  // 递归函数用于过滤敏感字段
  function filterSensitiveFields(obj) {
    if (!obj || typeof obj !== 'object') return obj;
    
    const result = Array.isArray(obj) ? [] : {};
    
    for (const key in obj) {
      // 跳过内部加密字段
      if (key.startsWith('_') && key !== '_id') continue;
      
      // 检查字段是否有敏感标记
      const sensitivity = obj[key] && obj[key].sensitivity_level;
      
      // 如果没有敏感标记或者用户有权限，则包含此字段
      if (sensitivity === undefined || sensitivity >= allowedLevel) {
        if (Array.isArray(obj[key]) || (obj[key] && typeof obj[key] === 'object')) {
          result[key] = filterSensitiveFields(obj[key]);
        } else {
          result[key] = obj[key];
        }
      }
      // 如果是敏感字段但用户无权访问，则设置为null或移除
      else {
        if (Array.isArray(result)) {
          result.push(null);
        } else {
          result[key] = "[敏感数据已隐藏]";
        }
      }
    }
    
    return result;
  }
  
  return filterSensitiveFields(data);
};

const HealthData = mongoose.model('HealthData', healthDataSchema);

module.exports = HealthData; 