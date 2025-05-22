/**
 * 数据库模式可视化路由
 * 提供生成和查看MongoDB模式可视化的API和页面
 */

const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const handlebars = require('handlebars');
const { promisify } = require('util');
const schemaHelper = require('../../templates/schema-visualization-helper');

// 权限检查中间件
const { requireAdmin } = require('../../middleware/auth');

// 读取模板文件
const readFile = promisify(fs.readFile);
const writeFile = promisify(fs.writeFile);

// 注册Handlebars助手函数
schemaHelper.registerHelpers(handlebars);

/**
 * 获取所有可用模型的架构信息
 * @returns {Array} 包含架构信息的数组
 */
async function getAllSchemas() {
  const schemas = [];
  
  // 获取所有已注册的模型
  const modelNames = mongoose.modelNames();
  
  for (const modelName of modelNames) {
    try {
      const model = mongoose.model(modelName);
      const schema = model.schema;
      
      // 添加模型名称和集合名称
      schema.modelName = modelName;
      schema.collection = model.collection.name;
      
      // 从SchemaGuardService获取冻结状态(如果可用)
      try {
        const SchemaGuardService = require('../../services/core/schemaGuardService');
        if (SchemaGuardService.getInstance && SchemaGuardService.getInstance().isSchemFrozen) {
          schema.isFrozen = await SchemaGuardService.getInstance().isSchemaFrozen(modelName);
          schema.history = await SchemaGuardService.getInstance().getSchemaHistory(modelName);
        }
      } catch (error) {
        console.warn(`无法获取模式${modelName}的保护状态:`, error.message);
      }
      
      schemas.push(schema);
    } catch (error) {
      console.error(`获取模型${modelName}时出错:`, error);
    }
  }
  
  return schemas;
}

/**
 * 生成HTML可视化并保存到文件
 * @param {Array} schemas - 模式信息
 * @param {String} outputPath - 输出文件路径
 * @returns {String} 生成的HTML内容
 */
async function generateVisualization(schemas, outputPath) {
  try {
    // 读取Handlebars模板
    const templatePath = path.join(__dirname, '../../templates/schema-visualization.hbs');
    const templateSource = await readFile(templatePath, 'utf8');
    
    // 编译模板
    const template = handlebars.compile(templateSource);
    
    // 准备模板数据
    const templateData = schemaHelper.prepareTemplateContext(schemas);
    
    // 渲染HTML
    const html = template(templateData);
    
    // 保存到文件
    if (outputPath) {
      const outputDir = path.dirname(outputPath);
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }
      await writeFile(outputPath, html);
    }
    
    return html;
  } catch (error) {
    console.error('生成可视化时出错:', error);
    throw error;
  }
}

/**
 * @api {get} /admin/schema-visualization 获取数据库架构可视化页面
 * @apiName GetSchemaVisualization
 * @apiGroup Admin
 * @apiPermission admin
 * 
 * @apiSuccess {String} html 数据库架构可视化的HTML页面
 */
router.get('/', requireAdmin, async (req, res) => {
  try {
    const schemas = await getAllSchemas();
    const outputPath = path.join(__dirname, '../../../public/reports/schema-visualization.html');
    
    // 生成HTML并保存到文件
    const html = await generateVisualization(schemas, outputPath);
    
    res.send(html);
  } catch (error) {
    console.error('生成架构可视化时出错:', error);
    res.status(500).json({
      success: false,
      message: '生成架构可视化时出错',
      error: error.message
    });
  }
});

/**
 * @api {get} /admin/schema-visualization/json 获取数据库架构JSON数据
 * @apiName GetSchemaVisualizationJson
 * @apiGroup Admin
 * @apiPermission admin
 * 
 * @apiSuccess {Boolean} success 操作是否成功
 * @apiSuccess {Object} data 包含架构信息的对象
 */
router.get('/json', requireAdmin, async (req, res) => {
  try {
    const schemas = await getAllSchemas();
    const templateData = schemaHelper.prepareTemplateContext(schemas);
    
    res.json({
      success: true,
      data: templateData
    });
  } catch (error) {
    console.error('获取架构数据时出错:', error);
    res.status(500).json({
      success: false,
      message: '获取架构数据时出错',
      error: error.message
    });
  }
});

/**
 * @api {post} /admin/schema-visualization/refresh 刷新并重新生成架构可视化
 * @apiName RefreshSchemaVisualization
 * @apiGroup Admin
 * @apiPermission admin
 * 
 * @apiSuccess {Boolean} success 操作是否成功
 * @apiSuccess {String} message 操作结果消息
 * @apiSuccess {String} url 生成的报告URL
 */
router.post('/refresh', requireAdmin, async (req, res) => {
  try {
    const schemas = await getAllSchemas();
    const outputPath = path.join(__dirname, '../../../public/reports/schema-visualization.html');
    
    // 生成HTML并保存到文件
    await generateVisualization(schemas, outputPath);
    
    // 返回报告URL
    const reportUrl = '/reports/schema-visualization.html';
    
    res.json({
      success: true,
      message: '架构可视化已成功生成',
      url: reportUrl
    });
  } catch (error) {
    console.error('刷新架构可视化时出错:', error);
    res.status(500).json({
      success: false,
      message: '刷新架构可视化时出错',
      error: error.message
    });
  }
});

module.exports = router; 