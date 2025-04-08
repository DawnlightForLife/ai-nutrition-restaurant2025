#!/usr/bin/env node
/**
 * 控制器清理工具
 * 用于清理检测有问题的控制器文件并重新创建
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// 控制器目录
const CONTROLLERS_DIR = path.join('backend', 'controllers');

// 控制器目录结构
const CONTROLLER_DIRS = [
  'core',
  'forum',
  'health',
  'merchant',
  'misc',
  'nutrition',
  'order',
  'audit'
];

// 控制器定义
const controllers = [
  // Core controllers
  { directory: 'core', name: 'auth', resourceName: '认证信息', functionSuffix: 'Auth', description: '处理用户认证相关的所有请求，包括登录、注册、验证码、重置密码等' },
  { directory: 'core', name: 'user', resourceName: '用户', functionSuffix: 'User', description: '处理用户信息相关的所有请求，包括获取、更新用户信息等' },
  { directory: 'core', name: 'admin', resourceName: '管理员', functionSuffix: 'Admin', description: '处理管理员相关的所有请求，包括管理员管理、权限分配等' },
  { directory: 'core', name: 'permission', resourceName: '权限', functionSuffix: 'Permission', description: '处理权限相关的所有请求，包括角色管理、权限分配等' },
  
  // Forum controllers
  { directory: 'forum', name: 'forumPost', resourceName: '帖子', functionSuffix: 'ForumPost', description: '处理论坛帖子相关的所有请求，包括发帖、获取帖子列表等' },
  { directory: 'forum', name: 'forumComment', resourceName: '评论', functionSuffix: 'ForumComment', description: '处理论坛评论相关的所有请求，包括评论、回复等' },
  
  // Health controllers
  { directory: 'health', name: 'nutritionProfile', resourceName: '营养档案', functionSuffix: 'NutritionProfile', description: '处理用户营养档案相关的所有请求，包括创建、更新营养需求等' },
  { directory: 'health', name: 'healthData', resourceName: '健康数据', functionSuffix: 'HealthData', description: '处理用户健康数据相关的所有请求，包括体检数据、运动数据等' },
  
  // Merchant controllers
  { directory: 'merchant', name: 'merchant', resourceName: '商家', functionSuffix: 'Merchant', description: '处理商家基本信息相关的所有请求，包括商家注册、信息更新等' },
  { directory: 'merchant', name: 'store', resourceName: '店铺', functionSuffix: 'Store', description: '处理店铺相关的所有请求，包括店铺管理、信息更新等' },
  { directory: 'merchant', name: 'dish', resourceName: '菜品', functionSuffix: 'Dish', description: '处理菜品相关的所有请求，包括菜品管理、营养信息等' },
  { directory: 'merchant', name: 'merchantStats', resourceName: '统计数据', functionSuffix: 'MerchantStats', description: '处理商家统计数据相关的所有请求，包括销售统计、用户分析等' },
  
  // Misc controllers
  { directory: 'misc', name: 'notification', resourceName: '通知', functionSuffix: 'Notification', description: '处理系统通知相关的所有请求，包括消息推送、通知管理等' },
  { directory: 'misc', name: 'appConfig', resourceName: '配置', functionSuffix: 'AppConfig', description: '处理系统配置相关的所有请求，包括全局设置、参数配置等' },
  
  // Nutrition controllers
  { directory: 'nutrition', name: 'aiRecommendation', resourceName: '推荐', functionSuffix: 'AiRecommendation', description: '处理AI推荐相关的所有请求，包括个性化推荐、营养建议等' },
  { directory: 'nutrition', name: 'nutritionist', resourceName: '营养师', functionSuffix: 'Nutritionist', description: '处理营养师相关的所有请求，包括营养师资料、审核等' },
  { directory: 'nutrition', name: 'favorite', resourceName: '收藏', functionSuffix: 'Favorite', description: '处理用户收藏相关的所有请求，包括收藏菜品、收藏店铺等' },
  
  // Order controllers
  { directory: 'order', name: 'order', resourceName: '订单', functionSuffix: 'Order', description: '处理订单相关的所有请求，包括下单、支付、订单管理等' },
  { directory: 'order', name: 'consultation', resourceName: '咨询', functionSuffix: 'Consultation', description: '处理咨询相关的所有请求，包括营养咨询、预约等' },
  { directory: 'order', name: 'subscription', resourceName: '订阅', functionSuffix: 'Subscription', description: '处理订阅服务相关的所有请求，包括套餐订阅、续费等' },
  
  // Audit controllers
  { directory: 'audit', name: 'auditLog', resourceName: '审计日志', functionSuffix: 'AuditLog', description: '处理审计日志相关的所有请求，包括操作记录、安全审计等' }
];

// 控制器模板
function getControllerTemplate(name, description, resourceName, functionSuffix) {
  return `/**
 * ${name}控制器
 * ${description}
 * @module controllers/${this.directory}/${this.fileName}
 */

/**
 * 创建${resourceName}
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建${resourceName}的JSON响应
 */
exports.create${functionSuffix} = async (req, res) => {
  // TODO: implement create${functionSuffix}
};

/**
 * 获取${resourceName}列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含${resourceName}列表的JSON响应
 */
exports.get${functionSuffix}List = async (req, res) => {
  // TODO: implement get${functionSuffix}List
};

/**
 * 获取单个${resourceName}详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个${resourceName}的JSON响应
 */
exports.get${functionSuffix}ById = async (req, res) => {
  // TODO: implement get${functionSuffix}ById
};

/**
 * 更新${resourceName}
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后${resourceName}的JSON响应
 */
exports.update${functionSuffix} = async (req, res) => {
  // TODO: implement update${functionSuffix}
};

/**
 * 删除${resourceName}
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.delete${functionSuffix} = async (req, res) => {
  // TODO: implement delete${functionSuffix}
};
`;
}

// 确保目录存在
CONTROLLER_DIRS.forEach(dir => {
  const dirPath = path.join(CONTROLLERS_DIR, dir);
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`创建目录: ${dirPath}`);
  }
});

// 检查控制器文件内容是否符合规范
function isValidController(filePath, functionSuffix) {
  if (!fs.existsSync(filePath)) {
    return false;
  }
  
  const content = fs.readFileSync(filePath, 'utf8');
  const requiredFunctions = [
    `exports.create${functionSuffix}`,
    `exports.get${functionSuffix}List`,
    `exports.get${functionSuffix}ById`,
    `exports.update${functionSuffix}`,
    `exports.delete${functionSuffix}`
  ];
  
  // 检查文件是否包含所有必要的函数导出
  return requiredFunctions.every(func => content.includes(func)) && !content.includes('');
}

// 清理并重新生成所有控制器
console.log('清理并重新生成所有控制器...');

controllers.forEach(controller => {
  const filePath = path.join(CONTROLLERS_DIR, controller.directory, `${controller.name}Controller.js`);
  const fileName = `${controller.name}Controller`;
  
  // 检查文件是否有效
  if (isValidController(filePath, controller.functionSuffix)) {
    console.log(`保留有效控制器: ${filePath}`);
    return;
  }
  
  // 文件不存在或内容不符合规范，需要重新生成
  console.log(`重新生成控制器: ${filePath}`);
  
  // 准备控制器对象，包含生成模板需要的上下文
  const controllerObj = {
    ...controller,
    fileName,
    directory: controller.directory
  };
  
  // 生成控制器内容
  const content = getControllerTemplate.call(controllerObj, controller.resourceName, controller.description, controller.resourceName, controller.functionSuffix);
  
  // 确保父目录存在
  const dirPath = path.dirname(filePath);
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
  
  // 写入文件
  fs.writeFileSync(filePath, content, 'utf8');
});

console.log('控制器目录清理和重新生成完成!');
console.log('所有控制器现在应该符合项目规范。'); 