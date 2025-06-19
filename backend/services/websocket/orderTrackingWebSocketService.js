const Order = require('../../models/order/orderModel');
const jwt = require('jsonwebtoken');

class OrderTrackingWebSocketService {
  constructor() {
    this.io = null;
    this.connectedClients = new Map();
    this.orderTrackers = new Map();
  }

  initialize(io) {
    this.io = io;
    
    // 创建订单追踪命名空间
    const orderNamespace = io.of('/orders');
    
    orderNamespace.on('connection', async (socket) => {
      console.log('客户端连接到订单追踪:', socket.id);
      
      // 验证用户身份
      const token = socket.handshake.auth.token;
      if (!token) {
        socket.disconnect();
        return;
      }
      
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;
        const userType = socket.handshake.query.userType || 'customer';
        const merchantId = socket.handshake.query.merchantId;
        
        // 保存客户端连接信息
        this.connectedClients.set(socket.id, {
          userId,
          userType,
          merchantId,
          socket
        });
        
        // 根据用户类型加入不同的房间
        if (userType === 'merchant' && merchantId) {
          socket.join(`merchant-${merchantId}`);
          // 发送当前制作队列状态
          await this.sendProductionQueue(socket, merchantId);
        } else if (userType === 'customer') {
          socket.join(`user-${userId}`);
        }
        
        // 监听订单追踪请求
        socket.on('trackOrder', async (orderId) => {
          await this.trackOrder(socket, orderId, userId, userType);
        });
        
        // 监听制作进度更新
        socket.on('updateProductionProgress', async (data) => {
          if (userType === 'merchant') {
            await this.updateProductionProgress(socket, data, merchantId);
          }
        });
        
        // 监听断开连接
        socket.on('disconnect', () => {
          console.log('客户端断开连接:', socket.id);
          this.connectedClients.delete(socket.id);
          this.removeTracker(socket.id);
        });
        
      } catch (error) {
        console.error('WebSocket认证失败:', error);
        socket.disconnect();
      }
    });
  }
  
  /**
   * 发送制作队列状态
   */
  async sendProductionQueue(socket, merchantId) {
    try {
      // 获取制作中的订单
      const preparingOrders = await Order.find({
        merchantId: merchantId,
        status: { $in: ['confirmed', 'preparing'] }
      })
      .populate('userId', 'nickname phone')
      .sort({ createdAt: 1 });

      const queue = preparingOrders.map(order => ({
        orderId: order._id,
        orderNumber: order.orderNumber,
        customerName: order.userId?.nickname || '顾客',
        items: order.items.map(item => ({
          name: item.name,
          quantity: item.quantity,
          customizations: item.customizations
        })),
        status: order.status,
        createdAt: order.createdAt,
        estimatedCompletionTime: order.dineIn?.estimatedCompletionTime,
        productionSteps: this.getProductionSteps(order)
      }));

      socket.emit('productionQueue', {
        type: 'initial',
        queue,
        timestamp: new Date()
      });
      
    } catch (error) {
      console.error('发送制作队列失败:', error);
    }
  }
  
  /**
   * 追踪单个订单
   */
  async trackOrder(socket, orderId, userId, userType) {
    try {
      const query = { _id: orderId };
      
      // 验证权限
      if (userType === 'customer') {
        query.userId = userId;
      } else if (userType === 'merchant') {
        const client = this.connectedClients.get(socket.id);
        query.merchantId = client.merchantId;
      }
      
      const order = await Order.findOne(query)
        .populate('userId', 'nickname phone')
        .populate('merchantId', 'name');

      if (!order) {
        socket.emit('trackingError', {
          orderId,
          error: '订单不存在或无权限访问'
        });
        return;
      }

      // 创建追踪器
      const trackerId = `${socket.id}-${orderId}`;
      this.orderTrackers.set(trackerId, {
        socketId: socket.id,
        orderId,
        userId,
        userType
      });

      // 发送订单状态
      socket.emit('orderStatus', {
        orderId: order._id,
        orderNumber: order.orderNumber,
        status: order.status,
        statusHistory: order.statusHistory,
        merchantName: order.merchantId?.name,
        items: order.items,
        estimatedCompletionTime: order.dineIn?.estimatedCompletionTime,
        productionSteps: this.getProductionSteps(order),
        timestamp: new Date()
      });
      
    } catch (error) {
      console.error('追踪订单失败:', error);
      socket.emit('trackingError', {
        orderId,
        error: '系统错误'
      });
    }
  }
  
  /**
   * 更新制作进度
   */
  async updateProductionProgress(socket, data, merchantId) {
    try {
      const { orderId, step, progress, notes } = data;
      
      const order = await Order.findOne({
        _id: orderId,
        merchantId: merchantId
      });

      if (!order) {
        socket.emit('updateError', {
          error: '订单不存在或无权限更新'
        });
        return;
      }

      // 更新制作进度
      if (!order.productionProgress) {
        order.productionProgress = {};
      }
      
      order.productionProgress[step] = {
        status: progress,
        updatedAt: new Date(),
        updatedBy: socket.handshake.auth.userId,
        notes
      };

      // 如果所有步骤完成，更新订单状态为ready
      const allStepsCompleted = this.checkAllStepsCompleted(order);
      if (allStepsCompleted && order.status === 'preparing') {
        order.updateStatus('ready');
      }

      await order.save();

      // 通知所有相关客户端
      const updateData = {
        orderId: order._id,
        orderNumber: order.orderNumber,
        step,
        progress,
        notes,
        overallProgress: this.calculateOverallProgress(order),
        timestamp: new Date()
      };

      // 通知商家端所有客户端
      this.io.of('/orders').to(`merchant-${merchantId}`).emit('productionUpdate', updateData);
      
      // 通知客户端
      this.io.of('/orders').to(`user-${order.userId}`).emit('orderProgressUpdate', updateData);
      
    } catch (error) {
      console.error('更新制作进度失败:', error);
      socket.emit('updateError', {
        error: '更新失败'
      });
    }
  }
  
  /**
   * 订单状态变更通知
   */
  async notifyOrderStatusChange(order, oldStatus, newStatus) {
    try {
      const notification = {
        orderId: order._id,
        orderNumber: order.orderNumber,
        oldStatus,
        newStatus,
        timestamp: new Date()
      };

      // 通知商家
      if (order.merchantId) {
        this.io.of('/orders').to(`merchant-${order.merchantId}`).emit('orderStatusChanged', notification);
      }

      // 通知客户
      if (order.userId) {
        this.io.of('/orders').to(`user-${order.userId}`).emit('orderStatusChanged', notification);
      }

      // 特殊状态的额外通知
      if (newStatus === 'ready') {
        this.io.of('/orders').to(`user-${order.userId}`).emit('orderReady', {
          orderId: order._id,
          orderNumber: order.orderNumber,
          pickupCode: order.pickupCode,
          message: '您的订单已准备好，请及时取餐！'
        });
      }
      
    } catch (error) {
      console.error('发送订单状态变更通知失败:', error);
    }
  }
  
  /**
   * 获取制作步骤
   */
  getProductionSteps(order) {
    const steps = [
      {
        id: 'received',
        name: '接单',
        status: order.status !== 'pending' ? 'completed' : 'pending',
        timestamp: order.statusHistory?.find(h => h.status === 'confirmed')?.timestamp
      },
      {
        id: 'preparing',
        name: '备餐',
        status: order.status === 'preparing' || order.status === 'ready' || order.status === 'completed' ? 'completed' : 
                order.status === 'confirmed' ? 'in_progress' : 'pending',
        timestamp: order.statusHistory?.find(h => h.status === 'preparing')?.timestamp
      },
      {
        id: 'cooking',
        name: '制作',
        status: order.productionProgress?.cooking?.status || 
                (order.status === 'ready' || order.status === 'completed' ? 'completed' : 'pending'),
        timestamp: order.productionProgress?.cooking?.updatedAt
      },
      {
        id: 'plating',
        name: '装盘',
        status: order.productionProgress?.plating?.status || 
                (order.status === 'ready' || order.status === 'completed' ? 'completed' : 'pending'),
        timestamp: order.productionProgress?.plating?.updatedAt
      },
      {
        id: 'ready',
        name: '完成',
        status: order.status === 'ready' || order.status === 'completed' ? 'completed' : 'pending',
        timestamp: order.statusHistory?.find(h => h.status === 'ready')?.timestamp
      }
    ];

    return steps;
  }
  
  /**
   * 检查所有步骤是否完成
   */
  checkAllStepsCompleted(order) {
    const requiredSteps = ['cooking', 'plating'];
    return requiredSteps.every(step => 
      order.productionProgress?.[step]?.status === 'completed'
    );
  }
  
  /**
   * 计算整体进度
   */
  calculateOverallProgress(order) {
    const steps = this.getProductionSteps(order);
    const completedSteps = steps.filter(step => step.status === 'completed').length;
    return Math.round((completedSteps / steps.length) * 100);
  }
  
  removeTracker(socketId) {
    // 移除与该socket相关的所有追踪器
    for (const [trackerId, tracker] of this.orderTrackers.entries()) {
      if (tracker.socketId === socketId) {
        this.orderTrackers.delete(trackerId);
      }
    }
  }
}

module.exports = new OrderTrackingWebSocketService();