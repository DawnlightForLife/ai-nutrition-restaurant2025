const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

// Mock nutritionist JWT token
const mockNutritionistToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NTBhMWIyM2U0YjBkMzY1NGM4YTIzNDUiLCJudXRyaXRpb25pc3RJZCI6IjY1MGExYjIzZTRiMGQzNjU0YzhhMjM0NiIsInJvbGUiOiJudXRyaXRpb25pc3QiLCJpYXQiOjE3MDAwMDAwMDB9.mock_token';

const axiosConfig = {
  headers: {
    'Authorization': `Bearer ${mockNutritionistToken}`,
    'Content-Type': 'application/json'
  }
};

async function testWorkbenchAPIs() {
  console.log('🧪 开始测试营养师工作台API...\n');

  const tests = [
    {
      name: '获取工作台统计数据',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/dashboard/stats`,
      expectedFields: ['overall', 'today', 'recentTrends', 'upcomingConsultations']
    },
    {
      name: '获取待办任务',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/dashboard/tasks`,
      expectedFields: null, // Expect array
      isArray: true
    },
    {
      name: '获取咨询列表（全部）',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/consultations`,
      expectedFields: null, // Expect array
      isArray: true
    },
    {
      name: '获取咨询列表（待处理）',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/consultations?status=pending`,
      expectedFields: null, // Expect array
      isArray: true
    },
    {
      name: '获取排班表',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/schedule`,
      expectedFields: ['workingHours', 'vacations', 'appointments']
    },
    {
      name: '获取收入明细',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/income/details`,
      expectedFields: ['items', 'totalAmount', 'totalCount']
    },
    {
      name: '获取快捷操作',
      method: 'GET',
      url: `${API_BASE_URL}/nutritionist/workbench/quick-actions`,
      expectedFields: null, // Expect array
      isArray: true
    }
  ];

  let passed = 0;
  let failed = 0;

  for (const test of tests) {
    try {
      console.log(`\n📋 测试: ${test.name}`);
      console.log(`   URL: ${test.method} ${test.url}`);
      
      const response = await axios({
        method: test.method,
        url: test.url,
        ...axiosConfig
      });

      // Check response structure
      if (response.data && response.data.success) {
        const data = response.data.data;
        
        if (test.isArray) {
          if (Array.isArray(data)) {
            console.log(`   ✅ 成功：返回数组，包含 ${data.length} 个项目`);
            passed++;
          } else {
            console.log(`   ❌ 失败：期望返回数组，实际返回 ${typeof data}`);
            failed++;
          }
        } else if (test.expectedFields) {
          const missingFields = test.expectedFields.filter(field => !(field in data));
          if (missingFields.length === 0) {
            console.log(`   ✅ 成功：包含所有必需字段`);
            console.log(`   📊 数据预览:`, JSON.stringify(data, null, 2).substring(0, 200) + '...');
            passed++;
          } else {
            console.log(`   ❌ 失败：缺少字段 ${missingFields.join(', ')}`);
            failed++;
          }
        } else {
          console.log(`   ✅ 成功：请求完成`);
          passed++;
        }
      } else {
        console.log(`   ❌ 失败：响应格式错误`);
        failed++;
      }
    } catch (error) {
      console.log(`   ❌ 失败：${error.response?.data?.message || error.message}`);
      if (error.response?.status === 401) {
        console.log(`   ⚠️  需要有效的营养师身份认证`);
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

  // Test specific operations with mock data
  if (failed === tests.length) {
    console.log('\n⚠️  所有测试都失败了，可能是因为：');
    console.log('1. 需要先创建营养师账号并获取真实的JWT token');
    console.log('2. 数据库中没有相关数据');
    console.log('3. 认证中间件配置问题');
    console.log('\n建议：');
    console.log('1. 先通过注册API创建营养师账号');
    console.log('2. 使用登录API获取JWT token');
    console.log('3. 替换脚本中的mockNutritionistToken');
  }
}

// Run tests
testWorkbenchAPIs().catch(console.error);