/**
 * ES模块动态加载工具
 * 本工具类支持以同步或异步方式动态加载 ES 模块，可选缓存策略，并支持目录批量加载。
 * 适用于插件系统、动态配置模块等场景。
 * @module utils/dynamicEsmLoader
 */

const fs = require('fs');
const path = require('path');
const logger = require('../logger');

/**
 * ES模块动态加载器
 * 提供动态加载和刷新 ES 模块的能力，支持缓存管理和目录批量加载。
 * 可配置异步(import)或同步(require)加载方式，适应不同模块规范。
 */
class DynamicEsmLoader {
  /**
   * 构造函数，初始化加载器实例
   * @param {Object} options - 配置选项
   * @param {String} options.importMode - 导入模式，'async' 或 'sync'，决定模块加载方式
   * @param {Boolean} options.enableCache - 是否启用模块缓存，避免重复加载
   */
  constructor(options = {}) {
    this.options = {
      importMode: 'async',  // 'async' 或 'sync'
      enableCache: false,
      ...options
    };
    
    this.moduleCache = new Map();
    this.logger = logger.child({ util: 'DynamicEsmLoader' });
    
    this.logger.info('动态ESM加载器已创建', {
      importMode: this.options.importMode,
      enableCache: this.options.enableCache
    });
  }
  
  /**
   * 动态导入单个 ES 模块
   * @param {String} modulePath - 要导入的模块的绝对路径或相对路径
   * @returns {Promise<Object>} - 导入的模块对象（export 内容）
   */
  async importModule(modulePath) {
    try {
      const resolvedPath = path.resolve(modulePath);

      // 检查缓存，若启用缓存且模块已缓存，则直接返回缓存结果
      if (this.options.enableCache && this.moduleCache.has(resolvedPath)) {
        this.logger.debug(`从缓存中命中模块: ${resolvedPath}`);
        return this.moduleCache.get(resolvedPath);
      }

      // 验证模块文件是否存在
      if (!fs.existsSync(resolvedPath)) {
        throw new Error(`模块文件不存在: ${resolvedPath}`);
      }

      let moduleExports;

      // 根据导入模式导入模块
      if (this.options.importMode === 'async') {
        // 异步导入（适用于 ESModule）
        if (modulePath.startsWith('file:') || path.isAbsolute(modulePath)) {
          moduleExports = await import(modulePath);
        } else {
          moduleExports = await import(`file://${resolvedPath}`);
        }
      } else {
        // 同步导入（适用于 CommonJS）
        // 删除 Node.js require 缓存，确保重新加载最新模块
        delete require.cache[resolvedPath];
        moduleExports = require(resolvedPath);
      }

      // 如果启用缓存，则存入模块缓存
      if (this.options.enableCache) {
        this.moduleCache.set(resolvedPath, moduleExports);
      }

      this.logger.debug(`成功导入模块: ${resolvedPath}`);
      return moduleExports;
    } catch (error) {
      this.logger.error(`导入模块失败: ${modulePath}`, error);
      throw new Error(`导入模块失败 ${modulePath}: ${error.message}`);
    }
  }
  
  /**
   * 刷新模块（即强制重新加载该模块）
   * @param {String} modulePath - 模块文件路径
   * @returns {Promise<Object>} - 模块的最新导出内容
   */
  async refreshModule(modulePath) {
    const resolvedPath = path.resolve(modulePath);

    // 清除自定义缓存
    this.moduleCache.delete(resolvedPath);

    // 清除 Node.js 模块缓存，确保下一次加载时重新加载模块
    delete require.cache[resolvedPath];

    // 重新导入模块
    return await this.importModule(modulePath);
  }
  
  /**
   * 清空所有模块缓存（包括手动缓存）
   */
  clearCache() {
    this.moduleCache.clear();
    this.logger.debug('已清空模块缓存');
  }
  
  /**
   * 创建一个加载指定目录中所有模块的异步函数
   * @param {String} directory - 目标目录路径
   * @param {Object} options - 加载选项，例如过滤器与递归加载控制
   * @returns {Function} - 返回一个可调用的异步函数用于加载模块
   */
  createDirectoryLoader(directory, options = {}) {
    const loaderOptions = {
      filter: (file) => file.endsWith('.js'),
      recursive: false,
      ...options
    };
    
    return async () => {
      const dirPath = path.resolve(directory);
      const results = new Map();
      
      try {
        if (!fs.existsSync(dirPath)) {
          throw new Error(`目录不存在: ${dirPath}`);
        }
        
        const files = this._getFilesInDirectory(dirPath, loaderOptions);
        
        for (const file of files) {
          const moduleName = path.basename(file, path.extname(file));
          try {
            const moduleExports = await this.importModule(file);
            results.set(moduleName, moduleExports);
          } catch (error) {
            this.logger.error(`加载目录中的模块失败: ${file}`, error);
            results.set(moduleName, { error: error.message });
          }
        }
        
        return results;
      } catch (error) {
        this.logger.error(`加载目录失败: ${dirPath}`, error);
        throw error;
      }
    };
  }
  
  /**
   * 递归获取目录中的符合条件的文件列表
   * @private
   * @param {String} directory - 目录路径
   * @param {Object} options - 筛选条件，如是否递归、过滤函数
   * @returns {Array<String>} - 符合条件的文件路径数组
   */
  _getFilesInDirectory(directory, options) {
    const { filter, recursive } = options;
    const files = [];
    
    // 读取目录内容
    const items = fs.readdirSync(directory);
    
    for (const item of items) {
      // 忽略隐藏文件（以点开头）
      if (item.startsWith('.')) continue;
      
      const itemPath = path.join(directory, item);
      const stats = fs.statSync(itemPath);
      
      if (stats.isDirectory() && recursive) {
        // 递归加载子目录
        const subDirFiles = this._getFilesInDirectory(itemPath, options);
        files.push(...subDirFiles);
      } else if (stats.isFile() && filter(item)) {
        // 符合过滤条件的文件加入列表
        files.push(itemPath);
      }
    }
    
    return files;
  }
}

module.exports = DynamicEsmLoader;