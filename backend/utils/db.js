const mongoose = require('mongoose');
const dbConfig = require('../config/db.config');

// 用于全局 mongoose 连接（如果需要）
const connectGlobal = async () => {
    try {
        await mongoose.connect(dbConfig.mongoURI, {
            ...dbConfig.options,
            autoReconnect: true,
            reconnectTries: Number.MAX_VALUE,
            reconnectInterval: 1000
        });
        console.log('Global MongoDB connected successfully');
    } catch (error) {
        console.error('Global MongoDB connection error:', error);
        throw error;
    }
};

// 用于关闭全局连接
const disconnectGlobal = async () => {
    try {
        await mongoose.disconnect();
        console.log('Global MongoDB disconnected successfully');
    } catch (error) {
        console.error('Global MongoDB disconnection error:', error);
        throw error;
    }
};

// 用于检查全局连接状态
const isGlobalConnected = () => {
    return mongoose.connection.readyState === 1;
};

module.exports = { 
    connectGlobal, 
    disconnectGlobal,
    isGlobalConnected,
    // 导出 mongoose 实例，供其他模块使用
    mongoose 
}; 