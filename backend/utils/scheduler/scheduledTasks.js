/**
 * 定时任务工具
 * 处理系统中的各种定时任务，如数据清理、缓存刷新、数据库统计等
 * 可用于性能优化、资源清理、数据同步等周期性后台任务场景
 * @module utils/scheduledTasks
 */
const cron = require('node-cron');
const mongoose = require('mongoose');

// 任务列表，存储所有注册的定时任务信息
const tasks = [];

/**
 * 定时任务管理器
 * 提供定时任务的注册、启动、停止及手动执行功能
 */
const ScheduledTasks = {
  /**
   * 初始化所有定时任务
   * 应在系统启动后调用，注册并启动预定义的定时任务
   */
  initTasks() {
    console.log('🔄 正在初始化定时任务...');
    
    // 清理过期数据任务 - 每天凌晨3点执行
    // cron表达式说明：'0 3 * * *' 表示每天03:00执行
    this.registerTask('cleanupExpiredData', '0 3 * * *', this.cleanupExpiredData);
    
    // 更新缓存数据任务 - 每小时执行一次
    // cron表达式说明：'0 * * * *' 表示每小时的第0分钟执行
    this.registerTask('updateCache', '0 * * * *', this.updateCache);
    
    // 数据库统计任务 - 每天凌晨2点执行
    // cron表达式说明：'0 2 * * *' 表示每天02:00执行
    this.registerTask('dbStats', '0 2 * * *', this.collectDatabaseStats);
    
    // 启动所有注册的任务
    this.startAllTasks();
    
    console.log(`✅ 已初始化 ${tasks.length} 个定时任务`);
  },
  
  /**
   * 注册一个定时任务
   * @param {string} name - 任务名称（必须唯一）
   * @param {string} schedule - cron表达式（例如：'0 3 * * *' 表示每天凌晨3点）
   * @param {Function} func - 实际执行的异步任务函数
   */
  registerTask(name, schedule, func) {
    tasks.push({
      name,
      schedule,
      func,
      task: null
    });
    console.log(`📝 已注册定时任务: ${name}, 执行计划: ${schedule}`);
  },
  
  /**
   * 启动所有注册的任务
   * 通常由 initTasks 自动调用，启动所有未启动的任务
   */
  startAllTasks() {
    tasks.forEach(taskInfo => {
      if (taskInfo.task) {
        // 任务已经启动，跳过
        return;
      }
      
      try {
        taskInfo.task = cron.schedule(taskInfo.schedule, async () => {
          const startTime = new Date();
          console.log(`⏰ [${startTime.toISOString()}] 执行定时任务: ${taskInfo.name}`);
          try {
            await taskInfo.func();
            const endTime = new Date();
            console.log(`✅ [${endTime.toISOString()}] 定时任务完成: ${taskInfo.name}, 耗时: ${(endTime - startTime)}ms`);
          } catch (error) {
            console.error(`❌ 定时任务执行失败: ${taskInfo.name}`, error);
          }
        });
        console.log(`▶️ 已启动定时任务: ${taskInfo.name}`);
      } catch (error) {
        console.error(`❌ 启动定时任务失败: ${taskInfo.name}`, error);
      }
    });
  },
  
  /**
   * 停止所有注册任务
   * 可用于服务退出或调试场景，停止所有正在运行的定时任务
   */
  stopAllTasks() {
    tasks.forEach(taskInfo => {
      if (taskInfo.task) {
        taskInfo.task.stop();
        taskInfo.task = null;
        console.log(`⏹ 已停止定时任务: ${taskInfo.name}`);
      }
    });
  },
  
  /**
   * 手动触发执行某个已注册的定时任务
   * 常用于后台管理或紧急任务执行
   * @param {string} name - 任务名称
   * @returns {Promise<boolean>} 是否成功执行
   */
  async runTaskManually(name) {
    const taskInfo = tasks.find(t => t.name === name);
    if (!taskInfo) {
      console.error(`⚠️ 未找到任务: ${name}`);
      return false;
    }
    
    try {
      const startTime = new Date();
      console.log(`🔧 [${startTime.toISOString()}] 手动执行任务: ${name}`);
      await taskInfo.func();
      const endTime = new Date();
      console.log(`✅ [${endTime.toISOString()}] 任务完成: ${name}, 耗时: ${(endTime - startTime)}ms`);
      return true;
    } catch (error) {
      console.error(`❌ 手动执行任务失败: ${name}`, error);
      return false;
    }
  },
  
  /**
   * 实现：清理系统中过期数据
   * 可扩展为清理用户临时记录、日志归档等
   * @private
   */
  async cleanupExpiredData() {
    const now = new Date();
    console.log(`🧹 [${now.toISOString()}] 开始清理过期数据...`);
    
    // 这里可以实现各种数据清理逻辑
    // 例如：
    // 1. 清理过期的临时文件
    // 2. 归档旧的日志数据
    // 3. 删除过期的缓存
    
    console.log(`✅ [${new Date().toISOString()}] 过期数据清理完成`);
  },
  
  /**
   * 实现：刷新缓存数据（如热门商品、系统配置等）
   * @private
   */
  async updateCache() {
    console.log(`♻️ [${new Date().toISOString()}] 开始更新缓存数据...`);
    
    // 这里可以实现缓存更新逻辑
    // 例如：
    // 1. 更新热门商品缓存
    // 2. 刷新系统配置缓存
    // 3. 更新用户统计数据
    
    console.log(`✅ [${new Date().toISOString()}] 缓存数据更新完成`);
  },
  
  /**
   * 实现：收集数据库统计信息（如大小、集合数、对象数等）
   * 可扩展为存入数据库或推送至日志系统
   * @private
   */
  async collectDatabaseStats() {
    console.log(`📊 [${new Date().toISOString()}] 开始收集数据库统计信息...`);
    
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
      console.error('❌ 收集数据库统计信息失败:', error);
    }
    
    console.log(`✅ [${new Date().toISOString()}] 数据库统计信息收集完成`);
  }
};

module.exports = ScheduledTasks; 