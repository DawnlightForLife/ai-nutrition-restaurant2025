#!/usr/bin/env node
/**
 * 控制器生成工具
 * 用于生成符合项目规范的控制器文件
 * 
 * 使用方法：
 * node tools/generate-controller.js [目录] [控制器名称] [资源名称] [函数后缀]
 * 
 * 示例：
 * node tools/generate-controller.js core user "用户" User
 */

const fs = require('fs');
const path = require('path');
const util = require('util');

// 检查参数数量
if (process.argv.length < 6) {
  console.log('参数不足！');
  console.log('使用方法: node tools/generate-controller.js [目录] [控制器名称] [资源名称] [函数后缀]');
  console.log('示例: node tools/generate-controller.js core user "用户" User');
  process.exit(1);
}

// 获取参数
const directory = process.argv[2];
const controllerName = process.argv[3];
const resourceName = process.argv[4];
const functionSuffix = process.argv[5];
const description = process.argv[6] || `处理${resourceName}相关的所有请求`;

// 控制器文件模板
const template = `/**
 * ${resourceName}控制器
 * ${description}
 * @module controllers/${directory}/${controllerName}Controller
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

// 目标路径
const targetDir = path.join('backend', 'controllers', directory);
const targetPath = path.join(targetDir, `${controllerName}Controller.js`);

// 确保目录存在
if (!fs.existsSync(targetDir)) {
  fs.mkdirSync(targetDir, { recursive: true });
  console.log(`创建目录: ${targetDir}`);
}

// 写入文件
fs.writeFileSync(targetPath, template, 'utf8');
console.log(`控制器文件已生成: ${targetPath}`);

// 打印使用提示
console.log('\n如何使用此控制器:');
console.log(`1. 在 routes/${directory}.js 文件中添加以下路由:`);
console.log(`
const ${controllerName}Controller = require('../controllers/${directory}/${controllerName}Controller');

// 创建${resourceName}
router.post('/${controllerName}s', ${controllerName}Controller.create${functionSuffix});

// 获取${resourceName}列表
router.get('/${controllerName}s', ${controllerName}Controller.get${functionSuffix}List);

// 获取单个${resourceName}
router.get('/${controllerName}s/:id', ${controllerName}Controller.get${functionSuffix}ById);

// 更新${resourceName}
router.put('/${controllerName}s/:id', ${controllerName}Controller.update${functionSuffix});

// 删除${resourceName}
router.delete('/${controllerName}s/:id', ${controllerName}Controller.delete${functionSuffix});
`);

console.log('2. 在 services 目录中创建对应的服务层文件');
console.log(`3. 实现控制器中的 TODO 方法`); 