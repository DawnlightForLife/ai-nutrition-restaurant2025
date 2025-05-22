const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

const nutritionistSchema = new mongoose.Schema({
  // 关联到用户
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    description: '关联用户 ID'
  },
  // 个人信息
  personalInfo: {
    realName: {
      type: String,
      required: true,
      description: '真实姓名'
    },
    idCardNumber: {
      type: String,
      required: true,
      description: '身份证号码'
    }
  },
  // 专业资质
  qualifications: {
    licenseNumber: {
      type: String,
      required: true,
      description: '营养师执业证编号'
    },
    licenseImageUrl: {
      type: String,
      description: '证书照片 URL'
    },
    certificationImages: [{
      type: String, // URL references to certification documents
      description: '其他资格证书 URL 列表'
    }],
    professionalTitle: {
      type: String,
      enum: ['初级营养师', '中级营养师', '高级营养师', '营养顾问'],
      description: '专业职称（中文）'
    },
    certificationLevel: {
      type: String,
      enum: ['junior', 'intermediate', 'senior', 'expert'],
      description: '专业等级（英文）'
    },
    issuingAuthority: {
      type: String,
      description: '发证机构'
    },
    issueDate: {
      type: Date,
      description: '发证日期'
    },
    expiryDate: {
      type: Date,
      description: '有效截止日期'
    },
    verified: {
      type: Boolean,
      default: false,
      description: '是否已验证'
    }
  },
  // 专业信息
  professionalInfo: {
    specializations: [{
      type: String,
      enum: ['weightManagement', 'sportsNutrition', 'diabetes', 'prenatal', 'pediatric', 'geriatric', 'eatingDisorders', 'heartHealth', 'digestiveHealth', 'foodAllergies'],
      description: '擅长领域'
    }],
    experienceYears: {
      type: Number,
      min: 0,
      description: '从业年限'
    },
    education: [{
      degree: {
        type: String,
        description: '学历学位'
      },
      institution: {
        type: String,
        description: '毕业院校'
      },
      year: {
        type: Number,
        description: '毕业年份'
      },
      major: {
        type: String,
        description: '专业'
      }
    }],
    languages: [{
      type: String,
      description: '擅长语言'
    }],
    bio: {
      type: String,
      maxlength: 1000,
      description: '个人简介'
    }
  },
  // 服务信息
  serviceInfo: {
    consultationFee: {
      type: Number,
      min: 0,
      description: '咨询费用'
    },
    consultationDuration: {
      type: Number, // 分钟
      default: 60,
      description: '咨询时长（分钟）'
    },
    availableOnline: {
      type: Boolean,
      default: true,
      description: '是否支持线上咨询'
    },
    availableInPerson: {
      type: Boolean,
      default: false,
      description: '是否支持线下咨询'
    },
    inPersonLocations: [{
      name: {
        type: String,
        description: '线下服务点名称'
      },
      address: {
        type: String,
        description: '地址'
      },
      city: {
        type: String,
        description: '城市'
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
    }],
    serviceTags: [{
      type: String,
      description: '服务标签'
    }],
    availableTimeSlots: [{
      day: {
        type: String,
        enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
        description: '星期'
      },
      slots: [{
        startTime: {
          type: String, // format: "HH:MM"
          description: '开始时间'
        },
        endTime: {
          type: String,     // format: "HH:MM"
          description: '结束时间'
        }
      }]
    }]
  },
  // 营养师评价
  ratings: {
    averageRating: {
      type: Number,
      min: 0,
      max: 5,
      default: 0,
      description: '平均评分'
    },
    totalReviews: {
      type: Number,
      default: 0,
      description: '评论数量'
    }
  },
  // 营养师状态
  status: {
    type: String,
    enum: ['active', 'inactive', 'suspended', 'pendingVerification'],
    default: 'pendingVerification',
    description: '营养师状态'
  },
  // 审核信息
  verification: {
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
      description: '审核状态'
    },
    rejectedReason: {
      type: String,
      description: '驳回理由'
    },
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      description: '审核人'
    },
    reviewedAt: {
      type: Date,
      description: '审核时间'
    },
    // 审核历史记录
    verificationHistory: [{
      status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        required: true
      },
      reason: {
        type: String,
        description: '操作原因或驳回理由'
      },
      changedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Admin',
        description: '操作者'
      },
      changedAt: {
        type: Date,
        default: Date.now,
        description: '变更时间'
      }
    }]
  },
  // 工作关联
  affiliations: [{
    organizationType: {
      type: String,
      enum: ['hospital', 'clinic', 'gym', 'restaurant', 'school', 'university', 'company', 'independent', 'maternityCenter', 'schoolCompany'],
      description: '所属机构类型'
    },
    organizationName: {
      type: String,
      description: '机构名称'
    },
    organizationId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'affiliations.organizationType',
      description: '机构 ID'
    },
    position: {
      type: String,
      description: '职位'
    },
    startDate: {
      type: Date,
      description: '入职日期'
    },
    endDate: {
      type: Date,
      description: '离职日期'
    },
    current: {
      type: Boolean,
      default: true,
      description: '是否当前任职'
    }
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引
nutritionistSchema.index({ userId: 1 }, { unique: true });
nutritionistSchema.index({ 'qualifications.licenseNumber': 1 }, { unique: true });
nutritionistSchema.index({ 'personalInfo.idCardNumber': 1 }, { unique: true });
nutritionistSchema.index({ 'professionalInfo.specializations': 1 });
nutritionistSchema.index({ 'serviceInfo.consultationFee': 1 });
nutritionistSchema.index({ 'serviceInfo.serviceTags': 1 });
nutritionistSchema.index({ 'ratings.averageRating': -1 });
nutritionistSchema.index({ status: 1 });
nutritionistSchema.index({ 'verification.verificationStatus': 1 });
nutritionistSchema.index({ 'serviceInfo.inPersonLocations.city': 1 });

// 虚拟字段
nutritionistSchema.virtual('isLicenseValid').get(function() {
  if (!this.qualifications.expiryDate) return null;
  return new Date(this.qualifications.expiryDate) > new Date();
});

nutritionistSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
nutritionistSchema.methods.getPublicProfile = function() {
  return {
    id: this._id,
    userId: this.userId,
    specializations: this.professionalInfo.specializations,
    experienceYears: this.professionalInfo.experienceYears,
    bio: this.professionalInfo.bio,
    languages: this.professionalInfo.languages,
    consultationFee: this.serviceInfo.consultationFee,
    consultationDuration: this.serviceInfo.consultationDuration,
    availableOnline: this.serviceInfo.availableOnline,
    availableInPerson: this.serviceInfo.availableInPerson,
    serviceTags: this.serviceInfo.serviceTags || [],
    averageRating: this.ratings.averageRating,
    totalReviews: this.ratings.totalReviews,
    certifications: this.qualifications.certificationImages || []
  };
};

nutritionistSchema.methods.isQualifiedFor = function(specialization) {
  return this.professionalInfo.specializations.includes(specialization);
};

// 静态方法
nutritionistSchema.statics.findBySpecialization = function(specialization) {
  return this.find({
    'professionalInfo.specializations': specialization,
    status: 'active'
  });
};

nutritionistSchema.statics.findTopRated = function(limit = 10) {
  return this.find({ status: 'active' })
    .sort({ 'ratings.averageRating': -1 })
    .limit(limit);
};

// 中间件
nutritionistSchema.pre('save', function(next) {
  // 验证资质有效性
  if (this.qualifications.expiryDate && 
      new Date(this.qualifications.expiryDate) < new Date()) {
    this.status = 'inactive';
  }
  next();
});

// 创建模型并导出
const Nutritionist = ModelFactory.createModel('Nutritionist', nutritionistSchema);
module.exports = Nutritionist;