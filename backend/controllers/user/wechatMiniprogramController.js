const axios = require('axios');
const jwt = require('jsonwebtoken');
const User = require('../../models/user/userModel');
const ResponseHelper = require('../../utils/responseHelper');

/**
 * 微信小程序登录控制器
 */
class WechatMiniprogramController {
  /**
   * 微信手机号快速登录
   * POST /auth/wechat-phone-login
   */
  static async phoneLogin(req, res) {
    try {
      const { loginCode, phoneCode } = req.body;

      if (!loginCode || !phoneCode) {
        return ResponseHelper.error(res, '登录凭证和手机号授权码不能为空', 400);
      }

      // 1. 使用loginCode换取openid
      const wechatResponse = await WechatMiniprogramController.code2Session(loginCode);
      
      if (!wechatResponse.openid) {
        return ResponseHelper.error(res, '微信登录失败：' + (wechatResponse.errmsg || '获取用户信息失败'), 400);
      }

      // 2. 使用phoneCode获取手机号
      const phoneInfo = await WechatMiniprogramController.getPhoneNumber(phoneCode);
      
      if (!phoneInfo.phoneNumber) {
        return ResponseHelper.error(res, '获取手机号失败：' + (phoneInfo.errmsg || '手机号授权失败'), 400);
      }

      const { openid, session_key, unionid } = wechatResponse;
      const { phoneNumber } = phoneInfo;

      // 3. 查找或创建用户（使用手机号作为主键）
      let user = await User.findOne({ 
        phone: phoneNumber
      });

      if (!user) {
        // 创建新用户
        user = await WechatMiniprogramController.createUserWithPhone(openid, session_key, unionid, phoneNumber);
      } else {
        // 更新现有用户的微信信息
        await WechatMiniprogramController.updateUserWechatInfo(user, openid, session_key);
      }

      // 4. 生成JWT令牌
      const token = jwt.sign(
        { 
          userId: user._id,
          openid: user.wechatOpenId,
          role: user.role,
          phone: user.phone
        },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
      );

      // 5. 返回登录结果
      const userResponse = {
        id: user._id,
        phone: user.phone,
        nickname: user.nickname,
        email: user.email,
        avatarUrl: user.avatarUrl,
        role: user.role,
        needsPhoneBinding: false, // 已经有手机号了
        createdAt: user.createdAt
      };

      return ResponseHelper.success(res, {
        token,
        user: userResponse,
        message: user.isNewUser ? '注册成功' : '登录成功'
      });

    } catch (error) {
      console.error('微信手机号登录错误:', error);
      return ResponseHelper.error(res, '登录失败：' + error.message, 500);
    }
  }

  /**
   * 微信小程序登录
   * POST /auth/wechat-miniprogram
   */
  static async login(req, res) {
    try {
      const { code, userInfo = null } = req.body;

      if (!code) {
        return ResponseHelper.error(res, '微信登录凭证不能为空', 400);
      }

      // 1. 使用code换取openid和session_key
      const wechatResponse = await WechatMiniprogramController.code2Session(code);
      
      if (!wechatResponse.openid) {
        return ResponseHelper.error(res, '微信登录失败：' + (wechatResponse.errmsg || '获取用户信息失败'), 400);
      }

      const { openid, session_key, unionid } = wechatResponse;

      // 2. 查找或创建用户
      let user = await User.findOne({ 
        wechatOpenId: openid
      });

      if (!user) {
        // 创建新用户
        user = await WechatMiniprogramController.createUser(openid, session_key, unionid, userInfo);
      } else {
        // 更新现有用户信息
        await WechatMiniprogramController.updateUser(user, session_key, userInfo);
      }

      // 3. 生成JWT令牌
      const token = jwt.sign(
        { 
          userId: user._id,
          openid: user.wechatOpenId,
          role: user.role
        },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
      );

      // 4. 返回登录结果
      const userResponse = {
        id: user._id,
        phone: user.phone,
        nickname: user.nickname,
        email: user.email,
        avatarUrl: user.avatarUrl,
        role: user.role,
        needsPhoneBinding: !user.phone, // 是否需要绑定手机号
        createdAt: user.createdAt
      };

      return ResponseHelper.success(res, {
        token,
        user: userResponse,
        message: user.isNewUser ? '注册成功' : '登录成功'
      });

    } catch (error) {
      console.error('微信小程序登录错误:', error);
      return ResponseHelper.error(res, '登录失败：' + error.message, 500);
    }
  }

  /**
   * 手机号绑定
   * POST /auth/bind-phone
   */
  static async bindPhone(req, res) {
    try {
      const { phone, code, encryptedData, iv } = req.body;
      const userId = req.user.userId;

      if (!phone || !code) {
        return ResponseHelper.error(res, '手机号和验证码不能为空', 400);
      }

      // 验证短信验证码（这里需要实现验证码验证逻辑）
      // const isValidCode = await verifyPhoneCode(phone, code);
      // if (!isValidCode) {
      //   return ResponseHelper.error(res, '验证码错误或已过期', 400);
      // }

      // 检查手机号是否已被使用
      const existingUser = await User.findOne({ phone, _id: { $ne: userId } });
      if (existingUser) {
        return ResponseHelper.error(res, '该手机号已被其他用户使用', 400);
      }

      // 更新用户手机号
      const user = await User.findByIdAndUpdate(
        userId,
        { 
          phone,
          phoneVerified: true,
          updatedAt: new Date()
        },
        { new: true }
      );

      if (!user) {
        return ResponseHelper.error(res, '用户不存在', 404);
      }

      return ResponseHelper.success(res, {
        message: '手机号绑定成功',
        user: {
          id: user._id,
          phone: user.phone,
          phoneVerified: user.phoneVerified
        }
      });

    } catch (error) {
      console.error('手机号绑定错误:', error);
      return ResponseHelper.error(res, '绑定失败：' + error.message, 500);
    }
  }

  /**
   * 使用code换取openid和session_key
   */
  static async code2Session(code) {
    const appId = process.env.WECHAT_MINIPROGRAM_APP_ID;
    const appSecret = process.env.WECHAT_MINIPROGRAM_APP_SECRET;

    if (!appId || !appSecret) {
      throw new Error('微信小程序配置不完整，请检查环境变量');
    }

    const url = 'https://api.weixin.qq.com/sns/jscode2session';
    const params = {
      appid: appId,
      secret: appSecret,
      js_code: code,
      grant_type: 'authorization_code'
    };

    try {
      const response = await axios.get(url, { params });
      return response.data;
    } catch (error) {
      console.error('调用微信接口失败:', error);
      throw new Error('调用微信接口失败');
    }
  }

  /**
   * 创建新用户
   */
  static async createUser(openid, sessionKey, unionid, userInfo) {
    // 生成一个临时手机号，因为手机号是必填的
    const tempPhone = `wx${Date.now().toString().slice(-10)}`;
    
    const userData = {
      phone: tempPhone, // 临时手机号，后续需要用户绑定真实手机号
      nickname: userInfo?.nickName || '微信用户',
      avatarUrl: userInfo?.avatarUrl || '',
      wechatOpenId: openid,
      role: 'customer', // 默认角色
      authType: 'oauth',
      autoRegistered: true,
      profileCompleted: false
    };

    // 如果有性别信息
    if (userInfo?.gender !== undefined) {
      userData.gender = userInfo.gender === 1 ? 'male' : userInfo.gender === 2 ? 'female' : 'unknown';
    }

    // 如果有城市信息
    if (userInfo?.city) {
      userData.city = userInfo.city;
    }

    const user = new User(userData);
    await user.save();
    
    return user;
  }

  /**
   * 更新现有用户信息
   */
  static async updateUser(user, sessionKey, userInfo) {
    const updateData = {
      lastLogin: {
        time: new Date(),
        ip: '', // 可以从req中获取
        device: 'wechat_miniprogram'
      }
    };

    // 更新用户信息（如果提供）
    if (userInfo) {
      if (userInfo.nickName && !user.nickname) {
        updateData.nickname = userInfo.nickName;
      }
      if (userInfo.avatarUrl && !user.avatarUrl) {
        updateData.avatarUrl = userInfo.avatarUrl;
      }
      if (userInfo.gender !== undefined && !user.gender) {
        updateData.gender = userInfo.gender === 1 ? 'male' : userInfo.gender === 2 ? 'female' : 'unknown';
      }
      if (userInfo.city && !user.region?.city) {
        updateData['region.city'] = userInfo.city;
      }
    }

    await User.findByIdAndUpdate(user._id, updateData);
    
    // 返回更新后的用户对象
    Object.assign(user, updateData);
    return user;
  }

  /**
   * 获取微信手机号
   */
  static async getPhoneNumber(phoneCode) {
    const appId = process.env.WECHAT_MINIPROGRAM_APP_ID;
    const appSecret = process.env.WECHAT_MINIPROGRAM_APP_SECRET;

    if (!appId || !appSecret) {
      throw new Error('微信小程序配置不完整，请检查环境变量');
    }

    try {
      // 1. 获取access_token
      const tokenUrl = 'https://api.weixin.qq.com/cgi-bin/token';
      const tokenParams = {
        grant_type: 'client_credential',
        appid: appId,
        secret: appSecret
      };

      const tokenResponse = await axios.get(tokenUrl, { params: tokenParams });
      
      if (!tokenResponse.data.access_token) {
        throw new Error('获取access_token失败：' + (tokenResponse.data.errmsg || '未知错误'));
      }

      // 2. 使用access_token和phoneCode获取手机号
      const phoneUrl = 'https://api.weixin.qq.com/wxa/business/getuserphonenumber';
      const phoneData = {
        code: phoneCode
      };

      const phoneResponse = await axios.post(phoneUrl + '?access_token=' + tokenResponse.data.access_token, phoneData);
      
      if (phoneResponse.data.errcode === 0) {
        return {
          phoneNumber: phoneResponse.data.phone_info.phoneNumber,
          purePhoneNumber: phoneResponse.data.phone_info.purePhoneNumber,
          countryCode: phoneResponse.data.phone_info.countryCode
        };
      } else {
        throw new Error('获取手机号失败：' + (phoneResponse.data.errmsg || '未知错误'));
      }
    } catch (error) {
      console.error('调用微信手机号接口失败:', error);
      throw new Error('调用微信手机号接口失败');
    }
  }

  /**
   * 创建带手机号的新用户
   */
  static async createUserWithPhone(openid, sessionKey, unionid, phoneNumber) {
    const userData = {
      phone: phoneNumber,
      nickname: '微信用户',
      avatarUrl: '',
      wechatOpenId: openid,
      role: 'customer',
      authType: 'oauth',
      autoRegistered: true,
      profileCompleted: false,
      phoneVerified: true, // 微信授权的手机号默认已验证
      isNewUser: true
    };

    const user = new User(userData);
    await user.save();
    
    return user;
  }

  /**
   * 更新用户的微信信息
   */
  static async updateUserWechatInfo(user, openid, sessionKey) {
    const updateData = {
      wechatOpenId: openid,
      lastLogin: {
        time: new Date(),
        ip: '',
        device: 'wechat_miniprogram'
      }
    };

    await User.findByIdAndUpdate(user._id, updateData);
    
    // 返回更新后的用户对象
    Object.assign(user, updateData);
    return user;
  }

  /**
   * 解密微信小程序数据
   */
  static decryptWechatData(encryptedData, iv, sessionKey) {
    const crypto = require('crypto');
    
    try {
      const decipher = crypto.createDecipheriv('aes-128-cbc', sessionKey, iv);
      decipher.setAutoPadding(true);
      
      let decrypted = decipher.update(encryptedData, 'base64', 'utf8');
      decrypted += decipher.final('utf8');
      
      return JSON.parse(decrypted);
    } catch (error) {
      throw new Error('数据解密失败');
    }
  }
}

module.exports = WechatMiniprogramController;