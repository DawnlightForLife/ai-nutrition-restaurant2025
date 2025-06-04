/**
 * 餐厅分店领域实体
 * @module domain/restaurant/branch
 */

class Branch {
  constructor({
    id,
    restaurantId,
    name,
    code,
    address,
    location,
    contactInfo,
    businessHours,
    manager,
    staffCount,
    seatingCapacity,
    status,
    openingDate,
    features,
    images,
    parkingInfo,
    transportInfo,
    createdAt,
    updatedAt
  }) {
    // 基本信息
    this.id = id;
    this.restaurantId = restaurantId;
    this.name = name;
    this.code = code; // 分店编号
    
    // 位置信息
    this.address = address || {
      province: null,
      city: null,
      district: null,
      street: null,
      detail: null,
      postalCode: null
    };
    
    this.location = location || {
      type: 'Point',
      coordinates: [0, 0] // [longitude, latitude]
    };
    
    // 联系信息
    this.contactInfo = contactInfo || {
      phone: null,
      email: null,
      fax: null
    };
    
    // 营业时间
    this.businessHours = businessHours || {
      monday: { open: '09:00', close: '22:00', isOpen: true },
      tuesday: { open: '09:00', close: '22:00', isOpen: true },
      wednesday: { open: '09:00', close: '22:00', isOpen: true },
      thursday: { open: '09:00', close: '22:00', isOpen: true },
      friday: { open: '09:00', close: '22:00', isOpen: true },
      saturday: { open: '09:00', close: '22:00', isOpen: true },
      sunday: { open: '09:00', close: '22:00', isOpen: true },
      holidays: [] // 特殊营业时间
    };
    
    // 管理信息
    this.manager = manager || {
      name: null,
      phone: null,
      email: null
    };
    
    this.staffCount = staffCount || 0;
    this.seatingCapacity = seatingCapacity || 0;
    
    // 状态信息
    this.status = status || 'active'; // 'active' | 'inactive' | 'renovating' | 'closed'
    this.openingDate = openingDate;
    
    // 设施信息
    this.features = features || []; // 与餐厅主体相同
    this.images = images || [];
    
    // 交通信息
    this.parkingInfo = parkingInfo || {
      available: false,
      type: null, // 'free' | 'paid' | 'valet'
      spaces: 0,
      fee: null
    };
    
    this.transportInfo = transportInfo || {
      metro: [],
      bus: [],
      landmark: null
    };
    
    // 时间戳
    this.createdAt = createdAt || new Date();
    this.updatedAt = updatedAt || new Date();
  }
  
  // 检查当前是否营业
  isOpenNow() {
    if (this.status !== 'active') return false;
    
    const now = new Date();
    const dayOfWeek = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][now.getDay()];
    const currentTime = now.toTimeString().slice(0, 5); // HH:mm
    
    const todayHours = this.businessHours[dayOfWeek];
    if (!todayHours.isOpen) return false;
    
    return currentTime >= todayHours.open && currentTime <= todayHours.close;
  }
  
  // 获取今日营业时间
  getTodayBusinessHours() {
    const now = new Date();
    const dayOfWeek = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][now.getDay()];
    return this.businessHours[dayOfWeek];
  }
  
  // 更新分店信息
  update(updateData) {
    const allowedFields = [
      'name', 'address', 'location', 'contactInfo',
      'businessHours', 'manager', 'staffCount', 'seatingCapacity',
      'features', 'images', 'parkingInfo', 'transportInfo'
    ];
    
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        this[field] = updateData[field];
      }
    });
    
    this.updatedAt = new Date();
  }
  
  // 更新状态
  updateStatus(newStatus) {
    const validStatuses = ['active', 'inactive', 'renovating', 'closed'];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Invalid branch status: ${newStatus}`);
    }
    this.status = newStatus;
    this.updatedAt = new Date();
  }
  
  // 计算距离（米）
  calculateDistance(longitude, latitude) {
    const [lon2, lat2] = this.location.coordinates;
    const R = 6371000; // 地球半径（米）
    const φ1 = lat2 * Math.PI / 180;
    const φ2 = latitude * Math.PI / 180;
    const Δφ = (latitude - lat2) * Math.PI / 180;
    const Δλ = (longitude - lon2) * Math.PI / 180;
    
    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    
    return R * c;
  }
  
  // 转换为普通对象
  toObject() {
    return {
      id: this.id,
      restaurantId: this.restaurantId,
      name: this.name,
      code: this.code,
      address: this.address,
      location: this.location,
      contactInfo: this.contactInfo,
      businessHours: this.businessHours,
      manager: this.manager,
      staffCount: this.staffCount,
      seatingCapacity: this.seatingCapacity,
      status: this.status,
      openingDate: this.openingDate,
      features: this.features,
      images: this.images,
      parkingInfo: this.parkingInfo,
      transportInfo: this.transportInfo,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      isOpenNow: this.isOpenNow()
    };
  }
  
  // 转换为公开信息
  toPublicObject() {
    const publicData = this.toObject();
    // 移除管理人员敏感信息
    if (publicData.manager) {
      publicData.manager = {
        name: publicData.manager.name
      };
    }
    return publicData;
  }
}

module.exports = Branch;