/**
 * 营养师认证申请模型
 * 用于存储营养师资质认证申请的相关信息
 * 支持多种认证等级和专业领域
 */

const mongoose = require('mongoose');
const { nutritionistTypes } = require('../../constants');
const DataEncryption = require('../../utils/encryption');
const logger = require('../../config/modules/logger');

// 个人信息子Schema（超简化版 - 仅实名认证）
const personalInfoSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: [true, '请填写真实姓名'],
    trim: true,
    maxlength: [50, '姓名长度不能超过50个字符'],
    sensitivityLevel: 2,
    description: '申请人真实姓名'
  },
  
  idNumber: {
    type: String,
    required: [true, '请填写身份证号码'],
    validate: {
      validator: function(value) {
        // 如果值包含':'，说明已经是加密的，跳过验证
        if (value && value.includes(':')) {
          return true;
        }
        // 身份证号码格式验证（验证加密前的原始值）
        return /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/.test(value);
      },
      message: '请填写有效的身份证号码'
    },
    set: function(value) {
      // 保存时自动加密
      if (value && typeof value === 'string' && !value.includes(':')) {
        // 只有当值不包含':'时才认为是未加密的（因为加密后的值包含':'分隔符）
        return DataEncryption.encrypt(value);
      }
      return value;
    },
    sensitivityLevel: 3,
    description: '申请人身份证号码（加密存储）'
  },

  // 添加身份证号码哈希，用于唯一性检查
  idNumberHash: {
    type: String,
    unique: true,
    description: '身份证号码哈希值，用于唯一性验证'
  },
  
  phone: {
    type: String,
    required: [true, '请填写手机号码'],
    validate: {
      validator: function(value) {
        return /^1[3-9]\d{9}$/.test(value);
      },
      message: '请填写有效的手机号码'
    },
    sensitivityLevel: 2,
    description: '申请人联系电话'
  }
}, { _id: false });


// 认证申请信息子Schema（超简化版）
const certificationInfoSchema = new mongoose.Schema({
  specializationAreas: [{
    type: String,
    enum: {
      values: Object.keys(nutritionistTypes.SPECIALIZATION_AREAS).map(key => 
        nutritionistTypes.SPECIALIZATION_AREAS[key].value
      ),
      message: '请选择有效的专业领域'
    },
    sensitivityLevel: 1,
    description: '专业特长领域（1-2个）'
  }],
  
  workYearsInNutrition: {
    type: Number,
    required: [true, '请填写营养相关工作年限'],
    min: [0, '工作年限不能小于0'],
    max: [50, '工作年限不能超过50年'],
    sensitivityLevel: 1,
    description: '营养相关工作年限'
  }
}, { _id: false });

// 上传文件子Schema
const uploadedDocumentSchema = new mongoose.Schema({
  documentType: {
    type: String,
    required: [true, '请指定文档类型'],
    enum: {
      values: ['nutrition_certificate', 'id_card', 'training_certificate', 'other_materials'],
      message: '请选择有效的文档类型'
    },
    sensitivityLevel: 1,
    description: '文档类型'
  },
  
  fileName: {
    type: String,
    required: [true, '文件名不能为空'],
    maxlength: [255, '文件名不能超过255个字符'],
    sensitivityLevel: 1,
    description: '原始文件名'
  },
  
  fileUrl: {
    type: String,
    required: [true, '文件URL不能为空'],
    sensitivityLevel: 2,
    description: '文件存储URL'
  },
  
  fileSize: {
    type: Number,
    required: [true, '文件大小不能为空'],
    max: [10485760, '文件大小不能超过10MB'], // 10MB = 10 * 1024 * 1024
    sensitivityLevel: 1,
    description: '文件大小(字节)'
  },
  
  mimeType: {
    type: String,
    required: [true, '文件类型不能为空'],
    sensitivityLevel: 1,
    description: 'MIME类型'
  },
  
  uploadedAt: {
    type: Date,
    default: Date.now,
    sensitivityLevel: 1,
    description: '上传时间'
  },
  
  verified: {
    type: Boolean,
    default: false,
    sensitivityLevel: 1,
    description: '文档是否已验证'
  }
}, { _id: false });

// 审核信息子Schema
const reviewInfoSchema = new mongoose.Schema({
  status: {
    type: String,
    required: true,
    enum: {
      values: Object.keys(nutritionistTypes.CERTIFICATION_STATUS).map(key => 
        nutritionistTypes.CERTIFICATION_STATUS[key].value
      ),
      message: '请选择有效的审核状态'
    },
    default: 'draft',
    sensitivityLevel: 1,
    description: '当前审核状态'
  },
  
  submittedAt: {
    type: Date,
    sensitivityLevel: 1,
    description: '提交时间'
  },
  
  reviewedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    sensitivityLevel: 2,
    description: '审核人员ID'
  },
  
  reviewedAt: {
    type: Date,
    sensitivityLevel: 1,
    description: '审核时间'
  },
  
  reviewNotes: {
    type: String,
    maxlength: [2000, '审核备注不能超过2000个字符'],
    sensitivityLevel: 2,
    description: '审核备注'
  },
  
  rejectionReason: {
    type: String,
    maxlength: [1000, '拒绝原因不能超过1000个字符'],
    sensitivityLevel: 2,
    description: '拒绝原因'
  },
  
  approvalValidUntil: {
    type: Date,
    sensitivityLevel: 1,
    description: '认证有效期至'
  },
  
  resubmissionCount: {
    type: Number,
    default: 0,
    min: [0, '重新提交次数不能小于0'],
    sensitivityLevel: 1,
    description: '重新提交次数'
  },
  
  lastResubmissionDate: {
    type: Date,
    sensitivityLevel: 1,
    description: '最后重新提交时间'
  }
}, { _id: false });

// 主Schema定义
const nutritionistCertificationSchema = new mongoose.Schema({
  // 关联用户ID
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, '用户ID不能为空'],
    index: true,
    sensitivityLevel: 2,
    description: '申请用户ID'
  },
  
  // 申请编号（自动生成）
  applicationNumber: {
    type: String,
    unique: true,
    sensitivityLevel: 1,
    description: '申请编号'
  },
  
  // 个人信息
  personalInfo: {
    type: personalInfoSchema,
    required: [true, '个人信息不能为空'],
    sensitivityLevel: 2,
    description: '申请人个人信息'
  },
  
  
  // 认证申请信息
  certificationInfo: {
    type: certificationInfoSchema,
    required: [true, '认证信息不能为空'],
    sensitivityLevel: 1,
    description: '认证申请相关信息'
  },
  
  // 上传的文档
  documents: {
    type: [uploadedDocumentSchema],
    validate: {
      validator: function(documents) {
        // 简化验证逻辑，避免复杂查找操作
        if (!documents || documents.length === 0) {
          return false; // 至少需要一个文档
        }
        
        // 检查是否有营养师证书（必需文档）
        const hasNutritionCert = documents.some(doc => doc.documentType === 'nutrition_certificate');
        return hasNutritionCert;
      },
      message: '请至少上传营养师资格证书'
    },
    sensitivityLevel: 2,
    description: '上传的证件文档'
  },
  
  // 审核信息
  review: {
    type: reviewInfoSchema,
    default: () => ({ status: 'draft' }),
    sensitivityLevel: 2,
    description: '审核相关信息'
  }
}, {
  timestamps: true,
  versionKey: false
});

// 创建高效的复合索引
nutritionistCertificationSchema.index({ userId: 1, 'review.status': 1 });
nutritionistCertificationSchema.index({ 'personalInfo.idNumberHash': 1 }, { unique: true, sparse: true }); // 使用哈希值确保唯一性
nutritionistCertificationSchema.index({ applicationNumber: 1 }, { unique: true });
nutritionistCertificationSchema.index({ 'review.submittedAt': -1 });
nutritionistCertificationSchema.index({ 'certificationInfo.targetLevel': 1 });
nutritionistCertificationSchema.index({ createdAt: -1 }); // 添加创建时间索引以提高查询性能

// 优化的敏感数据处理
nutritionistCertificationSchema.pre('save', function(next) {
  try {
    // 只在身份证号码修改时处理，避免不必要的加解密操作
    if (this.personalInfo && this.personalInfo.idNumber && this.isModified('personalInfo.idNumber')) {
      let originalIdNumber = this.personalInfo.idNumber;
      
      // 检查是否已经是加密格式（包含':'分隔符）
      const isEncrypted = originalIdNumber.includes(':');
      
      if (isEncrypted) {
        try {
          originalIdNumber = DataEncryption.decrypt(originalIdNumber);
        } catch (error) {
          logger.warn('身份证号码解密失败，可能是格式问题', { error: error.message });
          // 如果解密失败，假设是原始值
        }
      }
      
      // 只有在哈希值不存在或身份证号码变更时才重新计算哈希
      if (!this.personalInfo.idNumberHash || this.isModified('personalInfo.idNumber')) {
        this.personalInfo.idNumberHash = DataEncryption.hash(originalIdNumber);
      }
    }
    next();
  } catch (error) {
    logger.error('敏感数据处理失败', error);
    next(error);
  }
});

// 高效的申请编号生成
nutritionistCertificationSchema.pre('save', async function(next) {
  if (!this.applicationNumber) {
    try {
      // 使用原子操作和时间戳确保唯一性，避免复杂查询
      const currentYear = new Date().getFullYear();
      const timestamp = Date.now().toString(36).toUpperCase(); // 时间戳转36进制
      const randomSuffix = Math.random().toString(36).substr(2, 4).toUpperCase();
      this.applicationNumber = `NC${currentYear}${timestamp}${randomSuffix}`;
      
      // 检查唯一性，如果冲突则重试（极小概率）
      const existing = await this.constructor.findOne({ applicationNumber: this.applicationNumber });
      if (existing) {
        // 添加额外随机数重试
        const extraRandom = Math.random().toString(36).substr(2, 2).toUpperCase();
        this.applicationNumber = `NC${currentYear}${timestamp}${randomSuffix}${extraRandom}`;
      }
    } catch (error) {
      logger.error('生成申请编号失败', error);
      return next(error);
    }
  }
  next();
});

// 提交申请时的验证
nutritionistCertificationSchema.pre('save', function(next) {
  if (this.review.status === 'pending' && !this.review.submittedAt) {
    this.review.submittedAt = new Date();
  }
  next();
});

// 实例方法：获取解密的身份证号码（仅用于业务逻辑，不对外暴露）
nutritionistCertificationSchema.methods.getDecryptedIdNumber = function() {
  try {
    if (this.personalInfo && this.personalInfo.idNumber) {
      return DataEncryption.decrypt(this.personalInfo.idNumber);
    }
  } catch (error) {
    // 解密失败，可能是未加密的原始值
    return this.personalInfo.idNumber;
  }
  return null;
};

// 实例方法：获取脱敏的身份证号码（用于显示）
nutritionistCertificationSchema.methods.getMaskedIdNumber = function() {
  try {
    const originalIdNumber = this.getDecryptedIdNumber();
    return originalIdNumber ? DataEncryption.mask(originalIdNumber, 'idNumber') : '';
  } catch (error) {
    return '****';
  }
};

// 实例方法：检查是否满足申请条件（超简化版）
nutritionistCertificationSchema.methods.checkEligibility = function() {
  const workYears = this.certificationInfo.workYearsInNutrition;
  const hasSpecialization = this.certificationInfo.specializationAreas && this.certificationInfo.specializationAreas.length > 0;
  const hasRequiredDocument = this.documents && this.documents.some(doc => doc.documentType === 'nutrition_certificate');
  
  // 超简化的资格检查：工作经验 + 专业方向 + 证书上传
  return workYears >= 0 && hasSpecialization && hasRequiredDocument;
};

// 实例方法：获取认证等级标签
nutritionistCertificationSchema.methods.getCertificationLevelLabel = function() {
  const level = this.certificationInfo.targetLevel;
  return nutritionistTypes.CERTIFICATION_LEVELS[level.toUpperCase()]?.label || level;
};

// 实例方法：获取状态标签
nutritionistCertificationSchema.methods.getStatusLabel = function() {
  const status = this.review.status;
  return nutritionistTypes.CERTIFICATION_STATUS[status.toUpperCase()]?.label || status;
};

// 静态方法：获取用户的认证申请
nutritionistCertificationSchema.statics.findByUserId = function(userId) {
  return this.find({ userId }).sort({ createdAt: -1 });
};

// 静态方法：获取待审核申请
nutritionistCertificationSchema.statics.findPendingApplications = function() {
  return this.find({ 'review.status': 'pending' }).sort({ 'review.submittedAt': 1 });
};

module.exports = mongoose.model('NutritionistCertification', nutritionistCertificationSchema);