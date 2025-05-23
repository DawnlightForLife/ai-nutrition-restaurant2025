#!/usr/bin/env node

/**
 * 模式可视化脚本
 * 
 * 此脚本生成一个交互式HTML报告，展示数据库所有模式的结构、关系和状态
 * 可用于文档生成和模式分析
 */

const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const handlebars = require('handlebars');
const chalk = require('chalk');
const config = require('../../config');
const SchemaGuardService = require('../../services/model/schemaGuardService');

// 默认配置
const DEFAULT_CONFIG = {
  outputDir: path.join(__dirname, '../../docs/schema'),
  includeHistory: true,
  includeRelations: true,
  includeValidation: true,
  outputFilename: 'schema-visualization.html',
  templatePath: path.join(__dirname, '../templates/schema-visualization.hbs')
};

// 日志函数
const logger = {
  info: console.log,
  error: console.error,
  debug: console.log,
  warn: console.warn
};

/**
 * 连接数据库
 */
async function connectToDatabase() {
  try {
    logger.info(chalk.blue('🔄 连接到数据库...'));
    
    await mongoose.connect(config.mongodb.uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    logger.info(chalk.green('✅ 数据库连接成功'));
    return true;
  } catch (error) {
    logger.error(chalk.red(`❌ 数据库连接失败: ${error.message}`));
    return false;
  }
}

/**
 * 加载所有模型
 */
async function loadModels() {
  try {
    logger.info(chalk.blue('🔄 加载模型文件...'));
    
    const modelDir = path.join(__dirname, '../models');
    const modelFiles = fs.readdirSync(modelDir)
      .filter(file => file.endsWith('.js') && file !== 'index.js' && file !== 'modelFactory.js');
    
    // 加载每个模型文件
    for (const file of modelFiles) {
      require(path.join(modelDir, file));
    }
    
    logger.info(chalk.green(`✅ 已加载 ${modelFiles.length} 个模型文件`));
    return mongoose.modelNames();
  } catch (error) {
    logger.error(chalk.red(`❌ 加载模型失败: ${error.message}`));
    return [];
  }
}

/**
 * 分析模式字段
 */
function analyzeSchemaFields(schema) {
  const fields = [];
  
  // 递归解析模式字段
  function parseSchemaFields(schemaObj, path = '') {
    if (!schemaObj || !schemaObj.paths) return;
    
    Object.keys(schemaObj.paths).forEach(key => {
      const fieldPath = path ? `${path}.${key}` : key;
      const field = schemaObj.paths[key];
      
      // 忽略Mongoose内部字段
      if (key === '__v') return;
      
      // 检查是否是嵌套模式
      if (field.schema) {
        fields.push({
          path: fieldPath,
          type: 'Object (嵌套模式)',
          required: field.isRequired || false,
          default: field.defaultValue,
          isNested: true
        });
        
        parseSchemaFields(field.schema, fieldPath);
      } 
      // 检查是否是数组
      else if (field.instance === 'Array') {
        const itemType = field.caster ? field.caster.instance : '混合类型';
        
        fields.push({
          path: fieldPath,
          type: `数组 [${itemType}]`,
          required: field.isRequired || false,
          default: field.defaultValue,
          isArray: true
        });
        
        // 如果数组包含嵌套模式
        if (field.schema) {
          parseSchemaFields(field.schema, `${fieldPath}[]`);
        }
      } 
      // 常规字段
      else {
        let type = field.instance;
        
        // 检查是否是引用字段
        if (field.options && field.options.ref) {
          type = `引用 (${field.options.ref})`;
        }
        
        fields.push({
          path: fieldPath,
          type: type,
          required: field.isRequired || false,
          default: field.defaultValue,
          isRef: field.options && field.options.ref ? true : false,
          ref: field.options && field.options.ref ? field.options.ref : null,
          validation: field.validators && field.validators.length > 0 ? field.validators : null
        });
      }
    });
  }
  
  parseSchemaFields(schema);
  return fields;
}

/**
 * 分析模式间的关系
 */
function analyzeSchemaRelations(models) {
  const relations = [];
  
  // 分析所有模型之间的关系
  Object.keys(models).forEach(modelName => {
    const model = models[modelName];
    const fields = analyzeSchemaFields(model.schema);
    
    // 查找引用字段
    fields.forEach(field => {
      if (field.isRef && field.ref) {
        relations.push({
          from: modelName,
          to: field.ref,
          fieldName: field.path,
          type: field.isArray ? '一对多' : '一对一'
        });
      }
    });
  });
  
  return relations;
}

/**
 * 收集模式数据
 */
async function collectSchemaData(options = {}) {
  logger.info(chalk.blue('🔄 收集模式数据...'));
  
  const schemaGuard = new SchemaGuardService({
    securityChecks: true,
    autoFreeze: false
  });
  
  await schemaGuard.initialize();
  const guardStatus = schemaGuard.getStatus();
  
  // 加载所有模型
  const models = {};
  const modelNames = mongoose.modelNames();
  
  modelNames.forEach(name => {
    models[name] = mongoose.model(name);
  });
  
  // 处理每个模型的数据
  const schemasData = [];
  
  for (const modelName of modelNames) {
    try {
      const model = models[modelName];
      const fields = analyzeSchemaFields(model.schema);
      
      // 获取模式历史（如果启用）
      let history = null;
      if (options.includeHistory) {
        try {
          history = await schemaGuard.getSchemaHistory(modelName);
        } catch (error) {
          logger.warn(chalk.yellow(`⚠️ 无法获取模式历史: ${modelName} - ${error.message}`));
        }
      }
      
      // 验证模式（如果启用）
      let validation = null;
      if (options.includeValidation) {
        try {
          validation = await schemaGuard.validateModelStructure(modelName, model.schema);
        } catch (error) {
          logger.warn(chalk.yellow(`⚠️ 无法验证模式: ${modelName} - ${error.message}`));
        }
      }
      
      // 检查是否冻结
      const isFrozen = guardStatus.frozenModels.includes(modelName);
      
      // 收集模式数据
      schemasData.push({
        name: modelName,
        fields: fields,
        history: history,
        validation: validation,
        isFrozen: isFrozen,
        collectionName: model.collection.name
      });
    } catch (error) {
      logger.error(chalk.red(`❌ 处理模式失败: ${modelName} - ${error.message}`));
    }
  }
  
  // 分析模型间的关系（如果启用）
  let relations = null;
  if (options.includeRelations) {
    relations = analyzeSchemaRelations(models);
  }
  
  logger.info(chalk.green(`✅ 已收集 ${schemasData.length} 个模式的数据`));
  
  return {
    schemas: schemasData,
    relations: relations,
    stats: {
      totalSchemas: schemasData.length,
      frozenSchemas: guardStatus.frozenModels.length,
      timestamp: new Date().toISOString()
    }
  };
}

/**
 * 生成HTML报告
 */
async function generateHtmlReport(data, options) {
  try {
    logger.info(chalk.blue('🔄 生成HTML报告...'));
    
    // 确保输出目录存在
    if (!fs.existsSync(options.outputDir)) {
      fs.mkdirSync(options.outputDir, { recursive: true });
    }
    
    // 读取模板
    let templateContent;
    
    // 如果模板文件不存在，使用内联模板
    if (!fs.existsSync(options.templatePath)) {
      logger.warn(chalk.yellow(`⚠️ 模板文件不存在: ${options.templatePath}，使用内置模板`));
      templateContent = `
      <!DOCTYPE html>
      <html lang="zh-CN">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>数据库模式可视化</title>
        <style>
          body { font-family: 'Arial', sans-serif; line-height: 1.6; color: #333; max-width: 1200px; margin: 0 auto; padding: 20px; }
          h1, h2, h3 { color: #2c3e50; }
          table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
          th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
          th { background-color: #f2f2f2; }
          tr:nth-child(even) { background-color: #f9f9f9; }
          .card { border: 1px solid #ddd; border-radius: 4px; padding: 15px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
          .frozen { background-color: #e8f4fe; }
          .required { color: #e74c3c; }
          .badge { display: inline-block; padding: 3px 7px; border-radius: 3px; font-size: 12px; margin-right: 5px; }
          .badge-frozen { background-color: #3498db; color: white; }
          .badge-ref { background-color: #2ecc71; color: white; }
          .relation-diagram { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 4px; }
          .tabs { display: flex; margin-bottom: -1px; }
          .tab { padding: 10px 20px; border: 1px solid #ddd; background: #f8f8f8; cursor: pointer; border-radius: 4px 4px 0 0; margin-right: 5px; }
          .tab.active { background: white; border-bottom-color: white; }
          .tab-content { display: none; border: 1px solid #ddd; padding: 20px; }
          .tab-content.active { display: block; }
        </style>
        <script src="https://cdn.jsdelivr.net/npm/mermaid@8.13.10/dist/mermaid.min.js"></script>
      </head>
      <body>
        <h1>数据库模式可视化</h1>
        
        <div class="card">
          <h2>概览</h2>
          <p>总模式数: {{stats.totalSchemas}}</p>
          <p>已冻结模式数: {{stats.frozenSchemas}}</p>
          <p>生成时间: {{stats.timestamp}}</p>
        </div>

        {{#if relations}}
        <div class="card">
          <h2>模式关系图</h2>
          <div class="relation-diagram">
            <div class="mermaid">
              graph TD;
              {{#each relations}}
              {{from}}--"{{fieldName}} ({{type}})"-->{{to}};
              {{/each}}
            </div>
          </div>
        </div>
        {{/if}}
        
        <h2>所有模式</h2>
        {{#each schemas}}
        <div class="card {{#if isFrozen}}frozen{{/if}}">
          <h3>
            {{name}} 
            {{#if isFrozen}}<span class="badge badge-frozen">已冻结</span>{{/if}}
          </h3>
          <p>集合名: {{collectionName}}</p>
          
          <div class="tabs">
            <div class="tab active" onclick="showTab('fields-{{@index}}', this)">字段</div>
            {{#if history}}
            <div class="tab" onclick="showTab('history-{{@index}}', this)">历史</div>
            {{/if}}
            {{#if validation}}
            <div class="tab" onclick="showTab('validation-{{@index}}', this)">验证</div>
            {{/if}}
          </div>
          
          <div id="fields-{{@index}}" class="tab-content active">
            <table>
              <tr>
                <th>字段路径</th>
                <th>类型</th>
                <th>必需</th>
                <th>默认值</th>
              </tr>
              {{#each fields}}
              <tr>
                <td>{{path}}</td>
                <td>
                  {{type}}
                  {{#if isRef}}<span class="badge badge-ref">引用</span>{{/if}}
                </td>
                <td>{{#if required}}是{{else}}否{{/if}}</td>
                <td>{{default}}</td>
              </tr>
              {{/each}}
            </table>
          </div>
          
          {{#if history}}
          <div id="history-{{@index}}" class="tab-content">
            <table>
              <tr>
                <th>时间</th>
                <th>动作</th>
                <th>详情</th>
              </tr>
              {{#each history}}
              <tr>
                <td>{{timestamp}}</td>
                <td>{{action}}</td>
                <td>{{details}}</td>
              </tr>
              {{/each}}
            </table>
          </div>
          {{/if}}
          
          {{#if validation}}
          <div id="validation-{{@index}}" class="tab-content">
            <p>状态: {{#if validation.valid}}有效{{else}}无效{{/if}}</p>
            
            {{#if validation.issues}}
            <table>
              <tr>
                <th>级别</th>
                <th>消息</th>
              </tr>
              {{#each validation.issues}}
              <tr>
                <td>{{level}}</td>
                <td>{{message}}</td>
              </tr>
              {{/each}}
            </table>
            {{/if}}
          </div>
          {{/if}}
        </div>
        {{/each}}
        
        <script>
          // 初始化 Mermaid
          mermaid.initialize({ startOnLoad: true });
          
          // 标签切换函数
          function showTab(tabId, tabElement) {
            // 获取所有相关的内容和标签
            const tabParent = tabElement.parentElement;
            const contentParent = tabParent.nextElementSibling;
            const allContents = contentParent.parentElement.querySelectorAll('.tab-content');
            const allTabs = tabParent.querySelectorAll('.tab');
            
            // 隐藏所有内容，取消所有标签的激活状态
            allContents.forEach(content => content.classList.remove('active'));
            allTabs.forEach(tab => tab.classList.remove('active'));
            
            // 显示选定的内容，激活选定的标签
            document.getElementById(tabId).classList.add('active');
            tabElement.classList.add('active');
          }
        </script>
      </body>
      </html>
      `;
    } else {
      templateContent = fs.readFileSync(options.templatePath, 'utf8');
    }
    
    // 编译模板
    const template = handlebars.compile(templateContent);
    const html = template(data);
    
    // 写入文件
    const outputPath = path.join(options.outputDir, options.outputFilename);
    fs.writeFileSync(outputPath, html);
    
    logger.info(chalk.green(`✅ HTML报告已生成: ${outputPath}`));
    return outputPath;
  } catch (error) {
    logger.error(chalk.red(`❌ 生成HTML报告失败: ${error.message}`));
    throw error;
  }
}

/**
 * 主函数
 */
async function main(customOptions = {}) {
  try {
    // 合并配置
    const options = { ...DEFAULT_CONFIG, ...customOptions };
    
    // 连接数据库
    const connected = await connectToDatabase();
    if (!connected) process.exit(1);
    
    // 加载模型
    const modelNames = await loadModels();
    if (modelNames.length === 0) process.exit(1);
    
    // 收集模式数据
    const data = await collectSchemaData(options);
    
    // 生成HTML报告
    const reportPath = await generateHtmlReport(data, options);
    
    // 关闭数据库连接
    await mongoose.connection.close();
    
    return {
      success: true,
      reportPath: reportPath
    };
  } catch (error) {
    logger.error(chalk.red(`❌ 脚本执行失败: ${error.message}`));
    
    if (mongoose.connection.readyState === 1) {
      await mongoose.connection.close();
    }
    
    return {
      success: false,
      error: error.message
    };
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  const args = process.argv.slice(2);
  const customOptions = {};
  
  // 解析命令行参数
  for (let i = 0; i < args.length; i += 2) {
    const key = args[i].replace(/^--/, '');
    const value = args[i + 1];
    
    if (key && value) {
      if (value === 'true') customOptions[key] = true;
      else if (value === 'false') customOptions[key] = false;
      else customOptions[key] = value;
    }
  }
  
  main(customOptions)
    .then(result => {
      if (result.success) {
        console.log(chalk.green(`\n✅ 报告已成功生成: ${result.reportPath}`));
        process.exit(0);
      } else {
        console.error(chalk.red(`\n❌ 报告生成失败: ${result.error}`));
        process.exit(1);
      }
    })
    .catch(error => {
      console.error(chalk.red(`\n❌ 意外错误: ${error.message}`));
      process.exit(1);
    });
}

module.exports = {
  main,
  collectSchemaData,
  generateHtmlReport
}; 