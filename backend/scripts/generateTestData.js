/**
 * 测试数据生成脚本
 * 生成并保存模拟数据到分片数据库中
 */

const { MongoClient } = require('mongodb');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const { ObjectId } = require('mongodb');

// MongoDB连接配置 - 使用环境变量中的连接字符串或Docker网络中的地址
const DB_URI = process.env.MONGO_PRIMARY_URI || 'mongodb://172.19.0.3:27017/smart_nutrition_restaurant';
const DB_NAME = 'smart_nutrition_restaurant';

// 分片配置（与directMigration.js相同）
const shardingConfig = {
  strategies: {
    AuditLog: {
      enabled: true,
      type: 'time',
      timeUnit: 'month'
    },
    HealthData: {
      enabled: true,
      type: 'user',
      shards: 5
    },
    Order: {
      enabled: true,
      type: 'time',
      timeUnit: 'month'
    },
    User: {
      enabled: true,
      type: 'hash',
      shards: 3
    },
    Merchant: {
      enabled: true,
      type: 'geo'
    },
    AiRecommendation: {
      enabled: true,
      type: 'user',
      shards: 5
    },
    ForumPost: {
      enabled: true,
      type: 'time',
      timeUnit: 'quarter'
    },
    DbMetric: {
      enabled: true,
      type: 'time',
      timeUnit: 'year'
    }
  }
};

// 集合名称与策略名称的映射
const COLLECTION_TO_STRATEGY = {
  'auditlogs': 'AuditLog',
  'healthdata': 'HealthData',
  'orders': 'Order',
  'users': 'User',
  'merchants': 'Merchant',
  'airecommendations': 'AiRecommendation',
  'forumposts': 'ForumPost',
  'dbmetrics': 'DbMetric'
};

// 获取分片名称
function getShardName(collectionName, key, strategy) {
  const collBaseName = collectionName.endsWith('s') 
    ? collectionName.slice(0, -1) 
    : collectionName;
  
  const now = new Date();
  
  switch (strategy.type) {
    case 'time':
      const date = key instanceof Date ? key : now;
      const year = date.getFullYear();
      let timePart;
      
      if (strategy.timeUnit === 'month') {
        const month = date.getMonth() + 1;
        timePart = `${year}_${month.toString().padStart(2, '0')}`;
      } else if (strategy.timeUnit === 'quarter') {
        const quarter = Math.floor(date.getMonth() / 3) + 1;
        timePart = `${year}_q${quarter}`;
      } else if (strategy.timeUnit === 'year') {
        timePart = `${year}`;
      } else {
        // 默认按月
        const month = date.getMonth() + 1;
        timePart = `${year}_${month.toString().padStart(2, '0')}`;
      }
      
      return `${collBaseName}_${timePart}`;
      
    case 'hash':
      const hash = typeof key === 'string' ? key : String(key);
      const hashCode = hash.split('').reduce((a, b) => {
        a = ((a << 5) - a) + b.charCodeAt(0);
        return a & a;
      }, 0);
      const shardIndex = Math.abs(hashCode) % (strategy.shards || 3);
      return `${collBaseName}_shard_${shardIndex}`;
      
    case 'geo':
      if (Array.isArray(key) && key.length === 2) {
        const [longitude, latitude] = key;
        // 简化的地理区域划分
        const region = Math.floor((longitude + 180) / 90) * 4 + Math.floor((latitude + 90) / 45);
        return `${collBaseName}_region_${region}`;
      }
      return `${collBaseName}_region_default`;
      
    case 'range':
      const value = typeof key === 'number' ? key : 0;
      let rangeName = 'default';
      
      if (strategy.ranges && Array.isArray(strategy.ranges)) {
        for (let i = 0; i < strategy.ranges.length; i++) {
          const range = strategy.ranges[i];
          if (value >= range.min && value < range.max) {
            rangeName = range.name;
            break;
          }
        }
      }
      
      return `${collBaseName}_${rangeName}`;
      
    case 'user':
      const userId = typeof key === 'string' ? key : String(key);
      const userHash = userId.split('').reduce((a, b) => {
        a = ((a << 5) - a) + b.charCodeAt(0);
        return a & a;
      }, 0);
      const userShardIndex = Math.abs(userHash) % (strategy.shards || 5);
      return `${collBaseName}_user_${userShardIndex}`;
      
    default:
      return collectionName;
  }
}

// 生成随机用户
async function generateUsers(db, count) {
  console.log(`生成 ${count} 个测试用户...`);
  
  const users = [];
  const hashedPassword = await bcrypt.hash('password123', 10);
  
  for (let i = 0; i < count; i++) {
    const userId = new ObjectId();
    const user = {
      _id: userId,
      nickname: `测试用户${i+1}`,
      phone: `1388888${(1000 + i).toString().slice(1)}`,
      password: hashedPassword,
      age: 20 + Math.floor(Math.random() * 40),
      gender: ['male', 'female', 'other'][Math.floor(Math.random() * 3)],
      height: 150 + Math.floor(Math.random() * 50),
      weight: 45 + Math.floor(Math.random() * 50),
      activityLevel: ['sedentary', 'light', 'moderate', 'active', 'very_active'][Math.floor(Math.random() * 5)],
      region: {
        province: '广东省',
        city: '深圳市'
      },
      dietaryPreferences: {
        cuisinePreference: ['chinese', 'western', 'japanese', 'korean', 'other'][Math.floor(Math.random() * 5)],
        allergies: [],
        avoidedIngredients: [],
        spicyPreference: ['mild', 'medium', 'hot'][Math.floor(Math.random() * 3)]
      },
      healthData: {
        hasRecentMedicalReport: false,
        medicalReportUrl: '',
        healthIssues: []
      },
      role: 'user',
      createdAt: new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000),
      updatedAt: new Date()
    };
    
    users.push(user);
    
    // 确定用户的分片
    const shardKey = user._id.toString();
    const strategy = shardingConfig.strategies.User;
    const shardCollectionName = getShardName('users', shardKey, strategy);
    
    // 保存到分片
    await db.collection(shardCollectionName).updateOne(
      { _id: user._id },
      { $set: user },
      { upsert: true }
    );
    
    // 同时保存到原始集合
    await db.collection('users').updateOne(
      { _id: user._id },
      { $set: user },
      { upsert: true }
    );
    
    console.log(`- 用户 ${user.nickname} 保存到 ${shardCollectionName}`);
  }
  
  return users;
}

// 生成健康数据
async function generateHealthData(db, users) {
  console.log(`为 ${users.length} 个用户生成健康数据...`);
  
  for (let user of users) {
    const healthDataCount = 5 + Math.floor(Math.random() * 10); // 每个用户5-15条健康数据
    
    for (let i = 0; i < healthDataCount; i++) {
      const date = new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000);
      
      const healthData = {
        _id: new ObjectId(),
        user_id: user._id,
        date: date,
        weight: user.weight + (Math.random() * 4 - 2), // 随机波动
        bloodPressure: {
          systolic: 110 + Math.floor(Math.random() * 40),
          diastolic: 70 + Math.floor(Math.random() * 20)
        },
        bloodSugar: 4.5 + Math.random() * 3,
        sleepHours: 5 + Math.random() * 4,
        steps: Math.floor(Math.random() * 15000),
        notes: '',
        createdAt: date,
        updatedAt: date
      };
      
      // 确定健康数据的分片
      const shardKey = user._id.toString();
      const strategy = shardingConfig.strategies.HealthData;
      const shardCollectionName = getShardName('healthdata', shardKey, strategy);
      
      // 保存到分片
      await db.collection(shardCollectionName).updateOne(
        { _id: healthData._id },
        { $set: healthData },
        { upsert: true }
      );
      
      // 同时保存到原始集合
      await db.collection('healthdata').updateOne(
        { _id: healthData._id },
        { $set: healthData },
        { upsert: true }
      );
    }
    
    console.log(`- 用户 ${user.nickname} 的健康数据已生成`);
  }
}

// 生成商家数据
async function generateMerchants(db, count) {
  console.log(`生成 ${count} 个测试商家...`);
  
  const merchants = [];
  const cuisineTypes = ['chinese', 'western', 'japanese', 'korean', 'italian', 'thai', 'vietnamese', 'indian'];
  const cities = [
    { name: '深圳', coords: [114.0579, 22.5431] },
    { name: '广州', coords: [113.2644, 23.1291] },
    { name: '北京', coords: [116.4074, 39.9042] },
    { name: '上海', coords: [121.4737, 31.2304] },
    { name: '成都', coords: [104.0668, 30.5728] }
  ];
  
  for (let i = 0; i < count; i++) {
    const city = cities[Math.floor(Math.random() * cities.length)];
    // 在城市坐标附近添加随机偏移
    const longitude = city.coords[0] + (Math.random() * 0.2 - 0.1);
    const latitude = city.coords[1] + (Math.random() * 0.2 - 0.1);
    
    const merchant = {
      _id: new ObjectId(),
      name: `测试餐厅${i+1}`,
      description: `这是一家提供健康美食的餐厅，位于${city.name}`,
      cuisine: cuisineTypes[Math.floor(Math.random() * cuisineTypes.length)],
      address: `${city.name}市中心区域${Math.floor(Math.random() * 100) + 1}号`,
      location: {
        type: 'Point',
        coordinates: [longitude, latitude]
      },
      contactPhone: `0755-${Math.floor(Math.random() * 10000000) + 10000000}`,
      businessHours: {
        opening: '09:00',
        closing: '22:00'
      },
      priceLevel: Math.floor(Math.random() * 3) + 1, // 1-3
      rating: Math.floor(Math.random() * 40 + 10) / 10, // 1.0-5.0
      reviewCount: Math.floor(Math.random() * 500),
      isVerified: true,
      createdAt: new Date(Date.now() - Math.floor(Math.random() * 365) * 24 * 60 * 60 * 1000),
      updatedAt: new Date()
    };
    
    merchants.push(merchant);
    
    // 确定商家的分片
    const shardKey = merchant.location.coordinates;
    const strategy = shardingConfig.strategies.Merchant;
    const shardCollectionName = getShardName('merchants', shardKey, strategy);
    
    // 保存到分片
    await db.collection(shardCollectionName).updateOne(
      { _id: merchant._id },
      { $set: merchant },
      { upsert: true }
    );
    
    // 同时保存到原始集合
    await db.collection('merchants').updateOne(
      { _id: merchant._id },
      { $set: merchant },
      { upsert: true }
    );
    
    console.log(`- 商家 ${merchant.name} 保存到 ${shardCollectionName}`);
  }
  
  return merchants;
}

// 生成订单数据
async function generateOrders(db, users, merchants, count) {
  console.log(`生成 ${count} 个测试订单...`);
  
  for (let i = 0; i < count; i++) {
    const user = users[Math.floor(Math.random() * users.length)];
    const merchant = merchants[Math.floor(Math.random() * merchants.length)];
    
    // 随机订单日期（过去30天内）
    const orderDate = new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000);
    
    // 随机生成1-5件商品
    const itemCount = Math.floor(Math.random() * 5) + 1;
    const items = [];
    let totalAmount = 0;
    
    for (let j = 0; j < itemCount; j++) {
      const price = Math.floor(Math.random() * 100) + 10;
      const quantity = Math.floor(Math.random() * 3) + 1;
      const itemTotal = price * quantity;
      totalAmount += itemTotal;
      
      items.push({
        name: `测试食品${j+1}`,
        description: '健康美味的食品',
        price: price,
        quantity: quantity,
        totalPrice: itemTotal,
        nutritionInfo: {
          calories: Math.floor(Math.random() * 500) + 100,
          protein: Math.floor(Math.random() * 30) + 5,
          carbs: Math.floor(Math.random() * 50) + 10,
          fat: Math.floor(Math.random() * 20) + 2
        }
      });
    }
    
    const order = {
      _id: new ObjectId(),
      user_id: user._id,
      merchant_id: merchant._id,
      orderNumber: `ORD${Date.now().toString().slice(-8)}${Math.floor(Math.random() * 1000)}`,
      items: items,
      totalAmount: totalAmount,
      status: ['pending', 'processing', 'completed', 'cancelled'][Math.floor(Math.random() * 4)],
      createdAt: orderDate,
      updatedAt: orderDate,
      deliveryAddress: `${merchant.address}附近地址`,
      paymentMethod: ['wechat', 'alipay', 'creditcard'][Math.floor(Math.random() * 3)],
      deliveryTime: new Date(orderDate.getTime() + Math.floor(Math.random() * 120) * 60 * 1000)
    };
    
    // 确定订单的分片
    const shardKey = order.createdAt;
    const strategy = shardingConfig.strategies.Order;
    const shardCollectionName = getShardName('orders', shardKey, strategy);
    
    // 保存到分片
    await db.collection(shardCollectionName).updateOne(
      { _id: order._id },
      { $set: order },
      { upsert: true }
    );
    
    // 同时保存到原始集合
    await db.collection('orders').updateOne(
      { _id: order._id },
      { $set: order },
      { upsert: true }
    );
    
    if (i % 10 === 0) {
      console.log(`- 已生成 ${i+1}/${count} 个订单`);
    }
  }
  
  console.log(`- 所有 ${count} 个订单已生成完成`);
}

// 生成审计日志
async function generateAuditLogs(db, users, count) {
  console.log(`生成 ${count} 个审计日志...`);
  
  const actionTypes = ['login', 'logout', 'user_create', 'user_update', 'order_create', 'order_update', 'view_profile'];
  const status = ['success', 'failure'];
  
  for (let i = 0; i < count; i++) {
    const user = users[Math.floor(Math.random() * users.length)];
    const logDate = new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000);
    
    const log = {
      _id: new ObjectId(),
      user_id: user._id,
      action: actionTypes[Math.floor(Math.random() * actionTypes.length)],
      status: status[Math.floor(Math.random() * status.length)],
      timestamp: logDate,
      ip_address: `192.168.${Math.floor(Math.random() * 256)}.${Math.floor(Math.random() * 256)}`,
      user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      details: {
        notes: '测试审计日志'
      }
    };
    
    // 确定日志的分片
    const shardKey = log.timestamp;
    const strategy = shardingConfig.strategies.AuditLog;
    const shardCollectionName = getShardName('auditlogs', shardKey, strategy);
    
    // 保存到分片
    await db.collection(shardCollectionName).updateOne(
      { _id: log._id },
      { $set: log },
      { upsert: true }
    );
    
    // 同时保存到原始集合
    await db.collection('auditlogs').updateOne(
      { _id: log._id },
      { $set: log },
      { upsert: true }
    );
    
    if (i % 100 === 0) {
      console.log(`- 已生成 ${i+1}/${count} 个审计日志`);
    }
  }
  
  console.log(`- 所有 ${count} 个审计日志已生成完成`);
}

// 主程序
async function generateTestData() {
  let client;
  
  try {
    console.log('开始生成测试数据...');
    
    // 连接到MongoDB
    client = new MongoClient(DB_URI);
    await client.connect();
    console.log('MongoDB连接成功');
    
    const db = client.db(DB_NAME);
    
    // 生成测试数据
    const users = await generateUsers(db, 20);
    await generateHealthData(db, users);
    const merchants = await generateMerchants(db, 10);
    await generateOrders(db, users, merchants, 100);
    await generateAuditLogs(db, users, 500);
    
    console.log('所有测试数据生成完成');
    
  } catch (error) {
    console.error('生成测试数据时出错:', error);
  } finally {
    // 关闭数据库连接
    if (client) {
      await client.close();
      console.log('已关闭数据库连接');
    }
  }
}

// 执行生成测试数据
generateTestData()
  .then(() => {
    console.log('测试数据生成脚本执行完成');
    process.exit(0);
  })
  .catch(err => {
    console.error('测试数据生成脚本执行失败:', err);
    process.exit(1);
  }); 