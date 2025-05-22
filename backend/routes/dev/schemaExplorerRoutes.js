/**
 * 模式管理和可视化路由
 * @module routes/dev/schemaRoutes
 */

const express = require('express');
const router = express.Router();
const { logger } = require('../../utils/logger/winstonLogger.js');
const { isAdmin } = require('../../middleware/authMiddleware');

// 获取服务实例
const schemaTransformer = require('../../services/model/schemaTransformer').getInstance();
let schemaGuardService;

try {
  schemaGuardService = require('../../services/model/schemaGuardService').getInstance();
} catch (error) {
  logger.warn('无法加载SchemaGuardService：', error.message);
}

/**
 * @route GET /api/admin/schema/visualization
 * @desc 获取数据库模式可视化数据
 * @access Admin
 */
router.get('/visualization', isAdmin, async (req, res) => {
  try {
    const includeVirtuals = req.query.includeVirtuals !== 'false';
    const includeIndexes = req.query.includeIndexes !== 'false';
    const includeHistory = req.query.includeHistory !== 'false';
    
    const schemaData = await schemaTransformer.transformAllModels({
      includeVirtuals,
      includeIndexes,
      includeHistory
    });
    
    res.json(schemaData);
  } catch (error) {
    logger.error('获取模式可视化数据时出错：', error);
    res.status(500).json({ 
      success: false, 
      message: '获取模式可视化数据时出错', 
      error: error.message 
    });
  }
});

/**
 * @route GET /api/admin/schema/render
 * @desc 渲染模式可视化页面
 * @access Admin
 */
router.get('/render', isAdmin, async (req, res) => {
  try {
    const schemaData = await schemaTransformer.transformAllModels();
    
    res.render('schema-visualization', { 
      title: '数据库模式可视化',
      schemaData: JSON.stringify(schemaData),
      hasSchemaGuard: !!schemaGuardService
    });
  } catch (error) {
    logger.error('渲染模式可视化页面时出错：', error);
    res.status(500).render('error', { 
      message: '渲染模式可视化页面时出错', 
      error: error.message 
    });
  }
});

// 以下端点仅在SchemaGuardService可用时才启用
if (schemaGuardService) {
  /**
   * @route POST /api/admin/schema/freeze/:modelName
   * @desc 冻结指定模型的模式
   * @access Admin
   */
  router.post('/freeze/:modelName', isAdmin, async (req, res) => {
    try {
      const { modelName } = req.params;
      const result = await schemaGuardService.freezeSchema(modelName, req.user._id);
      
      res.json({
        success: true,
        message: `模型 ${modelName} 的模式已成功冻结`,
        data: result
      });
    } catch (error) {
      logger.error(`冻结模型 ${req.params.modelName} 的模式时出错：`, error);
      res.status(500).json({ 
        success: false, 
        message: `冻结模型模式时出错`, 
        error: error.message 
      });
    }
  });

  /**
   * @route POST /api/admin/schema/unfreeze/:modelName
   * @desc 解冻指定模型的模式
   * @access Admin
   */
  router.post('/unfreeze/:modelName', isAdmin, async (req, res) => {
    try {
      const { modelName } = req.params;
      const result = await schemaGuardService.unfreezeSchema(modelName, req.user._id);
      
      res.json({
        success: true,
        message: `模型 ${modelName} 的模式已成功解冻`,
        data: result
      });
    } catch (error) {
      logger.error(`解冻模型 ${req.params.modelName} 的模式时出错：`, error);
      res.status(500).json({ 
        success: false, 
        message: `解冻模型模式时出错`, 
        error: error.message 
      });
    }
  });

  /**
   * @route GET /api/admin/schema/history/:modelName
   * @desc 获取指定模型的模式历史
   * @access Admin
   */
  router.get('/history/:modelName', isAdmin, async (req, res) => {
    try {
      const { modelName } = req.params;
      const history = await schemaGuardService.getSchemaHistory(modelName);
      
      res.json({
        success: true,
        modelName,
        history
      });
    } catch (error) {
      logger.error(`获取模型 ${req.params.modelName} 的模式历史时出错：`, error);
      res.status(500).json({ 
        success: false, 
        message: `获取模型模式历史时出错`, 
        error: error.message 
      });
    }
  });

  /**
   * @route GET /api/admin/schema/frozen
   * @desc 获取所有冻结的模式
   * @access Admin
   */
  router.get('/frozen', isAdmin, async (req, res) => {
    try {
      const frozenSchemas = await schemaGuardService.getFrozenSchemas();
      
      res.json({
        success: true,
        count: frozenSchemas.length,
        frozenSchemas
      });
    } catch (error) {
      logger.error('获取冻结模式列表时出错：', error);
      res.status(500).json({ 
        success: false, 
        message: '获取冻结模式列表时出错', 
        error: error.message 
      });
    }
  });
}

module.exports = router; 