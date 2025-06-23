const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

async function testWorkbenchWithAuth() {
  console.log('🧪 营养师工作台API测试（带认证）\n');

  try {
    // Step 1: 创建测试用户账号
    console.log('📝 Step 1: 创建测试用户账号...');
    const registerData = {
      username: `nutritionist_${Date.now()}`,
      password: 'Test123456',
      email: `nutritionist_${Date.now()}@test.com`,
      phone: '13800138000',
      role: 'nutritionist'
    };

    let userId;
    try {
      const registerResponse = await axios.post(`${API_BASE_URL}/auth/register`, registerData);
      userId = registerResponse.data.data.user.id || registerResponse.data.data.user._id;
      console.log('✅ 用户注册成功，ID:', userId);
    } catch (error) {
      console.log('⚠️  注册失败，尝试登录已有账号...');
      // 如果注册失败，尝试使用已有账号
      registerData.username = 'test_nutritionist';
      registerData.email = 'test_nutritionist@test.com';
    }

    // Step 2: 登录获取token
    console.log('\n📝 Step 2: 登录获取JWT token...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
      phone: registerData.phone,
      password: registerData.password
    });

    const token = loginResponse.data.data.token;
    const user = loginResponse.data.data.user;
    console.log('✅ 登录成功，获得token');
    console.log('   用户ID:', user.id || user._id);
    console.log('   角色:', user.role);

    // Step 3: 检查是否有nutritionistId
    if (!user.nutritionistId) {
      console.log('\n⚠️  用户没有营养师ID，需要创建营养师档案...');
      
      // 创建营养师档案
      try {
        const nutritionistData = {
          userId: user.id || user._id,
          name: '测试营养师',
          idNumber: '110101199001011234',
          phone: registerData.phone,
          email: registerData.email,
          certificateNumber: 'CERT123456',
          certificateLevel: '中级',
          certificateValidUntil: '2025-12-31',
          specialties: ['体重管理', '运动营养'],
          yearsOfExperience: 5,
          education: '营养学硕士',
          consultationPrice: 200,
          consultationDuration: 60,
          supportOnline: true,
          supportOffline: false,
          isOnline: true
        };

        const nutritionistResponse = await axios.post(
          `${API_BASE_URL}/nutritionists`,
          nutritionistData,
          {
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json'
            }
          }
        );

        console.log('✅ 营养师档案创建成功');
        
        // 重新登录获取更新后的用户信息
        const newLoginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
          phone: registerData.phone,
          password: registerData.password
        });
        
        token = newLoginResponse.data.data.token;
      } catch (error) {
        console.log('❌ 创建营养师档案失败:', error.response?.data?.message || error.message);
      }
    }

    // Step 4: 测试工作台API
    console.log('\n📝 Step 3: 测试工作台API...');
    
    const axiosConfig = {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    };

    const tests = [
      {
        name: '获取工作台统计数据',
        method: 'GET',
        url: `${API_BASE_URL}/nutritionist/workbench/dashboard/stats`
      },
      {
        name: '获取待办任务',
        method: 'GET',
        url: `${API_BASE_URL}/nutritionist/workbench/dashboard/tasks`
      },
      {
        name: '获取咨询列表',
        method: 'GET',
        url: `${API_BASE_URL}/nutritionist/workbench/consultations`
      },
      {
        name: '获取排班表',
        method: 'GET',
        url: `${API_BASE_URL}/nutritionist/workbench/schedule`
      },
      {
        name: '获取快捷操作',
        method: 'GET',
        url: `${API_BASE_URL}/nutritionist/workbench/quick-actions`
      }
    ];

    let passed = 0;
    let failed = 0;

    for (const test of tests) {
      try {
        console.log(`\n📋 测试: ${test.name}`);
        const response = await axios({
          method: test.method,
          url: test.url,
          ...axiosConfig
        });

        if (response.data && response.data.success) {
          console.log('   ✅ 成功');
          console.log('   📊 数据:', JSON.stringify(response.data.data, null, 2).substring(0, 200) + '...');
          passed++;
        } else {
          console.log('   ❌ 失败：响应格式错误');
          failed++;
        }
      } catch (error) {
        console.log('   ❌ 失败:', error.response?.data?.message || error.message);
        if (error.response?.data) {
          console.log('   详情:', JSON.stringify(error.response.data, null, 2));
        }
        failed++;
      }
    }

    console.log('\n' + '='.repeat(50));
    console.log(`📊 测试结果汇总:`);
    console.log(`   ✅ 通过: ${passed}`);
    console.log(`   ❌ 失败: ${failed}`);
    console.log(`   📈 通过率: ${((passed / tests.length) * 100).toFixed(1)}%`);
    console.log('='.repeat(50));

  } catch (error) {
    console.error('\n❌ 测试过程出错:', error.message);
    if (error.response?.data) {
      console.error('错误详情:', error.response.data);
    }
  }
}

// 运行测试
testWorkbenchWithAuth().catch(console.error);