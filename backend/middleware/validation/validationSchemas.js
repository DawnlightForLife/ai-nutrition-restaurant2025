/**
 * 验证模式集合
 * 集中管理所有API的验证规则
 * @module middleware/validation/validationSchemas
 */

const Joi = require('joi');

// ========== 通用验证规则 ==========
const commonSchemas = {
  // MongoDB ObjectId
  objectId: Joi.string().pattern(/^[0-9a-fA-F]{24}$/),
  
  // 分页参数
  pagination: Joi.object({
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(20),
    sort: Joi.string(),
    order: Joi.string().valid('asc', 'desc').default('desc')
  }),
  
  // 日期范围
  dateRange: Joi.object({
    startDate: Joi.date().iso(),
    endDate: Joi.date().iso().greater(Joi.ref('startDate'))
  }),
  
  // 地理位置
  location: Joi.object({
    longitude: Joi.number().min(-180).max(180).required(),
    latitude: Joi.number().min(-90).max(90).required()
  }),
  
  // 地址
  address: Joi.object({
    province: Joi.string().required(),
    city: Joi.string().required(),
    district: Joi.string().required(),
    street: Joi.string().required(),
    detail: Joi.string().required(),
    postalCode: Joi.string()
  })
};

// ========== 用户相关验证 ==========
const userSchemas = {
  // 用户注册
  register: Joi.object({
    phone: Joi.string().pattern(/^1[3-9]\d{9}$/).required(),
    password: Joi.string().min(6).max(128).required(),
    confirmPassword: Joi.string().valid(Joi.ref('password')).required(),
    name: Joi.string().min(2).max(50),
    email: Joi.string().email(),
    verificationCode: Joi.string().length(6).required()
  }),
  
  // 用户登录
  login: Joi.object({
    phone: Joi.string().pattern(/^1[3-9]\d{9}$/),
    email: Joi.string().email(),
    password: Joi.string().required()
  }).xor('phone', 'email'),
  
  // 更新个人资料
  updateProfile: Joi.object({
    name: Joi.string().min(2).max(50),
    email: Joi.string().email(),
    avatar: Joi.string().uri(),
    gender: Joi.string().valid('male', 'female', 'other'),
    birthday: Joi.date().max('now'),
    bio: Joi.string().max(500)
  }),
  
  // 修改密码
  changePassword: Joi.object({
    oldPassword: Joi.string().required(),
    newPassword: Joi.string().min(6).max(128).required(),
    confirmPassword: Joi.string().valid(Joi.ref('newPassword')).required()
  })
};

// ========== 餐厅相关验证 ==========
const restaurantSchemas = {
  // 创建餐厅
  createRestaurant: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    type: Joi.string().valid('single_store', 'chain', 'franchise').required(),
    description: Joi.string().max(1000),
    logo: Joi.string().uri(),
    coverImage: Joi.string().uri(),
    businessLicense: Joi.string().required(),
    registrationNumber: Joi.string().required(),
    legalRepresentative: Joi.string().required(),
    establishedDate: Joi.date().max('now'),
    contactInfo: Joi.object({
      phone: Joi.string().required(),
      email: Joi.string().email(),
      website: Joi.string().uri()
    }),
    socialMedia: Joi.object({
      wechat: Joi.string(),
      weibo: Joi.string(),
      douyin: Joi.string(),
      xiaohongshu: Joi.string()
    }),
    tags: Joi.array().items(Joi.string()),
    features: Joi.array().items(Joi.string().valid('wifi', 'parking', 'private_room', 'outdoor_seating')),
    cuisineTypes: Joi.array().items(Joi.string()),
    priceRange: Joi.string().valid('low', 'medium', 'high', 'luxury'),
    serviceTypes: Joi.array().items(Joi.string().valid('dine_in', 'takeout', 'delivery')),
    paymentMethods: Joi.array().items(Joi.string().valid('cash', 'alipay', 'wechat_pay', 'credit_card'))
  }),
  
  // 更新餐厅
  updateRestaurant: Joi.object({
    name: Joi.string().min(2).max(100),
    description: Joi.string().max(1000),
    logo: Joi.string().uri(),
    coverImage: Joi.string().uri(),
    contactInfo: Joi.object({
      phone: Joi.string(),
      email: Joi.string().email(),
      website: Joi.string().uri()
    }),
    socialMedia: Joi.object({
      wechat: Joi.string(),
      weibo: Joi.string(),
      douyin: Joi.string(),
      xiaohongshu: Joi.string()
    }),
    tags: Joi.array().items(Joi.string()),
    features: Joi.array().items(Joi.string()),
    cuisineTypes: Joi.array().items(Joi.string()),
    priceRange: Joi.string().valid('low', 'medium', 'high', 'luxury'),
    serviceTypes: Joi.array().items(Joi.string()),
    paymentMethods: Joi.array().items(Joi.string())
  }),
  
  // 创建分店
  createBranch: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    address: commonSchemas.address.required(),
    location: Joi.object({
      type: Joi.string().valid('Point').default('Point'),
      coordinates: Joi.array().items(Joi.number()).length(2).required()
    }),
    contactInfo: Joi.object({
      phone: Joi.string().required(),
      email: Joi.string().email(),
      fax: Joi.string()
    }),
    businessHours: Joi.object({
      monday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      tuesday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      wednesday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      thursday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      friday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      saturday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      }),
      sunday: Joi.object({
        open: Joi.string().pattern(/^\d{2}:\d{2}$/),
        close: Joi.string().pattern(/^\d{2}:\d{2}$/),
        isOpen: Joi.boolean()
      })
    }),
    manager: Joi.object({
      name: Joi.string(),
      phone: Joi.string(),
      email: Joi.string().email()
    }),
    staffCount: Joi.number().integer().min(0),
    seatingCapacity: Joi.number().integer().min(0),
    features: Joi.array().items(Joi.string()),
    images: Joi.array().items(Joi.string().uri()),
    parkingInfo: Joi.object({
      available: Joi.boolean(),
      type: Joi.string().valid('free', 'paid', 'valet'),
      spaces: Joi.number().integer().min(0),
      fee: Joi.number().min(0)
    }),
    transportInfo: Joi.object({
      metro: Joi.array().items(Joi.string()),
      bus: Joi.array().items(Joi.string()),
      landmark: Joi.string()
    })
  }),
  
  // 更新分店
  updateBranch: Joi.object({
    name: Joi.string().min(2).max(100),
    address: commonSchemas.address,
    location: Joi.object({
      type: Joi.string().valid('Point'),
      coordinates: Joi.array().items(Joi.number()).length(2)
    }),
    contactInfo: Joi.object({
      phone: Joi.string(),
      email: Joi.string().email(),
      fax: Joi.string()
    }),
    businessHours: Joi.object(),
    manager: Joi.object({
      name: Joi.string(),
      phone: Joi.string(),
      email: Joi.string().email()
    }),
    staffCount: Joi.number().integer().min(0),
    seatingCapacity: Joi.number().integer().min(0),
    features: Joi.array().items(Joi.string()),
    images: Joi.array().items(Joi.string().uri()),
    parkingInfo: Joi.object(),
    transportInfo: Joi.object()
  }),
  
  // 创建桌位
  createTable: Joi.object({
    tableNumber: Joi.string().required(),
    area: Joi.string().valid('main', 'vip', 'outdoor', 'private'),
    capacity: Joi.number().integer().min(1).max(50),
    minCapacity: Joi.number().integer().min(1),
    tableType: Joi.string().valid('regular', 'booth', 'bar', 'high_table'),
    shape: Joi.string().valid('square', 'round', 'rectangular'),
    features: Joi.array().items(Joi.string().valid('window_seat', 'wheelchair_accessible', 'baby_chair', 'power_outlet')),
    position: Joi.object({
      x: Joi.number(),
      y: Joi.number(),
      floor: Joi.number().integer()
    }),
    isActive: Joi.boolean()
  }),
  
  // 批量创建桌位
  createTables: Joi.object({
    tables: Joi.array().items(
      Joi.object({
        tableNumber: Joi.string().required(),
        area: Joi.string().valid('main', 'vip', 'outdoor', 'private'),
        capacity: Joi.number().integer().min(1).max(50),
        minCapacity: Joi.number().integer().min(1),
        tableType: Joi.string().valid('regular', 'booth', 'bar', 'high_table'),
        shape: Joi.string().valid('square', 'round', 'rectangular'),
        features: Joi.array().items(Joi.string()),
        position: Joi.object({
          x: Joi.number(),
          y: Joi.number(),
          floor: Joi.number().integer()
        }),
        isActive: Joi.boolean()
      })
    ).min(1).max(100).required()
  }),
  
  // 更新桌位
  updateTable: Joi.object({
    tableNumber: Joi.string(),
    area: Joi.string().valid('main', 'vip', 'outdoor', 'private'),
    capacity: Joi.number().integer().min(1).max(50),
    minCapacity: Joi.number().integer().min(1),
    tableType: Joi.string().valid('regular', 'booth', 'bar', 'high_table'),
    shape: Joi.string().valid('square', 'round', 'rectangular'),
    features: Joi.array().items(Joi.string()),
    position: Joi.object({
      x: Joi.number(),
      y: Joi.number(),
      floor: Joi.number().integer()
    })
  }),
  
  // 更新设置
  updateSettings: Joi.object({
    orderSettings: Joi.object(),
    paymentSettings: Joi.object(),
    deliverySettings: Joi.object(),
    tableSettings: Joi.object(),
    notificationSettings: Joi.object(),
    operationalSettings: Joi.object(),
    nutritionSettings: Joi.object(),
    promotionSettings: Joi.object()
  })
};

// ========== 订单相关验证 ==========
const orderSchemas = {
  // 创建订单
  createOrder: Joi.object({
    restaurantId: commonSchemas.objectId.required(),
    branchId: commonSchemas.objectId.required(),
    orderType: Joi.string().valid('dine_in', 'takeout', 'delivery').required(),
    tableId: commonSchemas.objectId.when('orderType', {
      is: 'dine_in',
      then: Joi.required()
    }),
    items: Joi.array().items(
      Joi.object({
        dishId: commonSchemas.objectId.required(),
        quantity: Joi.number().integer().min(1).required(),
        price: Joi.number().min(0).required(),
        specialInstructions: Joi.string().max(200)
      })
    ).min(1).required(),
    deliveryInfo: Joi.object({
      address: commonSchemas.address.required(),
      contactName: Joi.string().required(),
      contactPhone: Joi.string().required(),
      deliveryTime: Joi.date().min('now'),
      deliveryInstructions: Joi.string().max(500)
    }).when('orderType', {
      is: 'delivery',
      then: Joi.required()
    }),
    paymentMethod: Joi.string().valid('cash', 'alipay', 'wechat_pay', 'credit_card'),
    couponCode: Joi.string(),
    remarks: Joi.string().max(500)
  }),
  
  // 更新订单
  updateOrder: Joi.object({
    status: Joi.string().valid('pending', 'confirmed', 'preparing', 'ready', 'delivering', 'completed', 'cancelled'),
    paymentStatus: Joi.string().valid('pending', 'paid', 'refunded'),
    deliveryInfo: Joi.object({
      address: commonSchemas.address,
      contactName: Joi.string(),
      contactPhone: Joi.string(),
      deliveryTime: Joi.date(),
      deliveryInstructions: Joi.string().max(500)
    }),
    remarks: Joi.string().max(500)
  })
};

// ========== 营养相关验证 ==========
const nutritionSchemas = {
  // 创建营养档案
  createNutritionProfile: Joi.object({
    height: Joi.number().min(50).max(300).required(),
    weight: Joi.number().min(20).max(500).required(),
    age: Joi.number().integer().min(1).max(150).required(),
    gender: Joi.string().valid('male', 'female', 'other').required(),
    activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active').required(),
    dietaryRestrictions: Joi.array().items(Joi.string()),
    allergies: Joi.array().items(Joi.string()),
    healthConditions: Joi.array().items(Joi.string()),
    fitnessGoals: Joi.array().items(Joi.string()),
    preferredCuisines: Joi.array().items(Joi.string())
  }),
  
  // 更新营养档案
  updateNutritionProfile: Joi.object({
    height: Joi.number().min(50).max(300),
    weight: Joi.number().min(20).max(500),
    age: Joi.number().integer().min(1).max(150),
    gender: Joi.string().valid('male', 'female', 'other'),
    activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active'),
    dietaryRestrictions: Joi.array().items(Joi.string()),
    allergies: Joi.array().items(Joi.string()),
    healthConditions: Joi.array().items(Joi.string()),
    fitnessGoals: Joi.array().items(Joi.string()),
    preferredCuisines: Joi.array().items(Joi.string())
  }),

  // 营养师认证申请
  createNutritionistCertification: Joi.object({
    personalInfo: Joi.object({
      fullName: Joi.string().min(2).max(50).required(),
      gender: Joi.string().valid('male', 'female').required(),
      birthDate: Joi.date().max('now').required(),
      idNumber: Joi.string().pattern(/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/).required(),
      phone: Joi.string().pattern(/^1[3-9]\d{9}$/).required(),
      email: Joi.string().email().required(),
      address: Joi.object({
        province: Joi.string().required(),
        city: Joi.string().required(),
        district: Joi.string().required(),
        detailed: Joi.string().min(5).max(200).required()
      }).required()
    }).required(),
    
    education: Joi.object({
      degree: Joi.string().valid('doctoral', 'master', 'bachelor', 'associate', 'technical_secondary').required(),
      major: Joi.string().valid('nutrition', 'food_science', 'clinical_medicine', 'preventive_medicine', 'nursing', 'pharmacy', 'biochemistry', 'other_related').required(),
      school: Joi.string().min(2).max(100).required(),
      graduationYear: Joi.number().integer().min(1950).max(new Date().getFullYear() + 5).required(),
      gpa: Joi.number().min(0).max(4.0).optional()
    }).required(),
    
    workExperience: Joi.object({
      totalYears: Joi.number().integer().min(0).max(50).required(),
      currentPosition: Joi.string().min(2).max(100).required(),
      currentEmployer: Joi.string().min(2).max(100).required(),
      workDescription: Joi.string().min(10).max(1000).required(),
      previousExperiences: Joi.array().items(Joi.object({
        position: Joi.string().min(2).max(100).required(),
        employer: Joi.string().min(2).max(100).required(),
        startDate: Joi.date().required(),
        endDate: Joi.date().greater(Joi.ref('startDate')).optional(),
        responsibilities: Joi.string().max(500).optional()
      })).default([])
    }).required(),
    
    certificationInfo: Joi.object({
      targetLevel: Joi.string().valid('registered_dietitian', 'dietetic_technician', 'public_nutritionist_l4', 'public_nutritionist_l3', 'nutrition_manager').required(),
      specializationAreas: Joi.array().items(
        Joi.string().valid('clinical_nutrition', 'public_nutrition', 'food_nutrition', 'sports_nutrition', 'maternal_child', 'elderly_nutrition', 'weight_management')
      ).min(1).required(),
      motivationStatement: Joi.string().min(50).max(2000).required(),
      careerGoals: Joi.string().max(1000).optional()
    }).required()
  }),

  // 更新营养师认证申请（与创建相同的验证规则，但所有字段都是可选的）
  updateNutritionistCertification: Joi.object({
    personalInfo: Joi.object({
      fullName: Joi.string().min(2).max(50),
      gender: Joi.string().valid('male', 'female'),
      birthDate: Joi.date().max('now'),
      idNumber: Joi.string().pattern(/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/),
      phone: Joi.string().pattern(/^1[3-9]\d{9}$/),
      email: Joi.string().email(),
      address: Joi.object({
        province: Joi.string(),
        city: Joi.string(),
        district: Joi.string(),
        detailed: Joi.string().min(5).max(200)
      })
    }),
    
    education: Joi.object({
      degree: Joi.string().valid('doctoral', 'master', 'bachelor', 'associate', 'technical_secondary'),
      major: Joi.string().valid('nutrition', 'food_science', 'clinical_medicine', 'preventive_medicine', 'nursing', 'pharmacy', 'biochemistry', 'other_related'),
      school: Joi.string().min(2).max(100),
      graduationYear: Joi.number().integer().min(1950).max(new Date().getFullYear() + 5),
      gpa: Joi.number().min(0).max(4.0)
    }),
    
    workExperience: Joi.object({
      totalYears: Joi.number().integer().min(0).max(50),
      currentPosition: Joi.string().min(2).max(100),
      currentEmployer: Joi.string().min(2).max(100),
      workDescription: Joi.string().min(10).max(1000),
      previousExperiences: Joi.array().items(Joi.object({
        position: Joi.string().min(2).max(100).required(),
        employer: Joi.string().min(2).max(100).required(),
        startDate: Joi.date().required(),
        endDate: Joi.date().greater(Joi.ref('startDate')),
        responsibilities: Joi.string().max(500)
      }))
    }),
    
    certificationInfo: Joi.object({
      targetLevel: Joi.string().valid('registered_dietitian', 'dietetic_technician', 'public_nutritionist_l4', 'public_nutritionist_l3', 'nutrition_manager'),
      specializationAreas: Joi.array().items(
        Joi.string().valid('clinical_nutrition', 'public_nutrition', 'food_nutrition', 'sports_nutrition', 'maternal_child', 'elderly_nutrition', 'weight_management')
      ).min(1),
      motivationStatement: Joi.string().min(50).max(2000),
      careerGoals: Joi.string().max(1000)
    })
  }),

  // 文档上传验证
  uploadDocument: Joi.object({
    documentType: Joi.string().valid('degree_certificate', 'graduation_certificate', 'transcript', 'work_certificate', 'professional_certificate', 'training_certificate', 'id_card', 'profile_photo').required(),
    fileName: Joi.string().min(1).max(255).required(),
    fileUrl: Joi.string().uri().required(),
    fileSize: Joi.number().integer().min(1).max(10 * 1024 * 1024).required(), // 最大10MB
    mimeType: Joi.string().valid('image/jpeg', 'image/jpg', 'image/png', 'application/pdf').required()
  })
};

// ========== 积分相关验证 ==========
const pointsSchemas = {
  // 创建积分规则
  createPointsRule: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    type: Joi.string().valid('earn', 'redeem').required(),
    action: Joi.string().valid('order', 'review', 'share', 'checkin', 'referral', 'custom').required(),
    points: Joi.number().integer().min(0).required(),
    conditions: Joi.object({
      minAmount: Joi.number().min(0),
      maxAmount: Joi.number().min(0),
      categories: Joi.array().items(Joi.string()),
      timeRange: Joi.object({
        start: Joi.string().pattern(/^\d{2}:\d{2}$/),
        end: Joi.string().pattern(/^\d{2}:\d{2}$/)
      }),
      dayOfWeek: Joi.array().items(Joi.number().integer().min(0).max(6)),
      userLevel: Joi.array().items(Joi.string())
    }),
    validFrom: Joi.date(),
    validTo: Joi.date().greater(Joi.ref('validFrom')),
    isActive: Joi.boolean(),
    priority: Joi.number().integer().min(0).max(100)
  }),
  
  // 积分交易
  pointsTransaction: Joi.object({
    userId: commonSchemas.objectId.required(),
    type: Joi.string().valid('earn', 'redeem', 'expire', 'adjust').required(),
    points: Joi.number().integer().required(),
    reason: Joi.string().required(),
    orderId: commonSchemas.objectId,
    metadata: Joi.object()
  })
};

// ========== 内容举报验证 ==========
const contentReportSchemas = {
  // 创建举报
  createReport: Joi.object({
    contentType: Joi.string().valid('post', 'comment', 'user', 'dish', 'review').required(),
    contentId: commonSchemas.objectId.required(),
    reason: Joi.string().valid('spam', 'inappropriate', 'false_info', 'harassment', 'copyright', 'other').required(),
    description: Joi.string().max(1000).required(),
    evidence: Joi.array().items(Joi.string().uri())
  }),
  
  // 处理举报
  processReport: Joi.object({
    action: Joi.string().valid('approve', 'reject', 'escalate').required(),
    result: Joi.object({
      actionTaken: Joi.string().valid('none', 'warning', 'content_removed', 'user_suspended', 'user_banned'),
      notes: Joi.string().max(1000)
    })
  })
};

// ========== 访客档案验证 ==========
const guestProfileSchemas = {
  // 创建访客档案
  createGuestProfile: Joi.object({
    profileData: Joi.object({
      height: Joi.number().min(50).max(300),
      weight: Joi.number().min(20).max(500),
      age: Joi.number().integer().min(1).max(150),
      gender: Joi.string().valid('male', 'female', 'other'),
      activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active'),
      dietaryRestrictions: Joi.array().items(Joi.string()),
      allergies: Joi.array().items(Joi.string())
    }).required()
  }),
  
  // 绑定到用户
  bindToUser: Joi.object({
    bindingToken: Joi.string().required(),
    userId: commonSchemas.objectId.required()
  })
};

// ========== 取餐码验证 ==========
const pickupCodeSchemas = {
  // 验证取餐码
  verifyPickupCode: Joi.object({
    code: Joi.string().length(6).uppercase().required()
  }),
  
  // 批量验证
  batchVerify: Joi.object({
    codes: Joi.array().items(Joi.string().length(6).uppercase()).min(1).max(20).required()
  })
};

// 集合所有验证模式
const validationSchemas = {
  // 通用
  common: commonSchemas,
  
  // 用户
  'user.register': userSchemas.register,
  'user.login': userSchemas.login,
  'user.updateProfile': userSchemas.updateProfile,
  'user.changePassword': userSchemas.changePassword,
  
  // 餐厅
  'restaurant.create': restaurantSchemas.createRestaurant,
  'restaurant.update': restaurantSchemas.updateRestaurant,
  'branch.create': restaurantSchemas.createBranch,
  'branch.update': restaurantSchemas.updateBranch,
  'table.create': restaurantSchemas.createTable,
  'table.createBatch': restaurantSchemas.createTables,
  'table.update': restaurantSchemas.updateTable,
  'settings.update': restaurantSchemas.updateSettings,
  
  // 订单
  'order.create': orderSchemas.createOrder,
  'order.update': orderSchemas.updateOrder,
  
  // 营养
  'nutritionProfile.create': nutritionSchemas.createNutritionProfile,
  'nutritionProfile.update': nutritionSchemas.updateNutritionProfile,
  
  // 营养师认证
  'nutritionistCertification.create': nutritionSchemas.createNutritionistCertification,
  'nutritionistCertification.update': nutritionSchemas.updateNutritionistCertification,
  'nutritionistCertification.uploadDocument': nutritionSchemas.uploadDocument,
  
  // 积分
  'pointsRule.create': pointsSchemas.createPointsRule,
  'points.transaction': pointsSchemas.pointsTransaction,
  
  // 内容举报
  'contentReport.create': contentReportSchemas.createReport,
  'contentReport.process': contentReportSchemas.processReport,
  
  // 访客档案
  'guestProfile.create': guestProfileSchemas.createGuestProfile,
  'guestProfile.bind': guestProfileSchemas.bindToUser,
  
  // 取餐码
  'pickupCode.verify': pickupCodeSchemas.verifyPickupCode,
  'pickupCode.batchVerify': pickupCodeSchemas.batchVerify
};

// 导出验证模式获取函数
const getValidationSchema = (schemaName) => {
  const schema = validationSchemas[schemaName];
  if (!schema) {
    throw new Error(`Validation schema '${schemaName}' not found`);
  }
  return schema;
};

module.exports = {
  validationSchemas,
  getValidationSchema,
  // 导出各模块的原始模式对象，方便扩展
  commonSchemas,
  userSchemas,
  restaurantSchemas,
  orderSchemas,
  nutritionSchemas,
  pointsSchemas,
  contentReportSchemas,
  guestProfileSchemas,
  pickupCodeSchemas
};