/**
 * 批处理服务模块
 * 用于处理 insertMany / updateMany / deleteMany / bulkWrite 的批量队列优化
 * - 支持按模型+操作类型分批处理
 * - 根据配置设置批次大小和处理间隔
 * - 支持超时批次自动处理和强制刷新
 * - 内部管理 Promise 分发与错误隔离
 * @module services/core/batchProcessService
 */

/**
 * 批处理服务
 * 用于优化大批量数据操作
 */

const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

class BatchProcessService {
  constructor() {
    this.batches = {};
    this.batchSizeLimit = config.database.batchSize || 1000;
    this.batchTimeoutMs = config.database.batchTimeoutMs || 2000;
    this.processingBatches = false;
    
    // 批处理统计
    this.stats = {
      totalOperations: 0,
      totalBatches: 0,
      averageBatchSize: 0,
      successRate: 100,
      lastProcessedAt: null
    };
    
    // 定时处理批次
    this.timer = setInterval(() => this.processAllBatches(), this.batchTimeoutMs);
  }
  
  /**
   * 添加数据库操作到批处理队列
   * @param {string} modelName - Mongoose模型名
   * @param {string} operation - 操作类型：insertMany / updateMany / deleteMany / bulkWrite
   * @param {Object} data - 操作数据（根据操作类型不同格式各异）
   * @param {Object} options - 操作选项，可控制立即执行
   * @returns {Promise<any>} - 操作完成的Promise
   */
  async addToBatch(modelName, operation, data, options = {}) {
    // 如果禁用批处理或强制立即执行
    if (!config.database.enableBatchProcessing || options.immediate) {
      return this.executeOperation(modelName, operation, data, options);
    }
    
    const batchKey = `${modelName}:${operation}`;
    
    // 初始化批次
    if (!this.batches[batchKey]) {
      this.batches[batchKey] = {
        operations: [],
        promises: [],
        resolvers: [],
        rejectors: [],
        createdAt: Date.now(),
        lastUpdatedAt: Date.now()
      };
    }
    
    // 创建用于返回的Promise
    const promise = new Promise((resolve, reject) => {
      // 保存操作
      this.batches[batchKey].operations.push({ data, options });
      // 保存promise resolvers
      this.batches[batchKey].resolvers.push(resolve);
      this.batches[batchKey].rejectors.push(reject);
      // 更新批次时间
      this.batches[batchKey].lastUpdatedAt = Date.now();
    });
    
    // 如果批次大小达到阈值，立即处理
    if (this.batches[batchKey].operations.length >= this.batchSizeLimit) {
      this.processBatch(batchKey).catch(err => {
        logger.error(`处理批次 ${batchKey} 时出错`, { error: err });
      });
    }
    
    return promise;
  }
  
  /**
   * 立即执行数据库操作（不批处理）
   * @param {string} modelName - 模型名称
   * @param {string} operation - 操作类型
   * @param {Object} data - 操作数据
   * @param {Object} options - 操作选项
   * @returns {Promise<Object>} 操作结果
   */
  async executeOperation(modelName, operation, data, options = {}) {
    try {
      // 获取模型
      const Model = mongoose.model(modelName);
      
      if (!Model) {
        throw new Error(`模型 ${modelName} 不存在`);
      }
      
      // 执行操作
      switch (operation) {
        case 'insertMany':
          return await Model.insertMany(data, options);
        
        case 'updateMany':
          return await Model.updateMany(data.filter, data.update, options);
        
        case 'deleteMany':
          return await Model.deleteMany(data, options);
          
        case 'bulkWrite':
          return await Model.bulkWrite(data, options);
          
        default:
          throw new Error(`不支持的操作: ${operation}`);
      }
    } catch (error) {
      logger.error(`执行 ${modelName}.${operation} 操作失败`, { error });
      throw error;
    }
  }
  
  /**
   * 处理指定批次
   * @param {string} batchKey - 批次键
   * @returns {Promise<void>}
   */
  async processBatch(batchKey) {
    if (!this.batches[batchKey] || this.batches[batchKey].operations.length === 0) {
      return;
    }
    
    // 获取批次信息
    const batch = this.batches[batchKey];
    const [modelName, operation] = batchKey.split(':');
    
    // 标记为正在处理
    this.processingBatches = true;
    
    try {
      let result;
      
      // 根据操作类型合并数据
      if (operation === 'insertMany') {
        // 合并所有插入数据
        const documents = batch.operations.flatMap(op => op.data);
        // 合并选项
        const mergedOptions = this._mergeOptions(batch.operations);
        
        // 执行批量插入
        result = await this.executeOperation(modelName, operation, documents, mergedOptions);
        
        // 将结果分配给各个操作的promise
        batch.resolvers.forEach((resolve, index) => {
          const opData = batch.operations[index].data;
          const opResults = Array.isArray(opData) ? 
            result.filter(doc => opData.some(d => this._docMatchesInput(doc, d))) : 
            [result.find(doc => this._docMatchesInput(doc, opData))];
            
          resolve(opResults);
        });
      } else if (operation === 'updateMany') {
        // 批量更新转换为bulkWrite操作
        const bulkOps = batch.operations.map(op => ({
          updateMany: {
            filter: op.data.filter,
            update: op.data.update,
            ...op.options
          }
        }));
        
        // 执行批量写入
        result = await this.executeOperation(modelName, 'bulkWrite', bulkOps, { ordered: false });
        
        // 将结果分配给各个promise
        batch.resolvers.forEach((resolve) => {
          resolve(result);
        });
      } else if (operation === 'deleteMany') {
        // 合并删除条件
        const filters = batch.operations.map(op => op.data);
        
        // 如果过滤条件简单，可以合并
        if (filters.every(f => Object.keys(f).length === 1 && f._id)) {
          // 提取所有ID
          const ids = filters.flatMap(f => Array.isArray(f._id) ? f._id : [f._id]);
          const mergedFilter = { _id: { $in: ids } };
          
          // 执行批量删除
          result = await this.executeOperation(modelName, operation, mergedFilter);
          
          // 解决所有promise
          batch.resolvers.forEach(resolve => {
            resolve(result);
          });
        } else {
          // 条件复杂，单独处理每个删除操作
          const results = [];
          for (let i = 0; i < batch.operations.length; i++) {
            const op = batch.operations[i];
            try {
              const opResult = await this.executeOperation(modelName, operation, op.data, op.options);
              results.push(opResult);
              batch.resolvers[i](opResult);
            } catch (error) {
              batch.rejectors[i](error);
            }
          }
          result = results;
        }
      } else if (operation === 'bulkWrite') {
        // 合并所有批量写操作
        const bulkOps = batch.operations.flatMap(op => op.data);
        
        // 合并选项
        const mergedOptions = this._mergeOptions(batch.operations, { ordered: false });
        
        // 执行批量操作
        result = await this.executeOperation(modelName, operation, bulkOps, mergedOptions);
        
        // 通知所有promise
        batch.resolvers.forEach(resolve => {
          resolve(result);
        });
      }
      
      // 更新统计信息
      this._updateStats(batch.operations.length);
      
      // 处理完成，删除批次
      delete this.batches[batchKey];
      
    } catch (error) {
      logger.error(`处理批次 ${batchKey} 失败`, { error });
      
      // 拒绝所有promise
      batch.rejectors.forEach(reject => {
        reject(error);
      });
      
      // 删除批次
      delete this.batches[batchKey];
    } finally {
      this.processingBatches = false;
    }
  }
  
  /**
   * 处理所有待处理批次
   * @returns {Promise<void>}
   */
  async processAllBatches() {
    if (this.processingBatches) {
      return;
    }
    
    const batchKeys = Object.keys(this.batches);
    if (batchKeys.length === 0) {
      return;
    }
    
    // 标记为正在处理
    this.processingBatches = true;
    
    try {
      // 并发处理所有批次
      await Promise.all(
        batchKeys.map(key => this.processBatch(key))
      );
    } catch (error) {
      logger.error('处理批次时出错', { error });
    } finally {
      this.processingBatches = false;
    }
  }
  
  /**
   * 强制立即处理所有批次
   * @returns {Promise<Object>} 处理统计
   */
  async flushAllBatches() {
    await this.processAllBatches();
    return this.getStats();
  }
  
  /**
   * 获取批处理统计信息
   * @returns {Object} 统计信息
   */
  getStats() {
    return {
      ...this.stats,
      pendingBatches: Object.keys(this.batches).length,
      pendingOperations: Object.values(this.batches).reduce(
        (total, batch) => total + batch.operations.length, 0
      )
    };
  }
  
  /**
   * 更新统计信息
   * @param {number} operationsCount - 操作数量
   * @private
   */
  _updateStats(operationsCount) {
    this.stats.totalOperations += operationsCount;
    this.stats.totalBatches += 1;
    this.stats.averageBatchSize = this.stats.totalOperations / this.stats.totalBatches;
    this.stats.lastProcessedAt = new Date();
  }
  
  /**
   * 合并操作选项
   * @param {Array<{data: any, options: Object}>} operations - 操作列表
   * @param {Object} [defaultOptions={}] - 默认选项
   * @returns {Object} 合并后的选项
   * @private
   */
  _mergeOptions(operations, defaultOptions = {}) {
    const merged = { ...defaultOptions };
    
    // 提取所有选项
    operations.forEach(op => {
      if (op.options) {
        Object.keys(op.options).forEach(key => {
          // 优先保留已存在的选项
          if (!(key in merged)) {
            merged[key] = op.options[key];
          }
        });
      }
    });
    
    return merged;
  }
  
  /**
   * 检查文档是否匹配输入数据
   * @param {Object} doc - 文档
   * @param {Object} input - 输入数据
   * @returns {boolean} 是否匹配
   * @private
   */
  _docMatchesInput(doc, input) {
    if (!doc || !input) return false;
    
    // 如果input有_id，检查是否匹配
    if (input._id) {
      const inputId = input._id.toString();
      const docId = doc._id.toString();
      return inputId === docId;
    }
    
    // 否则检查关键字段是否匹配
    const keyFields = Object.keys(input).filter(k => 
      !k.startsWith('_') && typeof input[k] !== 'object'
    );
    
    return keyFields.every(key => doc[key] === input[key]);
  }
  
  /**
   * 清理并关闭服务
   */
  cleanup() {
    clearInterval(this.timer);
    return this.processAllBatches();
  }
}

// 创建单例
const batchProcessService = new BatchProcessService();

// 单例导出，确保全局共享批处理上下文
module.exports = batchProcessService; 