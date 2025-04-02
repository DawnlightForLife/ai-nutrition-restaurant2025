const express = require('express');
const router = express.Router();
const restaurantController = require('../controllers/restaurantController');
const auth = require('../middleware/auth');

// 公开路由
router.get('/', restaurantController.getAllRestaurants);
router.get('/featured', restaurantController.getFeaturedRestaurants);
router.get('/:id', restaurantController.getRestaurantById);

// 需要认证的路由
router.post('/', auth, restaurantController.createRestaurant);
router.put('/:id', auth, restaurantController.updateRestaurant);
router.delete('/:id', auth, restaurantController.deleteRestaurant);

module.exports = router; 