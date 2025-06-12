const systemConfigService = require('../../services/core/systemConfigService');
const { catchAsync } = require('../../utils');
const { AppError } = require('../../utils/errors');

/**
 * 系统配置控制器
 * 处理系统配置相关的HTTP请求
 */
class SystemConfigController {
  /**
   * 获取公开配置
   * GET /api/system-config/public
   */
  getPublicConfigs = catchAsync(async (req, res) => {
    const configs = await systemConfigService.getPublicConfigs();
    
    res.json({
      success: true,
      data: configs
    });
  });

  /**
   * 获取认证功能配置
   * GET /api/system-config/certification
   */
  getCertificationConfigs = catchAsync(async (req, res) => {
    const configs = await systemConfigService.getCertificationConfigs();
    
    res.json({
      success: true,
      data: configs
    });
  });

  /**
   * 获取所有配置（管理后台）
   * GET /api/admin/system-config
   */
  getAllConfigs = catchAsync(async (req, res) => {
    const { category, isPublic, isEditable } = req.query;
    
    const filter = {};
    if (category) filter.category = category;
    if (isPublic !== undefined) filter.isPublic = isPublic === 'true';
    if (isEditable !== undefined) filter.isEditable = isEditable === 'true';
    
    const configs = await systemConfigService.getAllConfigs(filter);
    
    res.json({
      success: true,
      data: configs,
      total: configs.length
    });
  });

  /**
   * 获取单个配置（管理后台）
   * GET /api/admin/system-config/:key
   */
  getConfig = catchAsync(async (req, res) => {
    const { key } = req.params;
    
    const value = await systemConfigService.getConfigValue(key);
    
    if (value === null) {
      throw new AppError('配置项不存在', 404);
    }
    
    res.json({
      success: true,
      data: { key, value }
    });
  });

  /**
   * 更新配置（管理后台）
   * PUT /api/admin/system-config/:key
   */
  updateConfig = catchAsync(async (req, res) => {
    const { key } = req.params;
    const { value } = req.body;
    const updatedBy = req.user._id; // 从认证中间件获取
    
    if (value === undefined) {
      throw new AppError('配置值不能为空', 400);
    }
    
    const config = await systemConfigService.setConfigValue(key, value, updatedBy);
    
    res.json({
      success: true,
      message: '配置更新成功',
      data: config
    });
  });

  /**
   * 批量更新认证配置（管理后台）
   * PUT /api/admin/system-config/certification
   */
  updateCertificationConfigs = catchAsync(async (req, res) => {
    const configs = req.body;
    const updatedBy = req.user._id;
    
    // 验证配置键名
    const allowedKeys = [
      'merchant_certification_enabled',
      'nutritionist_certification_enabled',
      'merchant_certification_mode',
      'nutritionist_certification_mode'
    ];
    
    const invalidKeys = Object.keys(configs).filter(key => !allowedKeys.includes(key));
    if (invalidKeys.length > 0) {
      throw new AppError(`无效的配置项: ${invalidKeys.join(', ')}`, 400);
    }
    
    const results = await systemConfigService.updateCertificationConfigs(configs, updatedBy);
    
    res.json({
      success: true,
      message: '认证配置更新成功',
      data: results
    });
  });

  /**
   * 创建配置（管理后台）
   * POST /api/admin/system-config
   */
  createConfig = catchAsync(async (req, res) => {
    const configData = req.body;
    const createdBy = req.user._id;
    
    // 验证必填字段
    const requiredFields = ['key', 'value', 'description', 'category'];
    const missingFields = requiredFields.filter(field => !configData[field]);
    
    if (missingFields.length > 0) {
      throw new AppError(`缺少必填字段: ${missingFields.join(', ')}`, 400);
    }
    
    // 设置创建者
    configData.updatedBy = createdBy;
    
    const config = await systemConfigService.createConfig(configData);
    
    res.status(201).json({
      success: true,
      message: '配置创建成功',
      data: config
    });
  });

  /**
   * 删除配置（管理后台）
   * DELETE /api/admin/system-config/:key
   */
  deleteConfig = catchAsync(async (req, res) => {
    const { key } = req.params;
    
    await systemConfigService.deleteConfig(key);
    
    res.json({
      success: true,
      message: '配置删除成功'
    });
  });

  /**
   * 获取配置分类列表
   * GET /api/admin/system-config/categories
   */
  getCategories = catchAsync(async (req, res) => {
    const categories = [
      { value: 'feature', label: '功能配置', description: '功能开关和模式设置' },
      { value: 'system', label: '系统配置', description: '系统级别的配置项' },
      { value: 'business', label: '业务配置', description: '业务相关的配置项' },
      { value: 'ui', label: '界面配置', description: '用户界面相关配置' },
      { value: 'security', label: '安全配置', description: '安全相关的配置项' }
    ];
    
    res.json({
      success: true,
      data: categories
    });
  });

  /**
   * 初始化默认配置
   * POST /api/admin/system-config/initialize
   */
  initializeDefaults = catchAsync(async (req, res) => {
    await systemConfigService.initializeDefaults();
    
    res.json({
      success: true,
      message: '默认配置初始化成功'
    });
  });
}

module.exports = new SystemConfigController();