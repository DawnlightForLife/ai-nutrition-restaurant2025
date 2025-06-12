const logger = require('../../config/modules/logger');
const notificationService = require('../../services/notification/notificationService');
const smsService = require('../../services/messaging/smsService');

/**
 * 营养师认证审核完成后的钩子
 * 当管理员完成认证申请审核时触发
 */
const onNutritionistCertificationReviewed = async (certificationData, reviewResult) => {
  try {
    logger.info('营养师认证审核完成钩子触发:', { 
      applicationId: certificationData._id,
      userId: certificationData.userId,
      decision: reviewResult.decision,
      reviewerId: reviewResult.reviewerId
    });

    const { decision, reviewNotes } = reviewResult;
    let notificationTitle, notificationContent, smsContent;

    // 根据审核结果生成不同的通知内容
    switch (decision) {
      case 'approved':
        notificationTitle = '🎉 认证申请已通过';
        notificationContent = `恭喜您！您的${certificationData.certificationLevel}认证申请已通过审核。您现在可以开始提供专业的营养咨询服务。`;
        smsContent = `恭喜！您的营养师认证申请已通过审核。认证级别：${certificationData.certificationLevel}。您现在可以开始提供专业服务。`;
        break;
      
      case 'rejected':
        notificationTitle = '❌ 认证申请未通过';
        notificationContent = `很遗憾，您的${certificationData.certificationLevel}认证申请未通过审核。${reviewNotes ? `审核意见：${reviewNotes}` : ''}请根据反馈完善材料后重新申请。`;
        smsContent = `您的营养师认证申请未通过审核。${reviewNotes ? `原因：${reviewNotes.substring(0, 30)}` : ''}请完善材料后重新申请。`;
        break;
      
      case 'needsRevision':
        notificationTitle = '📝 认证申请需要补充材料';
        notificationContent = `您的${certificationData.certificationLevel}认证申请需要补充材料。${reviewNotes ? `具体要求：${reviewNotes}` : ''}请尽快完善后重新提交。`;
        smsContent = `您的营养师认证申请需要补充材料。${reviewNotes ? `要求：${reviewNotes.substring(0, 30)}` : ''}请尽快完善。`;
        break;
      
      default:
        logger.warn('未知的审核结果:', decision);
        return;
    }

    // 1. 发送系统通知给申请人
    await notificationService.createNotification({
      userId: certificationData.userId,
      type: `certification_${decision}`,
      title: notificationTitle,
      content: notificationContent,
      metadata: {
        applicationId: certificationData._id.toString(),
        certificationLevel: certificationData.certificationLevel,
        decision,
        reviewNotes,
        reviewedAt: new Date(),
        reviewerId: reviewResult.reviewerId
      }
    });

    // 2. 发送短信通知给申请人
    if (certificationData.personalInfo && certificationData.personalInfo.phone) {
      try {
        await smsService.sendSms(
          certificationData.personalInfo.phone,
          smsContent
        );
      } catch (smsError) {
        logger.warn('发送认证审核结果短信失败:', smsError);
      }
    }

    // 3. 如果是通过审核，发送欢迎通知
    if (decision === 'approved') {
      setTimeout(async () => {
        try {
          await notificationService.createNotification({
            userId: certificationData.userId,
            type: 'certification_welcome',
            title: '欢迎加入营养师团队',
            content: '欢迎您正式加入我们的营养师团队！您可以在个人中心查看认证证书，开始为用户提供专业的营养咨询服务。',
            metadata: {
              applicationId: certificationData._id.toString(),
              certificationLevel: certificationData.certificationLevel,
              welcomeAt: new Date()
            }
          });
        } catch (welcomeError) {
          logger.warn('发送欢迎通知失败:', welcomeError);
        }
      }, 5000); // 5秒后发送欢迎通知
    }

    // 4. 通知相关管理员审核结果
    const adminNotificationData = {
      type: 'certification_review_completed',
      title: '认证审核已完成',
      content: `${certificationData.personalInfo?.name || '未知申请人'}的${certificationData.certificationLevel}认证申请审核已完成，结果：${decision === 'approved' ? '通过' : decision === 'rejected' ? '拒绝' : '需要修改'}`,
      metadata: {
        applicationId: certificationData._id.toString(),
        applicantName: certificationData.personalInfo?.name,
        certificationLevel: certificationData.certificationLevel,
        decision,
        reviewerId: reviewResult.reviewerId,
        reviewedAt: new Date()
      }
    };

    await notificationService.notifyAdmins(adminNotificationData);

    logger.info('营养师认证审核完成钩子执行完成:', { 
      applicationId: certificationData._id, 
      decision 
    });

  } catch (error) {
    logger.error('营养师认证审核完成钩子执行失败:', error);
    // 钩子失败不应影响主业务流程，记录错误即可
  }
};

module.exports = onNutritionistCertificationReviewed;