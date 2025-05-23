/**
 * Schema 管理路由
 * 提供模型 Schema 的可视化、差异比较、状态管理和冻结功能接口
 * @module routes/dev/schemaAdminRoutes
 */

const express = require('express');
const router = express.Router();
const SchemaTransformer = require('../../utils/schema/schemaTransformer');
const SchemaGuardService = require('../../services/model/schemaGuardService');
const { requireAdmin } = require('../../middleware/auth/authMiddleware');
const logger = require('../../utils/logger/winstonLogger');

// 获取 SchemaGuardService 实例
const schemaGuard = new SchemaGuardService({
  autoFreeze: false,
  validateOnInit: true,
  securityCheck: true
});

/**
 * [GET] 获取所有模型的 Schema 信息
 * 路径: /api/schema/models
 * 权限: requireAdmin
 */
router.get('/models', requireAdmin, async (req, res) => {
  try {
    const options = {
      includeVirtuals: req.query.includeVirtuals !== 'false',
      includeIndexes: req.query.includeIndexes !== 'false'
    };
    
    const schemas = SchemaTransformer.getAllModelSchemas(options);
    
    res.json({
      success: true,
      data: schemas
    });
  } catch (error) {
    logger.error(`获取Schema信息出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取Schema信息时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 获取特定模型的 Schema 信息
 * 路径: /api/schema/models/:modelName
 * 权限: requireAdmin
 */
router.get('/models/:modelName', requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const options = {
      includeVirtuals: req.query.includeVirtuals !== 'false',
      includeIndexes: req.query.includeIndexes !== 'false'
    };
    
    const schema = SchemaTransformer.getModelSchema(modelName, options);
    
    if (!schema) {
      return res.status(404).json({
        success: false,
        error: `未找到模型: ${modelName}`
      });
    }
    
    res.json({
      success: true,
      data: schema
    });
  } catch (error) {
    logger.error(`获取模型Schema出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取模型Schema时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 获取 Schema 历史记录
 * 路径: /api/schema/history
 * 权限: requireAdmin
 */
router.get('/history', requireAdmin, async (req, res) => {
  try {
    const { modelName, limit = 20, skip = 0 } = req.query;
    
    const history = await schemaGuard.getSchemaHistory(modelName, {
      limit: parseInt(limit),
      skip: parseInt(skip)
    });
    
    res.json({
      success: true,
      data: history
    });
  } catch (error) {
    logger.error(`获取Schema历史出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取Schema历史时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 获取两个 Schema 版本之间的差异
 * 路径: /api/schema/diff
 * 权限: requireAdmin
 */
router.get('/diff', requireAdmin, async (req, res) => {
  try {
    const { modelName, oldVersion, newVersion } = req.query;
    
    if (!modelName || !oldVersion || !newVersion) {
      return res.status(400).json({
        success: false,
        error: '请提供模型名称和两个版本进行比较'
      });
    }
    
    // 获取两个版本的Schema快照
    const history = await schemaGuard.getSchemaHistory(modelName, {
      snapshotIds: [oldVersion, newVersion]
    });
    
    if (history.length < 2) {
      return res.status(404).json({
        success: false,
        error: '未找到指定的Schema版本'
      });
    }
    
    // 找到两个指定版本
    const oldSchema = history.find(item => item._id.toString() === oldVersion);
    const newSchema = history.find(item => item._id.toString() === newVersion);
    
    // 计算差异
    const diff = SchemaTransformer.compareSchemas(
      oldSchema.schemaData,
      newSchema.schemaData
    );
    
    res.json({
      success: true,
      data: {
        diff,
        oldTimestamp: oldSchema.createdAt,
        newTimestamp: newSchema.createdAt
      }
    });
  } catch (error) {
    logger.error(`比较Schema差异出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '比较Schema差异时发生错误',
      details: error.message
    });
  }
});

/**
 * [POST] 冻结指定模型 Schema
 * 路径: /api/schema/freeze/:modelName
 * 权限: requireAdmin
 */
router.post('/freeze/:modelName', requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const reason = req.body.reason || '管理员冻结';
    
    await schemaGuard.freezeSchema(modelName, {
      reason,
      userId: req.user._id
    });
    
    res.json({
      success: true,
      message: `已成功冻结模型Schema: ${modelName}`
    });
  } catch (error) {
    logger.error(`冻结Schema出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '冻结Schema时发生错误',
      details: error.message
    });
  }
});

/**
 * [POST] 解冻指定模型 Schema
 * 路径: /api/schema/unfreeze/:modelName
 * 权限: requireAdmin
 */
router.post('/unfreeze/:modelName', requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const reason = req.body.reason || '管理员解冻';
    
    await schemaGuard.unfreezeSchema(modelName, {
      reason,
      userId: req.user._id
    });
    
    res.json({
      success: true,
      message: `已成功解冻模型Schema: ${modelName}`
    });
  } catch (error) {
    logger.error(`解冻Schema出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '解冻Schema时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 获取模型当前 Schema 状态
 * 路径: /api/schema/status/:modelName
 * 权限: requireAdmin
 */
router.get('/status/:modelName', requireAdmin, async (req, res) => {
  try {
    const { modelName } = req.params;
    const status = await schemaGuard.getSchemaStatus(modelName);
    
    if (!status) {
      return res.status(404).json({
        success: false,
        error: `未找到模型: ${modelName}`
      });
    }
    
    res.json({
      success: true,
      data: status
    });
  } catch (error) {
    logger.error(`获取Schema状态出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取Schema状态时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 获取所有模型 Schema 状态
 * 路径: /api/schema/status
 * 权限: requireAdmin
 */
router.get('/status', requireAdmin, async (req, res) => {
  try {
    const allStatus = await schemaGuard.getAllSchemaStatuses();
    
    res.json({
      success: true,
      data: allStatus
    });
  } catch (error) {
    logger.error(`获取所有Schema状态出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '获取所有Schema状态时发生错误',
      details: error.message
    });
  }
});

/**
 * [GET] 检查所有模型的 Schema 安全性问题
 * 路径: /api/schema/security-check
 * 权限: requireAdmin
 */
router.get('/security-check', requireAdmin, async (req, res) => {
  try {
    const securityIssues = await schemaGuard.checkSchemaSecurity();
    
    res.json({
      success: true,
      data: {
        issues: securityIssues,
        count: securityIssues.length
      }
    });
  } catch (error) {
    logger.error(`检查Schema安全性出错: ${error.message}`, { error });
    
    res.status(500).json({
      success: false,
      error: '检查Schema安全性时发生错误',
      details: error.message
    });
  }
});

module.exports = router; 