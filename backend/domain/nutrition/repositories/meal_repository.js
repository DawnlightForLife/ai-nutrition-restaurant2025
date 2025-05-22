const Repository = require('../../common/interfaces/repository');

/**
 * 餐品仓储接口
 * 定义餐品实体的持久化操作
 */
class MealRepository extends Repository {
  /**
   * 根据分类ID查找餐品
   * @param {string} categoryId - 分类ID
   * @returns {Promise<Array>} 餐品列表
   */
  async findByCategoryId(categoryId) {
    throw new Error('方法未实现');
  }

  /**
   * 查找特色餐品
   * @param {number} limit - 返回结果数量限制
   * @returns {Promise<Array>} 特色餐品列表
   */
  async findFeatured(limit = 10) {
    throw new Error('方法未实现');
  }

  /**
   * 查找推荐餐品
   * @param {number} limit - 返回结果数量限制
   * @returns {Promise<Array>} 推荐餐品列表
   */
  async findRecommended(limit = 10) {
    throw new Error('方法未实现');
  }

  /**
   * 根据营养指标查找餐品
   * @param {Object} criteria - 营养筛选条件
   * @param {number} criteria.minCalories - 最小卡路里
   * @param {number} criteria.maxCalories - 最大卡路里
   * @param {number} criteria.minProtein - 最小蛋白质
   * @param {number} criteria.maxProtein - 最大蛋白质
   * @param {number} criteria.minCarbs - 最小碳水化合物
   * @param {number} criteria.maxCarbs - 最大碳水化合物
   * @param {number} criteria.minFat - 最小脂肪
   * @param {number} criteria.maxFat - 最大脂肪
   * @returns {Promise<Array>} 符合条件的餐品列表
   */
  async findByNutritionCriteria(criteria) {
    throw new Error('方法未实现');
  }

  /**
   * 根据标签查找餐品
   * @param {Array<string>} tags - 标签列表
   * @returns {Promise<Array>} 餐品列表
   */
  async findByTags(tags) {
    throw new Error('方法未实现');
  }

  /**
   * 搜索餐品
   * @param {string} keyword - 搜索关键词
   * @returns {Promise<Array>} 餐品列表
   */
  async search(keyword) {
    throw new Error('方法未实现');
  }
}

module.exports = MealRepository; 