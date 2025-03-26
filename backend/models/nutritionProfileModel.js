const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

// 定义营养档案模型的结构
const nutritionProfileSchema = new mongoose.Schema({
  // 基本关联
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  // 档案名称
  name: {
    type: String,
    required: true,
    trim: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 基本信息
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
    sensitivity_level: 2 // 中度敏感数据
  },
  age: {
    type: Number,
    min: 0,
    max: 120,
    sensitivity_level: 2 // 中度敏感数据
  },
  height: {
    type: Number, // 单位：厘米
    min: 50,
    max: 250,
    sensitivity_level: 2 // 中度敏感数据
  },
  weight: {
    type: Number, // 单位：公斤
    min: 0,
    max: 300,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 活动水平
  activity_level: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 健康状况
  health_conditions: [{
    type: String,
    sensitivity_level: 1 // 高度敏感数据
  }],
  // 饮食偏好
  dietary_preferences: {
    cuisine_preference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other',
      sensitivity_level: 3 // 低度敏感数据
    },
    allergies: [{
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    }],
    avoided_ingredients: [{
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }],
    spicy_preference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium',
      sensitivity_level: 3 // 低度敏感数据
    },
    diet_type: {
      type: String,
      enum: ['omnivore', 'vegetarian', 'vegan', 'pescatarian', 'paleo', 'keto', 'gluten_free', 'dairy_free', 'other'],
      default: 'omnivore',
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 营养目标
  goals: {
    type: String,
    enum: ['weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement', 'other'],
    default: 'health_improvement',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 目标热量和宏量素
  nutrition_targets: {
    calories: {
      type: Number,
      min: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    protein_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    },
    carbs_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    },
    fat_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 备注
  notes: {
    type: String,
    default: '',
    sensitivity_level: 2 // 中度敏感数据
  },
  // 是否为家庭成员档案
  is_family_member: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 家庭成员关系（如果适用）
  family_relationship: {
    type: String,
    default: '',
    sensitivity_level: 2 // 中度敏感数据
  },
  // 档案隐私设置
  privacy_settings: {
    // 是否共享给营养师
    share_with_nutritionist: {
      type: Boolean,
      default: false
    },
    // 是否用于AI推荐
    use_for_ai_recommendation: {
      type: Boolean,
      default: true
    },
    // 是否在餐厅/商家下单时使用
    use_for_merchants: {
      type: Boolean,
      default: false
    }
  },
  // 授权记录
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['Nutritionist', 'Merchant']
    },
    granted_at: {
      type: Date,
      default: Date.now
    },
    valid_until: {
      type: Date
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
  // 关联的健康数据
  related_health_data: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'HealthData'
  }],
  // 关联的AI推荐历史
  recommendation_history: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation'
  }],
  // 档案版本和审计
  version: {
    type: Number,
    default: 1
  },
  modification_history: [{
    modified_at: {
      type: Date,
      default: Date.now
    },
    modified_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    modified_by_type: {
      type: String,
      enum: ['user', 'nutritionist', 'admin'],
      default: 'user'
    },
    change_description: String,
    changed_fields: [String]
  }],
  // 营养师注释
  nutritionist_notes: [{
    nutritionist_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    note: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    created_at: {
      type: Date,
      default: Date.now
    },
    updated_at: {
      type: Date,
      default: Date.now
    }
  }],
  // 健康指标
  health_metrics: {
    bmi: {
      type: Number,
      min: 0,
      max: 50,
      sensitivity_level: 2 // 中度敏感数据
    },
    blood_pressure: {
      systolic: {
        type: Number,
        min: 0,
        max: 300,
        sensitivity_level: 2 // 中度敏感数据
      },
      diastolic: {
        type: Number,
        min: 0,
        max: 200,
        sensitivity_level: 2 // 中度敏感数据
      },
      measured_at: {
        type: Date
      }
    },
    blood_glucose: {
      value: {
        type: Number,
        min: 0,
        max: 500,
        sensitivity_level: 1 // 高度敏感数据
      },
      measured_at: {
        type: Date
      }
    }
  },
  // 是否为主档案
  is_primary: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 创建和更新时间
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

// 创建索引
nutritionProfileSchema.index({ user_id: 1 });
nutritionProfileSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
nutritionProfileSchema.index({ is_family_member: 1 });
nutritionProfileSchema.index({ is_primary: 1 });
nutritionProfileSchema.index({ created_at: -1 });
nutritionProfileSchema.index({ updated_at: -1 });
nutritionProfileSchema.index({ name: 'text' });
// 复合索引
nutritionProfileSchema.index({ user_id: 1, is_primary: 1 });
nutritionProfileSchema.index({ user_id: 1, created_at: -1 });

// 更新前自动更新时间和增加修改记录
nutritionProfileSchema.pre('save', function(next) {
  // 如果是新文档或修改了内容
  if (this.isNew || this.isModified()) {
    // 更新时间
    this.updated_at = Date.now();
    
    // 如果有当前用户ID并且不是新文档，记录修改信息
    if (!this.isNew && this._current_user_id) {
      const changedFields = this.modifiedPaths().filter(
        path => !path.startsWith('updated_at') && !path.startsWith('modification_history')
      );
      
      if (changedFields.length > 0) {
        if (!this.modification_history) {
          this.modification_history = [];
        }
        
        this.modification_history.push({
          modified_at: new Date(),
          modified_by: this._current_user_id,
          modified_by_type: this._modified_by_type || 'user',
          change_description: this._change_reason || '常规更新',
          changed_fields: changedFields
        });
      }
    }
  }
  
  next();
});

// 应用权限控制的中间件 - 在查询前过滤数据
nutritionProfileSchema.statics.findWithPermissionCheck = async function(query = {}, options = {}, user) {
  // 如果是用户本人查询自己的数据，直接返回
  if (user && query.user_id && user._id.equals(query.user_id)) {
    return this.find(query, options);
  }
  
  // 如果是营养师或商家，检查授权
  if (user && user.role) {
    // 构建访问授权查询条件
    const accessQuery = {
      ...query,
      'access_grants': {
        $elemMatch: {
          granted_to: user._id,
          granted_to_type: user.role === 'nutritionist' ? 'Nutritionist' : 'Merchant',
          revoked: false,
          $or: [
            { valid_until: { $exists: false } },
            { valid_until: null },
            { valid_until: { $gt: new Date() } }
          ]
        }
      }
    };
    
    return this.find(accessQuery, options);
  }
  
  // 其他情况，返回空结果
  return [];
};

// 获取档案的敏感级别的方法
nutritionProfileSchema.methods.getSensitivityLevel = function() {
  // 如果档案包含健康状况或过敏信息，则为高敏感
  if ((this.health_conditions && this.health_conditions.length > 0) || 
      (this.dietary_preferences && this.dietary_preferences.allergies && this.dietary_preferences.allergies.length > 0)) {
    return 1; // 高敏感数据
  }
  
  // 否则为中敏感
  return 2; // 中敏感数据
};

// 授权特定营养师或商家访问
nutritionProfileSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, reason) {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已有授权
  const existingGrant = this.access_grants.find(
    grant => grant.granted_to.equals(granteeId) && 
             grant.granted_to_type === granteeType && 
             !grant.revoked
  );
  
  if (existingGrant) {
    // 更新现有授权
    existingGrant.valid_until = validUntil || null;
    existingGrant.reason = reason || existingGrant.reason;
    return true;
  } else {
    // 添加新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: new Date(),
      valid_until: validUntil || null,
      reason: reason || '用户授权'
    });
  }
};

// 撤销授权
nutritionProfileSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = new Date();
      found = true;
    }
  });
  
  return found;
};

// 计算BMI
nutritionProfileSchema.methods.calculateBMI = function() {
  if (!this.height || !this.weight) return null;
  
  const heightInMeters = this.height / 100;
  const bmi = this.weight / (heightInMeters * heightInMeters);
  
  // 更新BMI字段
  if (!this.health_metrics) {
    this.health_metrics = {};
  }
  
  this.health_metrics.bmi = parseFloat(bmi.toFixed(2));
  
  return this.health_metrics.bmi;
};

// 使用ModelFactory创建支持读写分离的模型
const NutritionProfile = ModelFactory.model('NutritionProfile', nutritionProfileSchema);

// 添加分片支持的保存方法
const originalSave = NutritionProfile.prototype.save;
NutritionProfile.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.NutritionProfile) {
    // 应用用户分片策略，使用user_id作为分片键
    const shardKey = this.user_id.toString();
    const shardCollection = shardingService.getShardName('NutritionProfile', shardKey);
    console.log(`将营养档案保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = NutritionProfile; 