/**
 * 商家注册Hook
 * 商家注册成功后的处理逻辑
 */

const emailService = require('../../services/messaging/emailService');
const smsService = require('../../services/messaging/smsService');
const notificationService = require('../../services/notification/notificationService');
const logger = require('../../config/modules/logger');

/**
 * 商家注册Hook
 * @param {Object} merchant - 商家数据
 * @param {Object} user - 用户数据
 */
async function onMerchantRegistered(merchant, user) {
  try {
    logger.info('商家注册Hook触发', { 
      merchantId: merchant._id, 
      userId: user._id,
      businessName: merchant.businessName 
    });

    // 1. 发送注册确认邮件
    await sendRegistrationConfirmationEmail(merchant, user);

    // 2. 发送短信通知
    await sendRegistrationConfirmationSMS(merchant);

    // 3. 创建系统通知
    await createRegistrationNotification(merchant, user);

    // 4. 通知管理员新商家
    await notifyAdminNewMerchant(merchant);

    // 5. 初始化商家默认设置
    await initializeMerchantDefaults(merchant);

    logger.info('商家注册Hook完成', { merchantId: merchant._id });

  } catch (error) {
    logger.error('商家注册Hook失败', { 
      error, 
      merchantId: merchant._id,
      userId: user._id 
    });
    // Hook失败不应该影响主流程
  }
}

/**
 * 发送注册确认邮件
 */
async function sendRegistrationConfirmationEmail(merchant, user) {
  try {
    const emailTemplate = {
      to: merchant.contact.email,
      subject: '商家申请提交成功 - 智能营养餐厅',
      template: 'merchant-registration-confirmation',
      data: {
        businessName: merchant.businessName,
        userName: user.username,
        submissionTime: new Date().toLocaleString('zh-CN'),
        estimatedReviewTime: '1-3个工作日',
        contactSupport: 'support@nutrition-restaurant.com'
      }
    };

    await emailService.sendEmail(emailTemplate);
    logger.info('商家注册确认邮件发送成功', { 
      merchantId: merchant._id, 
      email: merchant.contact.email 
    });

  } catch (error) {
    logger.error('发送注册确认邮件失败', { error, merchantId: merchant._id });
  }
}

/**
 * 发送短信通知
 */
async function sendRegistrationConfirmationSMS(merchant) {
  try {
    const message = `智能营养餐厅：
您的"${merchant.businessName}"商家申请已提交，预计1-3个工作日内审核完成，请耐心等待。`;
    
    await smsService.sendSms(merchant.contact.phone, message, {
      template: 'MERCHANT_REGISTRATION'
    });

    logger.info('商家注册短信发送成功', { 
      merchantId: merchant._id, 
      phone: merchant.contact.phone 
    });

  } catch (error) {
    logger.error('发送短信通知失败', { error, merchantId: merchant._id });
  }
}

/**
 * 创建系统通知
 */
async function createRegistrationNotification(merchant, user) {
  try {
    await notificationService.createNotification({
      userId: user._id,
      type: 'merchant_registration',
      title: '商家申请已提交',
      content: `您的商家"${merchant.businessName}"申请已提交，预计1-3个工作日内审核完成`,
      data: {
        merchantId: merchant._id,
        businessName: merchant.businessName,
        status: 'pending'
      }
    });

    logger.info('商家注册系统通知创建成功', { merchantId: merchant._id });

  } catch (error) {
    logger.error('创建系统通知失败', { error, merchantId: merchant._id });
  }
}

/**
 * 通知管理员新商家
 */
async function notifyAdminNewMerchant(merchant) {
  try {
    // 发送给管理员
    const adminEmail = process.env.ADMIN_EMAIL || 'admin@nutrition-restaurant.com';
    
    await emailService.sendEmail({
      to: adminEmail,
      subject: '新商家申请待审核',
      template: 'admin-new-merchant-notification',
      data: {
        businessName: merchant.businessName,
        businessType: merchant.businessType,
        contactEmail: merchant.contact.email,
        contactPhone: merchant.contact.phone,
        city: merchant.address.city,
        province: merchant.address.province,
        submissionTime: new Date().toLocaleString('zh-CN'),
        merchantId: merchant._id,
        adminUrl: `${process.env.ADMIN_URL}/merchants/pending`
      }
    });

    logger.info('管理员商家申请通知发送成功', { merchantId: merchant._id });

  } catch (error) {
    logger.error('发送管理员通知失败', { error, merchantId: merchant._id });
  }
}

/**
 * 初始化商家默认设置
 */
async function initializeMerchantDefaults(merchant) {
  try {
    // 这里可以添加默认设置初始化
    // 比如默认菜单分类、基础配置等
    
    logger.info('商家默认设置初始化完成', { merchantId: merchant._id });

  } catch (error) {
    logger.error('初始化商家默认设置失败', { error, merchantId: merchant._id });
  }
}

module.exports = onMerchantRegistered;