/**
 * 营养档案扩展功能测试脚本
 */

const axios = require('axios');

const BASE_URL = 'http://localhost:3000/api/nutrition/nutrition-profiles-extended';

// 测试用的Bearer token（需要替换为实际token）
const TEST_TOKEN = 'your-test-token-here';

const headers = {
  'Authorization': `Bearer ${TEST_TOKEN}`,
  'Content-Type': 'application/json'
};

async function testGetTemplates() {
  console.log('\n=== 测试获取营养档案模板 ===');
  try {
    const response = await axios.get(`${BASE_URL}/templates`, { headers });
    console.log('✅ 获取模板成功:', JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.log('❌ 获取模板失败:', error.response?.data || error.message);
  }
}

async function testValidateHealthGoals() {
  console.log('\n=== 测试健康目标验证 ===');
  const testData = {
    nutritionGoals: ['blood_sugar_control'],
    healthGoalDetails: {
      bloodSugarControl: {
        diabetesType: 'type2',
        medicationStatus: 'oral'
      }
    }
  };

  try {
    const response = await axios.post(`${BASE_URL}/validate-health-goals`, testData, { headers });
    console.log('✅ 健康目标验证成功:', response.data);
  } catch (error) {
    console.log('❌ 健康目标验证失败:', error.response?.data || error.message);
  }
}

async function testDetectConflicts() {
  console.log('\n=== 测试冲突检测 ===');
  const testData = {
    nutritionGoals: ['weight_loss', 'muscle_gain'], // 故意创建冲突
    activityLevel: 'sedentary',
    dietaryPreferences: {
      religiousDietary: 'halal',
      dietaryType: 'omnivore'
    }
  };

  try {
    const response = await axios.post(`${BASE_URL}/detect-conflicts`, testData, { headers });
    console.log('✅ 冲突检测成功:', JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.log('❌ 冲突检测失败:', error.response?.data || error.message);
  }
}

async function testGenerateSuggestions() {
  console.log('\n=== 测试生成建议 ===');
  const testData = {
    nutritionGoals: ['weight_loss'],
    activityLevel: 'moderate',
    gender: 'male',
    ageGroup: '26to35'
  };

  try {
    const response = await axios.post(`${BASE_URL}/generate-suggestions`, testData, { headers });
    console.log('✅ 生成建议成功:', JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.log('❌ 生成建议失败:', error.response?.data || error.message);
  }
}

async function runAllTests() {
  console.log('🚀 开始测试营养档案扩展功能...');
  
  await testGetTemplates();
  await testValidateHealthGoals();
  await testDetectConflicts();
  await testGenerateSuggestions();
  
  console.log('\n✨ 所有测试完成!');
}

// 如果直接运行此脚本
if (require.main === module) {
  runAllTests().catch(console.error);
}

module.exports = {
  testGetTemplates,
  testValidateHealthGoals,
  testDetectConflicts,
  testGenerateSuggestions,
  runAllTests
};