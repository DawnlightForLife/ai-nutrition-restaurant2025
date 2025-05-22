/**
 * 论坛评论服务模块（forumCommentService）
 * 提供论坛帖子下的评论管理功能，包括新增、获取、修改、删除评论等
 * 支持分页、权限验证、作者信息关联、编辑状态追踪等机制
 * 依赖 ForumComment 模型，并通过 populate 支持作者信息嵌套查询
 * @module services/forum/forumCommentService
 */
const ForumComment = require('../../models/forum/forumCommentModel');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 论坛评论服务对象
 */
const forumCommentService = {
  /**
   * 获取帖子评论列表
   * @async
   * @param {string} postId - 帖子ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 评论列表
   */
  async getCommentsByPostId(postId, options = {}) {
    try {
      const { page = 1, limit = 50, sort = 'createdAt' } = options;
      
      const comments = await ForumComment.find({ postId })
        .sort(sort)
        .skip((page - 1) * limit)
        .limit(limit)
        .populate('authorId', 'username avatar');
        
      return comments;
    } catch (error) {
      logger.error('获取帖子评论列表失败', { postId, options, error });
      throw new Error('获取评论列表失败');
    }
  },
  
  /**
   * 添加评论
   * @async
   * @param {Object} commentData - 评论数据
   * @returns {Promise<Object>} 创建的评论
   */
  async addComment(commentData) {
    try {
      const newComment = new ForumComment({
        ...commentData,
        createdAt: new Date()
      });
      
      await newComment.save();
      logger.info(`新评论已添加`, { commentId: newComment._id, postId: commentData.postId });
      return newComment;
    } catch (error) {
      logger.error('添加评论失败', { commentData, error });
      throw new Error('添加评论失败');
    }
  },
  
  /**
   * 删除评论
   * @async
   * @param {string} commentId - 评论ID
   * @param {string} userId - 用户ID（用于权限验证）
   * @returns {Promise<boolean>} 是否成功删除
   */
  async deleteComment(commentId, userId) {
    try {
      const result = await ForumComment.deleteOne({ _id: commentId, authorId: userId });
      
      if (result.deletedCount > 0) {
        logger.info(`评论已删除`, { commentId, userId });
        return true;
      }
      
      logger.warn(`未找到要删除的评论或没有权限`, { commentId, userId });
      return false;
    } catch (error) {
      logger.error('删除评论失败', { commentId, userId, error });
      throw new Error('删除评论失败');
    }
  },
  
  /**
   * 更新评论
   * @async
   * @param {string} commentId - 评论ID
   * @param {string} userId - 用户ID（用于权限验证）
   * @param {Object} commentData - 评论数据
   * @returns {Promise<Object>} 更新后的评论
   */
  async updateComment(commentId, userId, commentData) {
    try {
      const comment = await ForumComment.findOne({ _id: commentId, authorId: userId });
      
      if (!comment) {
        logger.warn(`未找到要更新的评论或没有权限`, { commentId, userId });
        throw new Error('评论不存在或无权限更新');
      }
      
      if (commentData.content) {
        comment.content = commentData.content;
      }
      
      comment.updatedAt = new Date();
      comment.isEdited = true;
      
      await comment.save();
      logger.info(`评论已更新`, { commentId });
      return comment;
    } catch (error) {
      logger.error('更新评论失败', { commentId, userId, error });
      throw new Error('更新评论失败');
    }
  },
  
  /**
   * 获取用户的所有评论
   * @async
   * @param {string} userId - 用户ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 评论列表
   */
  async getUserComments(userId, options = {}) {
    try {
      const { page = 1, limit = 20, sort = '-createdAt' } = options;
      
      const comments = await ForumComment.find({ authorId: userId })
        .sort(sort)
        .skip((page - 1) * limit)
        .limit(limit)
        .populate('postId', 'title');
        
      return comments;
    } catch (error) {
      logger.error('获取用户评论列表失败', { userId, options, error });
      throw new Error('获取用户评论列表失败');
    }
  }
};

module.exports = forumCommentService; 