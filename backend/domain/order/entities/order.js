const Entity = require('../../common/interfaces/entity');
const ID = require('../../common/value_objects/id');
const OrderItem = require('../value_objects/order_item');
const OrderStatus = require('../value_objects/order_status');

/**
 * 订单实体
 * 代表用户的一次订餐请求
 */
class Order extends Entity {
  /**
   * @param {string} id - 订单ID
   * @param {string} userId - 用户ID
   * @param {string} restaurantId - 餐厅ID
   * @param {Array<OrderItem>} items - 订单项列表
   * @param {OrderStatus} status - 订单状态
   * @param {Date} orderDate - 下单时间
   * @param {Object} deliveryInfo - 配送信息
   * @param {Object} paymentInfo - 支付信息
   * @param {number} subtotal - 小计金额
   * @param {number} tax - 税费
   * @param {number} deliveryFee - 配送费
   * @param {number} discount - 折扣金额
   * @param {string} note - 订单备注
   * @param {Date} updatedAt - 更新时间
   */
  constructor(
    id,
    userId,
    restaurantId,
    items,
    status,
    orderDate,
    deliveryInfo,
    paymentInfo,
    subtotal,
    tax,
    deliveryFee,
    discount = 0,
    note = '',
    updatedAt = new Date()
  ) {
    super(id);
    
    this._userId = userId;
    this._restaurantId = restaurantId;
    this._items = [...items];
    this._status = status;
    this._orderDate = orderDate;
    this._deliveryInfo = { ...deliveryInfo };
    this._paymentInfo = { ...paymentInfo };
    this._subtotal = subtotal;
    this._tax = tax;
    this._deliveryFee = deliveryFee;
    this._discount = discount;
    this._note = note;
    this._updatedAt = updatedAt;
  }

  // Getters
  get userId() { return this._userId; }
  get restaurantId() { return this._restaurantId; }
  get items() { return [...this._items]; }
  get status() { return this._status; }
  get orderDate() { return this._orderDate; }
  get deliveryInfo() { return { ...this._deliveryInfo }; }
  get paymentInfo() { return { ...this._paymentInfo }; }
  get subtotal() { return this._subtotal; }
  get tax() { return this._tax; }
  get deliveryFee() { return this._deliveryFee; }
  get discount() { return this._discount; }
  get note() { return this._note; }
  get updatedAt() { return this._updatedAt; }

  /**
   * 计算订单总金额
   * @returns {number} 订单总金额
   */
  getTotalAmount() {
    return this._subtotal + this._tax + this._deliveryFee - this._discount;
  }

  /**
   * 创建新订单
   * @param {string} userId - 用户ID
   * @param {string} restaurantId - 餐厅ID
   * @param {Array<OrderItem>} items - 订单项列表
   * @param {Object} deliveryInfo - 配送信息
   * @param {Object} paymentInfo - 支付信息
   * @param {number} subtotal - 小计金额
   * @param {number} tax - 税费
   * @param {number} deliveryFee - 配送费
   * @param {number} discount - 折扣金额
   * @param {string} note - 订单备注
   * @returns {Order} 新订单
   */
  static create(
    userId,
    restaurantId,
    items,
    deliveryInfo,
    paymentInfo,
    subtotal,
    tax,
    deliveryFee,
    discount = 0,
    note = ''
  ) {
    const now = new Date();
    return new Order(
      ID.generate().value,
      userId,
      restaurantId,
      items,
      new OrderStatus(OrderStatus.PENDING),
      now,
      deliveryInfo,
      paymentInfo,
      subtotal,
      tax,
      deliveryFee,
      discount,
      note,
      now
    );
  }

  /**
   * 更新订单状态
   * @param {string} newStatus - 新状态
   * @returns {Order} 更新后的订单
   */
  updateStatus(newStatus) {
    if (!this._status.canTransitionTo(newStatus)) {
      throw new Error(`不能从 ${this._status.value} 状态转换到 ${newStatus} 状态`);
    }
    
    return new Order(
      this.id,
      this._userId,
      this._restaurantId,
      this._items,
      new OrderStatus(newStatus),
      this._orderDate,
      this._deliveryInfo,
      this._paymentInfo,
      this._subtotal,
      this._tax,
      this._deliveryFee,
      this._discount,
      this._note,
      new Date()
    );
  }

  /**
   * 添加订单项
   * @param {OrderItem} item - 新的订单项
   * @returns {Order} 更新后的订单
   */
  addItem(item) {
    if (this._status.value !== OrderStatus.PENDING) {
      throw new Error('只能修改待处理状态的订单');
    }
    
    // 检查是否已存在相同商品
    const existingItemIndex = this._items.findIndex(i => i.mealId === item.mealId);
    let newItems;
    
    if (existingItemIndex >= 0) {
      // 合并相同商品
      const mergedItem = this._items[existingItemIndex].merge(item);
      newItems = [
        ...this._items.slice(0, existingItemIndex),
        mergedItem,
        ...this._items.slice(existingItemIndex + 1)
      ];
    } else {
      // 添加新商品
      newItems = [...this._items, item];
    }
    
    // 重新计算小计
    const newSubtotal = newItems.reduce((sum, item) => sum + item.getTotalPrice(), 0);
    
    return new Order(
      this.id,
      this._userId,
      this._restaurantId,
      newItems,
      this._status,
      this._orderDate,
      this._deliveryInfo,
      this._paymentInfo,
      newSubtotal,
      this._tax,
      this._deliveryFee,
      this._discount,
      this._note,
      new Date()
    );
  }

  /**
   * 移除订单项
   * @param {string} mealId - 要移除的餐品ID
   * @returns {Order} 更新后的订单
   */
  removeItem(mealId) {
    if (this._status.value !== OrderStatus.PENDING) {
      throw new Error('只能修改待处理状态的订单');
    }
    
    const newItems = this._items.filter(item => item.mealId !== mealId);
    
    if (newItems.length === this._items.length) {
      throw new Error('订单中不存在该餐品');
    }
    
    // 重新计算小计
    const newSubtotal = newItems.reduce((sum, item) => sum + item.getTotalPrice(), 0);
    
    return new Order(
      this.id,
      this._userId,
      this._restaurantId,
      newItems,
      this._status,
      this._orderDate,
      this._deliveryInfo,
      this._paymentInfo,
      newSubtotal,
      this._tax,
      this._deliveryFee,
      this._discount,
      this._note,
      new Date()
    );
  }

  /**
   * 更新订单备注
   * @param {string} newNote - 新的备注
   * @returns {Order} 更新后的订单
   */
  updateNote(newNote) {
    return new Order(
      this.id,
      this._userId,
      this._restaurantId,
      this._items,
      this._status,
      this._orderDate,
      this._deliveryInfo,
      this._paymentInfo,
      this._subtotal,
      this._tax,
      this._deliveryFee,
      this._discount,
      newNote,
      new Date()
    );
  }

  /**
   * 转换为JSON
   * @returns {Object} JSON表示
   */
  toJSON() {
    return {
      id: this.id,
      userId: this._userId,
      restaurantId: this._restaurantId,
      items: this._items.map(item => item.toJSON()),
      status: this._status.value,
      orderDate: this._orderDate.toISOString(),
      deliveryInfo: this._deliveryInfo,
      paymentInfo: this._paymentInfo,
      subtotal: this._subtotal,
      tax: this._tax,
      deliveryFee: this._deliveryFee,
      discount: this._discount,
      total: this.getTotalAmount(),
      note: this._note,
      updatedAt: this._updatedAt.toISOString()
    };
  }

  /**
   * 从JSON创建实例
   * @param {Object} json - JSON数据
   * @returns {Order} 新实例
   */
  static fromJSON(json) {
    return new Order(
      json.id,
      json.userId,
      json.restaurantId,
      json.items.map(itemJson => OrderItem.fromJSON(itemJson)),
      new OrderStatus(json.status),
      new Date(json.orderDate),
      json.deliveryInfo,
      json.paymentInfo,
      json.subtotal,
      json.tax,
      json.deliveryFee,
      json.discount,
      json.note,
      new Date(json.updatedAt)
    );
  }
}

module.exports = Order; 