const logger = require('../../config/modules/logger');
const notificationService = require('../../services/notification/notificationService');
const smsService = require('../../services/messaging/smsService');

/**
 * 营养师认证过期提醒钩子
 * 当营养师认证即将过期或已过期时触发
 */
const onNutritionistCertificationExpired = async (certificationData, expiryType) => {
  try {
    logger.info('营养师认证过期提醒钩子触发:', { 
      applicationId: certificationData._id,
      userId: certificationData.userId,
      expiryType, // 'warning' | 'expired'
      expiryDate: certificationData.certificationInfo?.expiryDate
    });

    let notificationTitle, notificationContent, smsContent;

    // 根据过期类型生成不同的通知内容
    switch (expiryType) {
      case 'warning':
        // 30天内过期提醒
        const daysLeft = Math.ceil((new Date(certificationData.certificationInfo?.expiryDate) - new Date()) / (1000 * 60 * 60 * 24));
        notificationTitle = '⚠️ 认证即将过期';
        notificationContent = `您的${certificationData.certificationLevel}认证将在${daysLeft}天后过期（${new Date(certificationData.certificationInfo?.expiryDate).toLocaleDateString()}）。请及时申请续期以保持认证有效性。`;
        smsContent = `您的营养师认证将在${daysLeft}天后过期，请及时申请续期以保持认证有效性。`;
        break;
      
      case 'expired':
        notificationTitle = '❌ 认证已过期';
        notificationContent = `您的${certificationData.certificationLevel}认证已于${new Date(certificationData.certificationInfo?.expiryDate).toLocaleDateString()}过期。请尽快申请续期以恢复认证状态。`;
        smsContent = `您的营养师认证已过期，请尽快申请续期以恢复认证状态。`;
        break;
      
      default:
        logger.warn('未知的过期类型:', expiryType);
        return;
    }

    // 1. 发送系统通知给营养师
    await notificationService.createNotification({
      userId: certificationData.userId,
      type: `certification_${expiryType}`,
      title: notificationTitle,
      content: notificationContent,
      metadata: {
        applicationId: certificationData._id.toString(),
        certificationLevel: certificationData.certificationLevel,
        expiryDate: certificationData.certificationInfo?.expiryDate,
        expiryType,
        notifiedAt: new Date()
      }
    });

    // 2. 发送短信通知给营养师
    if (certificationData.personalInfo && certificationData.personalInfo.phone) {
      try {
        await smsService.sendSms(
          certificationData.personalInfo.phone,
          smsContent
        );
      } catch (smsError) {
        logger.warn('发送认证过期提醒短信失败:', smsError);
      }
    }

    // 3. 如果已过期，通知管理员
    if (expiryType === 'expired') {
      const adminNotificationData = {
        type: 'certification_expired',
        title: '营养师认证已过期',
        content: `营养师${certificationData.personalInfo?.name || '未知'}的${certificationData.certificationLevel}认证已过期，请关注其续期申请。`,
        metadata: {
          applicationId: certificationData._id.toString(),
          nutritionistName: certificationData.personalInfo?.name,
          certificationLevel: certificationData.certificationLevel,
          expiryDate: certificationData.certificationInfo?.expiryDate,
          expiredAt: new Date()
        }
      };

      await notificationService.notifyAdmins(adminNotificationData);
    }

    // 4. 如果认证已过期，暂停营养师服务权限
    if (expiryType === 'expired') {
      // 这里可以调用用户服务来更新营养师的服务状态
      // 例如：await userService.updateNutritionistStatus(certificationData.userId, 'suspended');
      logger.info('营养师认证已过期，需要暂停服务权限:', { 
        userId: certificationData.userId,
        applicationId: certificationData._id 
      });
    }

    logger.info('营养师认证过期提醒钩子执行完成:', { 
      applicationId: certificationData._id, 
      expiryType 
    });

  } catch (error) {
    logger.error('营养师认证过期提醒钩子执行失败:', error);
    // 钩子失败不应影响主业务流程，记录错误即可
  }
};

module.exports = onNutritionistCertificationExpired;