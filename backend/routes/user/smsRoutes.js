/**
 * SMS短信服务路由
 * 处理短信验证码发送（已取消独立验证接口，验证整合入登录流程）
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/user/smsController');

/** TODO: 添加具体的路由逻辑 */
router.post('/send', controller.createSms); // 发送短信

module.exports = router;
