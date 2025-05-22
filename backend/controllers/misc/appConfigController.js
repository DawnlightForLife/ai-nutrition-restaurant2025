const AppConfig = require('../../models/core/appConfigModel');

/**
 * 创建应用配置
 * @route POST /api/config
 * @access private
 */
exports.createAppConfig = async (req, res) => {
  try {
    const { key, value, description } = req.body;
    
    // 检查配置是否已存在
    const existingConfig = await AppConfig.findOne({ key });
    if (existingConfig) {
      return res.status(400).json({
        success: false,
        message: `配置键 ${key} 已存在`
      });
    }
    
    // 创建新配置
    const appConfig = await AppConfig.create({
      key,
      value,
      description
    });
    
    res.status(201).json({
      success: true,
      data: appConfig
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '创建配置失败',
      error: error.message
    });
  }
};

/**
 * 获取应用配置列表
 * @route GET /api/config
 * @access private
 */
exports.getAppConfigList = async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    const appConfigs = await AppConfig.find()
      .sort({ key: 1 })
      .skip(skip)
      .limit(parseInt(limit));
    
    const total = await AppConfig.countDocuments();
    
    res.status(200).json({
      success: true,
      data: appConfigs,
      meta: {
        page: parseInt(page),
        limit: parseInt(limit),
        total
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '获取配置列表失败',
      error: error.message
    });
  }
};

/**
 * 获取指定应用配置详情
 * @route GET /api/config/:id
 * @access private
 */
exports.getAppConfigById = async (req, res) => {
  try {
    const appConfig = await AppConfig.findById(req.params.id);
    
    if (!appConfig) {
      return res.status(404).json({
        success: false,
        message: '配置不存在'
      });
    }
    
    res.status(200).json({
      success: true,
      data: appConfig
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '获取配置详情失败',
      error: error.message
    });
  }
};

/**
 * 更新应用配置
 * @route PUT /api/config/:id
 * @access private
 */
exports.updateAppConfig = async (req, res) => {
  try {
    const { value, description } = req.body;
    
    const appConfig = await AppConfig.findById(req.params.id);
    
    if (!appConfig) {
      return res.status(404).json({
        success: false,
        message: '配置不存在'
      });
    }
    
    // 不允许修改系统配置
    if (appConfig.isSystem && req.body.key) {
      return res.status(403).json({
        success: false,
        message: '不允许修改系统配置的键名'
      });
    }
    
    // 更新配置
    appConfig.value = value;
    if (description) appConfig.description = description;
    
    await appConfig.save();
    
    res.status(200).json({
      success: true,
      data: appConfig
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '更新配置失败',
      error: error.message
    });
  }
};

/**
 * 删除应用配置
 * @route DELETE /api/config/:id
 * @access private
 */
exports.deleteAppConfig = async (req, res) => {
  try {
    const appConfig = await AppConfig.findById(req.params.id);
    
    if (!appConfig) {
      return res.status(404).json({
        success: false,
        message: '配置不存在'
      });
    }
    
    // 不允许删除系统配置
    if (appConfig.isSystem) {
      return res.status(403).json({
        success: false,
        message: '不允许删除系统配置'
      });
    }
    
    await appConfig.deleteOne();
    
    res.status(200).json({
      success: true,
      message: '删除成功'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '删除配置失败',
      error: error.message
    });
  }
}; 