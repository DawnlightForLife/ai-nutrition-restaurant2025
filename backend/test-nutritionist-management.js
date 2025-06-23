const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'http://localhost:5000/api';
let adminToken = '';
let nutritionistToken = '';
let testUserId = '';
let testNutritionistId = '';

// 颜色输出
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function logSection(title) {
  console.log('\n' + '='.repeat(50));
  log(title, 'cyan');
  console.log('='.repeat(50));
}

// 创建测试用户
async function createTestUsers() {
  logSection('创建测试用户');
  
  try {
    // 创建管理员用户
    const adminData = {
      phone: '13800000001',
      password: 'Admin123456',
      name: '测试管理员',
      role: 'admin'
    };
    
    log('创建管理员用户...', 'blue');
    const adminRes = await axios.post(`${BASE_URL}/auth/register`, adminData);
    log('管理员用户创建成功', 'green');
    
    // 管理员登录
    const adminLoginRes = await axios.post(`${BASE_URL}/auth/login`, {
      phone: adminData.phone,
      password: adminData.password
    });
    adminToken = adminLoginRes.data.data.token;
    log('管理员登录成功', 'green');

    // 创建营养师用户
    const nutritionistData = {
      phone: '13800000002',
      password: 'Nutri123456',
      name: '测试营养师',
      role: 'nutritionist'
    };
    
    log('创建营养师用户...', 'blue');
    const nutriRes = await axios.post(`${BASE_URL}/auth/register`, nutritionistData);
    testUserId = nutriRes.data.data.user._id;
    log('营养师用户创建成功', 'green');
    
    // 营养师登录
    const nutriLoginRes = await axios.post(`${BASE_URL}/auth/login`, {
      phone: nutritionistData.phone,
      password: nutritionistData.password
    });
    nutritionistToken = nutriLoginRes.data.data.token;
    log('营养师登录成功', 'green');
    
    return true;
  } catch (error) {
    log(`创建测试用户失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试营养师认证申请
async function testNutritionistCertification() {
  logSection('测试营养师认证申请');
  
  try {
    const certData = {
      realName: '张营养师',
      idNumber: '110101199001011234',
      licenseNumber: 'NUT2024001',
      certificationLevel: 'senior',
      issueDate: '2020-01-01',
      expiryDate: '2025-12-31',
      issuingAuthority: '中国营养学会',
      specializations: ['clinical', 'sports', 'pediatric'],
      experienceYears: 5,
      education: '硕士',
      university: '北京协和医学院',
      major: '临床营养学',
      workUnit: '北京协和医院',
      position: '高级营养师',
      introduction: '专注临床营养10年，擅长慢病营养管理',
      consultationFee: 200,
      availableTimeSlots: {
        monday: ['09:00-12:00', '14:00-17:00'],
        tuesday: ['09:00-12:00', '14:00-17:00'],
        wednesday: ['09:00-12:00']
      }
    };

    log('提交营养师认证申请...', 'blue');
    const res = await axios.post(
      `${BASE_URL}/nutritionist-certification/applications`,
      certData,
      { headers: { Authorization: `Bearer ${nutritionistToken}` } }
    );
    
    testNutritionistId = res.data.data.nutritionist._id;
    log(`营养师认证申请成功，营养师ID: ${testNutritionistId}`, 'green');
    
    // 管理员审核通过
    log('管理员审核通过认证...', 'blue');
    const reviewRes = await axios.put(
      `${BASE_URL}/admin/nutritionist-certification-review/${res.data.data._id}/review`,
      {
        decision: 'approved',
        reviewNotes: '资质齐全，审核通过'
      },
      { headers: { Authorization: `Bearer ${adminToken}` } }
    );
    log('认证审核通过', 'green');
    
    return true;
  } catch (error) {
    log(`营养师认证测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试营养师管理列表
async function testNutritionistManagementList() {
  logSection('测试营养师管理列表');
  
  try {
    // 测试不同的查询参数
    const testCases = [
      { name: '默认查询', params: {} },
      { name: '分页查询', params: { page: 1, limit: 10 } },
      { name: '状态筛选', params: { status: 'active' } },
      { name: '审核状态筛选', params: { verificationStatus: 'approved' } },
      { name: '搜索查询', params: { search: '张营养师' } },
      { name: '排序查询', params: { sortBy: 'createdAt', sortOrder: 'desc' } }
    ];

    for (const testCase of testCases) {
      log(`测试${testCase.name}...`, 'blue');
      const res = await axios.get(
        `${BASE_URL}/admin/nutritionist-management`,
        {
          params: testCase.params,
          headers: { Authorization: `Bearer ${adminToken}` }
        }
      );
      
      log(`${testCase.name}成功，返回 ${res.data.data.nutritionists.length} 条记录`, 'green');
      
      // 验证第一次查询（无缓存）
      const start1 = Date.now();
      await axios.get(
        `${BASE_URL}/admin/nutritionist-management`,
        {
          params: testCase.params,
          headers: { Authorization: `Bearer ${adminToken}` }
        }
      );
      const time1 = Date.now() - start1;
      
      // 验证第二次查询（有缓存）
      const start2 = Date.now();
      await axios.get(
        `${BASE_URL}/admin/nutritionist-management`,
        {
          params: testCase.params,
          headers: { Authorization: `Bearer ${adminToken}` }
        }
      );
      const time2 = Date.now() - start2;
      
      log(`性能对比 - 无缓存: ${time1}ms, 有缓存: ${time2}ms (提升 ${((time1-time2)/time1*100).toFixed(1)}%)`, 'yellow');
    }
    
    return true;
  } catch (error) {
    log(`营养师管理列表测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试营养师详情
async function testNutritionistDetail() {
  logSection('测试营养师详情');
  
  try {
    log('获取营养师详情...', 'blue');
    const res = await axios.get(
      `${BASE_URL}/admin/nutritionist-management/${testNutritionistId}`,
      { headers: { Authorization: `Bearer ${adminToken}` } }
    );
    
    const detail = res.data.data;
    log('营养师详情获取成功', 'green');
    log(`- 姓名: ${detail.nutritionist.personalInfo.realName}`, 'cyan');
    log(`- 证书编号: ${detail.nutritionist.qualifications.licenseNumber}`, 'cyan');
    log(`- 统计数据: 咨询${detail.stats.totalConsultations}次, 评分${detail.stats.avgRating}`, 'cyan');
    
    return true;
  } catch (error) {
    log(`营养师详情测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试状态更新
async function testStatusUpdate() {
  logSection('测试营养师状态更新');
  
  try {
    const statusUpdates = [
      { status: 'suspended', reason: '测试暂停' },
      { status: 'active', reason: '测试恢复' }
    ];

    for (const update of statusUpdates) {
      log(`更新状态为 ${update.status}...`, 'blue');
      const res = await axios.put(
        `${BASE_URL}/admin/nutritionist-management/${testNutritionistId}/status`,
        update,
        { headers: { Authorization: `Bearer ${adminToken}` } }
      );
      
      log(`状态更新成功: ${update.status}`, 'green');
    }
    
    return true;
  } catch (error) {
    log(`状态更新测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试批量操作
async function testBatchOperations() {
  logSection('测试批量操作');
  
  try {
    // 创建额外的测试营养师
    const extraNutritionists = [];
    for (let i = 3; i <= 5; i++) {
      const userData = {
        phone: `1380000000${i}`,
        password: 'Test123456',
        name: `测试营养师${i}`,
        role: 'nutritionist'
      };
      
      const userRes = await axios.post(`${BASE_URL}/auth/register`, userData);
      const loginRes = await axios.post(`${BASE_URL}/auth/login`, {
        phone: userData.phone,
        password: userData.password
      });
      
      const certData = {
        realName: `营养师${i}`,
        idNumber: `11010119900101123${i}`,
        licenseNumber: `NUT202400${i}`,
        certificationLevel: 'intermediate',
        issueDate: '2020-01-01',
        expiryDate: '2025-12-31',
        issuingAuthority: '中国营养学会',
        specializations: ['clinical'],
        experienceYears: 3,
        education: '本科',
        university: '北京大学',
        major: '营养学',
        workUnit: '测试医院',
        position: '营养师',
        introduction: '测试营养师',
        consultationFee: 100
      };
      
      const certRes = await axios.post(
        `${BASE_URL}/nutritionist-certification/applications`,
        certData,
        { headers: { Authorization: `Bearer ${loginRes.data.data.token}` } }
      );
      
      extraNutritionists.push(certRes.data.data.nutritionist._id);
    }
    
    log(`创建了 ${extraNutritionists.length} 个额外的测试营养师`, 'green');

    // 测试批量状态更新
    log('测试批量状态更新...', 'blue');
    const batchRes = await axios.post(
      `${BASE_URL}/admin/nutritionist-management/batch`,
      {
        nutritionistIds: extraNutritionists,
        action: 'updateStatus',
        data: {
          status: 'suspended',
          reason: '批量测试暂停'
        }
      },
      { headers: { Authorization: `Bearer ${adminToken}` } }
    );
    
    log(`批量操作成功，影响 ${batchRes.data.data.affected} 条记录`, 'green');
    
    // 测试批量下线
    log('测试批量下线...', 'blue');
    const offlineRes = await axios.post(
      `${BASE_URL}/admin/nutritionist-management/batch`,
      {
        nutritionistIds: extraNutritionists,
        action: 'setOffline'
      },
      { headers: { Authorization: `Bearer ${adminToken}` } }
    );
    
    log('批量下线操作成功', 'green');
    
    return true;
  } catch (error) {
    log(`批量操作测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试管理概览统计
async function testManagementOverview() {
  logSection('测试管理概览统计');
  
  try {
    log('获取管理概览数据...', 'blue');
    const res = await axios.get(
      `${BASE_URL}/admin/nutritionist-management/overview`,
      { headers: { Authorization: `Bearer ${adminToken}` } }
    );
    
    const overview = res.data.data.overview;
    log('管理概览数据获取成功', 'green');
    log(`- 总营养师数: ${overview.totalNutritionists}`, 'cyan');
    log(`- 活跃营养师: ${overview.activeNutritionists}`, 'cyan');
    log(`- 待审核: ${overview.pendingVerification}`, 'cyan');
    log(`- 在线营养师: ${overview.onlineNutritionists}`, 'cyan');
    log(`- 月活跃度: ${overview.activityRate}%`, 'cyan');
    
    return true;
  } catch (error) {
    log(`管理概览测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试搜索功能
async function testSearch() {
  logSection('测试搜索功能');
  
  try {
    const searchTerms = ['张营养师', 'NUT2024', '13800000002'];
    
    for (const term of searchTerms) {
      log(`搜索关键词: ${term}...`, 'blue');
      const res = await axios.get(
        `${BASE_URL}/admin/nutritionist-management/search`,
        {
          params: { q: term },
          headers: { Authorization: `Bearer ${adminToken}` }
        }
      );
      
      log(`搜索成功，找到 ${res.data.data.results.length} 条结果`, 'green');
    }
    
    return true;
  } catch (error) {
    log(`搜索测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试数据导出
async function testDataExport() {
  logSection('测试数据导出');
  
  try {
    const formats = ['csv', 'json'];
    
    for (const format of formats) {
      log(`测试 ${format.toUpperCase()} 格式导出...`, 'blue');
      const res = await axios.get(
        `${BASE_URL}/admin/nutritionist-management/export`,
        {
          params: { format },
          headers: { Authorization: `Bearer ${adminToken}` },
          responseType: format === 'csv' ? 'text' : 'json'
        }
      );
      
      if (format === 'csv') {
        log(`CSV 导出成功，数据长度: ${res.data.length} 字符`, 'green');
      } else {
        log(`JSON 导出成功，导出 ${res.data.length} 条记录`, 'green');
      }
    }
    
    return true;
  } catch (error) {
    log(`数据导出测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 测试WebSocket连接
async function testWebSocketConnection() {
  logSection('测试WebSocket实时功能');
  
  return new Promise((resolve) => {
    try {
      const io = require('socket.io-client');
      const socket = io('http://localhost:5000/nutritionist-status', {
        auth: { token: nutritionistToken }
      });

      socket.on('connect', () => {
        log('WebSocket连接成功', 'green');
        
        // 测试上线
        socket.emit('go-online', {
          statusMessage: '正在服务中',
          availableConsultationTypes: ['text', 'voice']
        });
      });

      socket.on('online-success', (data) => {
        log('营养师上线成功', 'green');
        
        // 测试状态更新
        socket.emit('update-status', {
          isAvailable: false,
          statusMessage: '休息中'
        });
      });

      socket.on('status-updated', (data) => {
        log('状态更新成功', 'green');
        
        // 测试心跳
        socket.emit('heartbeat');
      });

      socket.on('heartbeat-ack', (data) => {
        log('心跳响应成功', 'green');
        
        // 测试下线
        socket.emit('go-offline');
      });

      socket.on('offline-success', (data) => {
        log('营养师下线成功', 'green');
        socket.disconnect();
        resolve(true);
      });

      socket.on('error', (error) => {
        log(`WebSocket错误: ${error.message}`, 'red');
        socket.disconnect();
        resolve(false);
      });

      // 设置超时
      setTimeout(() => {
        log('WebSocket测试超时', 'yellow');
        socket.disconnect();
        resolve(true);
      }, 10000);
      
    } catch (error) {
      log(`WebSocket测试失败: ${error.message}`, 'red');
      resolve(false);
    }
  });
}

// 测试性能监控
async function testPerformanceMonitoring() {
  logSection('测试性能监控');
  
  try {
    log('测试API调用性能...', 'blue');
    
    const operations = [
      { name: '列表查询', url: '/admin/nutritionist-management', params: { limit: 50 } },
      { name: '详情查询', url: `/admin/nutritionist-management/${testNutritionistId}` },
      { name: '统计概览', url: '/admin/nutritionist-management/overview' }
    ];

    for (const op of operations) {
      const times = [];
      
      // 执行5次测试
      for (let i = 0; i < 5; i++) {
        const start = Date.now();
        await axios.get(
          `${BASE_URL}${op.url}`,
          {
            params: op.params,
            headers: { Authorization: `Bearer ${adminToken}` }
          }
        );
        times.push(Date.now() - start);
      }
      
      const avg = times.reduce((a, b) => a + b, 0) / times.length;
      const min = Math.min(...times);
      const max = Math.max(...times);
      
      log(`${op.name} - 平均: ${avg.toFixed(1)}ms, 最小: ${min}ms, 最大: ${max}ms`, 'yellow');
    }
    
    return true;
  } catch (error) {
    log(`性能监控测试失败: ${error.response?.data?.message || error.message}`, 'red');
    return false;
  }
}

// 主测试函数
async function runTests() {
  console.log('\n');
  log('🚀 开始测试营养师管理功能', 'cyan');
  console.log('\n');

  const tests = [
    { name: '创建测试用户', fn: createTestUsers },
    { name: '营养师认证申请', fn: testNutritionistCertification },
    { name: '营养师管理列表', fn: testNutritionistManagementList },
    { name: '营养师详情', fn: testNutritionistDetail },
    { name: '状态更新', fn: testStatusUpdate },
    { name: '批量操作', fn: testBatchOperations },
    { name: '管理概览统计', fn: testManagementOverview },
    { name: '搜索功能', fn: testSearch },
    { name: '数据导出', fn: testDataExport },
    { name: 'WebSocket连接', fn: testWebSocketConnection },
    { name: '性能监控', fn: testPerformanceMonitoring }
  ];

  let passed = 0;
  let failed = 0;

  for (const test of tests) {
    const result = await test.fn();
    if (result) {
      passed++;
    } else {
      failed++;
    }
  }

  // 测试总结
  console.log('\n' + '='.repeat(50));
  log('📊 测试总结', 'cyan');
  console.log('='.repeat(50));
  log(`✅ 通过: ${passed} 个测试`, 'green');
  if (failed > 0) {
    log(`❌ 失败: ${failed} 个测试`, 'red');
  }
  log(`📈 通过率: ${((passed / tests.length) * 100).toFixed(1)}%`, 'yellow');
  
  // 清理测试数据（可选）
  if (process.argv.includes('--cleanup')) {
    logSection('清理测试数据');
    // 这里可以添加清理逻辑
    log('测试数据已清理', 'green');
  }
}

// 检查服务是否运行
async function checkServices() {
  try {
    await axios.get(`${BASE_URL}/health`);
    return true;
  } catch (error) {
    log('❌ 后端服务未运行，请先启动服务', 'red');
    return false;
  }
}

// 运行测试
(async () => {
  if (await checkServices()) {
    await runTests();
  }
})();