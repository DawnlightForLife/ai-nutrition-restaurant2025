const nutritionProfileService = require('../services/nutritionProfileService');
const mongoose = require('mongoose');
const cacheService = require('../services/cacheService');
const AuditLog = require('../models/auditLogModel');

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
      goals,
      ownerId
    } = req.body;

    // 从JWT获取用户ID，或者使用请求中提供的ownerId（适用于管理员为用户创建档案的情况）
    const userId = req.user ? req.user.userId : null;
    const profileOwnerId = ownerId || userId;
    
    // 验证必须有用户ID
    if (!profileOwnerId) {
      return res.status(400).json({ success: false, message: '缺少用户ID(ownerId)' });
    }

    // 验证必填字段
    if (!name) {
      return res.status(400).json({ success: false, message: '档案名称不能为空' });
    }

    console.log(`[CreateProfile] 创建档案，用户ID: ${profileOwnerId}, 档案名称: ${name}`);

    // 创建新的营养档案
    try {
      const newProfile = await nutritionProfileService.createProfile({
        ownerId: profileOwnerId,
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

      // 添加审计日志
      await AuditLog.create({
        action: 'data_modify',
        description: '创建营养档案',
        actor: {
          type: 'user',
          id: userId || profileOwnerId,
          model: 'User',
          name: '用户' // 这里可以根据实际情况添加用户名
        },
        resource: {
          type: 'nutrition_profile',
          id: newProfile._id,
          name: newProfile.name,
          owner_id: profileOwnerId
        },
        result: {
          status: 'success',
          message: '营养档案创建成功'
        }
      });

      // 清除相关缓存
      await cacheService.del(`user_profiles:${profileOwnerId}`);

      res.status(201).json({
        success: true,
        message: '营养档案创建成功',
        profile: {
          ...newProfile.toObject(),
          ownerId: newProfile.user_id
        }
      });
    } catch (serviceError) {
      console.error('营养档案服务错误:', serviceError);
      
      // 处理不同类型的错误
      if (serviceError.name === 'ValidationError') {
        // Mongoose验证错误
        const validationErrors = Object.keys(serviceError.errors).map(field => ({
          field,
          message: serviceError.errors[field].message
        }));
        
        return res.status(400).json({ 
          success: false, 
          message: '数据验证失败',
          errors: validationErrors
        });
      } else if (serviceError.code === 11000) {
        // 重复键错误
        return res.status(400).json({ 
          success: false, 
          message: '档案已存在'
        });
      }
      
      // 其他服务错误
      res.status(500).json({ 
        success: false, 
        message: '创建档案失败: ' + (serviceError.message || '未知错误')
      });
    }
  } catch (error) {
    console.error('创建营养档案失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取用户的所有营养档案
const getUserProfiles = async (req, res) => {
  try {
    // 尝试从请求参数、请求体或者认证令牌中获取用户ID
    const { ownerId, userId } = req.query;
    
    // 从JWT获取用户ID
    const jwtUserId = req.user ? req.user.userId : null;
    
    // 确定最终使用的用户ID
    const finalUserId = ownerId || userId || jwtUserId;
    
    console.log(`获取营养档案列表 - 参数: ownerId=${ownerId}, userId=${userId}, JWT用户=${jwtUserId}, 最终使用=${finalUserId}`);
    
    if (!finalUserId) {
      console.warn('获取营养档案列表失败: 未提供用户ID');
      return res.status(400).json({ 
        success: false, 
        message: '用户ID不能为空', 
        help: '请在查询参数中提供ownerId或userId，或使用有效的认证令牌' 
      });
    }
    
    // 验证ID格式是否有效
    if (!mongoose.Types.ObjectId.isValid(finalUserId)) {
      console.warn(`获取营养档案列表失败: 无效的用户ID格式 "${finalUserId}"`);
      return res.status(400).json({ success: false, message: '无效的用户ID格式' });
    }

    // 使用缓存服务
    const cacheKey = `user_profiles:${finalUserId}`;
    const profiles = await cacheService.get(cacheKey, async () => {
      return await nutritionProfileService.getProfilesByUserId(finalUserId);
    }, { ttl: 300 }); // 缓存5分钟

    console.log(`获取到 ${profiles.length} 个营养档案，用户ID: ${finalUserId}`);
    
    res.json({
      success: true,
      count: profiles.length,
      profiles: profiles.map(profile => ({
        ...profile.toObject(),
        ownerId: profile.user_id
      }))
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
    const { ownerId } = req.query;
    
    // 从JWT获取用户ID，或者使用请求中提供的ownerId
    const userId = req.user ? req.user.userId : null;
    const requesterId = userId || ownerId;
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    // 使用缓存服务
    const cacheKey = `profile:${profileId}`;
    const profile = await cacheService.get(cacheKey, async () => {
      return await nutritionProfileService.getProfileById(profileId);
    }, { ttl: 600 }); // 缓存10分钟
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者身份
    const profileOwnerId = profile.user_id.toString();
    
    // 如果有请求者ID，并且与档案所有者不匹配，则拒绝访问
    if (requesterId && profileOwnerId !== requesterId) {
      console.warn(`档案访问授权失败 - 请求者: ${requesterId}, 档案所有者: ${profileOwnerId}`);
      
      await AuditLog.create({
        action: 'data_access',
        description: '未授权访问营养档案',
        actor: {
          type: 'user',
          id: requesterId
        },
        resource: {
          type: 'nutrition_profile',
          id: profileId,
          name: profile.name,
          owner_id: profileOwnerId
        },
        result: {
          status: 'failure',
          message: '无权访问此档案'
        },
        sensitivity_level: 2
      });
      
      return res.status(403).json({ success: false, message: '无权访问此档案' });
    }

    res.json({
      success: true,
      profile: {
        ...profile.toObject(),
        ownerId: profile.user_id
      }
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
    
    // 从JWT获取用户ID，或者使用请求中提供的ownerId
    const userId = req.user ? req.user.userId : null;
    const requestOwnerId = updateData.ownerId;
    
    if (!userId && !requestOwnerId) {
      return res.status(400).json({ success: false, message: '缺少用户ID - 请提供ownerId或使用有效的认证令牌' });
    }
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    // 查找档案
    const profile = await nutritionProfileService.getProfileById(profileId);
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者是否为档案所有者
    const profileOwnerId = profile.user_id.toString();
    const requesterId = userId || requestOwnerId;
    
    console.log(`更新档案 - 请求者ID: ${requesterId}, 档案所有者ID: ${profileOwnerId}`);
    
    // 如果不是通过身份验证的令牌，并且ownerId与档案所有者不匹配，则拒绝
    if (profileOwnerId !== requesterId) {
      console.warn(`更新档案授权失败 - 请求者: ${requesterId}, 档案所有者: ${profileOwnerId}`);
      
      await AuditLog.create({
        action: 'data_modify',
        description: '未授权更新营养档案',
        actor: {
          type: 'user',
          id: requesterId
        },
        resource: {
          type: 'nutrition_profile',
          id: profileId,
          name: profile.name,
          owner_id: profileOwnerId
        },
        result: {
          status: 'failure',
          message: '无权修改此档案'
        },
        sensitivity_level: 2
      });
      
      return res.status(403).json({ success: false, message: '无权修改此档案' });
    }

    // 防止修改档案所有者
    delete updateData.ownerId;
    
    // 转换字段名，确保与模型一致
    if (updateData.ownerId && !updateData.user_id) {
      updateData.user_id = updateData.ownerId;
      delete updateData.ownerId;
    }
    
    // 更新档案
    const updatedProfile = await nutritionProfileService.updateProfile(profileId, updateData);

    // 记录审计日志
    await AuditLog.create({
      action: 'data_modify',
      description: '更新营养档案',
      actor: {
        type: 'user',
        id: requesterId
      },
      resource: {
        type: 'nutrition_profile',
        id: profileId,
        name: updatedProfile.name
      },
      result: {
        status: 'success',
        message: '营养档案更新成功'
      },
      data_snapshot: {
        changed_fields: Object.keys(updateData)
      }
    });

    // 清除相关缓存
    await Promise.all([
      cacheService.del(`profile:${profileId}`),
      cacheService.del(`user_profiles:${profileOwnerId}`)
    ]);

    res.json({
      success: true,
      message: '营养档案更新成功',
      profile: {
        ...updatedProfile.toObject(),
        ownerId: updatedProfile.user_id
      }
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
    const { ownerId } = req.query;
    
    // 从JWT获取用户ID，或者使用请求中提供的ownerId
    const userId = req.user ? req.user.userId : null;
    const requesterId = userId || ownerId;
    
    if (!requesterId) {
      return res.status(400).json({ success: false, message: '缺少用户ID - 请提供ownerId或使用有效的认证令牌' });
    }
    
    if (!mongoose.Types.ObjectId.isValid(profileId)) {
      return res.status(400).json({ success: false, message: '无效的档案ID格式' });
    }

    // 查找档案
    const profile = await nutritionProfileService.getProfileById(profileId);
    
    if (!profile) {
      return res.status(404).json({ success: false, message: '未找到该营养档案' });
    }

    // 验证请求者是否为档案所有者
    const profileOwnerId = profile.user_id.toString();
    
    console.log(`删除档案 - 请求者ID: ${requesterId}, 档案所有者ID: ${profileOwnerId}`);
    
    if (profileOwnerId !== requesterId) {
      console.warn(`删除档案授权失败 - 请求者: ${requesterId}, 档案所有者: ${profileOwnerId}`);
      
      await AuditLog.create({
        action: 'data_delete',
        description: '未授权删除营养档案',
        actor: {
          type: 'user',
          id: requesterId
        },
        resource: {
          type: 'nutrition_profile',
          id: profileId,
          name: profile.name,
          owner_id: profileOwnerId
        },
        result: {
          status: 'failure',
          message: '无权删除此档案'
        },
        sensitivity_level: 2
      });
      
      return res.status(403).json({ success: false, message: '无权删除此档案' });
    }

    // 删除档案
    await nutritionProfileService.deleteProfile(profileId);

    // 记录审计日志
    await AuditLog.create({
      action: 'data_delete',
      description: '删除营养档案',
      actor: {
        type: 'user',
        id: requesterId
      },
      resource: {
        type: 'nutrition_profile',
        id: profileId,
        name: profile.name
      },
      result: {
        status: 'success',
        message: '营养档案删除成功'
      }
    });

    // 清除相关缓存
    await Promise.all([
      cacheService.del(`profile:${profileId}`),
      cacheService.del(`user_profiles:${profileOwnerId}`)
    ]);

    res.json({
      success: true,
      message: '营养档案删除成功'
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