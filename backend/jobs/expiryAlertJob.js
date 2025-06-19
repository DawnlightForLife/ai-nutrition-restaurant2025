/**
 * 食材过期预警定时任务
 * 定期检查食材过期状态，发送预警通知
 */
const cron = require('node-cron');
const { IngredientInventory, ALERT_TYPES } = require('../models/merchant/ingredientInventoryModel');
const { Notification } = require('../models/notification/notificationModel');
const inventoryWebSocketService = require('../services/websocket/inventoryWebSocketService');

class ExpiryAlertJob {
  constructor() {
    this.taskName = 'ExpiryAlertJob';
    this.cronExpression = '0 8,20 * * *'; // 每天早上8点和晚上8点执行
  }

  /**
   * 启动定时任务
   */
  start() {
    console.log(`[${this.taskName}] 启动过期预警检查任务...`);
    
    // 立即执行一次
    this.execute();
    
    // 设置定时任务
    this.task = cron.schedule(this.cronExpression, () => {
      this.execute();
    });
  }

  /**
   * 停止定时任务
   */
  stop() {
    if (this.task) {
      this.task.stop();
      console.log(`[${this.taskName}] 停止过期预警检查任务`);
    }
  }

  /**
   * 执行任务
   */
  async execute() {
    console.log(`[${this.taskName}] 开始执行过期预警检查...`);
    
    try {
      const now = new Date();
      const threeDaysLater = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);
      const sevenDaysLater = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);

      // 获取所有活跃的库存记录
      const inventories = await IngredientInventory.find({
        isActive: true,
        'alertSettings.expiryAlert': true
      }).populate('merchantId');

      let expiredCount = 0;
      let expiringSoonCount = 0;
      let expiringIn7DaysCount = 0;

      for (const inventory of inventories) {
        // 检查每个批次的过期状态
        for (const batch of inventory.stockBatches) {
          if (batch.quantity <= 0) continue; // 跳过已用完的批次

          const expiryDate = new Date(batch.expiryDate);
          
          if (expiryDate < now) {
            // 已过期
            expiredCount++;
            await this.createExpiryAlert(inventory, batch, 'expired');
          } else if (expiryDate <= threeDaysLater) {
            // 3天内过期
            expiringSoonCount++;
            await this.createExpiryAlert(inventory, batch, 'expiring_soon');
          } else if (expiryDate <= sevenDaysLater) {
            // 7天内过期
            expiringIn7DaysCount++;
            await this.createExpiryAlert(inventory, batch, 'expiring_in_7_days');
          }
        }
      }

      console.log(`[${this.taskName}] 检查完成: 已过期${expiredCount}个批次，3天内过期${expiringSoonCount}个批次，7天内过期${expiringIn7DaysCount}个批次`);
      
    } catch (error) {
      console.error(`[${this.taskName}] 执行错误:`, error);
    }
  }

  /**
   * 创建过期预警
   */
  async createExpiryAlert(inventory, batch, alertType) {
    try {
      const now = new Date();
      const expiryDate = new Date(batch.expiryDate);
      const daysUntilExpiry = Math.ceil((expiryDate - now) / (24 * 60 * 60 * 1000));
      
      let title, content, priority;
      
      switch (alertType) {
        case 'expired':
          title = '食材已过期';
          content = `食材"${inventory.name}"批次${batch.batchNumber}已过期，请立即处理！过期日期：${expiryDate.toLocaleDateString()}`;
          priority = 'high';
          break;
          
        case 'expiring_soon':
          title = '食材即将过期';
          content = `食材"${inventory.name}"批次${batch.batchNumber}将在${daysUntilExpiry}天后过期，请尽快使用！`;
          priority = 'high';
          break;
          
        case 'expiring_in_7_days':
          title = '食材过期提醒';
          content = `食材"${inventory.name}"批次${batch.batchNumber}将在${daysUntilExpiry}天后过期`;
          priority = 'medium';
          break;
      }

      // 检查是否已发送过相同的预警（避免重复）
      const existingAlert = await Notification.findOne({
        userId: inventory.merchantId.userId,
        type: 'inventory_expiry',
        'metadata.inventoryId': inventory._id,
        'metadata.batchNumber': batch.batchNumber,
        'metadata.alertType': alertType,
        createdAt: { $gte: new Date(now.getTime() - 24 * 60 * 60 * 1000) } // 24小时内
      });

      if (existingAlert) {
        return; // 已发送过，跳过
      }

      // 创建通知
      const notification = new Notification({
        userId: inventory.merchantId.userId,
        type: 'inventory_expiry',
        title,
        content,
        priority,
        relatedId: inventory._id,
        relatedModel: 'IngredientInventory',
        metadata: {
          inventoryId: inventory._id,
          ingredientName: inventory.name,
          batchNumber: batch.batchNumber,
          expiryDate: expiryDate,
          quantity: batch.quantity,
          unit: batch.unit,
          alertType,
          daysUntilExpiry
        }
      });
      
      await notification.save();
      
      // 通过WebSocket发送实时通知
      await inventoryWebSocketService.io.of('/inventory')
        .to(`store-${inventory.merchantId._id}`)
        .emit('expiryAlert', {
          type: alertType,
          inventory: {
            id: inventory._id,
            name: inventory.name
          },
          batch: {
            batchNumber: batch.batchNumber,
            expiryDate,
            quantity: batch.quantity,
            unit: batch.unit
          },
          daysUntilExpiry,
          timestamp: now
        });

      console.log(`[${this.taskName}] 发送过期预警: ${inventory.name} - 批次${batch.batchNumber} - ${title}`);
      
    } catch (error) {
      console.error(`[${this.taskName}] 创建过期预警失败:`, error);
    }
  }

  /**
   * 清理过期批次（可选功能）
   */
  async cleanupExpiredBatches() {
    try {
      console.log(`[${this.taskName}] 开始清理过期批次...`);
      
      const result = await IngredientInventory.updateMany(
        {
          isActive: true,
          'stockBatches.expiryDate': { $lt: new Date() }
        },
        {
          $pull: {
            stockBatches: {
              expiryDate: { $lt: new Date() },
              quantity: { $lte: 0 }
            }
          }
        }
      );
      
      console.log(`[${this.taskName}] 清理完成: 更新了${result.modifiedCount}个库存记录`);
      
    } catch (error) {
      console.error(`[${this.taskName}] 清理过期批次失败:`, error);
    }
  }
}

module.exports = new ExpiryAlertJob();