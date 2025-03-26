import React, { useState, useEffect } from 'react';
import { getUserInfo, updateUserInfo, updateHealthInfo, updateRegionAndPreferences } from '../services/userService';

const UserProfile = () => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    loadUserProfile();
  }, []);

  const loadUserProfile = async () => {
    try {
      const response = await getUserInfo();
      if (response.success) {
        setUser(response.user);
      } else {
        setError(response.message || '获取用户信息失败');
      }
    } catch (error) {
      setError('加载用户信息时出错');
      console.error('加载用户信息错误:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateProfile = async (formData) => {
    try {
      const response = await updateUserInfo(formData);
      if (response.success) {
        setUser(prevUser => ({
          ...prevUser,
          ...response.user
        }));
      } else {
        setError(response.message || '更新用户信息失败');
      }
    } catch (error) {
      setError('更新用户信息时出错');
      console.error('更新用户信息错误:', error);
    }
  };

  const handleUpdateHealthInfo = async (healthData) => {
    try {
      const response = await updateHealthInfo(healthData);
      if (response.success) {
        setUser(prevUser => ({
          ...prevUser,
          ...response.user
        }));
      } else {
        setError(response.message || '更新健康信息失败');
      }
    } catch (error) {
      setError('更新健康信息时出错');
      console.error('更新健康信息错误:', error);
    }
  };

  const handleUpdatePreferences = async (preferences) => {
    try {
      const response = await updateRegionAndPreferences(preferences);
      if (response.success) {
        setUser(prevUser => ({
          ...prevUser,
          region: response.region,
          dietaryPreferences: response.dietaryPreferences
        }));
      } else {
        setError(response.message || '更新偏好设置失败');
      }
    } catch (error) {
      setError('更新偏好设置时出错');
      console.error('更新偏好设置错误:', error);
    }
  };

  if (loading) {
    return <div>加载中...</div>;
  }

  if (error) {
    return <div className="error-message">{error}</div>;
  }

  if (!user) {
    return <div>未找到用户信息</div>;
  }

  return (
    <div className="user-profile">
      <h2>用户资料</h2>
      
      {/* 基本信息 */}
      <section className="basic-info">
        <h3>基本信息</h3>
        <p>昵称: {user.nickname || '未设置'}</p>
        <p>手机号: {user.phone}</p>
      </section>

      {/* 健康信息 */}
      <section className="health-info">
        <h3>健康信息</h3>
        <p>身高: {user.height ? `${user.height}cm` : '未设置'}</p>
        <p>体重: {user.weight ? `${user.weight}kg` : '未设置'}</p>
        <p>年龄: {user.age || '未设置'}</p>
        <p>性别: {user.gender || '未设置'}</p>
        <p>活动水平: {user.activityLevel || '未设置'}</p>
      </section>

      {/* 地区和饮食偏好 */}
      <section className="preferences">
        <h3>地区和饮食偏好</h3>
        <p>地区: {user.region?.province ? `${user.region.province} ${user.region.city}` : '未设置'}</p>
        <p>菜系偏好: {user.dietaryPreferences?.cuisinePreference || '未设置'}</p>
        <p>辣度偏好: {user.dietaryPreferences?.spicyPreference || '未设置'}</p>
        <p>过敏: {user.dietaryPreferences?.allergies?.length ? user.dietaryPreferences.allergies.join(', ') : '无'}</p>
        <p>忌口: {user.dietaryPreferences?.avoidedIngredients?.length ? user.dietaryPreferences.avoidedIngredients.join(', ') : '无'}</p>
      </section>
    </div>
  );
};

export default UserProfile; 