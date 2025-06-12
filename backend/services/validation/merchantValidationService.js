/**
 * 商家数据验证服务
 * 提供商家注册和更新时的数据验证功能
 * @module services/validation/merchantValidationService
 */

const logger = require('../../utils/logger/winstonLogger');

const merchantValidationService = {
  /**
   * 验证商家注册数据
   * @param {Object} merchantData - 商家数据
   * @returns {Object} 验证结果
   */
  validateMerchantRegistration(merchantData) {
    const errors = [];
    const warnings = [];

    // 1. 基本信息验证
    this.validateBasicInfo(merchantData, errors);

    // 2. 联系信息验证
    this.validateContactInfo(merchantData, errors, warnings);

    // 3. 地址信息验证
    this.validateAddressInfo(merchantData, errors, warnings);

    // 4. 商业信息验证
    this.validateBusinessInfo(merchantData, errors, warnings);

    // 5. 数据完整性检查
    this.validateDataIntegrity(merchantData, warnings);

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
      score: this.calculateCompletionScore(merchantData)
    };
  },

  /**
   * 验证基本信息
   */
  validateBasicInfo(data, errors) {
    // 商家名称验证
    if (!data.businessName || data.businessName.trim().length < 2) {
      errors.push({
        field: 'businessName',
        message: '商家名称至少需要2个字符',
        code: 'INVALID_BUSINESS_NAME'
      });
    } else if (data.businessName.length > 50) {
      errors.push({
        field: 'businessName',
        message: '商家名称不能超过50个字符',
        code: 'BUSINESS_NAME_TOO_LONG'
      });
    }

    // 商家类型验证
    const validBusinessTypes = ['maternityCenter', 'gym', 'school', 'company', 'restaurant', 'other'];
    if (!data.businessType || !validBusinessTypes.includes(data.businessType)) {
      errors.push({
        field: 'businessType',
        message: '请选择有效的商家类型',
        code: 'INVALID_BUSINESS_TYPE'
      });
    }

    // 注册号码验证
    if (!data.registrationNumber) {
      errors.push({
        field: 'registrationNumber',
        message: '营业执照注册号不能为空',
        code: 'MISSING_REGISTRATION_NUMBER'
      });
    } else if (!/^[A-Z0-9]{15,20}$/.test(data.registrationNumber)) {
      errors.push({
        field: 'registrationNumber',
        message: '营业执照注册号格式不正确',
        code: 'INVALID_REGISTRATION_FORMAT'
      });
    }

    // 税务登记号验证
    if (data.taxId && !/^[A-Z0-9]{15,20}$/.test(data.taxId)) {
      errors.push({
        field: 'taxId',
        message: '税务登记号格式不正确',
        code: 'INVALID_TAX_ID_FORMAT'
      });
    }
  },

  /**
   * 验证联系信息
   */
  validateContactInfo(data, errors, warnings) {
    if (!data.contact) {
      errors.push({
        field: 'contact',
        message: '联系信息不能为空',
        code: 'MISSING_CONTACT_INFO'
      });
      return;
    }

    // 邮箱验证
    if (!data.contact.email) {
      errors.push({
        field: 'contact.email',
        message: '邮箱地址不能为空',
        code: 'MISSING_EMAIL'
      });
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.contact.email)) {
      errors.push({
        field: 'contact.email',
        message: '邮箱地址格式不正确',
        code: 'INVALID_EMAIL_FORMAT'
      });
    }

    // 手机号验证
    if (!data.contact.phone) {
      errors.push({
        field: 'contact.phone',
        message: '手机号码不能为空',
        code: 'MISSING_PHONE'
      });
    } else if (!/^1[3-9]\d{9}$/.test(data.contact.phone)) {
      errors.push({
        field: 'contact.phone',
        message: '手机号码格式不正确',
        code: 'INVALID_PHONE_FORMAT'
      });
    }

    // 备用电话验证（可选）
    if (data.contact.alternatePhone && !/^1[3-9]\d{9}$/.test(data.contact.alternatePhone)) {
      warnings.push({
        field: 'contact.alternatePhone',
        message: '备用电话格式不正确',
        code: 'INVALID_ALTERNATE_PHONE'
      });
    }

    // 网站地址验证（可选）
    if (data.contact.website) {
      try {
        new URL(data.contact.website);
      } catch {
        warnings.push({
          field: 'contact.website',
          message: '网站地址格式不正确',
          code: 'INVALID_WEBSITE_URL'
        });
      }
    }
  },

  /**
   * 验证地址信息
   */
  validateAddressInfo(data, errors, warnings) {
    if (!data.address) {
      errors.push({
        field: 'address',
        message: '地址信息不能为空',
        code: 'MISSING_ADDRESS_INFO'
      });
      return;
    }

    // 详细地址验证
    if (!data.address.line1 || data.address.line1.trim().length < 5) {
      errors.push({
        field: 'address.line1',
        message: '详细地址至少需要5个字符',
        code: 'INVALID_ADDRESS_LINE1'
      });
    }

    // 城市验证
    if (!data.address.city) {
      errors.push({
        field: 'address.city',
        message: '城市不能为空',
        code: 'MISSING_CITY'
      });
    }

    // 省份验证（优先使用province字段）
    const province = data.address.province || data.address.state;
    if (!province) {
      errors.push({
        field: 'address.province',
        message: '省份不能为空',
        code: 'MISSING_PROVINCE'
      });
    }

    // 邮政编码验证
    if (!data.address.postalCode) {
      errors.push({
        field: 'address.postalCode',
        message: '邮政编码不能为空',
        code: 'MISSING_POSTAL_CODE'
      });
    } else if (!/^\d{6}$/.test(data.address.postalCode)) {
      errors.push({
        field: 'address.postalCode',
        message: '邮政编码格式不正确（应为6位数字）',
        code: 'INVALID_POSTAL_CODE'
      });
    }

    // 区县建议
    if (!data.address.district) {
      warnings.push({
        field: 'address.district',
        message: '建议填写区县信息以提高定位精度',
        code: 'MISSING_DISTRICT_SUGGESTION'
      });
    }

    // 坐标验证（可选）
    if (data.address.coordinates) {
      const { latitude, longitude } = data.address.coordinates;
      if (latitude && (latitude < -90 || latitude > 90)) {
        warnings.push({
          field: 'address.coordinates.latitude',
          message: '纬度值应在-90到90之间',
          code: 'INVALID_LATITUDE'
        });
      }
      if (longitude && (longitude < -180 || longitude > 180)) {
        warnings.push({
          field: 'address.coordinates.longitude',
          message: '经度值应在-180到180之间',
          code: 'INVALID_LONGITUDE'
        });
      }
    }
  },

  /**
   * 验证商业信息
   */
  validateBusinessInfo(data, errors, warnings) {
    if (!data.businessProfile) {
      warnings.push({
        field: 'businessProfile',
        message: '建议填写商业信息以提高通过率',
        code: 'MISSING_BUSINESS_PROFILE'
      });
      return;
    }

    // 商家简介验证
    if (!data.businessProfile.description) {
      warnings.push({
        field: 'businessProfile.description',
        message: '建议添加商家简介',
        code: 'MISSING_DESCRIPTION'
      });
    } else if (data.businessProfile.description.length < 10) {
      warnings.push({
        field: 'businessProfile.description',
        message: '商家简介建议至少10个字符',
        code: 'DESCRIPTION_TOO_SHORT'
      });
    } else if (data.businessProfile.description.length > 500) {
      errors.push({
        field: 'businessProfile.description',
        message: '商家简介不能超过500个字符',
        code: 'DESCRIPTION_TOO_LONG'
      });
    }

    // 加盟信息验证
    if (data.businessProfile.isFranchise && data.businessProfile.franchiseInfo) {
      const franchiseInfo = data.businessProfile.franchiseInfo;
      
      if (!franchiseInfo.franchiseLevel) {
        warnings.push({
          field: 'businessProfile.franchiseInfo.franchiseLevel',
          message: '建议选择加盟级别',
          code: 'MISSING_FRANCHISE_LEVEL'
        });
      }

      if (franchiseInfo.contractNumber && franchiseInfo.contractNumber.length < 5) {
        warnings.push({
          field: 'businessProfile.franchiseInfo.contractNumber',
          message: '合同编号过短',
          code: 'INVALID_CONTRACT_NUMBER'
        });
      }
    }
  },

  /**
   * 验证数据完整性
   */
  validateDataIntegrity(data, warnings) {
    // 营养相关信息完整性
    if (data.businessType === 'restaurant' || data.businessType === 'maternityCenter') {
      if (!data.nutritionFeatures || !data.nutritionFeatures.hasNutritionist) {
        warnings.push({
          field: 'nutritionFeatures',
          message: '建议配置营养师信息以提供更好的服务',
          code: 'MISSING_NUTRITION_FEATURES'
        });
      }
    }

    // 设置信息完整性
    if (!data.merchantSettings) {
      warnings.push({
        field: 'merchantSettings',
        message: '建议配置商家设置信息',
        code: 'MISSING_MERCHANT_SETTINGS'
      });
    }

    // 支付设置检查
    if (!data.paymentSettings) {
      warnings.push({
        field: 'paymentSettings',
        message: '建议配置支付方式以支持在线交易',
        code: 'MISSING_PAYMENT_SETTINGS'
      });
    }
  },

  /**
   * 计算数据完整性评分
   */
  calculateCompletionScore(data) {
    let score = 0;
    const maxScore = 100;

    // 基本信息权重 40%
    if (data.businessName) score += 10;
    if (data.businessType) score += 10;
    if (data.registrationNumber) score += 10;
    if (data.taxId) score += 10;

    // 联系信息权重 30%
    if (data.contact?.email) score += 10;
    if (data.contact?.phone) score += 10;
    if (data.contact?.website) score += 5;
    if (data.contact?.alternatePhone) score += 5;

    // 地址信息权重 20%
    if (data.address?.line1) score += 5;
    if (data.address?.city) score += 5;
    if (data.address?.province || data.address?.state) score += 5;
    if (data.address?.district) score += 3;
    if (data.address?.postalCode) score += 2;

    // 商业信息权重 10%
    if (data.businessProfile?.description) score += 5;
    if (data.nutritionFeatures) score += 2;
    if (data.merchantSettings) score += 2;
    if (data.paymentSettings) score += 1;

    return Math.min(score, maxScore);
  },

  /**
   * 验证地址格式转换
   */
  validateAndConvertAddress(addressData) {
    const converted = { ...addressData };

    // 如果有state字段但没有province字段，将state映射到province
    if (converted.state && !converted.province) {
      converted.province = converted.state;
    }

    // 确保向后兼容
    if (converted.province && !converted.state) {
      converted.state = converted.province;
    }

    return converted;
  },

  /**
   * 异步验证商家名称唯一性
   */
  async validateBusinessNameUniqueness(businessName, excludeMerchantId = null) {
    try {
      const Merchant = require('../../models/merchant/merchantModel');
      
      const query = { businessName: new RegExp(`^${businessName}$`, 'i') };
      if (excludeMerchantId) {
        query._id = { $ne: excludeMerchantId };
      }

      const existingMerchant = await Merchant.findOne(query);
      
      return {
        isUnique: !existingMerchant,
        suggestion: existingMerchant ? `${businessName}(${Date.now()})` : null
      };
    } catch (error) {
      logger.error('验证商家名称唯一性失败', { error, businessName });
      return { isUnique: true, suggestion: null };
    }
  },

  /**
   * 验证注册号码唯一性
   */
  async validateRegistrationNumberUniqueness(registrationNumber, excludeMerchantId = null) {
    try {
      const Merchant = require('../../models/merchant/merchantModel');
      
      const query = { registrationNumber };
      if (excludeMerchantId) {
        query._id = { $ne: excludeMerchantId };
      }

      const existingMerchant = await Merchant.findOne(query);
      
      return {
        isUnique: !existingMerchant,
        conflictMerchant: existingMerchant ? {
          id: existingMerchant._id,
          businessName: existingMerchant.businessName
        } : null
      };
    } catch (error) {
      logger.error('验证注册号码唯一性失败', { error, registrationNumber });
      return { isUnique: true, conflictMerchant: null };
    }
  }
};

module.exports = merchantValidationService;