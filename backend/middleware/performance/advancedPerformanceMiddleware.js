const os = require('os');
const v8 = require('v8');
const { logger } = require('../core/loggingMiddleware');

/**
 * 高级性能监控中间件集合
 * 提供详细的系统和应用性能监控，包括：
 * - 请求统计和响应时间分析
 * - CPU和内存使用监控
 * - 数据库和缓存性能统计
 * - 性能报告生成
 */

// 性能指标收集器
class PerformanceMetrics {
    constructor() {
        this.metrics = {
            requests: {
                total: 0,
                byMethod: {},
                byRoute: {},
                errors: 0
            },
            responseTime: {
                min: Infinity,
                max: 0,
                avg: 0,
                p95: 0,
                p99: 0,
                samples: []
            },
            resources: {
                cpu: {
                    usage: 0,
                    cores: os.cpus().length
                },
                memory: {
                    total: os.totalmem(),
                    free: os.freemem(),
                    used: os.totalmem() - os.freemem(),
                    heapUsed: 0,
                    heapTotal: 0,
                    external: 0
                },
                uptime: 0
            },
            database: {
                queries: 0,
                slowQueries: 0,
                errors: 0
            },
            cache: {
                hits: 0,
                misses: 0,
                errors: 0
            }
        };
        this.startTime = Date.now();
    }

    // 更新请求统计
    updateRequestStats(method, route, duration, isError) {
        this.metrics.requests.total++;
        this.metrics.requests.byMethod[method] = (this.metrics.requests.byMethod[method] || 0) + 1;
        this.metrics.requests.byRoute[route] = (this.metrics.requests.byRoute[route] || 0) + 1;
        if (isError) this.metrics.requests.errors++;

        // 更新响应时间统计
        this.metrics.responseTime.samples.push(duration);
        this.metrics.responseTime.min = Math.min(this.metrics.responseTime.min, duration);
        this.metrics.responseTime.max = Math.max(this.metrics.responseTime.max, duration);
        
        // 计算平均值
        const sum = this.metrics.responseTime.samples.reduce((a, b) => a + b, 0);
        this.metrics.responseTime.avg = sum / this.metrics.responseTime.samples.length;

        // 计算百分位数
        const sortedSamples = [...this.metrics.responseTime.samples].sort((a, b) => a - b);
        const p95Index = Math.floor(sortedSamples.length * 0.95);
        const p99Index = Math.floor(sortedSamples.length * 0.99);
        this.metrics.responseTime.p95 = sortedSamples[p95Index];
        this.metrics.responseTime.p99 = sortedSamples[p99Index];
    }

    // 更新资源使用统计
    updateResourceStats() {
        const heapStats = v8.getHeapStatistics();
        const cpus = os.cpus();
        const totalCpuTime = cpus.reduce((acc, cpu) => {
            return acc + Object.values(cpu.times).reduce((sum, time) => sum + time, 0);
        }, 0);
        const idleCpuTime = cpus.reduce((acc, cpu) => acc + cpu.times.idle, 0);
        
        this.metrics.resources.cpu.usage = ((totalCpuTime - idleCpuTime) / totalCpuTime) * 100;
        this.metrics.resources.memory.free = os.freemem();
        this.metrics.resources.memory.used = os.totalmem() - os.freemem();
        this.metrics.resources.memory.heapUsed = heapStats.used_heap_size;
        this.metrics.resources.memory.heapTotal = heapStats.total_heap_size;
        this.metrics.resources.memory.external = heapStats.external_memory;
        this.metrics.resources.uptime = os.uptime();
    }

    // 更新数据库统计
    updateDatabaseStats(isSlow, isError) {
        this.metrics.database.queries++;
        if (isSlow) this.metrics.database.slowQueries++;
        if (isError) this.metrics.database.errors++;
    }

    // 更新缓存统计
    updateCacheStats(isHit, isError) {
        if (isHit) this.metrics.cache.hits++;
        else this.metrics.cache.misses++;
        if (isError) this.metrics.cache.errors++;
    }

    // 获取性能报告
    getReport() {
        this.updateResourceStats();
        return {
            ...this.metrics,
            uptime: Date.now() - this.startTime
        };
    }

    // 重置指标
    reset() {
        this.metrics = new PerformanceMetrics().metrics;
        this.startTime = Date.now();
    }
}

// 创建性能指标实例
const metrics = new PerformanceMetrics();

// 高级性能监控中间件
const advancedPerformanceMonitor = (options = {}) => {
    const {
        interval = 30000, // 30秒更新一次资源统计
        logLevel = 'info',
        threshold = {
            responseTime: 1000, // 1秒
            cpuUsage: 80, // 80%
            memoryUsage: 85 // 85%
        }
    } = options;

    // 定期更新资源统计
    setInterval(() => {
        metrics.updateResourceStats();
        const report = metrics.getReport();
        
        // 检查资源使用是否超过阈值
        if (report.resources.cpu.usage > threshold.cpuUsage) {
            logger.warn('High CPU usage detected', {
                usage: report.resources.cpu.usage,
                threshold: threshold.cpuUsage
            });
        }
        
        if ((report.resources.memory.used / report.resources.memory.total) * 100 > threshold.memoryUsage) {
            logger.warn('High memory usage detected', {
                usage: (report.resources.memory.used / report.resources.memory.total) * 100,
                threshold: threshold.memoryUsage
            });
        }
    }, interval);

    return (req, res, next) => {
        const start = Date.now();
        
        // 在响应结束时更新统计
        res.on('finish', () => {
            const duration = Date.now() - start;
            metrics.updateRequestStats(
                req.method,
                req.path,
                duration,
                res.statusCode >= 400
            );

            if (duration > threshold.responseTime) {
                logger.warn('Slow request detected', {
                    method: req.method,
                    path: req.path,
                    duration,
                    threshold: threshold.responseTime
                });
            }
        });

        next();
    };
};

// 性能报告中间件
const performanceReport = (req, res, next) => {
    if (req.path === '/metrics') {
        res.json(metrics.getReport());
    } else {
        next();
    }
};

// 重置指标中间件
const resetMetrics = (req, res, next) => {
    if (req.path === '/metrics/reset' && req.method === 'POST') {
        metrics.reset();
        res.json({ message: 'Metrics reset successfully' });
    } else {
        next();
    }
};

module.exports = {
    advancedPerformanceMonitor,
    performanceReport,
    resetMetrics,
    metrics
}; 