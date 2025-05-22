/**
 * 支付服务配置
 * 定义支付服务提供商和沙箱模式设置
 */

require('dotenv').config();

const paymentConfig = {
  // 支付服务提供商，例如：'alipay'、'wechat'、'stripe'
  vendor: process.env.PAYMENT_VENDOR || 'mock',
  
  // 是否启用沙箱模式（测试环境）
  enableSandbox: process.env.PAYMENT_SANDBOX === 'true',
  
  // 支付超时设置（毫秒）
  timeout: parseInt(process.env.PAYMENT_TIMEOUT || '1800000'), // 默认30分钟
  
  // 支付回调URL
  callbackUrl: process.env.PAYMENT_CALLBACK_URL || 'http://localhost:3000/api/v1/payment/callback',
  
  // 支付通知URL
  notifyUrl: process.env.PAYMENT_NOTIFY_URL || 'http://localhost:3000/api/v1/payment/notify',
  
  // 提供商特定配置
  providers: {
    alipay: {
      appId: process.env.ALIPAY_APP_ID,
      privateKey: process.env.ALIPAY_PRIVATE_KEY,
      publicKey: process.env.ALIPAY_PUBLIC_KEY,
      // 沙箱和生产环境的网关
      gateway: {
        sandbox: 'https://openapi.alipaydev.com/gateway.do',
        production: 'https://openapi.alipay.com/gateway.do'
      }
    },
    wechat: {
      appId: process.env.WECHAT_APP_ID,
      mchId: process.env.WECHAT_MCH_ID,
      apiKey: process.env.WECHAT_API_KEY,
      certificatePath: process.env.WECHAT_CERT_PATH,
      // 沙箱和生产环境的API地址
      apiUrl: {
        sandbox: 'https://api.mch.weixin.qq.com/sandboxnew/',
        production: 'https://api.mch.weixin.qq.com/'
      }
    },
    stripe: {
      secretKey: {
        sandbox: process.env.STRIPE_TEST_SECRET_KEY,
        production: process.env.STRIPE_LIVE_SECRET_KEY
      },
      publishableKey: {
        sandbox: process.env.STRIPE_TEST_PUBLISHABLE_KEY,
        production: process.env.STRIPE_LIVE_PUBLISHABLE_KEY
      },
      webhookSecret: process.env.STRIPE_WEBHOOK_SECRET
    },
    mock: {
      // 模拟支付设置
      simulateDelay: parseInt(process.env.MOCK_PAYMENT_DELAY || '3000'),
      forceSucceed: process.env.MOCK_PAYMENT_SUCCEED !== 'false'
    }
  },
  
  // 退款设置
  refund: {
    allowPartial: process.env.ALLOW_PARTIAL_REFUND !== 'false',
    maxRefundDays: parseInt(process.env.MAX_REFUND_DAYS || '30'),
    automaticApproval: process.env.AUTOMATIC_REFUND_APPROVAL === 'true'
  },
  
  // 支付流程日志设置
  logging: {
    logPaymentFlow: process.env.LOG_PAYMENT_FLOW !== 'false',
    logPaymentDetails: process.env.LOG_PAYMENT_DETAILS === 'true',
    sensitiveDataMask: process.env.MASK_SENSITIVE_DATA !== 'false'
  }
};

module.exports = paymentConfig; 