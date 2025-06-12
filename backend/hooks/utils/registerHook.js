// Using console for simple logging to avoid circular dependencies

/**
 * �P��w{
 * Л�P���ь���
 * @module hooks/utils/registerHook
 */

// �PX��h
const hooks = new Map();

/**
 * 茩P
 * @param {string} eventName ���
 * @param {Function} hookFunction �P�p
 */
const registerHook = (eventName, hookFunction) => {
  if (typeof hookFunction !== 'function') {
    throw new Error(`Hook for event "${eventName}" must be a function`);
  }

  if (!hooks.has(eventName)) {
    hooks.set(eventName, []);
  }

  hooks.get(eventName).push(hookFunction);
  console.log(`Hook registered for event: ${eventName}`);
};

/**
 * �ѩP
 * @param {string} eventName ���
 * @param {...any} args  ٩P��p
 * @returns {Promise<Array>} @	�P�gLӜ
 */
const triggerHook = async (eventName, ...args) => {
  const eventHooks = hooks.get(eventName);
  
  if (!eventHooks || eventHooks.length === 0) {
    console.log(`No hooks registered for event: ${eventName}`);
    return [];
  }

  console.log(`Triggering ${eventHooks.length} hooks for event: ${eventName}`);

  const results = [];
  
  for (const hookFunction of eventHooks) {
    try {
      const result = await hookFunction(...args);
      results.push({ success: true, result });
    } catch (error) {
      console.error(`Hook execution failed for event "${eventName}":`, error);
      results.push({ success: false, error: error.message });
    }
  }

  return results;
};

/**
 * ���茄�Ph
 * @param {string} eventName �	����
 * @returns {Object|Array} �Ph
 */
const getRegisteredHooks = (eventName) => {
  if (eventName) {
    return hooks.get(eventName) || [];
  }
  
  const allHooks = {};
  for (const [event, hookList] of hooks.entries()) {
    allHooks[event] = hookList.length;
  }
  
  return allHooks;
};

/**
 * �d�P
 * @param {string} eventName ���
 * @param {Function} hookFunction ��d��P�p
 */
const unregisterHook = (eventName, hookFunction) => {
  const eventHooks = hooks.get(eventName);
  
  if (eventHooks) {
    const index = eventHooks.indexOf(hookFunction);
    if (index > -1) {
      eventHooks.splice(index, 1);
      console.log(`Hook unregistered for event: ${eventName}`);
    }
  }
};

/**
 * d@	�P
 * @param {string} eventName �	����
 */
const clearHooks = (eventName) => {
  if (eventName) {
    hooks.delete(eventName);
    console.log(`All hooks cleared for event: ${eventName}`);
  } else {
    hooks.clear();
    console.log('All hooks cleared');
  }
};

module.exports = {
  registerHook,
  triggerHook,
  getRegisteredHooks,
  unregisterHook,
  clearHooks
};