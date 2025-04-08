const express = require('express');
const router = express.Router();
const { createAuditLog, getAuditLogList, getAuditLogById, updateAuditLog, deleteAuditLog } = require('../../controllers/audit/auditLogController');

/**
 * 审计日志相关路由
 */

// 创建审计日志
router.post('/', createAuditLog);

// 获取审计日志列表
router.get('/', getAuditLogList);

// 获取单个审计日志详情
router.get('/:id', getAuditLogById);

// 更新审计日志
router.put('/:id', updateAuditLog);

// 删除审计日志
router.delete('/:id', deleteAuditLog);

module.exports = router;
