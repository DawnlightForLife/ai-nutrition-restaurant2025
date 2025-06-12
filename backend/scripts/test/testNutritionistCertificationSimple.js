/**
 * 营养师认证API测试脚本 - 简化版
 * 使用前端实际发送的数据格式
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';
let authToken = '';
let applicationId = '';

// 测试用户数据
const testPhone = '13800138011';
const testCode = '123456'; // 测试环境固定验证码

// 简化的测试申请数据（与前端一致）
const testApplication = {
  personalInfo: {
    fullName: '张衡',
    idNumber: '513433199412112512',
    phone: '15112341234'
  },
  certificationInfo: {
    specializationAreas: ['child_nutrition', 'weight_management'],
    workYearsInNutrition: 1
  },
  documents: [{
    documentType: 'nutrition_certificate',
    fileName: 'scaled_19.jpg',
    fileUrl: 'local:///data/user/0/com.ainutrition.restaurant.staging/cache/scaled_19.jpg',
    fileSize: 82716,
    mimeType: 'image/jpeg',
    uploadedAt: new Date().toISOString()
  }]
};

async function test() {
  try {
    console.log('🚀 开始测试营养师认证API（简化版）...\n');

    // 1. 发送验证码
    console.log('1️⃣ 发送验证码...');
    try {
      await axios.post(`${API_BASE_URL}/auth/send-code`, {
        phone: testPhone
      });
      console.log('✅ 验证码发送成功\n');
    } catch (error) {
      console.log('❌ 发送验证码失败:', error.response?.data?.message || error.message);
    }

    // 2. 登录
    console.log('2️⃣ 用户登录...');
    try {
      const loginResponse = await axios.post(`${API_BASE_URL}/auth/login/code`, {
        phone: testPhone,
        code: testCode
      });
      authToken = loginResponse.data.token || loginResponse.data.data?.token;
      const userId = loginResponse.data.user?._id || loginResponse.data.data?.user?._id;
      console.log('✅ 登录成功');
      console.log('👤 用户ID:', userId);
      console.log('🔑 Token前10位:', authToken.substring(0, 10) + '...');
      console.log('\n');
    } catch (error) {
      console.log('❌ 登录失败:', error.response?.data?.message || error.message);
      return;
    }

    // 3. 创建认证申请
    console.log('3️⃣ 创建认证申请...');
    console.log('📋 请求数据:', JSON.stringify(testApplication, null, 2));
    
    try {
      const createResponse = await axios.post(
        `${API_BASE_URL}/nutritionist-certification/applications`,
        testApplication,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`,
            'Content-Type': 'application/json'
          },
          timeout: 30000 // 30秒超时
        }
      );
      applicationId = createResponse.data.data._id;
      console.log('✅ 申请创建成功');
      console.log('📋 申请ID:', applicationId);
      console.log('📋 申请编号:', createResponse.data.data.applicationNumber);
      console.log('📋 当前状态:', createResponse.data.data.review.status);
      console.log('\n');
    } catch (error) {
      console.log('❌ 创建申请失败:', error.response?.data?.message || error.message);
      if (error.response?.data) {
        console.log('❌ 错误详情:', JSON.stringify(error.response.data, null, 2));
      }
      if (error.code === 'ETIMEDOUT' || error.code === 'ECONNABORTED') {
        console.log('⏱️ 请求超时');
      }
      return;
    }

    // 4. 查询申请详情
    if (applicationId) {
      console.log('4️⃣ 查询申请详情...');
      try {
        const detailResponse = await axios.get(
          `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}`,
          {
            headers: {
              'Authorization': `Bearer ${authToken}`
            }
          }
        );
        const application = detailResponse.data.data;
        console.log('✅ 查询成功');
        console.log('📋 申请编号:', application.applicationNumber);
        console.log('📋 申请状态:', application.review.status);
        console.log('📋 申请人姓名:', application.personalInfo.fullName);
        console.log('\n');
      } catch (error) {
        console.log('❌ 查询失败:', error.response?.data?.message || error.message);
      }
    }

    console.log('\n✨ 测试完成！');

  } catch (error) {
    console.error('💥 测试过程中发生错误:', error.message);
    if (error.stack) {
      console.error('堆栈信息:', error.stack);
    }
  }
}

// 运行测试
test();