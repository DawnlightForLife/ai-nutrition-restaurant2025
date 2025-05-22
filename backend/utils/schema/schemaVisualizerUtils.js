/**
 * Schema可视化工具类
 * 用于前端图谱可视化、字段差异对比、模型时间线展示等场景
 * 支持 Vis.js、D3.js 等前端图形库所需数据格式生成
 * @module utils/schemaVisualizerUtils
 */

/**
 * 为前端提供的Schema可视化工具类
 */
class SchemaVisualizerUtils {
  /**
   * 生成模型之间的关系图
   * 将所有模型字段中的 ref 引用生成节点与边结构
   * 可用于 Vis.js 或 Cytoscape.js 可视化拓扑图渲染
   * @param {Object} schemaData - 从SchemaTransformer获取的模式数据
   * @returns {Object} 格式化后的节点和边数据，适用于可视化图表
   */
  static generateRelationshipGraph(schemaData) {
    // 初始化节点和边数组
    const nodes = [];
    const edges = [];
    
    // 为每个模型创建一个节点
    Object.keys(schemaData).forEach((modelName, index) => {
      nodes.push({
        id: modelName,
        label: modelName,
        title: this._generateNodeTooltip(schemaData[modelName]),
        group: Math.floor(index % 5), // 简单的颜色分组
        value: Object.keys(schemaData[modelName].fields).length // 节点大小基于字段数量
      });
    });
    
    // 遍历所有模型的关系，创建边
    Object.keys(schemaData).forEach(modelName => {
      const modelData = schemaData[modelName];
      
      if (modelData.relationships && modelData.relationships.length > 0) {
        modelData.relationships.forEach(rel => {
          // 创建边，避免重复边
          const edgeId = `${rel.from}-${rel.to}`;
          const reverseEdgeId = `${rel.to}-${rel.from}`;
          
          // 检查是否已存在此边
          const existingEdge = edges.find(e => e.id === edgeId || e.id === reverseEdgeId);
          
          if (!existingEdge) {
            edges.push({
              id: edgeId,
              from: rel.from,
              to: rel.to,
              label: rel.type,
              arrows: 'to',
              title: `${rel.fieldName}: ${rel.description || rel.type}`
            });
          }
        });
      }
    });
    
    return { nodes, edges };
  }
  
  /**
   * @private
   * 生成单个模型节点的 tooltip 提示 HTML
   * 包括字段列表、索引信息，适用于可视化展示
   * @param {Object} modelData - 模型数据
   * @returns {String} HTML格式的提示信息
   */
  static _generateNodeTooltip(modelData) {
    let tooltip = `<div class="schema-tooltip">`;
    tooltip += `<h3>${modelData.name}</h3>`;
    tooltip += `<div class="schema-fields">`;
    
    // 添加所有字段信息
    Object.keys(modelData.fields).forEach(fieldName => {
      const field = modelData.fields[fieldName];
      tooltip += `<div class="field">`;
      tooltip += `<span class="field-name">${fieldName}</span>: `;
      tooltip += `<span class="field-type">${field.type}</span>`;
      
      // 添加字段属性（如果有）
      if (field.required) {
        tooltip += `<span class="field-required">必填</span>`;
      }
      
      if (field.unique) {
        tooltip += `<span class="field-unique">唯一</span>`;
      }
      
      if (field.ref) {
        tooltip += `<span class="field-ref">引用: ${field.ref}</span>`;
      }
      
      tooltip += `</div>`;
    });
    
    tooltip += `</div>`;
    
    // 添加索引信息（如果有）
    if (modelData.indexes && modelData.indexes.length > 0) {
      tooltip += `<div class="schema-indexes">`;
      tooltip += `<h4>索引</h4>`;
      tooltip += `<ul>`;
      
      modelData.indexes.forEach(index => {
        tooltip += `<li>${JSON.stringify(index.fields)}`;
        if (index.unique) {
          tooltip += ` (唯一)`;
        }
        tooltip += `</li>`;
      });
      
      tooltip += `</ul>`;
      tooltip += `</div>`;
    }
    
    tooltip += `</div>`;
    return tooltip;
  }
  
  /**
   * 生成模式变更历史的时间线数据
   * 每个历史记录可视化为一个时间线节点（用于 Vis.js Timeline 等组件）
   * @param {Array} schemaHistory - 模式历史数据
   * @returns {Array} 格式化后的时间线数据
   */
  static generateHistoryTimeline(schemaHistory) {
    if (!schemaHistory || !Array.isArray(schemaHistory)) {
      return [];
    }
    
    return schemaHistory.map((entry, index) => {
      const timestamp = new Date(entry.timestamp);
      
      return {
        id: index,
        content: `${entry.action} by ${entry.userId || 'System'}`,
        title: entry.description || `Schema ${entry.action} at ${timestamp.toLocaleString()}`,
        start: timestamp,
        type: this._getTimelineItemType(entry.action)
      };
    });
  }
  
  /**
   * @private
   * 根据操作类型（如创建、修改、冻结）决定时间线项目的视觉类型
   * @param {String} action - 操作类型
   * @returns {String} 时间线项目类型
   */
  static _getTimelineItemType(action) {
    switch (action) {
      case 'CREATED':
        return 'point';
      case 'MODIFIED':
        return 'box';
      case 'FROZEN':
        return 'background';
      case 'UNFROZEN':
        return 'background';
      default:
        return 'point';
    }
  }
  
  /**
   * 比较两个模型的字段结构，生成字段级别的差异清单
   * 标记字段的添加、删除、修改，并指明是否有变更
   * @param {Object} oldSchema - 旧模式对象
   * @param {Object} newSchema - 新模式对象
   * @returns {Object} 包含添加、删除和修改的字段差异
   */
  static generateSchemaDiff(oldSchema, newSchema) {
    if (!oldSchema || !newSchema) {
      return null;
    }
    
    const oldFields = oldSchema.fields || {};
    const newFields = newSchema.fields || {};
    
    const added = [];
    const removed = [];
    const modified = [];
    
    // 查找添加和修改的字段
    Object.keys(newFields).forEach(fieldName => {
      if (!oldFields[fieldName]) {
        added.push({
          field: fieldName,
          details: newFields[fieldName]
        });
      } else if (JSON.stringify(oldFields[fieldName]) !== JSON.stringify(newFields[fieldName])) {
        modified.push({
          field: fieldName,
          oldDetails: oldFields[fieldName],
          newDetails: newFields[fieldName]
        });
      }
    });
    
    // 查找删除的字段
    Object.keys(oldFields).forEach(fieldName => {
      if (!newFields[fieldName]) {
        removed.push({
          field: fieldName,
          details: oldFields[fieldName]
        });
      }
    });
    
    return {
      added,
      removed,
      modified,
      hasChanges: added.length > 0 || removed.length > 0 || modified.length > 0
    };
  }
  
  /**
   * 生成 D3.js 所需的树形结构格式，展示模型与字段的层级关系
   * @param {Object} schemaData - 从SchemaTransformer获取的模式数据
   * @returns {Object} 格式化后的树形结构数据
   */
  static generateSchemaTree(schemaData) {
    const root = {
      name: "数据库模式",
      children: []
    };
    
    Object.keys(schemaData).forEach(modelName => {
      const modelData = schemaData[modelName];
      const modelNode = {
        name: modelName,
        children: []
      };
      
      // 添加字段作为子节点
      Object.keys(modelData.fields).forEach(fieldName => {
        const field = modelData.fields[fieldName];
        modelNode.children.push({
          name: fieldName,
          type: field.type,
          size: field.required ? 2000 : 1000, // 必填字段显示更大
          required: field.required,
          unique: field.unique,
          ref: field.ref
        });
      });
      
      root.children.push(modelNode);
    });
    
    return root;
  }
}

module.exports = SchemaVisualizerUtils;