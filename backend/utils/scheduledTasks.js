/**
 * 定时任务工具
 * 处理系统中的各种定时任务，如数据清理、缓存刷新等
 * @module utils/scheduledTasks
 */
const cron = require('node-cron');
const mongoose = require('mongoose');

// 任务列表
const tasks = [];

/**
 * 定时任务管理器
 */
const ScheduledTasks = {
  /**
   * 初始化所有定时任务
   */
  initTasks() {
    console.log('正在初始化定时任务...');
    
    // 清理过期数据任务 - 每天凌晨3点执行
    this.registerTask('cleanupExpiredData', '0 3 * * *', async () => {
      console.log('执行过期数据清理任务');
      try {
        // 在这里实现过期数据清理逻辑
        // 例如：await this.cleanupExpiredData();
      } catch (error) {
        console.error('过期数据清理任务失败:', error);
      }
    });
    
    // 更新缓存数据任务 - 每小时执行一次
    this.registerTask('updateCache', '0 * * * *', async () => {
      console.log('执行缓存更新任务');
      try {
        // 在这里实现缓存更新逻辑
        // 例如：await this.updateCache();
      } catch (error) {
        console.error('缓存更新任务失败:', error);
      }
    });
    
    // 数据库统计任务 - 每天凌晨2点执行
    this.registerTask('dbStats', '0 2 * * *', async () => {
      console.log('执行数据库统计任务');
      try {
        // 在这里实现数据库统计逻辑
        // 例如：await this.collectDatabaseStats();
      } catch (error) {
        console.error('数据库统计任务失败:', error);
      }
    });
    
    // 启动所有任务
    this.startAllTasks();
    
    console.log(`已初始化 ${tasks.length} 个定时任务`);
  },
  
  /**
   * 注册一个定时任务
   * @param {string} name - 任务名称
   * @param {string} schedule - cron表达式
   * @param {Function} func - 任务函数
   */
  registerTask(name, schedule, func) {
    tasks.push({
      name,
      schedule,
      func,
      task: null
    });
    console.log(`已注册定时任务: ${name}, 执行计划: ${schedule}`);
  },
  
  /**
   * 启动所有注册的任务
   */
  startAllTasks() {
    tasks.forEach(taskInfo => {
      if (taskInfo.task) {
        // 任务已经启动，跳过
        return;
      }
      
      try {
        taskInfo.task = cron.schedule(taskInfo.schedule, async () => {
          console.log(`执行定时任务: ${taskInfo.name}`);
          try {
            await taskInfo.func();
          } catch (error) {
            console.error(`定时任务执行失败: ${taskInfo.name}`, error);
          }
        });
        console.log(`已启动定时任务: ${taskInfo.name}`);
      } catch (error) {
        console.error(`启动定时任务失败: ${taskInfo.name}`, error);
      }
    });
  },
  
  /**
   * 停止所有任务
   */
  stopAllTasks() {
    tasks.forEach(taskInfo => {
      if (taskInfo.task) {
        taskInfo.task.stop();
        taskInfo.task = null;
        console.log(`已停止定时任务: ${taskInfo.name}`);
      }
    });
  },
  
  /**
   * 手动执行特定任务
   * @param {string} name - 任务名称
   * @returns {Promise<boolean>} 是否成功执行
   */
  async runTaskManually(name) {
    const taskInfo = tasks.find(t => t.name === name);
    if (!taskInfo) {
      console.error(`未找到任务: ${name}`);
      return false;
    }
    
    try {
      console.log(`手动执行任务: ${name}`);
      await taskInfo.func();
      console.log(`任务完成: ${name}`);
      return true;
    } catch (error) {
      console.error(`手动执行任务失败: ${name}`, error);
      return false;
    }
  },
  
  /**
   * 清理过期数据实现
   * @private
   */
  async cleanupExpiredData() {
    const now = new Date();
    console.log('开始清理过期数据...');
    
    // 这里可以实现各种数据清理逻辑
    // 例如：
    // 1. 清理过期的临时文件
    // 2. 归档旧的日志数据
    // 3. 删除过期的缓存
    
    console.log('过期数据清理完成');
  },
  
  /**
   * 更新缓存数据实现
   * @private
   */
  async updateCache() {
    console.log('开始更新缓存数据...');
    
    // 这里可以实现缓存更新逻辑
    // 例如：
    // 1. 更新热门商品缓存
    // 2. 刷新系统配置缓存
    // 3. 更新用户统计数据
    
    console.log('缓存数据更新完成');
  },
  
  /**
   * 收集数据库统计信息实现
   * @private
   */
  async collectDatabaseStats() {
    console.log('开始收集数据库统计信息...');
    
    // 收集MongoDB统计信息
    try {
      const db = mongoose.connection.db;
      const stats = await db.stats();
      console.log('数据库统计:', {
        dbSize: (stats.dataSize / (1024 * 1024)).toFixed(2) + ' MB',
        collections: stats.collections,
        objects: stats.objects
      });
      
      // 这里可以将统计信息保存到数据库或发送到监控系统
    } catch (error) {
      console.error('收集数据库统计信息失败:', error);
    }
    
    console.log('数据库统计信息收集完成');
  }
};

module.exports = ScheduledTasks; 