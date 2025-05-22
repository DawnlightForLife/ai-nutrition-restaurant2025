const mongoose = require('mongoose');
const config = require('../../config/index');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 数据库连接管理器
 * 处理MongoDB连接、读写分离和重连逻辑
 */
class DatabaseManager {
  constructor() {
    this.connections = {
      primary: null,  // 主连接（写操作）
      replica: null   // 副本集连接（读操作）
    };
    
    // 基础连接选项
    this.connectionOptions = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      autoIndex: process.env.NODE_ENV !== 'production',
      connectTimeoutMS: config.database.connectTimeoutMS || 10000,
      socketTimeoutMS: config.database.socketTimeoutMS || 45000,
      serverSelectionTimeoutMS: config.database.serverSelectionTimeoutMS || 10000,
      // 连接池配置
      maxPoolSize: config.database.poolSize || 10,
      minPoolSize: config.database.minPoolSize || 1,
      // 错误重试
      retryWrites: config.database.retryWrites !== false,
      retryReads: config.database.retryReads !== false
    };
    
    this.isConnected = false;
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = config.database.maxReconnectAttempts || 10;
    
    // 当前重连任务
    this.reconnectTasks = {
      primary: null,
      replica: null
    };
    
    // 连接状态监控
    this.connectionStatus = {
      lastPing: Date.now(),
      healthy: true
    };
    
    // 设置监控间隔（2分钟检查一次）
    if (process.env.NODE_ENV === 'production') {
      this.healthCheckInterval = setInterval(() => this.checkConnectionHealth(), 120000);
    }
    
    // 连接池使用统计
    this.poolStats = {
      primary: {
        available: 0,
        used: 0,
        pending: 0,
        max: this.connectionOptions.maxPoolSize
      },
      replica: {
        available: 0,
        used: 0,
        pending: 0,
        max: this.connectionOptions.maxPoolSize
      },
      lastCheck: Date.now(),
      history: []
    };
    
    // 自适应连接池检查间隔（30秒检查一次）
    if (config.database.enableAdaptivePool) {
      this.adaptivePoolInterval = setInterval(() => this.adjustPoolSize(), 30000);
    }
  }

  /**
   * 初始化所有数据库连接
   * @returns {Promise<boolean>} 连接是否成功
   */
  async init() {
    try {
      // 设置默认连接
      await this.connectPrimary();
      
      // 如果配置了读写分离，创建副本连接
      if (config.database.useSplitConnections) {
        await this.connectReplica();
        logger.info('数据库读写分离模式已启用');
      } else {
        logger.info('数据库使用单一连接模式');
      }
      
      this.setupConnectionEvents();
      this.isConnected = true;
      
      // 如果配置了日志记录连接详情
      if (config.database.logConnection) {
        this.logConnectionInfo();
      }
      
      // 启动连接池监控
      await this.updatePoolStats();
      
      return true;
    } catch (error) {
      logger.error('数据库连接初始化失败:', error);
      return false;
    }
  }
  
  /**
   * 记录连接信息
   */
  logConnectionInfo() {
    const primaryConn = mongoose.connection;
    
    logger.info('数据库连接信息:', {
      readyState: primaryConn.readyState,
      host: primaryConn.host,
      name: primaryConn.name,
      port: primaryConn.port,
      models: Object.keys(primaryConn.models).length,
      collections: primaryConn.collections ? Object.keys(primaryConn.collections).length : 0
    });
    
    if (this.connections.replica) {
      logger.info('副本集连接信息:', {
        readyState: this.connections.replica.readyState,
        host: this.connections.replica.host,
        name: this.connections.replica.name,
        port: this.connections.replica.port,
        models: Object.keys(this.connections.replica.models).length
      });
    }
  }

  /**
   * 检查连接健康状态
   */
  async checkConnectionHealth() {
    try {
      // 检查主连接
      if (mongoose.connection.readyState !== 1) {
        logger.warn('健康检查: 主连接不可用，状态:', mongoose.connection.readyState);
        this.connectionStatus.healthy = false;
        this.handleConnectionError('primary', new Error('连接不可用'));
        return;
      }
      
      // 检查副本连接
      if (this.connections.replica && this.connections.replica.readyState !== 1) {
        logger.warn('健康检查: 副本连接不可用，状态:', this.connections.replica.readyState);
        this.connectionStatus.healthy = false;
        this.handleConnectionError('replica', new Error('连接不可用'));
        return;
      }
      
      // 执行ping测试
      const pingResult = await mongoose.connection.db.admin().ping();
      this.connectionStatus.lastPing = Date.now();
      this.connectionStatus.healthy = pingResult.ok === 1;
      
      if (!this.connectionStatus.healthy) {
        logger.warn('健康检查: 数据库ping失败');
        this.handleConnectionError('primary', new Error('Ping失败'));
      }
      
      // 更新连接池统计
      await this.updatePoolStats();
    } catch (error) {
      logger.error('健康检查失败:', error);
      this.connectionStatus.healthy = false;
      this.handleConnectionError('primary', error);
    }
  }

  /**
   * 更新连接池统计信息
   */
  async updatePoolStats() {
    try {
      // 获取主连接池状态
      if (mongoose.connection.db) {
        const primaryStats = await mongoose.connection.db.admin().serverStatus();
        if (primaryStats && primaryStats.connections) {
          this.poolStats.primary = {
            available: primaryStats.connections.available || 0,
            used: primaryStats.connections.current || 0,
            pending: primaryStats.connections.pending || 0,
            max: this.connectionOptions.maxPoolSize
          };
        }
      }
      
      // 获取副本连接池状态
      if (this.connections.replica && this.connections.replica.db) {
        const replicaStats = await this.connections.replica.db.admin().serverStatus();
        if (replicaStats && replicaStats.connections) {
          this.poolStats.replica = {
            available: replicaStats.connections.available || 0,
            used: replicaStats.connections.current || 0,
            pending: replicaStats.connections.pending || 0,
            max: this.connectionOptions.maxPoolSize
          };
        }
      }
      
      // 更新时间
      this.poolStats.lastCheck = Date.now();
      
      // 记录历史数据（保留最近30分钟，每30秒一个点）
      this.poolStats.history.push({
        timestamp: this.poolStats.lastCheck,
        primary: { ...this.poolStats.primary },
        replica: { ...this.poolStats.replica }
      });
      
      // 只保留最近60个数据点（30分钟）
      if (this.poolStats.history.length > 60) {
        this.poolStats.history.shift();
      }
      
      // 检查是否需要记录警告
      this.checkPoolUsage();
    } catch (error) {
      logger.error('更新连接池统计失败:', error);
    }
  }
  
  /**
   * 检查连接池使用情况并记录警告
   */
  checkPoolUsage() {
    // 检查主连接池使用率
    const primaryUsage = this.poolStats.primary.used / this.poolStats.primary.max;
    if (primaryUsage > 0.8) {
      logger.warn(`主连接池使用率高: ${Math.round(primaryUsage * 100)}%, 已用: ${this.poolStats.primary.used}, 最大: ${this.poolStats.primary.max}`);
    }
    
    // 检查副本连接池使用率
    if (this.connections.replica) {
      const replicaUsage = this.poolStats.replica.used / this.poolStats.replica.max;
      if (replicaUsage > 0.8) {
        logger.warn(`副本连接池使用率高: ${Math.round(replicaUsage * 100)}%, 已用: ${this.poolStats.replica.used}, 最大: ${this.poolStats.replica.max}`);
      }
    }
    
    // 检查挂起的连接请求
    if (this.poolStats.primary.pending > 3) {
      logger.warn(`主连接池有${this.poolStats.primary.pending}个挂起的连接请求，可能需要增加连接池大小`);
    }
  }
  
  /**
   * 调整连接池大小（自适应）
   */
  async adjustPoolSize() {
    // 如果没有启用自适应连接池，跳过
    if (!config.database.enableAdaptivePool) {
      return;
    }
    
    try {
      await this.updatePoolStats();
      
      // 计算过去5分钟的负载趋势
      const recentHistory = this.poolStats.history.slice(-10);
      if (recentHistory.length < 5) {
        return; // 需要更多历史数据
      }
      
      // 主连接池调整
      this._adjustSinglePoolSize('primary');
      
      // 如果启用了读写分离，调整副本连接池
      if (this.connections.replica) {
        this._adjustSinglePoolSize('replica');
      }
    } catch (error) {
      logger.error('调整连接池大小失败:', error);
    }
  }
  
  /**
   * 调整单个连接池大小
   * @param {string} type - 连接类型 (primary or replica)
   */
  _adjustSinglePoolSize(type) {
    const poolStats = this.poolStats[type];
    const history = this.poolStats.history.slice(-10).map(h => h[type]);
    
    // 计算平均使用率
    const avgUsage = history.reduce((sum, stat) => sum + stat.used, 0) / history.length;
    const maxUsage = Math.max(...history.map(stat => stat.used));
    const usageRatio = avgUsage / poolStats.max;
    
    // 是否有挂起的连接请求
    const hasPending = history.some(stat => stat.pending > 0);
    
    // 决定是否调整连接池大小
    let newPoolSize = poolStats.max;
    
    // 负载高，增加连接池大小
    if (usageRatio > 0.7 || hasPending || maxUsage >= poolStats.max * 0.9) {
      newPoolSize = Math.min(
        poolStats.max + 5,                      // 每次增加5个连接
        config.database.absoluteMaxPoolSize || 100, // 绝对最大值
        maxUsage * 1.5                          // 最大使用量的1.5倍
      );
    } 
    // 负载低，减少连接池大小
    else if (usageRatio < 0.3 && maxUsage < poolStats.max * 0.5) {
      newPoolSize = Math.max(
        Math.ceil(maxUsage * 1.5),          // 最大使用量的1.5倍
        config.database.minPoolSize || 5,    // 最小连接池大小
        5                                    // 至少保留5个连接
      );
    }
    
    // 如果需要调整，执行调整
    if (newPoolSize !== poolStats.max) {
      logger.info(`调整${type}连接池大小: ${poolStats.max} -> ${newPoolSize}, 当前使用率: ${Math.round(usageRatio * 100)}%`);
      
      // 更新配置
      if (type === 'primary') {
        this.connectionOptions.maxPoolSize = newPoolSize;
        this.poolStats.primary.max = newPoolSize;
      } else {
        this.poolStats.replica.max = newPoolSize;
      }
      
      // 连接池大小实际调整需要通过重新创建连接实现
      // 但为避免频繁重连，仅在必要时执行
      if (Math.abs(newPoolSize - poolStats.max) >= 10) {
        // 仅在大幅变化时重新连接，通过uri参数传递
        // 这部分代码不实际执行重连，只记录需要调整的幅度
        logger.info(`下次连接将使用新的连接池大小: ${newPoolSize}`);
      }
    }
  }

  /**
   * 连接到主数据库
   * @returns {Promise<mongoose.Connection>} Mongoose连接对象
   */
  async connectPrimary() {
    try {
      // 主写入URI或默认URI
      const uri = config.database.writeUri || config.database.uri;
      
      if (!uri) {
        throw new Error('未配置数据库URI');
      }
      
      // 应用服务器特定参数
      const options = { 
        ...this.connectionOptions,
        // 如果是写连接，不从副本读取
        readPreference: 'primary'
      };
      
      // 使用全局连接
      this.connections.primary = await mongoose.connect(uri, options);
      
      logger.info('已连接到主数据库');
      return mongoose.connection;
    } catch (error) {
      logger.error('连接主数据库失败:', error);
      throw error;
    }
  }

  /**
   * 连接到副本集数据库
   * @returns {Promise<mongoose.Connection>} Mongoose连接对象
   */
  async connectReplica() {
    try {
      // 如果没有配置读专用URI，使用主URI
      const replicaUri = config.database.readUri || config.database.uri;
      
      if (!replicaUri) {
        throw new Error('未配置读取数据库URI');
      }
      
      // 应用服务器特定参数
      const replicaOptions = {
        ...this.connectionOptions,
        // 副本连接池大小可能需要更大
        maxPoolSize: config.database.readPoolSize || this.connectionOptions.maxPoolSize * 2,
        // 从副本优先读取
        readPreference: 'secondaryPreferred'
      };
      
      // 创建副本连接
      this.connections.replica = await mongoose.createConnection(replicaUri, replicaOptions);
      
      logger.info('已连接到副本集数据库');
      return this.connections.replica;
    } catch (error) {
      logger.error('连接副本集数据库失败:', error);
      throw error;
    }
  }

  /**
   * 设置连接事件监听器
   */
  setupConnectionEvents() {
    // 监控主连接
    mongoose.connection.on('error', (err) => {
      logger.error('主数据库连接错误:', err);
      this.handleConnectionError('primary', err);
    });
    
    mongoose.connection.on('disconnected', () => {
      logger.warn('主数据库连接断开');
      this.handleDisconnect('primary');
    });
    
    mongoose.connection.on('reconnected', () => {
      logger.info('主数据库重新连接成功');
      this.reconnectAttempts = 0;
      this.connectionStatus.healthy = true;
      
      // 触发模型重新初始化
      this.reinitializeModels('primary');
    });
    
    // 如果使用读写分离，监控副本连接
    if (this.connections.replica) {
      this.connections.replica.on('error', (err) => {
        logger.error('副本数据库连接错误:', err);
        this.handleConnectionError('replica', err);
      });
      
      this.connections.replica.on('disconnected', () => {
        logger.warn('副本数据库连接断开');
        this.handleDisconnect('replica');
      });
      
      this.connections.replica.on('reconnected', () => {
        logger.info('副本数据库重新连接成功');
        this.connectionStatus.healthy = true;
        
        // 触发模型重新初始化
        this.reinitializeModels('replica');
      });
    }
    
    // 添加进程退出处理
    process.on('SIGINT', async () => {
      logger.info('接收到应用关闭信号，正在关闭数据库连接...');
      await this.close();
      process.exit(0);
    });
  }

  /**
   * 重新初始化数据库模型
   * @param {string} connectionType 连接类型
   */
  async reinitializeModels(connectionType) {
    try {
      logger.info(`正在重新初始化${connectionType === 'primary' ? '主' : '副本'}连接的模型...`);
      
      // 导入模型工厂以使用其重新初始化方法
      const ModelFactory = require('../../models/modelFactory');
      
      if (typeof ModelFactory.reinitializeAllModels === 'function') {
        const results = await ModelFactory.reinitializeAllModels();
        logger.info(`模型重新初始化完成: ${results.success} 成功, ${results.failed} 失败`);
      } else {
        logger.warn('模型工厂缺少reinitializeAllModels方法，无法重新初始化模型');
      }
    } catch (error) {
      logger.error('重新初始化模型失败:', error);
    }
  }

  /**
   * 处理连接错误
   * @param {string} connectionType 连接类型
   * @param {Error} error 错误对象
   */
  handleConnectionError(connectionType, error) {
    // 避免重复处理相同连接的错误
    if (this.reconnectTasks[connectionType]) {
      return;
    }
    
    logger.error(`${connectionType === 'primary' ? '主' : '副本'}数据库连接错误:`, error);
    
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      logger.error(`达到最大重连尝试次数(${this.maxReconnectAttempts})，不再尝试重连`);
      // 如果是生产环境，可能需要发送警报或通知
      if (process.env.NODE_ENV === 'production') {
        this.sendAlert(`数据库连接失败，已达到最大重试次数: ${this.maxReconnectAttempts}`);
      }
      return;
    }
    
    // 增加重连尝试次数并使用指数退避算法
    this.reconnectAttempts++;
    const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempts), 60000);
    
    logger.info(`将在 ${delay}ms 后尝试重新连接${connectionType === 'primary' ? '主' : '副本'}数据库 (尝试 ${this.reconnectAttempts}/${this.maxReconnectAttempts})`);
    
    // 创建一个重连任务并保存引用，避免多次重连
    this.reconnectTasks[connectionType] = setTimeout(async () => {
      try {
        await this.reconnect(connectionType);
        this.reconnectTasks[connectionType] = null;
      } catch (err) {
        logger.error(`重连 ${connectionType} 数据库失败:`, err);
        this.reconnectTasks[connectionType] = null;
        
        // 继续尝试重连
        this.handleConnectionError(connectionType, err);
      }
    }, delay);
  }

  /**
   * 发送数据库警报（可以根据需要实现）
   * @param {string} message 警报消息
   */
  sendAlert(message) {
    logger.error('数据库警报:', message);
    // 这里可以集成第三方告警服务，如发送邮件、短信或调用监控API
  }

  /**
   * 处理连接断开
   * @param {string} connectionType 连接类型
   */
  handleDisconnect(connectionType) {
    if (!this.isConnected) return; // 如果尚未连接，忽略断开事件
    
    logger.warn(`${connectionType === 'primary' ? '主' : '副本'}数据库连接已断开`);
    
    // 更新健康状态
    this.connectionStatus.healthy = false;
    
    // 如果是主动断开，不需要重连
    if (mongoose.connection.readyState === 0 && connectionType === 'primary') {
      this.isConnected = false;
      return;
    }
    
    this.handleConnectionError(connectionType, new Error('连接断开'));
  }

  /**
   * 重连数据库
   * @param {string} connectionType 连接类型
   * @returns {Promise<boolean>} 是否重连成功
   */
  async reconnect(connectionType) {
    try {
      logger.info(`正在尝试重新连接到${connectionType === 'primary' ? '主' : '副本'}数据库...`);
      
      if (connectionType === 'primary') {
        await this.connectPrimary();
      } else if (connectionType === 'replica' && config.database.useSplitConnections) {
        await this.connectReplica();
      }
      
      logger.info(`重新连接到${connectionType === 'primary' ? '主' : '副本'}数据库成功`);
      
      // 更新健康状态
      this.connectionStatus.healthy = true;
      this.reconnectAttempts = 0;
      
      return true;
    } catch (error) {
      logger.error(`重新连接到${connectionType === 'primary' ? '主' : '副本'}数据库失败:`, error);
      throw error;
    }
  }

  /**
   * 获取主连接（用于写操作）
   * @returns {Promise<mongoose.Connection>} Mongoose连接对象
   */
  async getPrimaryConnection() {
    if (!this.isConnected) {
      await this.init();
    }
    
    return mongoose.connection;
  }

  /**
   * 获取副本连接（用于读操作）
   * @returns {Promise<mongoose.Connection>} Mongoose连接对象
   */
  async getReplicaConnection() {
    if (!this.isConnected) {
      await this.init();
    }
    
    // 如果配置了读写分离且副本连接可用，返回副本连接
    if (config.database.useSplitConnections && 
        this.connections.replica && 
        this.connections.replica.readyState === 1) {
      return this.connections.replica;
    }
    
    // 否则返回主连接
    return mongoose.connection;
  }

  /**
   * 关闭所有数据库连接
   * @returns {Promise<void>}
   */
  async close() {
    try {
      // 清除健康检查间隔
      if (this.healthCheckInterval) {
        clearInterval(this.healthCheckInterval);
      }
      
      // 清除所有重连任务
      Object.keys(this.reconnectTasks).forEach(key => {
        if (this.reconnectTasks[key]) {
          clearTimeout(this.reconnectTasks[key]);
          this.reconnectTasks[key] = null;
        }
      });
      
      // 关闭主连接
      if (mongoose.connection.readyState !== 0) {
        await mongoose.connection.close();
        logger.info('主数据库连接已关闭');
      }
      
      // 关闭副本连接
      if (this.connections.replica && this.connections.replica.readyState !== 0) {
        await this.connections.replica.close();
        logger.info('副本数据库连接已关闭');
      }
      
      this.isConnected = false;
      this.reconnectAttempts = 0;
    } catch (error) {
      logger.error('关闭数据库连接时出错:', error);
      throw error;
    }
  }
  
  /**
   * 获取数据库连接状态
   * @returns {Object} 连接状态信息
   */
  getStatus() {
    return {
      isConnected: this.isConnected,
      primaryState: mongoose.connection ? mongoose.connection.readyState : 0,
      replicaState: this.connections.replica ? this.connections.replica.readyState : 0,
      healthy: this.connectionStatus.healthy,
      lastPing: this.connectionStatus.lastPing,
      reconnectAttempts: this.reconnectAttempts,
      usingSplitConnections: config.database.useSplitConnections
    };
  }

  /**
   * 获取连接池统计信息
   * @returns {Object} 连接池统计
   */
  getPoolStats() {
    return {
      ...this.poolStats,
      historyCount: this.poolStats.history.length,
      primaryUsage: this.poolStats.primary.used / this.poolStats.primary.max,
      replicaUsage: this.connections.replica 
        ? this.poolStats.replica.used / this.poolStats.replica.max
        : 0
    };
  }
  
  /**
   * 手动设置连接池大小
   * @param {Object} sizes - 连接池大小设置
   * @param {number} sizes.primary - 主连接池大小
   * @param {number} sizes.replica - 副本连接池大小
   * @returns {Object} 新的连接池设置
   */
  setPoolSizes(sizes = {}) {
    if (sizes.primary && typeof sizes.primary === 'number') {
      this.connectionOptions.maxPoolSize = Math.max(
        this.connectionOptions.minPoolSize,
        Math.min(sizes.primary, config.database.absoluteMaxPoolSize || 100)
      );
      this.poolStats.primary.max = this.connectionOptions.maxPoolSize;
      logger.info(`手动设置主连接池大小: ${this.connectionOptions.maxPoolSize}`);
    }
    
    if (sizes.replica && typeof sizes.replica === 'number' && this.connections.replica) {
      this.poolStats.replica.max = Math.max(
        this.connectionOptions.minPoolSize,
        Math.min(sizes.replica, config.database.absoluteMaxPoolSize || 100)
      );
      logger.info(`手动设置副本连接池大小: ${this.poolStats.replica.max}`);
    }
    
    return {
      primary: this.poolStats.primary.max,
      replica: this.poolStats.replica.max
    };
  }
}

module.exports = new DatabaseManager();