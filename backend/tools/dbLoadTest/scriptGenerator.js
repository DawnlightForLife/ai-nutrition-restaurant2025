/**
 * ScriptGenerator - 流量捕获脚本生成器类
 * 用于根据数据库操作捕获记录生成负载测试脚本。
 * 支持 MongoDB 原生、Mongoose、Sequelize 多种模板输出。
 */
/**
 * 数据库负载测试脚本生成器
 * 负责从捕获的流量生成测试脚本，用于执行负载测试
 */
const fs = require('fs');
const path = require('path');
const config = require('./config');
const trafficCapture = require('./trafficCapture');

class ScriptGenerator {
  constructor(options = {}) {
    this.options = {
      ...config.scriptGeneration,
      ...options
    };
    
    // 确保脚本目录存在
    if (!fs.existsSync(this.options.scriptDir)) {
      fs.mkdirSync(this.options.scriptDir, { recursive: true });
    }
  }
  
  /**
   * 从捕获文件生成测试脚本
   * @param {string} captureFile 捕获文件路径
   * @param {Object} options 生成选项
   * @returns {string} 生成的脚本文件路径
   */
  generateFromCapture(captureFile, options = {}) {
    try {
      const captureData = trafficCapture.loadCaptureFile(captureFile);
      if (!captureData) {
        throw new Error(`无法加载捕获文件: ${captureFile}`);
      }
      
      const generationOptions = {
        ...this.options,
        ...options
      };
      
      // 准备脚本文件名
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const baseFileName = path.basename(captureFile, '.json');
      const scriptFileName = `${baseFileName}_script_${timestamp}.js`;
      const scriptFilePath = path.join(generationOptions.scriptDir, scriptFileName);
      
      // 生成脚本内容
      const scriptContent = this.buildScriptContent(captureData, generationOptions);
      
      // 写入脚本文件
      fs.writeFileSync(scriptFilePath, scriptContent, 'utf8');
      
      console.log(`测试脚本已生成: ${scriptFilePath}`);
      
      // 如果需要可执行权限
      if (generationOptions.makeExecutable) {
        fs.chmodSync(scriptFilePath, '755');
      }
      
      return scriptFilePath;
    } catch (error) {
      // 调试提示
      console.error('[ScriptGenerator] 生成测试脚本失败:', error);
      return null;
    }
  }
  
  /**
   * 构建脚本内容
   * @param {Object} captureData 捕获的流量数据
   * @param {Object} options 生成选项
   * @returns {string} 脚本内容
   */
  buildScriptContent(captureData, options) {
    const { requests, metadata } = captureData;
    
    // 筛选请求
    let filteredRequests = [...requests];
    
    // 按操作类型筛选
    if (options.includeOperations.length > 0) {
      filteredRequests = filteredRequests.filter(req => 
        options.includeOperations.includes(req.operation.type)
      );
    }
    
    if (options.excludeOperations.length > 0) {
      filteredRequests = filteredRequests.filter(req => 
        !options.excludeOperations.includes(req.operation.type)
      );
    }
    
    // 按集合筛选
    if (options.includeCollections.length > 0) {
      filteredRequests = filteredRequests.filter(req => 
        options.includeCollections.includes(req.operation.collection)
      );
    }
    
    if (options.excludeCollections.length > 0) {
      filteredRequests = filteredRequests.filter(req => 
        !options.excludeCollections.includes(req.operation.collection)
      );
    }
    
    // 限制请求数量
    if (options.maxRequests > 0 && filteredRequests.length > options.maxRequests) {
      filteredRequests = filteredRequests.slice(0, options.maxRequests);
    }
    
    // 计算请求的时间分布
    let timingDistribution = null;
    if (options.preserveTiming && metadata.captureStartTime && metadata.captureEndTime) {
      timingDistribution = this.calculateTimingDistribution(filteredRequests, metadata);
    }
    
    // 根据模板类型生成脚本
    switch (options.scriptType) {
      case 'mongodb':
        return this.generateMongoDBScript(filteredRequests, options, timingDistribution);
      case 'mongoose':
        return this.generateMongooseScript(filteredRequests, options, timingDistribution);
      case 'sequelize':
        return this.generateSequelizeScript(filteredRequests, options, timingDistribution);
      default:
        return this.generateGenericScript(filteredRequests, options, timingDistribution);
    }
  }
  
  /**
   * 计算请求的时间分布
   * @param {Array} requests 请求列表
   * @param {Object} metadata 捕获元数据
   * @returns {Array<number>} 每个请求的相对执行时间（毫秒）
   */
  calculateTimingDistribution(requests, metadata) {
    const startTimeMs = new Date(metadata.captureStartTime).getTime();
    
    return requests.map(req => {
      const reqTimeMs = new Date(req.timestamp).getTime();
      return reqTimeMs - startTimeMs;
    });
  }
  
  /**
   * 生成MongoDB原生脚本
   * @param {Array} requests 请求列表
   * @param {Object} options 生成选项
   * @param {Array} timing 时间分布
   * @returns {string} 脚本内容
   */
  generateMongoDBScript(requests, options, timing) {
    const concurrency = options.concurrency || 1;
    const iterations = options.iterations || 1;
    const multiplier = options.requestMultiplier || 1;
    
    // 脚本头部
    let script = `/**
 * MongoDB负载测试脚本
 * 生成时间: ${new Date().toISOString()}
 * 请求数量: ${requests.length}
 * 并发数: ${concurrency}
 * 迭代次数: ${iterations}
 * 请求倍数: ${multiplier}
 */
const { MongoClient } = require('mongodb');
const fs = require('fs');
const path = require('path');

// 数据库连接信息
const DB_URI = '${options.dbUri || 'mongodb://localhost:27017'}';
const DB_NAME = '${options.dbName || 'test'}';
const DB_OPTIONS = ${JSON.stringify(options.dbOptions || {}, null, 2)};

// 测试配置
const TEST_CONFIG = {
  concurrency: ${concurrency},
  iterations: ${iterations},
  requestMultiplier: ${multiplier},
  delayBetweenRequests: ${options.delayBetweenRequests || 0},
  preserveTiming: ${options.preserveTiming ? 'true' : 'false'},
  reportingInterval: ${options.reportingInterval || 1000},
  logRequests: ${options.logRequests ? 'true' : 'false'},
  logErrors: ${options.logErrors ? 'true' : 'false'},
  stopOnError: ${options.stopOnError ? 'true' : 'false'}
};

// 结果统计
const STATS = {
  startTime: null,
  endTime: null,
  totalRequests: 0,
  completedRequests: 0,
  failedRequests: 0,
  totalDuration: 0,
  operations: {}
};

// 定义请求
const REQUESTS = ${this.formatMongoRequests(requests)};
${timing ? `\n// 请求的时间分布（毫秒）\nconst REQUEST_TIMING = ${JSON.stringify(timing)};` : ''}

// 连接数据库
async function connectToDatabase() {
  try {
    const client = new MongoClient(DB_URI, DB_OPTIONS);
    await client.connect();
    console.log('已连接到数据库');
    
    const db = client.db(DB_NAME);
    return { client, db };
  } catch (error) {
    console.error('连接数据库失败:', error);
    process.exit(1);
  }
}

// 执行单个请求
async function executeRequest(db, request) {
  const startTime = process.hrtime();
  
  try {
    const { operation } = request;
    let result;
    
    // 根据操作类型执行不同的数据库操作
    switch (operation.type) {
      case 'find':
        result = await db.collection(operation.collection)
          .find(operation.query || {}, operation.options || {})
          .project(operation.projection || {})
          .toArray();
        break;
        
      case 'findOne':
        result = await db.collection(operation.collection)
          .findOne(operation.query || {}, {
            projection: operation.projection || {},
            ...operation.options
          });
        break;
        
      case 'count':
      case 'countDocuments':
        result = await db.collection(operation.collection)
          .countDocuments(operation.query || {}, operation.options || {});
        break;
        
      case 'distinct':
        result = await db.collection(operation.collection)
          .distinct(operation.fields, operation.query || {}, operation.options || {});
        break;
        
      case 'aggregate':
        result = await db.collection(operation.collection)
          .aggregate(operation.pipeline || [], operation.options || {})
          .toArray();
        break;
        
      case 'insertOne':
        result = await db.collection(operation.collection)
          .insertOne(operation.document || {}, operation.options || {});
        break;
        
      case 'insertMany':
        result = await db.collection(operation.collection)
          .insertMany(operation.documents || [], operation.options || {});
        break;
        
      case 'updateOne':
        result = await db.collection(operation.collection)
          .updateOne(operation.query || {}, operation.update || {}, operation.options || {});
        break;
        
      case 'updateMany':
        result = await db.collection(operation.collection)
          .updateMany(operation.query || {}, operation.update || {}, operation.options || {});
        break;
        
      case 'deleteOne':
        result = await db.collection(operation.collection)
          .deleteOne(operation.query || {}, operation.options || {});
        break;
        
      case 'deleteMany':
        result = await db.collection(operation.collection)
          .deleteMany(operation.query || {}, operation.options || {});
        break;
        
      default:
        console.warn(\`不支持的操作类型: \${operation.type}\`);
        return null;
    }
    
    const hrDuration = process.hrtime(startTime);
    const durationMs = hrDuration[0] * 1000 + hrDuration[1] / 1000000;
    
    // 更新统计信息
    STATS.completedRequests++;
    STATS.totalDuration += durationMs;
    
    if (!STATS.operations[operation.type]) {
      STATS.operations[operation.type] = {
        count: 0,
        totalDuration: 0,
        minDuration: Infinity,
        maxDuration: 0
      };
    }
    
    const opStats = STATS.operations[operation.type];
    opStats.count++;
    opStats.totalDuration += durationMs;
    opStats.minDuration = Math.min(opStats.minDuration, durationMs);
    opStats.maxDuration = Math.max(opStats.maxDuration, durationMs);
    
    if (TEST_CONFIG.logRequests) {
      console.log(\`请求完成: \${operation.type} \${operation.collection} (\${durationMs.toFixed(2)}ms)\`);
    }
    
    return { result, duration: durationMs };
  } catch (error) {
    STATS.failedRequests++;
    
    if (TEST_CONFIG.logErrors) {
      console.error(\`请求失败: \${request.operation.type} \${request.operation.collection} - \${error.message}\`);
    }
    
    if (TEST_CONFIG.stopOnError) {
      throw error;
    }
    
    return { error: error.message };
  }
}

// 执行测试迭代
async function runIteration(db, iterationIndex) {
  console.log(\`开始执行迭代 #\${iterationIndex + 1}\`);
  
  // 为每个请求创建执行函数
  const executionPromises = [];
  
  for (let i = 0; i < REQUESTS.length * TEST_CONFIG.requestMultiplier; i++) {
    // 获取请求（考虑到倍数因子）
    const requestIndex = i % REQUESTS.length;
    const request = REQUESTS[requestIndex];
    STATS.totalRequests++;
    
    // 创建执行函数
    const executePromise = async () => {
      // 如果需要保持时间分布
      if (TEST_CONFIG.preserveTiming && REQUEST_TIMING) {
        const delay = REQUEST_TIMING[requestIndex] || 0;
        await new Promise(resolve => setTimeout(resolve, delay));
      } else if (TEST_CONFIG.delayBetweenRequests > 0) {
        await new Promise(resolve => setTimeout(resolve, TEST_CONFIG.delayBetweenRequests));
      }
      
      return executeRequest(db, request);
    };
    
    executionPromises.push(executePromise());
  }
  
  // 等待所有请求完成
  await Promise.all(executionPromises);
  console.log(\`迭代 #\${iterationIndex + 1} 完成\`);
}

// 并发执行测试
async function runConcurrentTest(db) {
  const concurrentPromises = [];
  
  for (let i = 0; i < TEST_CONFIG.concurrency; i++) {
    concurrentPromises.push((async () => {
      for (let j = 0; j < TEST_CONFIG.iterations; j++) {
        await runIteration(db, j);
      }
    })());
  }
  
  await Promise.all(concurrentPromises);
}

// 打印统计信息
function printStats() {
  const { startTime, endTime, totalRequests, completedRequests, failedRequests, totalDuration, operations } = STATS;
  const totalTimeMs = endTime - startTime;
  const successRate = (completedRequests / totalRequests) * 100;
  const throughput = completedRequests / (totalTimeMs / 1000);
  const avgResponseTime = totalDuration / completedRequests;
  
  console.log('\\n========== 测试结果 ==========');
  console.log(\`执行时间: \${(totalTimeMs / 1000).toFixed(2)}秒\`);
  console.log(\`总请求数: \${totalRequests}\`);
  console.log(\`成功请求: \${completedRequests}\`);
  console.log(\`失败请求: \${failedRequests}\`);
  console.log(\`成功率: \${successRate.toFixed(2)}%\`);
  console.log(\`吞吐量: \${throughput.toFixed(2)} 请求/秒\`);
  console.log(\`平均响应时间: \${avgResponseTime.toFixed(2)}ms\`);
  
  console.log('\\n操作类型统计:');
  for (const [opType, opStats] of Object.entries(operations)) {
    const avgDuration = opStats.totalDuration / opStats.count;
    console.log(\`  \${opType}:
    数量: \${opStats.count}
    平均响应时间: \${avgDuration.toFixed(2)}ms
    最小响应时间: \${opStats.minDuration.toFixed(2)}ms
    最大响应时间: \${opStats.maxDuration.toFixed(2)}ms\`);
  }
  
  // 将结果保存到文件
  const resultFile = path.join(
    process.cwd(), 
    \`load_test_result_\${new Date().toISOString().replace(/[:.]/g, '-')}.json\`
  );
  
  const resultData = {
    ...STATS,
    successRate,
    throughput,
    avgResponseTime,
    startTimeFormatted: new Date(startTime).toISOString(),
    endTimeFormatted: new Date(endTime).toISOString(),
    testConfig: TEST_CONFIG
  };
  
  fs.writeFileSync(resultFile, JSON.stringify(resultData, null, 2), 'utf8');
  console.log(\`\\n结果已保存到: \${resultFile}\`);
}

// 定期报告进度
function startProgressReporting() {
  return setInterval(() => {
    const currentTime = Date.now();
    const elapsed = (currentTime - STATS.startTime) / 1000;
    const progress = (STATS.completedRequests / STATS.totalRequests) * 100;
    const throughput = STATS.completedRequests / elapsed;
    
    console.log(
      \`进度: \${progress.toFixed(2)}% | \` +
      \`完成: \${STATS.completedRequests}/\${STATS.totalRequests} | \` +
      \`失败: \${STATS.failedRequests} | \` +
      \`吞吐量: \${throughput.toFixed(2)} 请求/秒\`
    );
  }, TEST_CONFIG.reportingInterval);
}

// 主函数
async function main() {
  try {
    const { client, db } = await connectToDatabase();
    
    STATS.startTime = Date.now();
    console.log(\`开始负载测试, 时间: \${new Date(STATS.startTime).toISOString()}\`);
    
    // 开始进度报告
    const progressInterval = startProgressReporting();
    
    // 运行测试
    await runConcurrentTest(db);
    
    // 结束测试
    clearInterval(progressInterval);
    STATS.endTime = Date.now();
    
    // 打印结果
    printStats();
    
    // 关闭数据库连接
    await client.close();
    console.log('测试完成，数据库连接已关闭');
  } catch (error) {
    console.error('测试执行失败:', error);
    process.exit(1);
  }
}

// 执行主函数
main().catch(console.error);
`;
    
    return script;
  }
  
  /**
   * 生成Mongoose脚本
   * @param {Array} requests 请求列表
   * @param {Object} options 生成选项
   * @param {Array} timing 时间分布
   * @returns {string} 脚本内容
   */
  generateMongooseScript(requests, options, timing) {
    // 基于MongoDB脚本，但使用Mongoose API
    const script = this.generateMongoDBScript(requests, options, timing);
    
    // 替换MongoDB客户端相关代码为Mongoose
    return script
      .replace(
        "const { MongoClient } = require('mongodb');",
        "const mongoose = require('mongoose');"
      )
      .replace(
        /async function connectToDatabase\(\) \{[\s\S]*?return \{ client, db \};[\s\S]*?\}/,
        `async function connectToDatabase() {
  try {
    await mongoose.connect(DB_URI, DB_OPTIONS);
    console.log('已连接到数据库');
    return { mongoose };
  } catch (error) {
    console.error('连接数据库失败:', error);
    process.exit(1);
  }
}`
      )
      // 更新关闭连接的代码
      .replace(
        "await client.close();",
        "await mongoose.disconnect();"
      );
  }
  
  /**
   * 生成Sequelize脚本
   * @param {Array} requests 请求列表
   * @param {Object} options 生成选项
   * @param {Array} timing 时间分布
   * @returns {string} 脚本内容
   */
  generateSequelizeScript(requests, options, timing) {
    // 为SQL数据库生成的脚本，基于Sequelize ORM
    const concurrency = options.concurrency || 1;
    const iterations = options.iterations || 1;
    
    return `/**
 * Sequelize负载测试脚本
 * 生成时间: ${new Date().toISOString()}
 * 请求数量: ${requests.length}
 * 并发数: ${concurrency}
 * 迭代次数: ${iterations}
 */
const { Sequelize, Op } = require('sequelize');
const fs = require('fs');
const path = require('path');

// 创建模型定义
// ...
`;
  }
  
  /**
   * 生成通用脚本
   * @param {Array} requests 请求列表
   * @param {Object} options 生成选项
   * @param {Array} timing 时间分布
   * @returns {string} 脚本内容
   */
  generateGenericScript(requests, options, timing) {
    // 默认生成MongoDB脚本
    return this.generateMongoDBScript(requests, options, timing);
  }
  
  /**
   * 格式化MongoDB请求为JavaScript代码
   * @param {Array} requests 请求列表
   * @returns {string} 格式化的JavaScript数组
   */
  formatMongoRequests(requests) {
    // 使用JSON.stringify会导致函数和特殊对象丢失，所以我们手动构建
    const formattedRequests = requests.map(req => {
      return `{
    id: '${req.id}',
    timestamp: '${req.timestamp}',
    operation: {
      type: '${req.operation.type}',
      collection: '${req.operation.collection}',
      ${req.operation.query ? `query: ${this.formatObject(req.operation.query)},` : ''}
      ${req.operation.options ? `options: ${this.formatObject(req.operation.options)},` : ''}
      ${req.operation.projection ? `projection: ${this.formatObject(req.operation.projection)},` : ''}
      ${req.operation.pipeline ? `pipeline: ${this.formatArray(req.operation.pipeline)},` : ''}
      ${req.operation.update ? `update: ${this.formatObject(req.operation.update)},` : ''}
      ${req.operation.document ? `document: ${this.formatObject(req.operation.document)},` : ''}
      ${req.operation.documents ? `documents: ${this.formatArray(req.operation.documents)},` : ''}
      ${req.operation.fields ? `fields: '${req.operation.fields}',` : ''}
      ${req.operation.model ? `model: '${req.operation.model}'` : ''}
    }
  }`;
    });
    
    return `[\n  ${formattedRequests.join(',\n  ')}\n]`;
  }
  
  /**
   * 将对象格式化为JavaScript代码字符串
   * @param {Object} obj 要格式化的对象
   * @returns {string} 格式化后的代码字符串
   */
  formatObject(obj) {
    if (!obj) return '{}';
    
    try {
      const json = JSON.stringify(obj, (key, value) => {
        // 处理正则表达式
        if (value instanceof RegExp) {
          return value.toString();
        }
        return value;
      }, 2);
      
      // 将JSON中的正则表达式字符串转换为实际的正则表达式
      return json.replace(/"(\/.*?\/[gimuy]*)"/g, (match, regexStr) => {
        // 去除额外的反斜杠
        return regexStr.replace(/\\\\/g, '\\');
      });
    } catch (error) {
      console.warn(`格式化对象时出错: ${error.message}`);
      return '{}';
    }
  }
  
  /**
   * 将数组格式化为JavaScript代码字符串
   * @param {Array} arr 要格式化的数组
   * @returns {string} 格式化后的代码字符串
   */
  formatArray(arr) {
    if (!arr || !Array.isArray(arr)) return '[]';
    
    try {
      const json = JSON.stringify(arr, null, 2);
      return json;
    } catch (error) {
      console.warn(`格式化数组时出错: ${error.message}`);
      return '[]';
    }
  }
  
  /**
   * 获取所有可用的脚本文件
   * @returns {Array} 脚本文件列表
   */
  getScriptFiles() {
    try {
      const files = fs.readdirSync(this.options.scriptDir)
        .filter(file => file.endsWith('.js'))
        .map(file => {
          const fullPath = path.join(this.options.scriptDir, file);
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
      console.error('[ScriptGenerator] 获取脚本文件列表失败:', error);
      return [];
    }
  }
}

// 导出单例实例
module.exports = new ScriptGenerator(); 