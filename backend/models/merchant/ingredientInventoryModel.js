/**
 * 商家食材库存模型
 * 管理商家的食材库存、过期预警、自动补货等功能
 */
const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 库存预警类型
const ALERT_TYPES = {
  LOW_STOCK: 'low_stock',           // 低库存
  OUT_OF_STOCK: 'out_of_stock',     // 缺货
  EXPIRING_SOON: 'expiring_soon',   // 即将过期
  EXPIRED: 'expired',               // 已过期
  QUALITY_ISSUE: 'quality_issue'    // 质量问题
};

// 库存状态
const STOCK_STATUS = {
  NORMAL: 'normal',                 // 正常
  LOW: 'low',                      // 偏低
  CRITICAL: 'critical',            // 紧急
  OUT: 'out'                       // 缺货
};

// 单个库存记录（支持批次管理）
const stockBatchSchema = new mongoose.Schema({
  batchNumber: {
    type: String,
    required: true,
    description: '批次号'
  },
  quantity: {
    type: Number,
    required: true,
    min: 0,
    description: '该批次数量'
  },
  unit: {
    type: String,
    required: true,
    enum: ['kg', 'g', 'l', 'ml', 'piece', 'box', 'bag'],
    description: '单位'
  },
  purchaseDate: {
    type: Date,
    required: true,
    description: '采购日期'
  },
  expiryDate: {
    type: Date,
    required: true,
    description: '过期日期'
  },
  purchasePrice: {
    type: Number,
    required: true,
    min: 0,
    description: '采购单价'
  },
  supplier: {
    name: { type: String, description: '供应商名称' },
    contact: { type: String, description: '供应商联系方式' },
    supplierId: { type: String, description: '供应商ID' }
  },
  qualityGrade: {
    type: String,
    enum: ['A', 'B', 'C'],
    default: 'A',
    description: '质量等级'
  },
  storageLocation: {
    type: String,
    description: '存储位置'
  },
  notes: {
    type: String,
    description: '备注'
  }
}, { _id: true, timestamps: true });

// 主库存模型
const ingredientInventorySchema = new mongoose.Schema({
  // 基本信息
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    description: '商家ID'
  },
  ingredientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'IngredientNutrition',
    required: true,
    description: '食材营养信息ID'
  },
  name: {
    type: String,
    required: true,
    description: '食材名称'
  },
  chineseName: {
    type: String,
    required: true,
    description: '中文名称'
  },
  category: {
    type: String,
    required: true,
    description: '食材类别'
  },
  
  // 库存信息
  stockBatches: [stockBatchSchema],
  
  // 库存统计（自动计算）
  totalStock: {
    type: Number,
    default: 0,
    min: 0,
    description: '总库存数量'
  },
  availableStock: {
    type: Number,
    default: 0,
    min: 0,
    description: '可用库存（排除预留和过期）'
  },
  reservedStock: {
    type: Number,
    default: 0,
    min: 0,
    description: '预留库存（已订单但未使用）'
  },
  expiredStock: {
    type: Number,
    default: 0,
    min: 0,
    description: '过期库存'
  },
  
  // 库存配置
  minThreshold: {
    type: Number,
    required: true,
    min: 0,
    description: '最低库存阈值'
  },
  maxCapacity: {
    type: Number,
    required: true,
    min: 0,
    description: '最大库存容量'
  },
  optimalLevel: {
    type: Number,
    description: '最佳库存水平'
  },
  reorderPoint: {
    type: Number,
    description: '重新订购点'
  },
  reorderQuantity: {
    type: Number,
    description: '推荐订购数量'
  },
  
  // 库存状态
  status: {
    type: String,
    enum: Object.values(STOCK_STATUS),
    default: STOCK_STATUS.NORMAL,
    description: '库存状态'
  },
  
  // 预警设置
  alertSettings: {
    lowStockAlert: { type: Boolean, default: true },
    expiryAlert: { type: Boolean, default: true },
    qualityAlert: { type: Boolean, default: true },
    alertDaysBefore: { type: Number, default: 3, description: '过期前多少天预警' }
  },
  
  // 自动补货设置
  autoReorderSettings: {
    enabled: { type: Boolean, default: false },
    preferredSupplier: { type: String, description: '首选供应商' },
    maxAutoOrderAmount: { type: Number, description: '最大自动订购金额' },
    conditions: [{
      type: { type: String, enum: ['low_stock', 'out_of_stock', 'time_based'] },
      threshold: { type: Number, description: '触发阈值' },
      orderQuantity: { type: Number, description: '订购数量' }
    }]
  },
  
  // 使用统计
  usageStats: {
    dailyConsumption: { type: Number, default: 0, description: '日均消耗量' },
    weeklyConsumption: { type: Number, default: 0, description: '周均消耗量' },
    monthlyConsumption: { type: Number, default: 0, description: '月均消耗量' },
    lastUsed: { type: Date, description: '最后使用时间' },
    usageFrequency: { type: String, enum: ['high', 'medium', 'low'], default: 'medium' }
  },
  
  // 成本分析
  costAnalysis: {
    averagePurchasePrice: { type: Number, description: '平均采购价格' },
    totalInventoryValue: { type: Number, default: 0, description: '库存总价值' },
    wasteValue: { type: Number, default: 0, description: '浪费价值（过期损失）' },
    turnoverRate: { type: Number, description: '库存周转率' }
  },
  
  // 季节性模式
  seasonalPattern: {
    spring: { consumption: Number, optimalStock: Number },
    summer: { consumption: Number, optimalStock: Number },
    autumn: { consumption: Number, optimalStock: Number },
    winter: { consumption: Number, optimalStock: Number }
  },
  
  // 供应商信息
  suppliers: [{
    supplierId: { type: String, description: '供应商ID' },
    name: { type: String, description: '供应商名称' },
    contact: { type: String, description: '联系方式' },
    leadTime: { type: Number, description: '供货周期（天）' },
    minOrderQuantity: { type: Number, description: '最小订购量' },
    pricePerUnit: { type: Number, description: '单价' },
    qualityRating: { type: Number, min: 1, max: 5, description: '质量评分' },
    reliabilityRating: { type: Number, min: 1, max: 5, description: '可靠性评分' },
    isPrimary: { type: Boolean, default: false, description: '是否主要供应商' },
    isActive: { type: Boolean, default: true, description: '是否启用' }
  }],
  
  // 质量控制
  qualityControl: {
    lastInspectionDate: { type: Date, description: '最后检查日期' },
    qualityScore: { type: Number, min: 0, max: 10, description: '质量评分' },
    defectRate: { type: Number, min: 0, max: 100, description: '缺陷率%' },
    storageConditions: {
      temperature: { type: Number, description: '存储温度' },
      humidity: { type: Number, description: '存储湿度' },
      location: { type: String, description: '存储位置' }
    }
  },
  
  // 是否启用
  isActive: {
    type: Boolean,
    default: true,
    description: '是否启用该食材库存'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
ingredientInventorySchema.index({ merchantId: 1 });
ingredientInventorySchema.index({ ingredientId: 1 });
ingredientInventorySchema.index({ merchantId: 1, name: 1 });
ingredientInventorySchema.index({ status: 1 });
ingredientInventorySchema.index({ totalStock: 1 });
ingredientInventorySchema.index({ 'stockBatches.expiryDate': 1 });
ingredientInventorySchema.index({ 'usageStats.usageFrequency': 1 });

// 复合索引
ingredientInventorySchema.index({ merchantId: 1, status: 1 });
ingredientInventorySchema.index({ merchantId: 1, totalStock: 1 });

// 虚拟字段
ingredientInventorySchema.virtual('stockPercentage').get(function() {
  if (this.maxCapacity <= 0) return 0;
  return Math.round((this.totalStock / this.maxCapacity) * 100);
});

ingredientInventorySchema.virtual('daysUntilReorder').get(function() {
  if (this.usageStats.dailyConsumption <= 0) return 999;
  return Math.ceil((this.availableStock - this.reorderPoint) / this.usageStats.dailyConsumption);
});

ingredientInventorySchema.virtual('estimatedDaysRemaining').get(function() {
  if (this.usageStats.dailyConsumption <= 0) return 999;
  return Math.ceil(this.availableStock / this.usageStats.dailyConsumption);
});

// 关联
ingredientInventorySchema.virtual('merchant', {
  ref: 'Merchant',
  localField: 'merchantId',
  foreignField: '_id',
  justOne: true
});

ingredientInventorySchema.virtual('ingredient', {
  ref: 'IngredientNutrition',
  localField: 'ingredientId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
ingredientInventorySchema.methods.calculateTotals = function() {
  const now = new Date();
  let totalStock = 0;
  let availableStock = 0;
  let expiredStock = 0;
  let totalValue = 0;
  
  this.stockBatches.forEach(batch => {
    totalStock += batch.quantity;
    totalValue += batch.quantity * batch.purchasePrice;
    
    if (batch.expiryDate <= now) {
      expiredStock += batch.quantity;
    } else {
      availableStock += batch.quantity;
    }
  });
  
  // 减去预留库存
  availableStock = Math.max(0, availableStock - this.reservedStock);
  
  this.totalStock = totalStock;
  this.availableStock = availableStock;
  this.expiredStock = expiredStock;
  this.costAnalysis.totalInventoryValue = totalValue;
  
  // 更新库存状态
  this.updateStockStatus();
  
  return {
    totalStock,
    availableStock,
    expiredStock,
    totalValue
  };
};

ingredientInventorySchema.methods.updateStockStatus = function() {
  if (this.totalStock <= 0) {
    this.status = STOCK_STATUS.OUT;
  } else if (this.availableStock <= this.minThreshold * 0.5) {
    this.status = STOCK_STATUS.CRITICAL;
  } else if (this.availableStock <= this.minThreshold) {
    this.status = STOCK_STATUS.LOW;
  } else {
    this.status = STOCK_STATUS.NORMAL;
  }
};

ingredientInventorySchema.methods.addStock = function(batchData) {
  this.stockBatches.push(batchData);
  this.calculateTotals();
  return this;
};

ingredientInventorySchema.methods.removeExpiredStock = function() {
  const now = new Date();
  const expiredBatches = this.stockBatches.filter(batch => batch.expiryDate <= now);
  
  let wasteValue = 0;
  expiredBatches.forEach(batch => {
    wasteValue += batch.quantity * batch.purchasePrice;
  });
  
  this.stockBatches = this.stockBatches.filter(batch => batch.expiryDate > now);
  this.costAnalysis.wasteValue += wasteValue;
  this.calculateTotals();
  
  return { removedBatches: expiredBatches, wasteValue };
};

ingredientInventorySchema.methods.consumeStock = function(quantity) {
  // FIFO原则消耗库存（先过期的先用）
  let remainingToConsume = quantity;
  const now = new Date();
  
  // 按过期时间排序
  this.stockBatches.sort((a, b) => a.expiryDate - b.expiryDate);
  
  for (let i = 0; i < this.stockBatches.length && remainingToConsume > 0; i++) {
    const batch = this.stockBatches[i];
    
    if (batch.expiryDate > now && batch.quantity > 0) {
      const consumeFromBatch = Math.min(batch.quantity, remainingToConsume);
      batch.quantity -= consumeFromBatch;
      remainingToConsume -= consumeFromBatch;
    }
  }
  
  // 移除空批次
  this.stockBatches = this.stockBatches.filter(batch => batch.quantity > 0);
  
  this.calculateTotals();
  this.usageStats.lastUsed = new Date();
  
  return quantity - remainingToConsume; // 返回实际消耗量
};

ingredientInventorySchema.methods.reserveStock = function(quantity) {
  if (this.availableStock >= quantity) {
    this.reservedStock += quantity;
    this.calculateTotals();
    return true;
  }
  return false;
};

ingredientInventorySchema.methods.releaseReservedStock = function(quantity) {
  this.reservedStock = Math.max(0, this.reservedStock - quantity);
  this.calculateTotals();
};

ingredientInventorySchema.methods.getExpiringBatches = function(days = 3) {
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() + days);
  
  return this.stockBatches.filter(batch => 
    batch.expiryDate <= cutoffDate && batch.expiryDate > new Date()
  );
};

ingredientInventorySchema.methods.calculateAveragePrice = function() {
  if (this.stockBatches.length === 0) return 0;
  
  let totalValue = 0;
  let totalQuantity = 0;
  
  this.stockBatches.forEach(batch => {
    totalValue += batch.quantity * batch.purchasePrice;
    totalQuantity += batch.quantity;
  });
  
  return totalQuantity > 0 ? totalValue / totalQuantity : 0;
};

// 静态方法
ingredientInventorySchema.statics.getLowStockItems = function(merchantId) {
  return this.find({
    merchantId,
    status: { $in: [STOCK_STATUS.LOW, STOCK_STATUS.CRITICAL, STOCK_STATUS.OUT] },
    isActive: true
  });
};

ingredientInventorySchema.statics.getExpiringItems = function(merchantId, days = 3) {
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() + days);
  
  return this.find({
    merchantId,
    'stockBatches.expiryDate': { $lte: cutoffDate, $gt: new Date() },
    isActive: true
  });
};

ingredientInventorySchema.statics.getInventoryAlerts = function(merchantId) {
  return this.aggregate([
    { $match: { merchantId: mongoose.Types.ObjectId(merchantId), isActive: true } },
    {
      $addFields: {
        alerts: {
          $let: {
            vars: {
              now: new Date(),
              threeDaysLater: { $add: [new Date(), 3 * 24 * 60 * 60 * 1000] }
            },
            in: {
              $concatArrays: [
                // 低库存预警
                {
                  $cond: [
                    { $lte: ["$availableStock", "$minThreshold"] },
                    [{
                      type: "low_stock",
                      severity: { $cond: [{ $lte: ["$availableStock", { $multiply: ["$minThreshold", 0.5] }] }, "critical", "warning"] },
                      message: "库存不足",
                      currentStock: "$availableStock",
                      threshold: "$minThreshold"
                    }],
                    []
                  ]
                },
                // 即将过期预警
                {
                  $filter: {
                    input: {
                      $map: {
                        input: "$stockBatches",
                        as: "batch",
                        in: {
                          $cond: [
                            { $and: [
                              { $lte: ["$$batch.expiryDate", "$$threeDaysLater"] },
                              { $gt: ["$$batch.expiryDate", "$$now"] }
                            ]},
                            {
                              type: "expiring_soon",
                              severity: "warning",
                              message: "即将过期",
                              expiryDate: "$$batch.expiryDate",
                              batchNumber: "$$batch.batchNumber",
                              quantity: "$$batch.quantity"
                            },
                            null
                          ]
                        }
                      }
                    },
                    cond: { $ne: ["$$this", null] }
                  }
                }
              ]
            }
          }
        }
      }
    },
    { $match: { "alerts.0": { $exists: true } } },
    {
      $project: {
        name: 1,
        chineseName: 1,
        totalStock: 1,
        availableStock: 1,
        minThreshold: 1,
        status: 1,
        alerts: 1
      }
    }
  ]);
};

// 前置钩子
ingredientInventorySchema.pre('save', function(next) {
  // 自动计算库存统计
  this.calculateTotals();
  
  // 更新平均价格
  this.costAnalysis.averagePurchasePrice = this.calculateAveragePrice();
  
  next();
});

// 使用ModelFactory创建模型
const IngredientInventory = ModelFactory.createModel('IngredientInventory', ingredientInventorySchema);

module.exports = {
  IngredientInventory,
  ALERT_TYPES,
  STOCK_STATUS
};