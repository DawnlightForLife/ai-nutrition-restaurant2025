/**
 * 商家管理功能测试脚本
 * 遵循项目架构，测试店长权限的商家管理功能
 */

const axios = require('axios');
const mongoose = require('mongoose');

const BASE_URL = 'http://localhost:8080/api';

// 测试用店长账户
const TEST_STORE_MANAGER = {
  phone: '13900001000',
  password: 'store123',
  role: 'store_manager',
  nickname: '测试店长'
};

let authToken = '';
let storeManagerUser = null;

async function initTestStoreManager() {
  try {
    console.log('1. 初始化测试店长账户...');
    
    // 连接数据库
    await mongoose.connect('mongodb://localhost:27017/ai-nutrition-restaurant');
    
    const User = require('./models/user/userModel');
    const bcrypt = require('bcryptjs');
    
    // 删除已存在的测试账户
    await User.deleteOne({ phone: TEST_STORE_MANAGER.phone });
    
    // 创建新的店长账户
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(TEST_STORE_MANAGER.password, salt);
    
    const storeManager = new User({
      phone: TEST_STORE_MANAGER.phone,
      password: hashedPassword,
      role: TEST_STORE_MANAGER.role,
      nickname: TEST_STORE_MANAGER.nickname,
      // 店长基本信息
      height: 175,
      weight: 70,
      age: 35,
      gender: 'male'
    });
    
    storeManagerUser = await storeManager.save();
    console.log('✓ 测试店长账户创建成功:', storeManagerUser.phone);
    
    await mongoose.disconnect();
    return true;
  } catch (error) {
    console.error('✗ 初始化店长账户失败:', error.message);
    return false;
  }
}

async function loginStoreManager() {
  try {
    console.log('\n2. 店长登录...');
    
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      phone: TEST_STORE_MANAGER.phone,
      password: TEST_STORE_MANAGER.password
    });
    
    if (response.data.success) {
      authToken = response.data.data.token;
      const user = response.data.data.user;
      console.log('✓ 店长登录成功');
      console.log('  用户ID:', user._id);
      console.log('  角色:', user.role);
      console.log('  昵称:', user.nickname);
      return true;
    }
  } catch (error) {
    console.error('✗ 店长登录失败:', error.response?.data?.message || error.message);
  }
  return false;
}

async function testDishManagement() {
  try {
    console.log('\n3. 测试菜品管理功能...');
    
    // 测试菜品数据
    const testDish = {
      name: '经典牛肉面',
      description: '精选优质牛肉，手工拉面，营养丰富',
      price: 38.0,
      category: 'main',
      tags: ['招牌', '热销'],
      allergens: ['麸质'],
      dietaryRestrictions: [],
      spicyLevel: 1,
      estimatedPrepTime: 15,
      isAvailable: true,
      nutritionFacts: {
        calories: 580,
        protein: 35,
        carbohydrates: 65,
        fat: 18,
        fiber: 4,
        sodium: 1200
      },
      ingredients: [
        {
          ingredientId: '60f1234567890abcdef12345',
          name: '牛肉',
          quantity: 200,
          unit: 'g',
          isOptional: false
        },
        {
          ingredientId: '60f1234567890abcdef12346', 
          name: '面条',
          quantity: 150,
          unit: 'g',
          isOptional: false
        }
      ],
      isFeatured: true
    };
    
    // 创建菜品
    console.log('3.1 创建菜品...');
    const createRes = await axios.post(`${BASE_URL}/merchant/dishes-enhanced`, testDish, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    if (createRes.data.success) {
      const dish = createRes.data.data;
      console.log('✓ 菜品创建成功:', dish.name);
      console.log('  菜品ID:', dish._id);
      
      // 获取菜品列表
      console.log('3.2 获取菜品列表...');
      const listRes = await axios.get(`${BASE_URL}/merchant/dishes-enhanced`, {
        headers: { Authorization: `Bearer ${authToken}` }
      });
      
      if (listRes.data.success) {
        console.log(`✓ 获取菜品列表成功，共 ${listRes.data.data.length} 个菜品`);
      }
      
      // 更新菜品
      console.log('3.3 更新菜品...');
      const updateRes = await axios.put(`${BASE_URL}/merchant/dishes-enhanced/${dish._id}`, {
        price: 42.0,
        description: '精选优质牛肉，手工拉面，营养丰富，深受顾客喜爱'
      }, {
        headers: { Authorization: `Bearer ${authToken}` }
      });
      
      if (updateRes.data.success) {
        console.log('✓ 菜品更新成功，新价格:', updateRes.data.data.price);
      }
      
      return dish._id;
    }
  } catch (error) {
    console.error('✗ 菜品管理测试失败:', error.response?.data?.message || error.message);
  }
  return null;
}

async function testInventoryManagement() {
  try {
    console.log('\n4. 测试库存管理功能...');
    
    // 测试库存数据
    const testInventory = {
      name: '牛肉',
      unit: 'kg',
      category: 'meat',
      minThreshold: 10,
      alertSettings: {
        lowStockAlert: true,
        expiryAlert: true,
        expiryWarningDays: 3
      }
    };
    
    // 创建库存
    console.log('4.1 创建库存...');
    const createRes = await axios.post(`${BASE_URL}/merchant/inventory`, testInventory, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    if (createRes.data.success) {
      const inventory = createRes.data.data;
      console.log('✓ 库存创建成功:', inventory.name);
      
      // 添加库存
      console.log('4.2 添加库存...');
      const addStockRes = await axios.post(`${BASE_URL}/merchant/inventory/${inventory._id}/stock`, {
        quantity: 50,
        unitCost: 45.0,
        expiryDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30天后过期
        supplier: '优质肉类供应商',
        batchNumber: 'BEEF001'
      }, {
        headers: { Authorization: `Bearer ${authToken}` }
      });
      
      if (addStockRes.data.success) {
        console.log('✓ 库存添加成功，当前库存:', addStockRes.data.data.totalStock);
      }
      
      // 消耗库存
      console.log('4.3 消耗库存...');
      const consumeRes = await axios.post(`${BASE_URL}/merchant/inventory/${inventory._id}/consume`, {
        quantity: 5,
        reason: '制作牛肉面'
      }, {
        headers: { Authorization: `Bearer ${authToken}` }
      });
      
      if (consumeRes.data.success) {
        console.log('✓ 库存消耗成功，剩余库存:', consumeRes.data.data.availableStock);
      }
      
      return inventory._id;
    }
  } catch (error) {
    console.error('✗ 库存管理测试失败:', error.response?.data?.message || error.message);
  }
  return null;
}

async function testOrderProcessing() {
  try {
    console.log('\n5. 测试订单处理功能...');
    
    // 获取订单列表（应该为空或有现有订单）
    console.log('5.1 获取订单列表...');
    const listRes = await axios.get(`${BASE_URL}/merchant/orders`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    if (listRes.data.success) {
      console.log(`✓ 获取订单列表成功，共 ${listRes.data.data.length} 个订单`);
    }
    
    // 获取制作队列
    console.log('5.2 获取制作队列...');
    const queueRes = await axios.get(`${BASE_URL}/merchant/orders/production/queue`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    if (queueRes.data.success) {
      console.log('✓ 获取制作队列成功');
    }
    
  } catch (error) {
    console.error('✗ 订单处理测试失败:', error.response?.data?.message || error.message);
  }
}

async function runMerchantTests() {
  console.log('🏪 开始测试商家管理功能...\n');
  
  // 初始化测试店长账户
  const initSuccess = await initTestStoreManager();
  if (!initSuccess) {
    console.error('无法初始化测试账户，测试终止');
    return;
  }
  
  // 店长登录
  const loginSuccess = await loginStoreManager();
  if (!loginSuccess) {
    console.error('无法登录，测试终止');
    return;
  }
  
  // 测试各功能模块
  const dishId = await testDishManagement();
  const inventoryId = await testInventoryManagement();
  await testOrderProcessing();
  
  console.log('\n✅ 商家管理功能测试完成！');
  
  if (dishId) {
    console.log(`📝 创建的测试菜品ID: ${dishId}`);
  }
  if (inventoryId) {
    console.log(`📦 创建的测试库存ID: ${inventoryId}`);
  }
}

// 运行测试
runMerchantTests().catch(console.error);