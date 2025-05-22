/**
 * 完成用户营养档案用例
 * 协调用户领域和营养领域，完成用户档案创建流程
 */
class CompleteProfileUseCase {
  /**
   * @param {Object} dependencies - 依赖注入
   * @param {import('../../../domain/user/repositories/user_repository')} dependencies.userRepository - 用户仓储
   * @param {import('../../../domain/nutrition/repositories/nutrition_profile_repository')} dependencies.nutritionProfileRepository - 营养档案仓储
   * @param {import('../../../domain/nutrition/repositories/diet_preference_repository')} dependencies.dietPreferenceRepository - 饮食偏好仓储
   * @param {import('../../../domain/nutrition/services/nutrition_recommendation_service')} dependencies.nutritionRecommendationService - 营养推荐服务
   */
  constructor({
    userRepository,
    nutritionProfileRepository,
    dietPreferenceRepository,
    nutritionRecommendationService
  }) {
    this._userRepository = userRepository;
    this._nutritionProfileRepository = nutritionProfileRepository;
    this._dietPreferenceRepository = dietPreferenceRepository;
    this._nutritionRecommendationService = nutritionRecommendationService;
  }

  /**
   * 完成用户营养档案
   * @param {string} userId - 用户ID
   * @param {Object} profileData - 营养档案数据
   * @param {Object} dietPreferences - 饮食偏好数据
   * @returns {Promise<Object>} 创建结果，包含档案和初始推荐
   */
  async execute(userId, profileData, dietPreferences) {
    // 1. 验证用户存在
    const user = await this._userRepository.findById(userId);
    if (!user) {
      throw new Error('用户不存在');
    }

    // 2. 创建或更新营养档案
    const NutritionProfile = require('../../../domain/nutrition/entities/nutrition_profile');
    let nutritionProfile = await this._nutritionProfileRepository.findByUserId(userId);
    
    if (nutritionProfile) {
      // 更新现有档案
      nutritionProfile = nutritionProfile.update(profileData);
    } else {
      // 创建新档案
      nutritionProfile = NutritionProfile.create(
        userId,
        profileData.age,
        profileData.gender,
        profileData.height,
        profileData.weight,
        profileData.activityLevel,
        profileData.healthGoals,
        profileData.medicalConditions || []
      );
    }
    
    // 保存营养档案
    const savedProfile = await this._nutritionProfileRepository.save(nutritionProfile);

    // 3. 保存饮食偏好
    const DietPreference = require('../../../domain/nutrition/entities/diet_preference');
    let dietPreference = await this._dietPreferenceRepository.findByUserId(userId);
    
    if (dietPreference) {
      // 更新现有偏好
      dietPreference = dietPreference.update(dietPreferences);
    } else {
      // 创建新偏好
      dietPreference = DietPreference.create(
        userId,
        dietPreferences.cuisinePreferences || [],
        dietPreferences.excludedIngredients || [],
        dietPreferences.allergens || [],
        dietPreferences.dietaryRestrictions || [],
        dietPreferences.mealPreferences || {}
      );
    }
    
    // 保存饮食偏好
    const savedPreference = await this._dietPreferenceRepository.save(dietPreference);

    // 4. 更新用户状态为档案已完成
    user.completeProfile();
    await this._userRepository.save(user);

    // 5. 生成初始营养推荐
    const initialRecommendations = await this._nutritionRecommendationService.generateInitialRecommendations(
      savedProfile,
      savedPreference
    );

    // 6. 返回完成结果
    return {
      profile: savedProfile.toJSON(),
      preferences: savedPreference.toJSON(),
      recommendations: initialRecommendations
    };
  }
}

module.exports = CompleteProfileUseCase; 