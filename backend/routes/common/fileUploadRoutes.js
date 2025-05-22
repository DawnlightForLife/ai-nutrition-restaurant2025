/**
 * 文件上传路由
 * 处理系统文件上传的相关操作
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/common/fileUploadController');

/** TODO: 添加文件上传中间件 */
router.post('/', controller.uploadFile); // 上传文件
router.get('/', controller.getFileList); // 获取文件列表

module.exports = router;
