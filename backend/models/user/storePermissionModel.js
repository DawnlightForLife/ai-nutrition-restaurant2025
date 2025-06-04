/**
 * 门店权限模型
 * 管理用户在特定门店的权限
 * @module models/user/storePermissionModel
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

const storePermissionSchema = new Schema({
  // 用户信息
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 门店信息
  storeId: {
    type: Schema.Types.ObjectId,
    ref: 'Store',
    required: true,
    index: true
  },
  
  // 分店信息（如果适用）
  branchId: {
    type: Schema.Types.ObjectId,
    ref: 'Branch',
    index: true
  },
  
  // 餐厅信息
  restaurantId: {
    type: Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true,
    index: true
  },
  
  // 角色信息
  role: {
    type: String,
    required: true,
    enum: [
      'store_owner',      // 店主
      'store_manager',    // 店长
      'assistant_manager', // 副店长
      'supervisor',       // 主管
      'cashier',         // 收银员
      'waiter',          // 服务员
      'chef',            // 厨师
      'kitchen_staff',   // 厨房员工
      'delivery_staff',  // 配送员
      'part_time',       // 兼职员工
      'trainee',         // 实习生
      'custom'           // 自定义角色
    ],
    index: true
  },
  
  // 自定义角色名称
  customRoleName: {
    type: String,
    required: function() {
      return this.role === 'custom';
    }
  },
  
  // 权限列表
  permissions: {
    // 订单管理
    order: {
      view: { type: Boolean, default: false },
      create: { type: Boolean, default: false },
      update: { type: Boolean, default: false },
      cancel: { type: Boolean, default: false },
      refund: { type: Boolean, default: false },
      viewAll: { type: Boolean, default: false } // 查看所有订单
    },
    
    // 菜品管理
    menu: {
      view: { type: Boolean, default: false },
      create: { type: Boolean, default: false },
      update: { type: Boolean, default: false },
      delete: { type: Boolean, default: false },
      updatePrice: { type: Boolean, default: false },
      updateStock: { type: Boolean, default: false }
    },
    
    // 库存管理
    inventory: {
      view: { type: Boolean, default: false },
      update: { type: Boolean, default: false },
      order: { type: Boolean, default: false }, // 订货权限
      adjust: { type: Boolean, default: false }, // 库存调整
      viewCost: { type: Boolean, default: false } // 查看成本
    },
    
    // 财务管理
    finance: {
      viewSales: { type: Boolean, default: false },
      viewProfit: { type: Boolean, default: false },
      handleCash: { type: Boolean, default: false },
      issueRefund: { type: Boolean, default: false },
      viewReports: { type: Boolean, default: false },
      exportData: { type: Boolean, default: false }
    },
    
    // 员工管理
    staff: {
      view: { type: Boolean, default: false },
      create: { type: Boolean, default: false },
      update: { type: Boolean, default: false },
      delete: { type: Boolean, default: false },
      schedule: { type: Boolean, default: false }, // 排班
      viewSalary: { type: Boolean, default: false }
    },
    
    // 客户管理
    customer: {
      view: { type: Boolean, default: false },
      update: { type: Boolean, default: false },
      viewHistory: { type: Boolean, default: false },
      sendMessage: { type: Boolean, default: false },
      manageVIP: { type: Boolean, default: false }
    },
    
    // 营销管理
    marketing: {
      viewCampaigns: { type: Boolean, default: false },
      createCampaigns: { type: Boolean, default: false },
      manageCoupons: { type: Boolean, default: false },
      viewAnalytics: { type: Boolean, default: false }
    },
    
    // 设置管理
    settings: {
      viewStore: { type: Boolean, default: false },
      updateStore: { type: Boolean, default: false },
      viewPayment: { type: Boolean, default: false },
      updatePayment: { type: Boolean, default: false },
      manageTables: { type: Boolean, default: false }
    },
    
    // 报表查看
    reports: {
      daily: { type: Boolean, default: false },
      weekly: { type: Boolean, default: false },
      monthly: { type: Boolean, default: false },
      custom: { type: Boolean, default: false },
      export: { type: Boolean, default: false }
    }
  },
  
  // 工作信息
  employmentInfo: {
    employeeId: String, // 员工编号
    department: String,
    position: String,
    hireDate: Date,
    contractType: {
      type: String,
      enum: ['full_time', 'part_time', 'temporary', 'intern', 'outsourced']
    },
    workSchedule: {
      type: String,
      enum: ['morning', 'afternoon', 'evening', 'night', 'flexible', 'shifts']
    },
    salary: {
      amount: Number,
      currency: {
        type: String,
        default: 'CNY'
      },
      type: {
        type: String,
        enum: ['hourly', 'daily', 'monthly', 'commission', 'mixed']
      }
    }
  },
  
  // 权限范围
  scope: {
    // 时间范围限制
    timeRestriction: {
      enabled: { type: Boolean, default: false },
      allowedDays: [Number], // 0-6, 0是周日
      allowedHours: {
        start: String, // "09:00"
        end: String    // "18:00"
      }
    },
    
    // 功能范围限制
    functionRestriction: {
      maxDailyOrders: Number,
      maxOrderAmount: Number,
      maxRefundAmount: Number,
      maxDiscountRate: Number
    },
    
    // 数据范围限制
    dataRestriction: {
      ownDataOnly: { type: Boolean, default: true }, // 只能看自己的数据
      teamDataOnly: { type: Boolean, default: false }, // 只能看团队数据
      timeRange: {
        type: String,
        enum: ['today', 'week', 'month', 'quarter', 'year', 'all'],
        default: 'month'
      }
    }
  },
  
  // 状态信息
  status: {
    type: String,
    required: true,
    enum: ['active', 'inactive', 'suspended', 'terminated'],
    default: 'active',
    index: true
  },
  
  // 激活信息
  activation: {
    activatedAt: Date,
    activatedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    deactivatedAt: Date,
    deactivatedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    deactivationReason: String
  },
  
  // 有效期
  validity: {
    startDate: {
      type: Date,
      default: Date.now
    },
    endDate: Date,
    isPermanent: {
      type: Boolean,
      default: true
    }
  },
  
  // 审批信息
  approval: {
    required: {
      type: Boolean,
      default: true
    },
    approvedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User'
    },
    approvedAt: Date,
    approvalNote: String,
    rejectionReason: String
  },
  
  // 使用记录
  usageStats: {
    lastAccessedAt: Date,
    totalAccesses: {
      type: Number,
      default: 0
    },
    lastActions: [{
      action: String,
      resource: String,
      timestamp: Date,
      ipAddress: String,
      result: {
        type: String,
        enum: ['success', 'denied', 'error']
      }
    }]
  },
  
  // 备注
  notes: [{
    date: Date,
    author: String,
    content: String,
    type: {
      type: String,
      enum: ['general', 'warning', 'commendation', 'incident']
    }
  }],
  
  // 元数据
  metadata: {
    source: {
      type: String,
      enum: ['manual', 'import', 'system', 'migration'],
      default: 'manual'
    },
    tags: [String],
    customFields: {
      type: Map,
      of: Schema.Types.Mixed
    }
  }
}, {
  timestamps: true,
  collection: 'store_permissions'
});

// 复合唯一索引 - 一个用户在一个门店只能有一个权限记录
storePermissionSchema.index({ userId: 1, storeId: 1 }, { unique: true });
storePermissionSchema.index({ restaurantId: 1, status: 1 });
storePermissionSchema.index({ role: 1, status: 1 });
storePermissionSchema.index({ 'validity.endDate': 1 });

// 虚拟字段 - 是否有效
storePermissionSchema.virtual('isValid').get(function() {
  if (this.status !== 'active') return false;
  
  const now = new Date();
  if (!this.validity.isPermanent && this.validity.endDate && this.validity.endDate < now) {
    return false;
  }
  
  if (this.validity.startDate > now) {
    return false;
  }
  
  return true;
});

// 虚拟字段 - 是否即将过期
storePermissionSchema.virtual('isExpiringSoon').get(function() {
  if (this.validity.isPermanent || !this.validity.endDate) return false;
  
  const now = new Date();
  const daysUntilExpiry = Math.ceil((this.validity.endDate - now) / (1000 * 60 * 60 * 24));
  return daysUntilExpiry > 0 && daysUntilExpiry <= 30;
});

// 实例方法 - 检查权限
storePermissionSchema.methods.hasPermission = function(resource, action) {
  if (!this.isValid) return false;
  
  // 检查时间限制
  if (this.scope.timeRestriction.enabled) {
    const now = new Date();
    const currentDay = now.getDay();
    const currentTime = now.toTimeString().substr(0, 5);
    
    if (!this.scope.timeRestriction.allowedDays.includes(currentDay)) {
      return false;
    }
    
    if (currentTime < this.scope.timeRestriction.allowedHours.start ||
        currentTime > this.scope.timeRestriction.allowedHours.end) {
      return false;
    }
  }
  
  // 检查具体权限
  if (this.permissions[resource] && this.permissions[resource][action] !== undefined) {
    return this.permissions[resource][action];
  }
  
  return false;
};

// 实例方法 - 记录访问
storePermissionSchema.methods.logAccess = function(action, resource, result, ipAddress) {
  this.usageStats.lastAccessedAt = new Date();
  this.usageStats.totalAccesses += 1;
  
  this.usageStats.lastActions.push({
    action,
    resource,
    timestamp: new Date(),
    ipAddress,
    result
  });
  
  // 只保留最近50条记录
  if (this.usageStats.lastActions.length > 50) {
    this.usageStats.lastActions = this.usageStats.lastActions.slice(-50);
  }
  
  return this.save();
};

// 实例方法 - 激活权限
storePermissionSchema.methods.activate = function(activatedBy) {
  this.status = 'active';
  this.activation.activatedAt = new Date();
  this.activation.activatedBy = activatedBy;
  return this.save();
};

// 实例方法 - 停用权限
storePermissionSchema.methods.deactivate = function(deactivatedBy, reason) {
  this.status = 'inactive';
  this.activation.deactivatedAt = new Date();
  this.activation.deactivatedBy = deactivatedBy;
  this.activation.deactivationReason = reason;
  return this.save();
};

// 实例方法 - 添加备注
storePermissionSchema.methods.addNote = function(author, content, type = 'general') {
  this.notes.push({
    date: new Date(),
    author,
    content,
    type
  });
  
  // 只保留最近20条备注
  if (this.notes.length > 20) {
    this.notes = this.notes.slice(-20);
  }
  
  return this.save();
};

// 静态方法 - 批量分配权限
storePermissionSchema.statics.batchAssign = async function(storeId, assignments) {
  const results = [];
  
  for (const assignment of assignments) {
    try {
      const permission = await this.findOneAndUpdate(
        { userId: assignment.userId, storeId },
        {
          ...assignment,
          storeId,
          status: 'active'
        },
        { upsert: true, new: true }
      );
      results.push({ success: true, permission });
    } catch (error) {
      results.push({ success: false, error: error.message, userId: assignment.userId });
    }
  }
  
  return results;
};

// 静态方法 - 获取门店员工列表
storePermissionSchema.statics.getStoreStaff = async function(storeId, options = {}) {
  const query = { storeId };
  
  if (options.status) {
    query.status = options.status;
  }
  
  if (options.role) {
    query.role = options.role;
  }
  
  return this.find(query)
    .populate('userId', 'name email phone avatar')
    .sort({ role: 1, createdAt: -1 });
};

// 静态方法 - 获取用户的所有门店权限
storePermissionSchema.statics.getUserStorePermissions = async function(userId) {
  return this.find({ userId, status: 'active' })
    .populate('storeId', 'name address')
    .populate('restaurantId', 'name')
    .sort({ createdAt: -1 });
};

// 静态方法 - 根据角色预设权限
storePermissionSchema.statics.getPresetPermissions = function(role) {
  const presets = {
    store_owner: {
      order: { view: true, create: true, update: true, cancel: true, refund: true, viewAll: true },
      menu: { view: true, create: true, update: true, delete: true, updatePrice: true, updateStock: true },
      inventory: { view: true, update: true, order: true, adjust: true, viewCost: true },
      finance: { viewSales: true, viewProfit: true, handleCash: true, issueRefund: true, viewReports: true, exportData: true },
      staff: { view: true, create: true, update: true, delete: true, schedule: true, viewSalary: true },
      customer: { view: true, update: true, viewHistory: true, sendMessage: true, manageVIP: true },
      marketing: { viewCampaigns: true, createCampaigns: true, manageCoupons: true, viewAnalytics: true },
      settings: { viewStore: true, updateStore: true, viewPayment: true, updatePayment: true, manageTables: true },
      reports: { daily: true, weekly: true, monthly: true, custom: true, export: true }
    },
    store_manager: {
      order: { view: true, create: true, update: true, cancel: true, refund: true, viewAll: true },
      menu: { view: true, create: true, update: true, delete: false, updatePrice: true, updateStock: true },
      inventory: { view: true, update: true, order: true, adjust: true, viewCost: true },
      finance: { viewSales: true, viewProfit: false, handleCash: true, issueRefund: true, viewReports: true, exportData: true },
      staff: { view: true, create: true, update: true, delete: false, schedule: true, viewSalary: false },
      customer: { view: true, update: true, viewHistory: true, sendMessage: true, manageVIP: true },
      marketing: { viewCampaigns: true, createCampaigns: false, manageCoupons: true, viewAnalytics: true },
      settings: { viewStore: true, updateStore: true, viewPayment: true, updatePayment: false, manageTables: true },
      reports: { daily: true, weekly: true, monthly: true, custom: true, export: true }
    },
    cashier: {
      order: { view: true, create: true, update: true, cancel: false, refund: false, viewAll: false },
      menu: { view: true, create: false, update: false, delete: false, updatePrice: false, updateStock: false },
      inventory: { view: false, update: false, order: false, adjust: false, viewCost: false },
      finance: { viewSales: true, viewProfit: false, handleCash: true, issueRefund: false, viewReports: false, exportData: false },
      staff: { view: false, create: false, update: false, delete: false, schedule: false, viewSalary: false },
      customer: { view: true, update: false, viewHistory: false, sendMessage: false, manageVIP: false },
      marketing: { viewCampaigns: false, createCampaigns: false, manageCoupons: false, viewAnalytics: false },
      settings: { viewStore: false, updateStore: false, viewPayment: false, updatePayment: false, manageTables: false },
      reports: { daily: true, weekly: false, monthly: false, custom: false, export: false }
    },
    waiter: {
      order: { view: true, create: true, update: true, cancel: false, refund: false, viewAll: false },
      menu: { view: true, create: false, update: false, delete: false, updatePrice: false, updateStock: false },
      inventory: { view: false, update: false, order: false, adjust: false, viewCost: false },
      finance: { viewSales: false, viewProfit: false, handleCash: false, issueRefund: false, viewReports: false, exportData: false },
      staff: { view: false, create: false, update: false, delete: false, schedule: false, viewSalary: false },
      customer: { view: true, update: false, viewHistory: false, sendMessage: false, manageVIP: false },
      marketing: { viewCampaigns: false, createCampaigns: false, manageCoupons: false, viewAnalytics: false },
      settings: { viewStore: false, updateStore: false, viewPayment: false, updatePayment: false, manageTables: false },
      reports: { daily: false, weekly: false, monthly: false, custom: false, export: false }
    }
  };
  
  return presets[role] || {};
};

// 中间件 - 保存前应用预设权限
storePermissionSchema.pre('save', function(next) {
  // 如果是新建且没有设置权限，应用预设
  if (this.isNew && Object.keys(this.permissions.toObject()).length === 0) {
    const presetPermissions = this.constructor.getPresetPermissions(this.role);
    this.permissions = presetPermissions;
  }
  
  // 自动设置餐厅ID（如果没有设置）
  if (!this.restaurantId && this.storeId) {
    // 这里应该从Store模型获取restaurantId
    // 暂时跳过，实际使用时需要处理
  }
  
  next();
});

// 转换选项
storePermissionSchema.set('toJSON', {
  virtuals: true,
  transform: function(doc, ret) {
    delete ret._id;
    delete ret.__v;
    // 隐藏敏感信息
    if (ret.employmentInfo?.salary) {
      ret.employmentInfo.salary = { type: ret.employmentInfo.salary.type };
    }
    return ret;
  }
});

const StorePermission = mongoose.model('StorePermission', storePermissionSchema);

module.exports = StorePermission;