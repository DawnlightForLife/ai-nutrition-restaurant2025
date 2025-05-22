/**
 * ✅ 模块名：trafficCapture.js
 * ✅ 所属系统：dbLoadTest
 * ✅ 功能概述：
 *   - 捕获所有 MongoDB 数据库操作请求及元信息
 *   - 支持脱敏处理、采样率控制、捕获文件轮换、元数据附加
 *   - 可输出 JSON 格式的完整捕获数据，用于回放或压测
 * ✅ 使用方式：
 *   const capture = require('./trafficCapture');
 *   capture.startCapture('myTest'); // 开始捕获
 *   capture.captureOperation(reqData); // 捕获一条记录
 *   capture.stopCapture(); // 停止并写入文件
 */
/**
 * 数据库负载测试流量捕获模块
 * 用于捕获和记录数据库操作，以便后续负载测试使用
 */
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const config = require('./config');

class TrafficCapture {
  constructor(options = {}) {
    // 初始化配置项并确保捕获目录存在
    this.options = {
      ...config.capture,
      ...options
    };
    
    this.captureActive = false;
    this.captureData = [];
    this.captureFileName = this.options.defaultCaptureFile;
    this.startTime = null;
    
    // 确保捕获目录存在
    if (!fs.existsSync(this.options.captureDir)) {
      fs.mkdirSync(this.options.captureDir, { recursive: true });
    }
  }
  
  /**
   * 开始捕获流量
   * @param {string} captureName 可选的捕获名称
   * @returns {boolean} 是否成功开始捕获
   */
  startCapture(captureName = '') {
    if (this.captureActive) {
      console.warn('[TrafficCapture] 流量捕获已在进行中');
      return false;
    }
    
    this.captureActive = true;
    this.captureData = [];
    this.startTime = new Date();
    
    // 如果提供了名称，使用它来创建文件名
    if (captureName) {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      this.captureFileName = `${captureName}_${timestamp}.json`;
    } else {
      this.captureFileName = this.options.defaultCaptureFile;
    }
    
    console.log(`开始流量捕获: ${this.captureFileName}`);
    return true;
  }
  
  /**
   * 停止捕获流量
   * @returns {string} 捕获文件路径
   */
  stopCapture() {
    if (!this.captureActive) {
      console.warn('[TrafficCapture] 没有活动的流量捕获');
      return null;
    }
    
    this.captureActive = false;
    const endTime = new Date();
    const duration = (endTime - this.startTime) / 1000; // 秒
    
    // 添加元数据
    const metadata = {
      captureStartTime: this.startTime.toISOString(),
      captureEndTime: endTime.toISOString(),
      captureDuration: duration,
      totalRequests: this.captureData.length,
      timestamp: new Date().toISOString()
    };
    
    // 保存捕获数据
    const captureFilePath = path.join(this.options.captureDir, this.captureFileName);
    const captureContent = {
      metadata,
      requests: this.captureData
    };
    
    fs.writeFileSync(
      captureFilePath,
      JSON.stringify(captureContent, null, 2),
      'utf8'
    );
    
    console.log(`流量捕获已完成: ${captureFilePath} (${this.captureData.length}个请求)`);
    return captureFilePath;
  }
  
  /**
   * 记录数据库操作
   * @param {Object} data 数据库操作数据
   */
  captureOperation(data) {
    if (!this.captureActive) {
      return;
    }
    
    // 检查是否达到了最大捕获大小
    if (this.captureData.length >= this.options.maxCaptureSize) {
      console.warn(`[TrafficCapture] 已达到最大捕获大小 (${this.options.maxCaptureSize})，新请求将被丢弃`);
      return;
    }
    
    // 应用采样率
    if (this.options.sampleRate < 1.0 && Math.random() > this.options.sampleRate) {
      return;
    }
    
    // 格式化数据
    const formattedData = this.formatCaptureData(data);
    
    // 如果启用了脱敏，处理敏感数据
    const processedData = this.options.anonymizeSensitiveData 
      ? this.anonymizeSensitiveData(formattedData)
      : formattedData;
    
    this.captureData.push(processedData);
  }
  
  /**
   * 格式化捕获数据
   * @param {Object} data 原始数据
   * @returns {Object} 格式化的数据
   */
  formatCaptureData(data) {
    const timestamp = new Date().toISOString();
    const requestId = crypto.randomUUID();
    
    return {
      id: requestId,
      timestamp,
      operation: {
        type: data.operation,
        collection: data.collection,
        model: data.model,
        query: data.query,
        options: data.options,
        projection: data.projection,
        pipeline: data.pipeline,
        update: data.update,
        fields: data.fields
      },
      metadata: {
        source: data.source || 'api',
        userAgent: data.userAgent,
        ip: data.ip,
        duration: data.duration
      }
    };
  }
  
  /**
   * 脱敏敏感数据
   * @param {Object} data 原始数据对象
   * @returns {Object} 脱敏后的数据对象
   */
  anonymizeSensitiveData(data) {
    const clonedData = JSON.parse(JSON.stringify(data));
    
    // 检查是否为敏感集合
    if (this.options.sensitiveCollections.includes(clonedData.operation.collection)) {
      // 为敏感集合应用更严格的脱敏规则
      this.applySensitiveCollectionRules(clonedData);
    }
    
    // 遍历敏感字段列表
    this.options.sensitiveFields.forEach(field => {
      // 检查查询中的敏感字段
      if (clonedData.operation.query) {
        this.anonymizeField(clonedData.operation.query, field);
      }
      
      // 检查更新操作中的敏感字段
      if (clonedData.operation.update) {
        this.anonymizeField(clonedData.operation.update, field);
      }
      
      // 检查聚合管道中的敏感字段
      if (clonedData.operation.pipeline && Array.isArray(clonedData.operation.pipeline)) {
        clonedData.operation.pipeline.forEach(stage => {
          Object.values(stage).forEach(value => {
            if (typeof value === 'object' && value !== null) {
              this.anonymizeField(value, field);
            }
          });
        });
      }
    });
    
    // 脱敏元数据
    if (clonedData.metadata) {
      if (clonedData.metadata.ip) {
        clonedData.metadata.ip = this.anonymizeIp(clonedData.metadata.ip);
      }
    }
    
    return clonedData;
  }
  
  /**
   * 在对象中脱敏特定字段
   * @param {Object} obj 要处理的对象
   * @param {string} field 要脱敏的字段名
   */
  // ⚠️ 注意：字段匹配支持模糊包含（key 包含敏感字段名时即处理）
  anonymizeField(obj, field) {
    if (typeof obj !== 'object' || obj === null) {
      return;
    }
    
    for (const key in obj) {
      if (key === field || key.toLowerCase().includes(field.toLowerCase())) {
        // 根据字段类型选择不同的脱敏方法
        const value = obj[key];
        
        if (typeof value === 'string') {
          obj[key] = this.anonymizeString(value);
        } else if (typeof value === 'number') {
          obj[key] = 0;
        } else if (Array.isArray(value)) {
          obj[key] = value.map(item => 
            typeof item === 'string' ? this.anonymizeString(item) : item
          );
        }
      } else if (typeof obj[key] === 'object' && obj[key] !== null) {
        this.anonymizeField(obj[key], field);
      }
    }
  }
  
  /**
   * 对敏感集合应用特殊脱敏规则
   * @param {Object} data 数据对象
   */
  applySensitiveCollectionRules(data) {
    // 对敏感集合，我们可能想要更彻底地脱敏或者甚至移除某些操作类型
    if (['find', 'findOne'].includes(data.operation.type)) {
      // 保留查询结构，但移除实际值
      if (data.operation.query && typeof data.operation.query === 'object') {
        Object.keys(data.operation.query).forEach(key => {
          const value = data.operation.query[key];
          
          if (typeof value === 'string') {
            data.operation.query[key] = 'xxx';
          } else if (typeof value === 'number') {
            data.operation.query[key] = 0;
          } else if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
            // 处理操作符查询，例如 {$gt: 100}
            Object.keys(value).forEach(opKey => {
              if (opKey.startsWith('$')) {
                const opValue = value[opKey];
                if (typeof opValue === 'string') {
                  value[opKey] = 'xxx';
                } else if (typeof opValue === 'number') {
                  value[opKey] = 0;
                }
              }
            });
          }
        });
      }
    }
  }
  
  /**
   * 脱敏字符串
   * @param {string} str 要脱敏的字符串
   * @returns {string} 脱敏后的字符串
   */
  anonymizeString(str) {
    if (!str || str.length < 3) {
      return 'xxx';
    }
    
    // 如果是邮箱地址，使用特殊处理
    if (str.includes('@')) {
      return 'user@example.com';
    }
    
    // 如果看起来像是JWT或其他令牌
    if (str.length > 30 && /^[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+$/.test(str)) {
      return 'jwt.token.xxx';
    }
    
    // 如果是电话号码
    if (/^[\d\+\-\(\) ]{7,15}$/.test(str)) {
      return '+1234567890';
    }
    
    // 通用脱敏
    return 'xxx' + crypto.createHash('md5').update(str).digest('hex').substring(0, 8);
  }
  
  /**
   * 脱敏IP地址
   * @param {string} ip IP地址
   * @returns {string} 脱敏后的IP地址
   */
  anonymizeIp(ip) {
    if (!ip) return '';
    
    // 对于IPv4
    if (ip.includes('.')) {
      const parts = ip.split('.');
      return `${parts[0]}.${parts[1]}.0.0`;
    }
    
    // 对于IPv6
    if (ip.includes(':')) {
      const parts = ip.split(':');
      const firstTwo = parts.slice(0, 2);
      return `${firstTwo.join(':')}::0`;
    }
    
    return ip;
  }
  
  /**
   * 获取所有可用的捕获文件
   * @returns {Array} 捕获文件列表
   */
  getCaptureFiles() {
    try {
      const files = fs.readdirSync(this.options.captureDir)
        .filter(file => file.endsWith('.json'))
        .map(file => {
          const fullPath = path.join(this.options.captureDir, file);
          const stats = fs.statSync(fullPath);
          
          return {
            name: file,
            path: fullPath,
            size: stats.size,
            created: stats.birthtime
          };
        })
        .sort((a, b) => b.created - a.created); // 按创建时间倒序排列
      
      return files;
    } catch (error) {
      console.error('[TrafficCapture] 获取捕获文件列表失败:', error);
      return [];
    }
  }
  
  /**
   * 加载捕获文件
   * @param {string} fileName 文件名或路径
   * @returns {Object} 加载的捕获数据
   */
  loadCaptureFile(fileName) {
    try {
      const filePath = fileName.includes(path.sep) 
        ? fileName 
        : path.join(this.options.captureDir, fileName);
      
      if (!fs.existsSync(filePath)) {
        throw new Error(`文件不存在: ${filePath}`);
      }
      
      const fileContent = fs.readFileSync(filePath, 'utf8');
      return JSON.parse(fileContent);
    } catch (error) {
      console.error('[TrafficCapture] 加载捕获文件失败:', error);
      return null;
    }
  }
  
  /**
   * 获取当前捕获状态摘要，供前端或控制面板使用
   */
  getStatus() {
    return {
      active: this.captureActive,
      fileName: this.captureFileName,
      requestCount: this.captureData.length,
      startTime: this.startTime ? this.startTime.toISOString() : null,
      elapsedSeconds: this.startTime ? (new Date() - this.startTime) / 1000 : 0,
      config: {
        maxCaptureSize: this.options.maxCaptureSize,
        sampleRate: this.options.sampleRate,
        anonymizeSensitiveData: this.options.anonymizeSensitiveData
      }
    };
  }
}

// 导出单例实例
module.exports = new TrafficCapture(); 