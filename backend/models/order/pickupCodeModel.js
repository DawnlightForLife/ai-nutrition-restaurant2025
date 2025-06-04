const mongoose = require('mongoose');
const { Schema, ObjectId } = mongoose;

const pickupCodeSchema = new Schema({
  // 取餐码（6位字母数字组合）
  code: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
    length: 6,
    match: /^[A-Z0-9]{6}$/,
    index: true
  },
  
  // 关联订单
  orderId: {
    type: ObjectId,
    ref: 'Order',
    required: true,
    index: true
  },
  
  // 订单号（冗余字段，便于查询）
  orderNumber: {
    type: String,
    required: true,
    index: true
  },
  
  // 门店信息
  storeId: {
    type: ObjectId,
    ref: 'Store',
    required: true,
    index: true
  },
  
  // 用户信息
  userId: {
    type: ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 取餐码状态
  status: {
    type: String,
    enum: ['active', 'used', 'expired', 'cancelled'],
    default: 'active',
    index: true
  },
  
  // 生成时间
  generatedAt: {
    type: Date,
    default: Date.now,
    index: true
  },
  
  // 过期时间（默认2小时后过期）
  expiresAt: {
    type: Date,
    default: () => new Date(Date.now() + 2 * 60 * 60 * 1000),
    index: true
  },
  
  // 使用记录
  usageRecord: {
    usedAt: Date,
    usedBy: { type: ObjectId, ref: 'User' }, // 门店员工
    verificationMethod: {
      type: String,
      enum: ['manual', 'qr_scan', 'voice_input'],
      default: 'manual'
    },
    deviceInfo: {
      deviceId: String,
      deviceType: String,
      ipAddress: String
    }
  },
  
  // 验证尝试记录
  verificationAttempts: [{
    timestamp: { type: Date, default: Date.now },
    inputCode: String,
    success: Boolean,
    ipAddress: String,
    userAgent: String,
    failureReason: String
  }],
  
  // 取餐人信息
  pickupPerson: {
    name: String,
    phone: String,
    isOriginalCustomer: { type: Boolean, default: true }
  },
  
  // 特殊说明
  specialNotes: String,
  
  // 通知状态
  notificationStatus: {
    smsNotified: { type: Boolean, default: false },
    emailNotified: { type: Boolean, default: false },
    appNotified: { type: Boolean, default: false },
    lastNotificationAt: Date
  }
}, {
  timestamps: true,
  collection: 'pickup_codes'
});

// 复合索引优化
pickupCodeSchema.index({ storeId: 1, status: 1, generatedAt: -1 });
pickupCodeSchema.index({ userId: 1, status: 1, generatedAt: -1 });
pickupCodeSchema.index({ code: 1, storeId: 1 });
pickupCodeSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// 生成唯一取餐码
pickupCodeSchema.statics.generateCode = async function() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let code;
  let isUnique = false;
  let attempts = 0;
  
  while (!isUnique && attempts < 10) {
    code = '';
    for (let i = 0; i < 6; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    
    // 避免容易混淆的字符组合
    if (!/[IL0O]/.test(code)) {
      const existing = await this.findOne({ code, status: { $in: ['active', 'used'] } });
      if (!existing) {
        isUnique = true;
      }
    }
    attempts++;
  }
  
  if (!isUnique) {
    throw new Error('无法生成唯一取餐码，请重试');
  }
  
  return code;
};

// 为订单创建取餐码
pickupCodeSchema.statics.createForOrder = async function(orderData) {
  const code = await this.generateCode();
  
  const pickupCode = new this({
    code,
    orderId: orderData.orderId,
    orderNumber: orderData.orderNumber,
    storeId: orderData.storeId,
    userId: orderData.userId,
    pickupPerson: {
      name: orderData.customerName,
      phone: orderData.customerPhone,
      isOriginalCustomer: true
    },
    specialNotes: orderData.specialNotes
  });
  
  return await pickupCode.save();
};

// 验证取餐码
pickupCodeSchema.statics.verifyCode = async function(code, storeId, options = {}) {
  const pickupCode = await this.findOne({
    code: code.toUpperCase(),
    storeId,
    status: 'active',
    expiresAt: { $gt: new Date() }
  }).populate('orderId userId');
  
  // 记录验证尝试
  const attempt = {
    inputCode: code,
    success: !!pickupCode,
    ipAddress: options.ipAddress,
    userAgent: options.userAgent,
    failureReason: !pickupCode ? (
      await this.findOne({ code: code.toUpperCase(), storeId }) ? 
      'code_expired_or_used' : 'code_not_found'
    ) : null
  };
  
  if (pickupCode) {
    pickupCode.verificationAttempts.push(attempt);
    await pickupCode.save();
  } else {
    // 即使验证失败也要记录尝试
    const existingCode = await this.findOne({ code: code.toUpperCase(), storeId });
    if (existingCode) {
      existingCode.verificationAttempts.push(attempt);
      await existingCode.save();
    }
  }
  
  return pickupCode;
};

// 使用取餐码
pickupCodeSchema.methods.markAsUsed = async function(staffUserId, options = {}) {
  if (this.status !== 'active') {
    throw new Error('取餐码已使用或已过期');
  }
  
  if (this.expiresAt <= new Date()) {
    throw new Error('取餐码已过期');
  }
  
  this.status = 'used';
  this.usageRecord = {
    usedAt: new Date(),
    usedBy: staffUserId,
    verificationMethod: options.verificationMethod || 'manual',
    deviceInfo: {
      deviceId: options.deviceId,
      deviceType: options.deviceType,
      ipAddress: options.ipAddress
    }
  };
  
  // 如果指定了代取人信息
  if (options.pickupPerson) {
    this.pickupPerson = {
      ...this.pickupPerson,
      ...options.pickupPerson,
      isOriginalCustomer: false
    };
  }
  
  return await this.save();
};

// 取消取餐码
pickupCodeSchema.methods.cancel = async function(reason) {
  this.status = 'cancelled';
  this.specialNotes = this.specialNotes ? 
    `${this.specialNotes}\n取消原因: ${reason}` : 
    `取消原因: ${reason}`;
  
  return await this.save();
};

// 延长过期时间
pickupCodeSchema.methods.extendExpiry = async function(additionalHours = 1) {
  if (this.status !== 'active') {
    throw new Error('只能延长有效取餐码的过期时间');
  }
  
  const newExpiryTime = new Date(this.expiresAt.getTime() + additionalHours * 60 * 60 * 1000);
  const maxExpiryTime = new Date(this.generatedAt.getTime() + 24 * 60 * 60 * 1000); // 最多24小时
  
  this.expiresAt = newExpiryTime > maxExpiryTime ? maxExpiryTime : newExpiryTime;
  this.specialNotes = this.specialNotes ? 
    `${this.specialNotes}\n延长有效期至: ${this.expiresAt.toLocaleString()}` : 
    `延长有效期至: ${this.expiresAt.toLocaleString()}`;
  
  return await this.save();
};

// 获取门店的活跃取餐码统计
pickupCodeSchema.statics.getStoreStats = async function(storeId, date = new Date()) {
  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);
  
  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);
  
  const stats = await this.aggregate([
    {
      $match: {
        storeId: new mongoose.Types.ObjectId(storeId),
        generatedAt: { $gte: startOfDay, $lte: endOfDay }
      }
    },
    {
      $group: {
        _id: '$status',
        count: { $sum: 1 },
        codes: { $push: '$code' }
      }
    }
  ]);
  
  const result = {
    total: 0,
    active: 0,
    used: 0,
    expired: 0,
    cancelled: 0
  };
  
  stats.forEach(stat => {
    result[stat._id] = stat.count;
    result.total += stat.count;
  });
  
  return result;
};

// 自动过期处理
pickupCodeSchema.pre('save', function(next) {
  if (this.status === 'active' && this.expiresAt <= new Date()) {
    this.status = 'expired';
  }
  next();
});

// 验证取餐码格式
pickupCodeSchema.pre('validate', function(next) {
  if (this.code && !/^[A-Z0-9]{6}$/.test(this.code)) {
    return next(new Error('取餐码必须是6位字母数字组合'));
  }
  next();
});

module.exports = mongoose.model('PickupCode', pickupCodeSchema);