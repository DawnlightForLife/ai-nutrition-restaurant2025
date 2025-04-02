const mongoose = require('mongoose');
const { logger } = require('./loggingMiddleware');

// 查询监控类
class QueryMonitor {
    constructor() {
        this.queries = [];
        this.slowQueries = [];
        this.totalQueries = 0;
        this.totalTime = 0;
        this.maxQueries = 1000; // 最多保存1000条查询记录
    }

    addQuery(query) {
        this.queries.push(query);
        this.totalQueries++;
        this.totalTime += query.duration;

        // 如果查询时间超过阈值，记录为慢查询
        if (query.duration > 100) { // 100ms阈值
            this.slowQueries.push(query);
        }

        // 限制存储的查询数量
        if (this.queries.length > this.maxQueries) {
            this.queries.shift();
        }
    }

    getStats() {
        return {
            totalQueries: this.totalQueries,
            averageTime: this.totalTime / this.totalQueries,
            slowQueries: this.slowQueries.length,
            recentQueries: this.queries.slice(-10)
        };
    }

    clear() {
        this.queries = [];
        this.slowQueries = [];
        this.totalQueries = 0;
        this.totalTime = 0;
    }
}

// 查询优化器类
class QueryOptimizer {
    constructor(options = {}) {
        this.options = {
            maxLimit: options.maxLimit || 50,
            defaultLimit: options.defaultLimit || 10,
            allowedFields: options.allowedFields || [],
            defaultSort: options.defaultSort || { createdAt: -1 },
            maxDepth: options.maxDepth || 3,
            ...options
        };
    }

    optimizeQuery(query) {
        // 优化limit
        if (query.limit > this.options.maxLimit) {
            query.limit = this.options.maxLimit;
        }

        // 优化sort
        if (query.sort) {
            const sortFields = Object.keys(query.sort);
            const invalidFields = sortFields.filter(field => 
                !this.options.allowedFields.includes(field)
            );
            if (invalidFields.length > 0) {
                query.sort = this.options.defaultSort;
            }
        }

        // 优化select
        if (query.select) {
            const selectFields = query.select.split(' ');
            const validFields = selectFields.filter(field => 
                this.options.allowedFields.includes(field)
            );
            if (validFields.length > 0) {
                query.select = validFields.join(' ');
            }
        }

        // 优化populate
        if (query.populate) {
            query.populate = this.optimizePopulate(query.populate);
        }

        return query;
    }

    optimizePopulate(populate, depth = 0) {
        if (depth >= this.options.maxDepth) {
            return null;
        }

        if (Array.isArray(populate)) {
            return populate.map(p => this.optimizePopulate(p, depth + 1));
        }

        if (typeof populate === 'object') {
            const optimized = { ...populate };
            if (optimized.populate) {
                optimized.populate = this.optimizePopulate(optimized.populate, depth + 1);
            }
            return optimized;
        }

        return populate;
    }
}

// 查询缓存类
class QueryCache {
    constructor(redis, options = {}) {
        this.redis = redis;
        this.options = {
            ttl: options.ttl || 300, // 默认5分钟
            prefix: options.prefix || 'cache:',
            ...options
        };
    }

    async get(key) {
        try {
            const data = await this.redis.get(`${this.options.prefix}${key}`);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            logger.error('Cache get error:', error);
            return null;
        }
    }

    async set(key, value, ttl = this.options.ttl) {
        try {
            await this.redis.set(
                `${this.options.prefix}${key}`,
                JSON.stringify(value),
                'EX',
                ttl
            );
            return true;
        } catch (error) {
            logger.error('Cache set error:', error);
            return false;
        }
    }

    async delete(key) {
        try {
            await this.redis.del(`${this.options.prefix}${key}`);
            return true;
        } catch (error) {
            logger.error('Cache delete error:', error);
            return false;
        }
    }

    async clear(pattern) {
        try {
            const keys = await this.redis.keys(`${this.options.prefix}${pattern}`);
            if (keys.length > 0) {
                await this.redis.del(keys);
            }
            return true;
        } catch (error) {
            logger.error('Cache clear error:', error);
            return false;
        }
    }
}

// 批量操作优化器类
class BatchOptimizer {
    constructor(options = {}) {
        this.options = {
            maxBatchSize: options.maxBatchSize || 1000,
            chunkSize: options.chunkSize || 100,
            ...options
        };
    }

    async processBatch(operations, processor) {
        const chunks = this.chunkArray(operations, this.options.chunkSize);
        const results = [];

        for (const chunk of chunks) {
            const chunkResults = await Promise.all(
                chunk.map(operation => processor(operation))
            );
            results.push(...chunkResults);
        }

        return results;
    }

    chunkArray(array, size) {
        const chunks = [];
        for (let i = 0; i < array.length; i += size) {
            chunks.push(array.slice(i, i + size));
        }
        return chunks;
    }
}

// 创建实例
const queryMonitor = new QueryMonitor();
const queryCache = new QueryCache(require('./advancedRateLimitMiddleware').redis);
const batchOptimizer = new BatchOptimizer();

// 中间件函数
const queryMonitorMiddleware = () => {
    return (req, res, next) => {
        const start = Date.now();
        
        res.on('finish', () => {
            const duration = Date.now() - start;
            queryMonitor.addQuery({
                method: req.method,
                path: req.path,
                duration,
                timestamp: new Date()
            });
        });

        next();
    };
};

const queryOptimizerMiddleware = (options) => {
    const optimizer = new QueryOptimizer(options);
    
    return (req, res, next) => {
        if (req.query) {
            req.query = optimizer.optimizeQuery(req.query);
        }
        next();
    };
};

const queryCacheMiddleware = (options) => {
    return async (req, res, next) => {
        if (req.method !== 'GET') {
            return next();
        }

        const cacheKey = `${req.method}:${req.path}:${JSON.stringify(req.query)}`;
        const cachedData = await queryCache.get(cacheKey);

        if (cachedData) {
            return res.json(cachedData);
        }

        const originalJson = res.json;
        res.json = function(data) {
            queryCache.set(cacheKey, data, options.ttl);
            return originalJson.call(this, data);
        };

        next();
    };
};

const batchOptimizerMiddleware = (options) => {
    return async (req, res, next) => {
        if (req.body && Array.isArray(req.body)) {
            req.body = await batchOptimizer.processBatch(
                req.body,
                operation => operation
            );
        }
        next();
    };
};

// 导出中间件和实例
module.exports = {
    queryMonitor: queryMonitorMiddleware,
    queryOptimizer: queryOptimizerMiddleware,
    queryCache: queryCacheMiddleware,
    batchOptimizer: batchOptimizerMiddleware,
    queryMonitorInstance: queryMonitor,
    queryCacheInstance: queryCache,
    batchOptimizerInstance: batchOptimizer
}; 