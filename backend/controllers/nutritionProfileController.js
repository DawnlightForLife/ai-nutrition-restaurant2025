const NutritionProfile = require('../models/nutritionProfileModel');
const mongoose = require('mongoose');

// 创建新的营养档案
const createProfile = async (req, res) => {
  try {
    const {
      name,
      gender,
      age,
      height,
      weight,
      activityLevel,
      healthConditions,
      dietaryPreferences,
      goals
    } = req.body;

    // 从JWT获取用户ID
    const ownerId = req.user.userId;

    // 验证必填字段
    if (!name) {
      return res.status(400).json({ success: false, message: '档案名称不能为空' });
    }

    // 创建新的营养档案
    const newProfile = new NutritionProfile({
      ownerId,
      name,
      gender,
      age,
      height,
      weight,
      activityLevel,
      healthConditions,
      dietaryPreferences,
      goals
    });

    await newProfile.save();

    res.status(201).json({
      success: true,
      message: '营养档案创建成功',
      profile: newProfile
    });
  } catch (error) {
    console.error('创建营养档案失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取用户的所有营养档案
const getUserProfiles = async (req, res) => {
  try {
    const { ownerId } = req.query;
    
    if (!ownerId) {
      return res.status(400).json({ success: false, message: '用户ID不能为空' });
    }
    
    // 验证ID格式是否有效
    if (!mongoose.Types.ObjectId.isValid(ownerId)) {
      return res.status(400).json({ success: false, message: '无效的用户ID格式' });
    }

    const profiles = await NutritionProfile.find({ ownerId }).sort({ updatedAt: -1 });

    res.json({
      success: true,
      count: profiles.length,
      profiles
    });
  } catch (error) {
    console.error('获取用户营养档案失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取单个营养档案详情
const getProfileById = async (req, res) => {
  try {
    const { profileId } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者是否为档案所有者
    if (profile.ownerId.toString() !== req.user.userId) {
      return res.status(403).json({ success: false, message: '无权访问此档案' });
    }

    res.json({
      success: true,
      profile
    });
  } catch (error) {
    console.error('获取营养档案详情失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 更新营养档案
const updateProfile = async (req, res) => {
  try {
    const { profileId } = req.params;
    const updateData = req.body;
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    // 查找档案并检查所有权
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者是否为档案所有者
    if (profile.ownerId.toString() !== req.user.userId) {
      return res.status(403).json({ success: false, message: '无权修改此档案' });
    }

    // 防止修改档案所有者
    delete updateData.ownerId;
    
    // 更新档案
    const updatedProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      updateData,
      { new: true, runValidators: true }
    );

    res.json({
      success: true,
      message: '营养档案更新成功',
      profile: updatedProfile
    });
  } catch (error) {
    console.error('更新营养档案失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 删除营养档案
const deleteProfile = async (req, res) => {
  try {
    const { profileId } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    // 查找档案并检查所有权
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者是否为档案所有者
    if (profile.ownerId.toString() !== req.user.userId) {
      return res.status(403).json({ success: false, message: '无权删除此档案' });
    }

    // 删除档案
    await NutritionProfile.findByIdAndDelete(profileId);

    res.json({
      success: true,
      message: '营养档案已删除'
    });
  } catch (error) {
    console.error('删除营养档案失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

module.exports = {
  createProfile,
  getUserProfiles,
  getProfileById,
  updateProfile,
  deleteProfile
}; 