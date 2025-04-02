const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 营业时间子模式
const operatingHoursSchema = new mongoose.Schema({
  day_of_week: {
    type: String,
    enum: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
    required: true
  },
  is_open: {
    type: Boolean,
    default: true
  },
  opening_time: {
    type: String,
    required: true
  },
  closing_time: {
    type: String,
    required: true
  },
  break_start: String,
  break_end: String
});

const merchantSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // 基本信息
  business_name: {
    type: String,
    required: true,
    trim: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  business_type: {
    type: String,
    enum: ['restaurant', 'gym', 'maternity_center', 'school_company'],
    required: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  registration_number: {
    type: String,
    required: true,
    sensitivity_level: 1 // 高度敏感数据
  },
  tax_id: {
    type: String,
    required: true,
    sensitivity_level: 1 // 高度敏感数据
  },
  // 联系信息
  contact: {
    email: {
      type: String,
      required: true,
      sensitivity_level: 2 // 中度敏感数据
    },
    phone: {
      type: String,
      required: true,
      sensitivity_level: 2 // 中度敏感数据
    },
    alternative_phone: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    website: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 地址信息
  address: {
    line1: {
      type: String,
      required: true,
      sensitivity_level: 2 // 中度敏感数据
    },
    line2: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    city: {
      type: String,
      required: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    state: {
      type: String,
      required: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    postal_code: {
      type: String,
      required: true,
      sensitivity_level: 2 // 中度敏感数据
    },
    country: {
      type: String,
      default: 'China',
      sensitivity_level: 3 // 低度敏感数据
    },
    coordinates: {
      latitude: {
        type: Number,
        sensitivity_level: 2 // 中度敏感数据
      },
      longitude: {
        type: Number,
        sensitivity_level: 2 // 中度敏感数据
      }
    }
  },
  // 营业信息
  business_profile: {
    description: {
      type: String,
      required: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    establishment_year: {
      type: Number,
      sensitivity_level: 3 // 低度敏感数据
    },
    operating_hours: [operatingHoursSchema],
    cuisine_types: [{
      type: String,
      enum: ['chinese', 'sichuan', 'cantonese', 'hunan', 'western', 'fast_food', 'vegetarian', 'fusion', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }],
    average_price_range: {
      min: {
        type: Number,
        sensitivity_level: 3 // 低度敏感数据
      },
      max: {
        type: Number,
        sensitivity_level: 3 // 低度敏感数据
      }
    },
    facilities: [{
      type: String,
      enum: ['parking', 'wifi', 'outdoor_seating', 'air_conditioning', 'wheelchair_accessible', 'private_rooms', 'takeout', 'delivery', 'catering', 'reservations'],
      sensitivity_level: 3 // 低度敏感数据
    }],
    images: [{
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }],
    logo_url: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 营养与健康特色
  nutrition_features: {
    has_nutritionist: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    nutrition_certified: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    certification_details: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    nutritionist_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Nutritionist',
      sensitivity_level: 2 // 中度敏感数据
    },
    specialty_diets: [{
      type: String,
      enum: ['weight_loss', 'diabetes_friendly', 'heart_healthy', 'high_protein', 'low_sodium', 'gluten_free', 'pregnancy_nutrition', 'senior_nutrition', 'child_nutrition', 'athlete_nutrition', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }]
  },
  // 商家特定设置
  merchant_settings: {
    // 餐厅特定设置
    restaurant_settings: {
      allows_reservations: {
        type: Boolean,
        default: true
      },
      min_order_amount: {
        type: Number,
        default: 0
      },
      delivery_radius: {
        type: Number // 公里
      },
      delivery_fee: {
        type: Number,
        default: 0
      },
      estimated_delivery_time: {
        type: Number // 分钟
      },
      seating_capacity: Number
    },
    // 健身房特定设置
    gym_settings: {
      offers_meal_plans: {
        type: Boolean,
        default: false
      },
      has_nutrition_coaching: {
        type: Boolean,
        default: false
      },
      nutrition_coaching_fee: Number,
      membership_required: {
        type: Boolean,
        default: false
      }
    },
    // 月子中心特定设置
    maternity_center_settings: {
      offers_custom_meal_plans: {
        type: Boolean,
        default: true
      },
      offers_nutrition_education: {
        type: Boolean,
        default: true
      },
      has_medical_supervision: {
        type: Boolean,
        default: true
      },
      medical_staff_available: {
        type: Boolean,
        default: true
      }
    },
    // 学校/企业食堂特定设置
    school_company_settings: {
      organization_type: {
        type: String,
        enum: ['school', 'university', 'company', 'government', 'other']
      },
      serves_breakfast: {
        type: Boolean,
        default: false
      },
      serves_lunch: {
        type: Boolean,
        default: true
      },
      serves_dinner: {
        type: Boolean,
        default: false
      },
      subscription_available: {
        type: Boolean,
        default: false
      },
      subscription_details: String
    }
  },
  // 菜单管理
  menu_settings: {
    uses_ai_recommendations: {
      type: Boolean,
      default: true
    },
    personalization_level: {
      type: String,
      enum: ['none', 'basic', 'advanced', 'full'],
      default: 'basic'
    },
    allows_substitutions: {
      type: Boolean,
      default: true
    },
    auto_generates_nutrition_info: {
      type: Boolean,
      default: true
    },
    rotation_frequency: {
      type: String,
      enum: ['daily', 'weekly', 'monthly', 'seasonal', 'none'],
      default: 'none'
    }
  },
  // 认证与状态
  verification: {
    is_verified: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    verification_status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
      sensitivity_level: 3 // 低度敏感数据
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
    verification_notes: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    rejection_reason: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    verification_documents: [{
      document_type: {
        type: String,
        enum: ['business_license', 'food_permit', 'tax_certificate', 'health_certificate', 'identity_proof', 'other'],
        sensitivity_level: 2 // 中度敏感数据
      },
      document_url: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      uploaded_at: {
        type: Date,
        default: Date.now,
        sensitivity_level: 3 // 低度敏感数据
      },
      status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        default: 'pending',
        sensitivity_level: 3 // 低度敏感数据
      }
    }]
  },
  // 账户状态
  account_status: {
    is_active: {
      type: Boolean,
      default: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    suspension_reason: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    suspended_at: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    suspended_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      sensitivity_level: 3 // 低度敏感数据
    },
    suspension_end_date: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 支付与结算设置
  payment_settings: {
    accepted_payment_methods: [{
      type: String,
      enum: ['cash', 'credit_card', 'debit_card', 'wechat_pay', 'alipay', 'bank_transfer', 'subscription', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }],
    bank_account_info: {
      bank_name: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      account_number: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      account_name: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      }
    },
    settlement_cycle: {
      type: String,
      enum: ['daily', 'weekly', 'biweekly', 'monthly'],
      default: 'weekly',
      sensitivity_level: 3 // 低度敏感数据
    },
    commission_rate: {
      type: Number,
      default: 0.05,
      sensitivity_level: 2 // 中度敏感数据
    }
  },
  // 订单与统计
  stats: {
    total_orders: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    total_sales: {
      type: Number,
      default: 0,
      sensitivity_level: 2 // 中度敏感数据
    },
    avg_order_value: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    avg_rating: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    rating_count: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    health_score: {
      type: Number,
      min: 0,
      max: 100,
      default: 80,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 数据共享与访问权限
  data_sharing: {
    share_health_data_with_users: {
      type: Boolean,
      default: false
    },
    share_menu_items_with_public: {
      type: Boolean,
      default: true
    },
    share_menu_nutrition_data: {
      type: Boolean,
      default: true
    },
    allow_nutritionist_reviews: {
      type: Boolean,
      default: true
    }
  },
  // 外部服务集成
  external_services: [{
    service_name: {
      type: String,
      enum: ['delivery_service', 'reservation_system', 'pos_system', 'inventory_management', 'customer_loyalty', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    },
    service_provider: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    integration_details: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    is_active: {
      type: Boolean,
      default: true,
      sensitivity_level: 3 // 低度敏感数据
    }
  }],
  // 授权记录 - 记录哪些用户或营养师可以访问商家数据
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Admin']
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
      enum: ['view_menu', 'view_business_info', 'view_orders', 'manage_menu', 'manage_business', 'full_access'],
      default: 'view_menu'
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: {
      type: Date
    }
  }],
  // 安全与审计
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
      enum: ['User', 'Nutritionist', 'Admin', 'System']
    },
    ip_address: String,
    action: {
      type: String,
      enum: ['view_profile', 'view_menu', 'place_order', 'update_menu', 'update_profile', 'view_orders', 'other']
    },
    resource_id: mongoose.Schema.Types.ObjectId,
    details: String
  }],
  // 合规与隐私确认
  compliance: {
    terms_agreed: {
      type: Boolean,
      default: false
    },
    privacy_policy_agreed: {
      type: Boolean,
      default: false
    },
    data_processing_agreed: {
      type: Boolean,
      default: false
    },
    agreement_date: {
      type: Date
    },
    last_policy_update_agreed: {
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
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
merchantSchema.index({ user_id: 1 }, { unique: true });
merchantSchema.index({ business_name: 1 });
merchantSchema.index({ business_type: 1 });
merchantSchema.index({ 'address.city': 1, 'address.state': 1 });
merchantSchema.index({ 'address.coordinates': '2dsphere' }, { sparse: true });
merchantSchema.index({ 'business_profile.cuisine_types': 1 });
merchantSchema.index({ 'nutrition_features.specialty_diets': 1 });
merchantSchema.index({ 'nutrition_features.has_nutritionist': 1 });
merchantSchema.index({ 'verification_status': 1 });

// 添加虚拟字段
merchantSchema.virtual('is_open').get(function() {
  const now = new Date();
  const dayOfWeek = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][now.getDay()];
  const currentTime = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
  
  const todayHours = this.business_profile.operating_hours.find(h => h.day_of_week === dayOfWeek);
  if (!todayHours || !todayHours.is_open) return false;
  
  // 检查是否在营业时间内
  if (currentTime >= todayHours.opening_time && currentTime <= todayHours.closing_time) {
    // 检查是否在休息时间
    if (todayHours.break_start && todayHours.break_end) {
      if (currentTime >= todayHours.break_start && currentTime <= todayHours.break_end) {
        return false; // 在休息时间
      }
    }
    return true; // 在营业时间内且不在休息时间
  }
  
  return false; // 不在营业时间内
});

// 与用户关联的虚拟字段
merchantSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

// 与菜品关联的虚拟字段
merchantSchema.virtual('dishes', {
  ref: 'Dish',
  localField: '_id',
  foreignField: 'merchant_id'
});

// 实例方法
merchantSchema.methods.getPublicProfile = function() {
  return {
    id: this._id,
    business_name: this.business_name,
    business_type: this.business_type,
    contact: {
      email: this.contact.email,
      phone: this.contact.phone,
      website: this.contact.website
    },
    address: {
      city: this.address.city,
      state: this.address.state,
      country: this.address.country,
      coordinates: this.address.coordinates
    },
    business_profile: {
      description: this.business_profile.description,
      establishment_year: this.business_profile.establishment_year,
      operating_hours: this.business_profile.operating_hours,
      cuisine_types: this.business_profile.cuisine_types,
      average_price_range: this.business_profile.average_price_range,
      facilities: this.business_profile.facilities,
      images: this.business_profile.images,
      logo_url: this.business_profile.logo_url
    },
    nutrition_features: {
      has_nutritionist: this.nutrition_features.has_nutritionist,
      nutrition_certified: this.nutrition_features.nutrition_certified,
      specialty_diets: this.nutrition_features.specialty_diets
    },
    is_open: this.is_open
  };
};

merchantSchema.methods.supportsSpecialDiet = function(dietType) {
  return this.nutrition_features && 
         this.nutrition_features.specialty_diets && 
         this.nutrition_features.specialty_diets.includes(dietType);
};

merchantSchema.methods.getOperatingHoursForDay = function(dayOfWeek) {
  if (!this.business_profile || !this.business_profile.operating_hours) {
    return null;
  }
  
  return this.business_profile.operating_hours.find(
    hours => hours.day_of_week === dayOfWeek.toLowerCase()
  );
};

// 静态方法
merchantSchema.statics.findByBusinessType = function(businessType) {
  return this.find({ business_type: businessType });
};

merchantSchema.statics.findBySpecialtyDiet = function(dietType) {
  return this.find({ 'nutrition_features.specialty_diets': dietType });
};

merchantSchema.statics.findNearby = function(lat, lng, radiusInKm = 5) {
  return this.find({
    'address.coordinates': {
      $near: {
        $geometry: {
          type: 'Point',
          coordinates: [lng, lat]
        },
        $maxDistance: radiusInKm * 1000 // 转换为米
      }
    }
  });
};

// 中间件
merchantSchema.pre('save', function(next) {
  // 确保坐标字段格式正确（用于地理空间查询）
  if (this.address && this.address.coordinates && 
      this.address.coordinates.latitude && this.address.coordinates.longitude) {
    // 确保坐标字段为GeoJSON格式
    this.address.coordinates = {
      type: 'Point',
      coordinates: [this.address.coordinates.longitude, this.address.coordinates.latitude]
    };
  }
  next();
});

// 获取商家档案，基于访问级别筛选敏感数据
merchantSchema.methods.getFilteredProfile = function(accessLevel = 'public') {
  const profile = this.toObject();
  
  // 公开访问 - 只返回基本信息和低敏感度数据
  if (accessLevel === 'public') {
    const publicProfile = {
      _id: profile._id,
      business_name: profile.business_name,
      business_type: profile.business_type,
      address: {
        city: profile.address.city,
        state: profile.address.state,
        country: profile.address.country,
        coordinates: profile.address.coordinates
      },
      business_profile: {
        description: profile.business_profile.description,
        establishment_year: profile.business_profile.establishment_year,
        operating_hours: profile.business_profile.operating_hours,
        cuisine_types: profile.business_profile.cuisine_types,
        average_price_range: profile.business_profile.average_price_range,
        facilities: profile.business_profile.facilities,
        images: profile.business_profile.images,
        logo_url: profile.business_profile.logo_url
      },
      nutrition_features: {
        has_nutritionist: profile.nutrition_features.has_nutritionist,
        nutrition_certified: profile.nutrition_features.nutrition_certified,
        specialty_diets: profile.nutrition_features.specialty_diets
      },
      verification: {
        is_verified: profile.verification.is_verified
      },
      account_status: {
        is_active: profile.account_status.is_active
      },
      stats: {
        avg_rating: profile.stats.avg_rating,
        rating_count: profile.stats.rating_count,
        health_score: profile.stats.health_score
      },
      data_sharing: {
        share_menu_items_with_public: profile.data_sharing.share_menu_items_with_public,
        share_menu_nutrition_data: profile.data_sharing.share_menu_nutrition_data
      },
      created_at: profile.created_at
    };
    return publicProfile;
  }
  
  // 用户订单访问 - 返回订单相关信息
  if (accessLevel === 'order') {
    const orderProfile = {
      _id: profile._id,
      business_name: profile.business_name,
      business_type: profile.business_type,
      contact: {
        phone: profile.contact.phone,
        email: profile.contact.email
      },
      address: profile.address,
      business_profile: {
        operating_hours: profile.business_profile.operating_hours,
        logo_url: profile.business_profile.logo_url
      },
      merchant_settings: this.getMerchantTypeSettings(profile),
      payment_settings: {
        accepted_payment_methods: profile.payment_settings.accepted_payment_methods
      },
      verification: {
        is_verified: profile.verification.is_verified
      },
      account_status: {
        is_active: profile.account_status.is_active
      }
    };
    return orderProfile;
  }
  
  // 营养师访问 - 返回有关营养的更详细信息
  if (accessLevel === 'nutritionist') {
    const nutritionistProfile = {
      _id: profile._id,
      business_name: profile.business_name,
      business_type: profile.business_type,
      contact: {
        phone: profile.contact.phone,
        email: profile.contact.email,
        website: profile.contact.website
      },
      address: profile.address,
      business_profile: profile.business_profile,
      nutrition_features: profile.nutrition_features,
      merchant_settings: this.getMerchantTypeSettings(profile),
      menu_settings: profile.menu_settings,
      verification: {
        is_verified: profile.verification.is_verified,
        verification_status: profile.verification.verification_status
      },
      account_status: {
        is_active: profile.account_status.is_active
      },
      stats: profile.stats,
      data_sharing: profile.data_sharing
    };
    return nutritionistProfile;
  }
  
  // 管理员访问 - 返回完整信息
  if (accessLevel === 'admin') {
    return profile;
  }
  
  // 商家自己访问 - 返回完整信息但排除一些内部审计字段
  if (accessLevel === 'merchant') {
    // 移除内部审计信息
    delete profile.access_log;
    return profile;
  }
  
  // 默认返回公开信息
  return this.getFilteredProfile('public');
};

// 辅助方法 - 根据商家类型获取特定设置
merchantSchema.methods.getMerchantTypeSettings = function(profile) {
  switch(profile.business_type) {
    case 'restaurant':
      return { restaurant_settings: profile.merchant_settings.restaurant_settings };
    case 'gym':
      return { gym_settings: profile.merchant_settings.gym_settings };
    case 'maternity_center':
      return { maternity_center_settings: profile.merchant_settings.maternity_center_settings };
    case 'school_company':
      return { school_company_settings: profile.merchant_settings.school_company_settings };
    default:
      return {};
  }
};

// 授权访问方法
merchantSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, accessLevel = 'view_menu') {
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
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel
    });
  }
};

// 撤销授权方法
merchantSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !g.revoked) {
      grant.revoked = true;
      grant.revoked_at = Date.now();
      found = true;
    }
  });
  
  return found;
};

// 检查授权级别
merchantSchema.methods.checkAccessLevel = function(userId, userType) {
  if (!this.access_grants) return null;
  
  const now = new Date();
  const grant = this.access_grants.find(g => 
    g.granted_to.equals(userId) && 
    g.granted_to_type === userType && 
    !g.revoked && 
    (!g.valid_until || g.valid_until > now)
  );
  
  return grant ? grant.access_level : null;
};

// 记录访问方法
merchantSchema.methods.logAccess = async function(userId, userType, ipAddress, action, resourceId, details) {
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 保持日志在合理大小范围内，最多保留100条记录
  if (this.access_log.length >= 100) {
    this.access_log = this.access_log.slice(-99);
  }
  
  // 添加新的访问记录
  this.access_log.push({
    timestamp: Date.now(),
    accessed_by: userId,
    accessed_by_type: userType,
    ip_address: ipAddress,
    action: action,
    resource_id: resourceId,
    details: details
  });
  
  await this.save();
};

// 安全查询方法 - 考虑访问控制和数据敏感级别
merchantSchema.statics.findWithPermissionCheck = async function(query = {}, options = {}, user) {
  // 基础查询 - 只返回验证通过且活跃的商家
  const baseQuery = {
    ...query,
    'verification.is_verified': true,
    'account_status.is_active': true
  };
  
  // 公开访问(无用户)或普通用户 - 只返回基本公开数据
  if (!user || user.role === 'user') {
    return this.find(baseQuery, options).exec();
  }
  
  // 商家查询自己的数据
  if (user.role === 'merchant' && query.user_id && user._id.equals(query.user_id)) {
    return this.find(query, options).exec();
  }
  
  // 营养师查询 - 根据授权或公开设置
  if (user.role === 'nutritionist') {
    const merchants = await this.find(baseQuery, options).exec();
    
    // 过滤掉未授权访问的商家
    return merchants.filter(merchant => {
      // 检查是否有明确授权
      const hasDirectAccess = merchant.checkAccessLevel(user._id, 'Nutritionist');
      
      // 检查是否允许营养师审核
      const allowsNutritionistReview = merchant.data_sharing && merchant.data_sharing.allow_nutritionist_reviews;
      
      return hasDirectAccess || allowsNutritionistReview;
    });
  }
  
  // 管理员访问 - 可以查看所有商家，包括未验证或非活跃的
  if (user.role === 'admin' || user.role === 'super_admin') {
    return this.find(query, options).exec();
  }
  
  // 默认返回空结果
  return [];
};

const Merchant = ModelFactory.model('Merchant', merchantSchema);

module.exports = Merchant; 