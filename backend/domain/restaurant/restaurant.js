/**
 * 餐厅领域实体
 * @module domain/restaurant/restaurant
 */

class Restaurant {
  constructor({
    id,
    name,
    type,
    description,
    logo,
    coverImage,
    businessLicense,
    registrationNumber,
    legalRepresentative,
    establishedDate,
    status,
    verificationStatus,
    verifiedAt,
    contactInfo,
    socialMedia,
    tags,
    features,
    cuisineTypes,
    priceRange,
    serviceTypes,
    paymentMethods,
    createdAt,
    updatedAt
  }) {
    // 基本信息
    this.id = id;
    this.name = name;
    this.type = type; // 'single_store' | 'chain' | 'franchise'
    this.description = description;
    this.logo = logo;
    this.coverImage = coverImage;
    
    // 法律信息
    this.businessLicense = businessLicense;
    this.registrationNumber = registrationNumber;
    this.legalRepresentative = legalRepresentative;
    this.establishedDate = establishedDate;
    
    // 状态信息
    this.status = status || 'active'; // 'active' | 'inactive' | 'suspended'
    this.verificationStatus = verificationStatus || 'pending'; // 'pending' | 'verified' | 'rejected'
    this.verifiedAt = verifiedAt;
    
    // 联系信息
    this.contactInfo = contactInfo || {
      phone: null,
      email: null,
      website: null
    };
    
    // 社交媒体
    this.socialMedia = socialMedia || {
      wechat: null,
      weibo: null,
      douyin: null,
      xiaohongshu: null
    };
    
    // 餐厅特征
    this.tags = tags || [];
    this.features = features || []; // ['wifi', 'parking', 'private_room', 'outdoor_seating']
    this.cuisineTypes = cuisineTypes || []; // ['chinese', 'western', 'japanese', 'korean']
    this.priceRange = priceRange || 'medium'; // 'low' | 'medium' | 'high' | 'luxury'
    this.serviceTypes = serviceTypes || ['dine_in']; // ['dine_in', 'takeout', 'delivery']
    this.paymentMethods = paymentMethods || ['cash']; // ['cash', 'alipay', 'wechat_pay', 'credit_card']
    
    // 时间戳
    this.createdAt = createdAt || new Date();
    this.updatedAt = updatedAt || new Date();
  }
  
  // 验证餐厅是否可运营
  canOperate() {
    return this.status === 'active' && this.verificationStatus === 'verified';
  }
  
  // 更新餐厅信息
  update(updateData) {
    const allowedFields = [
      'name', 'description', 'logo', 'coverImage',
      'contactInfo', 'socialMedia', 'tags', 'features',
      'cuisineTypes', 'priceRange', 'serviceTypes', 'paymentMethods'
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
    const validStatuses = ['active', 'inactive', 'suspended'];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Invalid status: ${newStatus}`);
    }
    this.status = newStatus;
    this.updatedAt = new Date();
  }
  
  // 验证餐厅
  verify() {
    if (this.verificationStatus === 'verified') {
      throw new Error('Restaurant is already verified');
    }
    this.verificationStatus = 'verified';
    this.verifiedAt = new Date();
    this.updatedAt = new Date();
  }
  
  // 拒绝验证
  rejectVerification(reason) {
    this.verificationStatus = 'rejected';
    this.verificationReason = reason;
    this.updatedAt = new Date();
  }
  
  // 转换为普通对象
  toObject() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      description: this.description,
      logo: this.logo,
      coverImage: this.coverImage,
      businessLicense: this.businessLicense,
      registrationNumber: this.registrationNumber,
      legalRepresentative: this.legalRepresentative,
      establishedDate: this.establishedDate,
      status: this.status,
      verificationStatus: this.verificationStatus,
      verifiedAt: this.verifiedAt,
      contactInfo: this.contactInfo,
      socialMedia: this.socialMedia,
      tags: this.tags,
      features: this.features,
      cuisineTypes: this.cuisineTypes,
      priceRange: this.priceRange,
      serviceTypes: this.serviceTypes,
      paymentMethods: this.paymentMethods,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
  
  // 转换为公开信息（隐藏敏感信息）
  toPublicObject() {
    const publicData = this.toObject();
    // 移除敏感信息
    delete publicData.businessLicense;
    delete publicData.registrationNumber;
    delete publicData.legalRepresentative;
    return publicData;
  }
}

module.exports = Restaurant;