/**
 * ✅ 模块名：db.js
 * ✅ 所属层：utils（工具层 / 数据库工具）
 * ✅ 功能说明：
 *   - 提供全局 MongoDB（Mongoose）连接、断开连接、连接状态检查功能
 *   - 可用于服务启动初始化或中间件动态连接需求
 * ✅ 导出内容：
 *   - connectGlobal(): 初始化全局连接
 *   - disconnectGlobal(): 断开全局连接
 *   - isGlobalConnected(): 判断当前连接状态
 *   - mongoose: 原始 mongoose 实例（供模型定义或分库使用）
 */

const mongoose = require('mongoose');
const dbConfig = require('../../config/modules/db.config');

/**
 * 初始化全局 Mongoose 数据库连接
 */
const connectGlobal = async () => {
    try {
        await mongoose.connect(dbConfig.mongoURI, {
            ...dbConfig.options,
            autoReconnect: true,
            reconnectTries: Number.MAX_VALUE,
            reconnectInterval: 1000
        });
        console.log('[MongoDB] ✅ 全局连接成功');
    } catch (error) {
        console.error('[MongoDB] ❌ 全局连接失败:', error);
        throw error;
    }
};

/**
 * 关闭全局数据库连接（通常用于服务退出时）
 */
const disconnectGlobal = async () => {
    try {
        await mongoose.disconnect();
        console.log('[MongoDB] ✅ 全局断开成功');
    } catch (error) {
        console.error('[MongoDB] ❌ 全局断开失败:', error);
        throw error;
    }
};

/**
 * 判断当前是否已连接到数据库
 * @returns {boolean} 是否连接成功
 */
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