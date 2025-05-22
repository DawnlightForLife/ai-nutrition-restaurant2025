/**
 * 查询回归评估脚本
 * 用于部署前后自动执行慢查询回归评估
 */
const mongoose = require('mongoose');
const path = require('path');
const fs = require('fs');
const { program } = require('commander');
const queryEvolutionScorer = require('../utils/queryEvolutionScorer');
const logger = require('../../utils/logger/winstonLogger');
const config = require('../config/modules/db.config');
const dbManager = require('../services/database/database');

// 命令行参数配置
program
  .option('-p, --phase <phase>', '评估阶段 (pre/post)', 'pre')
  .option('-d, --deploymentId <id>', '部署ID (仅post阶段需要)')
  .option('-v, --version <version>', '版本标识符 (仅pre阶段需要)')
  .option('-m, --message <message>', '部署描述 (仅pre阶段需要)')
  .option('-q, --queryFile <file>', '自定义查询文件路径')
  .option('-c, --collections <collections>', '要评估的集合列表，逗号分隔')
  .option('-t, --threshold <ms>', '慢查询阈值(毫秒)', '500')
  .option('-l, --limit <count>', '每个集合的查询数量限制', '10')
  .option('-o, --output <dir>', '输出目录', './query-evaluation-reports')
  .parse(process.argv);

const options = program.opts();

/**
 * 主函数
 */
async function main() {
  try {
    // 连接数据库
    await connectToDatabase();
    
    // 获取测试查询列表
    const queries = await getTestQueries(options);
    
    if (queries.length === 0) {
      logger.error('没有找到要测试的查询');
      process.exit(1);
    }
    
    logger.info(`开始执行 ${options.phase} 阶段的查询回归评估，共 ${queries.length} 个查询`);
    
    let result;
    if (options.phase === 'pre') {
      // 准备部署前评估
      await preparePreDeploymentEvaluation(queries);
    } else if (options.phase === 'post') {
      // 执行部署后评估
      await executePostDeploymentEvaluation(queries);
    } else {
      logger.error(`不支持的评估阶段: ${options.phase}`);
      process.exit(1);
    }
    
    logger.info('查询回归评估完成');
    await mongoose.disconnect();
  } catch (error) {
    logger.error('执行查询回归评估时出错:', error);
    process.exit(1);
  }
}

/**
 * 连接到数据库
 */
async function connectToDatabase() {
  try {
    logger.info('正在连接到数据库...');
    
    await mongoose.connect(config.mongoURI, config.options);
    
    logger.info('成功连接到数据库');
  } catch (error) {
    logger.error('连接数据库失败:', error);
    throw error;
  }
}

/**
 * 准备部署前评估
 * @param {Array<Object>} queries - 要测试的查询列表
 */
async function preparePreDeploymentEvaluation(queries) {
  // 验证必需的参数
  if (!options.version) {
    throw new Error('需要指定版本标识符 (--version)');
  }
  
  // 开始新的部署评估
  const deployment = await queryEvolutionScorer.startDeployment(
    options.version,
    options.message || `部署 ${options.version} 的查询评估`
  );
  
  logger.info(`创建新的部署评估: ${deployment.id}`);
  
  // 运行部署前基准测试
  const benchmarkResult = await queryEvolutionScorer.runPreDeploymentBenchmark(queries);
  
  logger.info('部署前基准测试完成');
  
  // 输出部署ID，用于后续的post评估
  console.log(`部署ID: ${deployment.id}`);
  console.log(`查询总数: ${benchmarkResult.totalQueries}`);
  console.log(`总执行时间: ${benchmarkResult.totalDuration}ms`);
  console.log(`平均查询时间: ${benchmarkResult.averageDuration.toFixed(2)}ms`);
}

/**
 * 执行部署后评估
 * @param {Array<Object>} queries - 要测试的查询列表
 */
async function executePostDeploymentEvaluation(queries) {
  // 验证必需的参数
  if (!options.deploymentId) {
    throw new Error('需要指定部署ID (--deploymentId)');
  }
  
  // 获取部署信息
  const deployment = await queryEvolutionScorer.getDeploymentInfo(options.deploymentId);
  
  if (!deployment || !deployment.preBenchmark) {
    throw new Error(`找不到有效的部署: ${options.deploymentId}`);
  }
  
  logger.info(`正在进行部署后评估: ${deployment.id}`);
  
  // 设置当前部署
  queryEvolutionScorer.currentDeployment = deployment;
  
  // 运行部署后基准测试
  const result = await queryEvolutionScorer.runPostDeploymentBenchmark(queries);
  
  logger.info('部署后基准测试完成');
  
  // 生成性能报告
  const report = await queryEvolutionScorer.generatePerformanceReport(deployment.id);
  
  // 输出报告路径
  const reportPath = path.join(options.output, `${report.reportId}.json`);
  fs.mkdirSync(path.dirname(reportPath), { recursive: true });
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
  
  // 输出结果摘要
  console.log(`\n========== 性能变化摘要 ==========`);
  console.log(`部署版本: ${deployment.version}`);
  console.log(`总体评分: ${report.performanceSummary.overallScore.toFixed(2)} (-100 到 100，正值表示改进)`);
  console.log(`改进查询数: ${report.performanceSummary.improvements.count}`);
  console.log(`平均改进幅度: ${report.performanceSummary.improvements.averageImprovement.toFixed(2)}%`);
  console.log(`回归查询数: ${report.performanceSummary.regressions.count}`);
  console.log(`平均回归幅度: ${report.performanceSummary.regressions.averageRegression.toFixed(2)}%`);
  console.log(`未变化查询数: ${report.performanceSummary.unchanged.count}`);
  console.log(`性能报告已保存至: ${reportPath}`);
  
  // 如果有严重回归，给出提示
  if (report.performanceSummary.regressions.count > 0) {
    console.log(`\n警告: 检测到 ${report.performanceSummary.regressions.count} 个查询性能回归`);
    
    // 输出最严重的回归
    const topRegressions = report.performanceSummary.regressions.topRegressions.slice(0, 3);
    if (topRegressions.length > 0) {
      console.log('\n最严重的性能回归:');
      topRegressions.forEach((regression, index) => {
        console.log(`${index + 1}. 查询ID: ${regression.queryId} (${regression.collection}.${regression.operation})`);
        console.log(`   性能下降: ${regression.regressionPercentage.toFixed(2)}%, 从 ${regression.preTime}ms 增加到 ${regression.postTime}ms`);
      });
    }
    
    // 如果整体评分为负，建议回滚
    if (report.performanceSummary.overallScore < 0) {
      console.log(`\n建议: 由于整体性能下降，建议考虑回滚到之前的查询策略。`);
      console.log(`执行命令回滚: node scripts/query-rollback.js --deploymentId ${deployment.id}`);
    }
  }
}

/**
 * 获取测试查询列表
 * @param {Object} options - 命令行选项
 * @returns {Promise<Array<Object>>} 查询列表
 */
async function getTestQueries(options) {
  // 如果指定了查询文件，从文件加载
  if (options.queryFile) {
    return loadQueriesFromFile(options.queryFile);
  }
  
  // 否则从数据库提取慢查询
  return await extractSlowQueriesFromDatabase(options);
}

/**
 * 从文件加载查询
 * @param {string} filePath - 文件路径
 * @returns {Array<Object>} 查询列表
 */
function loadQueriesFromFile(filePath) {
  try {
    const fullPath = path.resolve(process.cwd(), filePath);
    logger.info(`从文件加载查询: ${fullPath}`);
    
    const queries = require(fullPath);
    
    if (!Array.isArray(queries)) {
      throw new Error('查询文件必须导出查询对象数组');
    }
    
    return queries;
  } catch (error) {
    logger.error('从文件加载查询失败:', error);
    throw error;
  }
}

/**
 * 从数据库提取慢查询
 * @param {Object} options - 命令行选项
 * @returns {Promise<Array<Object>>} 查询列表
 */
async function extractSlowQueriesFromDatabase(options) {
  try {
    logger.info('从数据库提取慢查询...');
    
    // 获取要评估的集合列表
    let collections = [];
    if (options.collections) {
      collections = options.collections.split(',');
    } else {
      // 获取所有集合
      collections = await mongoose.connection.db.listCollections().toArray();
      collections = collections.map(c => c.name);
    }
    
    // 排除系统集合
    collections = collections.filter(c => !c.startsWith('system.'));
    
    logger.info(`发现 ${collections.length} 个集合`);
    
    // 从集合中提取查询
    const threshold = parseInt(options.threshold);
    const limit = parseInt(options.limit);
    const queries = [];
    
    try {
      // 尝试从DbMetrics模型中获取慢查询
      const DbMetrics = mongoose.model('DbMetrics');
      
      // 获取最近的慢查询
      const slowQueries = await DbMetrics.find({ 
        slow_query: true,
        duration: { $gte: threshold }
      })
      .sort({ timestamp: -1 })
      .limit(100)
      .lean();
      
      if (slowQueries.length > 0) {
        logger.info(`从DbMetrics找到 ${slowQueries.length} 个慢查询`);
        
        for (const query of slowQueries) {
          if (collections.includes(query.collection)) {
            queries.push({
              id: query._id.toString(),
              operation: query.operation,
              collection: query.collection,
              filter: query.query || {},
              options: query.options || {},
              pipeline: query.pipeline || []
            });
            
            if (queries.length >= collections.length * limit) {
              break;
            }
          }
        }
      }
    } catch (error) {
      logger.warn('从DbMetrics获取慢查询失败，将使用默认测试查询:', error.message);
    }
    
    // 如果没有足够的查询，为每个集合生成一些默认查询
    if (queries.length < collections.length) {
      logger.info('生成默认测试查询...');
      
      for (const collection of collections) {
        // 统计集合中的文档数
        const count = await mongoose.connection.db.collection(collection).countDocuments();
        
        if (count > 0) {
          // 只为有数据的集合生成查询
          const collectionQueries = queries.filter(q => q.collection === collection);
          
          if (collectionQueries.length < limit) {
            // 生成一些基本查询
            const sampleDocument = await mongoose.connection.db.collection(collection).findOne();
            
            if (sampleDocument) {
              // 基于样本文档生成查询
              const fields = Object.keys(sampleDocument).filter(f => f !== '_id');
              
              if (fields.length > 0) {
                // 添加find查询
                queries.push({
                  id: `generated_find_${collection}_${Date.now()}`,
                  operation: 'find',
                  collection,
                  filter: {},
                  options: { limit: 100 }
                });
                
                // 添加一个基于随机字段的查询
                const randomField = fields[Math.floor(Math.random() * fields.length)];
                if (randomField && sampleDocument[randomField] !== undefined) {
                  queries.push({
                    id: `generated_field_${collection}_${Date.now()}`,
                    operation: 'find',
                    collection,
                    filter: { [randomField]: sampleDocument[randomField] },
                    options: { limit: 100 }
                  });
                }
                
                // 添加聚合查询
                if (fields.length >= 2) {
                  const groupField = fields[0];
                  const valueField = fields[1];
                  
                  queries.push({
                    id: `generated_aggregate_${collection}_${Date.now()}`,
                    operation: 'aggregate',
                    collection,
                    pipeline: [
                      { $group: { _id: `$${groupField}`, count: { $sum: 1 } } },
                      { $sort: { count: -1 } },
                      { $limit: 10 }
                    ],
                    options: {}
                  });
                }
              }
            }
          }
        }
      }
    }
    
    logger.info(`共生成 ${queries.length} 个测试查询`);
    return queries;
  } catch (error) {
    logger.error('提取慢查询失败:', error);
    throw error;
  }
}

// 执行主函数
main(); 