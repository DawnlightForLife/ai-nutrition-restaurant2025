/**
 * 餐品应用服务
 * 协调餐品领域对象实现业务用例
 */
class MealService {
  /**
   * @param {Object} repositories - 仓储集合
   * @param {import('../../../domain/nutrition/repositories/meal_repository')} repositories.mealRepository - 餐品仓储
   */
  constructor({ mealRepository }) {
    this._mealRepository = mealRepository;
  }

  /**
   * 创建新餐品
   * @param {Object} mealData - 餐品数据
   * @returns {Promise<Object>} 创建的餐品
   */
  async createMeal(mealData) {
    // 从领域层导入所需的实体和值对象
    const Meal = require('../../../domain/nutrition/entities/meal');
    const MealNutritionInfo = require('../../../domain/nutrition/value_objects/meal_nutrition_info');
    
    // 创建营养信息值对象
    const nutritionInfo = new MealNutritionInfo(
      mealData.calories,
      mealData.protein,
      mealData.carbohydrates,
      mealData.fat,
      mealData.fiber,
      mealData.sugar,
      mealData.sodium,
      mealData.vitamins,
      mealData.minerals
    );
    
    // 创建餐品实体
    const meal = Meal.create(
      mealData.name,
      mealData.description,
      mealData.price,
      mealData.imageUrls,
      mealData.categoryId,
      nutritionInfo,
      mealData.isFeatured,
      mealData.isRecommended,
      mealData.tags
    );
    
    // 保存到仓储
    const savedMeal = await this._mealRepository.save(meal);
    
    // 返回JSON表示
    return savedMeal.toJSON();
  }

  /**
   * 获取餐品详情
   * @param {string} id - 餐品ID
   * @returns {Promise<Object>} 餐品详情
   */
  async getMeal(id) {
    const meal = await this._mealRepository.findById(id);
    if (!meal) {
      throw new Error('餐品不存在');
    }
    return meal.toJSON();
  }

  /**
   * 更新餐品信息
   * @param {string} id - 餐品ID
   * @param {Object} updateData - 更新数据
   * @returns {Promise<Object>} 更新后的餐品
   */
  async updateMeal(id, updateData) {
    // 获取餐品
    const meal = await this._mealRepository.findById(id);
    if (!meal) {
      throw new Error('餐品不存在');
    }
    
    // 如果有营养信息更新，创建新的营养信息值对象
    let nutritionInfo = meal.nutritionInfo;
    if (updateData.nutritionInfo) {
      const MealNutritionInfo = require('../../../domain/nutrition/value_objects/meal_nutrition_info');
      nutritionInfo = new MealNutritionInfo(
        updateData.nutritionInfo.calories !== undefined ? updateData.nutritionInfo.calories : meal.nutritionInfo.calories,
        updateData.nutritionInfo.protein !== undefined ? updateData.nutritionInfo.protein : meal.nutritionInfo.protein,
        updateData.nutritionInfo.carbohydrates !== undefined ? updateData.nutritionInfo.carbohydrates : meal.nutritionInfo.carbohydrates,
        updateData.nutritionInfo.fat !== undefined ? updateData.nutritionInfo.fat : meal.nutritionInfo.fat,
        updateData.nutritionInfo.fiber !== undefined ? updateData.nutritionInfo.fiber : meal.nutritionInfo.fiber,
        updateData.nutritionInfo.sugar !== undefined ? updateData.nutritionInfo.sugar : meal.nutritionInfo.sugar,
        updateData.nutritionInfo.sodium !== undefined ? updateData.nutritionInfo.sodium : meal.nutritionInfo.sodium,
        updateData.nutritionInfo.vitamins || meal.nutritionInfo.vitamins,
        updateData.nutritionInfo.minerals || meal.nutritionInfo.minerals
      );
    }
    
    // 准备更新数据
    const updateDataWithNutrition = {
      ...updateData,
      nutritionInfo
    };
    
    // 执行更新
    const updatedMeal = meal.update(updateDataWithNutrition);
    
    // 保存到仓储
    const savedMeal = await this._mealRepository.save(updatedMeal);
    
    // 返回JSON表示
    return savedMeal.toJSON();
  }

  /**
   * 获取推荐餐品列表
   * @param {number} limit - 返回数量限制
   * @returns {Promise<Array<Object>>} 推荐餐品列表
   */
  async getRecommendedMeals(limit = 10) {
    const meals = await this._mealRepository.findRecommended(limit);
    return meals.map(meal => meal.toJSON());
  }

  /**
   * 获取特色餐品列表
   * @param {number} limit - 返回数量限制
   * @returns {Promise<Array<Object>>} 特色餐品列表
   */
  async getFeaturedMeals(limit = 10) {
    const meals = await this._mealRepository.findFeatured(limit);
    return meals.map(meal => meal.toJSON());
  }

  /**
   * 根据营养标准筛选餐品
   * @param {Object} criteria - 筛选条件
   * @returns {Promise<Array<Object>>} 餐品列表
   */
  async findMealsByNutrition(criteria) {
    const meals = await this._mealRepository.findByNutritionCriteria(criteria);
    return meals.map(meal => meal.toJSON());
  }
}

module.exports = MealService; 