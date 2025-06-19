/**
 * 测试增强的菜品管理API
 */

const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';

// 测试用户令牌（需要先登录获取）
let authToken = '';
let merchantId = '';

// 测试数据
const testDish = {
  name: '招牌糖醋里脊',
  description: '选用优质猪里脊肉，外酥内嫩，酸甜可口',
  price: 68.0,
  category: 'main',
  tags: ['招牌', '特色', '热销'],
  allergens: ['花生'],
  dietaryRestrictions: [],
  spicyLevel: 0,
  estimatedPrepTime: 25,
  isAvailable: true,
  nutritionFacts: {
    calories: 420,
    protein: 28,
    carbohydrates: 45,
    fat: 15,
    fiber: 2,
    sodium: 680
  },
  ingredients: [
    {
      ingredientId: '60f1234567890abcdef12345',
      name: '猪里脊肉',
      quantity: 300,
      unit: 'g',
      isOptional: false
    },
    {
      ingredientId: '60f1234567890abcdef12346',
      name: '番茄酱',
      quantity: 50,
      unit: 'ml',
      isOptional: false
    }
  ],
  isFeatured: true
};

async function loginAsTestMerchant() {
  try {
    console.log('1. 登录测试商家账户...');
    
    // 尝试使用测试商家账户登录
    const loginRes = await axios.post(`${BASE_URL}/user/auth/login`, {
      email: 'test_merchant@example.com',
      password: 'Test@1234'
    });

    if (loginRes.data.success) {
      authToken = loginRes.data.data.token;
      const user = loginRes.data.data.user;
      console.log('✓ 登录成功，用户角色:', user.role);
      
      // 如果是商家，获取merchantId
      if (user.role === 'merchant') {
        // 获取商家信息
        const merchantRes = await axios.get(`${BASE_URL}/merchant/profile`, {
          headers: { Authorization: `Bearer ${authToken}` }
        });
        
        if (merchantRes.data.success && merchantRes.data.data) {
          merchantId = merchantRes.data.data._id;
          console.log('✓ 获取商家ID:', merchantId);
        }
      }
      
      return true;
    }
  } catch (error) {
    console.error('✗ 登录失败:', error.response?.data?.message || error.message);
    
    // 如果商家不存在，尝试创建
    if (error.response?.status === 404 || error.response?.status === 401) {
      console.log('尝试创建测试商家账户...');
      return await createTestMerchant();
    }
  }
  return false;
}

async function createTestMerchant() {
  try {
    // 注册新商家
    const registerRes = await axios.post(`${BASE_URL}/user/auth/register`, {
      email: 'test_merchant@example.com',
      password: 'Test@1234',
      phone: '13900001111',
      role: 'merchant',
      merchantInfo: {
        businessName: '测试餐厅',
        businessType: 'restaurant',
        cuisineType: ['chinese'],
        businessLicense: 'TEST123456789',
        contactPerson: '张经理',
        contactPhone: '13900001111',
        address: '北京市朝阳区测试街道1号'
      }
    });

    if (registerRes.data.success) {
      console.log('✓ 商家注册成功');
      
      // 重新登录
      return await loginAsTestMerchant();
    }
  } catch (error) {
    console.error('✗ 创建商家失败:', error.response?.data?.message || error.message);
  }
  return false;
}

async function testCreateDish() {
  try {
    console.log('\n2. 测试创建菜品...');
    
    // 添加merchantId到菜品数据
    const dishData = { ...testDish, merchantId };
    
    const res = await axios.post(`${BASE_URL}/merchant/dishes-enhanced`, dishData, {
      headers: { Authorization: `Bearer ${authToken}` }
    });

    if (res.data.success) {
      console.log('✓ 菜品创建成功:', res.data.data.name);
      return res.data.data._id;
    }
  } catch (error) {
    console.error('✗ 创建菜品失败:', error.response?.data || error.message);
    
    // 如果是验证错误，显示详细信息
    if (error.response?.data?.errors) {
      console.error('验证错误:', error.response.data.errors);
    }
  }
  return null;
}

async function testGetDishes() {
  try {
    console.log('\n3. 测试获取菜品列表...');
    
    const res = await axios.get(`${BASE_URL}/merchant/dishes-enhanced`, {
      headers: { Authorization: `Bearer ${authToken}` },
      params: { merchantId }
    });

    if (res.data.success) {
      console.log(`✓ 获取菜品列表成功，共 ${res.data.data.length} 个菜品`);
      if (res.data.data.length > 0) {
        console.log('第一个菜品:', res.data.data[0].name);
      }
      return res.data.data;
    }
  } catch (error) {
    console.error('✗ 获取菜品列表失败:', error.response?.data?.message || error.message);
  }
  return [];
}

async function testUpdateDish(dishId) {
  try {
    console.log('\n4. 测试更新菜品...');
    
    const updateData = {
      price: 78.0,
      description: '选用优质猪里脊肉，外酥内嫩，酸甜可口，深受顾客喜爱',
      tags: ['招牌', '特色', '热销', '新品推荐']
    };

    const res = await axios.put(`${BASE_URL}/merchant/dishes-enhanced/${dishId}`, updateData, {
      headers: { Authorization: `Bearer ${authToken}` }
    });

    if (res.data.success) {
      console.log('✓ 菜品更新成功，新价格:', res.data.data.price);
    }
  } catch (error) {
    console.error('✗ 更新菜品失败:', error.response?.data?.message || error.message);
  }
}

async function testDishAnalytics() {
  try {
    console.log('\n5. 测试菜品分析报告...');
    
    const res = await axios.get(`${BASE_URL}/merchant/dishes-enhanced/analytics/report`, {
      headers: { Authorization: `Bearer ${authToken}` },
      params: { merchantId }
    });

    if (res.data.success) {
      const report = res.data.data;
      console.log('✓ 获取分析报告成功:');
      console.log(`  - 菜品总数: ${report.totalDishes}`);
      console.log(`  - 可用菜品: ${report.availableDishes}`);
      console.log(`  - 平均价格: ￥${report.averagePrice?.toFixed(2) || 0}`);
      console.log(`  - 分类分布:`, report.categoryDistribution);
    }
  } catch (error) {
    console.error('✗ 获取分析报告失败:', error.response?.data?.message || error.message);
  }
}

async function runTests() {
  console.log('开始测试增强的菜品管理API...\n');
  
  // 登录或创建测试商家
  const loginSuccess = await loginAsTestMerchant();
  if (!loginSuccess) {
    console.error('无法登录，测试终止');
    return;
  }

  // 创建菜品
  const dishId = await testCreateDish();
  
  // 获取菜品列表
  await testGetDishes();
  
  // 如果创建成功，测试更新
  if (dishId) {
    await testUpdateDish(dishId);
  }
  
  // 获取分析报告
  await testDishAnalytics();
  
  console.log('\n测试完成！');
}

// 运行测试
runTests().catch(console.error);