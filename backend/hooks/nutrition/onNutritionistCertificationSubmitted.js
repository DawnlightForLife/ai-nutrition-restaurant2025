const logger = require('../../config/modules/logger');
const notificationService = require('../../services/notification/notificationService');
const smsService = require('../../services/messaging/smsService');

/**
 * 营养师认证申请提交后的钩子
 * 当营养师提交认证申请时触发
 */
const onNutritionistCertificationSubmitted = async (certificationData) => {
  try {
    logger.info('营养师认证申请提交钩子触发:', { 
      applicationId: certificationData._id,
      userId: certificationData.userId,
      certificationLevel: certificationData.certificationLevel
    });

    // 1. 发送系统通知给申请人（增加超时控制）
    try {
      const notificationPromise = notificationService.createNotification({
        userId: certificationData.userId,
        type: 'certification_submitted',
        title: '认证申请已提交',
        content: `您的营养师认证申请已成功提交，我们将在3-5个工作日内完成审核。`,
        metadata: {
          applicationId: certificationData._id.toString(),
          certificationLevel: certificationData.certificationLevel || 'unknown',
          submittedAt: new Date()
        }
      });
      
      // 设置3秒超时
      await Promise.race([
        notificationPromise,
        new Promise((_, reject) => setTimeout(() => reject(new Error('Notification timeout')), 3000))
      ]);
    } catch (notificationError) {
      logger.warn('发送认证申请提交通知失败:', notificationError.message || notificationError);
    }

    // 2. 发送短信通知给申请人（增加超时控制）
    if (certificationData.personalInfo && certificationData.personalInfo.phone) {
      try {
        const smsPromise = smsService.sendSms(
          certificationData.personalInfo.phone,
          `您的营养师认证申请已提交成功，申请编号：${certificationData._id.toString().slice(-8).toUpperCase()}。我们将在3-5个工作日内完成审核，请耐心等待。`
        );
        
        // 设置5秒超时
        await Promise.race([
          smsPromise,
          new Promise((_, reject) => setTimeout(() => reject(new Error('SMS timeout')), 5000))
        ]);
      } catch (smsError) {
        logger.warn('发送认证申请提交短信失败:', smsError.message || smsError);
      }
    }

    // 3. 通知管理员有新的认证申请待审核
    const adminNotificationData = {
      type: 'new_certification_application',
      title: '新的营养师认证申请',
      content: `收到新的${certificationData.certificationLevel}认证申请，申请人：${certificationData.personalInfo?.name || '未知'}`,
      metadata: {
        applicationId: certificationData._id.toString(),
        applicantName: certificationData.personalInfo?.name,
        certificationLevel: certificationData.certificationLevel,
        specialization: certificationData.specialization,
        submittedAt: new Date()
      }
    };

    try {
      const adminNotificationPromise = notificationService.notifyAdmins(adminNotificationData);
      
      // 设置3秒超时
      await Promise.race([
        adminNotificationPromise,
        new Promise((_, reject) => setTimeout(() => reject(new Error('Admin notification timeout')), 3000))
      ]);
    } catch (adminNotificationError) {
      logger.warn('发送管理员通知失败:', adminNotificationError.message || adminNotificationError);
    }

    logger.info('营养师认证申请提交钩子执行完成:', { applicationId: certificationData._id });

  } catch (error) {
    logger.error('营养师认证申请提交钩子执行失败:', error);
    // 钩子失败不应影响主业务流程，记录错误即可
  }
};

module.exports = onNutritionistCertificationSubmitted;