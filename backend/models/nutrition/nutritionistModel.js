const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

const nutritionistSchema = new mongoose.Schema({
  // 关联到用户
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  // 专业资质
  qualifications: {
    license_number: {
      type: String,
      required: true
    },
    license_image_url: String,
    certification_level: {
      type: String,
      enum: ['junior', 'intermediate', 'senior', 'expert']
    },
    issuing_authority: String,
    issue_date: Date,
    expiry_date: Date,
    verified: {
      type: Boolean,
      default: false
    }
  },
  // 专业信息
  professional_info: {
    specializations: [{
      type: String,
      enum: ['weight_management', 'sports_nutrition', 'diabetes', 'prenatal', 'pediatric', 'geriatric', 'eating_disorders', 'heart_health', 'digestive_health', 'food_allergies']
    }],
    experience_years: {
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
  service_info: {
    consultation_fee: {
      type: Number,
      min: 0
    },
    consultation_duration: {
      type: Number, // 分钟
      default: 60
    },
    available_online: {
      type: Boolean,
      default: true
    },
    available_in_person: {
      type: Boolean,
      default: false
    },
    in_person_locations: [{
      name: String,
      address: String,
      city: String,
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    }]
  },
  // 营养师评价
  ratings: {
    average_rating: {
      type: Number,
      min: 0,
      max: 5,
      default: 0
    },
    total_reviews: {
      type: Number,
      default: 0
    }
  },
  // 营养师状态
  status: {
    type: String,
    enum: ['active', 'inactive', 'suspended', 'pending_verification'],
    default: 'pending_verification'
  },
  // 工作关联
  affiliations: [{
    organization_type: {
      type: String,
      enum: ['hospital', 'clinic', 'gym', 'restaurant', 'school', 'university', 'company', 'independent']
    },
    organization_name: String,
    organization_id: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'affiliations.organization_type'
    },
    position: String,
    start_date: Date,
    end_date: Date,
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
nutritionistSchema.index({ user_id: 1 }, { unique: true });
nutritionistSchema.index({ 'qualifications.license_number': 1 }, { unique: true });
nutritionistSchema.index({ 'professional_info.specializations': 1 });
nutritionistSchema.index({ 'service_info.consultation_fee': 1 });
nutritionistSchema.index({ 'ratings.average_rating': -1 });
nutritionistSchema.index({ status: 1 });
nutritionistSchema.index({ 'service_info.in_person_locations.city': 1 });

// 虚拟字段
nutritionistSchema.virtual('is_license_valid').get(function() {
  if (!this.qualifications.expiry_date) return null;
  return new Date(this.qualifications.expiry_date) > new Date();
});

nutritionistSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

// 实例方法
nutritionistSchema.methods.getPublicProfile = function() {
  return {
    id: this._id,
    user_id: this.user_id,
    specializations: this.professional_info.specializations,
    experience_years: this.professional_info.experience_years,
    bio: this.professional_info.bio,
    languages: this.professional_info.languages,
    consultation_fee: this.service_info.consultation_fee,
    consultation_duration: this.service_info.consultation_duration,
    available_online: this.service_info.available_online,
    available_in_person: this.service_info.available_in_person,
    average_rating: this.ratings.average_rating,
    total_reviews: this.ratings.total_reviews
  };
};

nutritionistSchema.methods.isQualifiedFor = function(specialization) {
  return this.professional_info.specializations.includes(specialization);
};

// 静态方法
nutritionistSchema.statics.findBySpecialization = function(specialization) {
  return this.find({
    'professional_info.specializations': specialization,
    status: 'active'
  });
};

nutritionistSchema.statics.findTopRated = function(limit = 10) {
  return this.find({ status: 'active' })
    .sort({ 'ratings.average_rating': -1 })
    .limit(limit);
};

// 中间件
nutritionistSchema.pre('save', function(next) {
  // 验证资质有效性
  if (this.qualifications.expiry_date && 
      new Date(this.qualifications.expiry_date) < new Date()) {
    this.status = 'inactive';
  }
  next();
});

// 创建模型并导出
const Nutritionist = ModelFactory.createModel('Nutritionist', nutritionistSchema);
module.exports = Nutritionist; 