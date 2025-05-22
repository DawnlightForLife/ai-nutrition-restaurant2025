const Entity = require('../../common/interfaces/entity');
const ID = require('../../common/value_objects/id');
const MealNutritionInfo = require('../value_objects/meal_nutrition_info');

/**
 * 餐品实体
 * 代表餐厅提供的食品
 */
class Meal extends Entity {
  /**
   * @param {string} id - 餐品ID
   * @param {string} name - 餐品名称
   * @param {string} description - 餐品描述
   * @param {number} price - 餐品价格
   * @param {Array<string>} imageUrls - 餐品图片URL列表
   * @param {string} categoryId - 餐品分类ID
   * @param {MealNutritionInfo} nutritionInfo - 餐品营养信息
   * @param {boolean} isFeatured - 是否为特色餐品
   * @param {boolean} isRecommended - 是否为推荐餐品
   * @param {Array<string>} tags - 餐品标签
   * @param {number} rating - 餐品评分
   * @param {number} reviewCount - 评价数量
   * @param {Date} createdAt - 创建时间
   * @param {Date} updatedAt - 更新时间
   */
  constructor(
    id,
    name,
    description,
    price,
    imageUrls,
    categoryId,
    nutritionInfo,
    isFeatured = false,
    isRecommended = false,
    tags = [],
    rating = 0.0,
    reviewCount = 0,
    createdAt = new Date(),
    updatedAt = new Date()
  ) {
    super(id);
    this._validateData(name, description, price);

    this._name = name;
    this._description = description;
    this._price = price;
    this._imageUrls = [...imageUrls];
    this._categoryId = categoryId;
    this._nutritionInfo = nutritionInfo;
    this._isFeatured = isFeatured;
    this._isRecommended = isRecommended;
    this._tags = [...tags];
    this._rating = rating;
    this._reviewCount = reviewCount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  /**
   * 验证数据
   * @private
   */
  _validateData(name, description, price) {
    if (!name || name.trim() === '') {
      throw new Error('餐品名称不能为空');
    }

    if (!description) {
      throw new Error('餐品描述不能为空');
    }

    if (price < 0) {
      throw new Error('价格不能为负数');
    }
  }

  /**
   * 创建新餐品
   * @param {string} name - 餐品名称
   * @param {string} description - 餐品描述
   * @param {number} price - 餐品价格
   * @param {Array<string>} imageUrls - 餐品图片URL列表
   * @param {string} categoryId - 餐品分类ID
   * @param {MealNutritionInfo} nutritionInfo - 餐品营养信息
   * @param {boolean} isFeatured - 是否为特色餐品
   * @param {boolean} isRecommended - 是否为推荐餐品
   * @param {Array<string>} tags - 餐品标签
   * @returns {Meal} 新创建的餐品
   */
  static create(
    name,
    description,
    price,
    imageUrls,
    categoryId,
    nutritionInfo,
    isFeatured = false,
    isRecommended = false,
    tags = []
  ) {
    const newId = ID.generate().value;
    const now = new Date();
    return new Meal(
      newId,
      name,
      description,
      price,
      imageUrls,
      categoryId,
      nutritionInfo,
      isFeatured,
      isRecommended,
      tags,
      0.0,
      0,
      now,
      now
    );
  }

  // Getters
  get name() { return this._name; }
  get description() { return this._description; }
  get price() { return this._price; }
  get imageUrls() { return [...this._imageUrls]; }
  get categoryId() { return this._categoryId; }
  get nutritionInfo() { return this._nutritionInfo; }
  get isFeatured() { return this._isFeatured; }
  get isRecommended() { return this._isRecommended; }
  get tags() { return [...this._tags]; }
  get rating() { return this._rating; }
  get reviewCount() { return this._reviewCount; }
  get createdAt() { return this._createdAt; }
  get updatedAt() { return this._updatedAt; }

  /**
   * 更新餐品信息
   * @param {Object} data - 要更新的数据
   * @returns {Meal} 更新后的餐品
   */
  update(data) {
    const name = data.name !== undefined ? data.name : this._name;
    const description = data.description !== undefined ? data.description : this._description;
    const price = data.price !== undefined ? data.price : this._price;
    
    this._validateData(name, description, price);
    
    return new Meal(
      this.id,
      name,
      description,
      price,
      data.imageUrls !== undefined ? data.imageUrls : this._imageUrls,
      data.categoryId !== undefined ? data.categoryId : this._categoryId,
      data.nutritionInfo !== undefined ? data.nutritionInfo : this._nutritionInfo,
      data.isFeatured !== undefined ? data.isFeatured : this._isFeatured,
      data.isRecommended !== undefined ? data.isRecommended : this._isRecommended,
      data.tags !== undefined ? data.tags : this._tags,
      this._rating,
      this._reviewCount,
      this._createdAt,
      new Date()
    );
  }

  /**
   * 添加评分
   * @param {number} newRating - 新的评分(1-5)
   * @returns {Meal} 更新后的餐品
   */
  addRating(newRating) {
    if (newRating < 1 || newRating > 5) {
      throw new Error('评分必须在1到5之间');
    }

    // 计算新的平均评分
    const totalScore = (this._rating * this._reviewCount) + newRating;
    const newCount = this._reviewCount + 1;
    const newAverage = parseFloat((totalScore / newCount).toFixed(1));

    return new Meal(
      this.id,
      this._name,
      this._description,
      this._price,
      this._imageUrls,
      this._categoryId,
      this._nutritionInfo,
      this._isFeatured,
      this._isRecommended,
      this._tags,
      newAverage,
      newCount,
      this._createdAt,
      new Date()
    );
  }

  /**
   * 转换为JSON
   * @returns {Object} JSON表示
   */
  toJSON() {
    return {
      id: this.id,
      name: this._name,
      description: this._description,
      price: this._price,
      imageUrls: this._imageUrls,
      categoryId: this._categoryId,
      nutritionInfo: this._nutritionInfo.toJSON(),
      isFeatured: this._isFeatured,
      isRecommended: this._isRecommended,
      tags: this._tags,
      rating: this._rating,
      reviewCount: this._reviewCount,
      createdAt: this._createdAt.toISOString(),
      updatedAt: this._updatedAt.toISOString()
    };
  }

  /**
   * 从JSON创建实例
   * @param {Object} json - JSON数据
   * @returns {Meal} 新实例
   */
  static fromJSON(json) {
    return new Meal(
      json.id,
      json.name,
      json.description,
      json.price,
      json.imageUrls,
      json.categoryId,
      MealNutritionInfo.fromJSON(json.nutritionInfo),
      json.isFeatured,
      json.isRecommended,
      json.tags,
      json.rating,
      json.reviewCount,
      new Date(json.createdAt),
      new Date(json.updatedAt)
    );
  }
}

module.exports = Meal; 