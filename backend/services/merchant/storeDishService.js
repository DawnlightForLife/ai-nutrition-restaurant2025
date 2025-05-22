/**
 * 店铺菜品服务模块（storeDishService）
 * 用于处理店铺与菜品之间的关系管理，例如门店上架菜品、库存管理、上下架状态等
 * 支持按店铺获取菜单、绑定菜品到店铺、移除菜品、批量状态控制等功能
 * 当前为结构占位，后续由商家端菜单模块调用
 * @module services/merchant/storeDishService
 */

const StoreDish = require('../../models/merchant/storeDishModel');

const storeDishService = {
  /**
   * 获取指定店铺的全部菜品
   * @param {String} storeId
   * @returns {Promise<Array>}
   */
  async getDishesByStore(storeId) {
    // TODO: 查询 storeId 下所有绑定的菜品
    return [];
  },

  /**
   * 将菜品绑定到店铺
   * @param {String} storeId
   * @param {String} dishId
   * @returns {Promise<void>}
   */
  async bindDishToStore(storeId, dishId) {
    // TODO: 将 dishId 添加到 store 的菜单中
  },

  /**
   * 从店铺移除菜品
   * @param {String} storeId
   * @param {String} dishId
   * @returns {Promise<void>}
   */
  async removeDishFromStore(storeId, dishId) {
    // TODO: 从菜单中移除
  },

  /**
   * 更新菜品上下架状态
   * @param {String} storeId
   * @param {String} dishId
   * @param {Boolean} isAvailable
   * @returns {Promise<void>}
   */
  async updateDishAvailability(storeId, dishId, isAvailable) {
    // TODO: 上下架控制
  }
};

module.exports = storeDishService;