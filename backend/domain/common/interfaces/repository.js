/**
 * 仓储接口
 * 定义领域对象的持久化操作
 */
class Repository {
  /**
   * 保存实体
   * @param {*} entity - 要保存的实体
   * @returns {Promise<*>} 保存后的实体
   */
  async save(entity) {
    throw new Error('方法未实现');
  }

  /**
   * 根据ID查找实体
   * @param {string} id - 实体ID
   * @returns {Promise<*>} 找到的实体，如果不存在则返回null
   */
  async findById(id) {
    throw new Error('方法未实现');
  }

  /**
   * 删除实体
   * @param {string} id - 要删除的实体ID
   * @returns {Promise<boolean>} 是否成功删除
   */
  async delete(id) {
    throw new Error('方法未实现');
  }

  /**
   * 查找所有实体
   * @returns {Promise<Array>} 实体列表
   */
  async findAll() {
    throw new Error('方法未实现');
  }
}

module.exports = Repository; 