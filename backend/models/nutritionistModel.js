const mongoose = require('mongoose');

const nutritionistSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  real_name: {
    type: String,
    required: true,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 专业资质与认证
  certification: {
    certificate_type: {
      type: String,
      required: true,
      sensitivity_level: 2 // 中度敏感数据
    },
    certificate_number: {
      type: String,
      required: true,
      sensitivity_level: 1 // 高度敏感数据
    },
    certificate_image_url: {
      type: String,
      required: true,
      sensitivity_level: 1 // 高度敏感数据
    },
    issue_date: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    expiry_date: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    issuing_authority: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 专业领域
  specializations: [{
    type: String,
    enum: ['weight_management', 'sports_nutrition', 'maternal_nutrition', 'child_nutrition', 'clinical_nutrition', 'food_allergies', 'diabetes_management', 'heart_health', 'digestive_health', 'vegetarian_vegan', 'elderly_nutrition', 'other'],
    sensitivity_level: 3 // 低度敏感数据
  }],
  // 教育背景
  education: [{
    degree: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    institution: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    major: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    graduation_year: {
      type: Number,
      sensitivity_level: 3 // 低度敏感数据
    }
  }],
  // 工作经验
  experience: [{
    title: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    organization: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    start_date: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    end_date: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    description: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  }],
  // 个人简介
  bio: {
    type: String,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 发表文章或研究
  publications: [{
    title: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    publication: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    year: {
      type: Number,
      sensitivity_level: 3 // 低度敏感数据
    },
    url: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  }],
  // 咨询服务设置
  consultation_settings: {
    is_available: {
      type: Boolean,
      default: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    consultation_fee: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    available_time_slots: [{
      day_of_week: {
        type: String,
        enum: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
        sensitivity_level: 3 // 低度敏感数据
      },
      start_time: {
        type: String,
        sensitivity_level: 3 // 低度敏感数据
      },
      end_time: {
        type: String,
        sensitivity_level: 3 // 低度敏感数据
      }
    }],
    max_daily_consultations: {
      type: Number,
      default: 10,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 隐私与数据访问设置
  privacy_settings: {
    // 是否在公共页面显示完整档案
    public_profile: {
      type: Boolean,
      default: true
    },
    // 是否允许用户直接联系
    allow_direct_contact: {
      type: Boolean,
      default: true
    },
    // 默认可访问的用户数据类型
    default_user_data_access: {
      type: String,
      enum: ['basic', 'detailed', 'full'],
      default: 'basic'
    }
  },
  // 授权记录 - 记录哪些用户授权给了这个营养师
  user_authorizations: [{
    user_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    resource_type: {
      type: String,
      enum: ['health_data', 'nutrition_profile', 'order_history', 'all']
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
      enum: ['read', 'read_write'],
      default: 'read'
    },
    is_active: {
      type: Boolean,
      default: true
    }
  }],
  // 认证状态
  verification_status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending',
    sensitivity_level: 3 // 低度敏感数据
  },
  verified: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  rejection_reason: {
    type: String,
    sensitivity_level: 2 // 中度敏感数据
  },
  verified_at: {
    type: Date,
    sensitivity_level: 3 // 低度敏感数据
  },
  verified_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 评价统计
  ratings: {
    average: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    count: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 咨询数统计
  consultation_stats: {
    total_count: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    recent_month_count: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 安全与审计
  access_log: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    user_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    action: {
      type: String,
      enum: ['view_profile', 'view_health_data', 'provide_consultation', 'review_ai_recommendation']
    },
    resource_id: {
      type: mongoose.Schema.Types.ObjectId
    },
    ip_address: String
  }],
  // 数据保留策略
  data_retention: {
    consultation_records: {
      type: Number, // 保留天数
      default: 1095 // 默认3年
    },
    user_authorizations: {
      type: Number, // 保留天数
      default: 365 // 默认1年
    }
  },
  // 合规性确认
  compliance_confirmations: {
    privacy_policy_agreed: {
      type: Boolean,
      default: false
    },
    terms_of_service_agreed: {
      type: Boolean,
      default: false
    },
    confidentiality_agreement_agreed: {
      type: Boolean,
      default: false
    },
    agreement_date: {
      type: Date
    }
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

// 创建索引用于搜索营养师
nutritionistSchema.index({ 'specializations': 1 });
nutritionistSchema.index({ 'verification_status': 1 });
nutritionistSchema.index({ 'ratings.average': -1 });
nutritionistSchema.index({ 'user_id': 1 }, { unique: true });
nutritionistSchema.index({ 'user_authorizations.user_id': 1 });

// 更新前自动更新时间
nutritionistSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 记录用户数据访问
nutritionistSchema.methods.logAccess = async function(userId, action, resourceId, ipAddress) {
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 保持日志在合理大小，仅保留最近100条记录
  if (this.access_log.length >= 100) {
    this.access_log = this.access_log.slice(-99);
  }
  
  // 添加新的访问记录
  this.access_log.push({
    timestamp: Date.now(),
    user_id: userId,
    action,
    resource_id: resourceId,
    ip_address: ipAddress
  });
  
  await this.save();
};

// 检查是否有用户授权
nutritionistSchema.methods.hasUserAuthorization = function(userId, resourceType = 'health_data') {
  if (!this.user_authorizations) return false;
  
  const now = new Date();
  return this.user_authorizations.some(auth => 
    auth.user_id.equals(userId) && 
    (auth.resource_type === resourceType || auth.resource_type === 'all') &&
    auth.is_active && 
    (!auth.valid_until || auth.valid_until > now)
  );
};

// 添加用户授权记录
nutritionistSchema.methods.addUserAuthorization = function(userId, resourceType, validUntil, accessLevel = 'read') {
  if (!this.user_authorizations) {
    this.user_authorizations = [];
  }
  
  // 检查是否已存在授权
  const existingAuth = this.user_authorizations.find(
    auth => auth.user_id.equals(userId) && auth.resource_type === resourceType
  );
  
  if (existingAuth) {
    // 更新现有授权
    existingAuth.valid_until = validUntil;
    existingAuth.access_level = accessLevel;
    existingAuth.granted_at = Date.now();
    existingAuth.is_active = true;
  } else {
    // 添加新授权
    this.user_authorizations.push({
      user_id: userId,
      resource_type: resourceType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel,
      is_active: true
    });
  }
};

// 撤销用户授权
nutritionistSchema.methods.revokeUserAuthorization = function(userId, resourceType = 'all') {
  if (!this.user_authorizations) return false;
  
  let found = false;
  this.user_authorizations.forEach(auth => {
    if (auth.user_id.equals(userId) && 
        (auth.resource_type === resourceType || resourceType === 'all') && 
        auth.is_active) {
      auth.is_active = false;
      found = true;
    }
  });
  
  return found;
};

// 根据敏感级别过滤营养师信息
nutritionistSchema.methods.getFilteredProfile = function(accessLevel = 'public') {
  const profile = this.toObject();
  
  // 公开访问 - 只返回基本信息和低敏感度数据
  if (accessLevel === 'public') {
    // 移除所有标记为中高敏感的字段
    const publicProfile = {
      _id: profile._id,
      real_name: profile.real_name,
      bio: profile.bio,
      specializations: profile.specializations,
      verification_status: profile.verification_status,
      verified: profile.verified,
      ratings: profile.ratings,
      consultation_stats: {
        total_count: profile.consultation_stats.total_count
      },
      consultation_settings: {
        is_available: profile.consultation_settings.is_available,
        consultation_fee: profile.consultation_settings.consultation_fee,
        available_time_slots: profile.consultation_settings.available_time_slots
      }
    };
    return publicProfile;
  }
  
  // 授权用户访问 - 返回更多详细信息
  if (accessLevel === 'authorized') {
    // 移除高敏感信息和内部数据
    delete profile.certificate_number;
    delete profile.access_log;
    delete profile.user_authorizations;
    delete profile.data_retention;
    return profile;
  }
  
  // 管理员访问 - 返回完整信息
  if (accessLevel === 'admin') {
    return profile;
  }
  
  // 默认返回公开信息
  return this.getFilteredProfile('public');
};

// 定期清理过期授权的方法
nutritionistSchema.methods.cleanupExpiredAuthorizations = async function() {
  if (!this.user_authorizations) return;
  
  const now = new Date();
  let hasChanges = false;
  
  // 标记过期的授权
  this.user_authorizations.forEach(auth => {
    if (auth.valid_until && auth.valid_until < now && auth.is_active) {
      auth.is_active = false;
      hasChanges = true;
    }
  });
  
  // 如果有更改，保存文档
  if (hasChanges) {
    await this.save();
  }
};

const Nutritionist = mongoose.model('Nutritionist', nutritionistSchema);

module.exports = Nutritionist; 