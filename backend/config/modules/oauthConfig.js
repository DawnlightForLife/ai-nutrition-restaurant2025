/**
 * OAuth配置文件
 * 包含各个OAuth提供商的配置信息
 */

require('dotenv').config();

/**
 * 获取环境变量，带默认值
 * @param {string} key - 环境变量的键
 * @param {string} defaultValue - 默认值
 * @returns {string} - 环境变量的值或默认值
 */
const getEnv = (key, defaultValue = '') => {
  return process.env[key] || defaultValue;
};

// OAuth提供商配置
const oauthConfig = {
  // Google OAuth配置
  google: {
    clientId: getEnv('GOOGLE_CLIENT_ID'),
    clientSecret: getEnv('GOOGLE_CLIENT_SECRET'),
    redirectUri: getEnv('GOOGLE_REDIRECT_URI', 'http://localhost:3000/auth/google/callback'),
    tokenUrl: 'https://oauth2.googleapis.com/token',
    userInfoUrl: 'https://www.googleapis.com/oauth2/v3/userinfo',
    authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
    scope: 'profile email',
    responseType: 'code',
    grantType: 'authorization_code',
    isActive: getEnv('GOOGLE_OAUTH_ACTIVE', 'false') === 'true'
  },
  
  // GitHub OAuth配置
  github: {
    clientId: getEnv('GITHUB_CLIENT_ID'),
    clientSecret: getEnv('GITHUB_CLIENT_SECRET'),
    redirectUri: getEnv('GITHUB_REDIRECT_URI', 'http://localhost:3000/auth/github/callback'),
    tokenUrl: 'https://github.com/login/oauth/access_token',
    userInfoUrl: 'https://api.github.com/user',
    authUrl: 'https://github.com/login/oauth/authorize',
    scope: 'user:email',
    responseType: 'code',
    grantType: 'authorization_code',
    isActive: getEnv('GITHUB_OAUTH_ACTIVE', 'false') === 'true'
  },
  
  // Facebook OAuth配置
  facebook: {
    clientId: getEnv('FACEBOOK_CLIENT_ID'),
    clientSecret: getEnv('FACEBOOK_CLIENT_SECRET'),
    redirectUri: getEnv('FACEBOOK_REDIRECT_URI', 'http://localhost:3000/auth/facebook/callback'),
    tokenUrl: 'https://graph.facebook.com/v14.0/oauth/access_token',
    userInfoUrl: 'https://graph.facebook.com/me?fields=id,name,email,first_name,last_name,picture',
    authUrl: 'https://www.facebook.com/v14.0/dialog/oauth',
    scope: 'email,public_profile',
    responseType: 'code',
    grantType: 'authorization_code',
    isActive: getEnv('FACEBOOK_OAUTH_ACTIVE', 'false') === 'true'
  },
  
  // 微信OAuth配置
  wechat: {
    clientId: getEnv('WECHAT_APP_ID'),
    clientSecret: getEnv('WECHAT_APP_SECRET'),
    redirectUri: getEnv('WECHAT_REDIRECT_URI', 'http://localhost:3000/auth/wechat/callback'),
    tokenUrl: 'https://api.weixin.qq.com/sns/oauth2/access_token',
    userInfoUrl: 'https://api.weixin.qq.com/sns/userinfo',
    authUrl: 'https://open.weixin.qq.com/connect/qrconnect',
    scope: 'snsapi_login',
    responseType: 'code',
    grantType: 'authorization_code',
    isActive: getEnv('WECHAT_OAUTH_ACTIVE', 'true') === 'true'
  },
  
  // 苹果OAuth配置
  apple: {
    clientId: getEnv('APPLE_CLIENT_ID'),
    clientSecret: getEnv('APPLE_CLIENT_SECRET'),
    teamId: getEnv('APPLE_TEAM_ID'),
    keyId: getEnv('APPLE_KEY_ID'),
    privateKeyLocation: getEnv('APPLE_PRIVATE_KEY_LOCATION'),
    redirectUri: getEnv('APPLE_REDIRECT_URI', 'http://localhost:3000/auth/apple/callback'),
    tokenUrl: 'https://appleid.apple.com/auth/token',
    authUrl: 'https://appleid.apple.com/auth/authorize',
    scope: 'name email',
    responseType: 'code',
    grantType: 'authorization_code',
    isActive: getEnv('APPLE_OAUTH_ACTIVE', 'false') === 'true'
  }
};

/**
 * 获取激活的OAuth提供商列表
 * @returns {Object} - 激活的OAuth提供商配置对象
 */
const getActiveProviders = () => {
  const activeProviders = {};
  Object.keys(oauthConfig).forEach(provider => {
    if (oauthConfig[provider].isActive) {
      activeProviders[provider] = {
        clientId: oauthConfig[provider].clientId,
        authUrl: oauthConfig[provider].authUrl,
        redirectUri: oauthConfig[provider].redirectUri,
        scope: oauthConfig[provider].scope,
        responseType: oauthConfig[provider].responseType
      };
    }
  });
  return activeProviders;
};

// 添加获取激活提供商的方法
oauthConfig.getActiveProviders = getActiveProviders;

module.exports = oauthConfig; 