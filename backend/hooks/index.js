const { registerHook } = require('./utils/registerHook');

/**
 * 钩子注册中心
 * 统一管理所有业务钩子的注册和调用
 * @module hooks/index
 */

// =================== Nutrition 模块钩子 ===================
const onNutritionistCertificationSubmitted = require('./nutrition/onNutritionistCertificationSubmitted');
const onNutritionistCertificationReviewed = require('./nutrition/onNutritionistCertificationReviewed');
const onNutritionistCertificationExpired = require('./nutrition/onNutritionistCertificationExpired');

// 钩子注册映射 - 只注册营养师认证相关的钩子
const hookRegistry = {
  // Nutrition 模块
  'nutritionist.certification.submitted': onNutritionistCertificationSubmitted,
  'nutritionist.certification.reviewed': onNutritionistCertificationReviewed,
  'nutritionist.certification.expired': onNutritionistCertificationExpired
};

// 注册所有钩子
Object.entries(hookRegistry).forEach(([eventName, hookFunction]) => {
  registerHook(eventName, hookFunction);
});

/**
 * 触发钩子的便捷方法
 * @param {string} eventName 事件名称
 * @param {...any} args 传递给钩子的参数
 */
const triggerHook = async (eventName, ...args) => {
  const { triggerHook: trigger } = require('./utils/registerHook');
  return await trigger(eventName, ...args);
};

/**
 * 获取已注册的钩子列表
 * @param {string} eventName 可选，指定事件名称
 */
const getRegisteredHooks = (eventName) => {
  const { getRegisteredHooks: getHooks } = require('./utils/registerHook');
  return getHooks(eventName);
};

module.exports = {
  triggerHook,
  getRegisteredHooks,
  hookRegistry
};