/**
 * OAuth认证路由
 * 处理第三方登录认证流程
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/user/oauthController');

/** TODO: 添加具体的路由逻辑 */
router.get('/:provider', controller.authRequest); // OAuth认证请求
router.get('/:provider/callback', controller.handleOAuthCallback); // OAuth回调处理

module.exports = router;
