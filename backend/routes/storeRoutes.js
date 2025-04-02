const express = require('express');
const router = express.Router();
const storeController = require('../controllers/storeController');
const auth = require('../middleware/auth');

// 公开路由
router.get('/', storeController.getAllStores);
router.get('/featured', storeController.getFeaturedStores);
router.get('/:id', storeController.getStoreById);

module.exports = router; 