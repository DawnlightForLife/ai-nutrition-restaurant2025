/**
 * ✅ 模块名：dbLoadTest/config.js
 * ✅ 功能说明：数据库负载测试的统一配置文件
 * ✅ 包含三大配置区块：
 *   1. capture：流量捕获配置（用于生成测试脚本或进行回放）
 *   2. scriptGeneration：负载测试脚本生成与执行配置
 *   3. database：数据库连接配置
 * ✅ 使用建议：
 *   - 所有路径均以 BASE_DIR 为根目录统一管理
 *   - 所有可运行脚本通过环境变量控制连接参数（DB_URI / DB_NAME）
 *   - 流量采样、匿名化、轮换、压缩等配置建议按需启用
 */
const path = require('path');
const os = require('os');

// 📁 根目录定义（基于当前文件路径）
const BASE_DIR = path.join(__dirname, '../../../data/dbLoadTest');
const CAPTURE_DIR = path.join(BASE_DIR, 'captures');
const SCRIPT_DIR = path.join(BASE_DIR, 'scripts');
const RESULT_DIR = path.join(BASE_DIR, 'results');

// 默认配置
const config = {
  // ===================== 👁 流量捕获配置 =====================
  capture: {
    // 基本配置
    enabled: false, // 默认关闭捕获
    captureDir: CAPTURE_DIR, // 捕获文件存储目录
    maxCaptureSize: 1000, // 最大捕获请求数
    samplingRate: 1.0, // 采样率(0.0-1.0)，1表示捕获所有请求
    defaultCaptureFile: 'default-capture.json', // 默认捕获文件名
    sampleRate: 1.0, // 与samplingRate同义，兼容旧代码
    anonymizeSensitiveData: true, // 是否匿名化敏感数据
    sensitiveCollections: ['users', 'accounts', 'credentials'], // 敏感集合列表
    sensitiveFields: ['password', 'token', 'secret', 'creditcard', 'ssn'], // 敏感字段列表
    
    // 过滤设置
    includeOperations: [], // 要包含的操作类型，如find、aggregate等，空数组表示包含所有
    excludeOperations: ['ping', 'isMaster'], // 要排除的操作类型
    includeCollections: [], // 要包含的集合，空数组表示包含所有
    excludeCollections: ['system.'], // 要排除的集合前缀或名称
    
    // 敏感信息处理
    anonymizeFields: [
      // 字段名匹配(正则)和替换方式
      { pattern: 'password', replacement: '********' },
      { pattern: 'creditcard', replacement: '************' },
      { pattern: 'ssn', replacement: '***-**-****' },
      { pattern: 'email', mode: 'hash' }, // hash模式会对值进行一致性哈希
      { pattern: 'phone', mode: 'mask', keepLastN: 4 } // 保留最后N位字符
    ],
    
    anonymizeIpAddresses: true, // 是否匿名化IP地址
    
    // 文件处理配置
    maxFileSizeMB: 10, // 单个捕获文件最大大小(MB)
    rotateFiles: true, // 是否轮换文件
    compressFiles: true, // 是否压缩旧文件
    maxFiles: 10, // 保留的最大文件数
    
    // 元数据
    includeMetadata: true, // 是否包含元数据
    metadataKeys: [
      'hostname', 
      'startTime', 
      'endTime', 
      'dbVersion', 
      'connectionInfo',
    ],
  },
  
  // ===================== 🧪 脚本生成与压测配置 =====================
  scriptGeneration: {
    scriptDir: SCRIPT_DIR, // 脚本存储目录
    resultDir: RESULT_DIR, // 测试结果存储目录
    
    // 脚本类型
    scriptType: 'mongodb', // mongodb, mongoose, sequelize
    
    // 筛选配置
    includeOperations: [], // 要包含的操作类型，空数组表示包含所有
    excludeOperations: [], // 要排除的操作类型
    includeCollections: [], // 要包含的集合，空数组表示包含所有
    excludeCollections: [], // 要排除的集合
    
    // 性能测试配置
    concurrency: 10, // 并发执行的客户端数
    iterations: 3, // 每个客户端的迭代次数
    requestMultiplier: 1, // 请求倍数(1=原始流量，2=两倍流量)
    maxRequests: 0, // 最大请求数，0表示不限制
    delayBetweenRequests: 0, // 请求间延迟(毫秒)
    preserveTiming: true, // 是否保持原始请求的时间分布
    
    // 连接配置
    dbUri: process.env.DB_URI || 'mongodb://localhost:27017', // 数据库连接URI
    dbName: process.env.DB_NAME || 'test', // 数据库名称
    dbOptions: { // 数据库连接选项
      useNewUrlParser: true,
      useUnifiedTopology: true,
      connectTimeoutMS: 10000,
    },
    
    // 运行配置
    reportingInterval: 1000, // 报告进度间隔(毫秒)
    logRequests: false, // 是否记录每个请求
    logErrors: true, // 是否记录错误
    stopOnError: false, // 出错时是否停止测试
    makeExecutable: true, // 是否使生成的脚本可执行
    
    // 环境设置
    additionalEnvVars: {}, // 脚本运行时需要的额外环境变量
  },
  
  // ===================== 🧩 数据库连接配置 =====================
  database: {
    uri: process.env.DB_URI || 'mongodb://localhost:27017/test',
    options: {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      connectTimeoutMS: 10000,
      serverSelectionTimeoutMS: 10000,
    },
  },
};

// 导出配置
module.exports = config; 