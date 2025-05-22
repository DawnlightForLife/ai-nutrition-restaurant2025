const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');
const { merchantTypeValues } = require('./merchantTypeEnum');

// 导入需要的模型
const StoreDish = require('./storeDishModel');
const Dish = require('./productDishModel');

const storeSchema = new mongoose.Schema({
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    description: '关联的商家 ID',
    sensitivityLevel: 2
  },
  storeName: {
    type: String,
    required: true,
    description: '门店名称'
  },
  storeAddress: {
    province: {
      type: String,
      required: true,
      description: '省份',
      sensitivityLevel: 2
    },
    city: {
      type: String,
      required: true,
      description: '城市',
      sensitivityLevel: 2
    },
    district: {
      type: String,
      required: true,
      description: '区/县',
      sensitivityLevel: 2
    },
    street: {
      type: String,
      required: true,
      description: '街道地址',
      sensitivityLevel: 3
    },
    location: {
      lng: {
        type: Number,
        default: 0,
        description: '经度',
        sensitivityLevel: 3
      },
      lat: {
        type: Number,
        default: 0,
        description: '纬度',
        sensitivityLevel: 3
      }
    }
  },
  contactPhone: {
    type: String,
    required: true,
    description: '联系电话',
    sensitivityLevel: 3
  },
  managerName: {
    type: String,
    required: true,
    description: '门店负责人姓名',
    sensitivityLevel: 2
  },
  managerPhone: {
    type: String,
    required: true,
    description: '负责人联系电话',
    sensitivityLevel: 3
  },
  imageUrls: [{
    type: String,
    description: '门店图片列表'
  }],
  businessHours: [{
    day: {
      type: String,
      enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
      required: true,
      description: '星期几'
    },
    open: {
      type: String,
      required: true,
      description: '开店时间'
    },
    close: {
      type: String,
      required: true,
      description: '关店时间'
    }
  }],
  closedDates: [{
    type: Date,
    description: '临时闭店日期（如节假日）'
  }],
  // 门店级特定类型属性
  typeSpecificVersion: {
    type: String,
    default: 'v1',
    description: '类型特定字段版本控制'
  },
  storeType: {
    type: String,
    enum: merchantTypeValues,
    required: true,
    description: '门店类型'
  },
  typeSpecificData: {
    // 餐厅特有
    restaurant: {
      seatingCapacity: { type: Number, description: '就餐座位数' },
      privateRooms: Number,
      cuisineFocus: [String],
      deliveryRadius: Number // 公里
    },
    // 健身房特有
    gym: {
      equipmentCount: { type: Number, description: '健身器械数量' },
      showerRooms: Number,
      lockerCount: Number,
      classSchedule: [String]
    },
    // 月子中心特有
    maternityCenter: {
      bedCount: { type: Number, description: '床位数量' },
      nannyCount: Number,
      doctorCount: Number,
      facilities: [String]
    },
    // 学校/公司食堂特有
    schoolCompany: {
      capacity: { type: Number, description: '食堂容量' },
      servingTimes: [String],
      numberOfCounters: Number,
      specialDietaryOptions: Boolean
    }
  },
  isActive: {
    type: Boolean,
    default: true,
    description: '是否为活跃状态'
  },
  ratings: {
    average: {
      type: Number,
      default: 0,
      description: '平均评分'
    },
    count: {
      type: Number,
      default: 0,
      description: '评分次数'
    },
    lastUpdated: {
      type: Date,
      default: Date.now,
      description: '评分最后更新时间'
    },
    distribution: {
      type: Map,
      of: Number,
      default: {},
      description: '各评分档次的数量分布（如：5星、4星）'
    }
  },
  description: {
    type: String,
    description: '门店简介'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建地理空间索引
storeSchema.index({ 'storeAddress.location': '2dsphere' });
// 创建商家ID索引，便于查询特定商家的所有门店
storeSchema.index({ merchantId: 1 });
// 创建名称文本索引，便于门店搜索
storeSchema.index({ storeName: 'text' });
// 创建省市区组合索引，便于按地区查询门店
storeSchema.index({ 'storeAddress.province': 1, 'storeAddress.city': 1, 'storeAddress.district': 1 });
// 创建评分索引，便于查询高评分门店
storeSchema.index({ 'ratings.average': -1 });
// 创建活跃状态索引，便于查询活跃门店
storeSchema.index({ isActive: 1 });

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

storeSchema.virtual('fullAddress').get(function() {
  if (!this.storeAddress) return '';
  return `${this.storeAddress.province} ${this.storeAddress.city} ${this.storeAddress.district} ${this.storeAddress.street}`;
});

storeSchema.virtual('isOpen').get(function() {
  if (!this.businessHours || this.businessHours.length === 0) return false;
  
  // 获取当前时间和星期几
  const now = new Date();
  const dayOfWeek = now.getDay(); // 0是星期日，1-6是星期一到星期六
  const daysMap = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday'
  };
  
  // 查找今天的营业时间
  const todayHours = this.businessHours.find(hours => hours.day === daysMap[dayOfWeek]);
  if (!todayHours) return false;
  
  // 解析营业时间
  const [openHour, openMinute] = todayHours.open.split(':').map(Number);
  const [closeHour, closeMinute] = todayHours.close.split(':').map(Number);
  
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
    if (!this.businessHours || this.businessHours.length === 0) return false;
    
    const dayOfWeek = date.getDay();
    const daysMap = {
      0: 'Sunday',
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday'
    };
    
    // 查找特定日期的营业时间
    const dayHours = this.businessHours.find(hours => hours.day === daysMap[dayOfWeek]);
    if (!dayHours) return false;
    
    // 解析营业时间
    const [openHour, openMinute] = dayHours.open.split(':').map(Number);
    const [closeHour, closeMinute] = dayHours.close.split(':').map(Number);
    
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
      storeId: this._id,
      isAvailable: true
    };
    
    if (options.category) {
      // 这里需要通过关联Dish模型查询特定分类的菜品
      const dishes = await Dish.find({ category: options.category });
      const dishIds = dishes.map(dish => dish._id);
      query.dishId = { $in: dishIds };
    }
    
    const storeDishes = await StoreDish.find(query)
      .populate('dishId')
      .sort(options.sort || { 'salesData.totalSales': -1 });
    
    return storeDishes.map(sd => {
      // 合并Dish和StoreDish信息
      const dish = sd.dishId;
      if (!dish) return null;
      
      const dishObj = dish.toObject();
      // 用门店特定的价格覆盖默认价格
      if (sd.priceOverride !== undefined && sd.priceOverride !== null) {
        dishObj.price = sd.priceOverride;
      }
      if (sd.discountPriceOverride !== undefined && sd.discountPriceOverride !== null) {
        dishObj.discountPrice = sd.discountPriceOverride;
      }
      
      // 添加门店特定的属性
      dishObj.storeSpecificDescription = sd.storeSpecificDescription;
      dishObj.inventory = sd.inventory;
      dishObj.salesData = sd.salesData;
      dishObj.storeAttributes = sd.attributes;
      
      return dishObj;
    }).filter(Boolean); // 过滤掉null值
  },
  
  /**
   * 检查门店是否可以配送到特定位置
   * @param {Array} coordinates 目标位置的坐标 [lng, lat]
   * @returns {Boolean} 是否可配送
   */
  canDeliverTo(coordinates) {
    if (!this.storeAddress || !this.storeAddress.location || 
        !this.storeAddress.location.lng || !this.storeAddress.location.lat || 
        !Array.isArray(coordinates) || coordinates.length !== 2) {
      return false;
    }
    
    // 获取门店配送半径，根据商家类型不同会有不同默认值
    let deliveryRadius = 5; // 默认5公里
    
    if (this.typeSpecificData && this.typeSpecificData.restaurant) {
      deliveryRadius = this.typeSpecificData.restaurant.deliveryRadius || deliveryRadius;
    }
    
    // 计算两点之间的距离（使用简化的Haversine公式）
    const lng1 = this.storeAddress.location.lng;
    const lat1 = this.storeAddress.location.lat;
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
    const currentDistribution = this.ratings.distribution || new Map();
    
    const newCount = currentCount + 1;
    const newAvg = ((currentAvg * currentCount) + newRating) / newCount;
    
    // 更新评分分布
    const star = Math.round(newRating).toString();
    const newDistribution = new Map(currentDistribution);
    newDistribution.set(star, (newDistribution.get(star) || 0) + 1);
    
    this.ratings = {
      average: parseFloat(newAvg.toFixed(1)), // 保留一位小数
      count: newCount,
      lastUpdated: new Date(),
      distribution: newDistribution
    };
    
    return this.save();
  },
  
  /**
   * 获取分片键
   * @returns {String} 分片键
   */
  getShardKey() {
    // 优先使用地理位置作为分片键，否则使用商家ID
    return (this.storeAddress && this.storeAddress.location) ? 
           `${this.storeAddress.location.lng},${this.storeAddress.location.lat}` : 
           this.merchantId.toString();
  }
};

// 添加静态方法
storeSchema.statics = {
  /**
   * 查找附近的门店
   * @param {Array} coordinates 坐标 [lng, lat]
   * @param {Number} maxDistance 最大距离（公里）
   * @param {Object} filters 其他过滤条件
   * @returns {Promise<Array>} 门店列表
   */
  async findNearby(coordinates, maxDistance = 5, filters = {}) {
    // 转换最大距离为米
    const distanceInMeters = maxDistance * 1000;
    
    const query = {
      'storeAddress.location': {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [coordinates[0], coordinates[1]]
          },
          $maxDistance: distanceInMeters
        }
      },
      isActive: true,
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
      isActive: true,
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
    const query = { merchantId: merchantId };
    
    if (!includeInactive) {
      query.isActive = true;
    }
    
    return this.find(query);
  }
};

// 使用ModelFactory创建支持读写分离的模型
const Store = ModelFactory.createModel('Store', storeSchema);

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