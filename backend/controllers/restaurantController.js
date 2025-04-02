const Restaurant = require('../models/restaurant');

// 获取所有餐厅
exports.getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.find({ isActive: true })
      .populate('merchantId', 'name')
      .sort({ rating: -1, createdAt: -1 });
    
    res.json(restaurants);
  } catch (error) {
    res.status(500).json({ message: '获取餐厅列表失败', error: error.message });
  }
};

// 获取特色餐厅
exports.getFeaturedRestaurants = async (req, res) => {
  try {
    const featuredRestaurants = await Restaurant.find({ 
      isActive: true,
      isFeatured: true 
    })
      .populate('merchantId', 'name')
      .sort({ rating: -1, createdAt: -1 })
      .limit(10);
    
    res.json(featuredRestaurants);
  } catch (error) {
    res.status(500).json({ message: '获取特色餐厅失败', error: error.message });
  }
};

// 获取单个餐厅详情
exports.getRestaurantById = async (req, res) => {
  try {
    const restaurant = await Restaurant.findById(req.params.id)
      .populate('merchantId', 'name');
    
    if (!restaurant) {
      return res.status(404).json({ message: '餐厅不存在' });
    }
    
    res.json(restaurant);
  } catch (error) {
    res.status(500).json({ message: '获取餐厅详情失败', error: error.message });
  }
};

// 创建新餐厅
exports.createRestaurant = async (req, res) => {
  try {
    const restaurant = new Restaurant(req.body);
    await restaurant.save();
    res.status(201).json(restaurant);
  } catch (error) {
    res.status(400).json({ message: '创建餐厅失败', error: error.message });
  }
};

// 更新餐厅
exports.updateRestaurant = async (req, res) => {
  try {
    const restaurant = await Restaurant.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!restaurant) {
      return res.status(404).json({ message: '餐厅不存在' });
    }
    
    res.json(restaurant);
  } catch (error) {
    res.status(400).json({ message: '更新餐厅失败', error: error.message });
  }
};

// 删除餐厅
exports.deleteRestaurant = async (req, res) => {
  try {
    const restaurant = await Restaurant.findByIdAndDelete(req.params.id);
    
    if (!restaurant) {
      return res.status(404).json({ message: '餐厅不存在' });
    }
    
    res.json({ message: '餐厅删除成功' });
  } catch (error) {
    res.status(500).json({ message: '删除餐厅失败', error: error.message });
  }
}; 