const { v4: uuidv4 } = require('uuid');

/**
 * ID值对象
 * 表示领域中的唯一标识符
 */
class ID {
  /**
   * @param {string} value - ID值
   */
  constructor(value) {
    if (!value) {
      throw new Error('ID不能为空');
    }
    this._value = value;
  }

  /**
   * 获取ID值
   * @returns {string} ID值
   */
  get value() {
    return this._value;
  }

  /**
   * 生成新ID
   * @returns {ID} 新的ID实例
   */
  static generate() {
    return new ID(uuidv4());
  }

  /**
   * 比较两个ID是否相等
   * @param {ID} id - 要比较的ID
   * @returns {boolean} 是否相等
   */
  equals(id) {
    if (!(id instanceof ID)) {
      return false;
    }
    return this._value === id.value;
  }

  /**
   * 转换为字符串
   * @returns {string} ID字符串表示
   */
  toString() {
    return this._value;
  }
}

module.exports = ID; 