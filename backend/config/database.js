const mongoose = require('mongoose');
const config = require('./index');
const logger = require('../utils/logger');

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
    } catch (error) {
      logger.error('健康检查失败:', error);
      this.connectionStatus.healthy = false;
      this.handleConnectionError('primary', error);
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
      const ModelFactory = require('../models/modelFactory');
      
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
}

module.exports = new DatabaseManager(); 