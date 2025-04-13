const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

const nutritionistSchema = new mongoose.Schema({
  // 关联到用户
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  // 个人信息
  personalInfo: {
    realName: {
      type: String,
      required: true
    },
    idCardNumber: {
      type: String,
      required: true
    }
  },
  // 专业资质
  qualifications: {
    licenseNumber: {
      type: String,
      required: true
    },
    licenseImageUrl: String,
    certificationImages: [{
      type: String // URL references to certification documents
    }],
    professionalTitle: {
      type: String,
      enum: ['初级营养师', '中级营养师', '高级营养师', '营养顾问']
    },
    certificationLevel: {
      type: String,
      enum: ['junior', 'intermediate', 'senior', 'expert']
    },
    issuingAuthority: String,
    issueDate: Date,
    expiryDate: Date,
    verified: {
      type: Boolean,
      default: false
    }
  },
  // 专业信息
  professionalInfo: {
    specializations: [{
      type: String,
      enum: ['weightManagement', 'sportsNutrition', 'diabetes', 'prenatal', 'pediatric', 'geriatric', 'eatingDisorders', 'heartHealth', 'digestiveHealth', 'foodAllergies']
    }],
    experienceYears: {
      type: Number,
      min: 0
    },
    education: [{
      degree: String,
      institution: String,
      year: Number,
      major: String
    }],
    languages: [{
      type: String
    }],
    bio: {
      type: String,
      maxlength: 1000
    }
  },
  // 服务信息
  serviceInfo: {
    consultationFee: {
      type: Number,
      min: 0
    },
    consultationDuration: {
      type: Number, // 分钟
      default: 60
    },
    availableOnline: {
      type: Boolean,
      default: true
    },
    availableInPerson: {
      type: Boolean,
      default: false
    },
    inPersonLocations: [{
      name: String,
      address: String,
      city: String,
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    }],
    serviceTags: [{
      type: String
    }],
    availableTimeSlots: [{
      day: {
        type: String,
        enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      },
      slots: [{
        startTime: String, // format: "HH:MM"
        endTime: String     // format: "HH:MM"
      }]
    }]
  },
  // 营养师评价
  ratings: {
    averageRating: {
      type: Number,
      min: 0,
      max: 5,
      default: 0
    },
    totalReviews: {
      type: Number,
      default: 0
    }
  },
  // 营养师状态
  status: {
    type: String,
    enum: ['active', 'inactive', 'suspended', 'pendingVerification'],
    default: 'pendingVerification'
  },
  // 审核信息
  verification: {
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending'
    },
    rejectedReason: String,
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin'
    },
    reviewedAt: Date
  },
  // 工作关联
  affiliations: [{
    organizationType: {
      type: String,
      enum: ['hospital', 'clinic', 'gym', 'restaurant', 'school', 'university', 'company', 'independent']
    },
    organizationName: String,
    organizationId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'affiliations.organizationType'
    },
    position: String,
    startDate: Date,
    endDate: Date,
    current: {
      type: Boolean,
      default: true
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