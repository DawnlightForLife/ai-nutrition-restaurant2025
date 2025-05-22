const MealRepository = require('../../domain/nutrition/repositories/meal_repository');
const Meal = require('../../domain/nutrition/entities/meal');
const MealNutritionInfo = require('../../domain/nutrition/value_objects/meal_nutrition_info');

/**
 * MongoDB餐品仓储实现
 */
class MongoDBMealRepository extends MealRepository {
  /**
   * @param {Object} options - 选项
   * @param {import('mongoose').Model} options.mealModel - Mongoose餐品模型
   */
  constructor({ mealModel }) {
    super();
    this._mealModel = mealModel;
  }

  /**
   * 将数据库模型转换为领域实体
   * @param {Object} dbModel - 数据库模型
   * @returns {Meal} 餐品领域实体
   * @private
   */
  _toDomainEntity(dbModel) {
    if (!dbModel) return null;
    
    // 转换为普通对象
    const data = dbModel.toObject ? dbModel.toObject() : dbModel;
    
    // 创建营养信息值对象
    const nutritionInfo = new MealNutritionInfo(
      data.nutritionInfo.calories,
      data.nutritionInfo.protein,
      data.nutritionInfo.carbohydrates,
      data.nutritionInfo.fat,
      data.nutritionInfo.fiber,
      data.nutritionInfo.sugar,
      data.nutritionInfo.sodium,
      data.nutritionInfo.vitamins,
      data.nutritionInfo.minerals
    );
    
    // 创建餐品实体
    return new Meal(
      data._id.toString(),
      data.name,
      data.description,
      data.price,
      data.imageUrls,
      data.categoryId,
      nutritionInfo,
      data.isFeatured,
      data.isRecommended,
      data.tags,
      data.rating,
      data.reviewCount,
      new Date(data.createdAt),
      new Date(data.updatedAt)
    );
  }

  /**
   * 将领域实体转换为数据库模型
   * @param {Meal} domainEntity - 领域实体
   * @returns {Object} 数据库模型数据
   * @private
   */
  _toPersistence(domainEntity) {
    const data = domainEntity.toJSON();
    
    // 调整字段名以适应数据库模型
    return {
      ...data,
      _id: data.id  // MongoDB使用_id作为主键
    };
  }

  /**
   * 保存餐品
   * @param {Meal} meal - 餐品实体
   * @returns {Promise<Meal>} 保存后的餐品实体
   */
  async save(meal) {
    const persistenceData = this._toPersistence(meal);
    
    // 创建或更新餐品
    const result = await this._mealModel.findByIdAndUpdate(
      persistenceData._id,
      persistenceData,
      { new: true, upsert: true, setDefaultsOnInsert: true }
    );
    
    return this._toDomainEntity(result);
  }

  /**
   * 根据ID查找餐品
   * @param {string} id - 餐品ID
   * @returns {Promise<Meal>} 餐品实体，如果不存在则返回null
   */
  async findById(id) {
    const result = await this._mealModel.findById(id);
    return this._toDomainEntity(result);
  }

  /**
   * 删除餐品
   * @param {string} id - 餐品ID
   * @returns {Promise<boolean>} 是否成功删除
   */
  async delete(id) {
    const result = await this._mealModel.findByIdAndDelete(id);
    return !!result;
  }

  /**
   * 查找所有餐品
   * @returns {Promise<Array<Meal>>} 餐品实体列表
   */
  async findAll() {
    const results = await this._mealModel.find({});
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 根据分类ID查找餐品
   * @param {string} categoryId - 分类ID
   * @returns {Promise<Array<Meal>>} 餐品实体列表
   */
  async findByCategoryId(categoryId) {
    const results = await this._mealModel.find({ categoryId });
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 查找特色餐品
   * @param {number} limit - 返回结果数量限制
   * @returns {Promise<Array<Meal>>} 特色餐品实体列表
   */
  async findFeatured(limit = 10) {
    const results = await this._mealModel.find({ isFeatured: true }).limit(limit);
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 查找推荐餐品
   * @param {number} limit - 返回结果数量限制
   * @returns {Promise<Array<Meal>>} 推荐餐品实体列表
   */
  async findRecommended(limit = 10) {
    const results = await this._mealModel.find({ isRecommended: true }).limit(limit);
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 根据营养指标查找餐品
   * @param {Object} criteria - 营养筛选条件
   * @returns {Promise<Array<Meal>>} 符合条件的餐品实体列表
   */
  async findByNutritionCriteria(criteria) {
    // 构建查询条件
    const query = {};
    
    if (criteria.minCalories !== undefined) {
      query['nutritionInfo.calories'] = { $gte: criteria.minCalories };
    }
    
    if (criteria.maxCalories !== undefined) {
      query['nutritionInfo.calories'] = { ...query['nutritionInfo.calories'], $lte: criteria.maxCalories };
    }
    
    if (criteria.minProtein !== undefined) {
      query['nutritionInfo.protein'] = { $gte: criteria.minProtein };
    }
    
    if (criteria.maxProtein !== undefined) {
      query['nutritionInfo.protein'] = { ...query['nutritionInfo.protein'], $lte: criteria.maxProtein };
    }
    
    if (criteria.minCarbs !== undefined) {
      query['nutritionInfo.carbohydrates'] = { $gte: criteria.minCarbs };
    }
    
    if (criteria.maxCarbs !== undefined) {
      query['nutritionInfo.carbohydrates'] = { ...query['nutritionInfo.carbohydrates'], $lte: criteria.maxCarbs };
    }
    
    if (criteria.minFat !== undefined) {
      query['nutritionInfo.fat'] = { $gte: criteria.minFat };
    }
    
    if (criteria.maxFat !== undefined) {
      query['nutritionInfo.fat'] = { ...query['nutritionInfo.fat'], $lte: criteria.maxFat };
    }
    
    const results = await this._mealModel.find(query);
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 根据标签查找餐品
   * @param {Array<string>} tags - 标签列表
   * @returns {Promise<Array<Meal>>} 餐品实体列表
   */
  async findByTags(tags) {
    const results = await this._mealModel.find({ tags: { $in: tags } });
    return results.map(result => this._toDomainEntity(result));
  }

  /**
   * 搜索餐品
   * @param {string} keyword - 搜索关键词
   * @returns {Promise<Array<Meal>>} 餐品实体列表
   */
  async search(keyword) {
    const regex = new RegExp(keyword, 'i');
    const results = await this._mealModel.find({
      $or: [
        { name: regex },
        { description: regex },
        { tags: regex }
      ]
    });
    return results.map(result => this._toDomainEntity(result));
  }
}

module.exports = MongoDBMealRepository; 