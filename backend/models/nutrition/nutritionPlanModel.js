const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

// 营养计划模式定义
const nutritionPlanSchema = new Schema({
  // 用户信息
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '关联用户ID'
  },
  
  // 基本信息
  name: {
    type: String,
    required: true,
    trim: true,
    description: '计划名称'
  },
  description: {
    type: String,
    trim: true,
    description: '计划描述'
  },
  
  // 计划状态
  status: {
    type: String,
    enum: ['draft', 'active', 'completed', 'canceled'],
    default: 'draft',
    description: '计划状态：草稿、激活、完成、取消'
  },

  visibility: {
    type: String,
    enum: ['private', 'shared', 'public'],
    default: 'private',
    description: '计划可见性：private仅自己可见，shared指定人群，public公开展示'
  },
  
  // 计划周期
  startDate: {
    type: Date,
    required: true,
    description: '开始日期'
  },
  endDate: {
    type: Date,
    required: true,
    description: '结束日期'
  },
  
  // 计划目标
  goals: [{
    type: {
      type: String,
      enum: ['weight', 'nutrition', 'health', 'fitness', 'custom'],
      required: true,
      description: '目标类型'
    },
    target: {
      type: Schema.Types.Mixed,
      required: true,
      description: '目标值'
    },
    description: {
      type: String,
      description: '目标描述'
    },
    priority: {
      type: Number,
      min: 1,
      max: 5,
      default: 3,
      description: '优先级：1-5，5为最高优先级'
    },
    measurable: {
      type: Boolean,
      default: true,
      description: '该目标是否可量化（如体重）'
    }
  }],
  
  // 每日计划
  dailyPlans: [{
    date: {
      type: Date,
      required: true,
      description: '日期'
    },
    meals: [{
      mealType: {
        type: String,
        enum: ['breakfast', 'lunch', 'dinner', 'snack'],
        required: true,
        description: '餐点类型'
      },
      time: {
        type: String,
        description: '用餐时间，格式如 08:00'
      },
      dishes: [{
        dishId: {
          type: Schema.Types.ObjectId,
          ref: 'StoreDish',
          description: '菜品ID'
        },
        dishName: {
          type: String,
          description: '菜品名称'
        },
        merchantId: {
          type: Schema.Types.ObjectId,
          ref: 'Store',
          description: '商家ID'
        },
        merchantName: {
          type: String,
          description: '商家名称'
        },
        quantity: {
          type: Number,
          default: 1,
          min: 0.1,
          description: '数量'
        },
        unit: {
          type: String,
          default: '份',
          description: '单位'
        },
        calories: {
          type: Number,
          description: '卡路里'
        },
        protein: {
          type: Number,
          description: '蛋白质(克)'
        },
        carbs: {
          type: Number,
          description: '碳水化合物(克)'
        },
        fat: {
          type: Number,
          description: '脂肪(克)'
        },
        notes: {
          type: String,
          description: '备注'
        },
        tags: {
          type: [String],
          default: [],
          description: '菜品标签（如高蛋白、低脂等）'
        }
      }],
      totalCalories: {
        type: Number,
        description: '该餐总卡路里'
      },
      totalProtein: {
        type: Number,
        description: '该餐总蛋白质(克)'
      },
      totalCarbs: {
        type: Number,
        description: '该餐总碳水化合物(克)'
      },
      totalFat: {
        type: Number,
        description: '该餐总脂肪(克)'
      },
      notes: {
        type: String,
        description: '餐点备注'
      }
    }],
    dailyCalories: {
      type: Number,
      description: '每日总卡路里'
    },
    dailyProtein: {
      type: Number,
      description: '每日总蛋白质(克)'
    },
    dailyCarbs: {
      type: Number,
      description: '每日总碳水化合物(克)'
    },
    dailyFat: {
      type: Number,
      description: '每日总脂肪(克)'
    },
    waterIntake: {
      type: Number,
      description: '每日水摄入量(毫升)'
    },
    completed: {
      type: Boolean,
      default: false,
      description: '当天计划是否已完成'
    },
    note: {
      type: String,
      description: '每日备注'
    }
  }],
  
  // 用户进度
  progress: [{
    date: {
      type: Date,
      required: true,
      description: '记录日期'
    },
    metrics: [{
      name: {
        type: String,
        required: true,
        description: '指标名称（如体重、体脂等）'
      },
      value: {
        type: Schema.Types.Mixed,
        required: true,
        description: '指标值'
      },
      unit: {
        type: String,
        description: '单位'
      },
      trend: {
        type: String,
        enum: ['up', 'down', 'stable'],
        description: '该指标的趋势（上升、下降、持平）'
      }
    }],
    note: {
      type: String,
      description: '进度备注'
    },
    feeling: {
      type: String,
      enum: ['excellent', 'good', 'neutral', 'bad', 'terrible'],
      description: '用户感受'
    }
  }],
  
  // 相关推荐
  relatedRecommendationId: {
    type: Schema.Types.ObjectId,
    ref: 'AiRecommendation',
    description: '关联的AI推荐ID'
  },
  
  // 反馈和评价
  feedback: {
    rating: {
      type: Number,
      min: 1,
      max: 5,
      description: '用户评分(1-5)'
    },
    comment: {
      type: String,
      description: '用户评论'
    },
    submittedAt: {
      type: Date,
      description: '提交评价的时间'
    }
  },
  
  // 创建者和修改者
  createdBy: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    description: '创建者ID'
  },
  updatedBy: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    description: '最后更新者ID'
  }
}, { timestamps: true });

// 索引
nutritionPlanSchema.index({ userId: 1, status: 1 });
nutritionPlanSchema.index({ startDate: 1, endDate: 1 });
nutritionPlanSchema.index({ 'dailyPlans.date': 1 });

// 虚拟字段：计算计划当前进度百分比
nutritionPlanSchema.virtual('progressPercentage').get(function() {
  const now = new Date();
  const start = this.startDate;
  const end = this.endDate;
  
  if (now < start) return 0;
  if (now > end) return 100;
  
  const totalDays = Math.floor((end - start) / (1000 * 60 * 60 * 24));
  const daysPassed = Math.floor((now - start) / (1000 * 60 * 60 * 24));
  
  return Math.round((daysPassed / totalDays) * 100);
});

// 方法：获取特定日期的计划
nutritionPlanSchema.methods.getPlanForDate = function(date) {
  const dateStr = new Date(date).toISOString().split('T')[0];
  
  return this.dailyPlans.find(plan => {
    const planDateStr = new Date(plan.date).toISOString().split('T')[0];
    return planDateStr === dateStr;
  });
};

// 方法：更新进度
nutritionPlanSchema.methods.updateProgress = async function(progressData) {
  this.progress.push(progressData);
  return this.save();
};

// 方法：完成某天的计划
nutritionPlanSchema.methods.completeDay = async function(date, note = '') {
  const dateStr = new Date(date).toISOString().split('T')[0];
  
  let found = false;
  for (let i = 0; i < this.dailyPlans.length; i++) {
    const planDateStr = new Date(this.dailyPlans[i].date).toISOString().split('T')[0];
    if (planDateStr === dateStr) {
      this.dailyPlans[i].completed = true;
      if (note) {
        this.dailyPlans[i].note = note;
      }
      found = true;
      break;
    }
  }
  
  if (found) {
    return this.save();
  }
  
  return false;
};

// 方法：提交反馈
nutritionPlanSchema.methods.submitFeedback = async function(rating, comment) {
  this.feedback = {
    rating,
    comment,
    submittedAt: new Date()
  };
  
  return this.save();
};

// 使用ModelFactory创建支持读写分离的用户营养计划模型
const NutritionPlan = ModelFactory.createModel('NutritionPlan', nutritionPlanSchema);

// 添加分片支持
const originalSave = NutritionPlan.prototype.save;
NutritionPlan.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled &&
      shardingService.config.strategies.NutritionPlan) {
    // 按用户ID分片
    const shardKey = this.userId.toString();
    const shardCollection = shardingService.getShardName('NutritionPlan', shardKey);
    console.log(`将营养计划保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = NutritionPlan;