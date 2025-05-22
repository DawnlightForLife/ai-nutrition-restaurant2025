/**
 * 分片状态监控脚本
 * 用于监控各个分片的状态，并提供关键指标
 * 
 * 主要功能：
 * 1. 扫描并识别系统中的所有分片集合
 * 2. 收集每个分片集合的文档数量、大小等统计信息
 * 3. 分析分片分布情况和均衡性
 * 4. 监控分片迁移进度
 * 5. 生成和展示分片健康报告
 * 
 * 关键指标：
 * - 分片数量与分布情况
 * - 各分片的文档数和存储空间
 * - 分片均衡性分析 
 * - 分片率计算（已分片数据占总数据的比例）
 * - 迁移进度统计
 * 
 * 使用方法:
 * node scripts/monitor-shards.js [--interval=60] [--verbose]
 * 
 * 参数说明：
 * --interval=60  监控更新频率，单位秒，设为0则只运行一次
 * --verbose      显示详细信息模式，包括每个分片的详细统计
 */

const mongoose = require('mongoose');
const dbManager = require('../services/database/database');
const { shardingConfig } = require('../utils/shardingConfig');
require('dotenv').config();

// 解析命令行参数
const args = process.argv.slice(2);
const options = {
  interval: 60, // 默认每60秒监控一次
  verbose: false // 详细模式标志
};

// 处理命令行参数
args.forEach(arg => {
  if (arg.startsWith('--interval=')) {
    options.interval = parseInt(arg.split('=')[1], 10);
  } else if (arg === '--verbose') {
    options.verbose = true;
  }
});

/**
 * 获取所有分片名称
 * 扫描数据库中的所有集合，根据命名规则识别出分片集合
 * 
 * @returns {Promise<string[]>} 分片集合名称列表
 */
async function getAllShardNames() {
  const db = await dbManager.getPrimaryConnection();
  const collections = await db.listCollections().toArray();
  
  // 过滤分片集合（根据命名规则）
  // 包括所有主要数据类型的分片：用户、健康数据、订单、商家、审计日志等
  const shardCollections = collections.filter(coll => {
    const name = coll.name;
    return (
      name.startsWith('user_shard_') ||
      name.startsWith('nutritiondata_user_') ||
      name.startsWith('order_') ||
      name.startsWith('merchant_region_') ||
      name.startsWith('auditlog_') ||
      name.startsWith('airecommendation_user_') ||
      name.startsWith('forumpost_')
    );
  });
  
  return shardCollections.map(coll => coll.name);
}

/**
 * 获取集合的统计信息
 * 查询指定集合的文档数、大小、索引等统计数据
 * 
 * @param {string} collectionName - 集合名称
 * @returns {Promise<Object>} 集合统计信息
 */
async function getCollectionStats(collectionName) {
  const db = await dbManager.getPrimaryConnection();
  return db.command({ collStats: collectionName });
}

/**
 * 生成分片状态报告
 * 收集和分析分片状态数据，生成综合报告
 * 包括分片分布、统计数据、健康状况和优化建议
 */
async function generateShardReport() {
  try {
    console.log('\n===== 分片状态监控报告 =====');
    console.log(`时间: ${new Date().toISOString()}`);
    
    // 确保数据库连接
    if (!mongoose.connection.readyState) {
      await dbManager.connect();
      console.log('数据库连接成功');
    }
    
    // 获取所有分片名称
    const shardNames = await getAllShardNames();
    console.log(`发现 ${shardNames.length} 个分片集合`);
    
    // 收集统计信息
    const stats = {}; // 用于存储每个分片的统计数据
    
    // 对分片按类型进行分组
    const shardTypes = {
      user: [],             // 用户分片
      nutritiondata: [],    // 健康数据分片
      order: [],            // 订单分片
      merchant: [],         // 商家分片
      auditlog: [],         // 审计日志分片
      airecommendation: [], // AI推荐分片
      forumpost: []         // 论坛帖子分片
    };
    
    // 按类型对分片进行分组，便于后续分析
    shardNames.forEach(name => {
      if (name.startsWith('user_shard_')) shardTypes.user.push(name);
      else if (name.startsWith('nutritiondata_user_')) shardTypes.nutritiondata.push(name);
      else if (name.startsWith('order_')) shardTypes.order.push(name);
      else if (name.startsWith('merchant_region_')) shardTypes.merchant.push(name);
      else if (name.startsWith('auditlog_')) shardTypes.auditlog.push(name);
      else if (name.startsWith('airecommendation_user_')) shardTypes.airecommendation.push(name);
      else if (name.startsWith('forumpost_')) shardTypes.forumpost.push(name);
    });
    
    // 默认集合列表，用于比较和计算分片率
    const defaultCollections = ['users', 'nutritiondata', 'orders', 'merchants'];
    
    // 打印分片统计信息
    console.log('\n分片集合统计:');
    
    // 按数据类型处理分片统计
    for (const type in shardTypes) {
      const shards = shardTypes[type];
      if (shards.length === 0) continue; // 跳过没有分片的类型
      
      console.log(`\n${type.toUpperCase()} 分片 (${shards.length}个):`);
      
      // 收集该类型分片的汇总统计
      let totalCount = 0; // 总文档数
      let totalSize = 0;  // 总大小（字节）
      
      // 处理每个分片的统计信息
      for (const shard of shards) {
        const stat = await getCollectionStats(shard);
        stats[shard] = stat;
        
        // 累加总量
        totalCount += stat.count;
        totalSize += stat.size;
        
        // 详细模式下显示每个分片的具体统计
        if (options.verbose) {
          console.log(`  ${shard}:`);
          console.log(`    - 文档数: ${stat.count}`);
          console.log(`    - 大小: ${(stat.size / 1024 / 1024).toFixed(2)} MB`);
          console.log(`    - 索引数: ${stat.nindexes}`);
        }
      }
      
      // 打印类型摘要统计
      console.log(`  总计:`);
      console.log(`    - 文档总数: ${totalCount}`);
      console.log(`    - 总大小: ${(totalSize / 1024 / 1024).toFixed(2)} MB`);
      console.log(`    - 平均每个分片: ${(totalCount / shards.length).toFixed(2)} 文档`);
      
      // 查询对应的默认集合进行比较
      const defaultCollection = defaultCollections.find(c => c.startsWith(type));
      if (defaultCollection) {
        try {
          // 获取默认集合的统计数据
          const defaultStat = await getCollectionStats(defaultCollection);
          console.log(`  默认集合 (${defaultCollection}):`);
          console.log(`    - 文档数: ${defaultStat.count}`);
          console.log(`    - 大小: ${(defaultStat.size / 1024 / 1024).toFixed(2)} MB`);
          
          // 计算分片率 - 已分片数据占总数据的百分比
          const shardRatio = totalCount / (totalCount + defaultStat.count);
          console.log(`    - 分片率: ${(shardRatio * 100).toFixed(2)}%`);
          
          // 如果分片率低于50%，显示警告
          if (shardRatio < 0.5) {
            console.log(`    ⚠️ 警告: 分片率低于50%，建议运行分片同步工具`);
          }
        } catch (err) {
          console.log(`  默认集合 (${defaultCollection}): 不存在或无法访问`);
        }
      }
    }
    
    // 分片优化建议部分
    console.log('\n分片优化建议:');
    
    // 检查用户分片是否平衡 - 通过统计偏差分析
    if (shardTypes.user.length > 0) {
      // 收集每个用户分片的文档数量
      const userCounts = await Promise.all(
        shardTypes.user.map(async shard => {
          const stat = stats[shard] || await getCollectionStats(shard);
          return { shard, count: stat.count };
        })
      );
      
      // 计算平均值和标准差，用于分析分布均衡性
      const avg = userCounts.reduce((sum, item) => sum + item.count, 0) / userCounts.length;
      const stdDev = Math.sqrt(
        userCounts.reduce((sum, item) => sum + Math.pow(item.count - avg, 2), 0) / userCounts.length
      );
      
      // 检查偏差 - 标准差/平均值>0.5表示分布不均衡
      if (stdDev / avg > 0.5) {
        console.log('⚠️ 用户分片不平衡，建议重新分配:');
        userCounts.forEach(item => {
          // 显示每个分片的偏差百分比
          console.log(`  - ${item.shard}: ${item.count} 用户 (偏差: ${((item.count - avg) / avg * 100).toFixed(2)}%)`);
        });
      } else {
        console.log('✅ 用户分片分布相对均匀');
      }
    }
    
    // 计算并显示迁移进度统计
    try {
      const db = await dbManager.getPrimaryConnection();
      // 查询已迁移记录数
      const migratedCount = await db.collection('shard_migration_logs').countDocuments({});
      // 查询默认集合中的记录数（待处理）
      const pendingCount = await db.collection('users').countDocuments({});
      
      console.log('\n分片迁移进度:');
      console.log(`  - 已迁移用户: ${migratedCount}`);
      console.log(`  - 待处理用户: ${pendingCount}`);
      
      // 如果有待处理用户，显示完成率和进度条
      if (pendingCount > 0) {
        const completionRate = migratedCount / (migratedCount + pendingCount) * 100;
        console.log(`  - 完成率: ${completionRate.toFixed(2)}%`);
        
        // 绘制简单的ASCII进度条
        const progressBar = '█'.repeat(Math.floor(completionRate / 5)) + '░'.repeat(20 - Math.floor(completionRate / 5));
        console.log(`  - [${progressBar}]`);
      }
    } catch (err) {
      console.log('无法获取迁移进度信息');
    }
    
  } catch (error) {
    console.error('生成分片报告出错:', error);
  }
}

// 执行监控 - 支持一次性运行或定期更新模式
if (options.interval <= 0) {
  // 一次性运行模式：执行一次后退出
  (async () => {
    await generateShardReport();
    await mongoose.disconnect();
    process.exit(0);
  })();
} else {
  // 定期更新模式：按指定间隔重复执行
  console.log(`开始分片监控，每 ${options.interval} 秒更新一次...`);
  console.log('按 Ctrl+C 退出');
  
  // 立即执行一次初始报告
  generateShardReport();
  
  // 设置定时器定期执行报告更新
  const intervalId = setInterval(generateShardReport, options.interval * 1000);
  
  // 处理退出信号
  process.on('SIGINT', async () => {
    clearInterval(intervalId); // 停止定时器
    console.log('\n停止分片监控...');
    await mongoose.disconnect(); // 关闭数据库连接
    process.exit(0); // 正常退出
  });
} 