const express = require('express');
const router = express.Router();
const { authenticate } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');
const workbenchController = require('../../controllers/nutritionist/workbenchController');

// 应用认证和角色验证中间件
router.use(authenticate);
router.use(requireRole(['nutritionist']));

// 工作台统计数据
router.get('/dashboard/stats', workbenchController.getDashboardStats);

// 待办任务
router.get('/dashboard/tasks', workbenchController.getTasks);

// 营养师视角的咨询列表
router.get('/consultations', workbenchController.getConsultations);

// 咨询操作
router.put('/consultations/:id/accept', workbenchController.acceptConsultation);
router.put('/consultations/:id/reject', workbenchController.rejectConsultation);
router.put('/consultations/:id/complete', workbenchController.completeConsultation);

// 排班管理
router.get('/schedule', workbenchController.getSchedule);
router.put('/schedule', workbenchController.updateSchedule);

// 收入明细
router.get('/income/details', workbenchController.getIncomeDetails);

// 客户批量操作
router.post('/clients/batch-message', workbenchController.sendBatchMessage);

// 工作台快捷操作
router.get('/quick-actions', workbenchController.getQuickActions);

// 切换在线状态
router.post('/toggle-online-status', workbenchController.toggleOnlineStatus);

// 更新可用状态
router.put('/availability', workbenchController.updateAvailability);

module.exports = router;