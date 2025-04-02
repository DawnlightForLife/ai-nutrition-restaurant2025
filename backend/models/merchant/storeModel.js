const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/shardingService');

// 导入需要的模型
const StoreDish = require('./storeDishModel');
const Dish = require('./dishModel');

const storeSchema = new mongoose.Schema({
  merchant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true
  },
  name: {
    type: String,
    required: true
  },
  address: {
    province: {
      type: String,
      required: true
    },
    city: {
      type: String,
      required: true
    },
    district: {
      type: String,
      required: true
    },
    street: {
      type: String,
      required: true
    },
    location: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point'
      },
      coordinates: {
        type: [Number], // [longitude, latitude]
        default: [0, 0]
      }
    }
  },
  contact_phone: {
    type: String,
    required: true
  },
  manager_name: {
    type: String,
    required: true
  },
  manager_phone: {
    type: String,
    required: true
  },
  image_urls: [{
    type: String
  }],
  business_hours: {
    monday: String,
    tuesday: String,
    wednesday: String,
    thursday: String,
    friday: String,
    saturday: String,
    sunday: String
  },
  // 门店级特定类型属性
  type_specific_data: {
    // 餐厅特有
    restaurant: {
      seating_capacity: Number,
      private_rooms: Number,
      cuisine_focus: [String],
      delivery_radius: Number // 公里
    },
    // 健身房特有
    gym: {
      equipment_count: Number,
      shower_rooms: Number,
      locker_count: Number,
      class_schedule: [String]
    },
    // 月子中心特有
    maternity_center: {
      bed_count: Number,
      nanny_count: Number,
      doctor_count: Number,
      facilities: [String]
    },
    // 学校/公司食堂特有
    school_company: {
      capacity: Number,
      serving_times: [String],
      number_of_counters: Number,
      special_dietary_options: Boolean
    }
  },
  is_active: {
    type: Boolean,
    default: true
  },
  ratings: {
    average: {
      type: Number,
      default: 0
    },
    count: {
      type: Number,
      default: 0
    }
  },
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

// 创建地理空间索引
storeSchema.index({ 'address.location': '2dsphere' });
// 创建商家ID索引，便于查询特定商家的所有门店
storeSchema.index({ merchant_id: 1 });
// 创建名称文本索引，便于门店搜索
storeSchema.index({ name: 'text' });
// 创建省市区组合索引，便于按地区查询门店
storeSchema.index({ 'address.province': 1, 'address.city': 1, 'address.district': 1 });
// 创建评分索引，便于查询高评分门店
storeSchema.index({ 'ratings.average': -1 });
// 创建活跃状态索引，便于查询活跃门店
storeSchema.index({ is_active: 1 });

// 添加虚拟字段
storeSchema.virtual('merchant').get(function() {
  return this._merchant;
});

storeSchema.virtual('merchant').set(function(merchant) {
  this._merchant = merchant;
});

storeSchema.virtual('dishes').get(function() {
  return this._dishes || [];
});

storeSchema.virtual('dishes').set(function(dishes) {
  this._dishes = dishes;
});

storeSchema.virtual('full_address').get(function() {
  if (!this.address) return '';
  return `${this.address.province} ${this.address.city} ${this.address.district} ${this.address.street}`;
});

storeSchema.virtual('is_open').get(function() {
  if (!this.business_hours) return false;
  
  // 获取当前时间和星期几
  const now = new Date();
  const dayOfWeek = now.getDay(); // 0是星期日，1-6是星期一到星期六
  const daysMap = {
    0: 'sunday',
    1: 'monday',
    2: 'tuesday',
    3: 'wednesday',
    4: 'thursday',
    5: 'friday',
    6: 'saturday'
  };
  
  const todayHours = this.business_hours[daysMap[dayOfWeek]];
  if (!todayHours || todayHours.toLowerCase() === 'closed') return false;
  
  // 解析营业时间格式 "09:00-22:00"
  const [openTimeStr, closeTimeStr] = todayHours.split('-');
  if (!openTimeStr || !closeTimeStr) return false;
  
  const [openHour, openMinute] = openTimeStr.split(':').map(Number);
  const [closeHour, closeMinute] = closeTimeStr.split(':').map(Number);
  
  // 设置今天的营业开始和结束时间
  const openTime = new Date(now);
  openTime.setHours(openHour, openMinute, 0, 0);
  
  const closeTime = new Date(now);
  closeTime.setHours(closeHour, closeMinute, 0, 0);
  
  // 检查当前时间是否在营业时间内
  return now >= openTime && now <= closeTime;
});

// 添加实例方法
storeSchema.methods = {
  /**
   * 检查特定时间点门店是否营业
   * @param {Date} date 要检查的时间点
   * @returns {Boolean} 是否营业
   */
  isOpenAt(date) {
    if (!this.business_hours) return false;
    
    const dayOfWeek = date.getDay();
    const daysMap = {
      0: 'sunday',
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday'
    };
    
    const dayHours = this.business_hours[daysMap[dayOfWeek]];
    if (!dayHours || dayHours.toLowerCase() === 'closed') return false;
    
    const [openTimeStr, closeTimeStr] = dayHours.split('-');
    if (!openTimeStr || !closeTimeStr) return false;
    
    const [openHour, openMinute] = openTimeStr.split(':').map(Number);
    const [closeHour, closeMinute] = closeTimeStr.split(':').map(Number);
    
    const openTime = new Date(date);
    openTime.setHours(openHour, openMinute, 0, 0);
    
    const closeTime = new Date(date);
    closeTime.setHours(closeHour, closeMinute, 0, 0);
    
    return date >= openTime && date <= closeTime;
  },
  
  /**
   * 获取门店可用菜品
   * @param {Object} options 查询选项
   * @returns {Promise<Array>} 可用菜品列表
   */
  async getAvailableDishes(options = {}) {
    const query = { 
      store_id: this._id,
      is_available: true
    };
    
    if (options.category) {
      // 这里需要通过关联Dish模型查询特定分类的菜品
      const dishes = await Dish.find({ category: options.category });
      const dishIds = dishes.map(dish => dish._id);
      query.dish_id = { $in: dishIds };
    }
    
    const storeDishes = await StoreDish.find(query)
      .populate('dish_id')
      .sort(options.sort || { 'sales_data.total_sales': -1 });
    
    return storeDishes.map(sd => {
      // 合并Dish和StoreDish信息
      const dish = sd.dish_id;
      if (!dish) return null;
      
      const dishObj = dish.toObject();
      // 用门店特定的价格覆盖默认价格
      if (sd.price_override !== undefined && sd.price_override !== null) {
        dishObj.price = sd.price_override;
      }
      if (sd.discount_price_override !== undefined && sd.discount_price_override !== null) {
        dishObj.discount_price = sd.discount_price_override;
      }
      
      // 添加门店特定的属性
      dishObj.store_specific_description = sd.store_specific_description;
      dishObj.inventory = sd.inventory;
      dishObj.sales_data = sd.sales_data;
      dishObj.store_attributes = sd.attributes;
      
      return dishObj;
    }).filter(Boolean); // 过滤掉null值
  },
  
  /**
   * 检查门店是否可以配送到特定位置
   * @param {Array} coordinates 目标位置的坐标 [经度, 纬度]
   * @returns {Boolean} 是否可配送
   */
  canDeliverTo(coordinates) {
    if (!this.address || !this.address.location || 
        !this.address.location.coordinates || 
        !Array.isArray(coordinates) || coordinates.length !== 2) {
      return false;
    }
    
    // 获取门店配送半径，根据商家类型不同会有不同默认值
    let deliveryRadius = 5; // 默认5公里
    
    if (this.type_specific_data && this.type_specific_data.restaurant) {
      deliveryRadius = this.type_specific_data.restaurant.delivery_radius || deliveryRadius;
    }
    
    // 计算两点之间的距离（使用简化的Haversine公式）
    const [lng1, lat1] = this.address.location.coordinates;
    const [lng2, lat2] = coordinates;
    
    const toRadians = deg => deg * Math.PI / 180;
    const R = 6371; // 地球半径，单位公里
    
    const dLat = toRadians(lat2 - lat1);
    const dLng = toRadians(lng2 - lng1);
    
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) *
              Math.sin(dLng/2) * Math.sin(dLng/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distance = R * c;
    
    return distance <= deliveryRadius;
  },
  
  /**
   * 更新门店评分
   * @param {Number} newRating 新的评分
   * @returns {Promise<Object>} 更新后的门店
   */
  async updateRating(newRating) {
    if (typeof newRating !== 'number' || newRating < 0 || newRating > 5) {
      throw new Error('评分必须是0-5之间的数字');
    }
    
    // 更新平均评分
    const currentCount = this.ratings.count || 0;
    const currentAvg = this.ratings.average || 0;
    
    const newCount = currentCount + 1;
    const newAvg = ((currentAvg * currentCount) + newRating) / newCount;
    
    this.ratings = {
      average: parseFloat(newAvg.toFixed(1)), // 保留一位小数
      count: newCount
    };
    
    return this.save();
  },
  
  /**
   * 获取分片键
   * @returns {String} 分片键
   */
  getShardKey() {
    // 优先使用地理位置作为分片键，否则使用商家ID
    return (this.address && this.address.location) ? 
           this.address.location.coordinates.join(',') : 
           this.merchant_id.toString();
  }
};

// 添加静态方法
storeSchema.statics = {
  /**
   * 查找附近的门店
   * @param {Array} coordinates 坐标 [经度, 纬度]
   * @param {Number} maxDistance 最大距离（公里）
   * @param {Object} filters 其他过滤条件
   * @returns {Promise<Array>} 门店列表
   */
  async findNearby(coordinates, maxDistance = 5, filters = {}) {
    // 转换最大距离为米
    const distanceInMeters = maxDistance * 1000;
    
    const query = {
      'address.location': {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: coordinates
          },
          $maxDistance: distanceInMeters
        }
      },
      is_active: true,
      ...filters
    };
    
    return this.find(query);
  },
  
  /**
   * 按评分查找热门门店
   * @param {Object} filters 过滤条件
   * @param {Number} limit 结果数量限制
   * @returns {Promise<Array>} 门店列表
   */
  async findPopular(filters = {}, limit = 10) {
    const query = {
      is_active: true,
      'ratings.count': { $gte: 5 }, // 至少有5个评分
      ...filters
    };
    
    return this.find(query)
      .sort({ 'ratings.average': -1 })
      .limit(limit);
  },
  
  /**
   * 获取特定商户的所有门店
   * @param {ObjectId} merchantId 商户ID
   * @param {Boolean} includeInactive 是否包含非活跃门店
   * @returns {Promise<Array>} 门店列表
   */
  async findByMerchant(merchantId, includeInactive = false) {
    const query = { merchant_id: merchantId };
    
    if (!includeInactive) {
      query.is_active = true;
    }
    
    return this.find(query);
  }
};

// 更新前自动更新时间
storeSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Store = ModelFactory.model('Store', storeSchema);

// 添加分片支持的保存方法
const originalSave = Store.prototype.save;
Store.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.Store) {
    // 使用地理位置分片策略
    const shardKey = this.getShardKey();
    const shardCollection = shardingService.getShardName('Store', shardKey);
    console.log(`将门店信息保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = Store; 