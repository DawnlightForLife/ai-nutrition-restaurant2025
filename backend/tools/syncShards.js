/**
 * ✅ 模块名：syncShards.js
 * ✅ 所属工具：tools
 * ✅ 功能说明：
 *   - 将主集合中的用户数据迁移到 MongoDB 分片集合中
 *   - 支持 dryRun 模式模拟执行，不实际写入数据库
 *   - 支持限制迁移用户数量（--limit 参数）
 * ✅ 使用方法：
 *   node tools/syncShards.js [--limit=100] [--dryRun]
 */

/**
 * 用户分片同步工具
 * 该工具用于手动触发用户分片数据同步，将默认集合中的用户迁移到对应的分片集合
 * 
 * 主要功能：
 * 1. 从默认'users'集合获取用户数据
 * 2. 根据用户手机号计算正确的分片位置
 * 3. 将用户数据迁移到对应的分片集合
 * 4. 记录迁移日志以供审计和监控
 * 
 * 使用场景：
 * - 系统分片架构初始设置后的数据迁移
 * - 修复分片同步问题
 * - 对大量历史数据进行分批迁移
 * 
 * 使用方法:
 * node tools/syncShards.js [--limit=100] [--dryRun]
 * 
 * 参数说明：
 * --limit=100  限制处理的用户数量，默认100条
 * --dryRun     模拟运行模式，不实际修改数据库
 */

const mongoose = require('mongoose');
const User = require('../models/user/userModel');
const dbManager = require('../services/database/database');
const { getUserShardName } = require('../services/userService');
require('dotenv').config();

// 解析命令行参数
const args = process.argv.slice(2);
const options = {
  limit: 100, // 默认限制处理100个用户
  dryRun: false // 默认为实际执行模式
};

// 处理命令行参数
args.forEach(arg => {
  if (arg.startsWith('--limit=')) {
    options.limit = parseInt(arg.split('=')[1], 10);
  } else if (arg === '--dryRun') {
    options.dryRun = true;
  }
});

/**
 * 主函数：执行用户分片同步过程
 * 步骤：
 *   1. 连接数据库
 *   2. 查询默认集合的用户
 *   3. 根据手机号计算分片
 *   4. 判断目标分片是否已存在
 *   5. 写入目标分片 + 记录迁移日志（或 dryRun 显示）
 *   6. 输出统计信息
 */
async function syncUserShards() {
  try {
    console.log('开始分片同步过程...');
    console.log(`选项: 限制=${options.limit}, 模拟运行=${options.dryRun}`);
    
    // 连接数据库
    await dbManager.connect();
    console.log('数据库连接成功');
    
    // 查询默认集合中的用户
    // 使用lean()返回纯JavaScript对象而非Mongoose文档，提高性能
    const users = await User.find({}).limit(options.limit).lean();
    console.log(`从默认集合查询到 ${users.length} 个用户`);
    
    // 初始化统计信息对象
    const stats = {
      total: users.length,     // 总处理用户数
      migrated: 0,             // 成功迁移数量
      skipped: 0,              // 跳过处理数量 
      failed: 0,               // 迁移失败数量
      shards: {}               // 各分片用户分布情况
    };
    
    // 获取数据库连接用于低级操作
    const db = await dbManager.getPrimaryConnection();
    
    // 遍历用户进行分片迁移处理
    for (const user of users) {
      // 跳过没有手机号的用户，因为无法确定分片位置
      if (!user.phone) {
        console.log(`跳过用户 ${user._id}：缺少手机号`);
        stats.skipped++;
        continue;
      }
      
      // 根据手机号确定用户应该在哪个分片
      const shard = getUserShardName(user.phone);
      // 更新分片统计信息
      stats.shards[shard] = (stats.shards[shard] || 0) + 1;
      
      try {
        // 检查用户是否已存在于目标分片中，避免重复写入
        const existingUserInShard = await db.collection(shard).findOne({ _id: user._id });
        
        if (existingUserInShard) {
          console.log(`用户 ${user._id} 已存在于分片 ${shard} 中，跳过`);
          stats.skipped++;
          continue;
        }
        
        // 执行分片迁移 - 实际模式与模拟模式的处理逻辑
        if (!options.dryRun) {
          // 实际执行模式：将用户写入目标分片集合
          const result = await db.collection(shard).insertOne(user);
          if (result.acknowledged) {
            console.log(`用户 ${user._id} 已成功迁移到分片 ${shard}`);
            
            // 记录迁移日志到专门的日志集合，便于后续审计和监控
            await db.collection('shard_migration_logs').insertOne({
              userId: user._id,
              phone: user.phone,
              fromCollection: 'users',
              toCollection: shard,
              migratedAt: new Date(),
              success: true
            });
            
            stats.migrated++;
          } else {
            console.error(`[syncShards] 迁移用户 ${user._id} 到分片 ${shard} 失败`);
            stats.failed++;
          }
        } else {
          // 模拟模式：只记录将要执行的操作，不实际修改数据库
          console.log(`[DRY RUN] 用户 ${user._id} 将被迁移到分片 ${shard}`);
          stats.migrated++;
        }
      } catch (error) {
        console.error(`处理用户 ${user._id} 时出错:`, error);
        stats.failed++;
      }
    }
    
    // 打印执行统计摘要信息
    console.log('\n📊 分片同步完成！统计信息如下:');
    console.log(`总用户数: ${stats.total}`);
    console.log(`已迁移: ${stats.migrated}`);
    console.log(`已跳过: ${stats.skipped}`);
    console.log(`失败: ${stats.failed}`);
    console.log('分片分布:');
    // 显示各分片的用户分布情况
    Object.entries(stats.shards).forEach(([shard, count]) => {
      console.log(`  - ${shard}: ${count} 用户`);
    });
    
  } catch (error) {
    // 捕获并记录整个过程中的任何错误
    console.error('[syncShards] 分片同步过程失败:', error);
  } finally {
    // 无论成功失败都确保关闭数据库连接
    await mongoose.disconnect();
    console.log('数据库连接已关闭');
    process.exit(0);
  }
}

// 执行同步过程
syncUserShards(); 