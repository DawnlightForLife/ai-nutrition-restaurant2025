/**
 * 直接测试营养师认证路由
 */

const axios = require('axios');

async function testDirectRoute() {
  try {
    // 测试不需要认证的GET请求（如果有的话）
    console.log('测试营养师认证路由是否存在...');
    
    const response = await axios.get('http://localhost:8080/api/nutritionist-certification/applications');
    console.log('路由响应:', response.status);
    
  } catch (error) {
    console.log('错误状态码:', error.response?.status);
    console.log('错误信息:', error.response?.data?.message || error.message);
    
    if (error.response?.status === 404) {
      console.log('路由不存在，但这可能是正常的（如果没有test端点）');
    } else if (error.response?.status === 401) {
      console.log('路由存在但需要认证');
    } else if (error.response?.status === 500) {
      console.log('路由存在但有服务器错误');
    }
  }
}

testDirectRoute();