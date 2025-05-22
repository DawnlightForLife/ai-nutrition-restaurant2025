/**
 * 餐品营养信息值对象
 * 描述餐品的营养成分信息
 */
class MealNutritionInfo {
  /**
   * @param {number} calories - 卡路里 (kcal)
   * @param {number} protein - 蛋白质 (g)
   * @param {number} carbohydrates - 碳水化合物 (g)
   * @param {number} fat - 脂肪 (g)
   * @param {number} fiber - 膳食纤维 (g)
   * @param {number} sugar - 糖 (g)
   * @param {number} sodium - 钠 (mg)
   * @param {Object} [vitamins={}] - 维生素含量
   * @param {Object} [minerals={}] - 矿物质含量
   */
  constructor(
    calories,
    protein,
    carbohydrates,
    fat,
    fiber,
    sugar,
    sodium,
    vitamins = {},
    minerals = {}
  ) {
    this._validateNutrients(calories, protein, carbohydrates, fat, fiber, sugar, sodium);

    this._calories = calories;
    this._protein = protein;
    this._carbohydrates = carbohydrates;
    this._fat = fat;
    this._fiber = fiber;
    this._sugar = sugar;
    this._sodium = sodium;
    this._vitamins = vitamins;
    this._minerals = minerals;
  }

  /**
   * 验证营养成分数值是否合法
   * @private
   */
  _validateNutrients(calories, protein, carbohydrates, fat, fiber, sugar, sodium) {
    if (
      calories < 0 ||
      protein < 0 ||
      carbohydrates < 0 ||
      fat < 0 ||
      fiber < 0 ||
      sugar < 0 ||
      sodium < 0
    ) {
      throw new Error('营养成分值不能为负数');
    }
  }

  get calories() {
    return this._calories;
  }

  get protein() {
    return this._protein;
  }

  get carbohydrates() {
    return this._carbohydrates;
  }

  get fat() {
    return this._fat;
  }

  get fiber() {
    return this._fiber;
  }

  get sugar() {
    return this._sugar;
  }

  get sodium() {
    return this._sodium;
  }

  get vitamins() {
    return { ...this._vitamins };
  }

  get minerals() {
    return { ...this._minerals };
  }

  /**
   * 计算宏量营养素分布百分比
   * @returns {Object} 宏量营养素百分比分布
   */
  getMacroDistribution() {
    const totalMacroGrams = this._protein + this._carbohydrates + this._fat;
    if (totalMacroGrams === 0) return { protein: 0, carbohydrates: 0, fat: 0 };

    return {
      protein: (this._protein / totalMacroGrams) * 100,
      carbohydrates: (this._carbohydrates / totalMacroGrams) * 100,
      fat: (this._fat / totalMacroGrams) * 100,
    };
  }

  /**
   * 转换为JSON
   * @returns {Object} JSON表示
   */
  toJSON() {
    return {
      calories: this._calories,
      protein: this._protein,
      carbohydrates: this._carbohydrates,
      fat: this._fat,
      fiber: this._fiber,
      sugar: this._sugar,
      sodium: this._sodium,
      vitamins: this._vitamins,
      minerals: this._minerals,
    };
  }

  /**
   * 从JSON创建实例
   * @param {Object} json - JSON数据
   * @returns {MealNutritionInfo} 新实例
   */
  static fromJSON(json) {
    return new MealNutritionInfo(
      json.calories,
      json.protein,
      json.carbohydrates,
      json.fat,
      json.fiber,
      json.sugar,
      json.sodium,
      json.vitamins,
      json.minerals
    );
  }
}

module.exports = MealNutritionInfo; 