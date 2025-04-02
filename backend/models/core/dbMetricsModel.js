const mongoose = require('mongoose');

// 数据库指标模型，用于监控数据库性能和资源使用情况
const dbMetricsSchema = new mongoose.Schema({
  // 记录时间
  timestamp: {
    type: Date,
    default: Date.now,
    index: true
  },
  
  // 数据库连接信息
  connections: {
    current: Number,         // 当前连接数
    available: Number,       // 可用连接数
    pending: Number,         // 待处理连接请求
    totalCreated: Number     // 总共创建的连接数
  },
  
  // 查询性能指标
  operations: {
    reads: Number,           // 读操作次数
    writes: Number,          // 写操作次数
    updates: Number,         // 更新操作次数
    deletes: Number,         // 删除操作次数
    commands: Number,        // 命令操作次数
    aggregate: Number        // 聚合操作次数
  },
  
  // 查询延迟指标
  latency: {
    read: Number,            // 读操作平均延迟(毫秒)
    write: Number,           // 写操作平均延迟(毫秒)
    update: Number,          // 更新操作平均延迟(毫秒)
    delete: Number,          // 删除操作平均延迟(毫秒)
    command: Number,         // 命令操作平均延迟(毫秒)
    aggregate: Number        // 聚合操作平均延迟(毫秒)
  },
  
  // 系统资源使用
  system: {
    memory: Number,          // 内存使用(MB)
    cpu: Number,             // CPU使用率(%)
    disk: {
      used: Number,          // 磁盘使用(MB)
      free: Number           // 可用磁盘空间(MB)
    }
  },
  
  // 数据库统计信息
  dbStats: {
    collections: Number,     // 集合数量
    documents: Number,       // 文档总数
    indexes: Number,         // 索引总数
    dataSize: Number,        // 数据大小(MB)
    storageSize: Number,     // 存储大小(MB)
    indexSize: Number        // 索引大小(MB)
  },
  
  // 分片信息(如果有)
  shardInfo: {
    isSharded: Boolean,      // 是否开启分片
    shardDistribution: Object, // 分片文档分布
    balancerStatus: String   // 均衡器状态
  },
  
  // 其他指标
  misc: {
    slowQueries: Number,     // 慢查询数量
    errors: Number,          // 错误数量
    warnings: Number,        // 警告数量
    replicaLag: Number       // 副本延迟(毫秒)
  }
}, {
  timestamps: {
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  }
});

// 创建索引来优化查询效率
dbMetricsSchema.index({ 'timestamp': 1 });
dbMetricsSchema.index({ 'created_at': 1 });

const DbMetrics = mongoose.model('DbMetrics', dbMetricsSchema);

module.exports = DbMetrics;