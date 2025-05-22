/**
 * 店铺管理路由
 * 提供店铺的创建、查询、更新、删除接口
 * @module routes/merchant/storeRoutes
 */

const express = require('express');
const router = express.Router();
const { createStore, getStoreList, getStoreById, updateStore, deleteStore } = require('../../controllers/merchant/storeController');

// [POST] 创建店铺
router.post('/', createStore);

// [GET] 获取店铺列表
router.get('/', getStoreList);

// [GET] 获取指定店铺详情
router.get('/:id', getStoreById);

// [PUT] 更新店铺信息
router.put('/:id', updateStore);

// [DELETE] 删除店铺
router.delete('/:id', deleteStore);

module.exports = router; 