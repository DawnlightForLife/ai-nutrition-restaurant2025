/**
 * 访问轨迹追踪API路由
 * @module routes/security/accessTrackRoutes
 */

const express = require('express');
const router = express.Router();
const { getAccessTrackingService } = require('../../middleware/access/accessTrackingMiddleware');
const AccessTrack = require('../../models/security/accessTrackModel');
const authMiddleware = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
const requireRole = roleMiddleware.requireRole;
const logger = require('../../utils/logger/winstonLogger.js');

// 获取访问轨迹服务
const getService = () => {
  const service = getAccessTrackingService();
  if (!service) {
    throw new Error('访问轨迹服务未初始化');
  }
  return service;
};

/**
 * @route GET /api/access-tracking/status
 * @desc 获取访问轨迹服务状态
 * @access 管理员
 */
router.get('/status', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const service = getService();
      
      // 获取服务状态
      const status = {
        initialized: service.initialized,
        thresholds: service.options.thresholds,
        trackingEnabled: true
      };
      
      res.json({
        success: true,
        data: status
      });
    } catch (error) {
      logger.error('获取访问轨迹服务状态失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取访问轨迹服务状态时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/anomalies
 * @desc 获取异常访问记录
 * @access 管理员
 */
router.get('/anomalies', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      // 分页参数
      const page = parseInt(req.query.page || '1');
      const limit = parseInt(req.query.limit || '20');
      const skip = (page - 1) * limit;
      
      // 最小异常分数阈值
      const minScore = parseInt(req.query.minScore || '30');
      
      // 查询时间范围
      let timeRange = parseInt(req.query.timeRange || '24'); // 默认24小时
      const endDate = new Date();
      const startDate = new Date(endDate.getTime() - (timeRange * 60 * 60 * 1000));
      
      // 查询异常记录
      const anomalies = await AccessTrack.find({
        anomalyScore: { $gte: minScore },
        timestamp: { $gte: startDate }
      })
      .sort({ anomalyScore: -1, timestamp: -1 })
      .skip(skip)
      .limit(limit);
      
      // 获取总记录数
      const total = await AccessTrack.countDocuments({
        anomalyScore: { $gte: minScore },
        timestamp: { $gte: startDate }
      });
      
      // 返回结果
      res.json({
        success: true,
        data: anomalies,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      });
    } catch (error) {
      logger.error('获取异常访问记录失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取异常访问记录时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/user/:userId
 * @desc 获取用户访问历史
 * @access 管理员
 */
router.get('/user/:userId', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { userId } = req.params;
      
      // 分页参数
      const page = parseInt(req.query.page || '1');
      const limit = parseInt(req.query.limit || '20');
      const skip = (page - 1) * limit;
      
      // 获取用户访问历史
      const service = getService();
      const history = await service.getUserAccessHistory(userId, {
        limit,
        skip,
        sort: { timestamp: -1 }
      });
      
      // 获取总记录数
      const total = await AccessTrack.countDocuments({ userId });
      
      // 返回结果
      res.json({
        success: true,
        data: history,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      });
    } catch (error) {
      logger.error('获取用户访问历史失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取用户访问历史时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/resource/:type/:id
 * @desc 获取资源访问历史
 * @access 管理员
 */
router.get('/resource/:type/:id', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { type, id } = req.params;
      
      // 分页参数
      const page = parseInt(req.query.page || '1');
      const limit = parseInt(req.query.limit || '20');
      const skip = (page - 1) * limit;
      
      // 获取资源访问历史
      const service = getService();
      const history = await service.getResourceAccessHistory(type, id, {
        limit,
        skip,
        sort: { timestamp: -1 }
      });
      
      // 获取总记录数
      const total = await AccessTrack.countDocuments({
        'resource.type': type,
        'resource.id': id
      });
      
      // 返回结果
      res.json({
        success: true,
        data: history,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      });
    } catch (error) {
      logger.error('获取资源访问历史失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取资源访问历史时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/ip/:ip
 * @desc 获取IP访问历史
 * @access 管理员
 */
router.get('/ip/:ip', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { ip } = req.params;
      
      // 分页参数
      const page = parseInt(req.query.page || '1');
      const limit = parseInt(req.query.limit || '20');
      const skip = (page - 1) * limit;
      
      // 获取IP访问历史
      const history = await AccessTrack.find({ ip })
        .sort({ timestamp: -1 })
        .skip(skip)
        .limit(limit);
      
      // 获取总记录数
      const total = await AccessTrack.countDocuments({ ip });
      
      // 获取封禁状态
      const service = getService();
      const banInfo = await service.checkIPBan(ip);
      
      // 返回结果
      res.json({
        success: true,
        data: {
          history,
          banInfo
        },
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      });
    } catch (error) {
      logger.error('获取IP访问历史失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取IP访问历史时出错'
      });
    }
  }
);

/**
 * @route POST /api/access-tracking/ban-ip
 * @desc 封禁IP地址
 * @access 管理员
 */
router.post('/ban-ip', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { ip, duration, reason } = req.body;
      
      if (!ip) {
        return res.status(400).json({
          success: false,
          error: 'invalid_request',
          message: 'IP地址是必需的'
        });
      }
      
      // 封禁IP
      const service = getService();
      const banDuration = duration || 3600; // 默认1小时
      const banReason = reason || '管理员手动封禁';
      
      const result = await service.banIP(ip, banDuration, banReason);
      
      if (result) {
        // 记录封禁操作
        await AccessTrack.create({
          userId: req.user.id,
          ip: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
          method: 'POST',
          path: '/api/access-tracking/ban-ip',
          resource: {
            type: 'ip_ban',
            id: ip
          },
          timestamp: new Date(),
          metadata: {
            bannedIp: ip,
            duration: banDuration,
            reason: banReason
          }
        });
        
        res.json({
          success: true,
          message: `IP ${ip} 已被封禁，持续时间: ${banDuration}秒`,
          data: {
            ip,
            duration: banDuration,
            reason: banReason,
            expiresAt: new Date(Date.now() + banDuration * 1000)
          }
        });
      } else {
        res.status(500).json({
          success: false,
          error: 'ban_failed',
          message: '封禁IP时出错'
        });
      }
    } catch (error) {
      logger.error('封禁IP失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '封禁IP时出错'
      });
    }
  }
);

/**
 * @route POST /api/access-tracking/unban-ip
 * @desc 解封IP地址
 * @access 管理员
 */
router.post('/unban-ip', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { ip } = req.body;
      
      if (!ip) {
        return res.status(400).json({
          success: false,
          error: 'invalid_request',
          message: 'IP地址是必需的'
        });
      }
      
      // 解封IP
      const service = getService();
      const result = await service.unbanIP(ip);
      
      if (result) {
        // 记录解封操作
        await AccessTrack.create({
          userId: req.user.id,
          ip: req.headers['x-forwarded-for'] || req.connection.remoteAddress,
          method: 'POST',
          path: '/api/access-tracking/unban-ip',
          resource: {
            type: 'ip_unban',
            id: ip
          },
          timestamp: new Date(),
          metadata: {
            unbannedIp: ip
          }
        });
        
        res.json({
          success: true,
          message: `IP ${ip} 已被解封`
        });
      } else {
        res.status(500).json({
          success: false,
          error: 'unban_failed',
          message: '解封IP时出错'
        });
      }
    } catch (error) {
      logger.error('解封IP失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '解封IP时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/stats/user/:userId
 * @desc 获取用户访问统计信息
 * @access 管理员
 */
router.get('/stats/user/:userId', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      const { userId } = req.params;
      const resourceType = req.query.resourceType;
      const timeWindow = parseInt(req.query.timeWindow || '3600'); // 默认1小时
      
      // 获取用户资源访问统计
      const service = getService();
      const stats = await service.getUserResourceAccessStats(userId, resourceType, timeWindow);
      
      // 获取用户访问模式
      const days = parseInt(req.query.days || '30');
      const accessPattern = await AccessTrack.getUserAccessPattern(userId, days);
      
      res.json({
        success: true,
        data: {
          stats,
          accessPattern
        }
      });
    } catch (error) {
      logger.error('获取用户访问统计失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取用户访问统计时出错'
      });
    }
  }
);

/**
 * @route GET /api/access-tracking/stats/general
 * @desc 获取总体访问统计信息
 * @access 管理员
 */
router.get('/stats/general', 
  authMiddleware.requireAuth, 
  requireRole(['admin', 'security']), 
  async (req, res) => {
    try {
      // 查询时间范围
      const days = parseInt(req.query.days || '7');
      const endDate = new Date();
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - days);
      
      // 获取访问统计
      const stats = await AccessTrack.getAccessStats(startDate, endDate);
      
      // 获取异常访问数量
      const anomalyCount = await AccessTrack.countDocuments({
        anomalyScore: { $gte: 30 },
        timestamp: { $gte: startDate }
      });
      
      // 获取IP封禁数量
      const service = getService();
      // 注：此处假设已实现getActiveBans方法，实际可能需要在服务中实现
      const banCount = service.getActiveBans ? await service.getActiveBans() : 'N/A';
      
      res.json({
        success: true,
        data: {
          timeRange: {
            start: startDate,
            end: endDate,
            days
          },
          stats,
          summary: {
            anomalyCount,
            bannedIPs: banCount
          }
        }
      });
    } catch (error) {
      logger.error('获取总体访问统计失败:', error);
      res.status(500).json({
        success: false,
        error: 'server_error',
        message: '获取总体访问统计时出错'
      });
    }
  }
);

module.exports = router; 