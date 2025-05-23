/**
 * 查询演化评分系统 QueryEvolutionScorer
 * 
 * 本类用于自动化评估 MongoDB 查询策略优化对性能的影响，支持如下功能：
 * - 启动部署评估，执行部署前/后的性能基准测试；
 * - 比较查询执行耗时与 Explain 分析，评估改进/回归；
 * - 支持查询策略版本控制、回滚与报告生成；
 * - 查询历史演化可视化支持。
 * 
 * 适用于开发阶段或 CI/CD 部署流程中，对数据库查询优化效果进行定量衡量与记录。
 */
const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const logger = require('../logger/winstonLogger');
const dbPerformanceAnalyzer = require('./dbPerformanceAnalyzer');

class QueryEvolutionScorer {
  constructor() {
    this.historyPath = path.join(__dirname, '../data/query-evolution');
    this.ensureDirectoryExists(this.historyPath);
    this.currentDeployment = null;
  }

  /**
   * 确保目录存在
   * @param {string} directory - 目录路径
   * 检查指定目录是否存在，不存在则递归创建
   */
  ensureDirectoryExists(directory) {
    if (!fs.existsSync(directory)) {
      fs.mkdirSync(directory, { recursive: true });
    }
  }

  /**
   * 开始新的部署评估
   * @param {string} version - 版本标识符
   * @param {string} description - 部署描述
   * @returns {Promise<Object>} 部署信息
   * 初始化一次部署评估，记录初始信息并落地
   */
  async startDeployment(version, description) {
    this.currentDeployment = {
      id: `deploy_${Date.now()}`,
      version,
      description,
      startTime: new Date(),
      preBenchmark: null,
      postBenchmark: null,
      performance: {
        improvement: null,
        regressions: [],
        overallScore: null
      },
      queryStrategies: {}
    };

    // 保存部署信息
    await this.saveDeploymentInfo();

    return this.currentDeployment;
  }

  /**
   * 执行部署前的性能基准测试
   * @param {Array<Object>} queries - 要测试的查询列表
   * @returns {Promise<Object>} 基准测试结果
   * 运行部署前的所有查询，记录性能指标和策略
   */
  async runPreDeploymentBenchmark(queries) {
    if (!this.currentDeployment) {
      throw new Error('必须先调用 startDeployment');
    }

    logger.info(`开始部署前基准测试: ${this.currentDeployment.id}`);
    
    // 运行基准测试
    const benchmarkResult = await this.runBenchmark(queries);
    
    // 保存部署前基准测试结果
    this.currentDeployment.preBenchmark = benchmarkResult;
    this.currentDeployment.queryStrategies = this.extractQueryStrategies(queries);
    await this.saveDeploymentInfo();
    
    return benchmarkResult;
  }

  /**
   * 执行部署后的性能基准测试
   * @param {Array<Object>} queries - 要测试的查询列表
   * @returns {Promise<Object>} 基准测试结果
   * 运行部署后的所有查询，记录性能指标并自动进行性能变化分析
   */
  async runPostDeploymentBenchmark(queries) {
    if (!this.currentDeployment || !this.currentDeployment.preBenchmark) {
      throw new Error('必须先完成部署前基准测试');
    }

    logger.info(`开始部署后基准测试: ${this.currentDeployment.id}`);
    
    // 运行基准测试
    const benchmarkResult = await this.runBenchmark(queries);
    
    // 保存部署后基准测试结果
    this.currentDeployment.postBenchmark = benchmarkResult;
    
    // 分析性能变化
    this.analyzePerformanceChanges();
    
    // 保存部署信息
    await this.saveDeploymentInfo();
    
    return {
      benchmarkResult,
      performanceAnalysis: this.currentDeployment.performance
    };
  }

  /**
   * 运行查询基准测试
   * @param {Array<Object>} queries - 要测试的查询列表
   * @returns {Promise<Object>} 基准测试结果
   * 依次执行所有查询，统计耗时、返回条数、异常信息，并获取 explain
   */
  async runBenchmark(queries) {
    const results = {
      timestamp: new Date(),
      totalQueries: queries.length,
      totalDuration: 0,
      averageDuration: 0,
      queryResults: []
    };

    // 运行每个查询并收集性能指标
    for (const query of queries) {
      try {
        const startTime = Date.now();
        
        let queryResult;
        const collection = mongoose.connection.db.collection(query.collection);
        
        // 根据查询类型执行操作
        switch (query.operation) {
          case 'find':
            queryResult = await collection.find(query.filter, query.options).toArray();
            break;
          case 'findOne':
            queryResult = await collection.findOne(query.filter, query.options);
            break;
          case 'aggregate':
            queryResult = await collection.aggregate(query.pipeline, query.options).toArray();
            break;
          case 'count':
            queryResult = await collection.countDocuments(query.filter, query.options);
            break;
          case 'distinct':
            queryResult = await collection.distinct(query.field, query.filter, query.options);
            break;
          default:
            throw new Error(`不支持的操作类型: ${query.operation}`);
        }
        
        const endTime = Date.now();
        const duration = endTime - startTime;
        
        // 获取查询计划（explain），如不支持则返回null
        const explainResult = await this.getQueryExplain(query);
        
        results.queryResults.push({
          queryId: query.id,
          duration,
          resultCount: Array.isArray(queryResult) ? queryResult.length : 1,
          operation: query.operation,
          collection: query.collection,
          explain: explainResult
        });
        
        results.totalDuration += duration;
      } catch (error) {
        logger.error(`[QueryError] 执行查询 ${query.id} 时出错: ${error.message}\n${error.stack}`);
        
        results.queryResults.push({
          queryId: query.id,
          error: error.message,
          operation: query.operation,
          collection: query.collection
        });
      }
    }
    
    // 计算平均持续时间
    if (results.queryResults.length > 0) {
      results.averageDuration = results.totalDuration / results.queryResults.length;
    }
    
    return results;
  }

  /**
   * 获取查询的执行计划
   * 根据操作类型（find/aggregate/count）返回简化后的 explain 结果
   * @param {Object} query - 查询对象
   * @returns {Promise<Object>} 查询执行计划
   */
  async getQueryExplain(query) {
    try {
      const collection = mongoose.connection.db.collection(query.collection);
      let explainResult;
      
      // 根据查询类型获取执行计划
      // 注：countDocuments 通常不支持 explain，但我们兼容性包裹处理
      switch (query.operation) {
        case 'find':
          explainResult = await collection.find(query.filter, query.options).explain();
          break;
        case 'aggregate':
          explainResult = await collection.aggregate(query.pipeline, { 
            ...query.options,
            explain: true 
          }).toArray();
          break;
        case 'count':
          explainResult = await collection.countDocuments(query.filter, { 
            ...query.options,
            explain: true 
          });
          break;
        default:
          return null; // 某些操作可能不支持explain
      }
      return this.simplifyExplainResult(explainResult);
    } catch (error) {
      logger.warn(`[ExplainError] 获取查询 ${query.id} 的执行计划时出错: ${error.message}\n${error.stack}`);
      return null;
    }
  }

  /**
   * 简化Explain结果，只保留关键信息
   * 主要提取执行时间、扫描文档数、使用索引等
   * @param {Object} explainResult - 原始执行计划
   * @returns {Object} 简化后的执行计划
   */
  simplifyExplainResult(explainResult) {
    if (!explainResult) return null;
    
    try {
      // 提取关键信息
      const simplified = {
        executionTimeMillis: explainResult.executionStats?.executionTimeMillis,
        totalKeysExamined: explainResult.executionStats?.totalKeysExamined,
        totalDocsExamined: explainResult.executionStats?.totalDocsExamined,
        nReturned: explainResult.executionStats?.nReturned,
        indexesUsed: []
      };
      
      // 提取使用的索引（递归查找 winningPlan 中的 indexName）
      if (explainResult.queryPlanner?.winningPlan) {
        /**
         * 递归提取 winningPlan 中所有用到的 indexName
         * 递归逻辑：优先判断当前 plan 是否有 indexName，有则加入；
         * 若有 inputStage，递归进入；inputStages（数组）也递归遍历
         */
        const extractIndexes = (plan) => {
          if (!plan) return;
          if (plan.indexName && !simplified.indexesUsed.includes(plan.indexName)) {
            simplified.indexesUsed.push(plan.indexName);
          }
          if (plan.inputStage) extractIndexes(plan.inputStage);
          if (plan.inputStages) plan.inputStages.forEach(extractIndexes);
        };
        extractIndexes(explainResult.queryPlanner.winningPlan);
      }
      
      return simplified;
    } catch (error) {
      logger.warn(`[ExplainSimplifyError] 简化执行计划时出错: ${error.message}\n${error.stack}`);
      return null;
    }
  }

  /**
   * 提取查询策略信息
   * @param {Array<Object>} queries - 查询列表
   * @returns {Object} 查询策略映射
   * 仅提取策略关键信息，便于版本追踪和回滚
   */
  extractQueryStrategies(queries) {
    const strategies = {};
    
    queries.forEach(query => {
      strategies[query.id] = {
        operation: query.operation,
        collection: query.collection,
        filter: query.filter,
        options: query.options,
        pipeline: query.pipeline,
        field: query.field
      };
    });
    
    return strategies;
  }

  /**
   * 分析部署前后的性能变化，得出整体评分
   * 评估每个查询是否优化/退化/无变化，并进行打分
   */
  analyzePerformanceChanges() {
    if (!this.currentDeployment || !this.currentDeployment.preBenchmark || !this.currentDeployment.postBenchmark) {
      throw new Error('必须先完成部署前后的基准测试');
    }
    
    const { preBenchmark, postBenchmark } = this.currentDeployment;
    const performance = {
      improvement: {
        count: 0,
        queries: [],
        averageImprovement: 0
      },
      regressions: {
        count: 0,
        queries: [],
        averageRegression: 0
      },
      unchanged: {
        count: 0,
        queries: []
      },
      overallScore: 0
    };
    
    // 查询ID到结果的映射
    const preResultsMap = {};
    preBenchmark.queryResults.forEach(result => {
      preResultsMap[result.queryId] = result;
    });
    
    // 分析每个查询的性能变化
    let totalImprovementPercentage = 0;
    let totalRegressionPercentage = 0;
    
    postBenchmark.queryResults.forEach(postResult => {
      const preResult = preResultsMap[postResult.queryId];
      
      // 跳过异常情况：部署前或后有错误的查询，无法比较性能
      if (postResult.error || (preResult && preResult.error)) {
        // 可选：可将异常查询单独统计
        return;
      }
      if (preResult) {
        const preDuration = preResult.duration;
        const postDuration = postResult.duration;
        const diff = preDuration - postDuration;
        const changePercentage = (diff / preDuration) * 100;
        // 性能改进
        if (diff > 0 && changePercentage >= 5) {  // 至少5%的改进
          performance.improvement.count++;
          performance.improvement.queries.push({
            queryId: postResult.queryId,
            collection: postResult.collection,
            operation: postResult.operation,
            preTime: preDuration,
            postTime: postDuration,
            improvement: diff,
            improvementPercentage: changePercentage
          });
          totalImprovementPercentage += changePercentage;
        } 
        // 性能回归
        else if (diff < 0 && changePercentage <= -5) {  // 至少5%的回归
          performance.regressions.count++;
          performance.regressions.queries.push({
            queryId: postResult.queryId,
            collection: postResult.collection,
            operation: postResult.operation,
            preTime: preDuration,
            postTime: postDuration,
            regression: -diff,
            regressionPercentage: -changePercentage
          });
          totalRegressionPercentage += -changePercentage;
        } 
        // 性能基本不变
        else {
          performance.unchanged.count++;
          performance.unchanged.queries.push({
            queryId: postResult.queryId,
            collection: postResult.collection,
            operation: postResult.operation,
            preTime: preDuration,
            postTime: postDuration
          });
        }
      }
    });
    
    // 计算平均改进和回归百分比
    if (performance.improvement.count > 0) {
      performance.improvement.averageImprovement = totalImprovementPercentage / performance.improvement.count;
    }
    
    if (performance.regressions.count > 0) {
      performance.regressions.averageRegression = totalRegressionPercentage / performance.regressions.count;
    }
    
    // 总体评分构成解释：
    // - 改进占比越高越好（加权0.7）；
    // - 回归惩罚较重（加权1.3）；
    // - 整体评分限制在 -100 ~ 100。
    const totalQueries = performance.improvement.count + performance.regressions.count + performance.unchanged.count;
    if (totalQueries > 0) {
      const improvementWeight = 0.7;
      const regressionWeight = 1.3; // 回归有更高的惩罚权重
      const improvementScore = (performance.improvement.count / totalQueries) * 
                               performance.improvement.averageImprovement * 
                               improvementWeight;
      const regressionScore = (performance.regressions.count / totalQueries) * 
                              performance.regressions.averageRegression * 
                              regressionWeight;
      performance.overallScore = improvementScore - regressionScore;
      performance.overallScore = Math.max(-100, Math.min(100, performance.overallScore));
    }
    
    // 对查询结果进行排序（改进最大的在前，回归最严重的在前）
    performance.improvement.queries.sort((a, b) => b.improvementPercentage - a.improvementPercentage);
    performance.regressions.queries.sort((a, b) => b.regressionPercentage - a.regressionPercentage);
    
    // 更新当前部署的性能信息
    this.currentDeployment.performance = performance;
  }

  /**
   * 保存部署信息到本地 JSON 文件
   * 结构路径：[项目目录]/data/query-evolution/deploy_xxx.json
   * @returns {Promise<void>}
   */
  async saveDeploymentInfo() {
    if (!this.currentDeployment) {
      throw new Error('没有活动的部署');
    }
    
    const deploymentPath = path.join(this.historyPath, `${this.currentDeployment.id}.json`);
    
    try {
      // 添加日志：部署信息写入文件路径
      logger.debug(`写入部署文件路径: ${deploymentPath}`);
      await fs.promises.writeFile(
        deploymentPath,
        JSON.stringify(this.currentDeployment, null, 2)
      );
      
      // 更新最新部署的引用
      await fs.promises.writeFile(
        path.join(this.historyPath, 'latest.json'),
        JSON.stringify({ latestDeploymentId: this.currentDeployment.id })
      );
      
      logger.info(`已保存部署信息: ${this.currentDeployment.id}`);
    } catch (error) {
      logger.error(`[DeploySaveError] 保存部署信息失败: ${error.message}\n${error.stack}`);
      throw error;
    }
  }

  /**
   * 获取指定部署信息，若未指定则读取 latest.json 指向的最后一次部署记录
   * @param {string} deploymentId - 部署ID
   * @returns {Promise<Object>} 部署信息
   */
  async getDeploymentInfo(deploymentId) {
    try {
      // 如果没有指定ID，获取最新的部署
      if (!deploymentId) {
        try {
          const latestData = await fs.promises.readFile(
            path.join(this.historyPath, 'latest.json'),
            'utf8'
          );
          const latest = JSON.parse(latestData);
          deploymentId = latest.latestDeploymentId;
        } catch (error) {
          throw new Error('找不到最新部署信息');
        }
      }
      
      const deploymentPath = path.join(this.historyPath, `${deploymentId}.json`);
      // 添加日志：从文件读取路径
      logger.debug(`读取部署文件路径: ${deploymentPath}`);
      const data = await fs.promises.readFile(deploymentPath, 'utf8');
      return JSON.parse(data);
    } catch (error) {
      logger.error(`[DeployLoadError] 获取部署信息失败: ${deploymentId} - ${error.message}\n${error.stack}`);
      throw error;
    }
  }

  /**
   * 获取部署历史（最近N条）
   * 按部署时间倒序排列
   * @param {number} limit - 限制返回的部署数量
   * @returns {Promise<Array<Object>>} 部署历史列表
   */
  async getDeploymentHistory(limit = 10) {
    try {
      // 获取所有部署文件
      const files = await fs.promises.readdir(this.historyPath);
      const deploymentFiles = files.filter(file => 
        file.startsWith('deploy_') && file.endsWith('.json')
      );
      
      // 按创建时间排序（最新的在前）
      deploymentFiles.sort((a, b) => {
        // 从文件名中提取时间戳
        const timestampA = parseInt(a.replace('deploy_', '').replace('.json', ''));
        const timestampB = parseInt(b.replace('deploy_', '').replace('.json', ''));
        return timestampB - timestampA;
      });
      
      // 限制返回数量
      const limitedFiles = deploymentFiles.slice(0, limit);
      // 添加日志：列出所有部署文件
      logger.debug(`历史部署文件列表: ${deploymentFiles.join(', ')}`);
      
      // 读取部署信息
      const deployments = [];
      for (const file of limitedFiles) {
        try {
          const data = await fs.promises.readFile(
            path.join(this.historyPath, file),
            'utf8'
          );
          
          const deployment = JSON.parse(data);
          deployments.push({
            id: deployment.id,
            version: deployment.version,
            description: deployment.description,
            startTime: deployment.startTime,
            overallScore: deployment.performance?.overallScore,
            improvementCount: deployment.performance?.improvement?.count,
            regressionCount: deployment.performance?.regressions?.count
          });
        } catch (error) {
          logger.warn(`[HistoryReadError] 读取部署文件失败: ${file} - ${error.message}\n${error.stack}`);
        }
      }
      
      return deployments;
    } catch (error) {
      logger.error(`[HistoryLoadError] 获取部署历史失败: ${error.message}\n${error.stack}`);
      throw error;
    }
  }

  /**
   * 回滚到历史部署的查询策略
   * 会创建一个新的回滚版本并设为最新
   * @param {string} deploymentId - 部署ID
   * @returns {Promise<Object>} 回滚结果
   */
  async rollbackToDeployment(deploymentId) {
    try {
      // 获取目标部署信息
      const deployment = await this.getDeploymentInfo(deploymentId);
      
      if (!deployment || !deployment.queryStrategies) {
        throw new Error(`部署 ${deploymentId} 没有可用的查询策略`);
      }
      
      // 创建回滚操作的记录
      const rollbackDeployment = {
        id: `rollback_${Date.now()}`,
        version: `rollback_to_${deployment.version}`,
        description: `回滚到部署 ${deployment.id} (${deployment.version})`,
        startTime: new Date(),
        targetDeploymentId: deployment.id,
        queryStrategies: deployment.queryStrategies,
        status: 'completed'
      };
      
      // 保存回滚信息
      const rollbackPath = path.join(this.historyPath, `${rollbackDeployment.id}.json`);
      logger.info(`准备从部署 ${deploymentId} 回滚`);
      await fs.promises.writeFile(
        rollbackPath,
        JSON.stringify(rollbackDeployment, null, 2)
      );
      
      // 更新最新部署的引用
      await fs.promises.writeFile(
        path.join(this.historyPath, 'latest.json'),
        JSON.stringify({ latestDeploymentId: rollbackDeployment.id })
      );
      
      logger.info(`已回滚到部署 ${deployment.id} 的查询策略`);
      
      return {
        success: true,
        rollbackId: rollbackDeployment.id,
        message: `已成功回滚到部署 ${deployment.id} (${deployment.version}) 的查询策略`
      };
    } catch (error) {
      logger.error(`[RollbackError] 回滚到部署 ${deploymentId} 失败: ${error.message}\n${error.stack}`);
      throw error;
    }
  }

  /**
   * 生成指定部署的性能报告
   * 包含查询耗时对比、性能趋势、建议等
   * @param {string} deploymentId - 部署ID
   * @returns {Promise<Object>} 性能报告
   */
  async generatePerformanceReport(deploymentId) {
    try {
      // 获取部署信息
      const deployment = await this.getDeploymentInfo(deploymentId);
      
      if (!deployment) {
        throw new Error(`部署 ${deploymentId} 不存在`);
      }
      
      if (!deployment.performance || !deployment.preBenchmark || !deployment.postBenchmark) {
        throw new Error(`部署 ${deploymentId} 没有完整的性能测试数据`);
      }
      
      // 生成详细报告
      const report = {
        reportId: `report_${Date.now()}`,
        generatedAt: new Date(),
        deploymentInfo: {
          id: deployment.id,
          version: deployment.version,
          description: deployment.description,
          startTime: deployment.startTime
        },
        performanceSummary: {
          overallScore: deployment.performance.overallScore,
          improvements: {
            count: deployment.performance.improvement.count,
            averageImprovement: deployment.performance.improvement.averageImprovement,
            topImprovements: deployment.performance.improvement.queries.slice(0, 5)
          },
          regressions: {
            count: deployment.performance.regressions.count,
            averageRegression: deployment.performance.regressions.averageRegression,
            topRegressions: deployment.performance.regressions.queries.slice(0, 5)
          },
          unchanged: {
            count: deployment.performance.unchanged.count
          }
        },
        benchmarkComparison: {
          preBenchmark: {
            timestamp: deployment.preBenchmark.timestamp,
            totalQueries: deployment.preBenchmark.totalQueries,
            totalDuration: deployment.preBenchmark.totalDuration,
            averageDuration: deployment.preBenchmark.averageDuration
          },
          postBenchmark: {
            timestamp: deployment.postBenchmark.timestamp,
            totalQueries: deployment.postBenchmark.totalQueries,
            totalDuration: deployment.postBenchmark.totalDuration,
            averageDuration: deployment.postBenchmark.averageDuration
          },
          durationChange: {
            absolute: deployment.postBenchmark.totalDuration - deployment.preBenchmark.totalDuration,
            percentage: ((deployment.postBenchmark.totalDuration - deployment.preBenchmark.totalDuration) / 
                         deployment.preBenchmark.totalDuration) * 100
          },
          averageDurationChange: {
            absolute: deployment.postBenchmark.averageDuration - deployment.preBenchmark.averageDuration,
            percentage: ((deployment.postBenchmark.averageDuration - deployment.preBenchmark.averageDuration) / 
                         deployment.preBenchmark.averageDuration) * 100
          }
        },
        recommendations: []
      };
      
      // 生成优化建议
      if (deployment.performance.regressions.count > 0) {
        report.recommendations.push({
          type: 'critical',
          message: `检测到 ${deployment.performance.regressions.count} 个查询性能回归，建议检查这些查询的执行计划`
        });
        
        // 针对最严重的回归提供具体建议
        const worstRegression = deployment.performance.regressions.queries[0];
        if (worstRegression) {
          report.recommendations.push({
            type: 'specific',
            message: `最严重的性能回归：查询 ${worstRegression.queryId} (${worstRegression.collection}.${worstRegression.operation}) 性能下降了 ${worstRegression.regressionPercentage.toFixed(2)}%，从 ${worstRegression.preTime}ms 增加到 ${worstRegression.postTime}ms`
          });
        }
      }
      
      if (deployment.performance.overallScore < 0) {
        report.recommendations.push({
          type: 'warning',
          message: `整体查询性能下降 (评分: ${deployment.performance.overallScore.toFixed(2)})，建议考虑回滚到之前的查询策略`
        });
      } else if (deployment.performance.overallScore > 50) {
        report.recommendations.push({
          type: 'positive',
          message: `查询性能显著提升 (评分: ${deployment.performance.overallScore.toFixed(2)})，建议保留当前查询策略`
        });
      }
      
      // 保存报告
      const reportPath = path.join(this.historyPath, `${report.reportId}.json`);
      logger.info(`生成性能报告: ${reportPath}`);
      await fs.promises.writeFile(
        reportPath,
        JSON.stringify(report, null, 2)
      );
      
      return report;
    } catch (error) {
      logger.error(`[ReportError] 生成部署 ${deploymentId} 的性能报告失败: ${error.message}\n${error.stack}`);
      throw error;
    }
  }
}

module.exports = new QueryEvolutionScorer(); 