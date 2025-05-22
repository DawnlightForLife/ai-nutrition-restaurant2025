/**
 * 订单项值对象
 * 表示订单中的单个餐品项目
 */
class OrderItem {
  /**
   * @param {string} mealId - 餐品ID
   * @param {string} name - 餐品名称
   * @param {number} quantity - 数量
   * @param {number} unitPrice - 单价
   * @param {Object} [customizations={}] - 餐品定制选项
   * @param {string} [note=''] - 餐品备注
   */
  constructor(mealId, name, quantity, unitPrice, customizations = {}, note = '') {
    this._validateData(mealId, name, quantity, unitPrice);
    
    this._mealId = mealId;
    this._name = name;
    this._quantity = quantity;
    this._unitPrice = unitPrice;
    this._customizations = { ...customizations };
    this._note = note;
  }

  /**
   * 验证数据
   * @param {string} mealId - 餐品ID
   * @param {string} name - 餐品名称
   * @param {number} quantity - 数量
   * @param {number} unitPrice - 单价
   * @private
   */
  _validateData(mealId, name, quantity, unitPrice) {
    if (!mealId) {
      throw new Error('订单项必须有餐品ID');
    }
    
    if (!name || name.trim() === '') {
      throw new Error('订单项必须有餐品名称');
    }
    
    if (!Number.isInteger(quantity) || quantity <= 0) {
      throw new Error('数量必须是正整数');
    }
    
    if (unitPrice < 0) {
      throw new Error('单价不能为负数');
    }
  }

  // Getters
  get mealId() { return this._mealId; }
  get name() { return this._name; }
  get quantity() { return this._quantity; }
  get unitPrice() { return this._unitPrice; }
  get customizations() { return { ...this._customizations }; }
  get note() { return this._note; }

  /**
   * 计算订单项总价
   * @returns {number} 订单项总价
   */
  getTotalPrice() {
    return this._quantity * this._unitPrice;
  }

  /**
   * 更新数量
   * @param {number} newQuantity - 新数量
   * @returns {OrderItem} 新的订单项
   */
  updateQuantity(newQuantity) {
    if (!Number.isInteger(newQuantity) || newQuantity <= 0) {
      throw new Error('数量必须是正整数');
    }
    
    return new OrderItem(
      this._mealId,
      this._name,
      newQuantity,
      this._unitPrice,
      this._customizations,
      this._note
    );
  }

  /**
   * 更新备注
   * @param {string} newNote - 新备注
   * @returns {OrderItem} 新的订单项
   */
  updateNote(newNote) {
    return new OrderItem(
      this._mealId,
      this._name,
      this._quantity,
      this._unitPrice,
      this._customizations,
      newNote
    );
  }

  /**
   * 将两个相同餐品的订单项合并
   * @param {OrderItem} other - 另一个订单项
   * @returns {OrderItem} 合并后的订单项
   */
  merge(other) {
    if (this._mealId !== other.mealId) {
      throw new Error('只能合并相同餐品的订单项');
    }
    
    return new OrderItem(
      this._mealId,
      this._name,
      this._quantity + other.quantity,
      this._unitPrice,
      this._customizations,
      this._note
    );
  }

  /**
   * 转换为JSON
   * @returns {Object} JSON表示
   */
  toJSON() {
    return {
      mealId: this._mealId,
      name: this._name,
      quantity: this._quantity,
      unitPrice: this._unitPrice,
      customizations: this._customizations,
      note: this._note,
      totalPrice: this.getTotalPrice()
    };
  }

  /**
   * 从JSON创建实例
   * @param {Object} json - JSON数据
   * @returns {OrderItem} 新实例
   */
  static fromJSON(json) {
    return new OrderItem(
      json.mealId,
      json.name,
      json.quantity,
      json.unitPrice,
      json.customizations,
      json.note
    );
  }
}

module.exports = OrderItem; 