const cacheService = require('../cacheService');
const logger = require('../../config/modules/logger');

/**
 * 营养师管理缓存服务
 * 提供针对营养师管理功能的缓存优化
 */
class NutritionistManagementCacheService {
  constructor() {
    this.cacheKeyPrefix = 'nutritionist_mgmt';
    this.defaultTTL = 300; // 5分钟
    this.listTTL = 180; // 3分钟 - 列表数据更新较频繁
    this.statsTTL = 120; // 2分钟 - 统计数据需要相对实时
    this.detailTTL = 600; // 10分钟 - 详情数据相对稳定
  }

  /**
   * 生成缓存键
   */
  generateKey(type, ...params) {
    return `${this.cacheKeyPrefix}:${type}:${params.filter(p => p !== null && p !== undefined).join(':')}`;
  }

  /**
   * 缓存营养师列表
   */
  async cacheNutritionistsList(params, data) {
    try {
      const key = this.generateKey(
        'list',
        params.page || 1,
        params.limit || 20,
        params.status || 'all',
        params.verificationStatus || 'all',
        params.specialization || 'all',
        params.search || 'none',
        params.sortBy || 'createdAt',
        params.sortOrder || 'desc'
      );

      await cacheService.set(key, data, this.listTTL);
      logger.debug('营养师列表已缓存', { key, ttl: this.listTTL });
      return true;
    } catch (error) {
      logger.error('缓存营养师列表失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存的营养师列表
   */
  async getCachedNutritionistsList(params) {
    try {
      const key = this.generateKey(
        'list',
        params.page || 1,
        params.limit || 20,
        params.status || 'all',
        params.verificationStatus || 'all',
        params.specialization || 'all',
        params.search || 'none',
        params.sortBy || 'createdAt',
        params.sortOrder || 'desc'
      );

      const cached = await cacheService.get(key);
      if (cached) {
        logger.debug('从缓存获取营养师列表', { key });
      }
      return cached;
    } catch (error) {
      logger.error('获取缓存营养师列表失败:', error);
      return null;
    }
  }

  /**
   * 缓存营养师详情
   */
  async cacheNutritionistDetail(nutritionistId, data) {
    try {
      const key = this.generateKey('detail', nutritionistId);
      await cacheService.set(key, data, this.detailTTL);
      logger.debug('营养师详情已缓存', { nutritionistId, key, ttl: this.detailTTL });
      return true;
    } catch (error) {
      logger.error('缓存营养师详情失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存的营养师详情
   */
  async getCachedNutritionistDetail(nutritionistId) {
    try {
      const key = this.generateKey('detail', nutritionistId);
      const cached = await cacheService.get(key);
      if (cached) {
        logger.debug('从缓存获取营养师详情', { nutritionistId, key });
      }
      return cached;
    } catch (error) {
      logger.error('获取缓存营养师详情失败:', error);
      return null;
    }
  }

  /**
   * 缓存管理概览统计
   */
  async cacheManagementOverview(data) {
    try {
      const key = this.generateKey('overview');
      await cacheService.set(key, data, this.statsTTL);
      logger.debug('管理概览已缓存', { key, ttl: this.statsTTL });
      return true;
    } catch (error) {
      logger.error('缓存管理概览失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存的管理概览统计
   */
  async getCachedManagementOverview() {
    try {
      const key = this.generateKey('overview');
      const cached = await cacheService.get(key);
      if (cached) {
        logger.debug('从缓存获取管理概览', { key });
      }
      return cached;
    } catch (error) {
      logger.error('获取缓存管理概览失败:', error);
      return null;
    }
  }

  /**
   * 缓存搜索结果
   */
  async cacheSearchResults(query, limit, data) {
    try {
      const key = this.generateKey('search', query, limit || 10);
      await cacheService.set(key, data, this.listTTL);
      logger.debug('搜索结果已缓存', { query, key, ttl: this.listTTL });
      return true;
    } catch (error) {
      logger.error('缓存搜索结果失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存的搜索结果
   */
  async getCachedSearchResults(query, limit) {
    try {
      const key = this.generateKey('search', query, limit || 10);
      const cached = await cacheService.get(key);
      if (cached) {
        logger.debug('从缓存获取搜索结果', { query, key });
      }
      return cached;
    } catch (error) {
      logger.error('获取缓存搜索结果失败:', error);
      return null;
    }
  }

  /**
   * 缓存在线状态统计
   */
  async cacheOnlineStats(data) {
    try {
      const key = this.generateKey('online_stats');
      await cacheService.set(key, data, 30); // 30秒短缓存，保证实时性
      logger.debug('在线状态统计已缓存', { key, ttl: 30 });
      return true;
    } catch (error) {
      logger.error('缓存在线状态统计失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存的在线状态统计
   */
  async getCachedOnlineStats() {
    try {
      const key = this.generateKey('online_stats');
      const cached = await cacheService.get(key);
      if (cached) {
        logger.debug('从缓存获取在线状态统计', { key });
      }
      return cached;
    } catch (error) {
      logger.error('获取缓存在线状态统计失败:', error);
      return null;
    }
  }

  /**
   * 清除特定营养师的缓存
   */
  async invalidateNutritionistCache(nutritionistId) {
    try {
      // 清除详情缓存
      const detailKey = this.generateKey('detail', nutritionistId);
      await cacheService.del(detailKey);

      // 清除列表缓存（因为包含该营养师的所有列表都需要更新）
      await this.invalidateListCache();

      // 清除概览缓存
      await this.invalidateOverviewCache();

      logger.info('已清除营养师缓存', { nutritionistId });
      return true;
    } catch (error) {
      logger.error('清除营养师缓存失败:', error);
      return false;
    }
  }

  /**
   * 清除列表缓存
   */
  async invalidateListCache() {
    try {
      const pattern = this.generateKey('list', '*');
      await cacheService.delPattern(pattern);
      logger.debug('已清除营养师列表缓存');
      return true;
    } catch (error) {
      logger.error('清除营养师列表缓存失败:', error);
      return false;
    }
  }

  /**
   * 清除概览缓存
   */
  async invalidateOverviewCache() {
    try {
      const key = this.generateKey('overview');
      await cacheService.del(key);
      logger.debug('已清除管理概览缓存');
      return true;
    } catch (error) {
      logger.error('清除管理概览缓存失败:', error);
      return false;
    }
  }

  /**
   * 清除搜索缓存
   */
  async invalidateSearchCache() {
    try {
      const pattern = this.generateKey('search', '*');
      await cacheService.delPattern(pattern);
      logger.debug('已清除搜索缓存');
      return true;
    } catch (error) {
      logger.error('清除搜索缓存失败:', error);
      return false;
    }
  }

  /**
   * 清除所有营养师管理相关的缓存
   */
  async invalidateAllCache() {
    try {
      const pattern = `${this.cacheKeyPrefix}:*`;
      await cacheService.delPattern(pattern);
      logger.info('已清除所有营养师管理缓存');
      return true;
    } catch (error) {
      logger.error('清除所有营养师管理缓存失败:', error);
      return false;
    }
  }

  /**
   * 预热缓存 - 在系统启动或低峰期预先加载常用数据
   */
  async warmupCache() {
    try {
      logger.info('开始预热营养师管理缓存...');
      
      // 这里可以预加载一些常用的查询
      // 比如第一页的营养师列表、统计概览等
      // 具体实现需要调用相应的控制器方法
      
      logger.info('营养师管理缓存预热完成');
      return true;
    } catch (error) {
      logger.error('营养师管理缓存预热失败:', error);
      return false;
    }
  }

  /**
   * 获取缓存统计信息
   */
  async getCacheStats() {
    try {
      if (!cacheService.isConnected()) {
        return { status: 'disconnected', message: '缓存服务未连接' };
      }

      // 这里可以扩展获取具体的缓存统计信息
      return {
        status: 'connected',
        prefix: this.cacheKeyPrefix,
        ttl: {
          list: this.listTTL,
          detail: this.detailTTL,
          stats: this.statsTTL,
          default: this.defaultTTL
        }
      };
    } catch (error) {
      logger.error('获取缓存统计信息失败:', error);
      return { status: 'error', message: error.message };
    }
  }
}

module.exports = new NutritionistManagementCacheService();