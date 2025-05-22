/****
 * 论坛帖子服务模块（forumPostService）
 * 提供论坛帖子的管理功能，包括获取、创建、编辑和删除
 * 支持分页、分类筛选、作者信息填充、浏览量统计等功能
 * 所有操作均通过 Mongoose 的 ForumPost 模型完成
 * 与 forumCommentService、userService 配合使用构建完整论坛系统
 * @module services/forum/forumPostService
 */
const ForumPost = require('../../models/forum/forumPostModel');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 论坛帖子服务对象
 */
const forumPostService = {
  /**
   * 获取论坛帖子列表
   * @async
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 帖子列表
   */
  async getForumPosts(options = {}) {
    try {
      const { category, page = 1, limit = 20, sort = '-createdAt' } = options;
      const query = {};
      
      if (category) {
        query.category = category;
      }
      
      const posts = await ForumPost.find(query)
        .sort(sort)
        .skip((page - 1) * limit)
        .limit(limit)
        .populate('authorId', 'username avatar');
        
      return posts;
    } catch (error) {
      logger.error('获取论坛帖子列表失败', { options, error });
      throw new Error('获取论坛帖子列表失败');
    }
  },
  
  /**
   * 获取帖子详情
   * @async
   * @param {string} postId - 帖子ID
   * @returns {Promise<Object>} 帖子详情
   */
  async getForumPostById(postId) {
    try {
      const post = await ForumPost.findById(postId)
        .populate('authorId', 'username avatar');
        
      if (!post) {
        return null;
      }
      
      // 增加浏览次数
      post.viewCount += 1;
      await post.save();
      
      return post;
    } catch (error) {
      logger.error('获取帖子详情失败', { postId, error });
      throw new Error('获取帖子详情失败');
    }
  },
  
  /**
   * 创建新帖子
   * @async
   * @param {Object} postData - 帖子数据
   * @returns {Promise<Object>} 创建的帖子
   */
  async createForumPost(postData) {
    try {
      const newPost = new ForumPost({
        ...postData,
        createdAt: new Date(),
        updatedAt: new Date()
      });
      
      await newPost.save();
      logger.info(`新帖子已创建`, { postId: newPost._id });
      return newPost;
    } catch (error) {
      logger.error('创建帖子失败', { postData, error });
      throw new Error('创建帖子失败');
    }
  },
  
  /**
   * 更新帖子
   * @async
   * @param {string} postId - 帖子ID
   * @param {string} userId - 用户ID（用于权限验证）
   * @param {Object} postData - 帖子数据
   * @returns {Promise<Object>} 更新后的帖子
   */
  async updateForumPost(postId, userId, postData) {
    try {
      const post = await ForumPost.findOne({ _id: postId, authorId: userId });
      
      if (!post) {
        logger.warn(`未找到要更新的帖子或没有权限`, { postId, userId });
        throw new Error('帖子不存在或无权限更新');
      }
      
      Object.keys(postData).forEach(key => {
        if (key !== 'authorId' && key !== '_id' && key !== 'createdAt') {
          post[key] = postData[key];
        }
      });
      
      post.updatedAt = new Date();
      await post.save();
      
      logger.info(`帖子已更新`, { postId });
      return post;
    } catch (error) {
      logger.error('更新帖子失败', { postId, userId, error });
      throw new Error('更新帖子失败');
    }
  },
  
  /**
   * 删除帖子
   * @async
   * @param {string} postId - 帖子ID
   * @param {string} userId - 用户ID（用于权限验证）
   * @returns {Promise<boolean>} 是否成功删除
   */
  async deleteForumPost(postId, userId) {
    try {
      const result = await ForumPost.deleteOne({ _id: postId, authorId: userId });
      
      if (result.deletedCount > 0) {
        logger.info(`帖子已删除`, { postId, userId });
        return true;
      }
      
      logger.warn(`未找到要删除的帖子或没有权限`, { postId, userId });
      return false;
    } catch (error) {
      logger.error('删除帖子失败', { postId, userId, error });
      throw new Error('删除帖子失败');
    }
  }
};

module.exports = forumPostService; 