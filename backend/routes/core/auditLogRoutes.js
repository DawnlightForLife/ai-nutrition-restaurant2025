const express = require('express');
const router = express.Router();
const { createAuditLog, getAuditLogList, getAuditLogById, updateAuditLog, deleteAuditLog } = require('../../controllers/core/auditLogController');

/**
 * 审计日志 API 路由模块
 * 提供创建、查询、更新和删除审计日志的接口
 */

// [POST] 创建审计日志
router.post('/', createAuditLog);

// [GET] 获取审计日志列表
router.get('/', getAuditLogList);

// [GET] 获取指定 ID 的审计日志
router.get('/:id', getAuditLogById);

// [PUT] 更新指定 ID 的审计日志
router.put('/:id', updateAuditLog);

// [DELETE] 删除指定 ID 的审计日志
router.delete('/:id', deleteAuditLog);

module.exports = router;
