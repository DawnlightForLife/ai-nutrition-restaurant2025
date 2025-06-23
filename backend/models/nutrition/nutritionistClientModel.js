const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

/**
 * 营养师客户关系模型
 * 记录营养师与客户的关系和管理信息
 */
const nutritionistClientSchema = new mongoose.Schema({
  // 营养师ID
  nutritionistId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist',
    required: true
  },
  // 客户用户ID
  clientUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // 关系建立时间
  relationshipStartDate: {
    type: Date,
    default: Date.now
  },
  // 关系状态
  relationshipStatus: {
    type: String,
    enum: ['active', 'inactive', 'completed', 'paused'],
    default: 'active'
  },
  // 客户分类标签
  clientTags: [{
    type: String
  }],
  // 营养师备注
  nutritionistNotes: {
    type: String,
    sensitivityLevel: 2
  },
  // 客户健康概况
  healthOverview: {
    // 主要健康目标
    primaryGoals: [{
      type: String
    }],
    // 当前健康状况
    currentConditions: [{
      type: String
    }],
    // 饮食偏好
    dietaryPreferences: [{
      type: String
    }],
    // 过敏信息
    allergies: [{
      type: String
    }],
    // 最后更新时间
    lastUpdated: {
      type: Date,
      default: Date.now
    }
  },
  // 咨询历史统计
  consultationStats: {
    // 总咨询次数
    totalConsultations: {
      type: Number,
      default: 0
    },
    // 最后咨询时间
    lastConsultationDate: {
      type: Date
    },
    // 下次预约时间
    nextAppointment: {
      type: Date
    },
    // 平均咨询间隔（天）
    averageConsultationInterval: {
      type: Number,
      default: 0
    }
  },
  // 进展跟踪
  progressTracking: {
    // 初始评估
    initialAssessment: {
      weight: Number,
      height: Number,
      bmi: Number,
      bodyFatPercentage: Number,
      muscleMass: Number,
      assessmentDate: Date
    },
    // 目标设定
    goals: [{
      type: {
        type: String,
        enum: ['weight', 'bodyFat', 'muscle', 'nutrition', 'lifestyle']
      },
      target: {
        type: String
      },
      targetValue: {
        type: Number
      },
      currentValue: {
        type: Number
      },
      unit: {
        type: String
      },
      deadline: {
        type: Date
      },
      status: {
        type: String,
        enum: ['pending', 'in_progress', 'achieved', 'paused'],
        default: 'pending'
      },
      createdAt: {
        type: Date,
        default: Date.now
      }
    }],
    // 进展记录
    progressEntries: [{
      date: {
        type: Date,
        default: Date.now
      },
      measurements: {
        weight: Number,
        bodyFatPercentage: Number,
        muscleMass: Number
      },
      notes: {
        type: String
      },
      mood: {
        type: String,
        enum: ['excellent', 'good', 'neutral', 'poor', 'terrible']
      },
      compliance: {
        type: Number,
        min: 0,
        max: 100
      }
    }]
  },
  // 营养计划管理
  nutritionPlanHistory: [{
    planId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'NutritionPlan'
    },
    startDate: {
      type: Date
    },
    endDate: {
      type: Date
    },
    status: {
      type: String,
      enum: ['active', 'completed', 'paused', 'cancelled']
    },
    compliance: {
      type: Number,
      min: 0,
      max: 100
    },
    feedback: {
      type: String
    }
  }],
  // 重要提醒
  reminders: [{
    type: {
      type: String,
      enum: ['appointment', 'follow_up', 'goal_check', 'plan_review', 'custom']
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String
    },
    dueDate: {
      type: Date,
      required: true
    },
    priority: {
      type: String,
      enum: ['low', 'medium', 'high', 'urgent'],
      default: 'medium'
    },
    completed: {
      type: Boolean,
      default: false
    },
    completedAt: {
      type: Date
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }],
  // 敏感度级别
  sensitivityLevel: {
    type: Number,
    default: 2,
    enum: [1, 2, 3]
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引
nutritionistClientSchema.index({ nutritionistId: 1, clientUserId: 1 }, { unique: true });
nutritionistClientSchema.index({ nutritionistId: 1, relationshipStatus: 1 });
nutritionistClientSchema.index({ clientUserId: 1 });
nutritionistClientSchema.index({ 'consultationStats.lastConsultationDate': -1 });
nutritionistClientSchema.index({ 'consultationStats.nextAppointment': 1 });
nutritionistClientSchema.index({ clientTags: 1 });
nutritionistClientSchema.index({ 'reminders.dueDate': 1, 'reminders.completed': 1 });

// 虚拟字段
nutritionistClientSchema.virtual('relationshipDuration').get(function() {
  return Math.floor((new Date() - this.relationshipStartDate) / (1000 * 60 * 60 * 24));
});

nutritionistClientSchema.virtual('daysSinceLastConsultation').get(function() {
  if (!this.consultationStats.lastConsultationDate) return null;
  return Math.floor((new Date() - this.consultationStats.lastConsultationDate) / (1000 * 60 * 60 * 24));
});

nutritionistClientSchema.virtual('isActive').get(function() {
  return this.relationshipStatus === 'active';
});

nutritionistClientSchema.virtual('pendingReminders').get(function() {
  return this.reminders.filter(reminder => 
    !reminder.completed && 
    reminder.dueDate <= new Date()
  ).length;
});

// 关联用户信息
nutritionistClientSchema.virtual('clientUser', {
  ref: 'User',
  localField: 'clientUserId',
  foreignField: '_id',
  justOne: true
});

// 关联营养师信息
nutritionistClientSchema.virtual('nutritionist', {
  ref: 'Nutritionist',
  localField: 'nutritionistId',
  foreignField: '_id',
  justOne: true
});

// 实例方法：添加进展记录
nutritionistClientSchema.methods.addProgressEntry = async function(progressData) {
  this.progressTracking.progressEntries.push({
    ...progressData,
    date: new Date()
  });
  
  // 更新健康概况最后更新时间
  this.healthOverview.lastUpdated = new Date();
  
  return await this.save();
};

// 实例方法：更新咨询统计
nutritionistClientSchema.methods.updateConsultationStats = async function() {
  const Consultation = require('../consult/consultationModel');
  
  const consultations = await Consultation.find({
    $or: [
      { userId: this.clientUserId, nutritionistId: this.nutritionistId },
      { userId: this.clientUserId, assignedNutritionistId: this.nutritionistId }
    ],
    status: { $in: ['completed', 'inProgress'] }
  }).sort({ createdAt: -1 });
  
  this.consultationStats.totalConsultations = consultations.length;
  
  if (consultations.length > 0) {
    this.consultationStats.lastConsultationDate = consultations[0].createdAt;
    
    // 计算平均咨询间隔
    if (consultations.length > 1) {
      const intervals = [];
      for (let i = 0; i < consultations.length - 1; i++) {
        const days = (consultations[i].createdAt - consultations[i + 1].createdAt) / (1000 * 60 * 60 * 24);
        intervals.push(days);
      }
      this.consultationStats.averageConsultationInterval = 
        intervals.reduce((sum, interval) => sum + interval, 0) / intervals.length;
    }
  }
  
  return await this.save();
};

// 实例方法：添加提醒
nutritionistClientSchema.methods.addReminder = async function(reminderData) {
  this.reminders.push({
    ...reminderData,
    createdAt: new Date()
  });
  
  return await this.save();
};

// 实例方法：完成提醒
nutritionistClientSchema.methods.completeReminder = async function(reminderId) {
  const reminder = this.reminders.id(reminderId);
  if (reminder) {
    reminder.completed = true;
    reminder.completedAt = new Date();
    return await this.save();
  }
  throw new Error('提醒不存在');
};

// 实例方法：更新目标进度
nutritionistClientSchema.methods.updateGoalProgress = async function(goalId, currentValue, notes) {
  const goal = this.progressTracking.goals.id(goalId);
  if (goal) {
    goal.currentValue = currentValue;
    
    // 检查是否达成目标
    if (goal.targetValue && currentValue >= goal.targetValue) {
      goal.status = 'achieved';
    } else if (goal.status === 'pending') {
      goal.status = 'in_progress';
    }
    
    // 添加进展记录
    await this.addProgressEntry({
      notes: notes || `目标"${goal.target}"进度更新：${currentValue} ${goal.unit}`,
      compliance: Math.min(100, (currentValue / goal.targetValue) * 100)
    });
    
    return await this.save();
  }
  throw new Error('目标不存在');
};

// 静态方法：获取营养师的客户列表
nutritionistClientSchema.statics.getNutritionistClients = async function(nutritionistId, options = {}) {
  const {
    status = 'active',
    tags = [],
    sortBy = 'consultationStats.lastConsultationDate',
    sortOrder = -1,
    limit = 20,
    skip = 0,
    search = ''
  } = options;

  const query = { nutritionistId };
  
  if (status) {
    query.relationshipStatus = status;
  }
  
  if (tags.length > 0) {
    query.clientTags = { $in: tags };
  }

  let clients = await this.find(query)
    .populate('clientUser', 'username nickname avatar gender age email')
    .sort({ [sortBy]: sortOrder })
    .skip(skip)
    .limit(limit);

  // 如果有搜索关键词，进行筛选
  if (search) {
    clients = clients.filter(client => 
      client.clientUser.username.includes(search) ||
      client.clientUser.nickname?.includes(search) ||
      client.nutritionistNotes?.includes(search)
    );
  }

  const total = await this.countDocuments(query);

  return {
    clients,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 静态方法：获取客户详情
nutritionistClientSchema.statics.getClientDetail = async function(nutritionistId, clientUserId) {
  const client = await this.findOne({
    nutritionistId,
    clientUserId
  })
  .populate('clientUser', 'username nickname avatar gender age email phone')
  .populate('nutritionPlanHistory.planId');

  return client;
};

// 创建模型
const NutritionistClient = ModelFactory.createModel('NutritionistClient', nutritionistClientSchema);

module.exports = NutritionistClient;