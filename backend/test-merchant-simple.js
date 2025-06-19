/**
 * 简化的商家管理功能测试
 * 使用现有的测试用户和admin权限测试
 */

const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';

let authToken = '';

async function testWithAdmin() {
  try {
    console.log('🔐 使用管理员身份测试商家管理功能...\n');
    
    // 使用现有的管理员账户登录（从initAdmin.js可知）
    console.log('1. 管理员登录...');
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      phone: '13800138000',
      password: 'admin123'
    });
    
    if (response.data.success || response.data.token) {
      authToken = response.data.token || response.data.data?.token;
      console.log('✓ 管理员登录成功');
      console.log('  Token前10位:', authToken?.substring(0, 10) + '...');
      
      // 测试菜品管理API
      await testDishAPI();
      
      // 测试库存管理API
      await testInventoryAPI();
      
      // 测试订单处理API
      await testOrderAPI();
      
    } else {
      console.error('✗ 管理员登录失败');
    }
  } catch (error) {
    console.error('✗ 管理员登录失败:', error.response?.data?.message || error.message);
    
    // 如果管理员不存在，尝试使用测试用户
    await testWithRegularUser();
  }
}

async function testWithRegularUser() {
  try {
    console.log('\n🔐 使用测试用户身份测试...\n');
    
    // 使用现有的测试用户账户登录（从initTestUser.js可知）
    console.log('1. 测试用户登录...');
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      phone: '18582658187',
      password: '1234'
    });
    
    if (response.data.success || response.data.token) {
      authToken = response.data.token || response.data.data?.token;
      console.log('✓ 测试用户登录成功');
      
      // 测试API（预期可能因权限被拒绝）
      await testDishAPI();
    } else {
      console.error('✗ 测试用户登录失败');
    }
  } catch (error) {
    console.error('✗ 测试用户登录失败:', error.response?.data?.message || error.message);
    console.log('\n需要先运行用户初始化脚本:');
    console.log('docker exec ai-nutrition-restaurant2025-backend-1 node scripts/user/initAdmin.js');
    console.log('docker exec ai-nutrition-restaurant2025-backend-1 node scripts/data/initTestUser.js');
  }
}

async function testDishAPI() {
  try {
    console.log('\n2. 测试菜品管理API...');
    
    // 测试菜品数据
    const testDish = {
      name: '测试菜品',
      description: '这是一个测试菜品',
      price: 25.0,
      category: 'main',
      tags: ['测试'],
      isAvailable: true,
      nutritionFacts: {
        calories: 300,
        protein: 20,
        carbohydrates: 30,
        fat: 10
      },
      ingredients: []
    };
    
    // 获取菜品列表
    console.log('2.1 获取菜品列表...');
    const listRes = await axios.get(`${BASE_URL}/merchant/dishes-enhanced`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    console.log('✓ 菜品列表请求成功，响应状态:', listRes.status);
    console.log('  响应结构:', Object.keys(listRes.data));
    
    if (listRes.data.data) {
      console.log(`  菜品数量: ${listRes.data.data.length}`);
    }
    
    // 创建菜品
    console.log('2.2 创建菜品...');
    const createRes = await axios.post(`${BASE_URL}/merchant/dishes-enhanced`, testDish, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    console.log('✓ 菜品创建请求成功，响应状态:', createRes.status);
    if (createRes.data.data) {
      console.log('  创建的菜品ID:', createRes.data.data._id);
      console.log('  菜品名称:', createRes.data.data.name);
    }
    
  } catch (error) {
    console.error('✗ 菜品API测试失败:', error.response?.status, error.response?.data?.message || error.message);
    if (error.response?.status === 403) {
      console.log('  → 权限不足，这是预期的（需要store_manager角色）');
    }
  }
}

async function testInventoryAPI() {
  try {
    console.log('\n3. 测试库存管理API...');
    
    const listRes = await axios.get(`${BASE_URL}/merchant/inventory`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    console.log('✓ 库存列表请求成功，响应状态:', listRes.status);
    
  } catch (error) {
    console.error('✗ 库存API测试失败:', error.response?.status, error.response?.data?.message || error.message);
    if (error.response?.status === 403) {
      console.log('  → 权限不足，这是预期的（需要store_manager角色）');
    }
  }
}

async function testOrderAPI() {
  try {
    console.log('\n4. 测试订单处理API...');
    
    const listRes = await axios.get(`${BASE_URL}/merchant/orders`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    console.log('✓ 订单列表请求成功，响应状态:', listRes.status);
    
  } catch (error) {
    console.error('✗ 订单API测试失败:', error.response?.status, error.response?.data?.message || error.message);
    if (error.response?.status === 403) {
      console.log('  → 权限不足，这是预期的（需要store_manager角色）');
    }
  }
}

// 运行测试
testWithAdmin().then(() => {
  console.log('\n✅ API测试完成！');
}).catch(console.error);