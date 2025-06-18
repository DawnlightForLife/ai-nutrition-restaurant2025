/**
 * 商家业务功能测试脚本
 * 用于验证菜品管理和订单管理功能
 */

require('dotenv').config();
const mongoose = require('mongoose');

// 导入模型
const StoreDish = require('../../models/merchant/storeDishModel');
const ProductDish = require('../../models/merchant/productDishModel');
const Order = require('../../models/order/orderModel');

async function connectDB() {
  try {
    const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_db';
    await mongoose.connect(mongoUri);
    console.log('📊 数据库连接成功');
  } catch (error) {
    console.error('❌ 数据库连接失败:', error);
    process.exit(1);
  }
}

async function testDishFunctions() {
  console.log('\n🍽️ 测试菜品管理功能...');
  
  try {
    // 测试创建产品菜品
    const productDish = new ProductDish({
      name: '测试宫保鸡丁',
      description: '经典川菜，香辣可口',
      category: 'mainCourse',
      price: 28.00,
      ingredients: ['鸡肉', '花生', '辣椒'],
      nutritionFacts: {
        calories: 320,
        protein: 25,
        fat: 18,
        carbohydrates: 15
      },
      preparationTime: 15,
      spicyLevel: 3,
      createdBy: new mongoose.Types.ObjectId()
    });
    
    await productDish.save();
    console.log('✅ 产品菜品创建成功:', productDish.name);
    
    // 测试创建店铺菜品
    const storeDish = new StoreDish({
      storeId: new mongoose.Types.ObjectId(),
      dishId: productDish._id,
      priceOverride: 32.00,
      discountPriceOverride: 28.00,
      isAvailable: true,
      inventory: {
        currentStock: 50,
        alertThreshold: 10
      }
    });
    
    await storeDish.save();
    console.log('✅ 店铺菜品创建成功，当前库存:', storeDish.inventory.currentStock);
    
    // 测试库存更新
    await storeDish.updateStock(-5);
    console.log('✅ 库存更新成功，当前库存:', storeDish.inventory.currentStock);
    
    // 测试销售数据更新
    await storeDish.updateSalesData(3, 96.00);
    console.log('✅ 销售数据更新成功，总销量:', storeDish.salesData.totalSales);
    
    // 测试价格设置
    await storeDish.setPrice(35.00, 30.00);
    console.log('✅ 价格设置成功，当前价格:', storeDish.priceOverride);
    
    // 清理测试数据
    await ProductDish.findByIdAndDelete(productDish._id);
    await StoreDish.findByIdAndDelete(storeDish._id);
    console.log('🧹 菜品测试数据清理完成');
    
  } catch (error) {
    console.error('❌ 菜品功能测试失败:', error.message);
  }
}

async function testOrderFunctions() {
  console.log('\n📦 测试订单管理功能...');
  
  try {
    // 创建测试订单
    const order = new Order({
      orderNumber: `TEST${Date.now()}`,
      userId: new mongoose.Types.ObjectId(),
      merchantId: new mongoose.Types.ObjectId(),
      merchantType: 'restaurant',
      items: [
        {
          dishId: new mongoose.Types.ObjectId(),
          name: '测试菜品',
          price: 25.00,
          quantity: 2,
          itemTotal: 50.00
        }
      ],
      priceDetails: {
        subtotal: 50.00,
        total: 50.00
      },
      payment: {
        method: 'cash'
      },
      status: 'pending',
      orderType: 'takeout',
      contactInfo: {
        phone: '13800138000'
      }
    });
    
    await order.save();
    console.log('✅ 订单创建成功，订单号:', order.orderNumber);
    
    // 测试订单状态更新
    order.status = 'confirmed';
    if (!order.statusHistory) order.statusHistory = [];
    order.statusHistory.push({
      status: 'confirmed',
      timestamp: new Date(),
      operator: new mongoose.Types.ObjectId(),
      notes: '商家确认订单'
    });
    
    await order.save();
    console.log('✅ 订单状态更新成功，当前状态:', order.status);
    
    // 测试支付状态更新
    order.payment.status = 'paid';
    order.payment.paidAt = new Date();
    await order.save();
    console.log('✅ 支付状态更新成功，支付状态:', order.payment.status);
    
    // 清理测试数据
    await Order.findByIdAndDelete(order._id);
    console.log('🧹 订单测试数据清理完成');
    
  } catch (error) {
    console.error('❌ 订单功能测试失败:', error.message);
  }
}

async function testStaticMethods() {
  console.log('\n📈 测试静态方法功能...');
  
  try {
    // 测试查找热销菜品（空数据库会返回空数组）
    const storeId = new mongoose.Types.ObjectId();
    const bestSellers = await StoreDish.findBestSellers(storeId, 5);
    console.log('✅ 热销菜品查询成功，数量:', bestSellers.length);
    
    // 测试查找库存预警菜品
    const lowStockDishes = await StoreDish.findLowStock(storeId);
    console.log('✅ 库存预警菜品查询成功，数量:', lowStockDishes.length);
    
    console.log('✅ 静态方法测试完成');
    
  } catch (error) {
    console.error('❌ 静态方法测试失败:', error.message);
  }
}

async function runTests() {
  console.log('🧪 开始商家业务功能测试...\n');
  
  await connectDB();
  await testDishFunctions();
  await testOrderFunctions();
  await testStaticMethods();
  
  console.log('\n🎉 商家业务功能测试完成!');
  
  // 关闭数据库连接
  await mongoose.connection.close();
  console.log('📊 数据库连接已关闭');
}

// 如果作为脚本直接运行
if (require.main === module) {
  runTests().catch(error => {
    console.error('💥 测试执行失败:', error);
    process.exit(1);
  });
}

module.exports = { runTests };