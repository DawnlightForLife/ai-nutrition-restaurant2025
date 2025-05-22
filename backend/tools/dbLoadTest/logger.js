/**
 * ✅ 模块名：logger.js
 * ✅ 所属模块：dbLoadTest/tools
 * ✅ 功能说明：
 *   - 提供带时间戳、模块名前缀的标准日志记录器
 *   - 支持四种级别：debug / info / warn / error
 *   - 支持额外参数格式化（自动序列化对象）
 * ✅ 使用方式：
 *   const logger = getLogger('MyModule')
 *   logger.info('启动完成')
 * ✅ 推荐 future：
 *   - 支持写入日志文件（可配置）
 *   - 支持日志级别过滤（通过环境变量）
 *   - 支持颜色高亮输出（提升 CLI 可读性）
 */

/**
 * 创建一个日志记录器
 * @param {string} name 日志记录器名称
 * @returns {Object} logger 包含 debug/info/warn/error 四个标准方法
 */
function getLogger(name) {
  const timestamp = () => {
    return new Date().toISOString();
  };

  const formatMessage = (message, ...args) => {
    // 将日志消息格式化为标准字符串，包含时间戳与模块名前缀
    let formattedMessage = `[${timestamp()}] [${name}] ${message}`;
    if (args.length > 0) {
      formattedMessage += ' ' + args.map(arg => 
        typeof arg === 'object' ? JSON.stringify(arg) : arg
      ).join(' ');
    }
    return formattedMessage;
  };

  return {
    // DEBUG 级别日志（调试用）
    debug: (message, ...args) => {
      console.debug(formatMessage(message, ...args));
    },
    // INFO 级别日志（正常信息）
    info: (message, ...args) => {
      console.info(formatMessage(message, ...args));
    },
    // WARN 级别日志（警告信息）
    warn: (message, ...args) => {
      console.warn(formatMessage(message, ...args));
    },
    // ERROR 级别日志（错误信息）
    error: (message, ...args) => {
      console.error(formatMessage(message, ...args));
    }
  };
}

module.exports = { getLogger }; 