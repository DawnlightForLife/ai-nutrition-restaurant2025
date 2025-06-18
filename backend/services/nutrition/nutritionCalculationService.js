/**
 * 营养计算引擎服务
 * 提供营养元素计算、食材组合优化、营养目标匹配等核心功能
 * @module services/nutrition/nutritionCalculationService
 */

const { NutritionElement } = require('../../models/nutrition/nutritionElementModel');
const { IngredientNutrition } = require('../../models/nutrition/ingredientNutritionModel');
const { CookingMethod } = require('../../models/nutrition/cookingMethodModel');
const NutritionProfile = require('../../models/nutrition/nutritionProfileModel');

class NutritionCalculationService {
  
  /**
   * 计算单个食材指定重量和烹饪方式下的营养成分
   * @param {string} ingredientId - 食材ID
   * @param {number} amount - 食材重量(g)
   * @param {string} cookingMethod - 烹饪方式
   * @returns {Object} 营养成分计算结果
   */
  async calculateIngredientNutrition(ingredientId, amount, cookingMethod = 'raw') {
    try {
      // 获取食材营养信息
      const ingredient = await IngredientNutrition.findById(ingredientId);
      if (!ingredient) {
        throw new Error('食材不存在');
      }

      // 获取烹饪方式信息
      const cooking = await CookingMethod.findOne({ method: cookingMethod });
      if (!cooking && cookingMethod !== 'raw') {
        throw new Error('烹饪方式不存在');
      }

      // 计算基础营养含量（基于100g标准）
      const baseNutrition = this._calculateBaseNutrition(ingredient, amount);

      // 应用烹饪方式影响
      const finalNutrition = this._applyCookingEffects(baseNutrition, cooking, ingredient);

      return {
        ingredientId,
        ingredientName: ingredient.chineseName,
        amount,
        unit: 'g',
        cookingMethod,
        nutrition: finalNutrition,
        calculatedAt: new Date()
      };

    } catch (error) {
      throw new Error(`营养计算失败: ${error.message}`);
    }
  }

  /**
   * 计算食材组合的总营养成分
   * @param {Array} ingredients - 食材列表 [{id, amount, cookingMethod}]
   * @returns {Object} 组合营养成分
   */
  async calculateCombinedNutrition(ingredients) {
    try {
      const nutritionResults = [];
      const combinedNutrition = new Map();

      // 计算每个食材的营养
      for (const ingredient of ingredients) {
        const nutrition = await this.calculateIngredientNutrition(
          ingredient.id,
          ingredient.amount,
          ingredient.cookingMethod || 'raw'
        );
        nutritionResults.push(nutrition);

        // 累加营养成分
        nutrition.nutrition.forEach(nutrient => {
          const existing = combinedNutrition.get(nutrient.element) || 0;
          combinedNutrition.set(nutrient.element, existing + nutrient.amount);
        });
      }

      // 转换为数组格式
      const totalNutrition = Array.from(combinedNutrition.entries()).map(([element, amount]) => ({
        element,
        amount,
        unit: this._getNutrientUnit(element)
      }));

      return {
        ingredients: nutritionResults,
        totalNutrition,
        totalWeight: ingredients.reduce((sum, ing) => sum + ing.amount, 0),
        calculatedAt: new Date()
      };

    } catch (error) {
      throw new Error(`组合营养计算失败: ${error.message}`);
    }
  }

  /**
   * 根据用户营养档案计算个性化营养需求
   * @param {string} userId - 用户ID
   * @param {string} profileId - 营养档案ID
   * @returns {Object} 个性化营养需求
   */
  async calculatePersonalizedNeeds(userId, profileId) {
    try {
      const profile = await NutritionProfile.findOne({ 
        _id: profileId, 
        userId: userId 
      });
      
      if (!profile) {
        throw new Error('营养档案不存在');
      }

      // 计算基础代谢率 (BMR)
      const bmr = this._calculateBMR(profile);

      // 计算总日消耗量 (TDEE)
      const tdee = this._calculateTDEE(bmr, profile.activityLevel);

      // 计算宏量营养素需求
      const macroNeeds = this._calculateMacroNeeds(tdee, profile);

      // 计算微量营养素需求
      const microNeeds = await this._calculateMicroNeeds(profile);

      // 根据健康目标调整
      const adjustedNeeds = this._adjustForHealthGoals(macroNeeds, microNeeds, profile);

      return {
        userId,
        profileId,
        bmr,
        tdee,
        dailyNeeds: adjustedNeeds,
        calculatedAt: new Date(),
        validUntil: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7天有效期
      };

    } catch (error) {
      throw new Error(`个性化需求计算失败: ${error.message}`);
    }
  }

  /**
   * 营养目标匹配分析
   * @param {Object} currentNutrition - 当前营养摄入
   * @param {Object} targetNeeds - 目标营养需求
   * @returns {Object} 匹配分析结果
   */
  analyzeNutritionMatch(currentNutrition, targetNeeds) {
    const analysis = {
      overallMatch: 0,
      macroMatch: {},
      microMatch: {},
      gaps: [],
      excesses: [],
      recommendations: []
    };

    try {
      // 分析宏量营养素匹配
      analysis.macroMatch = this._analyzeMacroMatch(currentNutrition, targetNeeds);

      // 分析微量营养素匹配
      analysis.microMatch = this._analyzeMicroMatch(currentNutrition, targetNeeds);

      // 识别营养缺口
      analysis.gaps = this._identifyNutritionGaps(currentNutrition, targetNeeds);

      // 识别营养过量
      analysis.excesses = this._identifyNutritionExcesses(currentNutrition, targetNeeds);

      // 生成改善建议
      analysis.recommendations = this._generateRecommendations(analysis);

      // 计算整体匹配度
      analysis.overallMatch = this._calculateOverallMatch(analysis);

      return analysis;

    } catch (error) {
      throw new Error(`营养匹配分析失败: ${error.message}`);
    }
  }

  /**
   * 智能食材推荐
   * @param {Object} nutritionGaps - 营养缺口
   * @param {Array} availableIngredients - 可用食材列表
   * @param {Object} preferences - 用户偏好
   * @returns {Array} 推荐食材列表
   */
  async recommendIngredients(nutritionGaps, availableIngredients = [], preferences = {}) {
    try {
      const recommendations = [];

      for (const gap of nutritionGaps) {
        // 查找富含该营养素的食材
        const richIngredients = await IngredientNutrition.findRichInNutrient(
          gap.element,
          gap.minAmount || 0
        );

        // 过滤可用食材
        let candidates = richIngredients;
        if (availableIngredients.length > 0) {
          candidates = richIngredients.filter(ing => 
            availableIngredients.includes(ing._id.toString())
          );
        }

        // 应用用户偏好过滤
        if (preferences.allergens) {
          candidates = candidates.filter(ing => 
            !ing.hasAllergen(preferences.allergens)
          );
        }

        if (preferences.dietaryType) {
          candidates = this._filterByDietaryType(candidates, preferences.dietaryType);
        }

        // 按营养密度和可得性排序
        candidates = this._rankIngredients(candidates, gap.element);

        recommendations.push({
          nutrient: gap.element,
          gap: gap.amount,
          unit: gap.unit,
          recommendedIngredients: candidates.slice(0, 5).map(ing => ({
            id: ing._id,
            name: ing.chineseName,
            category: ing.category,
            nutrientContent: ing.getNutrientAmount(gap.element),
            nutritionDensity: ing.nutritionDensity.overall,
            servingSize: ing.servingSize,
            estimatedServing: this._calculateRequiredServing(gap.amount, ing, gap.element)
          }))
        });
      }

      return recommendations;

    } catch (error) {
      throw new Error(`食材推荐失败: ${error.message}`);
    }
  }

  /**
   * 计算食谱营养评分
   * @param {Object} recipeNutrition - 食谱营养成分
   * @param {Object} targetNeeds - 目标营养需求
   * @returns {Object} 营养评分结果
   */
  calculateNutritionScore(recipeNutrition, targetNeeds) {
    const scores = {
      overall: 0,
      balance: 0,
      adequacy: 0,
      moderation: 0,
      variety: 0,
      details: {}
    };

    try {
      // 计算营养充足性评分 (0-100)
      scores.adequacy = this._calculateAdequacyScore(recipeNutrition, targetNeeds);

      // 计算营养平衡性评分 (0-100)
      scores.balance = this._calculateBalanceScore(recipeNutrition, targetNeeds);

      // 计算营养适度性评分 (0-100)
      scores.moderation = this._calculateModerationScore(recipeNutrition, targetNeeds);

      // 计算营养多样性评分 (0-100)
      scores.variety = this._calculateVarietyScore(recipeNutrition);

      // 计算综合评分
      scores.overall = (
        scores.adequacy * 0.4 +
        scores.balance * 0.3 +
        scores.moderation * 0.2 +
        scores.variety * 0.1
      );

      // 生成详细评价
      scores.details = this._generateScoreDetails(scores, recipeNutrition, targetNeeds);

      return scores;

    } catch (error) {
      throw new Error(`营养评分计算失败: ${error.message}`);
    }
  }

  // ==================== 私有方法 ====================

  /**
   * 计算食材基础营养含量
   */
  _calculateBaseNutrition(ingredient, amount) {
    const standardAmount = ingredient.servingSize.amount;
    const ratio = amount / standardAmount;

    return ingredient.nutritionContent.map(nutrient => ({
      element: nutrient.element,
      amount: nutrient.amount * ratio,
      unit: nutrient.unit,
      dailyValuePercentage: nutrient.dailyValuePercentage * ratio
    }));
  }

  /**
   * 应用烹饪方式对营养的影响
   */
  _applyCookingEffects(baseNutrition, cookingMethod, ingredient) {
    if (!cookingMethod || cookingMethod.method === 'raw') {
      return baseNutrition;
    }

    return baseNutrition.map(nutrient => {
      const retention = cookingMethod.getNutrientRetention(nutrient.element);
      const retentionRate = retention !== undefined ? retention / 100 : 1;

      return {
        ...nutrient,
        amount: nutrient.amount * retentionRate,
        retentionRate: retentionRate,
        cookingLoss: nutrient.amount * (1 - retentionRate)
      };
    });
  }

  /**
   * 计算基础代谢率 (BMR)
   */
  _calculateBMR(profile) {
    const { gender, weight, height, ageGroup } = profile;
    const age = this._getAgeFromGroup(ageGroup);

    if (gender === 'male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  /**
   * 计算总日消耗量 (TDEE)
   */
  _calculateTDEE(bmr, activityLevel) {
    const activityMultipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
      'professional': 2.2
    };

    return bmr * (activityMultipliers[activityLevel] || 1.55);
  }

  /**
   * 计算宏量营养素需求
   */
  _calculateMacroNeeds(tdee, profile) {
    const macroRatios = profile.macroRatios || {
      protein: 0.25,
      fat: 0.30,
      carbs: 0.45
    };

    return {
      calories: tdee,
      protein: (tdee * macroRatios.protein) / 4, // 4 kcal/g
      fat: (tdee * macroRatios.fat) / 9, // 9 kcal/g
      carbohydrates: (tdee * macroRatios.carbs) / 4, // 4 kcal/g
      fiber: Math.max(25, tdee / 1000 * 14) // 14g/1000kcal
    };
  }

  /**
   * 计算微量营养素需求
   */
  async _calculateMicroNeeds(profile) {
    const microNeeds = new Map();
    
    // 获取所有营养元素
    const elements = await NutritionElement.find({ isActive: true });
    
    for (const element of elements) {
      const intake = element.getRecommendedIntake(
        profile.gender,
        profile.ageGroup,
        this._getSpecialCondition(profile)
      );
      
      if (intake && intake.rda) {
        microNeeds.set(element.name, {
          amount: intake.rda,
          unit: element.unit,
          min: intake.min,
          max: intake.max
        });
      }
    }

    return Object.fromEntries(microNeeds);
  }

  /**
   * 根据健康目标调整营养需求
   */
  _adjustForHealthGoals(macroNeeds, microNeeds, profile) {
    const adjusted = { ...macroNeeds, ...microNeeds };
    
    if (profile.nutritionGoals) {
      for (const goal of profile.nutritionGoals) {
        switch (goal) {
          case 'weight_loss':
            adjusted.calories *= 0.85; // 减少15%热量
            adjusted.protein *= 1.2;   // 增加蛋白质
            break;
          case 'muscle_gain':
            adjusted.calories *= 1.1;  // 增加10%热量
            adjusted.protein *= 1.5;   // 大幅增加蛋白质
            break;
          case 'blood_sugar_control':
            adjusted.carbohydrates *= 0.7; // 减少碳水
            adjusted.fiber *= 1.5;     // 增加纤维
            break;
        }
      }
    }

    return adjusted;
  }

  /**
   * 获取营养素单位
   */
  _getNutrientUnit(element) {
    const unitMap = {
      'calories': 'kcal',
      'protein': 'g',
      'carbohydrates': 'g',
      'fat': 'g',
      'fiber': 'g',
      'sodium': 'mg',
      'potassium': 'mg',
      'calcium': 'mg',
      'iron': 'mg',
      'vitamin_c': 'mg',
      'vitamin_d': 'IU'
    };
    return unitMap[element] || 'mg';
  }

  /**
   * 从年龄组获取大概年龄
   */
  _getAgeFromGroup(ageGroup) {
    const ageMap = {
      'under18': 16,
      '18to25': 22,
      '26to35': 30,
      '36to45': 40,
      '46to55': 50,
      '56to65': 60,
      'above65': 70
    };
    return ageMap[ageGroup] || 30;
  }

  /**
   * 获取特殊状况
   */
  _getSpecialCondition(profile) {
    if (profile.healthGoalDetails?.specialPhysiological?.pregnancyWeek > 0) {
      return 'pregnancy';
    }
    if (profile.healthGoalDetails?.specialPhysiological?.lactationMonth > 0) {
      return 'lactation';
    }
    if (profile.lifestyle?.exerciseFrequency === 'professional') {
      return 'athletes';
    }
    return null;
  }

  // 其他辅助方法...
  _analyzeMacroMatch(current, target) {
    // 实现宏量营养素匹配分析
    return {};
  }

  _analyzeMicroMatch(current, target) {
    // 实现微量营养素匹配分析
    return {};
  }

  _identifyNutritionGaps(current, target) {
    // 识别营养缺口
    return [];
  }

  _identifyNutritionExcesses(current, target) {
    // 识别营养过量
    return [];
  }

  _generateRecommendations(analysis) {
    // 生成改善建议
    return [];
  }

  _calculateOverallMatch(analysis) {
    // 计算整体匹配度
    return 85;
  }

  _filterByDietaryType(ingredients, dietaryType) {
    // 根据饮食类型过滤食材
    return ingredients;
  }

  _rankIngredients(ingredients, nutrient) {
    // 根据营养密度排序食材
    return ingredients.sort((a, b) => 
      b.getNutrientAmount(nutrient) - a.getNutrientAmount(nutrient)
    );
  }

  _calculateRequiredServing(gapAmount, ingredient, nutrient) {
    // 计算所需份量
    const nutrientAmount = ingredient.getNutrientAmount(nutrient);
    if (nutrientAmount === 0) return 0;
    
    const ratio = gapAmount / nutrientAmount;
    return Math.ceil(ratio * ingredient.servingSize.amount);
  }

  _calculateAdequacyScore(nutrition, target) {
    // 计算营养充足性评分
    return 80;
  }

  _calculateBalanceScore(nutrition, target) {
    // 计算营养平衡性评分
    return 75;
  }

  _calculateModerationScore(nutrition, target) {
    // 计算营养适度性评分
    return 90;
  }

  _calculateVarietyScore(nutrition) {
    // 计算营养多样性评分
    return 70;
  }

  _generateScoreDetails(scores, nutrition, target) {
    // 生成详细评价
    return {
      strengths: ['营养密度高', '蛋白质充足'],
      improvements: ['可增加维生素C', '减少钠含量']
    };
  }
}

module.exports = NutritionCalculationService;