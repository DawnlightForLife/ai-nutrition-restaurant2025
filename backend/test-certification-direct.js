/**
 * 直接测试营养师认证API
 */

const axios = require('axios');

async function testCertification() {
  try {
    // 1. 获取验证码
    console.log('1. 发送验证码...');
    await axios.post('http://localhost:8080/api/auth/send-code', {
      phone: '15112341234'
    });
    
    // 2. 登录
    console.log('2. 登录...');
    const loginRes = await axios.post('http://localhost:8080/api/auth/login/code', {
      phone: '15112341234',
      code: '123456'
    });
    
    const token = loginRes.data.token;
    console.log('获取到token:', token.substring(0, 20) + '...');
    
    // 3. 创建申请
    console.log('3. 创建营养师认证申请...');
    const startTime = Date.now();
    
    const applicationData = {
      personalInfo: {
        fullName: '测试用户',
        idNumber: '110101199001011' + Math.floor(Math.random() * 1000).toString().padStart(3, '0') + Math.floor(Math.random() * 10),
        phone: '15112341234'
      },
      certificationInfo: {
        specializationAreas: ['sports_nutrition'],
        workYearsInNutrition: 1
      },
      documents: [{
        documentType: 'nutrition_certificate',
        fileName: 'test.jpg',
        fileUrl: 'http://example.com/test.jpg',
        fileSize: 50000,
        mimeType: 'image/jpeg',
        uploadedAt: new Date().toISOString()
      }]
    };
    
    const response = await axios.post(
      'http://localhost:8080/api/nutritionist-certification/applications',
      applicationData,
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        timeout: 60000 // 60秒超时
      }
    );
    
    const duration = Date.now() - startTime;
    console.log(`✅ 申请创建成功，耗时: ${duration}ms`);
    console.log('响应数据:', JSON.stringify(response.data, null, 2));
    
  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    if (error.response) {
      console.error('响应状态:', error.response.status);
      console.error('响应数据:', error.response.data);
    }
  }
}

testCertification();