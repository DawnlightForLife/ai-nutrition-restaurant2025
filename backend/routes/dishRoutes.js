const express = require('express');
const router = express.Router();
const dishController = require('../controllers/dishController');
const authMiddleware = require('../middleware/authMiddleware');

// 公开路由
router.get('/', dishController.getAllDishes);
router.get('/featured', dishController.getFeaturedDishes);
router.get('/:id', dishController.getDishById);

// 需要认证的路由
router.post('/', authMiddleware, dishController.createDish);
router.put('/:id', authMiddleware, dishController.updateDish);
router.delete('/:id', authMiddleware, dishController.deleteDish);

module.exports = router; 