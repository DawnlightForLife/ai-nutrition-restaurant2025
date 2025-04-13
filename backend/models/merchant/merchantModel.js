const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 营业时间子模式
const operatingHoursSchema = new mongoose.Schema({
  dayOfWeek: {
    type: String,
    enum: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
    required: true
  },
  isOpen: {
    type: Boolean,
    default: true
  },
  openingTime: {
    type: String,
    required: true
  },
  closingTime: {
    type: String,
    required: true
  },
  breakStart: String,
  breakEnd: String
});

const merchantSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // 基本信息
  businessName: {
    type: String,
    required: true,
    trim: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  businessType: {
    type: String,
    enum: ['restaurant', 'gym', 'maternity_center', 'school_company'],
    required: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  registrationNumber: {
    type: String,
    required: true,
    sensitivity_level: 1 // 高度敏感数据
  },
  taxId: {
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
    alternativePhone: {
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
    postalCode: {
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
  businessProfile: {
    description: {
      type: String,
      required: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    establishmentYear: {
      type: Number,
      sensitivity_level: 3 // 低度敏感数据
    },
    operatingHours: [operatingHoursSchema],
    cuisineTypes: [{
      type: String,
      enum: ['chinese', 'sichuan', 'cantonese', 'hunan', 'western', 'fast_food', 'vegetarian', 'fusion', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }],
    averagePriceRange: {
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
    logoUrl: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 营养与健康特色
  nutritionFeatures: {
    hasNutritionist: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    nutritionCertified: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    certificationDetails: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    nutritionistId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Nutritionist',
      sensitivity_level: 2 // 中度敏感数据
    },
    specialtyDiets: [{
      type: String,
      enum: ['weight_loss', 'diabetes_friendly', 'heart_healthy', 'high_protein', 'low_sodium', 'gluten_free', 'pregnancy_nutrition', 'senior_nutrition', 'child_nutrition', 'athlete_nutrition', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }]
  },
  // 商家特定设置
  merchantSettings: {
    // 餐厅特定设置
    restaurantSettings: {
      allowsReservations: {
        type: Boolean,
        default: true
      },
      minOrderAmount: {
        type: Number,
        default: 0
      },
      deliveryRadius: {
        type: Number // 公里
      },
      deliveryFee: {
        type: Number,
        default: 0
      },
      estimatedDeliveryTime: {
        type: Number // 分钟
      },
      seatingCapacity: Number
    },
    // 健身房特定设置
    gymSettings: {
      offersMealPlans: {
        type: Boolean,
        default: false
      },
      hasNutritionCoaching: {
        type: Boolean,
        default: false
      },
      nutritionCoachingFee: Number,
      membershipRequired: {
        type: Boolean,
        default: false
      }
    },
    // 月子中心特定设置
    maternityCenterSettings: {
      offersCustomMealPlans: {
        type: Boolean,
        default: true
      },
      offersNutritionEducation: {
        type: Boolean,
        default: true
      },
      hasMedicalSupervision: {
        type: Boolean,
        default: true
      },
      medicalStaffAvailable: {
        type: Boolean,
        default: true
      }
    },
    // 学校/企业食堂特定设置
    schoolCompanySettings: {
      organizationType: {
        type: String,
        enum: ['school', 'university', 'company', 'government', 'other']
      },
      servesBreakfast: {
        type: Boolean,
        default: false
      },
      servesLunch: {
        type: Boolean,
        default: true
      },
      servesDinner: {
        type: Boolean,
        default: false
      },
      subscriptionAvailable: {
        type: Boolean,
        default: false
      },
      subscriptionDetails: String
    }
  },
  // 菜单管理
  menuSettings: {
    usesAiRecommendations: {
      type: Boolean,
      default: true
    },
    personalizationLevel: {
      type: String,
      enum: ['none', 'basic', 'advanced', 'full'],
      default: 'basic'
    },
    allowsSubstitutions: {
      type: Boolean,
      default: true
    },
    autoGeneratesNutritionInfo: {
      type: Boolean,
      default: true
    },
    rotationFrequency: {
      type: String,
      enum: ['daily', 'weekly', 'monthly', 'seasonal', 'none'],
      default: 'none'
    }
  },
  // 认证与状态
  verification: {
    isVerified: {
      type: Boolean,
      default: false,
      sensitivity_level: 3 // 低度敏感数据
    },
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
      sensitivity_level: 3 // 低度敏感数据
    },
    verifiedAt: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      sensitivity_level: 3 // 低度敏感数据
    },
    verificationNotes: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    rejectionReason: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    verificationDocuments: [{
      documentType: {
        type: String,
        enum: ['business_license', 'food_permit', 'tax_certificate', 'health_certificate', 'identity_proof', 'other'],
        sensitivity_level: 2 // 中度敏感数据
      },
      documentUrl: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      uploadedAt: {
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
  accountStatus: {
    isActive: {
      type: Boolean,
      default: true,
      sensitivity_level: 3 // 低度敏感数据
    },
    suspensionReason: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    suspendedAt: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    },
    suspendedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      sensitivity_level: 3 // 低度敏感数据
    },
    suspensionEndDate: {
      type: Date,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 支付与结算设置
  paymentSettings: {
    acceptedPaymentMethods: [{
      type: String,
      enum: ['cash', 'credit_card', 'debit_card', 'wechat_pay', 'alipay', 'bank_transfer', 'subscription', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    }],
    bankAccountInfo: {
      bankName: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      accountNumber: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      },
      accountName: {
        type: String,
        sensitivity_level: 1 // 高度敏感数据
      }
    },
    settlementCycle: {
      type: String,
      enum: ['daily', 'weekly', 'biweekly', 'monthly'],
      default: 'weekly',
      sensitivity_level: 3 // 低度敏感数据
    },
    commissionRate: {
      type: Number,
      default: 0.05,
      sensitivity_level: 2 // 中度敏感数据
    }
  },
  // 订单与统计
  stats: {
    totalOrders: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    totalSales: {
      type: Number,
      default: 0,
      sensitivity_level: 2 // 中度敏感数据
    },
    avgOrderValue: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    avgRating: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    ratingCount: {
      type: Number,
      default: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    healthScore: {
      type: Number,
      min: 0,
      max: 100,
      default: 80,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 数据共享与访问权限
  dataSharing: {
    shareHealthDataWithUsers: {
      type: Boolean,
      default: false
    },
    shareMenuItemsWithPublic: {
      type: Boolean,
      default: true
    },
    shareMenuNutritionData: {
      type: Boolean,
      default: true
    },
    allowNutritionistReviews: {
      type: Boolean,
      default: true
    }
  },
  // 外部服务集成
  externalServices: [{
    serviceName: {
      type: String,
      enum: ['delivery_service', 'reservation_system', 'pos_system', 'inventory_management', 'customer_loyalty', 'other'],
      sensitivity_level: 3 // 低度敏感数据
    },
    serviceProvider: {
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    },
    integrationDetails: {
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    },
    isActive: {
      type: Boolean,
      default: true,
      sensitivity_level: 3 // 低度敏感数据
    }
  }],
  // 授权记录 - 记录哪些用户或营养师可以访问商家数据
  accessGrants: [{
    grantedTo: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessGrants.grantedToType'
    },
    grantedToType: {
      type: String,
      enum: ['User', 'Nutritionist', 'Admin']
    },
    grantedAt: {
      type: Date,
      default: Date.now
    },
    validUntil: {
      type: Date
    },
    accessLevel: {
      type: String,
      enum: ['view_menu', 'view_business_info', 'view_orders', 'manage_menu', 'manage_business', 'full_access'],
      default: 'view_menu'
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revokedAt: {
      type: Date
    }
  }],
  // 安全与审计
  accessLog: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    accessedBy: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessLog.accessedByType'
    },
    accessedByType: {
      type: String,
      enum: ['User', 'Nutritionist', 'Admin', 'System']
    },
    ipAddress: String,
    action: {
      type: String,
      enum: ['view_profile', 'view_menu', 'place_order', 'update_menu', 'update_profile', 'view_orders', 'other']
    },
    resourceId: mongoose.Schema.Types.ObjectId,
    details: String
  }],
  // 合规与隐私确认
  compliance: {
    termsAgreed: {
      type: Boolean,
      default: false
    },
    privacyPolicyAgreed: {
      type: Boolean,
      default: false
    },
    dataProcessingAgreed: {
      type: Boolean,
      default: false
    },
    agreementDate: {
      type: Date
    },
    lastPolicyUpdateAgreed: {
      type: Date
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
merchantSchema.index({ userId: 1 }, { unique: true });
merchantSchema.index({ businessName: 1 });
merchantSchema.index({ businessType: 1 });
merchantSchema.index({ 'address.city': 1, 'address.state': 1 });
merchantSchema.index({ 'address.coordinates': '2dsphere' }, { sparse: true });
merchantSchema.index({ 'businessProfile.cuisineTypes': 1 });
merchantSchema.index({ 'nutritionFeatures.specialtyDiets': 1 });
merchantSchema.index({ 'nutritionFeatures.hasNutritionist': 1 });
merchantSchema.index({ 'verification.verificationStatus': 1 });

// 添加虚拟字段
merchantSchema.virtual('isOpen').get(function() {
  const now = new Date();
  const dayOfWeek = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][now.getDay()];
  const currentTime = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
  
  const todayHours = this.businessProfile.operatingHours.find(h => h.dayOfWeek === dayOfWeek);
  if (!todayHours || !todayHours.isOpen) return false;
  
  // 检查是否在营业时间内
  if (currentTime >= todayHours.openingTime && currentTime <= todayHours.closingTime) {
    // 检查是否在休息时间
    if (todayHours.breakStart && todayHours.breakEnd) {
      if (currentTime >= todayHours.breakStart && currentTime <= todayHours.breakEnd) {
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
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

// 与菜品关联的虚拟字段
merchantSchema.virtual('dishes', {
  ref: 'Dish',
  localField: '_id',
  foreignField: 'merchantId'
});

// 实例方法
merchantSchema.methods.getPublicProfile = function() {
  return {
    id: this._id,
    businessName: this.businessName,
    businessType: this.businessType,
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
    businessProfile: {
      description: this.businessProfile.description,
      establishmentYear: this.businessProfile.establishmentYear,
      operatingHours: this.businessProfile.operatingHours,
      cuisineTypes: this.businessProfile.cuisineTypes,
      averagePriceRange: this.businessProfile.averagePriceRange,
      facilities: this.businessProfile.facilities,
      images: this.businessProfile.images,
      logoUrl: this.businessProfile.logoUrl
    },
    nutritionFeatures: {
      hasNutritionist: this.nutritionFeatures.hasNutritionist,
      nutritionCertified: this.nutritionFeatures.nutritionCertified,
      specialtyDiets: this.nutritionFeatures.specialtyDiets
    },
    isOpen: this.isOpen
  };
};

merchantSchema.methods.supportsSpecialDiet = function(dietType) {
  return this.nutritionFeatures && 
         this.nutritionFeatures.specialtyDiets && 
         this.nutritionFeatures.specialtyDiets.includes(dietType);
};

merchantSchema.methods.getOperatingHoursForDay = function(dayOfWeek) {
  if (!this.businessProfile || !this.businessProfile.operatingHours) {
    return null;
  }
  
  return this.businessProfile.operatingHours.find(
    hours => hours.dayOfWeek === dayOfWeek.toLowerCase()
  );
};

// 静态方法
merchantSchema.statics.findByBusinessType = function(businessType) {
  return this.find({ businessType: businessType });
};

merchantSchema.statics.findBySpecialtyDiet = function(dietType) {
  return this.find({ 'nutritionFeatures.specialtyDiets': dietType });
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
      businessName: profile.businessName,
      businessType: profile.businessType,
      address: {
        city: profile.address.city,
        state: profile.address.state,
        country: profile.address.country,
        coordinates: profile.address.coordinates
      },
      businessProfile: {
        description: profile.businessProfile.description,
        establishmentYear: profile.businessProfile.establishmentYear,
        operatingHours: profile.businessProfile.operatingHours,
        cuisineTypes: profile.businessProfile.cuisineTypes,
        averagePriceRange: profile.businessProfile.averagePriceRange,
        facilities: profile.businessProfile.facilities,
        images: profile.businessProfile.images,
        logoUrl: profile.businessProfile.logoUrl
      },
      nutritionFeatures: {
        hasNutritionist: profile.nutritionFeatures.hasNutritionist,
        nutritionCertified: profile.nutritionFeatures.nutritionCertified,
        specialtyDiets: profile.nutritionFeatures.specialtyDiets
      },
      verification: {
        isVerified: profile.verification.isVerified
      },
      accountStatus: {
        isActive: profile.accountStatus.isActive
      },
      stats: {
        avgRating: profile.stats.avgRating,
        ratingCount: profile.stats.ratingCount,
        healthScore: profile.stats.healthScore
      },
      dataSharing: profile.dataSharing
    };
    
    return publicProfile;
  }
  
  // 用户级别访问 - 返回更多信息，但排除高敏感度数据
  if (accessLevel === 'user') {
    // 从profile移除敏感度为1的字段
    if (profile.registrationNumber) delete profile.registrationNumber;
    if (profile.taxId) delete profile.taxId;
    if (profile.paymentSettings && profile.paymentSettings.bankAccountInfo) {
      delete profile.paymentSettings.bankAccountInfo;
    }
    
    return profile;
  }
  
  // 商家自己访问 - 返回所有数据
  if (accessLevel === 'merchant' || accessLevel === 'admin') {
    return profile;
  }
  
  // 默认情况下返回公开信息
  return this.getFilteredProfile('public');
};

// 创建模型并导出
const Merchant = ModelFactory.createModel('Merchant', merchantSchema);
module.exports = Merchant; 