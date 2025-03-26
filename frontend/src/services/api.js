// 用户登录
export const login = async (credentials) => {
  try {
    const response = await axios.post(`${API_BASE_URL}/users/login`, credentials);
    if (response.data.success) {
      // 保存token
      localStorage.setItem('token', response.data.token);
      // 保存用户信息
      localStorage.setItem('user', JSON.stringify(response.data.user));
      return response.data;
    } else {
      throw new Error(response.data.message || '登录失败');
    }
  } catch (error) {
    console.error('登录错误:', error);
    // 添加重试逻辑
    if (error.response?.status === 500) {
      // 如果是服务器错误，尝试重试
      try {
        const retryResponse = await axios.post(`${API_BASE_URL}/users/login`, credentials);
        if (retryResponse.data.success) {
          localStorage.setItem('token', retryResponse.data.token);
          localStorage.setItem('user', JSON.stringify(retryResponse.data.user));
          return retryResponse.data;
        }
      } catch (retryError) {
        console.error('重试登录失败:', retryError);
      }
    }
    throw error;
  }
}; 