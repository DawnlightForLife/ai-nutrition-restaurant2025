const UserFavorite = require('../../models/nutrition/userFavoriteModel');

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
      return {
        success: true,
        message: '收藏成功',
        data: favorite
      };
    } catch (error) {
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
      return {
        success: true,
        status: result.status,
        message: result.message,
        data: result.favorite
      };
    } catch (error) {
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
      return {
        success: false,
        message: '获取热门收藏失败：' + error.message
      };
    }
  }
};

module.exports = userFavoriteService;