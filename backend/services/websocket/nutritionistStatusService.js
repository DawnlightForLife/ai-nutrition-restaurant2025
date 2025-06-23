/**
 * 营养师状态WebSocket服务
 * 用于实时同步营养师在线状态
 */

const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const config = require('../../config');
const logger = require('../../config/modules/logger');
const NutritionistModel = require('../../models/nutrition/nutritionistModel');

class NutritionistStatusService {
  constructor() {
    this.io = null;
    this.connections = new Map(); // nutritionistId -> socketId
    this.statusCache = new Map(); // nutritionistId -> status
  }

  /**
   * 初始化WebSocket服务
   */
  initialize(server) {
    this.io = new Server(server, {
      cors: {
        origin: config.system.cors.origin,
        credentials: true
      },
      path: '/ws/nutritionist-status'
    });

    this.io.use(this.authenticate.bind(this));
    this.io.on('connection', this.handleConnection.bind(this));

    logger.info('营养师状态WebSocket服务已初始化');
  }

  /**
   * 认证中间件
   */
  async authenticate(socket, next) {
    try {
      const token = socket.handshake.auth.token;
      if (!token) {
        return next(new Error('未提供认证令牌'));
      }

      const decoded = jwt.verify(token, config.jwt.secret);
      socket.userId = decoded.userId;
      socket.role = decoded.role;
      
      // 如果是营养师，记录其ID
      if (decoded.nutritionistId) {
        socket.nutritionistId = decoded.nutritionistId;
      }

      next();
    } catch (error) {
      logger.error('WebSocket认证失败:', error);
      next(new Error('认证失败'));
    }
  }

  /**
   * 处理连接
   */
  handleConnection(socket) {
    logger.info(`新的WebSocket连接: ${socket.id}, 用户: ${socket.userId}`);

    // 如果是营养师连接，更新其在线状态
    if (socket.nutritionistId) {
      this.handleNutritionistConnect(socket);
    }

    // 订阅营养师状态更新
    socket.on('subscribe:nutritionist', (nutritionistId) => {
      socket.join(`nutritionist:${nutritionistId}`);
      // 发送当前状态
      const status = this.getNutritionistStatus(nutritionistId);
      socket.emit('nutritionist:status', { nutritionistId, ...status });
    });

    // 取消订阅
    socket.on('unsubscribe:nutritionist', (nutritionistId) => {
      socket.leave(`nutritionist:${nutritionistId}`);
    });

    // 管理员订阅所有营养师状态
    if (socket.role === 'admin') {
      socket.join('admin:nutritionist-status');
    }

    // 心跳
    socket.on('ping', () => {
      socket.emit('pong', { timestamp: Date.now() });
    });

    // 断开连接
    socket.on('disconnect', () => {
      logger.info(`WebSocket断开连接: ${socket.id}`);
      if (socket.nutritionistId) {
        this.handleNutritionistDisconnect(socket);
      }
    });
  }

  /**
   * 处理营养师连接
   */
  async handleNutritionistConnect(socket) {
    const { nutritionistId } = socket;
    
    // 更新连接映射
    this.connections.set(nutritionistId, socket.id);
    
    // 更新状态
    await this.updateNutritionistStatus(nutritionistId, {
      isOnline: true,
      lastActiveAt: new Date()
    });

    // 加入营养师房间
    socket.join(`nutritionist:${nutritionistId}`);
    
    logger.info(`营养师上线: ${nutritionistId}`);
  }

  /**
   * 处理营养师断开连接
   */
  async handleNutritionistDisconnect(socket) {
    const { nutritionistId } = socket;
    
    // 移除连接映射
    this.connections.delete(nutritionistId);
    
    // 延迟更新离线状态（避免短暂断线）
    setTimeout(async () => {
      if (!this.connections.has(nutritionistId)) {
        await this.updateNutritionistStatus(nutritionistId, {
          isOnline: false,
          lastActiveAt: new Date()
        });
        logger.info(`营养师离线: ${nutritionistId}`);
      }
    }, 5000);
  }

  /**
   * 更新营养师状态
   */
  async updateNutritionistStatus(nutritionistId, status) {
    try {
      // 更新数据库
      await NutritionistModel.findByIdAndUpdate(nutritionistId, status);
      
      // 更新缓存
      this.statusCache.set(nutritionistId, {
        ...this.statusCache.get(nutritionistId),
        ...status,
        updatedAt: new Date()
      });
      
      // 广播状态更新
      this.broadcastStatusUpdate(nutritionistId, status);
    } catch (error) {
      logger.error('更新营养师状态失败:', error);
    }
  }

  /**
   * 广播状态更新
   */
  broadcastStatusUpdate(nutritionistId, status) {
    const updateData = {
      nutritionistId,
      ...status,
      timestamp: new Date()
    };
    
    // 通知订阅该营养师的客户端
    this.io.to(`nutritionist:${nutritionistId}`).emit('nutritionist:status:update', updateData);
    
    // 通知管理员
    this.io.to('admin:nutritionist-status').emit('nutritionist:status:update', updateData);
  }

  /**
   * 获取营养师状态
   */
  getNutritionistStatus(nutritionistId) {
    const cached = this.statusCache.get(nutritionistId);
    if (cached) {
      return cached;
    }
    
    // 默认状态
    return {
      isOnline: false,
      lastActiveAt: null,
      status: 'active'
    };
  }

  /**
   * 获取所有在线营养师
   */
  getOnlineNutritionists() {
    return Array.from(this.connections.keys());
  }

  /**
   * 获取活跃连接数
   */
  getActiveConnections() {
    return {
      total: this.io.sockets.sockets.size,
      nutritionists: this.connections.size,
      rooms: this.io.sockets.adapter.rooms.size
    };
  }

  /**
   * 发送消息给特定营养师
   */
  sendToNutritionist(nutritionistId, event, data) {
    const socketId = this.connections.get(nutritionistId);
    if (socketId) {
      this.io.to(socketId).emit(event, data);
      return true;
    }
    return false;
  }

  /**
   * 批量更新营养师状态
   */
  async batchUpdateStatus(updates) {
    for (const { nutritionistId, status } of updates) {
      await this.updateNutritionistStatus(nutritionistId, status);
    }
  }
}

// 导出单例实例
module.exports = new NutritionistStatusService();