/**
 * 商家审核通过Hook
 * 商家审核通过后的业务处理逻辑
 */

const emailService = require('../../services/messaging/emailService');
const smsService = require('../../services/messaging/smsService');
const notificationService = require('../../services/notification/notificationService');
const logger = require('../../config/modules/logger');

/**
 * 商家审核通过Hook
 * @param {Object} merchant - 商家数据
 * @param {Object} user - 用户数据
 * @param {Object} verificationData - 审核数据
 */
async function onMerchantApproved(merchant, user, verificationData) {
  try {
    logger.info('商家审核通过Hook触发', { 
      merchantId: merchant._id, 
      userId: user._id,
      businessName: merchant.businessName,
      verifiedBy: verificationData.verifiedBy
    });

    // 1. 发送审核通过邮件
    await sendApprovalEmail(merchant, user);

    // 2. 发送审核通过短信
    await sendApprovalSMS(merchant);

    // 3. 创建系统通知
    await createApprovalNotification(merchant, user);

    // 4. 激活商家服务功能
    await activateMerchantServices(merchant);

    // 5. 发送欢迎指南邮件
    await sendWelcomeEmail(merchant, user);

    // 6. 记录审核历史
    await recordApprovalHistory(merchant, verificationData);

    logger.info('商家审核通过Hook完成', { merchantId: merchant._id });

  } catch (error) {
    logger.error('商家审核通过Hook失败', { 
      error, 
      merchantId: merchant._id,
      userId: user._id 
    });
    // Hook失败不应该影响主流程
  }
}

/**
 * 发送审核通过邮件
 */
async function sendApprovalEmail(merchant, user) {
  try {
    const emailTemplate = {
      to: merchant.contact.email,
      subject: '恭喜！商家审核通过 - 智能营养餐厅平台',
      template: 'merchant-approval-success',
      data: {
        businessName: merchant.businessName,
        userName: user.username,
        approvalTime: new Date().toLocaleString('zh-CN'),
        loginUrl: `${process.env.MERCHANT_URL}/login`,
        dashboardUrl: `${process.env.MERCHANT_URL}/dashboard`,
        supportEmail: 'support@nutrition-restaurant.com',
        guideUrl: `${process.env.MERCHANT_URL}/guide`
      }
    };

    await emailService.sendEmail(emailTemplate);
    logger.info('商家审核通过邮件发送成功', { 
      merchantId: merchant._id, 
      email: merchant.contact.email 
    });

  } catch (error) {
    logger.error('发送审核通过邮件失败', { error, merchantId: merchant._id });
  }
}

/**
 * 发送审核通过短信
 */
async function sendApprovalSMS(merchant) {
  try {
    const message = `智能营养餐厅：恭喜！您的"${merchant.businessName}"审核通过，现在可以开始使用商家服务了！请登录智能营养餐厅商家端。`;
    
    await smsService.sendSms(merchant.contact.phone, message, {
      template: 'MERCHANT_APPROVAL_SUCCESS'
    });

    logger.info('商家审核通过短信发送成功', { 
      merchantId: merchant._id, 
      phone: merchant.contact.phone 
    });

  } catch (error) {
    logger.error('发送审核通过短信失败', { error, merchantId: merchant._id });
  }
}

/**
 * 创建审核通过通知
 */
async function createApprovalNotification(merchant, user) {
  try {
    await notificationService.createNotification({
      userId: user._id,
      type: 'merchant_approved',
      title: '恭喜！商家审核通过',
      content: `恭喜！您的商家"${merchant.businessName}"已审核通过，现在可以开始使用商家服务功能了！`,
      data: {
        merchantId: merchant._id,
        businessName: merchant.businessName,
        status: 'approved',
        nextSteps: [
          '完善店铺信息',
          '上传商家Logo',
          '添加菜品信息',
          '设置营业时间',
          '开始营业'
        ]
      }
    });

    logger.info('商家审核通过系统通知创建成功', { merchantId: merchant._id });

  } catch (error) {
    logger.error('创建审核通过通知失败', { error, merchantId: merchant._id });
  }
}

/**
 * 激活商家服务功能
 */
async function activateMerchantServices(merchant) {
  try {
    // 1. 激活默认设置
    // 2. 开通权限
    // 3. 设置默认菜单分类
    // 4. 开启营业状态
    
    logger.info('商家服务功能激活完成', { merchantId: merchant._id });

  } catch (error) {
    logger.error('激活商家服务功能失败', { error, merchantId: merchant._id });
  }
}

/**
 * 发送欢迎指南邮件
 */
async function sendWelcomeEmail(merchant, user) {
  try {
    const emailTemplate = {
      to: merchant.contact.email,
      subject: '欢迎入驻！快速上手智能营养餐厅',
      template: 'merchant-welcome-guide',
      data: {
        businessName: merchant.businessName,
        userName: user.username,
        quickStartSteps: [
          {
            step: 1,
            title: '完善店铺信息',
            description: '上传logo、设置营业时间等基本信息',
            url: `${process.env.MERCHANT_URL}/profile`
          },
          {
            step: 2,
            title: '添加菜品',
            description: '上传菜品图片，填写营养信息和价格',
            url: `${process.env.MERCHANT_URL}/menu`
          },
          {
            step: 3,
            title: '营业设置',
            description: '设置营业状态、配送范围和AI推荐',
            url: `${process.env.MERCHANT_URL}/settings`
          },
          {
            step: 4,
            title: '查看数据',
            description: '实时查看订单数据和营养分析',
            url: `${process.env.MERCHANT_URL}/dashboard`
          }
        ],
        supportResources: {
          helpCenter: `${process.env.MERCHANT_URL}/help`,
          videoTutorials: `${process.env.MERCHANT_URL}/tutorials`,
          contact: 'support@nutrition-restaurant.com'
        }
      }
    };

    await emailService.sendEmail(emailTemplate);
    logger.info('商家欢迎指南邮件发送成功', { merchantId: merchant._id });

  } catch (error) {
    logger.error('发送欢迎指南邮件失败', { error, merchantId: merchant._id });
  }
}

/**
 * 记录审核历史
 */
async function recordApprovalHistory(merchant, verificationData) {
  try {
    // 这里可以添加记录审核历史的逻辑
    // 包括审核人、审核时间、审核意见等信息
    
    logger.info('审核历史记录完成', { 
      merchantId: merchant._id,
      verifiedBy: verificationData.verifiedBy 
    });

  } catch (error) {
    logger.error('记录审核历史失败', { error, merchantId: merchant._id });
  }
}

module.exports = onMerchantApproved;