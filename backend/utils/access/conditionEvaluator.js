/**
 * ✅ 模块名：conditionEvaluator.js
 * ✅ 功能说明：
 *   - 对访问请求上下文（context）进行权限条件判断
 *   - 支持条件类型：
 *     1. 时间约束：before / after
 *     2. IP 限制：白名单 / 黑名单
 *     3. 地理位置约束：国家
 *     4. 设备类型限制
 *     5. 最小认证等级限制
 *     6. 自定义代码（字符串形式，动态函数执行）
 * ✅ 安全提示：
 *   - 对 `customEvaluator` 使用 `new Function`，存在潜在风险，建议使用沙箱或限制表达式语言执行。
 * ✅ 应用范围：
 *   - 数据访问控制中间件 / API 请求拦截器
 */

/**
 * 条件评估器
 * 用于评估数据访问控制的条件
 * @module utils/access/conditionEvaluator
 */

const logger = require('../logger');

/**
 * 评估条件是否满足
 * @param {Object} condition - 待评估的条件对象
 * @param {Object} context - 上下文信息
 * @returns {boolean} 条件是否满足
 */
const evaluateCondition = (condition, context = {}) => {
  // 如果条件为空，默认返回true
  if (!condition || Object.keys(condition).length === 0) {
    return true;
  }

  try {
    // ✅ 时间条件检查：检查当前时间是否在约束范围内
    if (condition.timeConstraint) {
      const now = new Date();
      if (condition.timeConstraint.after && new Date(condition.timeConstraint.after) > now) {
        return false;
      }
      if (condition.timeConstraint.before && new Date(condition.timeConstraint.before) < now) {
        return false;
      }
    }

    // ✅ IP 限制检查：判断请求IP是否在允许或拒绝列表中
    if (condition.ipConstraint && context.ip) {
      if (Array.isArray(condition.ipConstraint.allowList) && 
          condition.ipConstraint.allowList.length > 0 && 
          !condition.ipConstraint.allowList.includes(context.ip)) {
        return false;
      }
      if (Array.isArray(condition.ipConstraint.denyList) && 
          condition.ipConstraint.denyList.includes(context.ip)) {
        return false;
      }
    }

    // ✅ 地理位置检查：基于国家字段做精确匹配
    if (condition.geoConstraint && context.location) {
      // 简单实现，实际应用中可能需要更复杂的地理位置计算
      if (condition.geoConstraint.country && 
          condition.geoConstraint.country !== context.location.country) {
        return false;
      }
    }

    // ✅ 设备类型检查：是否在允许的设备类型列表中
    if (condition.deviceConstraint && context.device) {
      if (Array.isArray(condition.deviceConstraint.allowedDevices) && 
          condition.deviceConstraint.allowedDevices.length > 0 && 
          !condition.deviceConstraint.allowedDevices.includes(context.device.type)) {
        return false;
      }
    }

    // ✅ 认证等级检查：是否达到最低认证级别
    if (condition.authLevelConstraint && 
        typeof context.authLevel === 'number') {
      if (context.authLevel < condition.authLevelConstraint) {
        return false;
      }
    }

    // ✅ 自定义动态条件执行：将字符串解析为函数进行逻辑判断
    if (condition.customEvaluator && typeof condition.customEvaluator === 'string') {
      // 注意：这里使用了eval，在实际应用中应当谨慎使用或采用其他安全的替代方案
      // 在生产环境中，应该考虑使用沙箱或其他更安全的方式执行动态代码
      try {
        const evaluator = new Function('context', `return ${condition.customEvaluator}`);
        if (!evaluator(context)) {
          return false;
        }
      } catch (evalError) {
        logger.error(`[ConditionEvaluator] 自定义条件评估错误: ${evalError.message}`, {
          condition: condition.customEvaluator,
          error: evalError
        });
        return false;
      }
    }

    // 所有条件都满足
    return true;
  } catch (error) {
    logger.error(`[ConditionEvaluator] 条件评估错误: ${error.message}`, {
      condition,
      context: { ...context, sensitive: '[已屏蔽]' },
      error
    });
    return false;
  }
};

module.exports = {
  evaluateCondition
}; 