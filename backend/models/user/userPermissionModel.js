const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

/**
 * 用户权限模型
 * 用于管理用户的特殊权限，如商家权限、营养师权限等
 */
const userPermissionSchema = new mongoose.Schema({
  // 用户ID
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 权限类型
  permissionType: {
    type: String,
    enum: ['merchant', 'nutritionist'],
    required: true
  },
  
  // 权限状态
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'revoked'],
    default: 'pending'
  },
  
  // 授权信息
  grantedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin'
  },
  
  grantedAt: {
    type: Date
  },
  
  // 申请信息
  applicationData: {
    // 申请原因
    reason: String,
    // 联系方式
    contactInfo: {
      phone: String,
      email: String,
      wechat: String
    },
    // 相关资质描述
    qualifications: String,
    // 申请时间
    appliedAt: {
      type: Date,
      default: Date.now
    }
  },
  
  // 审核信息
  reviewData: {
    // 审核意见
    reviewComment: String,
    // 审核时间
    reviewedAt: Date,
    // 审核人
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin'
    }
  },
  
  // 权限有效期（可选）
  expiresAt: Date,
  
  // 备注
  remark: String
}, {
  timestamps: true
});

// 复合索引
userPermissionSchema.index({ userId: 1, permissionType: 1 }, { unique: true });
userPermissionSchema.index({ status: 1, permissionType: 1 });
userPermissionSchema.index({ grantedBy: 1 });

// 实例方法：授予权限
userPermissionSchema.methods.grant = function(adminId, comment = '') {
  this.status = 'approved';
  this.grantedBy = adminId;
  this.grantedAt = new Date();
  this.reviewData = {
    reviewComment: comment,
    reviewedAt: new Date(),
    reviewedBy: adminId
  };
  return this.save();
};

// 实例方法：拒绝权限
userPermissionSchema.methods.reject = function(adminId, comment = '') {
  this.status = 'rejected';
  this.reviewData = {
    reviewComment: comment,
    reviewedAt: new Date(),
    reviewedBy: adminId
  };
  return this.save();
};

// 实例方法：撤销权限
userPermissionSchema.methods.revoke = function(adminId, comment = '') {
  this.status = 'revoked';
  this.reviewData = {
    reviewComment: comment,
    reviewedAt: new Date(),
    reviewedBy: adminId
  };
  return this.save();
};

// 静态方法：检查用户是否有特定权限
userPermissionSchema.statics.hasPermission = async function(userId, permissionType) {
  const permission = await this.findOne({
    userId,
    permissionType,
    status: 'approved',
    $or: [
      { expiresAt: { $exists: false } },
      { expiresAt: null },
      { expiresAt: { $gt: new Date() } }
    ]
  });
  return !!permission;
};

// 静态方法：获取用户的所有有效权限
userPermissionSchema.statics.getUserPermissions = async function(userId) {
  const permissions = await this.find({
    userId,
    status: 'approved',
    $or: [
      { expiresAt: { $exists: false } },
      { expiresAt: null },
      { expiresAt: { $gt: new Date() } }
    ]
  });
  return permissions.map(p => p.permissionType);
};

// 静态方法：获取待审核的权限申请
userPermissionSchema.statics.getPendingApplications = async function(permissionType = null) {
  const query = { status: 'pending' };
  if (permissionType) {
    query.permissionType = permissionType;
  }
  
  return this.find(query)
    .populate('userId', 'username email profile')
    .sort({ createdAt: -1 });
};

// 静态方法：批量授予权限
userPermissionSchema.statics.batchGrant = async function(permissionIds, adminId, comment = '') {
  const result = await this.updateMany(
    { _id: { $in: permissionIds }, status: 'pending' },
    {
      $set: {
        status: 'approved',
        grantedBy: adminId,
        grantedAt: new Date(),
        'reviewData.reviewComment': comment,
        'reviewData.reviewedAt': new Date(),
        'reviewData.reviewedBy': adminId
      }
    }
  );
  return result;
};

// 使用ModelFactory创建模型
const UserPermission = ModelFactory.createModel('UserPermission', userPermissionSchema);

module.exports = UserPermission;