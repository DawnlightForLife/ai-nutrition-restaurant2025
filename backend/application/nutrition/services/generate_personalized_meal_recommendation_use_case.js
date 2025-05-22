/**
 * 生成个性化餐品推荐用例
 * 协调营养领域、用户领域和餐厅领域，生成个性化餐品推荐
 */
class GeneratePersonalizedMealRecommendationUseCase {
  /**
   * @param {Object} dependencies - 依赖注入
   * @param {import('../../../domain/user/repositories/user_repository')} dependencies.userRepository - 用户仓储
   * @param {import('../../../domain/nutrition/repositories/nutrition_profile_repository')} dependencies.nutritionProfileRepository - 营养档案仓储
   * @param {import('../../../domain/nutrition/repositories/diet_preference_repository')} dependencies.dietPreferenceRepository - 饮食偏好仓储
   * @param {import('../../../domain/nutrition/repositories/meal_repository')} dependencies.mealRepository - 餐品仓储
   * @param {import('../../../domain/nutrition/services/ai_recommendation_service')} dependencies.aiRecommendationService - AI推荐服务
   * @param {import('../../../domain/restaurant/repositories/restaurant_repository')} dependencies.restaurantRepository - 餐厅仓储
   * @param {import('../../../domain/order/repositories/order_repository')} dependencies.orderRepository - 订单仓储
   */
  constructor({
    userRepository,
    nutritionProfileRepository,
    dietPreferenceRepository,
    mealRepository,
    aiRecommendationService,
    restaurantRepository,
    orderRepository
  }) {
    this._userRepository = userRepository;
    this._nutritionProfileRepository = nutritionProfileRepository;
    this._dietPreferenceRepository = dietPreferenceRepository;
    this._mealRepository = mealRepository;
    this._aiRecommendationService = aiRecommendationService;
    this._restaurantRepository = restaurantRepository;
    this._orderRepository = orderRepository;
  }

  /**
   * 生成个性化餐品推荐
   * @param {string} userId - 用户ID
   * @param {Object} options - 推荐选项
   * @param {string} options.mealType - 餐品类型（早餐、午餐、晚餐、小食）
   * @param {number} options.calorieTarget - 目标卡路里（可选）
   * @param {Array<string>} options.preferredRestaurantIds - 偏好餐厅ID列表（可选）
   * @param {boolean} options.considerOrderHistory - 是否考虑订单历史（可选，默认true）
   * @returns {Promise<Object>} 餐品推荐结果
   */
  async execute(userId, options) {
    // 1. 验证用户存在并获取用户信息
    const user = await this._userRepository.findById(userId);
    if (!user) {
      throw new Error('用户不存在');
    }

    // 2. 获取用户营养档案
    const nutritionProfile = await this._nutritionProfileRepository.findByUserId(userId);
    if (!nutritionProfile) {
      throw new Error('用户尚未完成营养档案');
    }

    // 3. 获取用户饮食偏好
    const dietPreference = await this._dietPreferenceRepository.findByUserId(userId);
    if (!dietPreference) {
      throw new Error('用户尚未设置饮食偏好');
    }

    // 4. 如果需要考虑历史订单，则获取用户历史订单数据
    let orderHistory = [];
    if (options.considerOrderHistory !== false) {
      const recentOrders = await this._orderRepository.findRecentByUserId(userId, 10);
      orderHistory = recentOrders.map(order => ({
        orderId: order.id,
        items: order.items.map(item => ({
          mealId: item.mealId,
          name: item.name,
          quantity: item.quantity
        })),
        orderDate: order.orderDate
      }));
    }

    // 5. 获取偏好餐厅详情（如果指定了偏好餐厅）
    let preferredRestaurants = [];
    if (options.preferredRestaurantIds && options.preferredRestaurantIds.length > 0) {
      preferredRestaurants = await Promise.all(
        options.preferredRestaurantIds.map(id => this._restaurantRepository.findById(id))
      );
      preferredRestaurants = preferredRestaurants.filter(r => r !== null);
    }

    // 6. 准备AI推荐输入数据
    const recommendationInput = {
      user: {
        id: user.id,
        gender: nutritionProfile.gender,
        age: nutritionProfile.age,
        weight: nutritionProfile.weight,
        height: nutritionProfile.height,
        activityLevel: nutritionProfile.activityLevel,
        healthGoals: nutritionProfile.healthGoals,
        medicalConditions: nutritionProfile.medicalConditions
      },
      dietPreferences: {
        cuisinePreferences: dietPreference.cuisinePreferences,
        excludedIngredients: dietPreference.excludedIngredients,
        allergens: dietPreference.allergens,
        dietaryRestrictions: dietPreference.dietaryRestrictions,
        mealPreferences: dietPreference.mealPreferences
      },
      mealType: options.mealType,
      calorieTarget: options.calorieTarget || this._calculateDefaultCalorieTarget(
        nutritionProfile,
        options.mealType
      ),
      orderHistory: orderHistory,
      preferredRestaurants: preferredRestaurants.map(r => ({
        id: r.id,
        name: r.name,
        cuisineType: r.cuisineType
      }))
    };

    // 7. 调用AI推荐服务生成推荐
    const recommendationResult = await this._aiRecommendationService.generateMealRecommendations(
      recommendationInput
    );

    // 8. 获取推荐餐品的详细信息
    const recommendedMeals = await Promise.all(
      recommendationResult.recommendedMealIds.map(id => this._mealRepository.findById(id))
    );

    // 9. 处理并返回推荐结果
    return {
      recommendations: recommendedMeals.filter(meal => meal !== null).map(meal => ({
        meal: meal.toJSON(),
        matchScore: recommendationResult.matchScores[meal.id] || 0,
        nutritionFit: recommendationResult.nutritionFit[meal.id] || 0,
        preferenceFit: recommendationResult.preferenceFit[meal.id] || 0,
        reasoningExplanation: recommendationResult.explanations[meal.id] || ''
      })),
      targetNutrition: recommendationResult.targetNutrition,
      generatedAt: new Date().toISOString(),
      alternativeOptions: recommendationResult.alternativeCategories || []
    };
  }

  /**
   * 计算默认卡路里目标
   * @private
   */
  _calculateDefaultCalorieTarget(nutritionProfile, mealType) {
    // 基于营养档案中的数据计算每日卡路里需求
    let dailyCalories;
    
    // 简化的BMR计算（基础代谢率）
    if (nutritionProfile.gender === 'MALE') {
      dailyCalories = 10 * nutritionProfile.weight + 6.25 * nutritionProfile.height - 5 * nutritionProfile.age + 5;
    } else {
      dailyCalories = 10 * nutritionProfile.weight + 6.25 * nutritionProfile.height - 5 * nutritionProfile.age - 161;
    }
    
    // 根据活动水平调整
    const activityMultipliers = {
      SEDENTARY: 1.2,
      LIGHTLY_ACTIVE: 1.375,
      MODERATELY_ACTIVE: 1.55,
      VERY_ACTIVE: 1.725,
      EXTREMELY_ACTIVE: 1.9
    };
    
    dailyCalories *= activityMultipliers[nutritionProfile.activityLevel] || 1.2;
    
    // 根据健康目标进一步调整
    if (nutritionProfile.healthGoals.includes('WEIGHT_LOSS')) {
      dailyCalories *= 0.8; // 减少20%卡路里摄入以促进减重
    } else if (nutritionProfile.healthGoals.includes('WEIGHT_GAIN')) {
      dailyCalories *= 1.15; // 增加15%卡路里摄入以促进增重
    }
    
    // 根据餐食类型分配卡路里
    const mealDistribution = {
      BREAKFAST: 0.25,
      LUNCH: 0.35,
      DINNER: 0.30,
      SNACK: 0.10
    };
    
    return Math.round(dailyCalories * (mealDistribution[mealType] || 0.3));
  }
}

module.exports = GeneratePersonalizedMealRecommendationUseCase; 