const mongoose = require('mongoose');
const dbConfig = require('../config/db.config');

class DatabaseManager {
    constructor() {
        this.connections = new Map();
        this.primaryConnection = null;
        this.isInitialized = false;
        this.connectionPromise = null;
    }

    async connect() {
        // 如果已经有连接正在进行中，返回该Promise
        if (this.connectionPromise) {
            return this.connectionPromise;
        }

        // 如果已初始化，直接返回成功
        if (this.isInitialized && this.primaryConnection) {
            console.log('数据库已连接，重用现有连接');
            return Promise.resolve(this.primaryConnection);
        }

        // 创建新的连接Promise
        this.connectionPromise = new Promise(async (resolve, reject) => {
            try {
                console.log('正在建立数据库连接...');
                
                // 创建主数据库连接
                this.primaryConnection = await mongoose.createConnection(dbConfig.mongoURI, {
                    ...dbConfig.options,
                    autoReconnect: true,
                    reconnectTries: Number.MAX_VALUE,
                    reconnectInterval: 1000
                });

                // 添加事件监听器
                this.primaryConnection.on('connected', () => {
                    console.log('数据库连接已建立');
                    this.isInitialized = true;
                });
                
                this.primaryConnection.on('error', (err) => {
                    console.error('数据库连接错误:', err);
                    if (this.isInitialized) {
                        this.isInitialized = false;
                        this.connectionPromise = null;
                    }
                });
                
                this.primaryConnection.on('disconnected', () => {
                    console.log('数据库连接已断开');
                    this.isInitialized = false;
                    this.connectionPromise = null;
                });
                
                this.primaryConnection.on('reconnected', () => {
                    console.log('数据库已重新连接');
                    this.isInitialized = true;
                });

                // 存储连接
                this.connections.set('primary', this.primaryConnection);
                this.isInitialized = true;

                console.log('数据库连接成功建立');
                resolve(this.primaryConnection);
            } catch (error) {
                console.error('建立数据库连接失败:', error);
                this.isInitialized = false;
                this.connectionPromise = null;
                reject(error);
            }
        });

        return this.connectionPromise;
    }

    getPrimaryConnection() {
        if (!this.isInitialized || !this.primaryConnection) {
            throw new Error('数据库管理器未初始化或主连接未建立');
        }
        return this.primaryConnection;
    }

    // 等待连接就绪的方法，可以在初始化服务时使用
    async waitForConnection(timeoutMs = 30000) {
        const start = Date.now();
        
        // 如果已连接，直接返回
        if (this.isConnected()) {
            return this.primaryConnection;
        }
        
        try {
            // 开始连接
            await this.connect();
            
            // 等待连接就绪
            while (!this.isConnected()) {
                // 检查超时
                if (Date.now() - start > timeoutMs) {
                    throw new Error(`等待数据库连接超时 (${timeoutMs}ms)`);
                }
                
                // 等待100ms
                await new Promise(resolve => setTimeout(resolve, 100));
            }
            
            return this.primaryConnection;
        } catch (error) {
            console.error('等待数据库连接失败:', error);
            throw error;
        }
    }

    async close() {
        if (!this.isInitialized) {
            console.log('数据库管理器未初始化，无需关闭');
            return;
        }

        try {
            for (const [name, connection] of this.connections) {
                await connection.close();
                console.log(`已关闭连接: ${name}`);
            }
            this.connections.clear();
            this.primaryConnection = null;
            this.isInitialized = false;
            this.connectionPromise = null;
        } catch (error) {
            console.error('关闭数据库连接时出错:', error);
            throw error;
        }
    }

    // 检查连接状态
    isConnected() {
        return this.isInitialized && this.primaryConnection && this.primaryConnection.readyState === 1;
    }

    // 获取连接状态
    getConnectionState() {
        if (!this.primaryConnection) return 'disconnected';
        const states = ['disconnected', 'connected', 'connecting', 'disconnecting'];
        return states[this.primaryConnection.readyState];
    }
}

// 创建单例实例
const dbManager = new DatabaseManager();

module.exports = dbManager; 