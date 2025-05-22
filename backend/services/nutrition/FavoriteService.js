/**
 * 用户收藏服务模块（userFavoriteService）
 * 提供用户对营养推荐、菜品、营养师等内容的收藏、取消、状态查询等功能
 * 支持分页查询、收藏切换、收藏备注与标签功能
 * 与 userFavoriteModel 配合使用，服务于个性化推荐与用户行为分析
 * @module services/nutrition/FavoriteService
 */
const UserFavorite = require('../../models/nutrition/FavoriteModel');
const logger = require('../../utils/logger/winstonLogger.js');

const userFavoriteService = {
  // 添加用户收藏
  async addFavorite(userId, itemType, itemId, options = {}) {
    try {
      const { notes = '', tags = [] } = options;
      
      const favorite = new UserFavorite({
        userId,
        itemType,
        itemId,
        notes,
        tags
      });
      
      await favorite.save();
      logger.info('用户添加收藏成功', { userId, itemType, itemId });
      return {
        success: true,
        message: '收藏成功',
        data: favorite
      };
    } catch (error) {
      logger.error('添加用户收藏失败', { userId, itemType, itemId, error });
      return {
        success: false,
        message: '收藏失败：' + error.message
      };
    }
  },
  
  // 移除用户收藏
  async removeFavorite(userId, itemType, itemId) {
    try {
      const result = await UserFavorite.deleteOne({
        userId,
        itemType,
        itemId
      });
      
      if (result.deletedCount > 0) {
        logger.info('用户取消收藏成功', { userId, itemType, itemId });
        return {
          success: true,
          message: '取消收藏成功'
        };
      } else {
        return {
          success: false,
          message: '未找到指定收藏记录'
        };
      }
    } catch (error) {
      logger.error('取消用户收藏失败', { userId, itemType, itemId, error });
      return {
        success: false,
        message: '取消收藏失败：' + error.message
      };
    }
  },
  
  // 切换收藏状态
  async toggleFavorite(userId, itemType, itemId, options = {}) {
    try {
      const result = await UserFavorite.toggleFavorite(userId, itemType, itemId, options);
      logger.info('切换收藏状态', { userId, itemType, itemId, result });
      return {
        success: true,
        status: result.status,
        message: result.message,
        data: result.favorite
      };
    } catch (error) {
      logger.error('切换收藏状态失败', { userId, itemType, itemId, error });
      return {
        success: false,
        message: '操作收藏失败：' + error.message
      };
    }
  },
  
  // 获取用户收藏列表
  async getUserFavorites(userId, options = {}) {
    try {
      const result = await UserFavorite.getUserFavorites(userId, options);
      return {
        success: true,
        data: result.favorites,
        pagination: result.pagination
      };
    } catch (error) {
      logger.error('获取用户收藏列表失败', { userId, options, error });
      return {
        success: false,
        message: '获取收藏列表失败：' + error.message
      };
    }
  },
  
  // 检查是否已收藏
  async checkFavorite(userId, itemType, itemId) {
    try {
      const isFavorited = await UserFavorite.isFavorited(userId, itemType, itemId);
      return {
        success: true,
        isFavorited
      };
    } catch (error) {
      logger.error('检查收藏状态失败', { userId, itemType, itemId, error });
      return {
        success: false,
        message: '检查收藏状态失败：' + error.message
      };
    }
  },
  
  // 获取热门收藏
  async getPopularFavorites(options = {}) {
    try {
      const results = await UserFavorite.getMostFavorited(options);
      return {
        success: true,
        data: results
      };
    } catch (error) {
      logger.error('获取热门收藏失败', { options, error });
      return {
        success: false,
        message: '获取热门收藏失败：' + error.message
      };
    }
  }
};

module.exports = userFavoriteService;