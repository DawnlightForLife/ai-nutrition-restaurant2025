/**
 * 数据库初始化脚本
 * 根据模型定义创建所有必要的集合和索引
 */

const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// 导入所有模型
const {
  User,
  UserRole,
  Admin,
  NutritionProfile,
  HealthData,
  Nutritionist,
  Merchant,
  Dish,
  Order,
  AiRecommendation,
  Subscription,
  AuditLog,
  DataAccessControl,
  ForumPost,
  ForumComment,
  Consultation,
  MerchantStats,
  Store,
  StoreDish,
  UserFavorite,
  DbMetrics
} = require('../../models');

// 数据库连接URI
const DB_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant';

/**
 * 初始化数据库
 */
const initializeDatabase = async () => {
  try {
    // 连接到数据库
    console.log(`正在连接到数据库: ${DB_URI}`);
    await mongoose.connect(DB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('数据库连接成功');

    // 创建所有索引
    console.log('创建数据库索引...');
    await createIndexes();
    
    // 创建默认角色
    console.log('创建默认角色...');
    await createDefaultRoles();
    
    // 创建管理员账户
    console.log('创建管理员账户...');
    await createAdminUser();
    
    // 创建测试用户
    console.log('创建测试用户...');
    await createTestUser();

    console.log('数据库初始化完成');
  } catch (error) {
    console.error('数据库初始化失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('数据库连接已关闭');
  }
};

/**
 * 创建所有集合的索引
 */
const createIndexes = async () => {
  // 创建复合索引、唯一索引等
  await User.createIndexes();
  await UserRole.createIndexes();
  await Admin.createIndexes();
  await NutritionProfile.createIndexes();
  await HealthData.createIndexes();
  await Nutritionist.createIndexes();
  await Merchant.createIndexes();
  await Dish.createIndexes();
  await Order.createIndexes();
  await AiRecommendation.createIndexes();
  await Subscription.createIndexes();
  await AuditLog.createIndexes();
  await DataAccessControl.createIndexes();
  await ForumPost.createIndexes();
  await ForumComment.createIndexes();
  await Consultation.createIndexes();
  await MerchantStats.createIndexes();
  await Store.createIndexes();
  await StoreDish.createIndexes();
  await UserFavorite.createIndexes();
  await DbMetrics.createIndexes();
  
  console.log('所有索引创建完成');
};

/**
 * 创建默认角色
 */
const createDefaultRoles = async () => {
  const roles = [
    {
      name: 'admin',
      description: '系统管理员',
      permissions: ['all'],
      level: 100
    },
    {
      name: 'user',
      description: '普通用户',
      permissions: ['read_own', 'write_own'],
      level: 10
    },
    {
      name: 'merchant',
      description: '商家',
      permissions: ['read_own', 'write_own', 'manage_store'],
      level: 20
    },
    {
      name: 'nutritionist',
      description: '营养师',
      permissions: ['read_own', 'write_own', 'read_client', 'write_client'],
      level: 30
    }
  ];
  
  for (const role of roles) {
    await UserRole.findOneAndUpdate(
      { name: role.name },
      role,
      { upsert: true, new: true }
    );
  }
  
  console.log(`已创建 ${roles.length} 个默认角色`);
};

/**
 * 创建管理员用户
 */
const createAdminUser = async () => {
  const adminExists = await User.findOne({ role: 'admin' });
  if (adminExists) {
    console.log('管理员账户已存在');
    return;
  }
  
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash('admin123', salt);
  
  const admin = new User({
    phone: '13800138000',
    password: hashedPassword,
    role: 'admin',
    nickname: '系统管理员',
    email: 'admin@example.com',
    createdAt: new Date(),
    updatedAt: new Date()
  });
  
  await admin.save();
  console.log('管理员账户创建成功');
};

/**
 * 创建测试用户
 */
const createTestUser = async () => {
  const phone = '18582658187';
  const userExists = await User.findOne({ phone });
  
  if (userExists) {
    console.log('测试用户已存在');
    return;
  }
  
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash('1234', salt);
  
  const testUser = new User({
    phone: phone,
    password: hashedPassword,
    role: 'user',
    nickname: '测试用户',
    height: 175,
    weight: 70,
    age: 30,
    gender: 'male',
    activityLevel: 'moderate',
    email: 'test@example.com',
    createdAt: new Date(),
    updatedAt: new Date()
  });
  
  await testUser.save();
  console.log('测试用户创建成功');
  
  // 创建测试用户的营养档案
  const nutritionProfile = new NutritionProfile({
    user_id: testUser._id,
    height: testUser.height,
    weight: testUser.weight,
    age: testUser.age,
    gender: testUser.gender,
    activityLevel: testUser.activityLevel,
    bmr: 1800, // 基础代谢率
    dailyCalorieNeeds: 2200,
    dietaryPreferences: {
      cuisine: ['chinese', 'western'],
      allergies: [],
      restrictions: []
    },
    nutritionGoals: {
      targetWeight: 68,
      weeklyGoal: -0.5, // 每周减0.5kg
      dailyCalories: 2000,
      macroRatio: {
        protein: 30,
        carbs: 40,
        fat: 30
      }
    },
    createdAt: new Date(),
    updatedAt: new Date()
  });
  
  await nutritionProfile.save();
  console.log('测试用户营养档案创建成功');
  
  // 创建一些健康数据记录
  const healthDataPoints = [
    {
      user_id: testUser._id,
      date: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000),
      weight: 72,
      bloodPressure: { systolic: 120, diastolic: 80 },
      bloodSugar: 5.2,
      sleepHours: 7.5,
      steps: 8000
    },
    {
      user_id: testUser._id,
      date: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000),
      weight: 71.5,
      bloodPressure: { systolic: 118, diastolic: 78 },
      bloodSugar: 5.0,
      sleepHours: 8,
      steps: 10000
    },
    {
      user_id: testUser._id,
      date: new Date(),
      weight: 71,
      bloodPressure: { systolic: 115, diastolic: 75 },
      bloodSugar: 4.9,
      sleepHours: 8.5,
      steps: 12000
    }
  ];
  
  for (const dataPoint of healthDataPoints) {
    const healthData = new HealthData({
      ...dataPoint,
      createdAt: dataPoint.date,
      updatedAt: dataPoint.date
    });
    await healthData.save();
  }
  
  console.log('测试用户健康数据创建成功');
};

// 执行初始化
initializeDatabase()
  .then(() => {
    console.log('数据库初始化脚本执行完成');
    process.exit(0);
  })
  .catch(error => {
    console.error('初始化脚本执行失败:', error);
    process.exit(1);
  }); 