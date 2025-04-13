const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

// 导入需要的模型
const Dish = require('./ProductDishModel');

const storeDishSchema = new mongoose.Schema({
  storeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Store',
    required: true
  },
  dishId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true
  },
  // 门店特有的价格覆盖
  priceOverride: {
    type: Number,
    min: 0
  },
  discountPriceOverride: {
    type: Number,
    min: 0
  },
  // 是否在此门店可用
  isAvailable: {
    type: Boolean,
    default: true
  },
  // 门店特有描述
  storeSpecificDescription: {
    type: String
  },
  // 可用时间和日期
  availability: {
    startTime: {
      type: String,
      default: "00:00"
    },
    endTime: {
      type: String,
      default: "23:59"
    },
    daysOfWeek: {
      type: [Number],
      default: [0, 1, 2, 3, 4, 5, 6] // 0=周日, 1=周一, ..., 6=周六
    }
  },
  // 促销信息
  promotion: {
    isOnSale: {
      type: Boolean,
      default: false
    },
    salePrice: {
      type: Number,
      min: 0
    },
    validUntil: {
      type: Date
    }
  },
  // 库存信息
  inventory: {
    currentStock: {
      type: Number,
      default: 0
    },
    alertThreshold: {
      type: Number,
      default: 10
    }
  },
  // 销售数据
  salesData: {
    totalSales: {
      type: Number,
      default: 0
    },
    lastWeekSales: {
      type: Number,
      default: 0
    },
    lastMonthSales: {
      type: Number,
      default: 0
    }
  },
  // 门店菜品特有属性（如本店特色等）
  attributes: [{
    type: String
  }],
  specialNote: {
    type: String
  },
  availableStatus: {
    type: String,
    enum: ['available', 'unavailable', 'sold_out', 'low_stock', 'in_stock'],
    default: 'available'
  },
  availableTimes: [{
    startTime: String,
    endTime: String,
    dayOfWeek: Number // 0-6 表示周日到周六
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建复合索引确保每个门店的每个菜品只有一条记录
storeDishSchema.index({ storeId: 1, dishId: 1 }, { unique: true });
// 创建门店ID索引，便于查询特定门店的所有菜品
storeDishSchema.index({ storeId: 1, isAvailable: 1 });
// 创建菜品ID索引，便于查询特定菜品在哪些门店可用
storeDishSchema.index({ dishId: 1, isAvailable: 1 });
// 创建销售量索引，便于查询热销菜品
storeDishSchema.index({ storeId: 1, 'salesData.totalSales': -1 });
// 创建库存索引，便于查询库存紧张的菜品
storeDishSchema.index({ storeId: 1, 'inventory.currentStock': 1 });

// 添加虚拟字段
storeDishSchema.virtual('dish').get(function() {
  return this._dish;
});

storeDishSchema.virtual('dish').set(function(dish) {
  this._dish = dish;
});

storeDishSchema.virtual('store').get(function() {
  return this._store;
});

storeDishSchema.virtual('store').set(function(store) {
  this._store = store;
});

storeDishSchema.virtual('effectivePrice').get(function() {
  // 返回有效价格（优先使用折扣价）
  if (this.discountPriceOverride !== undefined && this.discountPriceOverride !== null) {
    return this.discountPriceOverride;
  }
  return this.priceOverride;
});

storeDishSchema.virtual('availabilityStatus').get(function() {
  if (!this.isAvailable) return 'unavailable';
  
  // 如果有库存信息，检查库存状态
  if (this.inventory && this.inventory.currentStock !== undefined) {
    if (this.inventory.currentStock <= 0) return 'sold_out';
    if (this.inventory.currentStock <= this.inventory.alertThreshold) return 'low_stock';
    return 'in_stock';
  }
  
  return 'available';
});

// 添加实例方法
storeDishSchema.methods = {
  /**
   * 更新菜品库存
   * @param {Number} quantity 变动数量（正数为增加，负数为减少）
   * @returns {Promise<Object>} 更新后的记录
   */
  async updateStock(quantity) {
    if (!this.inventory) {
      this.inventory = {
        currentStock: 0,
        alertThreshold: 10
      };
    }
    
    this.inventory.currentStock += quantity;
    
    // 确保库存不为负数
    if (this.inventory.currentStock < 0) {
      this.inventory.currentStock = 0;
    }
    
    return this.save();
  },
  
  /**
   * 更新销售数据
   * @param {Number} quantity 销售数量
   * @param {Number} revenue 销售金额
   * @returns {Promise<Object>} 更新后的记录
   */
  async updateSalesData(quantity, revenue) {
    if (!this.salesData) {
      this.salesData = {
        totalSales: 0,
        lastWeekSales: 0,
        lastMonthSales: 0
      };
    }
    
    // 更新总销售量
    this.salesData.totalSales += quantity;
    
    // 更新最近一周和一个月的销售量（这里需要配合定时任务定期刷新）
    const now = new Date();
    const oneWeekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    const oneMonthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    
    // 这里仅做简单累加，实际应用中可能需要使用更复杂的统计逻辑
    this.salesData.lastWeekSales += quantity;
    this.salesData.lastMonthSales += quantity;
    
    // 同时减少库存
    if (this.inventory) {
      await this.updateStock(-quantity);
    }
    
    return this.save();
  },
  
  /**
   * 设置菜品在门店的价格
   * @param {Number} regularPrice 常规价格
   * @param {Number} discountPrice 折扣价格
   * @returns {Promise<Object>} 更新后的记录
   */
  async setPrice(regularPrice, discountPrice = null) {
    this.priceOverride = regularPrice;
    
    if (discountPrice !== null) {
      this.discountPriceOverride = discountPrice;
    }
    
    return this.save();
  },
  
  /**
   * 切换菜品可用状态
   * @param {Boolean} available 是否可用
   * @returns {Promise<Object>} 更新后的记录
   */
  async toggleAvailability(available = null) {
    if (available === null) {
      this.isAvailable = !this.isAvailable;
    } else {
      this.isAvailable = !!available;
    }
    
    return this.save();
  },
  
  /**
   * 获取分片键
   * @returns {String} 分片键
   */
  getShardKey() {
    // 使用门店ID作为分片键，确保同一门店的菜品在同一分片
    return this.storeId.toString();
  }
};

// 添加静态方法
storeDishSchema.statics = {
  /**
   * 批量更新门店菜品价格
   * @param {ObjectId} storeId 门店ID
   * @param {Number} percentage 价格调整百分比（如10表示涨价10%，-5表示降价5%）
   * @param {Object} filters 其他过滤条件
   * @returns {Promise<Object>} 更新结果
   */
  async batchUpdatePrices(storeId, percentage, filters = {}) {
    if (!percentage || isNaN(percentage)) {
      throw new Error('价格调整百分比必须是有效数字');
    }
    
    const query = { 
      storeId: storeId,
      ...filters
    };
    
    // 查找所有符合条件的记录
    const storeDishes = await this.find(query);
    
    // 批量更新
    const updatePromises = storeDishes.map(async (sd) => {
      if (sd.priceOverride !== undefined && sd.priceOverride !== null) {
        const adjustment = sd.priceOverride * (percentage / 100);
        sd.priceOverride = Math.max(0, sd.priceOverride + adjustment);
      }
      
      if (sd.discountPriceOverride !== undefined && sd.discountPriceOverride !== null) {
        const adjustment = sd.discountPriceOverride * (percentage / 100);
        sd.discountPriceOverride = Math.max(0, sd.discountPriceOverride + adjustment);
      }
      
      return sd.save();
    });
    
    const results = await Promise.all(updatePromises);
    return {
      updated: results.length,
      results
    };
  },
  
  /**
   * 查找热销菜品
   * @param {ObjectId} storeId 门店ID
   * @param {Number} limit 结果数量限制
   * @returns {Promise<Array>} 菜品列表
   */
  async findBestSellers(storeId, limit = 10) {
    return this.find({
      storeId: storeId,
      isAvailable: true
    })
    .sort({ 'salesData.totalSales': -1 })
    .limit(limit)
    .populate('dishId');
  },
  
  /**
   * 查找库存紧张的菜品
   * @param {ObjectId} storeId 门店ID
   * @returns {Promise<Array>} 菜品列表
   */
  async findLowStock(storeId) {
    return this.find({
      storeId: storeId,
      isAvailable: true,
      'inventory.currentStock': { $lte: '$inventory.alertThreshold' }
    })
    .populate('dishId');
  },
  
  /**
   * 根据类别查询门店菜品
   * @param {ObjectId} storeId 门店ID
   * @param {String} category 菜品类别
   * @returns {Promise<Array>} 菜品列表
   */
  async findByCategory(storeId, category) {
    // 先查找指定类别的所有菜品
    const dishes = await Dish.find({ category });
    const dishIds = dishes.map(dish => dish._id);
    
    // 再查找门店中有这些菜品的记录
    return this.find({
      storeId: storeId,
      dishId: { $in: dishIds },
      isAvailable: true
    })
    .populate('dishId')
    .sort({ 'salesData.totalSales': -1 });
  },
  
  /**
   * 同步门店菜品库存（批量操作）
   * @param {Array} stockUpdates 库存更新数组 [{dishId, quantity}]
   * @param {ObjectId} storeId 门店ID
   * @returns {Promise<Object>} 更新结果
   */
  async syncInventory(stockUpdates, storeId) {
    if (!Array.isArray(stockUpdates) || !storeId) {
      throw new Error('库存更新参数无效');
    }
    
    const updatePromises = stockUpdates.map(async ({ dishId, quantity }) => {
      const record = await this.findOne({
        storeId: storeId,
        dishId
      });
      
      if (!record) {
        console.warn(`门店 ${storeId} 中未找到菜品 ${dishId} 的记录`);
        return null;
      }
      
      if (!record.inventory) {
        record.inventory = {
          currentStock: 0,
          alertThreshold: 10
        };
      }
      
      // 设置新库存
      record.inventory.currentStock = Math.max(0, quantity);
      
      return record.save();
    });
    
    const results = await Promise.all(updatePromises);
    return {
      updated: results.filter(Boolean).length,
      failed: results.length - results.filter(Boolean).length,
      results: results.filter(Boolean)
    };
  }
};

// 使用ModelFactory创建支持读写分离的模型
const StoreDish = ModelFactory.createModel('StoreDish', storeDishSchema);

// 添加分片支持的保存方法
const originalSave = StoreDish.prototype.save;
StoreDish.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.StoreDish) {
    // 使用门店ID作为分片键，确保同一门店的菜品在同一分片
    const shardKey = this.getShardKey();
    const shardCollection = shardingService.getShardName('StoreDish', shardKey);
    console.log(`将门店菜品保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = StoreDish; 