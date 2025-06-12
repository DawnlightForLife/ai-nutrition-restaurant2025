// 简单的日志模块
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message, ...args }) => {
      return `${timestamp} [${level.toUpperCase()}]: ${message} ${Object.keys(args).length ? JSON.stringify(args) : ''}`;
    })
  ),
  transports: [
    new winston.transports.Console()
  ]
});

module.exports = logger;