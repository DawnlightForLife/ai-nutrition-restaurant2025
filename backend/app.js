const express = require('express');
const cors = require('cors');
const dbManager = require('./services/database');
const { connectGlobal, disconnectGlobal } = require('./utils/db');
const userRoutes = require('./routes/userRoutes');
const nutritionProfileRoutes = require('./routes/nutritionProfileRoutes');
const authMiddleware = require('./middleware/authMiddleware');

const app = express();

// 中间件
app.use(cors());
app.use(express.json());

// 初始化数据库连接
const initializeDatabase = async () => {
    try {
        // 初始化连接管理器
        await dbManager.initialize();
        // 初始化全局连接
        await connectGlobal();
        console.log('Database connections initialized successfully');
    } catch (error) {
        console.error('Database initialization failed:', error);
        process.exit(1);
    }
};

initializeDatabase();

// 优雅关闭
process.on('SIGTERM', async () => {
    console.log('Received SIGTERM. Performing graceful shutdown...');
    try {
        await Promise.all([
            dbManager.closeAllConnections(),
            disconnectGlobal()
        ]);
        console.log('All database connections closed successfully');
        process.exit(0);
    } catch (error) {
        console.error('Error during graceful shutdown:', error);
        process.exit(1);
    }
});

// 路由
app.use('/api/users', userRoutes);

// 为营养档案路由添加更详细的错误日志
app.use('/api/nutrition-profiles', (req, res, next) => {
    console.log(`[DEBUG] 请求营养档案API: ${req.method} ${req.originalUrl}`);
    console.log('[DEBUG] 请求头:', JSON.stringify(req.headers));
    if (!req.headers.authorization) {
        console.log('[DEBUG] 请求中没有Authorization头');
    }
    next();
}, authMiddleware, (req, res, next) => {
    console.log('[DEBUG] 身份验证成功，用户ID:', req.user?.userId);
    next();
}, nutritionProfileRoutes);

// 错误处理中间件
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        message: '服务器内部错误'
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`服务器运行在端口 ${PORT}`);
}); 