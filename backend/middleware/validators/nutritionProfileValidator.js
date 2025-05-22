/**
 * 营养档案数据验证器
 * 提供营养档案相关数据的验证规则
 */
const Joi = require('joi');

module.exports = {
  /**
   * 创建营养档案验证
   */
  createProfileSchema: Joi.object({
    // TODO: 添加验证规则
  }),

  /**
   * 更新营养档案验证
   */
  updateProfileSchema: Joi.object({
    // TODO: 添加验证规则
  })
};