const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const { successResponse, errorResponse } = require('../../utils/responseUtils');
const User = require('../../models/core/userModel');
const { sendVerificationEmail } = require('../../services/core/emailService');

/**
 * 验证注册数据
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const validateRegistrationData = async (req, res) => {
  try {
    const { username, email } = req.body;

    // 检查用户名是否已存在
    const existingUsername = await User.findOne({ username });
    if (existingUsername) {
      return errorResponse(res, 400, '用户名已被使用');
    }

    // 检查邮箱是否已存在
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return errorResponse(res, 400, '邮箱已被注册');
    }

    return successResponse(res, 200, '验证通过');
  } catch (error) {
    console.error('验证注册数据失败:', error);
    return errorResponse(res, 500, '服务器错误');
  }
};

/**
 * 注册新用户
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const registerUser = async (req, res) => {
  try {
    const { username, password, email, phone } = req.body;

    // 生成验证码
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const verificationToken = uuidv4();

    // 创建新用户
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({
      username,
      password: hashedPassword,
      email,
      phone,
      verificationCode,
      verificationToken,
      status: 'pending'
    });

    await user.save();

    // 发送验证邮件
    await sendVerificationEmail(email, verificationCode);

    return successResponse(res, 201, '注册成功，请查收验证邮件', {
      userId: user._id,
      verificationToken
    });
  } catch (error) {
    console.error('注册用户失败:', error);
    return errorResponse(res, 500, '服务器错误');
  }
};

/**
 * 完成注册流程
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const completeRegistration = async (req, res) => {
  try {
    const { userId } = req.params;
    const { verificationCode } = req.body;

    const user = await User.findById(userId);
    if (!user) {
      return errorResponse(res, 404, '用户不存在');
    }

    if (user.status !== 'pending') {
      return errorResponse(res, 400, '用户已完成注册');
    }

    if (user.verificationCode !== verificationCode) {
      return errorResponse(res, 400, '验证码错误');
    }

    // 更新用户状态
    user.status = 'active';
    user.verificationCode = undefined;
    user.verificationToken = undefined;
    user.emailVerified = true;
    await user.save();

    return successResponse(res, 200, '注册完成');
  } catch (error) {
    console.error('完成注册失败:', error);
    return errorResponse(res, 500, '服务器错误');
  }
};

module.exports = {
  validateRegistrationData,
  registerUser,
  completeRegistration
}; 