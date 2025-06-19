/**
 * 自动补货定时任务
 * 定期检查库存状态，根据预设条件自动生成补货建议或订单
 */
const cron = require('node-cron');
const { IngredientInventory, STOCK_STATUS } = require('../models/merchant/ingredientInventoryModel');
const { Notification } = require('../models/notification/notificationModel');
const inventoryWebSocketService = require('../services/websocket/inventoryWebSocketService');

class AutoReorderJob {
  constructor() {
    this.taskName = 'AutoReorderJob';
    this.cronExpression = '0 */6 * * *'; // 每6小时执行一次
  }

  /**
   * 启动定时任务
   */
  start() {
    console.log(`[${this.taskName}] 启动自动补货检查任务...`);
    
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
      console.log(`[${this.taskName}] 停止自动补货检查任务`);
    }
  }

  /**
   * 执行任务
   */
  async execute() {
    console.log(`[${this.taskName}] 开始执行自动补货检查...`);
    
    try {
      // 获取所有需要检查的库存
      const inventories = await IngredientInventory.find({
        isActive: true,
        'autoReorderSettings.enabled': true
      }).populate('merchantId');

      let processedCount = 0;
      let reorderCount = 0;

      for (const inventory of inventories) {
        processedCount++;
        
        const shouldReorder = await this.checkReorderConditions(inventory);
        if (shouldReorder) {
          reorderCount++;
          await this.createReorderSuggestion(inventory);
        }
      }

      console.log(`[${this.taskName}] 处理完成: 检查${processedCount}个库存，生成${reorderCount}个补货建议`);
      
    } catch (error) {
      console.error(`[${this.taskName}] 执行错误:`, error);
    }
  }

  /**
   * 检查是否需要补货
   */
  async checkReorderConditions(inventory) {
    // 检查库存状态
    if (inventory.status === STOCK_STATUS.OUT) {
      return true;
    }

    // 检查是否低于重新订购点
    if (inventory.reorderPoint && inventory.availableStock <= inventory.reorderPoint) {
      return true;
    }

    // 检查自定义条件
    if (inventory.autoReorderSettings.conditions) {
      for (const condition of inventory.autoReorderSettings.conditions) {
        switch (condition.type) {
          case 'low_stock':
            if (inventory.availableStock <= condition.threshold) {
              return true;
            }
            break;
            
          case 'out_of_stock':
            if (inventory.availableStock === 0) {
              return true;
            }
            break;
            
          case 'time_based':
            // 基于消耗率和剩余天数
            if (inventory.usageStats.dailyConsumption > 0) {
              const daysRemaining = inventory.availableStock / inventory.usageStats.dailyConsumption;
              if (daysRemaining <= condition.threshold) {
                return true;
              }
            }
            break;
        }
      }
    }

    return false;
  }

  /**
   * 创建补货建议
   */
  async createReorderSuggestion(inventory) {
    try {
      // 计算建议补货数量
      let suggestedQuantity = inventory.reorderQuantity || 0;
      
      if (suggestedQuantity === 0) {
        // 如果没有预设的补货数量，根据最优库存水平计算
        if (inventory.optimalLevel) {
          suggestedQuantity = inventory.optimalLevel - inventory.availableStock;
        } else {
          // 否则使用日均消耗量 * 30天作为参考
          suggestedQuantity = (inventory.usageStats.dailyConsumption || 0) * 30;
        }
      }

      // 确保不超过最大库存容量
      const maxOrderQuantity = inventory.maxCapacity - inventory.totalStock;
      suggestedQuantity = Math.min(suggestedQuantity, maxOrderQuantity);

      // 获取推荐供应商
      const preferredSupplier = this.getPreferredSupplier(inventory);
      
      // 估算成本
      const estimatedCost = suggestedQuantity * (preferredSupplier?.pricePerUnit || 
        inventory.costAnalysis.averagePurchasePrice || 0);

      // 创建补货建议
      const reorderSuggestion = {
        inventoryId: inventory._id,
        ingredientName: inventory.name,
        currentStock: inventory.availableStock,
        suggestedQuantity,
        estimatedCost,
        supplier: preferredSupplier,
        reason: this.getReorderReason(inventory),
        urgency: this.calculateUrgency(inventory)
      };

      // 创建通知
      await this.createReorderNotification(inventory, reorderSuggestion);
      
      // 通过WebSocket发送实时通知
      await inventoryWebSocketService.io.of('/inventory')
        .to(`store-${inventory.merchantId._id}`)
        .emit('reorderSuggestion', reorderSuggestion);

      console.log(`[${this.taskName}] 生成补货建议: ${inventory.name} - 建议补货${suggestedQuantity}${inventory.stockBatches[0]?.unit || '个'}`);
      
    } catch (error) {
      console.error(`[${this.taskName}] 创建补货建议失败:`, error);
    }
  }

  /**
   * 获取首选供应商
   */
  getPreferredSupplier(inventory) {
    if (!inventory.suppliers || inventory.suppliers.length === 0) {
      return null;
    }

    // 首先查找主要供应商
    const primarySupplier = inventory.suppliers.find(s => s.isPrimary && s.isActive);
    if (primarySupplier) {
      return primarySupplier;
    }

    // 否则选择评分最高的活跃供应商
    const activeSuppliers = inventory.suppliers.filter(s => s.isActive);
    if (activeSuppliers.length === 0) {
      return null;
    }

    return activeSuppliers.reduce((best, current) => {
      const currentScore = (current.qualityRating || 0) + (current.reliabilityRating || 0);
      const bestScore = (best.qualityRating || 0) + (best.reliabilityRating || 0);
      return currentScore > bestScore ? current : best;
    });
  }

  /**
   * 获取补货原因
   */
  getReorderReason(inventory) {
    if (inventory.status === STOCK_STATUS.OUT) {
      return '库存已耗尽';
    }
    
    if (inventory.status === STOCK_STATUS.CRITICAL) {
      return '库存严重不足';
    }
    
    if (inventory.status === STOCK_STATUS.LOW) {
      return '库存偏低';
    }
    
    if (inventory.usageStats.dailyConsumption > 0) {
      const daysRemaining = inventory.availableStock / inventory.usageStats.dailyConsumption;
      if (daysRemaining < 7) {
        return `预计${Math.floor(daysRemaining)}天内耗尽`;
      }
    }
    
    return '达到补货点';
  }

  /**
   * 计算紧急程度
   */
  calculateUrgency(inventory) {
    if (inventory.status === STOCK_STATUS.OUT) {
      return 'critical';
    }
    
    if (inventory.status === STOCK_STATUS.CRITICAL) {
      return 'high';
    }
    
    if (inventory.usageStats.dailyConsumption > 0) {
      const daysRemaining = inventory.availableStock / inventory.usageStats.dailyConsumption;
      if (daysRemaining < 3) {
        return 'high';
      } else if (daysRemaining < 7) {
        return 'medium';
      }
    }
    
    return 'low';
  }

  /**
   * 创建补货通知
   */
  async createReorderNotification(inventory, suggestion) {
    try {
      const notification = new Notification({
        userId: inventory.merchantId.userId,
        type: 'inventory_reorder',
        title: '库存补货提醒',
        content: `食材"${inventory.name}"需要补货，当前库存：${suggestion.currentStock}，建议补货：${suggestion.suggestedQuantity}`,
        priority: suggestion.urgency === 'critical' ? 'high' : 'medium',
        relatedId: inventory._id,
        relatedModel: 'IngredientInventory',
        metadata: {
          inventoryId: inventory._id,
          ingredientName: inventory.name,
          currentStock: suggestion.currentStock,
          suggestedQuantity: suggestion.suggestedQuantity,
          estimatedCost: suggestion.estimatedCost,
          urgency: suggestion.urgency
        }
      });
      
      await notification.save();
      
    } catch (error) {
      console.error(`[${this.taskName}] 创建补货通知失败:`, error);
    }
  }
}

module.exports = new AutoReorderJob();