/**
 * 简化的API测试
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

async function testSimpleAPI() {
  try {
    // 测试一个简单的API调用，比如健康检查
    console.log('测试基本API连接...');
    
    // 先测试一个不需要认证的接口
    const healthResponse = await axios.get(`${API_BASE_URL}/health`);
    console.log('健康检查响应:', healthResponse.status);
    
  } catch (error) {
    if (error.response?.status === 404) {
      console.log('健康检查接口不存在，测试其他接口...');
      
      // 测试常量接口
      try {
        const constantsResponse = await axios.get(`${API_BASE_URL}/constants/nutritionist-types`);
        console.log('常量接口正常:', constantsResponse.status);
        console.log('营养师类型:', Object.keys(constantsResponse.data.data || {}));
      } catch (constantsError) {
        console.log('常量接口错误:', constantsError.response?.status || constantsError.message);
      }
    } else {
      console.error('连接失败:', error.message);
    }
  }
}

testSimpleAPI();