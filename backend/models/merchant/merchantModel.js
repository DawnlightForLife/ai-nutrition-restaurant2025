const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { merchantTypeValues } = require('./merchantTypeEnum');

// 营业时间子模式
const operatingHoursSchema = new mongoose.Schema({
  dayOfWeek: {
    type: String,
    enum: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
    required: true,
    description: '星期几'
  },
  isOpen: {
    type: Boolean,
    default: true,
    description: '该日是否营业'
  },
  openingTime: {
    type: String,
    required: true,
    description: '开始营业时间'
  },
  closingTime: {
    type: String,
    required: true,
    description: '结束营业时间'
  },
  breakStart: {
    type: String,
    description: '休息开始时间'
  },
  breakEnd: {
    type: String,
    description: '休息结束时间'
  }
});

const merchantSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '所属用户ID'
  },
  // 基本信息
  businessName: {
    type: String,
    required: true,
    trim: true,
    sensitivityLevel: 3, // 低度敏感数据
    description: '商家名称'
  },
  businessType: {
    type: String,
    enum: merchantTypeValues,
    required: true,
    sensitivityLevel: 3, // 低度敏感数据
    description: '商家类型'
  },
  registrationNumber: {
    type: String,
    required: true,
    sensitivityLevel: 1, // 高度敏感数据
    description: '营业执照编号'
  },
  taxId: {
    type: String,
    required: true,
    sensitivityLevel: 1, // 高度敏感数据
    description: '税务登记号'
  },
  // 联系信息
  contact: {
    email: {
      type: String,
      required: true,
      sensitivityLevel: 2, // 中度敏感数据
      description: '联系邮箱'
    },
    phone: {
      type: String,
      required: true,
      sensitivityLevel: 2, // 中度敏感数据
      description: '联系电话'
    },
    alternativePhone: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '备用电话'
    },
    website: {
      type: String,
      sensitivityLevel: 3, // 低度敏感数据
      description: '网站地址'
    }
  },
  // 地址信息
  address: {
    line1: {
      type: String,
      required: true,
      sensitivityLevel: 2, // 中度敏感数据
      description: '地址第一行'
    },
    line2: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '地址第二行'
    },
    city: {
      type: String,
      required: true,
      sensitivityLevel: 3, // 低度敏感数据
      description: '城市'
    },
    state: {
      type: String,
      required: true,
      sensitivityLevel: 3, // 低度敏感数据
      description: '省/州'
    },
    postalCode: {
      type: String,
      required: true,
      sensitivityLevel: 2, // 中度敏感数据
      description: '邮政编码'
    },
    country: {
      type: String,
      default: 'China',
      sensitivityLevel: 3, // 低度敏感数据
      description: '国家'
    },
    coordinates: {
      latitude: {
        type: Number,
        sensitivityLevel: 2, // 中度敏感数据
        description: '纬度'
      },
      longitude: {
        type: Number,
        sensitivityLevel: 2, // 中度敏感数据
        description: '经度'
      }
    }
  },
  // 营业信息
  businessProfile: {
    description: {
      type: String,
      required: true,
      sensitivityLevel: 3, // 低度敏感数据
      description: '商家简介'
    },
    establishmentYear: {
      type: Number,
      sensitivityLevel: 3, // 低度敏感数据
      description: '成立年份'
    },
    operatingHours: [operatingHoursSchema],
    cuisineTypes: [{
      type: String,
      enum: ['chinese', 'sichuan', 'cantonese', 'hunan', 'western', 'fastFood', 'vegetarian', 'fusion', 'other'],
      sensitivityLevel: 3, // 低度敏感数据
      description: '菜系类型'
    }],
    averagePriceRange: {
      minPrice: {
        type: Number,
        sensitivityLevel: 3, // 低度敏感数据
        description: '价格区间下限'
      },
      maxPrice: {
        type: Number,
        sensitivityLevel: 3, // 低度敏感数据
        description: '价格区间上限'
      }
    },
    facilities: [{
      type: String,
      enum: ['parking', 'wifi', 'outdoor_seating', 'air_conditioning', 'wheelchair_accessible', 'private_rooms', 'takeout', 'delivery', 'catering', 'reservations'],
      sensitivityLevel: 3, // 低度敏感数据
      description: '设施服务'
    }],
    images: [{
      type: String,
      sensitivityLevel: 3, // 低度敏感数据
      description: '商家图片'
    }],
    logoUrl: {
      type: String,
      sensitivityLevel: 3, // 低度敏感数据
      description: '商家Logo地址'
    }
  },
  // 营养与健康特色
  nutritionFeatures: {
    hasNutritionist: {
      type: Boolean,
      default: false,
      sensitivityLevel: 3, // 低度敏感数据
      description: '是否配备营养师'
    },
    nutritionCertified: {
      type: Boolean,
      default: false,
      sensitivityLevel: 3, // 低度敏感数据
      description: '是否营养认证'
    },
    certificationDetails: {
      type: String,
      sensitivityLevel: 3, // 低度敏感数据
      description: '认证详情'
    },
    nutritionistId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Nutritionist',
      sensitivityLevel: 2, // 中度敏感数据
      description: '关联营养师ID'
    },
    specialtyDiets: [{
      type: String,
      enum: [
        'weightLoss',
        'diabetesFriendly',
        'heartHealthy',
        'highProtein',
        'lowSodium',
        'glutenFree',
        'pregnancyNutrition',
        'seniorNutrition',
        'childNutrition',
        'athleteNutrition',
        'other'
      ],
      sensitivityLevel: 3, // 低度敏感数据
      description: '特殊饮食类型'
    }]
  },
  // 商家特定设置
  merchantSettings: {
    // 餐厅特定设置
    restaurantSettings: {
      allowsReservations: {
        type: Boolean,
        default: true,
        description: '是否允许预订'
      },
      minOrderAmount: {
        type: Number,
        default: 0,
        description: '最低订单金额'
      },
      deliveryRadius: {
        type: Number, // 公里
        description: '配送半径(公里)'
      },
      deliveryFee: {
        type: Number,
        default: 0,
        description: '配送费'
      },
      estimatedDeliveryTime: {
        type: Number, // 分钟
        description: '预计配送时间(分钟)'
      },
      seatingCapacity: {
        type: Number,
        description: '座位容量'
      }
    },
    // 健身房特定设置
    gymSettings: {
      offersMealPlans: {
        type: Boolean,
        default: false,
        description: '是否提供膳食计划'
      },
      hasNutritionCoaching: {
        type: Boolean,
        default: false,
        description: '是否提供营养指导'
      },
      nutritionCoachingFee: {
        type: Number,
        description: '营养指导费用'
      },
      membershipRequired: {
        type: Boolean,
        default: false,
        description: '是否需要会员资格'
      }
    },
    // 月子中心特定设置
    maternityCenterSettings: {
      offersCustomMealPlans: {
        type: Boolean,
        default: true,
        description: '是否提供定制膳食计划'
      },
      offersNutritionEducation: {
        type: Boolean,
        default: true,
        description: '是否提供营养教育'
      },
      hasMedicalSupervision: {
        type: Boolean,
        default: true,
        description: '是否有医疗监督'
      },
      medicalStaffAvailable: {
        type: Boolean,
        default: true,
        description: '是否有医务人员在场'
      }
    },
    // 学校/企业食堂特定设置
    schoolCompanySettings: {
      organizationType: {
        type: String,
        enum: ['school', 'university', 'company', 'government', 'other'],
        description: '组织类型'
      },
      servesBreakfast: {
        type: Boolean,
        default: false,
        description: '是否提供早餐'
      },
      servesLunch: {
        type: Boolean,
        default: true,
        description: '是否提供午餐'
      },
      servesDinner: {
        type: Boolean,
        default: false,
        description: '是否提供晚餐'
      },
      subscriptionAvailable: {
        type: Boolean,
        default: false,
        description: '是否提供订阅服务'
      },
      subscriptionDetails: {
        type: String,
        description: '订阅服务详情'
      }
    }
  },
  // 菜单管理
  menuSettings: {
    usesAiRecommendations: {
      type: Boolean,
      default: true,
      description: '是否使用AI推荐'
    },
    personalizationLevel: {
      type: String,
      enum: ['none', 'basic', 'advanced', 'full'],
      default: 'basic',
      description: '个性化推荐级别'
    },
    allowsSubstitutions: {
      type: Boolean,
      default: true,
      description: '是否允许替换食材'
    },
    autoGeneratesNutritionInfo: {
      type: Boolean,
      default: true,
      description: '是否自动生成营养信息'
    },
    rotationFrequency: {
      type: String,
      enum: ['daily', 'weekly', 'monthly', 'seasonal', 'none'],
      default: 'none',
      description: '菜单轮换频率'
    }
  },
  // 认证与状态
  verification: {
    isVerified: {
      type: Boolean,
      default: false,
      sensitivityLevel: 3, // 低度敏感数据
      description: '是否已验证'
    },
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
      sensitivityLevel: 3, // 低度敏感数据
      description: '验证状态'
    },
    verifiedAt: {
      type: Date,
      sensitivityLevel: 3, // 低度敏感数据
      description: '验证时间'
    },
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      sensitivityLevel: 3, // 低度敏感数据
      description: '验证人'
    },
    verificationNotes: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '验证备注'
    },
    rejectionReason: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '拒绝原因'
    },
    verificationDocuments: [{
      documentType: {
        type: String,
        enum: [
          'businessLicense',
          'foodPermit',
          'taxCertificate',
          'nutritionCertificate',
          'identityProof',
          'other'
        ],
        sensitivityLevel: 2, // 中度敏感数据
        description: '文档类型'
      },
      documentUrl: {
        type: String,
        sensitivityLevel: 1, // 高度敏感数据
        description: '文档链接'
      },
      uploadedAt: {
        type: Date,
        default: Date.now,
        sensitivityLevel: 3, // 低度敏感数据
        description: '上传时间'
      },
      status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        default: 'pending',
        sensitivityLevel: 3, // 低度敏感数据
        description: '文档状态'
      }
    }]
  },
  // 账户状态
  accountStatus: {
    isActive: {
      type: Boolean,
      default: true,
      sensitivityLevel: 3, // 低度敏感数据
      description: '账户是否激活'
    },
    suspensionReason: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '停用原因'
    },
    suspendedAt: {
      type: Date,
      sensitivityLevel: 3, // 低度敏感数据
      description: '停用时间'
    },
    suspendedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      sensitivityLevel: 3, // 低度敏感数据
      description: '停用操作人'
    },
    suspensionEndDate: {
      type: Date,
      sensitivityLevel: 3, // 低度敏感数据
      description: '停用结束日期'
    }
  },
  // 支付与结算设置
  paymentSettings: {
    acceptedPaymentMethods: [{
      type: String,
      enum: ['cash', 'creditCard', 'debitCard', 'wechatPay', 'alipay', 'bankTransfer', 'subscription', 'other'],
      sensitivityLevel: 3, // 低度敏感数据
      description: '支持的支付方式'
    }],
    bankAccountInfo: {
      bankName: {
        type: String,
        sensitivityLevel: 1, // 高度敏感数据
        description: '开户银行'
      },
      accountNumber: {
        type: String,
        sensitivityLevel: 1, // 高度敏感数据
        description: '银行账号'
      },
      accountName: {
        type: String,
        sensitivityLevel: 1, // 高度敏感数据
        description: '账户名称'
      }
    },
    settlementCycle: {
      type: String,
      enum: ['daily', 'weekly', 'biweekly', 'monthly'],
      default: 'weekly',
      sensitivityLevel: 3, // 低度敏感数据
      description: '结算周期'
    },
    commissionRate: {
      type: Number,
      default: 0.05,
      sensitivityLevel: 2, // 中度敏感数据
      description: '佣金率'
    }
  },
  // 订单与统计
  stats: {
    totalOrders: {
      type: Number,
      default: 0,
      sensitivityLevel: 3, // 低度敏感数据
      description: '总订单数'
    },
    totalSales: {
      type: Number,
      default: 0,
      sensitivityLevel: 2, // 中度敏感数据
      description: '总销售额'
    },
    avgOrderValue: {
      type: Number,
      default: 0,
      sensitivityLevel: 3, // 低度敏感数据
      description: '平均订单金额'
    },
    avgRating: {
      type: Number,
      default: 0,
      sensitivityLevel: 3, // 低度敏感数据
      description: '平均评分'
    },
    ratingCount: {
      type: Number,
      default: 0,
      sensitivityLevel: 3, // 低度敏感数据
      description: '评分数量'
    },
    healthScore: {
      type: Number,
      min: 0,
      max: 100,
      default: 80,
      sensitivityLevel: 3, // 低度敏感数据
      description: '健康评分(0-100)'
    }
  },
  // 数据共享与访问权限
  dataSharing: {
    shareNutritionDataWithUsers: {
      type: Boolean,
      default: false,
      description: '是否与用户共享营养数据'
    },
    shareMenuItemsWithPublic: {
      type: Boolean,
      default: true,
      description: '是否公开分享菜单项'
    },
    shareMenuNutritionData: {
      type: Boolean,
      default: true,
      description: '是否分享菜单营养数据'
    },
    allowNutritionistReviews: {
      type: Boolean,
      default: true,
      description: '是否允许营养师审核'
    }
  },
  // 外部服务集成
  externalServices: [{
    serviceName: {
      type: String,
      enum: [
        'deliveryService',
        'reservationSystem',
        'posSystem',
        'inventoryManagement',
        'customerLoyalty',
        'other'
      ],
      sensitivityLevel: 3, // 低度敏感数据
      description: '服务名称'
    },
    serviceProvider: {
      type: String,
      sensitivityLevel: 3, // 低度敏感数据
      description: '服务提供商'
    },
    integrationDetails: {
      type: String,
      sensitivityLevel: 2, // 中度敏感数据
      description: '集成详情'
    },
    isActive: {
      type: Boolean,
      default: true,
      sensitivityLevel: 3, // 低度敏感数据
      description: '是否激活'
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
      enum: ['User', 'Nutritionist', 'Admin'],
      description: '授予访问权限的对象类型'
    },
    grantedAt: {
      type: Date,
      default: Date.now,
      description: '授予访问权限的时间'
    },
    validUntil: {
      type: Date,
      description: '访问权限的有效期'
    },
    accessLevel: {
      type: String,
      enum: ['view_menu', 'view_business_info', 'view_orders', 'manage_menu', 'manage_business', 'full_access'],
      default: 'view_menu',
      description: '访问级别'
    },
    revoked: {
      type: Boolean,
      default: false,
      description: '是否已撤销访问权限'
    },
    revokedAt: {
      type: Date,
      description: '撤销访问权限的时间'
    }
  }],
  // 安全与审计
  accessLog: [{
    timestamp: {
      type: Date,
      default: Date.now,
      description: '访问时间'
    },
    accessedBy: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessLog.accessedByType'
    },
    accessedByType: {
      type: String,
      enum: ['User', 'Nutritionist', 'Admin', 'System'],
      description: '访问者类型'
    },
    ipAddress: {
      type: String,
      description: '访问者IP地址'
    },
    action: {
      type: String,
      enum: ['view_profile', 'view_menu', 'place_order', 'update_menu', 'update_profile', 'view_orders', 'other'],
      description: '访问操作'
    },
    resourceId: mongoose.Schema.Types.ObjectId,
    details: {
      type: String,
      description: '访问详情'
    }
  }],
  // 合规与隐私确认
  compliance: {
    termsAgreed: {
      type: Boolean,
      default: false,
      description: '是否同意条款'
    },
    privacyPolicyAgreed: {
      type: Boolean,
      default: false,
      description: '是否同意隐私政策'
    },
    dataProcessingAgreed: {
      type: Boolean,
      default: false,
      description: '是否同意数据处理'
    },
    agreementDate: {
      type: Date,
      description: '协议同意日期'
    },
    lastPolicyUpdateAgreed: {
      type: Date,
      description: '最后政策更新同意日期'
    }
  },
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

// 使用modelRegistrar创建模型
const Merchant = require('../modelRegistrar')('Merchant', merchantSchema, {
  timestamps: true,
  optimizedIndexes: {
    frequentFields: ['userId', 'businessName', 'businessType'],
    compound: [
      // 按地理位置查询商家 
      {
        fields: { 'address.city': 1, 'address.state': 1, businessType: 1 },
        name: 'merchant_location_type_idx'
      },
      // 按营养特色查询
      {
        fields: { 'nutritionFeatures.specialtyDiets': 1, businessType: 1 },
        name: 'merchant_nutrition_feature_idx'
      },
      // 商家评分索引
      {
        fields: { averageRating: -1, businessType: 1 },
        name: 'merchant_rating_idx'
      }
    ],
    partial: [
      // 有营养师的商家
      {
        fields: { 'nutritionFeatures.hasNutritionist': 1, businessType: 1 },
        filter: { 'nutritionFeatures.hasNutritionist': true },
        name: 'merchant_with_nutritionist_idx'
      }
    ],
    geo: [
      // 地理空间索引 
      { field: 'address.coordinates' }
    ],
    text: [
      // 搜索字段
      'businessName',
      'businessProfile.description',
      'nutritionFeatures.specialtyDiets'
    ]
  },
  // 查询助手方法
  query: {
    // 基本信息
    basicInfo: function() {
      return this.select('businessName businessType businessProfile.logoUrl businessProfile.description address.city address.state averageRating');
    },
    // 详细信息
    detailedInfo: function() {
      return this.select('businessName businessType businessProfile contact address nutritionFeatures averageRating');
    },
    // 按地理位置排序
    nearbyFirst: function(coordinates, maxDistance = 10000) {
      if (!coordinates || !coordinates.latitude || !coordinates.longitude) {
        return this;
      }
      return this.where('address.coordinates').near({
        center: {
          type: 'Point',
          coordinates: [coordinates.longitude, coordinates.latitude]
        },
        maxDistance: maxDistance,
        spherical: true
      });
    }
  }
});

module.exports = Merchant; 