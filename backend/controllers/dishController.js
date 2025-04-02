const { Dish, StoreDish } = require('../models');

// 获取所有菜品
exports.getAllDishes = async (req, res) => {
  try {
    console.log('[DEBUG] 开始获取所有菜品');
    const dishes = await Dish.find({ is_active: true })
      .sort({ rating: -1, createdAt: -1 });
    
    console.log(`[DEBUG] 成功获取菜品数量: ${dishes.length}`);
    res.status(200).json({
      success: true,
      data: dishes
    });
  } catch (error) {
    console.error('[ERROR] 获取菜品列表失败:', error);
    res.status(500).json({ 
      success: false,
      message: '获取菜品列表失败', 
      error: error.message 
    });
  }
};

// 获取特色菜品
exports.getFeaturedDishes = async (req, res) => {
  try {
    const featuredDishes = await Dish.find({ 
      is_active: true,
      isRecommended: true 
    })
      .sort({ rating: -1, createdAt: -1 })
      .limit(10);
    
    res.status(200).json({
      success: true,
      data: featuredDishes
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: '获取特色菜品失败', 
      error: error.message 
    });
  }
};

// 获取单个菜品详情
exports.getDishById = async (req, res) => {
  try {
    const dish = await Dish.findById(req.params.id);
    
    if (!dish) {
      return res.status(404).json({ 
        success: false,
        message: '菜品不存在' 
      });
    }
    
    // 获取该菜品在哪些门店有售
    const storeDishes = await StoreDish.find({ dish_id: dish._id })
      .populate('store_id', 'name address location businessHours');
    
    res.status(200).json({
      success: true,
      data: {
        ...dish.toObject(),
        availableStores: storeDishes.map(sd => sd.store_id)
      }
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: '获取菜品详情失败', 
      error: error.message 
    });
  }
}; 