const SystemConfig = require('../../models/core/systemConfigModel');
const { responseHelper } = require('../../utils');

/**
 * 旧版认证功能屏蔽中间件
 * 当新版权限管理系统启用时，屏蔽旧版认证路由
 */
const legacyCertificationMiddleware = async (req, res, next) => {
  try {
    // 检查是否启用旧版认证流程
    const legacyEnabled = await SystemConfig.getValue('legacy_certification_enabled', false);
    
    if (!legacyEnabled) {
      // 如果旧版认证被禁用，返回迁移提示
      return responseHelper.error(res, 
        '此认证流程已升级，请使用新版权限申请系统。如需帮助，请联系客服。', 
        410, // 410 Gone - 资源已永久移除
        {
          migrationInfo: {
            newEndpoint: '/api/user-permissions/apply',
            contactSupport: true,
            message: '认证流程已迁移到新的权限管理系统'
          }
        }
      );
    }
    
    // 如果启用旧版，添加警告头信息
    res.setHeader('X-Legacy-API-Warning', 'This API is deprecated and will be removed in future versions');
    next();
  } catch (error) {
    console.error('检查旧版认证配置失败:', error);
    // 出错时允许继续，避免影响正常功能
    next();
  }
};

/**
 * 检查是否应该显示迁移通知的中间件
 */
const migrationNoticeMiddleware = async (req, res, next) => {
  try {
    const showNotice = await SystemConfig.getValue('show_certification_migration_notice', true);
    
    if (showNotice) {
      res.setHeader('X-Migration-Notice', 'true');
      res.setHeader('X-Migration-Message', '认证流程已升级，建议使用新版权限申请系统');
    }
    
    next();
  } catch (error) {
    console.error('检查迁移通知配置失败:', error);
    next();
  }
};

module.exports = {
  legacyCertificationMiddleware,
  migrationNoticeMiddleware
};