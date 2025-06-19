const IngredientInventory = require('../../models/merchant/ingredientInventoryModel');
const jwt = require('jsonwebtoken');

class InventoryWebSocketService {
  constructor() {
    this.io = null;
    this.connectedClients = new Map();
    this.inventoryWatchers = new Map();
  }

  initialize(io) {
    this.io = io;
    
    // 创建库存监控命名空间
    const inventoryNamespace = io.of('/inventory');
    
    inventoryNamespace.on('connection', async (socket) => {
      console.log('客户端连接到库存监控:', socket.id);
      
      // 验证用户身份
      const token = socket.handshake.auth.token;
      if (!token) {
        socket.disconnect();
        return;
      }
      
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;
        const storeId = socket.handshake.query.storeId;
        
        // 保存客户端连接信息
        this.connectedClients.set(socket.id, {
          userId,
          storeId,
          socket
        });
        
        // 加入店铺房间
        socket.join(`store-${storeId}`);
        
        // 发送初始库存状态
        await this.sendInitialInventoryStatus(socket, storeId);
        
        // 监听库存更新请求
        socket.on('subscribeToInventory', async (data) => {
          await this.subscribeToInventory(socket, storeId, data);
        });
        
        // 监听断开连接
        socket.on('disconnect', () => {
          console.log('客户端断开连接:', socket.id);
          this.connectedClients.delete(socket.id);
          this.removeWatcher(socket.id);
        });
        
      } catch (error) {
        console.error('WebSocket认证失败:', error);
        socket.disconnect();
      }
    });
    
    // 启动库存监控
    this.startInventoryMonitoring();
  }
  
  async sendInitialInventoryStatus(socket, storeId) {
    try {
      // 获取库存预警信息
      const alerts = await IngredientInventory.aggregate([
        { $match: { storeId: storeId } },
        {
          $facet: {
            lowStock: [
              { $match: { $expr: { $lte: ['$currentStock', '$minStock'] } } },
              { $count: 'count' }
            ],
            expiringSoon: [
              {
                $match: {
                  expiryDate: {
                    $lte: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
                    $gte: new Date()
                  }
                }
              },
              { $count: 'count' }
            ],
            expired: [
              { $match: { expiryDate: { $lt: new Date() } } },
              { $count: 'count' }
            ]
          }
        }
      ]);
      
      const alertSummary = {
        lowStock: alerts[0].lowStock[0]?.count || 0,
        expiringSoon: alerts[0].expiringSoon[0]?.count || 0,
        expired: alerts[0].expired[0]?.count || 0
      };
      
      socket.emit('inventoryStatus', {
        type: 'initial',
        alerts: alertSummary,
        timestamp: new Date()
      });
      
    } catch (error) {
      console.error('发送初始库存状态失败:', error);
    }
  }
  
  async subscribeToInventory(socket, storeId, data) {
    const { ingredientIds = [] } = data;
    
    // 创建监控器
    const watcherId = `${socket.id}-${Date.now()}`;
    this.inventoryWatchers.set(watcherId, {
      socketId: socket.id,
      storeId,
      ingredientIds
    });
    
    // 发送订阅成功消息
    socket.emit('subscriptionSuccess', {
      watcherId,
      ingredientIds
    });
  }
  
  startInventoryMonitoring() {
    // 每30秒检查一次库存状态
    setInterval(async () => {
      try {
        // 获取所有需要监控的店铺
        const storeIds = new Set();
        this.connectedClients.forEach(client => {
          if (client.storeId) {
            storeIds.add(client.storeId);
          }
        });
        
        // 为每个店铺检查库存状态
        for (const storeId of storeIds) {
          await this.checkInventoryAlerts(storeId);
        }
        
      } catch (error) {
        console.error('库存监控错误:', error);
      }
    }, 30000); // 30秒
  }
  
  async checkInventoryAlerts(storeId) {
    try {
      // 检查低库存
      const lowStockItems = await IngredientInventory.find({
        storeId: storeId,
        $expr: { $lte: ['$currentStock', '$minStock'] }
      }).populate('ingredientId', 'name');
      
      // 检查即将过期商品（3天内）
      const expiringSoonItems = await IngredientInventory.find({
        storeId: storeId,
        expiryDate: {
          $lte: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
          $gte: new Date()
        }
      }).populate('ingredientId', 'name');
      
      // 检查已过期商品
      const expiredItems = await IngredientInventory.find({
        storeId: storeId,
        expiryDate: { $lt: new Date() }
      }).populate('ingredientId', 'name');
      
      // 发送预警信息到对应店铺的所有客户端
      const roomName = `store-${storeId}`;
      
      if (lowStockItems.length > 0) {
        this.io.of('/inventory').to(roomName).emit('inventoryAlert', {
          type: 'lowStock',
          items: lowStockItems.map(item => ({
            id: item._id,
            name: item.ingredientId?.name || '未知',
            currentStock: item.currentStock,
            minStock: item.minStock,
            unit: item.unit
          })),
          timestamp: new Date()
        });
      }
      
      if (expiringSoonItems.length > 0) {
        this.io.of('/inventory').to(roomName).emit('inventoryAlert', {
          type: 'expiringSoon',
          items: expiringSoonItems.map(item => ({
            id: item._id,
            name: item.ingredientId?.name || '未知',
            expiryDate: item.expiryDate,
            batchNo: item.batchNo,
            currentStock: item.currentStock,
            unit: item.unit
          })),
          timestamp: new Date()
        });
      }
      
      if (expiredItems.length > 0) {
        this.io.of('/inventory').to(roomName).emit('inventoryAlert', {
          type: 'expired',
          items: expiredItems.map(item => ({
            id: item._id,
            name: item.ingredientId?.name || '未知',
            expiryDate: item.expiryDate,
            batchNo: item.batchNo,
            currentStock: item.currentStock,
            unit: item.unit
          })),
          timestamp: new Date()
        });
      }
      
    } catch (error) {
      console.error('检查库存预警失败:', error);
    }
  }
  
  // 当库存更新时调用此方法
  async notifyInventoryUpdate(storeId, inventoryItem) {
    const roomName = `store-${storeId}`;
    
    this.io.of('/inventory').to(roomName).emit('inventoryUpdate', {
      type: 'update',
      item: {
        id: inventoryItem._id,
        name: inventoryItem.ingredientId?.name || '未知',
        currentStock: inventoryItem.currentStock,
        minStock: inventoryItem.minStock,
        maxStock: inventoryItem.maxStock,
        unit: inventoryItem.unit,
        expiryDate: inventoryItem.expiryDate,
        lastUpdated: inventoryItem.updatedAt
      },
      timestamp: new Date()
    });
    
    // 检查是否触发预警
    if (inventoryItem.currentStock <= inventoryItem.minStock) {
      this.io.of('/inventory').to(roomName).emit('inventoryAlert', {
        type: 'lowStock',
        items: [{
          id: inventoryItem._id,
          name: inventoryItem.ingredientId?.name || '未知',
          currentStock: inventoryItem.currentStock,
          minStock: inventoryItem.minStock,
          unit: inventoryItem.unit
        }],
        timestamp: new Date()
      });
    }
  }
  
  removeWatcher(socketId) {
    // 移除与该socket相关的所有监控器
    for (const [watcherId, watcher] of this.inventoryWatchers.entries()) {
      if (watcher.socketId === socketId) {
        this.inventoryWatchers.delete(watcherId);
      }
    }
  }
}

module.exports = new InventoryWebSocketService();