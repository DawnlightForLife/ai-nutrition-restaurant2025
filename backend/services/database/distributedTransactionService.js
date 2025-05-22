/**
 * 分布式事务服务模块
 * 提供跨分片事务支持，保障多数据库/集合操作的一致性和可恢复性
 * 实现两阶段提交协议、回滚机制、事务恢复机制与状态查询能力
 * 管理活跃事务生命周期，并进行统计与审计
 * @module services/core/distributedTransactionService
 */

const mongoose = require('mongoose');
const EventEmitter = require('events');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../../config');
const transactionService = require('./transactionService');
const shardingService = require('./shardingService');

/**
 * 分布式事务状态枚举
 * @enum {string}
 */
const DistributedTxnState = {
  // 准备阶段
  PREPARING: 'PREPARING',
  
  // 已提交
  COMMITTED: 'COMMITTED',
  
  // 已中止
  ABORTED: 'ABORTED',
  
  // 已回滚
  ROLLED_BACK: 'ROLLED_BACK',
  
  // 部分完成（需要恢复）
  PARTIAL: 'PARTIAL'
};

class DistributedTransactionService extends EventEmitter {
  constructor() {
    super();
    
    // 配置
    this.config = {
      enabled: config.database?.enableDistributedTransactions || false,
      maxTransactionLifetimeSecs: config.database?.maxTransactionLifetimeSecs || 60,
      recoveryInterval: config.database?.transactionRecoveryIntervalMs || 60000, // 1分钟
      maxRetries: config.database?.transactionRetries || 3,
      retryDelayMs: config.database?.transactionRetryDelayMs || 500,
      useTwoPhaseCommit: config.database?.useTwoPhaseCommit || true
    };
    
    // 活跃的分布式事务
    this.activeTransactions = new Map();
    
    // 恢复定时器
    this.recoveryTimer = null;
    
    // 统计数据
    this.stats = {
      totalTransactions: 0,
      successfulTransactions: 0,
      failedTransactions: 0,
      recoveredTransactions: 0,
      averageTransactionTime: 0,
      totalTransactionTime: 0
    };
    
    // 启动恢复进程
    if (this.config.enabled) {
      this._startRecoveryProcess();
      this._setupTransactionModel();
      logger.info('分布式事务服务已初始化');
    } else {
      logger.info('分布式事务服务已初始化，但未启用');
    }
  }
  
  /**
   * 设置事务模型
   * @private
   */
  async _setupTransactionModel() {
    try {
      // 检查分布式事务集合是否存在，如果不存在则创建
      const db = mongoose.connection.db;
      const collections = await db.listCollections({ name: 'distributed_transactions' }).toArray();
      
      if (collections.length === 0) {
        logger.info('创建分布式事务集合');
        
        // 创建集合
        await db.createCollection('distributed_transactions');
        
        // 创建索引
        await db.collection('distributed_transactions').createIndex(
          { transactionId: 1 },
          { unique: true }
        );
        
        await db.collection('distributed_transactions').createIndex(
          { state: 1, createdAt: 1 }
        );
        
        logger.info('分布式事务集合已创建并索引');
      }
    } catch (error) {
      logger.error('设置分布式事务集合时出错', { error });
    }
  }
  
  /**
   * 开始恢复进程
   * @private
   */
  _startRecoveryProcess() {
    this.recoveryTimer = setInterval(() => {
      this._recoverIncompleteTransactions().catch(err => {
        logger.error('恢复分布式事务时出错', { error: err });
      });
    }, this.config.recoveryInterval);
    
    logger.info('分布式事务恢复进程已启动，间隔:', this.config.recoveryInterval / 1000, '秒');
  }
  
  /**
   * 恢复未完成的事务
   * @private
   * @returns {Promise<void>}
   */
  async _recoverIncompleteTransactions() {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        return;
      }
      
      const db = mongoose.connection.db;
      const now = new Date();
      const cutoffTime = new Date(now.getTime() - (this.config.maxTransactionLifetimeSecs * 1000));
      
      // 查找未完成的事务
      const incompleteTransactions = await db.collection('distributed_transactions').find({
        state: { $in: [DistributedTxnState.PREPARING, DistributedTxnState.PARTIAL] },
        createdAt: { $lt: cutoffTime }
      }).toArray();
      
      logger.info(`发现 ${incompleteTransactions.length} 个未完成的分布式事务需要恢复`);
      
      for (const txn of incompleteTransactions) {
        try {
          // 对于准备中的事务，尝试回滚
          if (txn.state === DistributedTxnState.PREPARING) {
            await this._rollbackTransaction(txn);
          } 
          // 对于部分完成的事务，根据预备日志决定提交或回滚
          else if (txn.state === DistributedTxnState.PARTIAL) {
            if (txn.prepareCommitted) {
              await this._completeCommit(txn);
            } else {
              await this._rollbackTransaction(txn);
            }
          }
          
          this.stats.recoveredTransactions++;
          this.emit('transaction_recovered', { transactionId: txn.transactionId });
        } catch (error) {
          logger.error(`恢复事务 ${txn.transactionId} 时出错`, { error });
        }
      }
    } catch (error) {
      logger.error('查询未完成事务时出错', { error });
      throw error;
    }
  }
  
  /**
   * 创建分布式事务
   * @param {Object} options - 事务选项
   * @returns {Promise<Object>} 事务和上下文对象
   */
  async createTransaction(options = {}) {
    if (!this.config.enabled) {
      throw new Error('分布式事务服务未启用');
    }
    
    // 生成事务ID
    const transactionId = `dtx_${Date.now()}_${Math.random().toString(36).substring(2, 10)}`;
    
    // 创建事务记录
    const txnRecord = {
      transactionId,
      shards: options.shards || [],
      operations: [],
      state: DistributedTxnState.PREPARING,
      prepareCommitted: false,
      createdAt: new Date(),
      updatedAt: new Date(),
      metadata: options.metadata || {}
    };
    
    // 保存事务记录
    await mongoose.connection.db.collection('distributed_transactions').insertOne(txnRecord);
    
    // 记录到活跃事务表中
    this.activeTransactions.set(transactionId, {
      record: txnRecord,
      sessions: new Map(),
      startTime: Date.now()
    });
    
    logger.info(`创建分布式事务: ${transactionId}`);
    this.emit('transaction_created', { transactionId });
    
    return {
      transactionId,
      context: {
        shards: txnRecord.shards,
        metadata: txnRecord.metadata
      }
    };
  }
  
  /**
   * 在多个分片上执行分布式事务
   * @param {Array<string>} shards - 分片名称或键
   * @param {Function} operationFn - 操作函数，接收事务上下文和分片会话映射
   * @param {Object} options - 选项
   * @returns {Promise<any>} 操作结果
   */
  async executeAcrossShards(shards, operationFn, options = {}) {
    if (!this.config.enabled) {
      throw new Error('分布式事务服务未启用');
    }
    
    if (!shards || !Array.isArray(shards) || shards.length === 0) {
      throw new Error('必须提供至少一个分片');
    }
    
    const startTime = Date.now();
    const { transactionId, context } = await this.createTransaction({
      shards,
      metadata: options.metadata
    });
    
    // 更新统计信息
    this.stats.totalTransactions++;
    
    try {
      // 使用两阶段提交协议
      if (this.config.useTwoPhaseCommit) {
        return await this._executeTwoPhaseCommit(transactionId, shards, operationFn, options);
      } else {
        // 单阶段提交，适用于简单场景
        return await this._executeSinglePhaseCommit(transactionId, shards, operationFn, options);
      }
    } catch (error) {
      // 记录失败并尝试回滚
      this.stats.failedTransactions++;
      
      // 将事务状态更新为已中止
      await this._updateTransactionState(transactionId, DistributedTxnState.ABORTED);
      
      // 尝试回滚
      try {
        const activeTxn = this.activeTransactions.get(transactionId);
        if (activeTxn) {
          await this._rollbackTransaction({
            transactionId,
            operations: activeTxn.record.operations
          });
        }
      } catch (rollbackError) {
        logger.error(`回滚事务 ${transactionId} 时出错`, { error: rollbackError });
        // 设置为部分完成，等待恢复进程处理
        await this._updateTransactionState(transactionId, DistributedTxnState.PARTIAL);
      }
      
      logger.error(`分布式事务 ${transactionId} 执行失败:`, { error });
      this.emit('transaction_failed', { 
        transactionId, 
        error: error.message 
      });
      
      throw error;
    } finally {
      // 计算事务持续时间
      const duration = Date.now() - startTime;
      this.stats.totalTransactionTime += duration;
      this.stats.averageTransactionTime = 
        this.stats.totalTransactionTime / this.stats.totalTransactions;
      
      // 从活跃事务表中删除
      const activeTxn = this.activeTransactions.get(transactionId);
      if (activeTxn) {
        // 结束所有会话
        for (const [shardName, session] of activeTxn.sessions.entries()) {
          try {
            session.endSession();
          } catch (error) {
            logger.error(`结束分片 ${shardName} 会话时出错`, { error });
          }
        }
        
        this.activeTransactions.delete(transactionId);
      }
    }
  }
  
  /**
   * 执行两阶段提交
   * @private
   * @param {string} transactionId - 事务ID
   * @param {Array<string>} shards - 分片名称或键
   * @param {Function} operationFn - 操作函数
   * @param {Object} options - 选项
   * @returns {Promise<any>} 操作结果
   */
  async _executeTwoPhaseCommit(transactionId, shards, operationFn, options) {
    // 第一阶段：准备
    const shardSessions = new Map();
    const results = new Map();
    let success = true;
    
    // 为每个分片准备会话和事务
    for (const shardKey of shards) {
      try {
        const { session } = await transactionService.startTransaction();
        shardSessions.set(shardKey, session);
        
        // 记录到活跃事务中
        const activeTxn = this.activeTransactions.get(transactionId);
        if (activeTxn) {
          activeTxn.sessions.set(shardKey, session);
        }
      } catch (error) {
        success = false;
        logger.error(`为分片 ${shardKey} 创建事务时出错`, { error });
        break;
      }
    }
    
    if (!success) {
      // 中止所有已创建的会话
      for (const session of shardSessions.values()) {
        try {
          await session.abortTransaction();
          session.endSession();
        } catch (error) {
          logger.error('中止事务会话时出错', { error });
        }
      }
      
      throw new Error('准备事务阶段失败');
    }
    
    try {
      // 执行操作函数，传入分片会话映射
      const result = await operationFn({ transactionId, shardSessions });
      
      // 收集每个分片的操作
      const activeTxn = this.activeTransactions.get(transactionId);
      if (activeTxn) {
        // 记录分片操作
        activeTxn.record.operations = [];
        for (const [shardKey, operations] of Object.entries(result.operations || {})) {
          if (Array.isArray(operations)) {
            activeTxn.record.operations.push(...operations.map(op => ({
              ...op,
              shard: shardKey
            })));
          }
        }
        
        // 更新事务记录
        await this._updateTransactionOperations(transactionId, activeTxn.record.operations);
      }
      
      // 第二阶段：提交
      await this._updateTransactionState(transactionId, DistributedTxnState.PARTIAL, true);
      
      // 提交每个分片事务
      for (const [shardKey, session] of shardSessions.entries()) {
        try {
          await session.commitTransaction();
          results.set(shardKey, true);
        } catch (error) {
          results.set(shardKey, false);
          success = false;
          logger.error(`提交分片 ${shardKey} 事务时出错`, { error });
        }
      }
      
      // 更新事务状态
      if (success) {
        await this._updateTransactionState(transactionId, DistributedTxnState.COMMITTED);
        this.stats.successfulTransactions++;
        this.emit('transaction_committed', { transactionId });
      } else {
        // 部分提交，需要恢复进程处理
        this.emit('transaction_partial', { 
          transactionId,
          results: Object.fromEntries(results)
        });
      }
      
      return result.data;
    } catch (error) {
      // 操作函数执行失败，中止所有事务
      for (const [shardKey, session] of shardSessions.entries()) {
        try {
          await session.abortTransaction();
        } catch (abortError) {
          logger.error(`中止分片 ${shardKey} 事务时出错`, { error: abortError });
        }
      }
      
      throw error;
    }
  }
  
  /**
   * 执行单阶段提交（简化版，适用于简单场景）
   * @private
   * @param {string} transactionId - 事务ID
   * @param {Array<string>} shards - 分片名称或键
   * @param {Function} operationFn - 操作函数
   * @param {Object} options - 选项
   * @returns {Promise<any>} 操作结果
   */
  async _executeSinglePhaseCommit(transactionId, shards, operationFn, options) {
    // 为每个分片创建会话
    const shardSessions = new Map();
    
    try {
      // 单个会话，简化处理
      const { session } = await transactionService.startTransaction();
      
      for (const shardKey of shards) {
        shardSessions.set(shardKey, session);
      }
      
      // 记录到活跃事务中
      const activeTxn = this.activeTransactions.get(transactionId);
      if (activeTxn) {
        for (const [shardKey, session] of shardSessions.entries()) {
          activeTxn.sessions.set(shardKey, session);
        }
      }
      
      // 执行操作函数
      const result = await operationFn({ transactionId, shardSessions });
      
      // 提交事务
      await session.commitTransaction();
      
      // 更新事务状态
      await this._updateTransactionState(transactionId, DistributedTxnState.COMMITTED);
      
      this.stats.successfulTransactions++;
      this.emit('transaction_committed', { transactionId });
      
      return result.data;
    } catch (error) {
      // 中止所有会话
      const session = shardSessions.values().next().value;
      if (session) {
        try {
          await session.abortTransaction();
        } catch (abortError) {
          logger.error('中止事务时出错', { error: abortError });
        }
      }
      
      throw error;
    } finally {
      // 结束会话
      const session = shardSessions.values().next().value;
      if (session) {
        session.endSession();
      }
    }
  }
  
  /**
   * 更新事务状态
   * @private
   * @param {string} transactionId - 事务ID
   * @param {string} state - 新状态
   * @param {boolean} [prepareCommitted=false] - 准备阶段是否已提交
   * @returns {Promise<void>}
   */
  async _updateTransactionState(transactionId, state, prepareCommitted = false) {
    try {
      await mongoose.connection.db.collection('distributed_transactions').updateOne(
        { transactionId },
        { 
          $set: { 
            state,
            prepareCommitted: prepareCommitted,
            updatedAt: new Date() 
          } 
        }
      );
      
      // 更新内存中的记录
      const activeTxn = this.activeTransactions.get(transactionId);
      if (activeTxn) {
        activeTxn.record.state = state;
        activeTxn.record.prepareCommitted = prepareCommitted;
        activeTxn.record.updatedAt = new Date();
      }
    } catch (error) {
      logger.error(`更新事务 ${transactionId} 状态时出错`, { error });
      throw error;
    }
  }
  
  /**
   * 更新事务操作记录
   * @private
   * @param {string} transactionId - 事务ID
   * @param {Array<Object>} operations - 操作列表
   * @returns {Promise<void>}
   */
  async _updateTransactionOperations(transactionId, operations) {
    try {
      await mongoose.connection.db.collection('distributed_transactions').updateOne(
        { transactionId },
        { 
          $set: { 
            operations,
            updatedAt: new Date() 
          } 
        }
      );
    } catch (error) {
      logger.error(`更新事务 ${transactionId} 操作记录时出错`, { error });
      throw error;
    }
  }
  
  /**
   * 回滚事务
   * @private
   * @param {Object} transaction - 事务记录
   * @returns {Promise<void>}
   */
  async _rollbackTransaction(transaction) {
    logger.info(`开始回滚事务 ${transaction.transactionId}`);
    
    try {
      // 反向执行操作
      const operations = transaction.operations || [];
      const reversedOperations = operations.slice().reverse();
      
      for (const operation of reversedOperations) {
        try {
          await this._executeRollbackOperation(operation);
        } catch (error) {
          logger.error('回滚操作时出错', { error });
          // 继续回滚其他操作
        }
      }
      
      // 更新状态为已回滚
      await this._updateTransactionState(transaction.transactionId, DistributedTxnState.ROLLED_BACK);
      
      logger.info(`事务 ${transaction.transactionId} 已成功回滚`);
      this.emit('transaction_rolled_back', { transactionId: transaction.transactionId });
    } catch (error) {
      logger.error(`回滚事务 ${transaction.transactionId} 时出错`, { error });
      throw error;
    }
  }
  
  /**
   * 执行回滚操作
   * @private
   * @param {Object} operation - 要回滚的操作
   * @returns {Promise<void>}
   */
  async _executeRollbackOperation(operation) {
    const { type, model, documentId, shard, before } = operation;
    
    if (!model || !documentId) {
      return;
    }
    
    try {
      const Model = mongoose.model(model);
      
      switch (type) {
        case 'insert':
          // 插入操作的回滚是删除
          await Model.deleteOne({ _id: documentId });
          break;
          
        case 'update':
          // 更新操作的回滚是恢复到之前的状态
          if (before) {
            await Model.replaceOne({ _id: documentId }, before, { upsert: true });
          }
          break;
          
        case 'delete':
          // 删除操作的回滚是恢复文档
          if (before) {
            await Model.create(before);
          }
          break;
          
        default:
          logger.warn(`未知的操作类型: ${type}`);
      }
    } catch (error) {
      logger.error('回滚操作时出错', { error });
      throw error;
    }
  }
  
  /**
   * 完成提交
   * @private
   * @param {Object} transaction - 事务记录
   * @returns {Promise<void>}
   */
  async _completeCommit(transaction) {
    // 设置为已提交状态
    await this._updateTransactionState(transaction.transactionId, DistributedTxnState.COMMITTED);
    
    logger.info(`事务 ${transaction.transactionId} 恢复为已提交状态`);
    this.emit('transaction_completed', { transactionId: transaction.transactionId });
  }
  
  /**
   * 手动恢复事务
   * @param {string} transactionId - 事务ID
   * @param {string} action - 操作 ('commit' 或 'rollback')
   * @returns {Promise<boolean>} 操作是否成功
   */
  async recoverTransaction(transactionId, action) {
    try {
      // 查找事务记录
      const txnRecord = await mongoose.connection.db.collection('distributed_transactions').findOne({
        transactionId
      });
      
      if (!txnRecord) {
        throw new Error(`事务 ${transactionId} 不存在`);
      }
      
      // 只能恢复处于PARTIAL或PREPARING状态的事务
      if (txnRecord.state !== DistributedTxnState.PARTIAL && 
          txnRecord.state !== DistributedTxnState.PREPARING) {
        throw new Error(`事务 ${transactionId} 状态为 ${txnRecord.state}，无法恢复`);
      }
      
      if (action === 'commit') {
        await this._completeCommit(txnRecord);
        return true;
      } else if (action === 'rollback') {
        await this._rollbackTransaction(txnRecord);
        return true;
      } else {
        throw new Error(`无效的恢复操作: ${action}`);
      }
    } catch (error) {
      logger.error(`手动恢复事务 ${transactionId} 时出错`, { error });
      return false;
    }
  }
  
  /**
   * 获取事务状态
   * @param {string} transactionId - 事务ID
   * @returns {Promise<Object|null>} 事务状态
   */
  async getTransactionStatus(transactionId) {
    try {
      // 首先检查活跃事务
      if (this.activeTransactions.has(transactionId)) {
        const activeTxn = this.activeTransactions.get(transactionId);
        return {
          transactionId,
          state: activeTxn.record.state,
          prepareCommitted: activeTxn.record.prepareCommitted,
          createdAt: activeTxn.record.createdAt,
          updatedAt: activeTxn.record.updatedAt,
          shards: activeTxn.record.shards,
          operationCount: (activeTxn.record.operations || []).length,
          elapsedMs: Date.now() - activeTxn.startTime,
          active: true
        };
      }
      
      // 查找事务记录
      const txnRecord = await mongoose.connection.db.collection('distributed_transactions').findOne({
        transactionId
      });
      
      if (!txnRecord) {
        return null;
      }
      
      return {
        transactionId,
        state: txnRecord.state,
        prepareCommitted: txnRecord.prepareCommitted,
        createdAt: txnRecord.createdAt,
        updatedAt: txnRecord.updatedAt,
        shards: txnRecord.shards,
        operationCount: (txnRecord.operations || []).length,
        active: false
      };
    } catch (error) {
      logger.error(`获取事务 ${transactionId} 状态时出错`, { error });
      return null;
    }
  }
  
  /**
   * 获取服务状态
   * @returns {Object} 服务状态
   */
  getStatus() {
    return {
      enabled: this.config.enabled,
      activeTransactions: this.activeTransactions.size,
      stats: this.stats,
      config: this.config
    };
  }
}

// 创建单例
const distributedTransactionService = new DistributedTransactionService();

// 导出服务和枚举
module.exports = {
  distributedTransactionService,
  DistributedTxnState
}; 