/**
 * 加盟商模型
 * 管理餐厅品牌的加盟商信息
 * @module models/franchise/franchiseModel
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

const franchiseSchema = new Schema({
  // 基本信息
  franchiseCode: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  
  restaurantId: {
    type: Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true,
    index: true
  },
  
  // 加盟商信息
  franchiseInfo: {
    companyName: {
      type: String,
      required: true
    },
    legalRepresentative: {
      type: String,
      required: true
    },
    registrationNumber: {
      type: String,
      required: true,
      unique: true
    },
    businessLicense: {
      type: String,
      required: true
    },
    taxNumber: String,
    registeredCapital: Number,
    establishedDate: Date,
    businessScope: String
  },
  
  // 联系信息
  contactInfo: {
    primaryContact: {
      name: String,
      position: String,
      phone: {
        type: String,
        required: true
      },
      email: {
        type: String,
        required: true
      },
      wechat: String
    },
    secondaryContact: {
      name: String,
      position: String,
      phone: String,
      email: String
    },
    officeAddress: {
      province: String,
      city: String,
      district: String,
      street: String,
      detail: String,
      postalCode: String
    }
  },
  
  // 加盟合同信息
  contractInfo: {
    contractNumber: {
      type: String,
      required: true,
      unique: true
    },
    contractType: {
      type: String,
      enum: ['standard', 'regional', 'master', 'single_store'],
      default: 'standard'
    },
    signedDate: {
      type: Date,
      required: true
    },
    effectiveDate: {
      type: Date,
      required: true
    },
    expiryDate: {
      type: Date,
      required: true
    },
    autoRenewal: {
      type: Boolean,
      default: false
    },
    renewalTerms: String,
    contractFiles: [{
      fileName: String,
      fileUrl: String,
      uploadedAt: Date
    }]
  },
  
  // 财务信息
  financialInfo: {
    franchiseFee: {
      amount: Number,
      currency: {
        type: String,
        default: 'CNY'
      },
      paymentStatus: {
        type: String,
        enum: ['pending', 'partial', 'paid'],
        default: 'pending'
      },
      paymentDate: Date
    },
    securityDeposit: {
      amount: Number,
      status: {
        type: String,
        enum: ['pending', 'paid', 'refunded'],
        default: 'pending'
      },
      paidDate: Date,
      refundDate: Date
    },
    royaltyRate: {
      type: Number, // 百分比
      default: 0
    },
    marketingFeeRate: {
      type: Number, // 百分比
      default: 0
    },
    settlementAccount: {
      bankName: String,
      accountName: String,
      accountNumber: String,
      swiftCode: String
    }
  },
  
  // 运营信息
  operationalInfo: {
    authorizedStores: {
      type: Number,
      default: 1
    },
    operatingStores: {
      type: Number,
      default: 0
    },
    plannedStores: {
      type: Number,
      default: 0
    },
    territoryRestriction: {
      enabled: {
        type: Boolean,
        default: false
      },
      provinces: [String],
      cities: [String],
      exclusiveRadius: Number // 独家经营半径（米）
    },
    performanceTargets: {
      annualRevenue: Number,
      monthlyOrders: Number,
      customerSatisfaction: Number
    }
  },
  
  // 培训与支持
  supportInfo: {
    trainingCompleted: {
      initial: {
        type: Boolean,
        default: false
      },
      advanced: {
        type: Boolean,
        default: false
      },
      lastTrainingDate: Date
    },
    assignedSupport: {
      managerId: {
        type: Schema.Types.ObjectId,
        ref: 'User'
      },
      managerName: String,
      managerPhone: String,
      managerEmail: String
    },
    supportLevel: {
      type: String,
      enum: ['basic', 'standard', 'premium', 'vip'],
      default: 'standard'
    }
  },
  
  // 门店信息
  stores: [{
    type: Schema.Types.ObjectId,
    ref: 'Store'
  }],
  
  // 绩效评估
  performance: {
    rating: {
      type: Number,
      min: 0,
      max: 5,
      default: 0
    },
    lastEvaluationDate: Date,
    evaluationHistory: [{
      date: Date,
      rating: Number,
      evaluator: String,
      comments: String,
      metrics: {
        revenue: Number,
        customerSatisfaction: Number,
        operationalCompliance: Number,
        brandStandards: Number
      }
    }],
    warnings: [{
      date: Date,
      type: {
        type: String,
        enum: ['performance', 'compliance', 'payment', 'quality']
      },
      description: String,
      resolved: {
        type: Boolean,
        default: false
      },
      resolvedDate: Date
    }]
  },
  
  // 状态信息
  status: {
    type: String,
    required: true,
    enum: ['pending', 'active', 'suspended', 'terminated', 'expired'],
    default: 'pending',
    index: true
  },
  
  verificationStatus: {
    type: String,
    enum: ['pending', 'verified', 'rejected'],
    default: 'pending'
  },
  
  suspensionInfo: {
    suspended: {
      type: Boolean,
      default: false
    },
    suspendedDate: Date,
    suspensionReason: String,
    expectedResolutionDate: Date
  },
  
  terminationInfo: {
    terminated: {
      type: Boolean,
      default: false
    },
    terminatedDate: Date,
    terminationReason: String,
    terminatedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    }
  },
  
  // 备注和标签
  notes: [{
    date: Date,
    author: String,
    content: String,
    type: {
      type: String,
      enum: ['general', 'financial', 'operational', 'complaint']
    }
  }],
  
  tags: [String],
  
  // 系统字段
  createdBy: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  
  updatedBy: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  }
}, {
  timestamps: true,
  collection: 'franchises'
});

// 索引
franchiseSchema.index({ restaurantId: 1, status: 1 });
franchiseSchema.index({ 'contractInfo.expiryDate': 1 });
franchiseSchema.index({ 'franchiseInfo.registrationNumber': 1 });
franchiseSchema.index({ 'operationalInfo.territoryRestriction.cities': 1 });

// 虚拟字段 - 合同是否有效
franchiseSchema.virtual('isContractValid').get(function() {
  const now = new Date();
  return this.contractInfo.effectiveDate <= now && 
         this.contractInfo.expiryDate >= now &&
         this.status === 'active';
});

// 虚拟字段 - 合同剩余天数
franchiseSchema.virtual('contractDaysRemaining').get(function() {
  const now = new Date();
  const expiryDate = new Date(this.contractInfo.expiryDate);
  const diffTime = expiryDate - now;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  return diffDays > 0 ? diffDays : 0;
});

// 虚拟字段 - 是否需要续约
franchiseSchema.virtual('needsRenewal').get(function() {
  return this.contractDaysRemaining <= 90 && this.contractDaysRemaining > 0;
});

// 实例方法 - 验证加盟商
franchiseSchema.methods.verify = function() {
  this.verificationStatus = 'verified';
  this.status = 'active';
  return this.save();
};

// 实例方法 - 拒绝加盟商
franchiseSchema.methods.reject = function(reason) {
  this.verificationStatus = 'rejected';
  this.status = 'terminated';
  this.terminationInfo = {
    terminated: true,
    terminatedDate: new Date(),
    terminationReason: reason
  };
  return this.save();
};

// 实例方法 - 暂停加盟商
franchiseSchema.methods.suspend = function(reason, expectedResolutionDate) {
  this.status = 'suspended';
  this.suspensionInfo = {
    suspended: true,
    suspendedDate: new Date(),
    suspensionReason: reason,
    expectedResolutionDate
  };
  return this.save();
};

// 实例方法 - 恢复加盟商
franchiseSchema.methods.resume = function() {
  this.status = 'active';
  this.suspensionInfo.suspended = false;
  return this.save();
};

// 实例方法 - 终止合同
franchiseSchema.methods.terminate = function(reason, terminatedBy) {
  this.status = 'terminated';
  this.terminationInfo = {
    terminated: true,
    terminatedDate: new Date(),
    terminationReason: reason,
    terminatedBy
  };
  return this.save();
};

// 实例方法 - 添加备注
franchiseSchema.methods.addNote = function(author, content, type = 'general') {
  this.notes.push({
    date: new Date(),
    author,
    content,
    type
  });
  return this.save();
};

// 实例方法 - 添加警告
franchiseSchema.methods.addWarning = function(type, description) {
  this.performance.warnings.push({
    date: new Date(),
    type,
    description,
    resolved: false
  });
  return this.save();
};

// 实例方法 - 更新绩效评估
franchiseSchema.methods.updatePerformance = function(rating, evaluator, comments, metrics) {
  this.performance.rating = rating;
  this.performance.lastEvaluationDate = new Date();
  this.performance.evaluationHistory.push({
    date: new Date(),
    rating,
    evaluator,
    comments,
    metrics
  });
  
  // 只保留最近12次评估记录
  if (this.performance.evaluationHistory.length > 12) {
    this.performance.evaluationHistory = this.performance.evaluationHistory.slice(-12);
  }
  
  return this.save();
};

// 静态方法 - 生成加盟商编码
franchiseSchema.statics.generateFranchiseCode = async function(restaurantId) {
  const count = await this.countDocuments({ restaurantId });
  const timestamp = Date.now().toString(36);
  return `FR_${restaurantId.toString().substr(-6)}_${count + 1}_${timestamp}`.toUpperCase();
};

// 静态方法 - 查找即将到期的合同
franchiseSchema.statics.findExpiringContracts = async function(days = 90) {
  const futureDate = new Date();
  futureDate.setDate(futureDate.getDate() + days);
  
  return this.find({
    status: 'active',
    'contractInfo.expiryDate': {
      $gte: new Date(),
      $lte: futureDate
    },
    'contractInfo.autoRenewal': false
  }).populate('restaurantId', 'name');
};

// 静态方法 - 获取加盟商统计
franchiseSchema.statics.getFranchiseStats = async function(restaurantId) {
  const stats = await this.aggregate([
    {
      $match: {
        restaurantId: new mongoose.Types.ObjectId(restaurantId)
      }
    },
    {
      $group: {
        _id: '$status',
        count: { $sum: 1 },
        totalStores: { $sum: '$operationalInfo.operatingStores' },
        avgRating: { $avg: '$performance.rating' }
      }
    },
    {
      $group: {
        _id: null,
        statusBreakdown: {
          $push: {
            status: '$_id',
            count: '$count',
            totalStores: '$totalStores',
            avgRating: '$avgRating'
          }
        },
        totalFranchises: { $sum: '$count' },
        totalStores: { $sum: '$totalStores' }
      }
    }
  ]);
  
  return stats[0] || {
    statusBreakdown: [],
    totalFranchises: 0,
    totalStores: 0
  };
};

// 中间件 - 保存前验证
franchiseSchema.pre('save', function(next) {
  // 验证合同日期
  if (this.contractInfo.effectiveDate > this.contractInfo.expiryDate) {
    return next(new Error('Contract effective date must be before expiry date'));
  }
  
  // 自动更新状态
  if (this.contractInfo.expiryDate < new Date() && this.status === 'active') {
    this.status = 'expired';
  }
  
  next();
});

// 转换选项
franchiseSchema.set('toJSON', {
  virtuals: true,
  transform: function(doc, ret) {
    delete ret._id;
    delete ret.__v;
    // 隐藏敏感财务信息
    if (ret.financialInfo?.settlementAccount) {
      ret.financialInfo.settlementAccount.accountNumber = '****' + 
        ret.financialInfo.settlementAccount.accountNumber?.substr(-4);
    }
    return ret;
  }
});

const Franchise = mongoose.model('Franchise', franchiseSchema);

module.exports = Franchise;