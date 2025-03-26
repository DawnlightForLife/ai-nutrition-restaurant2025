const cron = require('node-cron');
const DbPerformanceAnalyzer = require('../utils/dbPerformanceAnalyzer');
const { MerchantStats } = require('../models');

/**
 * 定时任务服务
 * 管理系统中的所有定时任务
 */
class ScheduledTasks {
  /**
   * 初始化所有定时任务
   */
  static initTasks() {
    this.setupDatabaseMetricsCleanup();
    this.setupDailyPerformanceReport();
    this.setupMerchantStatsAggregation();
    console.log('定时任务已初始化');
  }

  /**
   * 设置数据库指标清理任务
   * 每月第一天凌晨3点运行
   */
  static setupDatabaseMetricsCleanup() {
    // 每月第一天凌晨3点运行
    cron.schedule('0 3 1 * *', async () => {
      try {
        console.log('执行数据库指标清理任务...');
        const deletedCount = await DbPerformanceAnalyzer.cleanupOldMetrics(30);
        console.log(`数据库指标清理完成，已删除 ${deletedCount} 条记录`);
      } catch (error) {
        console.error('数据库指标清理任务失败:', error);
      }
    });
  }

  /**
   * 设置每日性能报告生成任务
   * 每天凌晨2点运行
   */
  static setupDailyPerformanceReport() {
    // 每天凌晨2点运行
    cron.schedule('0 2 * * *', async () => {
      try {
        console.log('生成数据库每日性能报告...');
        const report = await DbPerformanceAnalyzer.generateDailyReport();
        
        // 这里可以添加逻辑将报告保存到数据库或发送邮件通知
        console.log('数据库性能报告生成完成');
        
        // 性能评分低于70时，向管理员发送警报
        if (report.performance_score < 70) {
          console.warn('数据库性能评分过低:', report.performance_score);
          await this.sendLowPerformanceAlert(report);
        }
      } catch (error) {
        console.error('生成数据库性能报告任务失败:', error);
      }
    });
  }

  /**
   * 设置商家统计数据聚合任务
   * 每天凌晨1点运行
   */
  static setupMerchantStatsAggregation() {
    // 每天凌晨1点运行
    cron.schedule('0 1 * * *', async () => {
      try {
        console.log('开始执行商家统计数据聚合...');
        
        // 获取所有商家ID
        const merchants = await require('../models').Merchant.find({}, { _id: 1 });
        const merchantIds = merchants.map(m => m._id);
        
        // 为每个商家更新统计数据
        let successCount = 0;
        
        for (const merchantId of merchantIds) {
          try {
            await MerchantStats.updateAllStats(merchantId);
            successCount++;
          } catch (err) {
            console.error(`更新商家 ${merchantId} 统计数据失败:`, err);
          }
        }
        
        console.log(`商家统计数据聚合完成，成功处理 ${successCount}/${merchantIds.length} 个商家`);
      } catch (error) {
        console.error('商家统计数据聚合任务失败:', error);
      }
    });
  }

  /**
   * 发送数据库性能低下警报
   * @param {Object} report 性能报告
   */
  static async sendLowPerformanceAlert(report) {
    try {
      // 这里可以添加发送邮件或短信通知的逻辑
      console.warn('数据库性能警报:');
      console.warn(`- 性能评分: ${report.performance_score}`);
      console.warn(`- 慢查询总数: ${report.slow_query_stats.total_count}`);
      console.warn(`- 受影响的集合数: ${report.slow_query_stats.collections_affected}`);
      
      if (report.optimization_suggestions.length > 0) {
        console.warn('优化建议:');
        report.optimization_suggestions
          .filter(s => s.priority === 'high')
          .forEach((suggestion, i) => {
            console.warn(`  ${i+1}. ${suggestion.problem}`);
            console.warn(`     建议: ${suggestion.suggestion}`);
          });
      }
      
      // 如果实际项目中有邮件服务，可以添加类似如下代码:
      // await emailService.sendAlert('数据库性能警报', {
      //   subject: `数据库性能评分过低: ${report.performance_score}`,
      //   report: report
      // });
    } catch (error) {
      console.error('发送数据库性能警报失败:', error);
    }
  }
}

module.exports = ScheduledTasks; 