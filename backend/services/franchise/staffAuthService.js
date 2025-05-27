/**
 * 加盟店员工认证服务
 * 处理店长、店员、营养师的注册和登录
 */
const User = require('../../models/user/userModel');
const FranchiseStore = require('../../models/franchise/franchiseStoreModel');
const jwt = require('jsonwebtoken');
const config = require('../../config');
const AppError = require('../../utils/errors/appError');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 员工注册（需要邀请码）
 * @param {Object} staffData - 员工注册数据
 * @param {string} staffData.phone - 手机号
 * @param {string} staffData.password - 密码
 * @param {string} staffData.inviteCode - 邀请码
 * @param {string} staffData.role - 角色（store_manager/store_staff/nutritionist）
 * @returns {Promise<Object>} 注册成功的员工信息
 */
const registerStaff = async (staffData) => {
  try {
    const { phone, password, inviteCode, role, realName } = staffData;
    
    // 验证邀请码并获取加盟店信息
    const store = await validateInviteCode(inviteCode, role);
    if (!store) {
      throw new AppError('无效的邀请码', 400);
    }
    
    // 检查手机号是否已注册
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      throw new AppError('该手机号已注册', 400);
    }
    
    // 检查该店是否已有店长（如果注册的是店长角色）
    if (role === 'store_manager') {
      const existingManager = await User.findOne({
        franchiseStoreId: store._id,
        role: 'store_manager'
      });
      if (existingManager) {
        throw new AppError('该门店已有店长', 400);
      }
    }
    
    // 创建新员工用户
    const user = new User({
      phone,
      password,
      role,
      realName,
      franchiseStoreId: store._id,
      authType: 'password',
      profileCompleted: false,
      autoRegistered: false,
      nickname: `${store.storeName}-${getRoleLabel(role)}`
    });
    
    await user.save();
    
    // 更新门店员工列表
    store.staff.push({
      userId: user._id,
      role: mapToStoreRole(role),
      joinDate: new Date()
    });
    
    // 如果是店长，更新门店的管理者ID
    if (role === 'store_manager') {
      store.managerId = user._id;
    }
    
    await store.save();
    
    // 生成token
    const token = generateToken(user);
    
    // 返回用户信息
    const userObject = user.toObject();
    delete userObject.password;
    
    return {
      user: userObject,
      token,
      store: {
        id: store._id,
        name: store.storeName,
        code: store.storeCode
      }
    };
  } catch (error) {
    logger.error('员工注册失败', { error });
    throw error;
  }
};

/**
 * 员工登录
 * @param {string} phone - 手机号
 * @param {string} password - 密码
 * @returns {Promise<Object>} 登录信息
 */
const staffLogin = async (phone, password) => {
  try {
    const user = await User.findOne({ phone })
      .populate('franchiseStoreId', 'storeName storeCode status');
    
    if (!user) {
      throw new AppError('用户不存在', 401);
    }
    
    // 验证是否为员工角色
    if (!['store_manager', 'store_staff', 'nutritionist'].includes(user.role)) {
      throw new AppError('请使用顾客端登录', 403);
    }
    
    // 验证密码
    const isValid = await user.comparePassword(password);
    if (!isValid) {
      throw new AppError('密码错误', 401);
    }
    
    // 检查门店状态
    if (user.franchiseStoreId && !user.franchiseStoreId.status.isActive) {
      throw new AppError('所属门店已暂停营业', 403);
    }
    
    // 更新最后登录时间
    user.lastLogin = {
      time: new Date(),
      ip: '', // 需要从req获取
      device: 'staff_app'
    };
    await user.save();
    
    // 生成token
    const token = generateToken(user);
    
    // 返回登录信息
    const userObject = user.toObject();
    delete userObject.password;
    
    return {
      token,
      user: {
        ...userObject,
        store: user.franchiseStoreId ? {
          id: user.franchiseStoreId._id,
          name: user.franchiseStoreId.storeName,
          code: user.franchiseStoreId.storeCode
        } : null
      }
    };
  } catch (error) {
    logger.error('员工登录失败', { error });
    throw error;
  }
};

/**
 * 验证邀请码
 * @private
 * @param {string} inviteCode - 邀请码
 * @param {string} role - 申请的角色
 * @returns {Promise<Object>} 加盟店信息
 */
const validateInviteCode = async (inviteCode, role) => {
  // 邀请码格式: STORE_CODE-ROLE-RANDOM
  // 例如: YQ-BJ-001-MGR-A8K3
  const parts = inviteCode.split('-');
  if (parts.length < 4) {
    return null;
  }
  
  const storeCode = parts.slice(0, -2).join('-');
  const roleCode = parts[parts.length - 2];
  
  // 验证角色码
  const roleMap = {
    'MGR': 'store_manager',
    'STF': 'store_staff',
    'NUT': 'nutritionist'
  };
  
  if (roleMap[roleCode] !== role) {
    return null;
  }
  
  // 查找门店
  const store = await FranchiseStore.findOne({
    storeCode: storeCode,
    'franchiseInfo.franchiseStatus': 'active'
  });
  
  return store;
};

/**
 * 生成JWT token
 * @private
 * @param {Object} user - 用户对象
 * @returns {string} JWT token
 */
const generateToken = (user) => {
  const payload = {
    id: user._id,
    userId: user._id,
    role: user.role,
    phone: user.phone,
    franchiseStoreId: user.franchiseStoreId
  };
  
  return jwt.sign(
    payload,
    config.jwt.secret,
    { expiresIn: config.jwt.expiresIn }
  );
};

/**
 * 获取角色标签
 * @private
 * @param {string} role - 角色值
 * @returns {string} 角色标签
 */
const getRoleLabel = (role) => {
  const labels = {
    'store_manager': '店长',
    'store_staff': '店员',
    'nutritionist': '营养师'
  };
  return labels[role] || '员工';
};

/**
 * 映射到门店角色
 * @private
 * @param {string} userRole - 用户角色
 * @returns {string} 门店角色
 */
const mapToStoreRole = (userRole) => {
  const mapping = {
    'store_manager': 'manager',
    'store_staff': 'cashier',
    'nutritionist': 'nutritionist'
  };
  return mapping[userRole] || 'staff';
};

module.exports = {
  registerStaff,
  staffLogin
};