/**
 * 测试AI营养推荐服务集成
 */

require('dotenv').config();
const mongoose = require('mongoose');
const { dbConnect } = require('./config');

// 测试AI营养推荐流程
async function testAIIntegration() {
  try {
    // 连接数据库
    await dbConnect();
    console.log('✅ 数据库连接成功');

    // 获取服务
    const { nutritionProfileService, aiRecommendationService } = require('./services');
    
    // 1. 获取一个测试用户的营养档案
    const profiles = await nutritionProfileService.getAllProfiles({ limit: 1 });
    
    if (!profiles.success || !profiles.data || profiles.data.length === 0) {
      console.log('❌ 没有找到营养档案，请先创建营养档案');
      process.exit(1);
    }
    
    const profile = profiles.data[0];
    console.log('\n✅ 找到营养档案:', {
      id: profile._id,
      userId: profile.userId,
      gender: profile.gender,
      age: profile.age,
      height: profile.height,
      weight: profile.weight,
      activityLevel: profile.activityLevel,
      healthGoal: profile.healthGoal
    });
    
    // 2. 测试根据营养档案ID生成推荐
    console.log('\n📊 测试根据营养档案ID生成推荐...');
    const recommendationResult = await aiRecommendationService.generateRecommendationByProfileId(profile._id);
    
    if (!recommendationResult.success) {
      console.log('❌ 生成推荐失败:', recommendationResult.message);
      process.exit(1);
    }
    
    console.log('\n✅ 成功生成AI推荐!');
    console.log('推荐ID:', recommendationResult.data._id);
    console.log('推荐类型:', recommendationResult.data.recommendationType);
    console.log('状态:', recommendationResult.data.status);
    
    // 显示营养目标
    if (recommendationResult.data.recommendationData && recommendationResult.data.recommendationData.summary) {
      const summary = recommendationResult.data.recommendationData.summary;
      console.log('\n📊 营养目标:');
      console.log('- 每日热量:', summary.dailyCalories, '卡路里');
      console.log('- 蛋白质比例:', summary.proteinPercentage, '%');
      console.log('- 碳水化合物比例:', summary.carbsPercentage, '%');
      console.log('- 脂肪比例:', summary.fatPercentage, '%');
      
      if (summary.keyBenefits) {
        console.log('\n🎯 关键营养指标:');
        summary.keyBenefits.forEach(benefit => {
          console.log('-', benefit);
        });
      }
    }
    
    // 显示饮食建议
    if (recommendationResult.data.recommendationData && recommendationResult.data.recommendationData.dietSuggestions) {
      console.log('\n💡 饮食建议:');
      recommendationResult.data.recommendationData.dietSuggestions.forEach((suggestion, index) => {
        console.log(`${index + 1}. ${suggestion.suggestion}`);
        if (suggestion.reasoning) {
          console.log(`   理由: ${suggestion.reasoning}`);
        }
      });
    }
    
    // 显示分析结果
    if (recommendationResult.data.analysis) {
      console.log('\n📈 营养分析:');
      if (recommendationResult.data.analysis.currentDietAnalysis) {
        console.log('当前饮食分析:', recommendationResult.data.analysis.currentDietAnalysis);
      }
    }
    
    // 3. 测试获取用户的推荐列表
    console.log('\n📋 获取用户的推荐列表...');
    const listResult = await aiRecommendationService.getRecommendationsByUserId(profile.userId, { limit: 5 });
    
    if (listResult.success) {
      console.log(`\n✅ 找到 ${listResult.data.length} 条推荐记录`);
      listResult.data.forEach((rec, index) => {
        console.log(`${index + 1}. 推荐ID: ${rec._id}, 类型: ${rec.recommendationType}, 创建时间: ${rec.createdAt}`);
      });
    }
    
    // 4. 测试AI服务健康检查
    console.log('\n🏥 检查AI服务状态...');
    const aiNutritionService = require('./services/ai/aiNutritionService');
    const healthCheck = await aiNutritionService.checkHealth();
    
    if (healthCheck.success) {
      console.log('✅ AI服务状态正常');
      console.log('- 服务版本:', healthCheck.data.version);
      console.log('- 服务状态:', healthCheck.data.status);
    } else {
      console.log('⚠️ AI服务可能不可用，使用备用算法');
    }
    
    console.log('\n✅ AI集成测试完成!');
    
  } catch (error) {
    console.error('\n❌ 测试失败:', error);
  } finally {
    // 关闭数据库连接
    await mongoose.connection.close();
    console.log('\n👋 数据库连接已关闭');
  }
}

// 运行测试
testAIIntegration();