/**
 * ✅ 模块名：schema-visualization-helper.js
 * ✅ 适用环境：MongoDB Mongoose 数据结构分析 + 可视化模板辅助（Handlebars）
 * ✅ 功能概览：
 *   - registerHelpers：注册通用模板辅助函数（条件判断、格式化、截断、JSON输出等）
 *   - processSchemaData：从原始 mongoose schema 提取字段信息（类型、引用、嵌套）
 *   - extractRelations：抽取模型之间的引用关系
 *   - generateStats：统计模式数量、冻结模型数量、关系数量等
 *   - prepareTemplateContext：将处理后的 schema 数据与统计结果封装成模板上下文
 * ✅ 高可用设计：
 *   - 递归处理嵌套字段
 *   - 支持引用字段自动识别（isRef）
 *   - 使用 moment 统一处理时间格式与相对时间
 * ✅ 建议未来扩展：
 *   - 增加字段类型图标映射（如 String → "🔤"）
 *   - 支持 schema history 展示结构 diff
 *   - 支持导出多格式结构图（markdown、plantUML、svg）
 */

const moment = require('moment');
moment.locale('zh-cn');

/**
 * 注册所有需要的Handlebars助手函数
 * @param {Object} handlebars - Handlebars实例
 */
function registerHelpers(handlebars) {
  // 比较助手 - 用于模板中的条件判断
  handlebars.registerHelper('eq', function(a, b) {
    return a === b;
  });
  
  handlebars.registerHelper('neq', function(a, b) {
    return a !== b;
  });
  
  handlebars.registerHelper('gt', function(a, b) {
    return a > b;
  });
  
  handlebars.registerHelper('lt', function(a, b) {
    return a < b;
  });
  
  handlebars.registerHelper('and', function() {
    return Array.prototype.slice.call(arguments, 0, -1).every(Boolean);
  });
  
  handlebars.registerHelper('or', function() {
    return Array.prototype.slice.call(arguments, 0, -1).some(Boolean);
  });
  
  // 格式化日期时间，默认格式 'YYYY-MM-DD HH:mm:ss'
  handlebars.registerHelper('formatDate', function(date, format) {
    if (!date) return '';
    return moment(date).format(format || 'YYYY-MM-DD HH:mm:ss');
  });
  
  // 相对时间显示（如“3小时前”）
  handlebars.registerHelper('fromNow', function(date) {
    if (!date) return '';
    return moment(date).fromNow();
  });
  
  // 截断文本超过指定长度，添加省略号
  handlebars.registerHelper('truncate', function(text, length) {
    if (!text) return '';
    length = length || 100;
    if (text.length <= length) return text;
    return text.substring(0, length) + '...';
  });
  
  // JSON格式化输出，便于调试展示
  handlebars.registerHelper('json', function(context) {
    return JSON.stringify(context, null, 2);
  });
  
  // 根据条件返回对应的class类名
  handlebars.registerHelper('className', function(condition, trueClass, falseClass) {
    return condition ? trueClass : (falseClass || '');
  });
}

/**
 * 处理模式数据以便于在模板中显示
 * @param {Array} schemas - 从数据库获取的原始模式数据
 * @param {Object} options - 处理选项
 * @returns {Array} 处理后的模式数据
 */
function processSchemaData(schemas, options = {}) {
  return schemas.map(schema => {
    // 提取字段信息
    const fields = [];
    
    function processField(field, path = '') {
      // 遍历并处理字段，支持嵌套字段（嵌套 schema）递归展开
      const currentPath = path ? `${path}.${field.path}` : field.path;
      
      // 处理嵌套模式
      if (field.schema && field.schema.paths) {
        Object.values(field.schema.paths).forEach(nestedField => {
          processField(nestedField, currentPath);
        });
      } else {
        // 添加普通字段
        fields.push({
          // path：字段路径（支持 a.b.c）
          path: currentPath,
          // type：字段类型（默认 Mixed）
          type: field.instance || 'Mixed',
          // isRef：是否为引用字段（含 ref）
          isRef: !!field.options && !!field.options.ref,
          // ref：引用模型名称
          ref: field.options ? field.options.ref : null,
          // isArray：是否为数组字段
          isArray: field.instance === 'Array',
          // isNested：是否为嵌套结构
          isNested: !!field.schema,
          // required：字段是否必填
          required: field.isRequired || false,
          // default：默认值（字符串表示）
          default: field.defaultValue !== undefined ? 
                  JSON.stringify(field.defaultValue) : ''
        });
      }
    }
    
    // 处理所有顶级字段
    Object.values(schema.paths || {}).forEach(field => {
      processField(field);
    });
    
    // 返回处理后的模式对象
    return {
      name: schema.modelName || '未命名模型',
      collectionName: schema.collection || '',
      isFrozen: schema.isFrozen || false,
      fields: fields,
      history: schema.history || [],
      validation: schema.validation || { valid: true }
    };
  });
}

/**
 * 从模式和字段数据中提取关系信息
 * @param {Array} schemas - 处理后的模式数据
 * @returns {Array} 模式间的关系数据
 */
function extractRelations(schemas) {
  const relations = [];
  
  schemas.forEach(schema => {
    schema.fields.forEach(field => {
      if (field.isRef && field.ref) {
        relations.push({
          from: schema.name,
          to: field.ref,
          fieldName: field.path,
          type: field.isArray ? '数组引用' : '引用'
        });
      }
    });
  });
  
  return relations;
}

/**
 * 生成报告所需的统计数据
 * @param {Array} schemas - 处理后的模式数据
 * @param {Array} relations - 关系数据
 * @returns {Object} 统计信息
 */
function generateStats(schemas, relations) {
  return {
    totalSchemas: schemas.length,
    // frozenSchemas：冻结模型数量
    frozenSchemas: schemas.filter(s => s.isFrozen).length,
    // relationCount：模型间引用数量
    relationCount: relations.length,
    timestamp: moment().format('YYYY-MM-DD HH:mm:ss')
  };
}

/**
 * 准备模板上下文数据
 * @param {Array} rawSchemas - 原始模式数据
 * @param {Object} options - 处理选项
 * @returns {Object} 用于模板渲染的数据
 */
function prepareTemplateContext(rawSchemas, options = {}) {
  const processedSchemas = processSchemaData(rawSchemas, options);
  const relations = extractRelations(processedSchemas);
  const stats = generateStats(processedSchemas, relations);
  
  return {
    schemas: processedSchemas,
    relations: relations,
    stats: stats
  };
}

module.exports = {
  registerHelpers,
  processSchemaData,
  extractRelations,
  generateStats,
  prepareTemplateContext
};