/**
 * 实体基类
 * 所有领域实体都应继承此类
 */
class Entity {
  /**
   * @param {string} id - 实体的唯一标识符
   */
  constructor(id) {
    if (!id) {
      throw new Error('实体必须有ID');
    }
    this._id = id;
  }

  /**
   * 获取实体ID
   * @returns {string} 实体ID
   */
  get id() {
    return this._id;
  }

  /**
   * 比较两个实体是否相等
   * 实体相等基于ID相等，而非属性相等
   * @param {Entity} entity - 要比较的实体
   * @returns {boolean} 是否相等
   */
  equals(entity) {
    if (!(entity instanceof Entity)) {
      return false;
    }
    return this._id === entity.id;
  }
}

module.exports = Entity; 