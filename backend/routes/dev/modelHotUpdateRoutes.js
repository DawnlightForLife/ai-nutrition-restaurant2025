/**
 * 模型热更新路由模块
 * 提供动态模型的加载、更新、状态查询等接口
 * @module routes/dev/modelHotUpdateRoutes
 */

const express = require('express');
const router = express.Router();
const authMiddleware = require('../../middleware/auth/authMiddleware');
const logger = require('../../utils/logger/winstonLogger.js');
const DynamicModelLoaderService = require('../../services/core/dynamicModelLoaderService');

// 创建动态模型加载服务实例
const dynamicModelLoader = new DynamicModelLoaderService({
  enableSandbox: true,
  enableGrayRelease: process.env.ENABLE_GRAY_RELEASE === 'true',
  grayReleasePercentage: parseInt(process.env.GRAY_RELEASE_PERCENTAGE || '10'),
  modelsDir: process.env.MODELS_DIR || './models'
});

// 初始化服务
(async () => {
  try {
    await dynamicModelLoader.initialize();
    logger.info('动态模型加载服务已成功初始化');
  } catch (error) {
    logger.error('初始化动态模型加载服务失败:', error);
  }
})();

/**
 * 获取所有已注册的模型信息
 * @route GET /api/model-hot-update/models
 * @security JWT
 */
router.get('/models', authMiddleware.requireAdmin, async (req, res) => {
  try {
    const models = dynamicModelLoader.getRegisteredModels();
    
    res.json({
      success: true,
      data: models
    });
  } catch (error) {
    logger.error(`获取模型信息时出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取模型信息时出错',
      details: error.message
    });
  }
});

/**
 * 获取指定模型的当前版本
 * @route GET /api/model-hot-update/models/:modelName/version
 * @security JWT
 */
router.get('/models/:modelName/version', authMiddleware.requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const version = dynamicModelLoader.getModelVersion(modelName);
    
    if (!version) {
      return res.status(404).json({
        success: false,
        error: `未找到模型: ${modelName}`
      });
    }
    
    res.json({
      success: true,
      data: {
        modelName,
        version
      }
    });
  } catch (error) {
    logger.error(`获取模型版本时出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取模型版本时出错',
      details: error.message
    });
  }
});

/**
 * 热更新指定模型
 * @route POST /api/model-hot-update/models/:modelName
 * @security JWT
 */
router.post('/models/:modelName', authMiddleware.requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const modelDefinition = req.body;
    
    if (!modelDefinition || !modelDefinition.schema) {
      return res.status(400).json({
        success: false,
        error: '无效的模型定义，schema是必需的'
      });
    }
    
    // 获取更新选项
    const updateOptions = {
      force: req.query.force === 'true',
      targetGroups: req.query.targetGroups ? req.query.targetGroups.split(',') : undefined,
      percentage: req.query.percentage ? parseInt(req.query.percentage) : undefined
    };
    
    const result = await dynamicModelLoader.updateModel(modelName, modelDefinition, updateOptions);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    logger.error(`更新模型时出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '更新模型时出错',
      details: error.message
    });
  }
});

/**
 * 通过文件更新模型
 * @route PUT /api/model-hot-update/models/file/:modelName
 * @security JWT
 */
router.put('/models/file/:modelName', authMiddleware.requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const { filePath } = req.body;
    
    if (!filePath) {
      return res.status(400).json({
        success: false,
        error: '必须提供模型文件路径'
      });
    }
    
    // 获取更新选项
    const updateOptions = {
      force: req.query.force === 'true',
      targetGroups: req.query.targetGroups ? req.query.targetGroups.split(',') : undefined,
      percentage: req.query.percentage ? parseInt(req.query.percentage) : undefined
    };
    
    const result = await dynamicModelLoader.loadModelFromFile(filePath, updateOptions);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    logger.error(`从文件更新模型时出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '从文件更新模型时出错',
      details: error.message
    });
  }
});

/**
 * 查看动态模型加载服务状态
 * @route GET /api/model-hot-update/status
 * @security JWT
 */
router.get('/status', authMiddleware.requireAdmin, async (req, res) => {
  try {
    res.json({
      success: true,
      data: {
        initialized: dynamicModelLoader.initialized,
        enableSandbox: dynamicModelLoader.options.enableSandbox,
        enableGrayRelease: dynamicModelLoader.options.enableGrayRelease,
        grayReleasePercentage: dynamicModelLoader.options.grayReleasePercentage,
        nodeId: dynamicModelLoader.nodeId,
        nodeGroup: dynamicModelLoader.nodeGroup,
        modelsCount: dynamicModelLoader.modelRegistry.size
      }
    });
  } catch (error) {
    logger.error(`获取服务状态时出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取服务状态时出错',
      details: error.message
    });
  }
});

module.exports = router; 