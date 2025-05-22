/**
 * CaptureManager 类负责数据库流量的采集与保存。
 * 主要功能包括：开始/停止捕获、匿名化、文件轮换与统计信息生成。
 */
/**
 * 数据库流量捕获管理器
 * 负责拦截和记录数据库操作，以便后续进行负载测试
 */
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const os = require('os');
const config = require('./config');

class CaptureManager {
  /**
   * 创建一个新的捕获管理器实例
   * @param {Object} options - 捕获选项，会覆盖默认配置
   */
  constructor(options = {}) {
    // 合并默认配置和用户提供的选项
    this.config = { ...config.capture, ...options };
    
    // 初始化捕获状态
    this.isCapturing = false;
    this.captureStartTime = null;
    this.capturedRequests = [];
    this.metadata = {};
    this.currentCaptureFile = null;
    
    // 确保捕获目录存在
    this._ensureDirExists(this.config.captureDir);
  }
  
  /**
   * 开始捕获数据库流量
   * @param {string} captureLabel - 可选的捕获标签，用于文件命名
   * @returns {Object} 捕获会话信息
   */
  startCapture(captureLabel = '') {
    if (this.isCapturing) {
      throw new Error('捕获已经在进行中');
    }
    
    this.isCapturing = true;
    this.captureStartTime = new Date();
    this.capturedRequests = [];
    
    // 初始化元数据
    this.metadata = this._initMetadata();
    
    // 生成唯一捕获文件名：格式为 capture-时间戳-标签.json
    const timestamp = this._formatDate(this.captureStartTime);
    const label = captureLabel ? `-${captureLabel.replace(/[^a-z0-9-]/gi, '_')}` : '';
    this.currentCaptureFile = path.join(
      this.config.captureDir,
      `capture-${timestamp}${label}.json`
    );
    
    console.log(`[CaptureManager] 开始捕获数据库流量，输出文件: ${this.currentCaptureFile}`);
    
    return {
      captureFile: this.currentCaptureFile,
      startTime: this.captureStartTime,
      metadata: this.metadata
    };
  }
  
  /**
   * 停止当前捕获并保存结果
   * @returns {Object} 捕获结果统计
   */
  stopCapture() {
    if (!this.isCapturing) {
      throw new Error('当前没有活动的捕获会话');
    }
    
    const endTime = new Date();
    this.metadata.endTime = endTime;
    this.metadata.duration = endTime - this.captureStartTime;
    this.metadata.totalRequests = this.capturedRequests.length;
    
    // 计算请求统计信息
    const stats = this._calculateStats();
    this.metadata.stats = stats;
    
    // 保存捕获文件
    const captureData = {
      metadata: this.metadata,
      requests: this.capturedRequests
    };
    
    fs.writeFileSync(
      this.currentCaptureFile,
      JSON.stringify(captureData, null, 2),
      'utf8'
    );
    
    // 重置捕获状态
    const result = {
      file: this.currentCaptureFile,
      startTime: this.captureStartTime,
      endTime: endTime,
      duration: this.metadata.duration,
      requestCount: this.capturedRequests.length,
      stats: stats
    };
    
    this.isCapturing = false;
    this.captureStartTime = null;
    this.capturedRequests = [];
    this.metadata = {};
    this.currentCaptureFile = null;
    
    console.log(`[CaptureManager] 数据库流量捕获已完成，共捕获 ${result.requestCount} 个请求`);
    
    return result;
  }
  
  /**
   * 记录数据库请求
   * @param {Object} request - 数据库请求对象
   * @returns {boolean} 是否成功记录
   */
  captureRequest(request) {
    if (!this.isCapturing) {
      return false;
    }
    
    // 应用采样率过滤
    if (Math.random() > this.config.samplingRate) {
      return false;
    }
    
    // 过滤不需要的操作和集合
    if (!this._shouldCaptureRequest(request)) {
      return false;
    }
    
    // 添加请求时间戳
    const timestampedRequest = {
      ...request,
      captureTimestamp: Date.now()
    };
    
    // 匿名化请求中的敏感字段，如手机号、身份证、IP 等
    const sanitizedRequest = this._anonymizeSensitiveData(timestampedRequest);
    
    // 添加到捕获列表
    this.capturedRequests.push(sanitizedRequest);
    
    // 检查是否达到最大捕获数量
    if (this.config.maxCaptureSize > 0 && 
        this.capturedRequests.length >= this.config.maxCaptureSize) {
      console.log(`[CaptureManager] 已达到最大捕获数量 (${this.config.maxCaptureSize})，自动停止捕获`);
      this.stopCapture();
    }
    
    // 检查是否需要轮换文件
    if (this.config.rotateFiles && this._shouldRotateFile()) {
      this._rotateFile();
    }
    
    return true;
  }
  
  /**
   * 获取捕获的请求数据
   * @returns {Array} 捕获的请求列表
   */
  getCapturedRequests() {
    return [...this.capturedRequests];
  }
  
  /**
   * 从文件加载捕获数据
   * @param {string} filePath - 捕获文件路径
   * @returns {Object} 加载的捕获数据
   */
  loadCaptureFromFile(filePath) {
    try {
      const fullPath = path.isAbsolute(filePath) 
        ? filePath 
        : path.join(this.config.captureDir, filePath);
      
      const data = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
      
      if (!data.requests || !Array.isArray(data.requests)) {
        throw new Error('无效的捕获文件格式：缺少请求数组');
      }
      
      return data;
    } catch (error) {
      throw new Error(`加载捕获文件失败: ${error.message}`);
    }
  }
  
  /**
   * 查找可用的捕获文件
   * @returns {Array} 可用捕获文件列表
   */
  listCaptureFiles() {
    try {
      const files = fs.readdirSync(this.config.captureDir)
        .filter(file => file.startsWith('capture-') && file.endsWith('.json'))
        .map(file => {
          const fullPath = path.join(this.config.captureDir, file);
          const stats = fs.statSync(fullPath);
          return {
            name: file,
            path: fullPath,
            size: stats.size,
            created: stats.birthtime
          };
        })
        .sort((a, b) => b.created - a.created); // 按创建时间降序排序
      
      return files;
    } catch (error) {
      console.error(`[CaptureManager] 列出捕获文件时出错: ${error.message}`);
      return [];
    }
  }
  
  /**
   * 合并多个捕获文件
   * @param {Array} fileList - 要合并的文件路径列表
   * @param {string} outputFile - 输出文件名
   * @returns {Object} 合并结果
   */
  mergeCaptureFiles(fileList, outputFile) {
    const mergedMetadata = { sources: [] };
    const mergedRequests = [];
    
    for (const file of fileList) {
      const data = this.loadCaptureFromFile(file);
      
      if (data.metadata) {
        mergedMetadata.sources.push({
          file: path.basename(file),
          startTime: data.metadata.startTime,
          endTime: data.metadata.endTime,
          requestCount: data.requests.length
        });
      }
      
      mergedRequests.push(...data.requests);
    }
    
    // 按时间戳排序请求
    mergedRequests.sort((a, b) => a.captureTimestamp - b.captureTimestamp);
    
    // 更新合并元数据
    mergedMetadata.totalRequests = mergedRequests.length;
    mergedMetadata.mergedAt = new Date();
    
    // 计算统计信息
    mergedMetadata.stats = this._calculateStatsFromRequests(mergedRequests);
    
    // 保存合并文件
    const outputPath = path.join(this.config.captureDir, outputFile);
    fs.writeFileSync(
      outputPath,
      JSON.stringify({ metadata: mergedMetadata, requests: mergedRequests }, null, 2),
      'utf8'
    );
    
    return {
      file: outputPath,
      requestCount: mergedRequests.length,
      sources: mergedMetadata.sources,
      stats: mergedMetadata.stats
    };
  }
  
  /**
   * 确保目录存在
   * @param {string} dir - 目录路径
   * @private
   */
  _ensureDirExists(dir) {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
      console.log(`[CaptureManager] 创建目录: ${dir}`);
    }
  }
  
  /**
   * 初始化捕获元数据
   * @returns {Object} 元数据对象
   * @private
   */
  _initMetadata() {
    const metadata = {
      captureVersion: '1.0',
      startTime: this.captureStartTime,
      samplingRate: this.config.samplingRate
    };
    
    // 添加系统信息
    if (this.config.includeMetadata) {
      for (const key of this.config.metadataKeys) {
        switch (key) {
          case 'hostname':
            metadata.hostname = os.hostname();
            break;
          case 'osInfo':
            metadata.osInfo = {
              platform: os.platform(),
              release: os.release(),
              type: os.type()
            };
            break;
          // 其他元数据字段可以在这里添加
        }
      }
    }
    
    return metadata;
  }
  
  /**
   * 判断是否应该捕获请求
   * @param {Object} request - 数据库请求对象
   * @returns {boolean} 是否应该捕获
   * @private
   */
  _shouldCaptureRequest(request) {
    // 检查操作类型
    if (this.config.includeOperations.length > 0 && 
        !this.config.includeOperations.includes(request.operation)) {
      return false;
    }
    
    if (this.config.excludeOperations.includes(request.operation)) {
      return false;
    }
    
    // 检查集合名称
    const collection = request.collection || '';
    
    if (this.config.includeCollections.length > 0 && 
        !this.config.includeCollections.some(c => collection.includes(c))) {
      return false;
    }
    
    if (this.config.excludeCollections.some(c => collection.includes(c))) {
      return false;
    }
    
    return true;
  }
  
  /**
   * 匿名化敏感数据
   * @param {Object} request - 请求对象
   * @returns {Object} 匿名化后的请求对象
   * @private
   */
  _anonymizeSensitiveData(request) {
    // 创建请求的深拷贝
    const clonedRequest = JSON.parse(JSON.stringify(request));
    
    // 处理请求中的敏感字段
    if (clonedRequest.query) {
      this._processObjectFields(clonedRequest.query);
    }
    
    if (clonedRequest.document) {
      this._processObjectFields(clonedRequest.document);
    }
    
    if (clonedRequest.documents && Array.isArray(clonedRequest.documents)) {
      clonedRequest.documents.forEach(doc => this._processObjectFields(doc));
    }
    
    // 匿名化 IP 地址
    if (this.config.anonymizeIpAddresses && clonedRequest.clientInfo?.host) {
      clonedRequest.clientInfo.host = this._anonymizeIp(clonedRequest.clientInfo.host);
    }
    
    return clonedRequest;
  }
  
  /**
   * 递归处理对象字段，匹配预设的字段名模式进行匿名化。
   * 支持多种模式：hash、mask、replacement。
   * @param {Object} obj - 要处理的对象
   * @private
   */
  _processObjectFields(obj) {
    if (!obj || typeof obj !== 'object') return;
    
    for (const [key, value] of Object.entries(obj)) {
      // 检查当前键是否匹配任何敏感字段模式
      const matchingPattern = this.config.anonymizeFields.find(p => 
        new RegExp(p.pattern, 'i').test(key)
      );
      
      if (matchingPattern) {
        if (value && typeof value === 'string') {
          // 根据配置的模式进行匿名化
          if (matchingPattern.mode === 'hash') {
            obj[key] = this._hashValue(value);
          } else if (matchingPattern.mode === 'mask' && matchingPattern.keepLastN) {
            obj[key] = this._maskValue(value, matchingPattern.keepLastN);
          } else if (matchingPattern.replacement) {
            obj[key] = matchingPattern.replacement;
          } else {
            obj[key] = '******';
          }
        }
      } else if (value && typeof value === 'object') {
        // 递归处理嵌套对象
        this._processObjectFields(value);
      }
    }
  }
  
  /**
   * 哈希处理敏感值
   * @param {string} value - 原始值
   * @returns {string} 哈希后的值
   * @private
   */
  _hashValue(value) {
    return crypto.createHash('sha256').update(value).digest('hex').substring(0, 16);
  }
  
  /**
   * 掩码处理敏感值，保留最后N位
   * @param {string} value - 原始值
   * @param {number} keepLastN - 保留的位数
   * @returns {string} 掩码处理后的值
   * @private
   */
  _maskValue(value, keepLastN) {
    if (value.length <= keepLastN) return '*'.repeat(value.length);
    
    const maskedPart = '*'.repeat(value.length - keepLastN);
    const visiblePart = value.slice(-keepLastN);
    
    return maskedPart + visiblePart;
  }
  
  /**
   * 匿名化 IP 地址
   * @param {string} ip - 原始 IP 地址
   * @returns {string} 匿名化后的 IP 地址
   * @private
   */
  _anonymizeIp(ip) {
    if (ip.includes(':')) {
      // IPv6
      const parts = ip.split(':');
      return parts.slice(0, 4).join(':') + ':****:****';
    } else {
      // IPv4
      const parts = ip.split('.');
      return parts.slice(0, 2).join('.') + '.*.*';
    }
  }
  
  /**
   * 检查是否应该轮换捕获文件
   * @returns {boolean} 是否应该轮换
   * @private
   */
  _shouldRotateFile() {
    try {
      const stats = fs.statSync(this.currentCaptureFile);
      const fileSizeInMB = stats.size / (1024 * 1024);
      
      return fileSizeInMB >= this.config.maxFileSizeMB;
    } catch (error) {
      return false;
    }
  }
  
  /**
   * 轮换文件逻辑：当当前文件超过最大大小限制时触发
   * @private
   */
  _rotateFile() {
    // 保存当前捕获数据
    const captureData = {
      metadata: { ...this.metadata, endTime: new Date() },
      requests: this.capturedRequests
    };
    
    fs.writeFileSync(
      this.currentCaptureFile,
      JSON.stringify(captureData, null, 2),
      'utf8'
    );
    
    console.log(`[CaptureManager] 轮换捕获文件: ${this.currentCaptureFile}`);
    
    // 创建新的捕获文件
    const timestamp = this._formatDate(new Date());
    this.currentCaptureFile = path.join(
      this.config.captureDir,
      `capture-${timestamp}-continued.json`
    );
    
    // 清空请求数组但保留元数据
    this.capturedRequests = [];
    
    // 如果需要压缩旧文件
    if (this.config.compressFiles) {
      // 这里可以添加压缩旧文件的代码
      // ...
    }
    
    // 删除超过最大保留数量的旧文件
    this._cleanupOldFiles();
  }
  
  /**
   * 删除多余历史文件，保留最新的 N 个文件（由 config.maxFiles 决定）
   * @private
   */
  _cleanupOldFiles() {
    if (!this.config.maxFiles) return;
    
    const files = this.listCaptureFiles();
    
    if (files.length > this.config.maxFiles) {
      const filesToDelete = files.slice(this.config.maxFiles);
      
      for (const file of filesToDelete) {
        try {
          fs.unlinkSync(file.path);
          console.log(`[CaptureManager] 删除旧捕获文件: ${file.name}`);
        } catch (error) {
          console.error(`[CaptureManager] 删除文件 ${file.name} 时出错: ${error.message}`);
        }
      }
    }
  }
  
  /**
   * 格式化日期为文件名友好的格式
   * @param {Date} date - 日期对象
   * @returns {string} 格式化的日期字符串
   * @private
   */
  _formatDate(date) {
    return date.toISOString()
      .replace(/:/g, '-')
      .replace(/\..+/, '')
      .replace('T', '_');
  }
  
  /**
   * 计算捕获请求的统计信息
   * @returns {Object} 统计信息
   * @private
   */
  _calculateStats() {
    return this._calculateStatsFromRequests(this.capturedRequests);
  }
  
  /**
   * 从请求列表计算统计信息
   * @param {Array} requests - 请求列表
   * @returns {Object} 统计信息
   * @private
   */
  _calculateStatsFromRequests(requests) {
    // 按操作类型分组
    const operationCounts = {};
    const collectionCounts = {};
    
    for (const req of requests) {
      // 计算操作类型统计
      const op = req.operation || 'unknown';
      operationCounts[op] = (operationCounts[op] || 0) + 1;
      
      // 计算集合统计
      const collection = req.collection || 'unknown';
      collectionCounts[collection] = (collectionCounts[collection] || 0) + 1;
    }
    
    return {
      operations: operationCounts,
      collections: collectionCounts,
      // 可以添加更多统计信息...
    };
  }
}

module.exports = CaptureManager; 