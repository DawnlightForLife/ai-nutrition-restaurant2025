/**
 * 订单状态值对象
 * 表示订单的当前状态
 */
class OrderStatus {
  static PENDING = 'PENDING';           // 待处理
  static CONFIRMED = 'CONFIRMED';       // 已确认
  static PREPARING = 'PREPARING';       // 准备中
  static READY = 'READY';               // 已就绪
  static DELIVERED = 'DELIVERED';       // 已配送
  static COMPLETED = 'COMPLETED';       // 已完成
  static CANCELLED = 'CANCELLED';       // 已取消
  static REFUNDED = 'REFUNDED';         // 已退款

  static ALL_STATUSES = [
    OrderStatus.PENDING,
    OrderStatus.CONFIRMED,
    OrderStatus.PREPARING,
    OrderStatus.READY,
    OrderStatus.DELIVERED,
    OrderStatus.COMPLETED,
    OrderStatus.CANCELLED,
    OrderStatus.REFUNDED
  ];

  /**
   * @param {string} value - 订单状态值
   */
  constructor(value) {
    this._validateStatus(value);
    this._value = value;
  }

  /**
   * 验证状态值是否有效
   * @param {string} value - 状态值
   * @private
   */
  _validateStatus(value) {
    if (!OrderStatus.ALL_STATUSES.includes(value)) {
      throw new Error(`无效的订单状态: ${value}`);
    }
  }

  /**
   * 获取状态值
   * @returns {string} 状态值
   */
  get value() {
    return this._value;
  }

  /**
   * 检查是否可以转换到目标状态
   * @param {string} targetStatus - 目标状态
   * @returns {boolean} 是否可以转换
   */
  canTransitionTo(targetStatus) {
    // 已取消或已退款的订单不能再变更状态
    if (this._value === OrderStatus.CANCELLED || this._value === OrderStatus.REFUNDED) {
      return false;
    }

    // 完成的订单只能转为退款状态
    if (this._value === OrderStatus.COMPLETED) {
      return targetStatus === OrderStatus.REFUNDED;
    }

    // 状态通常只能按顺序前进，除非取消或退款
    const currentIndex = OrderStatus.ALL_STATUSES.indexOf(this._value);
    const targetIndex = OrderStatus.ALL_STATUSES.indexOf(targetStatus);
    
    return targetStatus === OrderStatus.CANCELLED 
      || targetStatus === OrderStatus.REFUNDED
      || targetIndex === currentIndex + 1;
  }

  /**
   * equals方法
   * @param {OrderStatus} other - 另一个订单状态值对象
   * @returns {boolean} 是否相等
   */
  equals(other) {
    if (!(other instanceof OrderStatus)) {
      return false;
    }
    return this._value === other.value;
  }

  /**
   * 转换为字符串
   * @returns {string} 字符串表示
   */
  toString() {
    return this._value;
  }
}

module.exports = OrderStatus; 