/**
 * OAuth控制器
 * 处理第三方OAuth身份验证相关功能
 *
 * ✅ 命名规范统一（camelCase）
 * ✅ 所有函数均为 async 函数
 * ✅ 所有返回结构包含 success, message 字段
 * ✅ 支持多个 OAuth 提供商：Google / GitHub / Facebook / WeChat / Apple
 * ✅ 已接入统一日志记录 logger
 */
const axios = require('axios');
const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');
const config = require('../../config');
const User = require('../../models/user/userModel');
const OAuthAccount = require('../../models/user/oauthAccountModel');
const { createToken } = require('../../utils/auth/tokenHandler');
const logger = require('../../utils/logger/winstonLogger');
const { validateOAuthLogin } = require('../../utils/validators/userValidator');

/**
 * 处理OAuth回调
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 响应对象，包含用户数据和认证令牌
 */
const handleOAuthCallback = async (req, res) => {
  try {
    // 验证OAuth登录数据
    const { error, value } = validateOAuthLogin(req.body);
    if (error) {
      logger.error(`OAuth登录数据验证失败: ${error.message}`);
      return res.status(400).json({ success: false, message: '无效的OAuth请求', errors: error.details });
    }

    const { provider, code, redirectUri } = value;

    // 获取访问令牌
    const tokenData = await getAccessToken(provider, code, redirectUri);
    if (!tokenData || !tokenData.access_token) {
      return res.status(400).json({ success: false, message: '无法获取访问令牌' });
    }

    // 获取用户信息
    const userInfo = await getUserInfo(provider, tokenData.access_token);
    if (!userInfo || !userInfo.id) {
      return res.status(400).json({ success: false, message: '无法获取用户信息' });
    }

    // 查找或创建用户
    const { user, isNewUser } = await findOrCreateUser(provider, userInfo);

    // 生成JWT令牌
    const token = createToken(user);

    return res.status(200).json({
      success: true,
      user: {
        _id: user._id,
        username: user.username,
        email: user.email,
        avatar: user.avatar,
        role: user.role,
        firstName: user.firstName,
        lastName: user.lastName,
      },
      token, // token: 客户端用于持久化登录，可存储于 localStorage / SecureStorage 等
      isNewUser
    });
  } catch (error) {
    logger.error(`OAuth回调处理失败: ${error.message}`, { stack: error.stack });
    return res.status(500).json({ success: false, message: '身份验证过程中出现错误' });
  }
};

/**
 * 获取OAuth提供商的访问令牌
 * @param {string} provider - OAuth提供商名称
 * @param {string} code - 授权码
 * @param {string} redirectUri - 重定向URI
 * @returns {Object} 包含访问令牌的对象
 */
const getAccessToken = async (provider, code, redirectUri) => {
  try {
    let tokenUrl, params, headers;

    switch (provider) {
      case 'google':
        tokenUrl = 'https://oauth2.googleapis.com/token';
        params = {
          code,
          client_id: config.oauth.google.clientId,
          client_secret: config.oauth.google.clientSecret,
          redirect_uri: redirectUri || config.oauth.google.redirectUri,
          grant_type: 'authorization_code'
        };
        break;

      case 'github':
        tokenUrl = 'https://github.com/login/oauth/access_token';
        params = {
          code,
          client_id: config.oauth.github.clientId,
          client_secret: config.oauth.github.clientSecret,
          redirect_uri: redirectUri || config.oauth.github.redirectUri
        };
        headers = { Accept: 'application/json' };
        break;

      case 'facebook':
        tokenUrl = 'https://graph.facebook.com/v18.0/oauth/access_token';
        params = {
          code,
          client_id: config.oauth.facebook.clientId,
          client_secret: config.oauth.facebook.clientSecret,
          redirect_uri: redirectUri || config.oauth.facebook.redirectUri
        };
        break;

      case 'wechat':
        tokenUrl = 'https://api.weixin.qq.com/sns/oauth2/access_token';
        params = {
          appid: config.oauth.wechat.appId,
          secret: config.oauth.wechat.appSecret,
          code,
          grant_type: 'authorization_code'
        };
        break;
        
      case 'apple':
        tokenUrl = 'https://appleid.apple.com/auth/token';
        params = {
          code,
          client_id: config.oauth.apple.clientId,
          client_secret: config.oauth.apple.clientSecret,
          grant_type: 'authorization_code',
          redirect_uri: redirectUri || config.oauth.apple.redirectUri
        };
        break;

      default:
        throw new Error(`不支持的OAuth提供商: ${provider}`);
    }

    const response = await axios.post(tokenUrl, params, { headers });
    return response.data;
  } catch (error) {
    logger.error(`获取${provider}访问令牌失败: ${error.message}`, { stack: error.stack });
    throw new Error(`获取访问令牌失败: ${error.message}`);
  }
};

/**
 * 从OAuth提供商获取用户信息
 * @param {string} provider - OAuth提供商名称
 * @param {string} accessToken - 访问令牌
 * @returns {Object} 用户信息对象
 */
const getUserInfo = async (provider, accessToken) => {
  try {
    let userInfoUrl, headers, response, userInfo;

    switch (provider) {
      case 'google':
        userInfoUrl = 'https://www.googleapis.com/oauth2/v3/userinfo';
        headers = { Authorization: `Bearer ${accessToken}` };
        response = await axios.get(userInfoUrl, { headers });
        userInfo = {
          id: response.data.sub,
          email: response.data.email,
          firstName: response.data.given_name,
          lastName: response.data.family_name,
          avatar: response.data.picture,
          username: response.data.name
        };
        break;

      case 'github':
        userInfoUrl = 'https://api.github.com/user';
        headers = { Authorization: `token ${accessToken}` };
        response = await axios.get(userInfoUrl, { headers });
        
        // 获取GitHub用户邮箱（如果公开）
        let email = response.data.email;
        if (!email) {
          try {
            const emailsResponse = await axios.get('https://api.github.com/user/emails', { headers });
            const primaryEmail = emailsResponse.data.find(e => e.primary);
            if (primaryEmail) {
              email = primaryEmail.email;
            }
          } catch (err) {
            logger.warn(`无法获取GitHub用户邮箱: ${err.message}`);
          }
        }

        userInfo = {
          id: response.data.id.toString(),
          email: email,
          firstName: '',
          lastName: '',
          avatar: response.data.avatar_url,
          username: response.data.login
        };
        break;

      case 'facebook':
        userInfoUrl = 'https://graph.facebook.com/me?fields=id,email,first_name,last_name,picture';
        headers = { Authorization: `Bearer ${accessToken}` };
        response = await axios.get(userInfoUrl, { headers });
        userInfo = {
          id: response.data.id,
          email: response.data.email,
          firstName: response.data.first_name,
          lastName: response.data.last_name,
          avatar: response.data.picture?.data?.url,
          username: `${response.data.first_name}.${response.data.last_name}`
        };
        break;

      case 'wechat':
        userInfoUrl = `https://api.weixin.qq.com/sns/userinfo?access_token=${accessToken}&openid=${accessToken.openid}`;
        response = await axios.get(userInfoUrl);
        userInfo = {
          id: response.data.openid,
          email: `${response.data.openid}@wechat.user`,
          firstName: response.data.nickname,
          lastName: '',
          avatar: response.data.headimgurl,
          username: response.data.nickname
        };
        break;
        
      case 'apple':
        // Apple 不返回公开用户信息，仅初次授权时由前端提供，需由前端存储并传入
        // Apple不提供标准用户信息接口，依赖前端传递的用户信息
        // 这里我们使用token中的sub作为唯一标识符
        const decodedToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString());
        userInfo = {
          id: decodedToken.sub,
          email: decodedToken.email || `${decodedToken.sub}@privaterelay.appleid.com`,
          firstName: '',
          lastName: '',
          avatar: '',
          username: `apple_${decodedToken.sub.substring(0, 8)}`
        };
        break;

      default:
        throw new Error(`不支持的OAuth提供商: ${provider}`);
    }

    return userInfo;
  } catch (error) {
    logger.error(`获取${provider}用户信息失败: ${error.message}`, { stack: error.stack });
    throw new Error(`获取用户信息失败: ${error.message}`);
  }
};

/**
 * 查找或创建用户
 * @param {string} provider - OAuth提供商名称
 * @param {Object} userInfo - 用户信息对象
 * @returns {Object} 包含用户对象和是否为新用户的标志
 */
const findOrCreateUser = async (provider, userInfo) => {
  try {
    // 查找是否已存在OAuth账号
    let oauthAccount = await OAuthAccount.findOne({
      provider,
      providerId: userInfo.id
    }).populate('user');

    if (oauthAccount && oauthAccount.user) {
      // 更新OAuth账号信息
      oauthAccount.lastUsed = new Date();
      await oauthAccount.save();

      // 更新用户信息
      const user = oauthAccount.user;
      user.lastLogin = new Date();
      
      // 如果用户没有头像但OAuth提供了，则更新
      if (!user.avatar && userInfo.avatar) {
        user.avatar = userInfo.avatar;
      }
      
      await user.save();
      
      return { user, isNewUser: false };
    }

    // 查找是否已有相同邮箱的用户
    let user = null;
    if (userInfo.email) {
      user = await User.findOne({ email: userInfo.email });
    }

    let isNewUser = false;
    
    if (!user) {
      // 创建新用户
      isNewUser = true;
      
      // 生成唯一用户名
      const username = await generateUsername(userInfo.username || userInfo.firstName);
      
      user = new User({
        username,
        email: userInfo.email,
        firstName: userInfo.firstName || '',
        lastName: userInfo.lastName || '',
        avatar: userInfo.avatar || '',
        password: crypto.randomBytes(16).toString('hex'), // 生成随机密码
        hasPassword: false, // 标记为没有设置密码
        registrationMethod: 'oauth',
        status: 'active',
        lastLogin: new Date()
      });
      
      await user.save();
    }

    // 创建OAuth账号绑定
    oauthAccount = new OAuthAccount({
      user: user._id,
      provider,
      providerId: userInfo.id,
      lastUsed: new Date()
    });
    
    await oauthAccount.save();
    
    return { user, isNewUser };
  } catch (error) {
    logger.error(`查找或创建用户失败: ${error.message}`, { stack: error.stack });
    throw new Error(`查找或创建用户失败: ${error.message}`);
  }
};

/**
 * 生成唯一用户名
 * @param {string} baseName - 基础用户名
 * @returns {string} 唯一用户名
 */
const generateUsername = async (baseName) => {
  if (!baseName) {
    baseName = 'user';
  }
  
  // 移除特殊字符，只保留字母、数字和下划线
  const sanitizedName = baseName.replace(/[^\w]/g, '_').toLowerCase();
  
  // 尝试使用原始用户名
  let username = sanitizedName;
  let user = await User.findOne({ username });
  
  // 如果用户名已存在，添加随机后缀
  if (user) {
    username = `${sanitizedName}_${Math.floor(Math.random() * 10000)}`;
    user = await User.findOne({ username });
    
    // 如果仍然存在，使用UUID的一部分
    if (user) {
      username = `${sanitizedName}_${uuidv4().substring(0, 8)}`;
      // 如果生成用户名仍然冲突，建议记录冲突情况（后续可分析用户名生成效率）
    }
  }
  
  return username;
};

/**
 * 解绑OAuth账号
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 响应对象
 */
const unbindOAuth = async (req, res) => {
  try {
    const { provider } = req.params;
    const userId = req.user._id;
    
    // 验证提供商是否有效
    if (!['google', 'github', 'facebook', 'wechat', 'apple'].includes(provider)) {
      return res.status(400).json({ success: false, message: '不支持的OAuth提供商' });
    }
    
    // 检查是否为用户唯一的登录方式
    const oauthCount = await OAuthAccount.countDocuments({ user: userId });
    const user = await User.findById(userId);
    
    if (oauthCount === 1 && !user.hasPassword) {
      return res.status(400).json({ 
        success: false, 
        message: '无法解绑最后一个OAuth账号，请先设置密码' 
      });
    }
    
    // 查找并删除OAuth绑定
    const result = await OAuthAccount.deleteOne({ 
      user: userId,
      provider
    });
    
    if (result.deletedCount === 0) {
      return res.status(404).json({ 
        success: false, 
        message: `未找到与${provider}的绑定` 
      });
    }
    
    return res.status(200).json({ 
      success: true, 
      message: `成功解绑${provider}账号` 
    });
  } catch (error) {
    logger.error(`解绑OAuth账号失败: ${error.message}`, { stack: error.stack });
    return res.status(500).json({ success: false, message: '解绑过程中出现错误' });
  }
};

/**
 * 获取当前用户的OAuth绑定状态
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 响应对象，包含OAuth绑定状态
 */
const getOAuthBindings = async (req, res) => {
  try {
    const userId = req.user._id;
    
    // 获取用户所有OAuth绑定
    const oauthAccounts = await OAuthAccount.find({ user: userId });
    
    // 构建绑定状态
    const bindings = {
      google: false,
      github: false,
      facebook: false,
      wechat: false,
      apple: false
    };
    
    // 更新绑定状态
    oauthAccounts.forEach(account => {
      if (bindings.hasOwnProperty(account.provider)) {
        bindings[account.provider] = true;
      }
    });
    
    return res.status(200).json({ 
      success: true, 
      bindings 
    });
  } catch (error) {
    logger.error(`获取OAuth绑定状态失败: ${error.message}`, { stack: error.stack });
    return res.status(500).json({ success: false, message: '获取绑定状态过程中出现错误' });
  }
};

/**
 * 绑定OAuth账号到现有用户
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 响应对象
 */
const bindOAuth = async (req, res) => {
  try {
    // 验证OAuth登录数据
    const { error, value } = validateOAuthLogin(req.body);
    if (error) {
      return res.status(400).json({ success: false, message: '无效的OAuth请求', errors: error.details });
    }

    const { provider, code, redirectUri } = value;
    const userId = req.user._id;

    // 检查是否已绑定此提供商
    const existingBinding = await OAuthAccount.findOne({ 
      user: userId,
      provider
    });
    
    if (existingBinding) {
      return res.status(400).json({ 
        success: false, 
        message: `您已绑定${provider}账号` 
      });
    }

    // 获取访问令牌
    const tokenData = await getAccessToken(provider, code, redirectUri);
    if (!tokenData || !tokenData.access_token) {
      return res.status(400).json({ success: false, message: '无法获取访问令牌' });
    }

    // 获取用户信息
    const userInfo = await getUserInfo(provider, tokenData.access_token);
    if (!userInfo || !userInfo.id) {
      return res.status(400).json({ success: false, message: '无法获取用户信息' });
    }

    // 检查此OAuth账号是否已被其他用户绑定
    const existingOAuth = await OAuthAccount.findOne({
      provider,
      providerId: userInfo.id
    });
    
    if (existingOAuth) {
      return res.status(400).json({ 
        success: false, 
        message: `此${provider}账号已被其他用户绑定` 
      });
    }

    // 创建新的OAuth绑定
    const oauthAccount = new OAuthAccount({
      user: userId,
      provider,
      providerId: userInfo.id,
      lastUsed: new Date()
    });
    
    await oauthAccount.save();
    
    return res.status(200).json({ 
      success: true, 
      message: `成功绑定${provider}账号` 
    });
  } catch (error) {
    logger.error(`绑定OAuth账号失败: ${error.message}`, { stack: error.stack });
    return res.status(500).json({ success: false, message: '绑定过程中出现错误' });
  }
};

/**
 * 处理OAuth认证请求
 * 生成认证URL并重定向用户
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {void} 重定向到OAuth提供商
 */
const authRequest = async (req, res) => {
  try {
    const { provider } = req.params;
    let authUrl;

    // 根据不同的提供商生成不同的认证URL
    switch (provider) {
      case 'google':
        authUrl = `https://accounts.google.com/o/oauth2/v2/auth?client_id=${config.oauth.google.clientId}&redirect_uri=${encodeURIComponent(config.oauth.google.redirectUri)}&response_type=code&scope=email%20profile&access_type=offline`;
        break;
      case 'github':
        authUrl = `https://github.com/login/oauth/authorize?client_id=${config.oauth.github.clientId}&redirect_uri=${encodeURIComponent(config.oauth.github.redirectUri)}&scope=user:email`;
        break;
      case 'facebook':
        authUrl = `https://www.facebook.com/v18.0/dialog/oauth?client_id=${config.oauth.facebook.clientId}&redirect_uri=${encodeURIComponent(config.oauth.facebook.redirectUri)}&scope=email,public_profile`;
        break;
      case 'wechat':
        authUrl = `https://open.weixin.qq.com/connect/qrconnect?appid=${config.oauth.wechat.appId}&redirect_uri=${encodeURIComponent(config.oauth.wechat.redirectUri)}&response_type=code&scope=snsapi_login#wechat_redirect`;
        break;
      case 'apple':
        authUrl = `https://appleid.apple.com/auth/authorize?client_id=${config.oauth.apple.clientId}&redirect_uri=${encodeURIComponent(config.oauth.apple.redirectUri)}&response_type=code&scope=name%20email&response_mode=form_post`;
        break;
      default:
        return res.status(400).json({ success: false, message: `不支持的OAuth提供商: ${provider}` });
    }

    logger.info(`生成${provider}认证URL，重定向用户`);
    return res.redirect(authUrl);
  } catch (error) {
    logger.error(`OAuth请求处理失败: ${error.message}`, { stack: error.stack });
    return res.status(500).json({ success: false, message: '认证请求处理失败' });
  }
};

module.exports = {
  handleOAuthCallback,
  unbindOAuth,
  getOAuthBindings,
  bindOAuth,
  authRequest
};
