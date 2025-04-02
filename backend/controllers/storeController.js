const { Store, Merchant } = require('../models');

// 获取所有门店
exports.getAllStores = async (req, res) => {
  try {
    const stores = await Store.find({ status: 'active' })
      .populate('merchant_id', 'name description cuisine')
      .sort({ rating: -1, createdAt: -1 });
    
    res.status(200).json({
      success: true,
      data: stores
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: '获取门店列表失败', 
      error: error.message 
    });
  }
};

// 获取特色门店
exports.getFeaturedStores = async (req, res) => {
  try {
    const featuredStores = await Store.find({ 
      status: 'active',
      isVerified: true 
    })
      .populate('merchant_id', 'name description cuisine')
      .sort({ rating: -1, createdAt: -1 })
      .limit(10);
    
    res.status(200).json({
      success: true,
      data: featuredStores
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: '获取特色门店失败', 
      error: error.message 
    });
  }
};

// 获取单个门店详情
exports.getStoreById = async (req, res) => {
  try {
    const store = await Store.findById(req.params.id)
      .populate('merchant_id', 'name description cuisine');
    
    if (!store) {
      return res.status(404).json({ 
        success: false,
        message: '门店不存在' 
      });
    }
    
    res.status(200).json({
      success: true,
      data: store
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: '获取门店详情失败', 
      error: error.message 
    });
  }
}; 