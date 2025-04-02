/**
 * 示例数据生成脚本
 * 生成商家、菜品、订单等完整数据集
 */

const mongoose = require('mongoose');
const { ObjectId } = mongoose.Types;
require('dotenv').config();

// 导入所有模型
const {
  User, 
  Merchant, 
  Dish, 
  Order, 
  Store, 
  StoreDish,
  Nutritionist,
  Consultation,
  ForumPost,
  ForumComment,
  AiRecommendation,
  MerchantStats
} = require('../models');

// 数据库连接URI
const DB_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant';

/**
 * 生成示例数据
 */
const generateSampleData = async () => {
  try {
    // 连接到数据库
    console.log(`正在连接到数据库: ${DB_URI}`);
    await mongoose.connect(DB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('数据库连接成功');

    // 获取用户列表
    const users = await User.find({ role: 'user' });
    if (users.length === 0) {
      console.error('未找到用户数据，请先运行initializeDatabase.js脚本');
      return;
    }
    
    // 创建示例商家
    console.log('创建示例商家...');
    const merchants = await createMerchants();
    
    // 创建商家门店
    console.log('创建商家门店...');
    const stores = await createStores(merchants);
    
    // 创建菜品
    console.log('创建示例菜品...');
    const dishes = await createDishes();
    
    // 创建门店菜品关联
    console.log('创建门店菜品关联...');
    await createStoreDishes(stores, dishes);
    
    // 创建订单
    console.log('创建示例订单...');
    await createOrders(users, stores, dishes);
    
    // 创建营养师
    console.log('创建示例营养师...');
    const nutritionists = await createNutritionists();
    
    // 创建咨询记录
    console.log('创建示例咨询记录...');
    await createConsultations(users, nutritionists);
    
    // 创建论坛帖子和评论
    console.log('创建示例论坛内容...');
    await createForumContent(users);
    
    // 创建AI推荐
    console.log('创建示例AI推荐...');
    await createAiRecommendations(users, dishes);
    
    // 创建商家统计数据
    console.log('创建商家统计数据...');
    await createMerchantStats(merchants);

    console.log('所有示例数据生成完成');
  } catch (error) {
    console.error('生成示例数据失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('数据库连接已关闭');
  }
};

/**
 * 创建示例商家
 */
const createMerchants = async () => {
  const merchantsData = [
    {
      name: '健康食客',
      description: '专注于提供低碳水、高蛋白的健康餐饮选择',
      cuisine: 'chinese',
      address: '广东省深圳市南山区科技园南区',
      location: {
        type: 'Point',
        coordinates: [113.9204, 22.5006] // 经度,纬度
      },
      contactPhone: '0755-88889999',
      businessHours: { opening: '08:00', closing: '22:00' },
      priceLevel: 2,
      rating: 4.7,
      reviewCount: 342,
      isVerified: true
    },
    {
      name: '轻食优选',
      description: '新鲜食材，轻食沙拉，科学搭配营养均衡',
      cuisine: 'western',
      address: '广东省深圳市福田区中心区',
      location: {
        type: 'Point',
        coordinates: [114.0579, 22.5431]
      },
      contactPhone: '0755-66667777',
      businessHours: { opening: '09:00', closing: '21:30' },
      priceLevel: 3,
      rating: 4.5,
      reviewCount: 268,
      isVerified: true
    },
    {
      name: '营养工坊',
      description: '精准营养配餐，适合健身和减脂人群',
      cuisine: 'mixed',
      address: '广东省深圳市罗湖区东门步行街',
      location: {
        type: 'Point',
        coordinates: [114.1200, 22.5500]
      },
      contactPhone: '0755-55556666',
      businessHours: { opening: '07:30', closing: '20:00' },
      priceLevel: 2,
      rating: 4.8,
      reviewCount: 426,
      isVerified: true
    }
  ];

  const merchants = [];
  for (const data of merchantsData) {
    const merchant = new Merchant({
      ...data,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await merchant.save();
    merchants.push(merchant);
  }
  
  console.log(`已创建 ${merchants.length} 个商家`);
  return merchants;
};

/**
 * 创建商家门店
 */
const createStores = async (merchants) => {
  const stores = [];
  
  for (const merchant of merchants) {
    // 每个商家创建1-3个门店
    const storeCount = Math.floor(Math.random() * 3) + 1;
    
    for (let i = 0; i < storeCount; i++) {
      const store = new Store({
        merchant_id: merchant._id,
        name: `${merchant.name}${i === 0 ? '总店' : '分店' + i}`,
        address: `${merchant.address}${i === 0 ? '' : i + '号'}`,
        location: {
          type: 'Point',
          coordinates: [
            merchant.location.coordinates[0] + (Math.random() * 0.02 - 0.01),
            merchant.location.coordinates[1] + (Math.random() * 0.02 - 0.01)
          ]
        },
        contactPhone: merchant.contactPhone,
        businessHours: merchant.businessHours,
        status: 'active',
        createdAt: new Date(),
        updatedAt: new Date()
      });
      
      await store.save();
      stores.push(store);
    }
  }
  
  console.log(`已创建 ${stores.length} 个门店`);
  return stores;
};

/**
 * 创建示例菜品
 */
const createDishes = async () => {
  const dishesData = [
    {
      name: '蛋白质能量碗',
      description: '高蛋白、低脂肪，含鸡胸肉、藜麦、牛油果等健康食材',
      category: 'main',
      price: 48,
      nutritionInfo: {
        calories: 450,
        protein: 35,
        carbs: 45,
        fat: 15,
        fiber: 8,
        sugars: 5,
        sodium: 300
      },
      ingredients: ['鸡胸肉', '藜麦', '牛油果', '西兰花', '胡萝卜'],
      tags: ['高蛋白', '低脂肪', '健身餐'],
      isRecommended: true,
      isVegetarian: false,
      isVegan: false,
      isGlutenFree: true
    },
    {
      name: '鲜蔬沙拉',
      description: '新鲜蔬菜沙拉，配以特制低脂酱料',
      category: 'appetizer',
      price: 28,
      nutritionInfo: {
        calories: 220,
        protein: 5,
        carbs: 20,
        fat: 12,
        fiber: 6,
        sugars: 8,
        sodium: 250
      },
      ingredients: ['生菜', '樱桃番茄', '黄瓜', '胡萝卜', '橄榄油'],
      tags: ['低卡路里', '素食', '新鲜'],
      isRecommended: true,
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true
    },
    {
      name: '三文鱼牛油果沙拉',
      description: '挪威三文鱼搭配牛油果，富含优质脂肪和蛋白质',
      category: 'main',
      price: 58,
      nutritionInfo: {
        calories: 380,
        protein: 25,
        carbs: 15,
        fat: 26,
        fiber: 7,
        sugars: 3,
        sodium: 350
      },
      ingredients: ['三文鱼', '牛油果', '生菜', '柠檬汁', '橄榄油'],
      tags: ['富含omega-3', '高蛋白', '健康脂肪'],
      isRecommended: true,
      isVegetarian: false,
      isVegan: false,
      isGlutenFree: true
    },
    {
      name: '蒸鸡胸藜麦饭',
      description: '低脂肪高蛋白的健身餐，搭配藜麦和时令蔬菜',
      category: 'main',
      price: 42,
      nutritionInfo: {
        calories: 420,
        protein: 38,
        carbs: 40,
        fat: 10,
        fiber: 6,
        sugars: 2,
        sodium: 280
      },
      ingredients: ['鸡胸肉', '藜麦', '西兰花', '胡萝卜', '杏仁'],
      tags: ['高蛋白', '低脂肪', '健身餐'],
      isRecommended: true,
      isVegetarian: false,
      isVegan: false,
      isGlutenFree: true
    },
    {
      name: '水果能量杯',
      description: '新鲜水果与酸奶、燕麦的完美结合，提供持久能量',
      category: 'dessert',
      price: 25,
      nutritionInfo: {
        calories: 280,
        protein: 8,
        carbs: 45,
        fat: 6,
        fiber: 5,
        sugars: 25,
        sodium: 50
      },
      ingredients: ['希腊酸奶', '燕麦', '蓝莓', '草莓', '香蕉', '蜂蜜'],
      tags: ['健康甜点', '能量补充', '高纤维'],
      isRecommended: true,
      isVegetarian: true,
      isVegan: false,
      isGlutenFree: false
    }
  ];
  
  const dishes = [];
  for (const data of dishesData) {
    const dish = new Dish({
      ...data,
      imageUrl: `/images/dishes/${data.name.replace(/\s+/g, '_').toLowerCase()}.jpg`, // 虚拟的图片URL
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await dish.save();
    dishes.push(dish);
  }
  
  console.log(`已创建 ${dishes.length} 个菜品`);
  return dishes;
};

/**
 * 创建门店菜品关联
 */
const createStoreDishes = async (stores, dishes) => {
  // 为每个门店分配菜品
  for (const store of stores) {
    // 随机选择3-5个菜品
    const selectedDishes = [...dishes].sort(() => Math.random() - 0.5).slice(0, Math.floor(Math.random() * 3) + 3);
    
    for (const dish of selectedDishes) {
      const storeDish = new StoreDish({
        store_id: store._id,
        dish_id: dish._id,
        price: dish.price * (0.9 + Math.random() * 0.2), // 价格有小幅浮动
        availability: true,
        stockStatus: Math.random() > 0.2 ? 'in_stock' : 'limited',
        createdAt: new Date(),
        updatedAt: new Date()
      });
      
      await storeDish.save();
    }
  }
  
  console.log('门店菜品关联创建完成');
};

/**
 * 创建示例订单
 */
const createOrders = async (users, stores, dishes) => {
  // 为每个用户创建2-4个订单
  const orders = [];
  
  for (const user of users) {
    const orderCount = Math.floor(Math.random() * 3) + 2;
    
    for (let i = 0; i < orderCount; i++) {
      // 随机选择一个店铺
      const store = stores[Math.floor(Math.random() * stores.length)];
      
      // 随机选择1-3个菜品
      const orderDishCount = Math.floor(Math.random() * 3) + 1;
      const selectedDishes = [...dishes].sort(() => Math.random() - 0.5).slice(0, orderDishCount);
      
      const items = [];
      let totalAmount = 0;
      let totalCalories = 0;
      
      for (const dish of selectedDishes) {
        const quantity = Math.floor(Math.random() * 2) + 1;
        const itemTotal = dish.price * quantity;
        totalAmount += itemTotal;
        totalCalories += dish.nutritionInfo.calories * quantity;
        
        items.push({
          dish_id: dish._id,
          name: dish.name,
          price: dish.price,
          quantity: quantity,
          subtotal: itemTotal,
          nutritionInfo: dish.nutritionInfo
        });
      }
      
      // 创建订单，随机设置时间在过去30天内
      const orderDate = new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000);
      
      const order = new Order({
        user_id: user._id,
        store_id: store._id,
        merchant_id: store.merchant_id,
        orderNumber: `ORD${Date.now().toString().substr(-10)}${Math.floor(Math.random() * 1000)}`,
        items: items,
        totalAmount: totalAmount,
        totalCalories: totalCalories,
        status: ['pending', 'processing', 'completed'][Math.floor(Math.random() * 3)],
        paymentStatus: Math.random() > 0.1 ? 'paid' : 'pending',
        paymentMethod: ['wechat', 'alipay', 'creditcard'][Math.floor(Math.random() * 3)],
        deliveryAddress: user.address || '深圳市南山区科技园',
        deliveryTime: new Date(orderDate.getTime() + 30 * 60 * 1000), // 30分钟后送达
        remark: '',
        createdAt: orderDate,
        updatedAt: orderDate
      });
      
      await order.save();
      orders.push(order);
    }
  }
  
  console.log(`已创建 ${orders.length} 个订单`);
  return orders;
};

/**
 * 创建示例营养师
 */
const createNutritionists = async () => {
  const nutritionistsData = [
    {
      name: '王营养',
      qualification: '国家注册营养师',
      specialization: ['减重管理', '运动营养'],
      experience: 5,
      bio: '专注于减重和运动营养指导，帮助客户科学减脂增肌',
      contactEmail: 'wang@example.com',
      contactPhone: '13911112222',
      rating: 4.8,
      reviewCount: 126
    },
    {
      name: '李健康',
      qualification: '临床营养师',
      specialization: ['慢性病管理', '孕产营养'],
      experience: 8,
      bio: '擅长慢性病的营养干预和孕产期营养指导',
      contactEmail: 'li@example.com',
      contactPhone: '13922223333',
      rating: 4.9,
      reviewCount: 215
    }
  ];
  
  const nutritionists = [];
  for (const data of nutritionistsData) {
    const nutritionist = new Nutritionist({
      ...data,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await nutritionist.save();
    nutritionists.push(nutritionist);
  }
  
  console.log(`已创建 ${nutritionists.length} 个营养师`);
  return nutritionists;
};

/**
 * 创建示例咨询记录
 */
const createConsultations = async (users, nutritionists) => {
  const consultations = [];
  
  // 为每个用户创建0-2个咨询记录
  for (const user of users) {
    const consultationCount = Math.floor(Math.random() * 3);
    
    for (let i = 0; i < consultationCount; i++) {
      // 随机选择一个营养师
      const nutritionist = nutritionists[Math.floor(Math.random() * nutritionists.length)];
      
      // 随机设置时间在过去60天内
      const consultDate = new Date(Date.now() - Math.floor(Math.random() * 60) * 24 * 60 * 60 * 1000);
      
      const consultation = new Consultation({
        user_id: user._id,
        nutritionist_id: nutritionist._id,
        date: consultDate,
        duration: 30 + Math.floor(Math.random() * 30), // 30-60分钟
        type: ['online', 'in_person'][Math.floor(Math.random() * 2)],
        status: ['scheduled', 'completed', 'cancelled'][Math.floor(Math.random() * 3)],
        notes: '讨论饮食计划和减重目标',
        recommendations: '增加蛋白质摄入，控制碳水化合物，每天摄入2000卡路里',
        followUpDate: new Date(consultDate.getTime() + 14 * 24 * 60 * 60 * 1000), // 两周后复诊
        createdAt: new Date(consultDate.getTime() - 7 * 24 * 60 * 60 * 1000), // 一周前预约
        updatedAt: consultDate
      });
      
      await consultation.save();
      consultations.push(consultation);
    }
  }
  
  console.log(`已创建 ${consultations.length} 个咨询记录`);
  return consultations;
};

/**
 * 创建论坛帖子和评论
 */
const createForumContent = async (users) => {
  const forumTopics = [
    {
      title: '如何科学减脂不反弹？',
      content: '最近开始健身，想了解一下大家有什么科学的减脂方法，不容易反弹的那种。我目前的情况是...',
      tags: ['减脂', '健身', '饮食']
    },
    {
      title: '增肌期的营养搭配',
      content: '各位健友，请问增肌期应该如何安排饮食？蛋白质、碳水和脂肪的比例是多少比较合适？',
      tags: ['增肌', '蛋白质', '营养']
    },
    {
      title: '分享我的一周健康食谱',
      content: '经过三个月的实践，我总结了一套适合上班族的健康食谱，早餐、午餐、晚餐都有，分享给大家...',
      tags: ['食谱', '健康饮食', '分享']
    }
  ];
  
  const posts = [];
  
  // 创建论坛帖子
  for (const topic of forumTopics) {
    // 随机选择一个用户作为发帖人
    const author = users[Math.floor(Math.random() * users.length)];
    
    // 随机设置发帖时间在过去90天内
    const postDate = new Date(Date.now() - Math.floor(Math.random() * 90) * 24 * 60 * 60 * 1000);
    
    const post = new ForumPost({
      user_id: author._id,
      title: topic.title,
      content: topic.content,
      tags: topic.tags,
      viewCount: Math.floor(Math.random() * 500) + 50,
      likeCount: Math.floor(Math.random() * 50),
      commentCount: 0, // 稍后更新
      isSticky: false,
      isRecommended: Math.random() > 0.7,
      status: 'published',
      createdAt: postDate,
      updatedAt: postDate
    });
    
    await post.save();
    posts.push(post);
    
    // 为每个帖子创建2-5条评论
    const commentCount = Math.floor(Math.random() * 4) + 2;
    
    for (let i = 0; i < commentCount; i++) {
      // 随机选择一个用户作为评论者
      const commenter = users[Math.floor(Math.random() * users.length)];
      
      // 随机设置评论时间在发帖时间之后
      const commentDate = new Date(postDate.getTime() + Math.floor(Math.random() * (Date.now() - postDate.getTime())));
      
      const comment = new ForumComment({
        post_id: post._id,
        user_id: commenter._id,
        content: `这是对《${topic.title}》的评论，提供了一些建议和看法...`,
        likeCount: Math.floor(Math.random() * 10),
        createdAt: commentDate,
        updatedAt: commentDate
      });
      
      await comment.save();
    }
    
    // 更新帖子的评论数
    post.commentCount = commentCount;
    await post.save();
  }
  
  console.log(`已创建 ${posts.length} 个论坛帖子和相关评论`);
  return posts;
};

/**
 * 创建AI推荐记录
 */
const createAiRecommendations = async (users, dishes) => {
  const recommendations = [];
  
  // 为每个用户创建1-2个AI推荐
  for (const user of users) {
    const recCount = Math.floor(Math.random() * 2) + 1;
    
    for (let i = 0; i < recCount; i++) {
      // 随机选择3个菜品
      const recommendedDishes = [...dishes].sort(() => Math.random() - 0.5).slice(0, 3);
      
      // 随机设置推荐时间在过去30天内
      const recDate = new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000);
      
      const recommendation = new AiRecommendation({
        user_id: user._id,
        recommendationType: ['meal', 'dish', 'nutrition_plan'][Math.floor(Math.random() * 3)],
        recommendations: recommendedDishes.map(dish => ({
          dish_id: dish._id,
          name: dish.name,
          score: Math.floor(Math.random() * 20) + 80, // 80-100的匹配分数
          reason: '根据您的营养需求和口味偏好推荐'
        })),
        nutritionSummary: {
          calories: Math.floor(Math.random() * 500) + 1500, // 1500-2000卡路里
          protein: Math.floor(Math.random() * 30) + 60, // 60-90克蛋白质
          carbs: Math.floor(Math.random() * 50) + 150, // 150-200克碳水
          fat: Math.floor(Math.random() * 20) + 40, // 40-60克脂肪
        },
        userFeedback: Math.random() > 0.3 ? {
          rating: Math.floor(Math.random() * 3) + 3, // 3-5星评分
          comments: '推荐的菜品很符合我的口味和健康需求'
        } : null,
        createdAt: recDate,
        updatedAt: recDate
      });
      
      await recommendation.save();
      recommendations.push(recommendation);
    }
  }
  
  console.log(`已创建 ${recommendations.length} 个AI推荐`);
  return recommendations;
};

/**
 * 创建商家统计数据
 */
const createMerchantStats = async (merchants) => {
  // 为每个商家创建过去7天的统计数据
  for (const merchant of merchants) {
    for (let i = 0; i < 7; i++) {
      const statDate = new Date(Date.now() - i * 24 * 60 * 60 * 1000);
      const dateString = statDate.toISOString().split('T')[0]; // YYYY-MM-DD格式
      
      const stats = new MerchantStats({
        merchant_id: merchant._id,
        date: dateString,
        statistics: {
          orderCount: Math.floor(Math.random() * 50) + 10,
          totalRevenue: Math.floor(Math.random() * 5000) + 1000,
          averageOrderValue: Math.floor(Math.random() * 100) + 50,
          newCustomerCount: Math.floor(Math.random() * 10) + 1,
          topSellingDishes: [], // 简化处理，不填充实际数据
          peakHours: {
            morning: Math.floor(Math.random() * 20) + 5,
            noon: Math.floor(Math.random() * 30) + 20,
            evening: Math.floor(Math.random() * 25) + 15
          }
        },
        createdAt: new Date(),
        updatedAt: new Date()
      });
      
      await stats.save();
    }
  }
  
  console.log(`已为 ${merchants.length} 个商家创建统计数据`);
};

// 执行数据生成
generateSampleData()
  .then(() => {
    console.log('示例数据生成脚本执行完成');
    process.exit(0);
  })
  .catch(error => {
    console.error('示例数据生成脚本执行失败:', error);
    process.exit(1);
  }); 