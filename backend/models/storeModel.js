const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

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
    const coordinates = this.address && this.address.location ? 
                        this.address.location.coordinates : null;
    // 如果有地理位置信息，则使用地理位置作为分片键，否则使用商家ID
    const shardKey = coordinates || this.merchant_id.toString();
    const shardCollection = shardingService.getShardName('Store', shardKey);
    console.log(`将门店信息保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = Store; 