/**
 * TransactionService（事务管理服务）
 * 统一封装 MongoDB 事务操作，提供原子性执行能力
 * 支持事务启动、提交、回滚、超时清理、操作统计等功能
 * 封装了用户数据、营养档案、订单的原子写入逻辑
 * 提供 withTransaction / processOrderTransaction / updateNutritionDataTransaction 等高阶事务执行接口
 * @module services/core/transactionService
 */
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

/**
 * 事务管理服务
 * 用于管理MongoDB事务，确保数据操作的原子性
 */
class TransactionService {
  constructor() {
    this.stats = {
      totalTransactions: 0,
      successfulTransactions: 0,
      failedTransactions: 0,
      averageTransactionTime: 0,
      totalTransactionTime: 0
    };
    
    this.activeTransactions = new Map();
    this.transactionCounter = 0;
  }
  
  /**
   * 开始一个新事务
   * @param {Object} options - 事务选项
   * @returns {Object} 事务对象和会话
   */
  async startTransaction(options = {}) {
    try {
      const session = await mongoose.startSession();
      session.startTransaction(options);
      
      // 生成事务ID
      const transactionId = `txn_${Date.now()}_${++this.transactionCounter}`;
      
      // 记录活跃事务
      this.activeTransactions.set(transactionId, {
        session,
        startTime: Date.now(),
        operations: 0,
        status: 'active'
      });
      
      return {
        transactionId,
        session
      };
    } catch (error) {
      logger.error('启动事务失败', { error });
      throw new Error(`启动事务失败: ${error.message}`);
    }
  }
  
  /**
   * 在事务中执行数据库操作
   * @param {Function} operationFn - 要执行的操作函数，接收session作为参数
   * @param {Object} options - 事务选项
   * @returns {any} 操作结果
   */
  async withTransaction(operationFn, options = {}) {
    const { transactionId, session } = await this.startTransaction(options);
    const startTime = Date.now();
    
    try {
      // 执行操作函数
      const result = await operationFn(session);
      
      // 提交事务
      await this.commitTransaction(transactionId);
      
      // 更新统计信息
      this._updateStats({
        success: true,
        duration: Date.now() - startTime
      });
      
      return result;
    } catch (error) {
      // 回滚事务
      await this.abortTransaction(transactionId);
      
      // 更新统计信息
      this._updateStats({
        success: false,
        duration: Date.now() - startTime,
        error
      });
      
      logger.error(`事务 ${transactionId} 执行失败`, { error });
      throw error;
    } finally {
      // 确保会话结束
      if (this.activeTransactions.has(transactionId)) {
        const txnInfo = this.activeTransactions.get(transactionId);
        txnInfo.session.endSession();
        this.activeTransactions.delete(transactionId);
      }
    }
  }
  
  /**
   * 提交事务
   * @param {string} transactionId - 事务ID
   * @returns {boolean} 提交是否成功
   */
  async commitTransaction(transactionId) {
    if (!this.activeTransactions.has(transactionId)) {
      throw new Error(`未找到事务: ${transactionId}`);
    }
    
    const txnInfo = this.activeTransactions.get(transactionId);
    
    try {
      await txnInfo.session.commitTransaction();
      txnInfo.status = 'committed';
      logger.debug(`事务 ${transactionId} 已提交`);
      return true;
    } catch (error) {
      txnInfo.status = 'failed';
      logger.error(`提交事务 ${transactionId} 失败`, { error });
      throw error;
    }
  }
  
  /**
   * 中止事务
   * @param {string} transactionId - 事务ID
   * @returns {boolean} 中止是否成功
   */
  async abortTransaction(transactionId) {
    if (!this.activeTransactions.has(transactionId)) {
      logger.warn(`尝试中止不存在的事务: ${transactionId}`);
      return false;
    }
    
    const txnInfo = this.activeTransactions.get(transactionId);
    
    try {
      await txnInfo.session.abortTransaction();
      txnInfo.status = 'aborted';
      logger.debug(`事务 ${transactionId} 已中止`);
      return true;
    } catch (error) {
      logger.error(`中止事务 ${transactionId} 失败`, { error });
      return false;
    }
  }
  
  /**
   * 执行原子性订单处理事务
   * @param {Object} orderData - 订单数据
   * @param {Function} customLogic - 自定义事务逻辑
   * @returns {Object} 处理结果
   */
  async processOrderTransaction(orderData, customLogic = null) {
    return this.withTransaction(async (session) => {
      // 1. 创建订单
      const Order = mongoose.model('Order');
      const order = new Order(orderData);
      await order.save({ session });
      
      // 2. 更新商品库存
      if (orderData.items && orderData.items.length > 0) {
        const Dish = mongoose.model('Dish');
        for (const item of orderData.items) {
          await Dish.updateOne(
            { _id: item.dishId },
            { $inc: { stock: -item.quantity } },
            { session }
          );
        }
      }
      
      // 3. 更新商家订单统计
      if (orderData.merchantId) {
        const MerchantStats = mongoose.model('MerchantStats');
        await MerchantStats.updateOne(
          { merchantId: orderData.merchantId },
          { 
            $inc: { 
              totalOrders: 1,
              totalAmount: orderData.totalAmount 
            }
          },
          { upsert: true, session }
        );
      }
      
      // 4. 执行自定义逻辑(如果有)
      if (customLogic && typeof customLogic === 'function') {
        await customLogic(session, order);
      }
      
      return order;
    });
  }
  
  /**
   * 执行用户健康数据更新事务
   * @param {string} userId - 用户ID
   * @param {Object} healthData - 健康数据
   * @returns {Object} 处理结果
   */
  async updateNutritionDataTransaction(userId, nutritionData) {
    return this.withTransaction(async (session) => {
      // 1. 保存营养数据
      const NutritionData = mongoose.model('NutritionData');
      const User = mongoose.model('User');
      
      const newNutritionData = new NutritionProfile({
        userId,
        ...nutritionData
      });
      
      const savedNutritionData = await newNutritionData.save({ session });
      
      // 2. 更新用户基本营养信息
      if (nutritionData.basicMetrics) {
        const updateData = {};
        
        if (nutritionData.basicMetrics.height) {
          updateData.height = nutritionData.basicMetrics.height;
        }
        
        if (nutritionData.basicMetrics.weight) {
          updateData.weight = nutritionData.basicMetrics.weight;
        }
        
        if (Object.keys(updateData).length > 0) {
          await User.updateOne(
            { _id: userId },
            { $set: updateData },
            { session }
          );
        }
      }
      
      // 3. 触发营养档案更新
      const NutritionProfile = mongoose.model('NutritionProfile');
      await NutritionProfile.updateOne(
        { userId },
        { 
          $set: { 
            lastHealthDataUpdate: new Date(),
            needsRecalculation: true
          }
        },
        { upsert: true, session }
      );
      
      return savedHealthData;
    });
  }
  
  /**
   * 更新统计信息
   * @param {Object} data - 统计数据
   * @private
   */
  _updateStats(data) {
    this.stats.totalTransactions++;
    
    if (data.success) {
      this.stats.successfulTransactions++;
    } else {
      this.stats.failedTransactions++;
    }
    
    this.stats.totalTransactionTime += data.duration;
    this.stats.averageTransactionTime = this.stats.totalTransactionTime / this.stats.totalTransactions;
  }
  
  /**
   * 获取统计信息
   * @returns {Object} 统计信息
   */
  getStats() {
    return {
      ...this.stats,
      activeTransactions: this.activeTransactions.size,
      successRate: this.stats.totalTransactions > 0 
        ? (this.stats.successfulTransactions / this.stats.totalTransactions) * 100 
        : 0
    };
  }
  
  /**
   * 清理过期的事务
   * @param {number} maxAgeSecs - 最大事务存活时间(秒)
   */
  cleanupStaleTransactions(maxAgeSecs = 300) {
    const now = Date.now();
    const maxAge = maxAgeSecs * 1000;
    
    for (const [txnId, txnInfo] of this.activeTransactions.entries()) {
      if (now - txnInfo.startTime > maxAge) {
        logger.warn(`检测到过期事务 ${txnId}，状态: ${txnInfo.status}，尝试中止并清理`);
        
        try {
          if (txnInfo.status === 'active') {
            txnInfo.session.abortTransaction();
          }
          txnInfo.session.endSession();
          this.activeTransactions.delete(txnId);
        } catch (error) {
          logger.error(`清理过期事务 ${txnId} 失败`, { error });
        }
      }
    }
  }
}

// 创建单例
const transactionService = new TransactionService();

// 定期清理过期事务
setInterval(() => {
  transactionService.cleanupStaleTransactions();
}, 60000); // 每分钟检查一次

module.exports = transactionService;