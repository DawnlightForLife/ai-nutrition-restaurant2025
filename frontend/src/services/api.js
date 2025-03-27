import axios from 'axios';
// 定义API基础URL，确保指向正确的后端地址
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:8080/api';

console.log('[API] 使用API基础URL:', API_BASE_URL);

// 创建axios实例
const axiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// 请求拦截器
axiosInstance.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token');
    if (token) {
      console.log('添加授权头:', `Bearer ${token}`);
      config.headers.Authorization = `Bearer ${token}`;
    } else {
      console.log('未找到令牌，请求将在没有授权的情况下发送');
    }
    return config;
  },
  error => Promise.reject(error)
);

// 响应拦截器
axiosInstance.interceptors.response.use(
  response => response,
  error => {
    if (error.response) {
      console.error('API错误响应:', error.response.status, error.response.data);
      // 如果是401错误，可能是令牌问题
      if (error.response.status === 401) {
        console.error('令牌验证失败，尝试重新登录');
        // 可以在这里处理令牌刷新或重定向到登录页面
      }
    }
    return Promise.reject(error);
  }
);

// 用户登录
export const login = async (credentials) => {
  try {
    const response = await axiosInstance.post('/users/login', credentials);
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
        const retryResponse = await axiosInstance.post('/users/login', credentials);
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

// 营养档案API
export const nutritionProfileApi = {
  // 获取用户的所有营养档案
  getUserProfiles: async (userId) => {
    try {
      const response = await axiosInstance.get(`/nutrition-profiles?ownerId=${userId}`);
      return response.data;
    } catch (error) {
      console.error('获取营养档案失败:', error);
      throw error;
    }
  },

  // 创建新的营养档案
  createProfile: async (profileData) => {
    try {
      const response = await axiosInstance.post('/nutrition-profiles', profileData);
      return response.data;
    } catch (error) {
      console.error('创建营养档案失败:', error);
      throw error;
    }
  },

  // 更新营养档案
  updateProfile: async (profileId, profileData) => {
    try {
      const response = await axiosInstance.put(`/nutrition-profiles/${profileId}`, profileData);
      return response.data;
    } catch (error) {
      console.error('更新营养档案失败:', error);
      throw error;
    }
  },

  // 删除营养档案
  deleteProfile: async (profileId) => {
    try {
      const response = await axiosInstance.delete(`/nutrition-profiles/${profileId}`);
      return response.data;
    } catch (error) {
      console.error('删除营养档案失败:', error);
      throw error;
    }
  }
}; 