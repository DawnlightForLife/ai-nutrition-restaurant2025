/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 功能概述：
 *   - 实时追踪所有访问请求，记录访问行为与响应性能
 *   - 检测可疑行为（如频繁访问、异常路径、异常参数）并自动封禁
 *   - 提供资源追踪支持：自动识别被访问的资源类型和资源ID
 *   - 提供 resourceIdResolvers 工具集（支持从 params、query、body、user 中提取ID）
 * ✅ 支持内容：
 *   - 动态中间件初始化
 *   - Express 响应钩子覆盖（res.end）
 *   - 多场景封禁逻辑处理
 * ✅ 推荐 future：
 *   - 支持 user-agent 分析，识别爬虫行为
 *   - 提供访问轨迹分析 dashboard（热点路径、攻击图谱）
 */

/**
 * 访问轨迹追踪中间件 - 记录请求访问并检测异常行为
 * @module middleware/security/accessTrackingMiddleware
 */

const AccessTrackingService = require('../../services/security/accessTrackService');
const logger = require('../../utils/logger/winstonLogger.js');

// 访问轨迹服务实例
let accessTrackingService = null;

/**
 * 初始化访问轨迹追踪服务
 * @param {Object} options - 配置选项
 * @returns {Promise<AccessTrackingService>} 访问轨迹服务实例
 */
const initAccessTrackingService = async (options = {}) => {
  try {
    // TODO: 支持配置从外部配置中心加载访问规则（如黑名单、阈值）
    if (!accessTrackingService) {
      accessTrackingService = new AccessTrackingService(options);
      await accessTrackingService.initialize();
      
      // 设置异常检测处理
      accessTrackingService.on('anomaly_detected', handleAnomalyDetected);
      
      logger.info('访问轨迹追踪服务初始化成功');
    }
    
    return accessTrackingService;
  } catch (error) {
    logger.error('初始化访问轨迹追踪服务失败:', error);
    throw error;
  }
};

/**
 * 处理检测到的异常
 * @param {Object} anomalyEvent - 异常事件数据
 */
const handleAnomalyDetected = async (anomalyEvent) => {
  const { accessData, detectionResult } = anomalyEvent;
  
  logger.warn('检测到访问异常:', {
    userId: accessData.userId,
    ip: accessData.ip,
    path: accessData.path,
    anomalies: detectionResult.anomalies.map(a => a.type),
    score: detectionResult.anomalyScore
  });
  
  // 高风险行为检测：自动封禁来源IP
  // 若异常分数达到封禁阈值，将触发 accessTrackingService.banIP()
  if (detectionResult.anomalyScore >= 70) {
    // 高风险异常，自动封禁IP
    const banDuration = calculateBanDuration(detectionResult.anomalyScore);
    
    try {
      await accessTrackingService.banIP(
        accessData.ip,
        banDuration,
        `自动封禁: 异常分数 ${detectionResult.anomalyScore}`
      );
      
      logger.info(`已自动封禁IP ${accessData.ip}，持续时间: ${banDuration}秒，异常分数: ${detectionResult.anomalyScore}`);
    } catch (error) {
      logger.error('自动封禁IP失败:', error);
    }
  }
};

/**
 * 计算封禁时长（基于异常分数）
 * @param {Number} anomalyScore - 异常分数
 * @returns {Number} 封禁时长（秒）
 */
const calculateBanDuration = (anomalyScore) => {
  if (anomalyScore >= 90) {
    return 86400; // 24小时
  } else if (anomalyScore >= 80) {
    return 7200;  // 2小时
  } else {
    return 1800;  // 30分钟
  }
};

/**
 * 访问轨迹追踪中间件
 * 记录访问轨迹并检测异常行为
 * @param {Object} options - 中间件配置
 * @returns {Function} Express中间件函数
 */
const accessTrackingMiddleware = (options = {}) => {
  // 初始化访问轨迹服务
  let servicePromise = initAccessTrackingService(options);
  
  return async (req, res, next) => {
    // 跳过对静态资源的追踪
    if (req.path.startsWith('/static/') || req.path.startsWith('/public/') || req.path.includes('.')) {
      return next();
    }
    
    // 记录开始时间
    const startTime = Date.now();
    
    // 保存原始end方法
    const originalEnd = res.end;
    
    // 确保服务已初始化
    let service;
    try {
      service = await servicePromise;
    } catch (error) {
      logger.error('获取访问轨迹服务失败，跳过追踪:', error);
      return next();
    }
    
    // 检查IP是否被封禁
    try {
      const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      const banInfo = await service.checkIPBan(ip);
      
      if (banInfo) {
        // IP已被封禁，返回403响应
        logger.info(`拒绝访问: IP ${ip} 已被封禁`, banInfo);
        return res.status(403).json({
          success: false,
          error: 'access_denied',
          message: '您的访问已被暂时限制，请稍后再试',
          expiresAt: banInfo.expiresAt
        });
      }
    } catch (error) {
      logger.error('检查IP封禁状态失败:', error);
      // 继续处理请求，不阻止
    }
    
    // 覆盖响应结束方法
    res.end = function(chunk, encoding) {
      // 恢复原始方法
      res.end = originalEnd;
      
      // 计算响应时间
      const responseTime = Date.now() - startTime;
      
      // 异步记录访问轨迹
      try {
        // 尝试猜测资源类型和ID
        const resourceType = options.resourceType || req.resourceType;
        const resourceId = options.resourceId || req.resourceId;
        
        service.trackAccess(req, {
          responseTime,
          responseStatus: res.statusCode,
          resourceType,
          resourceId
        }).catch(error => {
          logger.error('记录访问轨迹失败:', error);
        });
      } catch (error) {
        logger.error('记录访问轨迹时出错:', error);
      }
      
      // 调用原始方法
      return originalEnd.call(this, chunk, encoding);
    };
    
    next();
  };
};

/**
 * 获取访问轨迹服务实例
 * @returns {AccessTrackingService|null} 访问轨迹服务实例
 */
const getAccessTrackingService = () => {
  return accessTrackingService;
};

/**
 * 可选资源追踪中间件（仅在目标路由使用）
 * - 提前设置 req.resourceType / req.resourceId
 * - 与 accessTrackingMiddleware 结合使用时提升追踪粒度
 */
const resourceTrackingMiddleware = (resourceType, resourceIdResolver = null) => {
  return (req, res, next) => {
    // 设置资源类型
    req.resourceType = resourceType;
    
    // 尝试设置资源ID
    if (resourceIdResolver && typeof resourceIdResolver === 'function') {
      try {
        req.resourceId = resourceIdResolver(req);
      } catch (error) {
        logger.error('解析资源ID失败:', error);
      }
    }
    
    next();
  };
};

/**
 * 解析资源ID的工具函数
 */
const resourceIdResolvers = {
  /**
   * 从路径参数中解析ID
   * @param {String} paramName - 参数名称
   * @returns {Function} 解析函数
   */
  fromParam: (paramName = 'id') => {
    return (req) => req.params[paramName];
  },
  
  /**
   * 从查询参数中解析ID
   * @param {String} queryName - 查询参数名称
   * @returns {Function} 解析函数
   */
  fromQuery: (queryName = 'id') => {
    return (req) => req.query[queryName];
  },
  
  /**
   * 从请求体中解析ID
   * @param {String} bodyField - 请求体字段名称
   * @returns {Function} 解析函数
   */
  fromBody: (bodyField = 'id') => {
    return (req) => req.body[bodyField];
  },
  
  /**
   * 从用户对象中解析ID
   * @returns {Function} 解析函数
   */
  fromUser: () => {
    return (req) => req.user ? req.user.id : null;
  }
};

module.exports = {
  accessTrackingMiddleware,
  resourceTrackingMiddleware,
  resourceIdResolvers,
  getAccessTrackingService,
  initAccessTrackingService
}; 