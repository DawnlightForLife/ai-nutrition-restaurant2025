const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

// 导入需要的模型
const Dish = require('./ProductDishModel');

const storeDishSchema = new mongoose.Schema({
  store_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Store',
    required: true
  },
  dish_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true
  },
  // 门店特有的价格覆盖
  price_override: {
    type: Number,
    min: 0
  },
  discount_price_override: {
    type: Number,
    min: 0
  },
  // 是否在此门店可用
  is_available: {
    type: Boolean,
    default: true
  },
  // 门店特有描述
  store_specific_description: {
    type: String
  },
  // 库存信息
  inventory: {
    current_stock: {
      type: Number,
      default: 0
    },
    alert_threshold: {
      type: Number,
      default: 10
    }
  },
  // 销售数据
  sales_data: {
    total_sales: {
      type: Number,
      default: 0
    },
    last_week_sales: {
      type: Number,
      default: 0
    },
    last_month_sales: {
      type: Number,
      default: 0
    }
  },
  // 门店菜品特有属性（如本店特色等）
  attributes: [{
    type: String
  }],
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建复合索引确保每个门店的每个菜品只有一条记录
storeDishSchema.index({ store_id: 1, dish_id: 1 }, { unique: true });
// 创建门店ID索引，便于查询特定门店的所有菜品
storeDishSchema.index({ store_id: 1, is_available: 1 });
// 创建菜品ID索引，便于查询特定菜品在哪些门店可用
storeDishSchema.index({ dish_id: 1, is_available: 1 });
// 创建销售量索引，便于查询热销菜品
storeDishSchema.index({ store_id: 1, 'sales_data.total_sales': -1 });
// 创建库存索引，便于查询库存紧张的菜品
storeDishSchema.index({ store_id: 1, 'inventory.current_stock': 1 });

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

storeDishSchema.virtual('effective_price').get(function() {
  // 返回有效价格（优先使用折扣价）
  if (this.discount_price_override !== undefined && this.discount_price_override !== null) {
    return this.discount_price_override;
  }
  return this.price_override;
});

storeDishSchema.virtual('availability_status').get(function() {
  if (!this.is_available) return 'unavailable';
  
  // 如果有库存信息，检查库存状态
  if (this.inventory && this.inventory.current_stock !== undefined) {
    if (this.inventory.current_stock <= 0) return 'sold_out';
    if (this.inventory.current_stock <= this.inventory.alert_threshold) return 'low_stock';
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
        current_stock: 0,
        alert_threshold: 10
      };
    }
    
    this.inventory.current_stock += quantity;
    
    // 确保库存不为负数
    if (this.inventory.current_stock < 0) {
      this.inventory.current_stock = 0;
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
    if (!this.sales_data) {
      this.sales_data = {
        total_sales: 0,
        last_week_sales: 0,
        last_month_sales: 0
      };
    }
    
    // 更新总销售量
    this.sales_data.total_sales += quantity;
    
    // 更新最近一周和一个月的销售量（这里需要配合定时任务定期刷新）
    const now = new Date();
    const oneWeekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    const oneMonthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    
    // 这里仅做简单累加，实际应用中可能需要使用更复杂的统计逻辑
    this.sales_data.last_week_sales += quantity;
    this.sales_data.last_month_sales += quantity;
    
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
    this.price_override = regularPrice;
    
    if (discountPrice !== null) {
      this.discount_price_override = discountPrice;
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
      this.is_available = !this.is_available;
    } else {
      this.is_available = !!available;
    }
    
    return this.save();
  },
  
  /**
   * 获取分片键
   * @returns {String} 分片键
   */
  getShardKey() {
    // 使用门店ID作为分片键，确保同一门店的菜品在同一分片
    return this.store_id.toString();
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
      store_id: storeId,
      ...filters
    };
    
    // 查找所有符合条件的记录
    const storeDishes = await this.find(query);
    
    // 批量更新
    const updatePromises = storeDishes.map(async (sd) => {
      if (sd.price_override !== undefined && sd.price_override !== null) {
        const adjustment = sd.price_override * (percentage / 100);
        sd.price_override = Math.max(0, sd.price_override + adjustment);
      }
      
      if (sd.discount_price_override !== undefined && sd.discount_price_override !== null) {
        const adjustment = sd.discount_price_override * (percentage / 100);
        sd.discount_price_override = Math.max(0, sd.discount_price_override + adjustment);
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
      store_id: storeId,
      is_available: true
    })
    .sort({ 'sales_data.total_sales': -1 })
    .limit(limit)
    .populate('dish_id');
  },
  
  /**
   * 查找库存紧张的菜品
   * @param {ObjectId} storeId 门店ID
   * @returns {Promise<Array>} 菜品列表
   */
  async findLowStock(storeId) {
    return this.find({
      store_id: storeId,
      is_available: true,
      'inventory.current_stock': { $lte: '$inventory.alert_threshold' }
    })
    .populate('dish_id');
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
      store_id: storeId,
      dish_id: { $in: dishIds },
      is_available: true
    })
    .populate('dish_id')
    .sort({ 'sales_data.total_sales': -1 });
  },
  
  /**
   * 同步门店菜品库存（批量操作）
   * @param {Array} stockUpdates 库存更新数组 [{dish_id, quantity}]
   * @param {ObjectId} storeId 门店ID
   * @returns {Promise<Object>} 更新结果
   */
  async syncInventory(stockUpdates, storeId) {
    if (!Array.isArray(stockUpdates) || !storeId) {
      throw new Error('库存更新参数无效');
    }
    
    const updatePromises = stockUpdates.map(async ({ dish_id, quantity }) => {
      const record = await this.findOne({
        store_id: storeId,
        dish_id
      });
      
      if (!record) {
        console.warn(`门店 ${storeId} 中未找到菜品 ${dish_id} 的记录`);
        return null;
      }
      
      if (!record.inventory) {
        record.inventory = {
          current_stock: 0,
          alert_threshold: 10
        };
      }
      
      // 设置新库存
      record.inventory.current_stock = Math.max(0, quantity);
      
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

// 更新前自动更新时间
storeDishSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

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