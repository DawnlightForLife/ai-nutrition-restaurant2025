/**
 * 短信服务配置
 * 定义短信服务提供商和测试模式设置
 */

require('dotenv').config();

const smsConfig = {
  // 短信服务提供商，例如：'aliyun'、'tencent'、'twilio'
  vendor: process.env.SMS_VENDOR || 'mock',
  
  // 是否启用模拟模式（不实际发送短信，用于开发和测试）
  mockMode: process.env.SMS_MOCK_MODE === 'true',
  
  // 短信发送配置
  sendConfig: {
    retryTimes: parseInt(process.env.SMS_RETRY_TIMES || '3'),
    retryInterval: parseInt(process.env.SMS_RETRY_INTERVAL || '1000'),
    timeout: parseInt(process.env.SMS_TIMEOUT || '5000')
  },
  
  // 短信验证码配置
  verificationCode: {
    length: parseInt(process.env.SMS_CODE_LENGTH || '6'),
    expireTime: parseInt(process.env.SMS_CODE_EXPIRE_TIME || '300'), // 默认5分钟
    dailyLimit: parseInt(process.env.SMS_DAILY_LIMIT || '20') // 单用户每日发送上限
  },
  
  // 提供商特定配置
  providers: {
    aliyun: {
      accessKeyId: process.env.ALIYUN_ACCESS_KEY_ID,
      accessKeySecret: process.env.ALIYUN_ACCESS_KEY_SECRET,
      signName: process.env.ALIYUN_SMS_SIGN_NAME,
      templateCode: process.env.ALIYUN_SMS_TEMPLATE_CODE
    },
    tencent: {
      secretId: process.env.TENCENT_SECRET_ID,
      secretKey: process.env.TENCENT_SECRET_KEY,
      appId: process.env.TENCENT_SMS_APP_ID,
      sign: process.env.TENCENT_SMS_SIGN,
      templateId: process.env.TENCENT_SMS_TEMPLATE_ID
    },
    twilio: {
      accountSid: process.env.TWILIO_ACCOUNT_SID,
      authToken: process.env.TWILIO_AUTH_TOKEN,
      phoneNumber: process.env.TWILIO_PHONE_NUMBER
    },
    mock: {
      outputToConsole: true
    }
  }
};

module.exports = smsConfig; 