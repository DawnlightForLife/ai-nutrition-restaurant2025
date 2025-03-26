import axios from 'axios';
import { API_BASE_URL } from '../config';

// 创建axios实例
const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000, // 设置超时时间为30秒
  headers: {
    'Content-Type': 'application/json'
  }
});

// 请求拦截器
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
api.interceptors.response.use(
  response => response,
  async error => {
    if (error.code === 'ECONNABORTED') {
      // 超时重试
      const config = error.config;
      if (!config._retry) {
        config._retry = true;
        return api(config);
      }
    }
    return Promise.reject(error);
  }
);

// 用户登录
export const login = async (credentials) => {
  try {
    const response = await api.post('/users/login', credentials);
    if (response.data.success) {
      // 保存token和用户信息
      localStorage.setItem('token', response.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.user));
      return response.data;
    } else {
      throw new Error(response.data.message || '登录失败');
    }
  } catch (error) {
    console.error('登录错误:', error);
    if (error.code === 'ECONNABORTED') {
      throw new Error('登录请求超时，请检查网络连接');
    }
    throw error;
  }
};

// 用户注册
export const register = async (userData) => {
  try {
    const response = await api.post('/users/register', userData);
    if (response.data.success) {
      // 保存token和用户信息
      localStorage.setItem('token', response.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.user));
      return response.data;
    } else {
      throw new Error(response.data.message || '注册失败');
    }
  } catch (error) {
    console.error('注册错误:', error);
    throw error;
  }
};

// 获取用户信息
export const getUserInfo = async () => {
  try {
    const response = await api.get('/users/profile');
    return response.data;
  } catch (error) {
    console.error('获取用户信息错误:', error);
    throw error;
  }
};

// 更新用户信息
export const updateUserInfo = async (userData) => {
  try {
    const response = await api.put('/users/profile', userData);
    return response.data;
  } catch (error) {
    console.error('更新用户信息错误:', error);
    throw error;
  }
};

// 更新健康信息
export const updateHealthInfo = async (healthData) => {
  try {
    const response = await api.put('/users/health-info', healthData);
    return response.data;
  } catch (error) {
    console.error('更新健康信息错误:', error);
    throw error;
  }
};

// 更新地区和饮食偏好
export const updateRegionAndPreferences = async (preferences) => {
  try {
    const response = await api.put('/users/preferences', preferences);
    return response.data;
  } catch (error) {
    console.error('更新偏好错误:', error);
    throw error;
  }
};

// 上传医疗报告
export const uploadMedicalReport = async (file) => {
  try {
    const formData = new FormData();
    formData.append('report', file);
    
    const response = await api.post('/users/medical-report', formData, {
      headers: { 
        'Content-Type': 'multipart/form-data'
      }
    });
    return response.data;
  } catch (error) {
    console.error('上传医疗报告错误:', error);
    throw error;
  }
}; 