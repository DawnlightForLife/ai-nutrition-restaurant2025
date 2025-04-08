const nodemailer = require('nodemailer');
const config = require('../../config');

// 创建邮件传输器
const transporter = nodemailer.createTransport({
  host: config.email.host,
  port: config.email.port,
  secure: config.email.secure,
  auth: {
    user: config.email.user,
    pass: config.email.password
  }
});

/**
 * 发送验证邮件
 * @param {string} email - 收件人邮箱
 * @param {string} verificationCode - 验证码
 * @returns {Promise<void>}
 */
const sendVerificationEmail = async (email, verificationCode) => {
  const mailOptions = {
    from: config.email.from,
    to: email,
    subject: '验证您的账号 - AI营养餐厅',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #333;">欢迎加入AI营养餐厅！</h2>
        <p>感谢您注册我们的服务。请使用以下验证码完成您的注册：</p>
        <div style="background-color: #f5f5f5; padding: 15px; text-align: center; margin: 20px 0;">
          <h1 style="color: #4CAF50; margin: 0;">${verificationCode}</h1>
        </div>
        <p>此验证码将在30分钟后过期。</p>
        <p>如果这不是您的操作，请忽略此邮件。</p>
        <hr style="border: 1px solid #eee; margin: 20px 0;">
        <p style="color: #666; font-size: 12px;">
          此邮件由系统自动发送，请勿回复。
        </p>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('发送验证邮件失败:', error);
    throw new Error('发送验证邮件失败');
  }
};

/**
 * 发送密码重置邮件
 * @param {string} email - 收件人邮箱
 * @param {string} resetToken - 重置令牌
 * @returns {Promise<void>}
 */
const sendPasswordResetEmail = async (email, resetToken) => {
  const resetUrl = `${config.app.frontendUrl}/reset-password?token=${resetToken}`;
  
  const mailOptions = {
    from: config.email.from,
    to: email,
    subject: '重置密码 - AI营养餐厅',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #333;">密码重置请求</h2>
        <p>我们收到了您的密码重置请求。请点击下面的链接重置您的密码：</p>
        <div style="text-align: center; margin: 20px 0;">
          <a href="${resetUrl}" 
             style="background-color: #4CAF50; color: white; padding: 12px 24px; 
                    text-decoration: none; border-radius: 4px; display: inline-block;">
            重置密码
          </a>
        </div>
        <p>此链接将在1小时后过期。</p>
        <p>如果这不是您的操作，请忽略此邮件。</p>
        <hr style="border: 1px solid #eee; margin: 20px 0;">
        <p style="color: #666; font-size: 12px;">
          此邮件由系统自动发送，请勿回复。
        </p>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('发送密码重置邮件失败:', error);
    throw new Error('发送密码重置邮件失败');
  }
};

module.exports = {
  sendVerificationEmail,
  sendPasswordResetEmail
}; 