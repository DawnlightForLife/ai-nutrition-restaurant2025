const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

async function testWorkbenchAPIs() {
  console.log('🧪 测试营养师工作台API（简化版）\n');

  // 使用一个固定的测试账号
  const testAccount = {
    phone: '13900000001',
    password: 'Test123456'
  };

  try {
    // Step 1: 尝试注册（如果账号已存在会失败，但没关系）
    console.log('📝 Step 1: 尝试注册测试账号...');
    try {
      await axios.post(`${API_BASE_URL}/auth/register`, {
        username: 'test_nutritionist_001',
        phone: testAccount.phone,
        password: testAccount.password,
        email: 'test_nutritionist_001@test.com',
        role: 'nutritionist'
      });
      console.log('✅ 注册成功');
    } catch (error) {
      console.log('⚠️  注册失败（可能账号已存在）:', error.response?.data?.message);
    }

    // Step 2: 登录
    console.log('\n📝 Step 2: 登录获取token...');
    let token;
    try {
      const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
        phone: testAccount.phone,
        password: testAccount.password
      });
      
      token = loginResponse.data.data.token;
      const user = loginResponse.data.data.user;
      console.log('✅ 登录成功');
      console.log('   用户角色:', user.role);
      console.log('   营养师ID:', user.nutritionistId || '未设置');
    } catch (error) {
      console.log('❌ 登录失败:', error.response?.data?.message);
      return;
    }

    // Step 3: 测试API（不检查权限，只测试路由是否存在）
    console.log('\n📝 Step 3: 测试工作台API路由...');
    
    const tests = [
      { name: '统计数据', url: '/nutritionist/workbench/dashboard/stats' },
      { name: '待办任务', url: '/nutritionist/workbench/dashboard/tasks' },
      { name: '咨询列表', url: '/nutritionist/workbench/consultations' },
      { name: '排班表', url: '/nutritionist/workbench/schedule' },
      { name: '快捷操作', url: '/nutritionist/workbench/quick-actions' }
    ];

    for (const test of tests) {
      try {
        console.log(`\n📋 测试: ${test.name}`);
        console.log(`   URL: GET ${API_BASE_URL}${test.url}`);
        
        const response = await axios.get(`${API_BASE_URL}${test.url}`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });

        if (response.status === 200) {
          console.log('   ✅ 路由可访问');
          if (response.data?.data) {
            console.log('   📊 返回数据类型:', Array.isArray(response.data.data) ? 'Array' : typeof response.data.data);
          }
        }
      } catch (error) {
        const status = error.response?.status;
        const message = error.response?.data?.message || error.message;
        
        if (status === 404) {
          console.log('   ❌ 路由不存在 (404)');
        } else if (status === 401) {
          console.log('   ⚠️  需要认证 (401)');
        } else if (status === 403) {
          console.log('   ⚠️  权限不足 (403) - 需要营养师角色');
        } else if (status === 500) {
          console.log('   ❌ 服务器错误 (500):', message);
        } else {
          console.log('   ❌ 请求失败:', message);
        }
      }
    }

    // 额外测试：检查用户是否有营养师权限
    console.log('\n\n📝 额外检查：用户权限状态');
    try {
      const meResponse = await axios.get(`${API_BASE_URL}/users/me`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      
      const userData = meResponse.data.data;
      console.log('   用户ID:', userData._id || userData.id);
      console.log('   用户角色:', userData.role);
      console.log('   营养师ID:', userData.nutritionistId || '❌ 未设置');
      
      if (!userData.nutritionistId && userData.role === 'nutritionist') {
        console.log('\n⚠️  提示：用户角色是营养师，但没有营养师ID');
        console.log('   需要先创建营养师档案才能访问工作台功能');
      }
    } catch (error) {
      console.log('   无法获取用户信息');
    }

  } catch (error) {
    console.error('\n❌ 测试失败:', error.message);
  }
}

// 运行测试
testWorkbenchAPIs().catch(console.error);