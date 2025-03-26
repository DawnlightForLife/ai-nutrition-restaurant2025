const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

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

// 更新前自动更新时间
storeDishSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const StoreDish = ModelFactory.model('StoreDish', storeDishSchema);

// 添加分片支持的保存方法
const originalSave = StoreDish.prototype.save;
StoreDish.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.StoreDish) {
    // 使用门店ID作为分片键，确保同一门店的菜品在同一分片
    const shardKey = this.store_id.toString();
    const shardCollection = shardingService.getShardName('StoreDish', shardKey);
    console.log(`将门店菜品保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = StoreDish; 