const mongoose = require('mongoose');

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
  sessions: [{
    openTime: {
      type: String,
      required: true,
      description: '开始营业时间 (HH:mm)'
    },
    closeTime: {
      type: String,
      required: true,
      description: '结束营业时间 (HH:mm)'
    }
  }]
}, { _id: false });

// 加盟店模型
const franchiseStoreSchema = new mongoose.Schema({
  // 基本信息
  storeCode: {
    type: String,
    required: true,
    unique: true,
    description: '门店编号 (如: YQ-BJ-001)'
  },
  storeName: {
    type: String,
    required: true,
    description: '门店名称'
  },
  managerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '店长用户ID'
  },
  
  // 加盟信息
  franchiseInfo: {
    franchiseDate: {
      type: Date,
      required: true,
      default: Date.now,
      description: '加盟日期'
    },
    contractStartDate: {
      type: Date,
      required: true,
      description: '合同开始日期'
    },
    contractEndDate: {
      type: Date,
      required: true,
      description: '合同结束日期'
    },
    franchiseStatus: {
      type: String,
      enum: ['pending', 'active', 'suspended', 'terminated'],
      default: 'pending',
      description: '加盟状态'
    },
    franchiseFee: {
      type: Number,
      required: true,
      description: '加盟费用'
    }
  },
  
  // 地址信息
  address: {
    province: {
      type: String,
      required: true,
      description: '省份'
    },
    city: {
      type: String,
      required: true,
      description: '城市'
    },
    district: {
      type: String,
      required: true,
      description: '区县'
    },
    street: {
      type: String,
      required: true,
      description: '详细地址'
    },
    postalCode: {
      type: String,
      description: '邮政编码'
    },
    coordinates: {
      latitude: {
        type: Number,
        description: '纬度'
      },
      longitude: {
        type: Number,
        description: '经度'
      }
    }
  },
  
  // 联系信息
  contact: {
    phone: {
      type: String,
      required: true,
      description: '门店电话'
    },
    email: {
      type: String,
      required: true,
      description: '门店邮箱'
    },
    emergencyContact: {
      name: {
        type: String,
        description: '紧急联系人'
      },
      phone: {
        type: String,
        description: '紧急联系电话'
      }
    }
  },
  
  // 营业信息
  businessInfo: {
    businessLicense: {
      number: {
        type: String,
        required: true,
        description: '营业执照号'
      },
      imageUrl: {
        type: String,
        description: '营业执照图片'
      }
    },
    taxRegistration: {
      number: {
        type: String,
        required: true,
        description: '税务登记号'
      }
    },
    operatingHours: [operatingHoursSchema],
    seatingCapacity: {
      type: Number,
      default: 50,
      description: '座位数'
    },
    deliveryRadius: {
      type: Number,
      default: 5,
      description: '配送半径(公里)'
    }
  },
  
  // 服务配置
  serviceConfig: {
    // 支持的服务类型
    supportedServices: [{
      type: String,
      enum: ['dine_in', 'takeout', 'delivery', 'catering', 'meal_prep'],
      description: '支持的服务类型'
    }],
    // 目标客户群体
    targetCustomers: [{
      type: String,
      enum: ['fitness', 'pregnancy', 'students', 'office_workers', 'elderly', 'general'],
      description: '目标客户群体'
    }],
    // 特色服务
    specialServices: {
      hasNutritionist: {
        type: Boolean,
        default: false,
        description: '是否配备营养师'
      },
      nutritionistId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        description: '营养师ID'
      },
      providesNutritionConsultation: {
        type: Boolean,
        default: true,
        description: '是否提供营养咨询'
      },
      customMealPlans: {
        type: Boolean,
        default: true,
        description: '是否提供定制餐单'
      }
    }
  },
  
  // 员工管理
  staff: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      description: '员工用户ID'
    },
    role: {
      type: String,
      enum: ['manager', 'chef', 'nutritionist', 'cashier', 'delivery', 'cleaner'],
      required: true,
      description: '员工角色'
    },
    joinDate: {
      type: Date,
      default: Date.now,
      description: '入职日期'
    },
    isActive: {
      type: Boolean,
      default: true,
      description: '是否在职'
    }
  }],
  
  // 运营数据（缓存）
  operationalData: {
    totalOrders: {
      type: Number,
      default: 0,
      description: '总订单数'
    },
    monthlyRevenue: {
      type: Number,
      default: 0,
      description: '月营收'
    },
    averageRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
      description: '平均评分'
    },
    totalReviews: {
      type: Number,
      default: 0,
      description: '总评价数'
    },
    lastUpdated: {
      type: Date,
      default: Date.now,
      description: '数据最后更新时间'
    }
  },
  
  // 状态信息
  status: {
    isActive: {
      type: Boolean,
      default: true,
      description: '是否营业中'
    },
    temporaryClosure: {
      reason: {
        type: String,
        description: '临时关闭原因'
      },
      startDate: {
        type: Date,
        description: '关闭开始时间'
      },
      expectedReopenDate: {
        type: Date,
        description: '预计重开时间'
      }
    }
  },
  
  // 系统配置
  settings: {
    autoAcceptOrders: {
      type: Boolean,
      default: false,
      description: '是否自动接单'
    },
    orderNotification: {
      email: {
        type: Boolean,
        default: true,
        description: '邮件通知'
      },
      sms: {
        type: Boolean,
        default: true,
        description: '短信通知'
      }
    },
    inventoryAlert: {
      enabled: {
        type: Boolean,
        default: true,
        description: '库存预警开启'
      },
      threshold: {
        type: Number,
        default: 20,
        description: '库存预警阈值(%)'
      }
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
franchiseStoreSchema.index({ storeCode: 1 });
franchiseStoreSchema.index({ managerId: 1 });
franchiseStoreSchema.index({ 'address.city': 1 });
franchiseStoreSchema.index({ 'franchiseInfo.franchiseStatus': 1 });
franchiseStoreSchema.index({ 'status.isActive': 1 });
franchiseStoreSchema.index({ 'address.coordinates': '2dsphere' }); // 地理位置索引

// 虚拟字段
franchiseStoreSchema.virtual('isOperating').get(function() {
  if (!this.status.isActive) return false;
  if (this.status.temporaryClosure && this.status.temporaryClosure.startDate) {
    const now = new Date();
    return now < this.status.temporaryClosure.startDate || 
           (this.status.temporaryClosure.expectedReopenDate && now > this.status.temporaryClosure.expectedReopenDate);
  }
  return true;
});

// 实例方法
franchiseStoreSchema.methods.isOpenNow = function() {
  const now = new Date();
  const dayOfWeek = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][now.getDay()];
  const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
  
  const todayHours = this.businessInfo.operatingHours.find(h => h.dayOfWeek === dayOfWeek);
  if (!todayHours || !todayHours.isOpen) return false;
  
  return todayHours.sessions.some(session => {
    return currentTime >= session.openTime && currentTime <= session.closeTime;
  });
};

// 静态方法
franchiseStoreSchema.statics.findNearby = async function(coordinates, maxDistance = 5000) {
  return this.find({
    'address.coordinates': {
      $near: {
        $geometry: {
          type: 'Point',
          coordinates: [coordinates.longitude, coordinates.latitude]
        },
        $maxDistance: maxDistance
      }
    },
    'status.isActive': true
  });
};

const FranchiseStore = mongoose.model('FranchiseStore', franchiseStoreSchema);

module.exports = FranchiseStore;