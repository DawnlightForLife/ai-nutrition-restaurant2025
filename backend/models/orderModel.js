const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
  dish_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true
  },
  name: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
    default: 1
  },
  customizations: [{
    option_name: String,
    option_value: String,
    additional_price: {
      type: Number,
      default: 0
    }
  }],
  special_instructions: String,
  item_total: {
    type: Number,
    required: true
  }
});

const orderSchema = new mongoose.Schema({
  order_number: {
    type: String,
    required: true,
    unique: true
  },
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  merchant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true
  },
  merchant_type: {
    type: String,
    enum: ['restaurant', 'gym', 'maternity_center', 'school_company'],
    required: true
  },
  items: [orderItemSchema],
  // 使用的营养档案（可选）
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  // 相关的AI推荐
  ai_recommendation_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation'
  },
  // 订单状态
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded'],
    default: 'pending'
  },
  // 订单类型
  order_type: {
    type: String,
    enum: ['dine_in', 'takeout', 'delivery', 'catering', 'subscription'],
    default: 'dine_in'
  },
  // 支付信息
  payment: {
    method: {
      type: String,
      enum: ['cash', 'credit_card', 'debit_card', 'mobile_payment', 'subscription', 'other'],
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'partially_refunded', 'refunded', 'failed'],
      default: 'pending'
    },
    transaction_id: String,
    payment_time: Date,
    refund_id: String,
    refund_time: Date
  },
  // 价格明细
  price_details: {
    subtotal: {
      type: Number,
      required: true
    },
    tax: {
      type: Number,
      default: 0
    },
    delivery_fee: {
      type: Number,
      default: 0
    },
    service_fee: {
      type: Number,
      default: 0
    },
    tip: {
      type: Number,
      default: 0
    },
    discount: {
      type: Number,
      default: 0
    },
    discount_code: String,
    total: {
      type: Number,
      required: true
    }
  },
  // 配送信息（如适用）
  delivery: {
    address: {
      line1: String,
      line2: String,
      city: String,
      state: String,
      postal_code: String,
      country: {
        type: String,
        default: 'China'
      },
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    },
    contact_name: String,
    contact_phone: String,
    delivery_instructions: String,
    estimated_delivery_time: Date,
    actual_delivery_time: Date,
    delivery_person: {
      id: String,
      name: String,
      phone: String
    }
  },
  // 堂食信息
  dine_in: {
    table_number: String,
    number_of_people: Number,
    estimated_completion_time: Date
  },
  // 订单营养摘要（汇总所有菜品）
  nutrition_summary: {
    calories: Number,
    protein: Number,
    fat: Number,
    carbohydrates: Number,
    suitable_for_health_conditions: [String],
    allergens: [String]
  },
  // 订单与营养目标吻合度评分（由AI计算）
  nutrition_goal_alignment: {
    score: {
      type: Number,
      min: 0,
      max: 100
    },
    analysis: String
  },
  // 访问控制与隐私
  privacy_level: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private'
  },
  // 订单访问授权
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['Nutritionist', 'Merchant', 'Admin']
    },
    granted_at: {
      type: Date,
      default: Date.now
    },
    valid_until: Date,
    access_level: {
      type: String,
      enum: ['read', 'read_write'],
      default: 'read'
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: Date
  }],
  // 评价
  rating: {
    overall: {
      type: Number,
      min: 1,
      max: 5
    },
    food_quality: {
      type: Number,
      min: 1,
      max: 5
    },
    service: {
      type: Number,
      min: 1,
      max: 5
    },
    delivery_experience: {
      type: Number,
      min: 1,
      max: 5
    },
    nutrition_quality: {
      type: Number,
      min: 1,
      max: 5
    },
    review_text: String,
    review_date: Date,
    merchant_response: String,
    merchant_response_date: Date
  },
  // 数据审计
  status_history: [{
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded']
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    updated_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'status_history.updated_by_type'
    },
    updated_by_type: {
      type: String,
      enum: ['User', 'Merchant', 'Admin', 'System']
    },
    notes: String
  }],
  // 安全和审计
  access_log: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    accessed_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_log.accessed_by_type'
    },
    accessed_by_type: {
      type: String,
      enum: ['User', 'Merchant', 'Nutritionist', 'Admin', 'System']
    },
    ip_address: String,
    action: {
      type: String,
      enum: ['view', 'update', 'pay', 'cancel', 'refund', 'rate']
    }
  }],
  // 时间戳
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

// 创建索引
orderSchema.index({ order_number: 1 }, { unique: true });
orderSchema.index({ user_id: 1, created_at: -1 });
orderSchema.index({ merchant_id: 1, created_at: -1 });
orderSchema.index({ status: 1 });
orderSchema.index({ 'payment.status': 1 });
orderSchema.index({ nutrition_profile_id: 1 });
orderSchema.index({ ai_recommendation_id: 1 });
orderSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
orderSchema.index({ merchant_type: 1 });

// 生成唯一订单号
orderSchema.pre('save', async function(next) {
  if (this.isNew) {
    const now = new Date();
    const year = now.getFullYear().toString().substr(-2);
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
    
    // 尝试生成一个唯一的订单号
    let isUnique = false;
    let attempts = 0;
    let generatedNumber;
    
    while (!isUnique && attempts < 10) {
      generatedNumber = `ORD${year}${month}${day}${random}${attempts}`;
      
      // 检查是否唯一
      const existingOrder = await this.constructor.findOne({ order_number: generatedNumber });
      if (!existingOrder) {
        isUnique = true;
      }
      
      attempts++;
    }
    
    if (!isUnique) {
      return next(new Error('无法生成唯一订单号'));
    }
    
    this.order_number = generatedNumber;
  }
  
  // 更新时间
  this.updated_at = Date.now();
  
  next();
});

// 计算订单营养摘要
orderSchema.methods.calculateNutritionSummary = async function() {
  if (!this.items || this.items.length === 0) return null;
  
  // 优化：收集所有菜品ID，使用一次查询获取所有需要的菜品
  const dishIds = this.items.map(item => item.dish_id);
  const dishes = await mongoose.model('Dish').find({ _id: { $in: dishIds } });
  
  // 创建菜品ID到菜品对象的映射，便于快速查找
  const dishMap = {};
  dishes.forEach(dish => {
    dishMap[dish._id.toString()] = dish;
  });
  
  let totalCalories = 0;
  let totalProtein = 0;
  let totalFat = 0;
  let totalCarbs = 0;
  const allergens = new Set();
  const healthConditions = new Set();
  
  // 遍历订单项，使用映射快速获取菜品数据
  for (const item of this.items) {
    const dishId = item.dish_id.toString();
    const dish = dishMap[dishId];
    if (!dish || !dish.nutrition_facts) continue;
    
    const quantity = item.quantity || 1;
    totalCalories += (dish.nutrition_facts.calories || 0) * quantity;
    totalProtein += (dish.nutrition_facts.protein || 0) * quantity;
    totalFat += (dish.nutrition_facts.fat || 0) * quantity;
    totalCarbs += (dish.nutrition_facts.carbohydrates || 0) * quantity;
    
    // 收集过敏原
    if (dish.allergens && dish.allergens.length > 0) {
      dish.allergens.forEach(allergen => allergens.add(allergen));
    }
    
    // 收集适用的健康条件
    if (dish.health_benefits && dish.health_benefits.length > 0) {
      dish.health_benefits.forEach(benefit => healthConditions.add(benefit.target_condition));
    }
  }
  
  // 更新营养摘要
  this.nutrition_summary = {
    calories: totalCalories,
    protein: totalProtein,
    fat: totalFat,
    carbohydrates: totalCarbs,
    allergens: Array.from(allergens),
    suitable_for_health_conditions: Array.from(healthConditions)
  };
  
  return this.nutrition_summary;
};

// 评估订单与用户营养目标的匹配度
orderSchema.methods.evaluateNutritionAlignment = async function() {
  if (!this.nutrition_profile_id) return null;
  
  try {
    // 如果已经有评估结果且是在最近1小时内计算的，直接返回
    if (this.nutrition_goal_alignment && this.updated_at) {
      const lastUpdateTime = new Date(this.updated_at).getTime();
      const currentTime = Date.now();
      // 1小时 = 3600000毫秒
      if (currentTime - lastUpdateTime < 3600000) {
        return this.nutrition_goal_alignment;
      }
    }
    
    // 确保已计算营养摘要
    if (!this.nutrition_summary) {
      await this.calculateNutritionSummary();
    }
    
    // 使用聚合管道进行高效查询 - 一次查询获取所有需要的数据
    const NutritionProfile = mongoose.model('NutritionProfile');
    const aggregationResult = await NutritionProfile.aggregate([
      // 匹配指定的营养档案
      { $match: { _id: mongoose.Types.ObjectId(this.nutrition_profile_id) } },
      // 只获取需要的字段
      { $project: {
          goals: 1,
          'dietary_preferences.allergies': 1
      }}
    ]).exec();
    
    const nutritionProfile = aggregationResult[0];
    if (!nutritionProfile) return null;
    
    let score = 0;
    let analysis = [];
    
    // 1. 检查过敏原和避免的食材
    const allergies = nutritionProfile.dietary_preferences?.allergies || [];
    const hasAllergens = allergies.some(
      allergen => this.nutrition_summary.allergens.includes(allergen)
    );
    
    if (hasAllergens) {
      score = 0;
      analysis.push('该订单包含您的过敏原，不建议食用！');
      
      this.nutrition_goal_alignment = {
        score,
        analysis: analysis.join(' ')
      };
      
      return this.nutrition_goal_alignment;
    }
    
    // 2. 评估是否符合健康目标
    // 转换营养目标为健康条件
    let targetCondition;
    switch(nutritionProfile.goals) {
      case 'weight_loss': targetCondition = 'weight_loss'; break;
      case 'weight_gain': targetCondition = 'muscle_gain'; break;
      case 'muscle_gain': targetCondition = 'muscle_gain'; break;
      case 'health_improvement': targetCondition = 'general_health'; break;
      default: targetCondition = null;
    }
    
    if (targetCondition && this.nutrition_summary.suitable_for_health_conditions.includes(targetCondition)) {
      score += 30;
      analysis.push(`这顿饮食非常符合您的${nutritionProfile.goals}目标。`);
    } else {
      score += 10;
      analysis.push(`这顿饮食对您的${nutritionProfile.goals}目标帮助有限。`);
    }
    
    // 3. 评估宏量营养素比例
    // 计算卡路里比例
    const totalCalories = this.nutrition_summary.calories;
    const proteinCalories = this.nutrition_summary.protein * 4; // 蛋白质: 4卡/克
    const fatCalories = this.nutrition_summary.fat * 9; // 脂肪: 9卡/克
    const carbCalories = this.nutrition_summary.carbohydrates * 4; // 碳水: 4卡/克
    
    const proteinPercentage = (proteinCalories / totalCalories) * 100;
    const fatPercentage = (fatCalories / totalCalories) * 100;
    const carbPercentage = (carbCalories / totalCalories) * 100;
    
    // 根据健康目标调整理想的宏量营养素比例
    let idealProteinRange, idealFatRange, idealCarbRange;
    
    switch(nutritionProfile.goals) {
      case 'weight_loss':
        idealProteinRange = [25, 35];
        idealFatRange = [20, 35];
        idealCarbRange = [30, 45];
        break;
      case 'muscle_gain':
        idealProteinRange = [30, 40];
        idealFatRange = [20, 30];
        idealCarbRange = [40, 50];
        break;
      default: // 维持或一般健康改善
        idealProteinRange = [15, 25];
        idealFatRange = [20, 35];
        idealCarbRange = [45, 65];
    }
    
    // 评估各宏量营养素是否在理想范围内
    const proteinScore = (proteinPercentage >= idealProteinRange[0] && proteinPercentage <= idealProteinRange[1]) ? 20 : 10;
    const fatScore = (fatPercentage >= idealFatRange[0] && fatPercentage <= idealFatRange[1]) ? 20 : 10;
    const carbScore = (carbPercentage >= idealCarbRange[0] && carbPercentage <= idealCarbRange[1]) ? 20 : 10;
    
    score += proteinScore + fatScore + carbScore;
    
    // 宏营养素分析
    if (proteinScore === 20) {
      analysis.push(`蛋白质摄入比例(${proteinPercentage.toFixed(1)}%)适中。`);
    } else if (proteinPercentage < idealProteinRange[0]) {
      analysis.push(`蛋白质摄入比例(${proteinPercentage.toFixed(1)}%)偏低，建议增加瘦肉、鱼、蛋、豆类等蛋白质食物。`);
    } else {
      analysis.push(`蛋白质摄入比例(${proteinPercentage.toFixed(1)}%)偏高，可适当减少。`);
    }
    
    if (fatScore === 20) {
      analysis.push(`脂肪摄入比例(${fatPercentage.toFixed(1)}%)适中。`);
    } else if (fatPercentage < idealFatRange[0]) {
      analysis.push(`脂肪摄入比例(${fatPercentage.toFixed(1)}%)偏低，适量健康脂肪有益健康。`);
    } else {
      analysis.push(`脂肪摄入比例(${fatPercentage.toFixed(1)}%)偏高，建议减少摄入。`);
    }
    
    if (carbScore === 20) {
      analysis.push(`碳水摄入比例(${carbPercentage.toFixed(1)}%)适中。`);
    } else if (carbPercentage < idealCarbRange[0]) {
      analysis.push(`碳水摄入比例(${carbPercentage.toFixed(1)}%)偏低，可适当增加全谷物、水果等优质碳水。`);
    } else {
      analysis.push(`碳水摄入比例(${carbPercentage.toFixed(1)}%)偏高，建议减少精制碳水摄入。`);
    }
    
    // 保存评分和分析
    this.nutrition_goal_alignment = {
      score: Math.min(score, 100), // 确保不超过100
      analysis: analysis.join(' ')
    };
    
    // 更新时间戳，用于缓存机制
    this.updated_at = Date.now();
    await this.save();
    
    return this.nutrition_goal_alignment;
  } catch (error) {
    console.error('评估营养匹配度时出错:', error);
    return null;
  }
};

// 授权访问方法
orderSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, accessLevel = 'read') {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已存在授权
  const existingGrant = this.access_grants.find(
    g => g.granted_to.equals(granteeId) && g.granted_to_type === granteeType && !g.revoked
  );
  
  if (existingGrant) {
    // 更新现有授权
    existingGrant.valid_until = validUntil;
    existingGrant.access_level = accessLevel;
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel
    });
  }
};

// 撤销授权方法
orderSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = Date.now();
      found = true;
    }
  });
  
  return found;
};

// 记录状态变更
orderSchema.methods.updateStatus = function(newStatus, updatedBy, updatedByType, notes) {
  // 更新当前状态
  this.status = newStatus;
  
  // 记录状态历史
  if (!this.status_history) {
    this.status_history = [];
  }
  
  this.status_history.push({
    status: newStatus,
    timestamp: Date.now(),
    updated_by: updatedBy,
    updated_by_type: updatedByType,
    notes: notes
  });
};

// 记录访问日志
orderSchema.methods.logAccess = function(userId, userType, ipAddress, action) {
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 保持日志大小合理
  if (this.access_log.length >= 50) {
    this.access_log = this.access_log.slice(-49);
  }
  
  this.access_log.push({
    timestamp: Date.now(),
    accessed_by: userId,
    accessed_by_type: userType,
    ip_address: ipAddress,
    action: action
  });
};

// 安全查询方法 - 考虑访问控制
orderSchema.statics.findWithPermissionCheck = async function(query = {}, options = {}, user) {
  // 如果是用户查询自己的订单，直接返回
  if (user && query.user_id && user._id.equals(query.user_id)) {
    return this.find(query, options);
  }
  
  // 如果是商户查询自己的订单
  if (user && user.role === 'merchant' && query.merchant_id && user._id.equals(query.merchant_id)) {
    return this.find(query, options);
  }
  
  // 如果是营养师，检查是否有授权
  if (user && user.role === 'nutritionist') {
    const nutritionistId = user._id;
    
    // 扩展查询条件，添加权限检查
    const permissionQuery = {
      ...query,
      $or: [
        // 用户授权给这个营养师的订单
        { 'access_grants.granted_to': nutritionistId, 'access_grants.granted_to_type': 'Nutritionist', 'access_grants.revoked': false },
        // 用户在隐私设置中分享给营养师的订单
        { privacy_level: 'share_with_nutritionist' }
      ]
    };
    
    return this.find(permissionQuery, options);
  }
  
  // 如果是管理员，直接返回结果
  if (user && (user.role === 'admin' || user.role === 'super_admin')) {
    return this.find(query, options);
  }
  
  // 其他情况，返回空结果
  return [];
};

const Order = mongoose.model('Order', orderSchema);

module.exports = Order; 