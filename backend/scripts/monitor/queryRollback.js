/**
 * 查询策略回滚脚本
 * 支持回滚到历史查询策略
 */
const mongoose = require('mongoose');
const { program } = require('commander');
const queryEvolutionScorer = require('../utils/queryEvolutionScorer');
const logger = require('../../utils/logger/winstonLogger');
const config = require('../config/modules/db.config');

// 命令行参数配置
program
  .requiredOption('-d, --deploymentId <id>', '要回滚到的部署ID')
  .option('-f, --force', '强制回滚，即使性能评分为正')
  .option('-l, --list', '列出可用的部署历史')
  .option('-v, --verbose', '显示详细信息')
  .parse(process.argv);

const options = program.opts();

/**
 * 主函数
 */
async function main() {
  try {
    // 如果只是列出历史，则不需要连接数据库
    if (options.list) {
      await listDeploymentHistory();
      return;
    }
    
    // 连接数据库
    await connectToDatabase();
    
    // 执行回滚
    if (options.deploymentId) {
      await rollbackToDeployment(options.deploymentId);
    } else {
      console.error('错误: 必须指定部署ID (--deploymentId) 或使用 --list 查看历史');
      process.exit(1);
    }
    
    await mongoose.disconnect();
  } catch (error) {
    logger.error('执行查询回滚时出错:', error);
    console.error(`回滚失败: ${error.message}`);
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
 * 列出部署历史
 */
async function listDeploymentHistory() {
  try {
    console.log('正在获取部署历史...');
    
    const deployments = await queryEvolutionScorer.getDeploymentHistory(20);
    
    if (deployments.length === 0) {
      console.log('没有找到部署历史记录');
      return;
    }
    
    console.log('\n===== 部署历史 =====');
    console.log('ID\t\t版本\t\t描述\t\t性能评分');
    console.log('--------------------------------------------------------------');
    
    deployments.forEach(deployment => {
      // 格式化显示
      const id = deployment.id.padEnd(20);
      const version = (deployment.version || '').padEnd(10);
      const description = (deployment.description || '').padEnd(20);
      const score = deployment.overallScore !== null ? 
        deployment.overallScore.toFixed(2) : 'N/A';
      
      console.log(`${id}\t${version}\t${description}\t${score}`);
    });
    
    console.log('\n要回滚到特定部署，请运行:');
    console.log('node scripts/query-rollback.js --deploymentId <部署ID>');
  } catch (error) {
    console.error('获取部署历史失败:', error.message);
    throw error;
  }
}

/**
 * 回滚到指定部署
 * @param {string} deploymentId - 部署ID
 */
async function rollbackToDeployment(deploymentId) {
  try {
    // 获取目标部署信息
    const deployment = await queryEvolutionScorer.getDeploymentInfo(deploymentId);
    
    if (!deployment) {
      throw new Error(`找不到部署: ${deploymentId}`);
    }
    
    // 获取最新部署信息
    let latestDeployment;
    try {
      latestDeployment = await queryEvolutionScorer.getDeploymentInfo();
    } catch (error) {
      console.log('找不到最新部署信息，将直接回滚到指定部署');
    }
    
    // 如果最新部署的性能评分为正且不是强制回滚，给出警告
    if (
      latestDeployment && 
      latestDeployment.performance && 
      latestDeployment.performance.overallScore > 0 && 
      !options.force
    ) {
      console.log(`\n警告: 当前部署 (${latestDeployment.id}) 的性能评分为 ${latestDeployment.performance.overallScore.toFixed(2)}，表明性能良好`);
      console.log('回滚可能会导致性能下降。如果确定要回滚，请使用 --force 选项');
      return;
    }
    
    console.log(`正在回滚到部署 ${deploymentId} (${deployment.version || 'unknown'})...`);
    
    // 执行回滚
    const result = await queryEvolutionScorer.rollbackToDeployment(deploymentId);
    
    if (result.success) {
      console.log(`\n回滚成功: ${result.message}`);
      console.log(`回滚ID: ${result.rollbackId}`);
      
      // 如果有查询策略，显示详细信息
      if (options.verbose && deployment.queryStrategies) {
        const strategyCount = Object.keys(deployment.queryStrategies).length;
        console.log(`\n已回滚 ${strategyCount} 个查询策略`);
        
        if (strategyCount > 0 && options.verbose) {
          console.log('\n查询策略概览:');
          let i = 0;
          for (const [queryId, strategy] of Object.entries(deployment.queryStrategies)) {
            if (i++ < 5) { // 只显示前5个
              console.log(`- 查询ID: ${queryId}`);
              console.log(`  集合: ${strategy.collection}`);
              console.log(`  操作: ${strategy.operation}`);
              console.log('');
            } else {
              console.log(`... 还有 ${strategyCount - 5} 个查询策略 (使用 --verbose 查看更多)`);
              break;
            }
          }
        }
      }
      
      console.log('\n回滚操作完成。在下一次部署前，系统将使用回滚的查询策略');
    } else {
      throw new Error('回滚失败');
    }
  } catch (error) {
    logger.error(`回滚到部署 ${deploymentId} 失败:`, error);
    throw error;
  }
}

// 执行主函数
main(); 