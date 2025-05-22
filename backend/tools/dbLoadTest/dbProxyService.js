/**
 * ✅ 模块名：dbProxyService.js
 * ✅ 功能概述：
 *   - 提供一个 Express 服务，用于代理执行 MongoDB 查询操作。
 *   - 支持查询、聚合、统计、去重等操作。
 *   - 支持 JWT 与 API Token 认证、速率限制、中间件日志记录。
 *   - 提供健康检查、指标统计、重置接口等。
 * ✅ 使用场景：数据库压测、远程代理查询、后端诊断工具。
 */
/**
 * 数据库代理服务类
 * 用于处理数据库请求、认证校验、速率限制与运行状态管理。
 */
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const config = require('./config');
const { getLogger } = require('./logger');

const logger = getLogger('dbProxyService');

/**
 * 数据库代理服务类
 */
class DbProxyService {
  constructor(options = {}) {
    this.port = options.port || 3333;
    this.apiToken = options.apiToken || 'test-token';
    this.jwtSecret = options.jwtSecret || 'db-proxy-secret';
    this.enableRateLimit = options.enableRateLimit !== false;
    this.maxRequestsPerMinute = options.maxRequestsPerMinute || 3000;
    this.app = express();
    this.server = null;
    this.metrics = {
      requests: 0,
      errors: 0,
      queriesByCollection: {},
      startTime: null
    };
  }
  
  /**
   * 初始化 Express 服务、配置中间件与路由
   */
  initialize() {
    try {
      // 配置中间件
      this.app.use(express.json({ limit: '10mb' }));
      this.app.use(cors());
      
      // 记录请求中间件
      this.app.use((req, res, next) => {
        const start = Date.now();
        
        // 记录响应完成时间
        res.on('finish', () => {
          const duration = Date.now() - start;
          const statusCode = res.statusCode;
          
          // 更新指标
          this.metrics.requests++;
          if (statusCode >= 400) {
            this.metrics.errors++;
          }
          
          // 记录详细信息到日志
          const logLevel = statusCode >= 400 ? 'error' : 'info';
          logger[logLevel](`${req.method} ${req.path} ${statusCode} ${duration}ms`);
        });
        
        next();
      });
      
      // 如果启用了速率限制
      if (this.enableRateLimit) {
        this.app.use(this._createRateLimiter());
      }
      
      // 认证中间件
      this.app.use((req, res, next) => {
        try {
          // 获取请求头中的token
          const authHeader = req.headers.authorization;
          if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({
              success: false,
              error: 'missing_token',
              message: 'Missing authentication token'
            });
          }
          
          const token = authHeader.substring(7);
          
          // 验证token
          if (token === this.apiToken) {
            return next();
          }
          
          // 尝试验证JWT
          try {
            const decoded = jwt.verify(token, this.jwtSecret);
            req.user = decoded;
            return next();
          } catch (jwtError) {
            return res.status(401).json({
              success: false,
              error: 'invalid_token',
              message: 'Invalid authentication token'
            });
          }
        } catch (error) {
          logger.error('认证中间件错误:', error);
          return res.status(500).json({
            success: false,
            error: 'auth_error',
            message: 'Authentication error'
          });
        }
      });
      
      // 设置路由
      this._setupRoutes();
      
      return true;
    } catch (error) {
      logger.error('初始化服务失败:', error);
      return false;
    }
  }
  
  /**
   * 创建基于 IP 的简单速率限制器
   * @returns {Function} 速率限制中间件
   * @private
   */
  _createRateLimiter() {
    const requestCounts = {};
    const windowMs = 60 * 1000; // 1分钟窗口
    
    return (req, res, next) => {
      const now = Date.now();
      const ip = req.ip;
      
      // 清理过期的计数
      Object.keys(requestCounts).forEach(key => {
        if (requestCounts[key].timestamp < now - windowMs) {
          delete requestCounts[key];
        }
      });
      
      // 获取当前IP的计数
      if (!requestCounts[ip]) {
        requestCounts[ip] = {
          count: 0,
          timestamp: now
        };
      }
      
      // 增加计数
      requestCounts[ip].count++;
      
      // 如果超过限制，返回429
      if (requestCounts[ip].count > this.maxRequestsPerMinute) {
        return res.status(429).json({
          success: false,
          error: 'rate_limit_exceeded',
          message: '请求速率超过限制'
        });
      }
      
      next();
    };
  }
  
  /**
   * 配置所有 HTTP 接口路由
   * @private
   */
  _setupRoutes() {
    // 健康检查端点
    this.app.get('/health', (req, res) => {
      return res.json({
        success: true,
        status: 'healthy',
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
      });
    });
    
    // 状态端点
    this.app.get('/status', (req, res) => {
      const now = Date.now();
      const uptime = this.metrics.startTime ? now - this.metrics.startTime : 0;
      
      return res.json({
        success: true,
        metrics: {
          requests: this.metrics.requests,
          errors: this.metrics.errors,
          errorRate: this.metrics.requests > 0 ? this.metrics.errors / this.metrics.requests : 0,
          queriesByCollection: this.metrics.queriesByCollection,
          uptime: uptime,
          startTime: this.metrics.startTime
        }
      });
    });
    
    // 重置指标端点
    this.app.post('/reset-metrics', (req, res) => {
      this.metrics = {
        requests: 0,
        errors: 0,
        queriesByCollection: {},
        startTime: Date.now()
      };
      
      return res.json({
        success: true,
        message: '指标已重置'
      });
    });
    
    // 数据库查询端点
    this.app.post('/api/db-proxy/query', async (req, res) => {
      try {
        const { operation, collection, filter, options, pipeline, field } = req.body;
        
        // 验证请求参数
        if (!operation || !collection) {
          return res.status(400).json({
            success: false,
            error: 'invalid_params',
            message: '缺少必需的参数: operation, collection'
          });
        }
        
        // 更新集合查询计数
        if (!this.metrics.queriesByCollection[collection]) {
          this.metrics.queriesByCollection[collection] = {
            total: 0,
            operations: {}
          };
        }
        
        this.metrics.queriesByCollection[collection].total++;
        
        if (!this.metrics.queriesByCollection[collection].operations[operation]) {
          this.metrics.queriesByCollection[collection].operations[operation] = 0;
        }
        
        this.metrics.queriesByCollection[collection].operations[operation]++;
        
        // 执行数据库操作
        const collectionObj = mongoose.connection.db.collection(collection);
        let result;
        
        switch (operation) {
          case 'find':
            // 执行 find 查询，返回文档数组
            result = await collectionObj.find(filter || {}, options || {}).toArray();
            break;
            
          case 'findOne':
            // 返回匹配的单个文档
            result = await collectionObj.findOne(filter || {}, options || {});
            break;
            
          case 'aggregate':
            // 使用 MongoDB 聚合管道处理数据
            result = await collectionObj.aggregate(pipeline || [], options || {}).toArray();
            break;
            
          case 'count':
          case 'countDocuments':
            // 返回匹配文档数量
            result = await collectionObj.countDocuments(filter || {}, options || {});
            break;
            
          case 'distinct':
            // 返回指定字段的唯一值集合
            result = await collectionObj.distinct(field, filter || {}, options || {});
            break;
            
          default:
            return res.status(400).json({
              success: false,
              error: 'unsupported_operation',
              message: `不支持的操作: ${operation}`
            });
        }
        
        // 返回结果
        return res.json({
          success: true,
          data: {
            result,
            count: Array.isArray(result) ? result.length : 1
          }
        });
      } catch (error) {
        logger.error('执行查询时出错:', error);
        
        return res.status(500).json({
          success: false,
          error: 'query_execution_failed',
          message: `查询执行失败: ${error.message}`
        });
      }
    });
    
    // 404处理
    this.app.use((req, res) => {
      return res.status(404).json({
        success: false,
        error: 'not_found',
        message: `未找到路径: ${req.path}`
      });
    });
    
    // 错误处理
    this.app.use((err, req, res, next) => {
      logger.error('服务器错误:', err);
      
      return res.status(500).json({
        success: false,
        error: 'server_error',
        message: `服务器错误: ${err.message}`
      });
    });
  }
  
  /**
   * 启动服务并监听端口
   * @returns {Promise<boolean>} 启动结果
   */
  async start() {
    try {
      // 检查数据库连接
      if (mongoose.connection.readyState !== 1) {
        logger.info('尝试连接到数据库...');
        await mongoose.connect(config.database.uri, config.database.options).catch(error => {
          logger.error('数据库连接失败:', error);
          throw error;
        });
      }
      
      // 初始化服务设置
      this.initialize();
      
      // 启动服务
      return new Promise((resolve) => {
        this.server = this.app.listen(this.port, () => {
          this.metrics.startTime = Date.now();
          logger.info(`数据库代理服务已启动, 监听端口: ${this.port}`);
          resolve(true);
        });
      });
    } catch (error) {
      logger.error('启动服务失败:', error);
      return false;
    }
  }
  
  /**
   * 优雅关闭服务
   * @returns {Promise<boolean>} 停止结果
   */
  async stop() {
    try {
      if (!this.server) {
        logger.warn('服务未运行');
        return true;
      }
      
      return new Promise((resolve) => {
        this.server.close(() => {
          logger.info('数据库代理服务已停止');
          this.server = null;
          resolve(true);
        });
      });
    } catch (error) {
      logger.error('停止服务失败:', error);
      return false;
    }
  }
  
  /**
   * 返回当前运行状态及指标
   * @returns {Object} 服务状态
   */
  getStatus() {
    const isRunning = !!this.server;
    const now = Date.now();
    const uptime = this.metrics.startTime ? now - this.metrics.startTime : 0;
    
    return {
      isRunning,
      port: this.port,
      metrics: this.metrics,
      uptime,
      startTime: this.metrics.startTime
    };
  }
}

// 导出模块
module.exports = DbProxyService; 