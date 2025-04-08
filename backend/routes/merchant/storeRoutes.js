const express = require('express');
const router = express.Router();
const { createStore, getStoreList, getStoreById, updateStore, deleteStore } = require('../../controllers/merchant/storeController');

/**
 * 店铺相关路由
 */

// 创建店铺
router.post('/', createStore);

// 获取店铺列表
router.get('/', getStoreList);

// 获取单个店铺详情
router.get('/:id', getStoreById);

// 更新店铺
router.put('/:id', updateStore);

// 删除店铺
router.delete('/:id', deleteStore);

module.exports = router; 