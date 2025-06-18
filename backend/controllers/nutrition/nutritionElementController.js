/**
 * 营养元素控制器
 * 处理营养元素的CRUD操作和查询
 * @module controllers/nutrition/nutritionElementController
 */

const { NutritionElement, NUTRITION_CATEGORIES, FUNCTION_CATEGORIES } = require('../../models/nutrition/nutritionElementModel');
const { responseHelper } = require('../../utils');
const { logger } = require('../../config');

/**
 * 获取营养元素列表
 */
const getNutritionElements = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      category,
      importance,
      functions,
      search,
      sortBy = 'name',
      sortOrder = 'asc'
    } = req.query;

    // 构建查询条件
    const query = { isActive: true };
    
    if (category) {
      query.category = category;
    }
    
    if (importance) {
      query.importance = importance;
    }
    
    if (functions) {
      query.functions = { $in: functions.split(',') };
    }
    
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { chineseName: { $regex: search, $options: 'i' } },
        { aliases: { $regex: search, $options: 'i' } }
      ];
    }

    // 排序
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页查询
    const skip = (page - 1) * limit;
    const elements = await NutritionElement.find(query)
      .sort(sortOptions)
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await NutritionElement.countDocuments(query);

    logger.info(`获取营养元素列表: ${elements.length}条记录`);

    return responseHelper.success(res, {
      elements,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });

  } catch (error) {
    logger.error('获取营养元素列表失败:', error);
    return responseHelper.error(res, '获取营养元素列表失败', 500);
  }
};

/**
 * 根据ID获取营养元素详情
 */
const getNutritionElementById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const element = await NutritionElement.findById(id).lean();
    
    if (!element) {
      return responseHelper.error(res, '营养元素不存在', 404);
    }

    logger.info(`获取营养元素详情: ${element.name}`);
    return responseHelper.success(res, element);

  } catch (error) {
    logger.error('获取营养元素详情失败:', error);
    return responseHelper.error(res, '获取营养元素详情失败', 500);
  }
};

/**
 * 创建营养元素
 */
const createNutritionElement = async (req, res) => {
  try {
    const elementData = req.body;
    
    // 检查名称是否已存在
    const existingElement = await NutritionElement.findOne({ 
      name: elementData.name 
    });
    
    if (existingElement) {
      return responseHelper.error(res, '营养元素名称已存在', 400);
    }

    const element = new NutritionElement(elementData);
    await element.save();

    logger.info(`创建营养元素成功: ${element.name}`);
    return responseHelper.success(res, element, '创建营养元素成功', 201);

  } catch (error) {
    logger.error('创建营养元素失败:', error);
    if (error.name === 'ValidationError') {
      return responseHelper.error(res, '数据验证失败', 400, error.errors);
    }
    return responseHelper.error(res, '创建营养元素失败', 500);
  }
};

/**
 * 更新营养元素
 */
const updateNutritionElement = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;
    
    // 检查名称冲突（排除自己）
    if (updateData.name) {
      const existingElement = await NutritionElement.findOne({ 
        name: updateData.name,
        _id: { $ne: id }
      });
      
      if (existingElement) {
        return responseHelper.error(res, '营养元素名称已存在', 400);
      }
    }

    const element = await NutritionElement.findByIdAndUpdate(
      id,
      { 
        ...updateData, 
        lastUpdated: new Date(),
        version: { $inc: 1 }
      },
      { new: true, runValidators: true }
    );

    if (!element) {
      return responseHelper.error(res, '营养元素不存在', 404);
    }

    logger.info(`更新营养元素成功: ${element.name}`);
    return responseHelper.success(res, element, '更新营养元素成功');

  } catch (error) {
    logger.error('更新营养元素失败:', error);
    if (error.name === 'ValidationError') {
      return responseHelper.error(res, '数据验证失败', 400, error.errors);
    }
    return responseHelper.error(res, '更新营养元素失败', 500);
  }
};

/**
 * 删除营养元素（软删除）
 */
const deleteNutritionElement = async (req, res) => {
  try {
    const { id } = req.params;
    
    const element = await NutritionElement.findByIdAndUpdate(
      id,
      { isActive: false },
      { new: true }
    );

    if (!element) {
      return responseHelper.error(res, '营养元素不存在', 404);
    }

    logger.info(`删除营养元素成功: ${element.name}`);
    return responseHelper.success(res, null, '删除营养元素成功');

  } catch (error) {
    logger.error('删除营养元素失败:', error);
    return responseHelper.error(res, '删除营养元素失败', 500);
  }
};

/**
 * 按类别获取营养元素
 */
const getNutritionElementsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    
    if (!Object.values(NUTRITION_CATEGORIES).includes(category)) {
      return responseHelper.error(res, '无效的营养类别', 400);
    }

    const elements = await NutritionElement.findByCategory(category);

    logger.info(`获取${category}类别营养元素: ${elements.length}条记录`);
    return responseHelper.success(res, elements);

  } catch (error) {
    logger.error('按类别获取营养元素失败:', error);
    return responseHelper.error(res, '按类别获取营养元素失败', 500);
  }
};

/**
 * 按功能获取营养元素
 */
const getNutritionElementsByFunction = async (req, res) => {
  try {
    const { functionCategory } = req.params;
    
    if (!Object.values(FUNCTION_CATEGORIES).includes(functionCategory)) {
      return responseHelper.error(res, '无效的功能类别', 400);
    }

    const elements = await NutritionElement.findByFunction(functionCategory);

    logger.info(`获取${functionCategory}功能营养元素: ${elements.length}条记录`);
    return responseHelper.success(res, elements);

  } catch (error) {
    logger.error('按功能获取营养元素失败:', error);
    return responseHelper.error(res, '按功能获取营养元素失败', 500);
  }
};

/**
 * 获取营养元素推荐摄入量
 */
const getRecommendedIntake = async (req, res) => {
  try {
    const { id } = req.params;
    const { gender, ageGroup, condition } = req.query;
    
    if (!gender || !ageGroup) {
      return responseHelper.error(res, '请提供性别和年龄组信息', 400);
    }

    const element = await NutritionElement.findById(id);
    if (!element) {
      return responseHelper.error(res, '营养元素不存在', 404);
    }

    const intake = element.getRecommendedIntake(gender, ageGroup, condition);
    
    if (!intake) {
      return responseHelper.error(res, '无法获取该条件下的推荐摄入量', 404);
    }

    logger.info(`获取营养元素推荐摄入量: ${element.name}`);
    return responseHelper.success(res, {
      element: element.name,
      chineseName: element.chineseName,
      unit: element.unit,
      gender,
      ageGroup,
      condition,
      recommendedIntake: intake
    });

  } catch (error) {
    logger.error('获取推荐摄入量失败:', error);
    return responseHelper.error(res, '获取推荐摄入量失败', 500);
  }
};

/**
 * 获取营养元素常量定义
 */
const getNutritionConstants = async (req, res) => {
  try {
    const constants = {
      categories: NUTRITION_CATEGORIES,
      functions: FUNCTION_CATEGORIES,
      units: {
        GRAM: 'g',
        MILLIGRAM: 'mg',
        MICROGRAM: 'mcg',
        INTERNATIONAL_UNIT: 'IU',
        MILLIEQUIVALENT: 'mEq',
        MILLILITER: 'ml',
        LITER: 'l',
        KCAL: 'kcal',
        KJ: 'kJ',
        PERCENT: '%'
      },
      importanceLevels: {
        ESSENTIAL: 'essential',
        IMPORTANT: 'important',
        BENEFICIAL: 'beneficial',
        OPTIONAL: 'optional'
      }
    };

    logger.info('获取营养元素常量定义');
    return responseHelper.success(res, constants);

  } catch (error) {
    logger.error('获取营养元素常量失败:', error);
    return responseHelper.error(res, '获取营养元素常量失败', 500);
  }
};

/**
 * 批量导入营养元素
 */
const batchImportNutritionElements = async (req, res) => {
  try {
    const { elements } = req.body;
    
    if (!Array.isArray(elements) || elements.length === 0) {
      return responseHelper.error(res, '请提供有效的营养元素数组', 400);
    }

    const results = {
      success: 0,
      failed: 0,
      errors: []
    };

    for (const elementData of elements) {
      try {
        // 检查是否已存在
        const existing = await NutritionElement.findOne({ name: elementData.name });
        
        if (existing) {
          results.errors.push(`营养元素 ${elementData.name} 已存在`);
          results.failed++;
          continue;
        }

        const element = new NutritionElement(elementData);
        await element.save();
        results.success++;

      } catch (error) {
        results.errors.push(`营养元素 ${elementData.name} 导入失败: ${error.message}`);
        results.failed++;
      }
    }

    logger.info(`批量导入营养元素完成: 成功${results.success}条，失败${results.failed}条`);
    return responseHelper.success(res, results, '批量导入完成');

  } catch (error) {
    logger.error('批量导入营养元素失败:', error);
    return responseHelper.error(res, '批量导入营养元素失败', 500);
  }
};

module.exports = {
  getNutritionElements,
  getNutritionElementById,
  createNutritionElement,
  updateNutritionElement,
  deleteNutritionElement,
  getNutritionElementsByCategory,
  getNutritionElementsByFunction,
  getRecommendedIntake,
  getNutritionConstants,
  batchImportNutritionElements
};