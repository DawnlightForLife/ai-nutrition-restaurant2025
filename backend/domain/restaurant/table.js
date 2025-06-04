/**
 * 餐桌领域实体
 * @module domain/restaurant/table
 */

class Table {
  constructor({
    id,
    branchId,
    tableNumber,
    qrCode,
    area,
    capacity,
    minCapacity,
    tableType,
    shape,
    status,
    currentOrderId,
    features,
    position,
    isActive,
    maintenanceInfo,
    createdAt,
    updatedAt
  }) {
    // 基本信息
    this.id = id;
    this.branchId = branchId;
    this.tableNumber = tableNumber; // 桌号，如 "A01", "B12"
    this.qrCode = qrCode; // 扫码点餐二维码
    
    // 区域信息
    this.area = area || 'main'; // 'main' | 'vip' | 'outdoor' | 'private'
    
    // 容量信息
    this.capacity = capacity || 4; // 标准容纳人数
    this.minCapacity = minCapacity || 1; // 最少人数
    
    // 桌台类型
    this.tableType = tableType || 'regular'; // 'regular' | 'booth' | 'bar' | 'high_table'
    this.shape = shape || 'square'; // 'square' | 'round' | 'rectangular'
    
    // 状态信息
    this.status = status || 'available'; // 'available' | 'occupied' | 'reserved' | 'cleaning' | 'maintenance'
    this.currentOrderId = currentOrderId; // 当前订单ID
    
    // 特性
    this.features = features || []; // ['window_seat', 'wheelchair_accessible', 'baby_chair', 'power_outlet']
    
    // 位置信息（用于平面图展示）
    this.position = position || {
      x: 0,
      y: 0,
      floor: 1
    };
    
    // 管理信息
    this.isActive = isActive !== false; // 是否启用
    this.maintenanceInfo = maintenanceInfo || {
      lastMaintenance: null,
      nextMaintenance: null,
      notes: null
    };
    
    // 时间戳
    this.createdAt = createdAt || new Date();
    this.updatedAt = updatedAt || new Date();
  }
  
  // 检查是否可用
  isAvailable() {
    return this.isActive && this.status === 'available';
  }
  
  // 占用桌位
  occupy(orderId) {
    if (!this.isAvailable()) {
      throw new Error(`Table ${this.tableNumber} is not available`);
    }
    this.status = 'occupied';
    this.currentOrderId = orderId;
    this.updatedAt = new Date();
  }
  
  // 释放桌位
  release() {
    this.status = 'cleaning';
    this.currentOrderId = null;
    this.updatedAt = new Date();
  }
  
  // 清洁完成
  cleaningComplete() {
    if (this.status !== 'cleaning') {
      throw new Error('Table is not in cleaning status');
    }
    this.status = 'available';
    this.updatedAt = new Date();
  }
  
  // 预订桌位
  reserve(reservationId) {
    if (!this.isAvailable()) {
      throw new Error(`Table ${this.tableNumber} is not available for reservation`);
    }
    this.status = 'reserved';
    this.currentOrderId = reservationId;
    this.updatedAt = new Date();
  }
  
  // 进入维护状态
  startMaintenance(notes) {
    this.status = 'maintenance';
    this.maintenanceInfo.lastMaintenance = new Date();
    if (notes) {
      this.maintenanceInfo.notes = notes;
    }
    this.updatedAt = new Date();
  }
  
  // 维护完成
  completeMaintenance() {
    if (this.status !== 'maintenance') {
      throw new Error('Table is not in maintenance status');
    }
    this.status = 'available';
    this.updatedAt = new Date();
  }
  
  // 更新桌位信息
  update(updateData) {
    const allowedFields = [
      'tableNumber', 'area', 'capacity', 'minCapacity',
      'tableType', 'shape', 'features', 'position'
    ];
    
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        this[field] = updateData[field];
      }
    });
    
    this.updatedAt = new Date();
  }
  
  // 启用/禁用桌位
  setActive(isActive) {
    this.isActive = isActive;
    if (!isActive && this.status === 'occupied') {
      throw new Error('Cannot disable an occupied table');
    }
    this.updatedAt = new Date();
  }
  
  // 生成二维码URL
  generateQRCodeUrl(baseUrl) {
    return `${baseUrl}/scan/table/${this.branchId}/${this.tableNumber}`;
  }
  
  // 转换为普通对象
  toObject() {
    return {
      id: this.id,
      branchId: this.branchId,
      tableNumber: this.tableNumber,
      qrCode: this.qrCode,
      area: this.area,
      capacity: this.capacity,
      minCapacity: this.minCapacity,
      tableType: this.tableType,
      shape: this.shape,
      status: this.status,
      currentOrderId: this.currentOrderId,
      features: this.features,
      position: this.position,
      isActive: this.isActive,
      maintenanceInfo: this.maintenanceInfo,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
  
  // 转换为公开信息（用于客户端）
  toPublicObject() {
    return {
      tableNumber: this.tableNumber,
      area: this.area,
      capacity: this.capacity,
      minCapacity: this.minCapacity,
      tableType: this.tableType,
      features: this.features,
      status: this.status,
      isAvailable: this.isAvailable()
    };
  }
}

module.exports = Table;