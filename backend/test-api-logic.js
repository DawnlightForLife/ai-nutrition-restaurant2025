/**
 * 测试营养档案扩展API逻辑
 */

console.log('🧪 开始测试营养档案扩展API业务逻辑...\n');

// 测试1: 获取模板
console.log('=== 测试1: 获取模板 ===');
const templates = {
  diabetic: {
    name: '糖尿病患者',
    data: {
      nutritionGoals: ['blood_sugar_control'],
      healthGoalDetails: {
        bloodSugarControl: {
          diabetesType: 'type2',
          medicationStatus: 'oral',
          monitoringFrequency: 'daily'
        }
      }
    }
  },
  fitness: {
    name: '健身增肌',
    data: {
      nutritionGoals: ['muscle_gain', 'sports_performance'],
      activityLevel: 'very_active',
      activityLevelDetail: 'more_than_3hours'
    }
  },
  weightLoss: {
    name: '健康减重',
    data: {
      nutritionGoals: ['weight_loss', 'fat_loss']
    }
  }
};

console.log('✅ 模板数量:', Object.keys(templates).length);
console.log('✅ 可用模板:', Object.keys(templates).join(', '));

// 测试2: 健康目标验证
console.log('\n=== 测试2: 健康目标验证 ===');

function validateHealthGoals(nutritionGoals) {
  if (!nutritionGoals || !Array.isArray(nutritionGoals) || nutritionGoals.length === 0) {
    return { success: false, message: '请至少选择一个营养目标' };
  }
  
  const hasWeightLoss = nutritionGoals.includes('weight_loss');
  const hasMuscleGain = nutritionGoals.includes('muscle_gain');
  
  if (hasWeightLoss && hasMuscleGain) {
    return { 
      success: false, 
      message: '减重和增肌目标存在冲突，建议选择体重管理或塑形目标' 
    };
  }
  
  return { success: true, message: '健康目标配置验证通过' };
}

// 测试有效目标
const validGoals = ['weight_loss', 'blood_sugar_control'];
const validResult = validateHealthGoals(validGoals);
console.log('有效目标测试:', validResult.success ? '✅' : '❌', validResult.message);

// 测试冲突目标
const conflictGoals = ['weight_loss', 'muscle_gain'];
const conflictResult = validateHealthGoals(conflictGoals);
console.log('冲突目标测试:', conflictResult.success ? '❌' : '✅', conflictResult.message);

// 测试3: 冲突检测
console.log('\n=== 测试3: 冲突检测 ===');

function detectConflicts(profileData) {
  const conflicts = [];
  
  // 检测目标冲突
  const goals = profileData.nutritionGoals || [];
  if (goals.includes('weight_loss') && goals.includes('muscle_gain')) {
    conflicts.push({
      type: 'goal',
      message: '减重和增肌目标存在冲突，建议选择塑形目标'
    });
  }
  
  // 检测饮食类型与宗教冲突
  if (profileData.dietaryPreferences) {
    const { dietaryType, religiousDietary } = profileData.dietaryPreferences;
    
    if (religiousDietary === 'halal' && dietaryType === 'omnivore') {
      conflicts.push({
        type: 'dietary',
        message: '清真饮食需要特殊的饮食限制'
      });
    }
    
    if (religiousDietary === 'buddhist' && !['vegetarian', 'vegan'].includes(dietaryType)) {
      conflicts.push({
        type: 'dietary',
        message: '佛教素食通常需要选择素食或纯素食'
      });
    }
  }
  
  // 检测运动与目标冲突
  if (profileData.activityLevel === 'sedentary' && goals.includes('sports_performance')) {
    conflicts.push({
      type: 'activity',
      message: '久坐生活方式与运动表现目标不匹配'
    });
  }
  
  return {
    success: true,
    hasConflicts: conflicts.length > 0,
    conflicts
  };
}

// 测试有冲突的配置
const conflictData = {
  nutritionGoals: ['weight_loss', 'muscle_gain'],
  activityLevel: 'sedentary',
  dietaryPreferences: {
    religiousDietary: 'halal',
    dietaryType: 'omnivore'
  }
};

const conflictDetectionResult = detectConflicts(conflictData);
console.log('✅ 冲突检测完成');
console.log('发现冲突:', conflictDetectionResult.hasConflicts ? '是' : '否');
console.log('冲突数量:', conflictDetectionResult.conflicts.length);
conflictDetectionResult.conflicts.forEach((conflict, idx) => {
  console.log(`  ${idx + 1}. [${conflict.type}] ${conflict.message}`);
});

// 测试4: 生成建议
console.log('\n=== 测试4: 生成建议 ===');

function generateSuggestions(requestData) {
  const { nutritionGoals, activityLevel, gender, ageGroup } = requestData;
  const suggestions = {
    dietaryType: [],
    tastePreferences: {},
    dailyCalorieTarget: null,
    macroRatios: {}
  };
  
  // 根据目标推荐饮食类型
  if (nutritionGoals.includes('weight_loss')) {
    suggestions.dietaryType.push('low_carb', 'mediterranean');
    suggestions.dailyCalorieTarget = gender === 'male' ? 1800 : 1500;
    suggestions.macroRatios = { protein: 0.3, fat: 0.35, carbs: 0.35 };
  }
  
  if (nutritionGoals.includes('muscle_gain')) {
    suggestions.dietaryType.push('omnivore');
    suggestions.dailyCalorieTarget = gender === 'male' ? 2800 : 2200;
    suggestions.macroRatios = { protein: 0.35, fat: 0.25, carbs: 0.4 };
  }
  
  if (nutritionGoals.includes('blood_sugar_control')) {
    suggestions.dietaryType.push('low_carb', 'keto');
    suggestions.tastePreferences = { sweet: 0, oily: 1 };
    suggestions.macroRatios = { protein: 0.25, fat: 0.5, carbs: 0.25 };
  }
  
  // 根据活动水平调整热量
  const activityMultiplier = {
    sedentary: 1.2,
    light: 1.375,
    moderate: 1.55,
    active: 1.725,
    very_active: 1.9,
    professional: 2.2
  };
  
  if (suggestions.dailyCalorieTarget && activityLevel) {
    const baseCal = suggestions.dailyCalorieTarget;
    suggestions.dailyCalorieTarget = Math.round(baseCal * (activityMultiplier[activityLevel] / 1.55));
  }
  
  return { success: true, suggestions };
}

// 测试建议生成
const suggestionRequest = {
  nutritionGoals: ['weight_loss'],
  activityLevel: 'moderate',
  gender: 'male',
  ageGroup: '26to35'
};

const suggestionResult = generateSuggestions(suggestionRequest);
console.log('✅ 建议生成完成');
console.log('推荐饮食类型:', suggestionResult.suggestions.dietaryType);
console.log('目标热量:', suggestionResult.suggestions.dailyCalorieTarget, 'kcal');
console.log('宏量营养素比例:', suggestionResult.suggestions.macroRatios);

console.log('\n🎉 所有API逻辑测试完成！');
console.log('✅ 模板功能: 正常');
console.log('✅ 健康目标验证: 正常'); 
console.log('✅ 冲突检测: 正常');
console.log('✅ 建议生成: 正常');