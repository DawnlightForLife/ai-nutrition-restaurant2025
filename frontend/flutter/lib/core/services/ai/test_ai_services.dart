/// 简化的AI服务测试版本
/// 用于验证功能是否正常工作

class TestAIServices {
  static bool _initialized = false;
  
  /// 初始化测试AI服务
  static Future<bool> initialize() async {
    try {
      // 模拟初始化延迟
      await Future.delayed(const Duration(milliseconds: 500));
      _initialized = true;
      print('测试AI服务初始化完成');
      return true;
    } catch (e) {
      print('测试AI服务初始化失败: $e');
      return false;
    }
  }
  
  /// 检查服务是否可用
  static bool get isAvailable => _initialized;
  
  /// 生成测试营养方案
  static Future<String> generateNutritionPlan(String userInput) async {
    if (!_initialized) {
      throw Exception('AI服务未初始化');
    }
    
    // 模拟AI响应延迟
    await Future.delayed(const Duration(seconds: 2));
    
    return '''
🥗 **个性化营养方案**

**每日营养目标：**
• 热量：1800-2000 kcal
• 蛋白质：135-150g
• 脂肪：50-67g
• 碳水化合物：225-300g

**三餐建议：**

🌅 **早餐**
• 燕麦粥 + 坚果 + 水果
• 脱脂牛奶或豆浆
• 煮蛋1个

🌞 **午餐**
• 瘦肉/鱼肉100g
• 蔬菜200g
• 糙米/全麦面100g

🌙 **晚餐**
• 蒸蛋羹或豆腐
• 绿叶蔬菜150g
• 少量主食

**注意事项：**
• 每日饮水1500-2000ml
• 适量运动配合
• 定期监测体重变化
''';
  }
  
  /// 生成咨询回复
  static Future<String> generateConsultationReply(String question) async {
    if (!_initialized) {
      throw Exception('AI服务未初始化');
    }
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    return '''
感谢您的咨询。根据您的问题，我建议：

1. **饮食调整**：
   - 增加优质蛋白质摄入
   - 适当减少精制碳水化合物
   - 增加新鲜蔬菜和水果

2. **生活习惯**：
   - 保持规律作息
   - 适量运动
   - 充足睡眠

3. **监测指标**：
   - 定期检查体重变化
   - 关注身体感受
   - 如有不适及时调整

如有其他问题，请随时咨询。
''';
  }
  
  /// 分析饮食记录
  static Future<String> analyzeDiet(String dietRecord) async {
    if (!_initialized) {
      throw Exception('AI服务未初始化');
    }
    
    await Future.delayed(const Duration(milliseconds: 1800));
    
    return '''
📊 **饮食分析报告**

**营养摄入评估：**
• 总热量：1850 kcal
• 蛋白质：85g ✅
• 脂肪：70g ⚠️
• 碳水化合物：220g ✅

**优点：**
• 蛋白质摄入充足
• 蔬菜种类丰富
• 用餐时间规律

**需要改善：**
• 精制糖摄入偏高
• 饱和脂肪含量较多
• 膳食纤维略显不足

**建议：**
• 用全谷物替代精制主食
• 增加坚果和深海鱼类
• 减少加工食品摄入
• 每日增加200g蔬菜
''';
  }
  
  /// 生成食谱
  static Future<String> generateRecipe(String requirements) async {
    if (!_initialized) {
      throw Exception('AI服务未初始化');
    }
    
    await Future.delayed(const Duration(seconds: 2));
    
    return '''
🍽️ **彩虹蔬菜鸡胸肉沙拉**

**食材（2人份）：**
• 鸡胸肉 200g
• 西兰花 150g
• 胡萝卜 100g
• 紫甘蓝 80g
• 小番茄 100g
• 橄榄油 15ml
• 柠檬汁 10ml
• 盐、黑胡椒适量

**制作步骤：**
1. 鸡胸肉用盐和黑胡椒腌制15分钟
2. 平底锅少油煎制鸡胸肉至熟透
3. 蔬菜分别焯水保持脆嫩
4. 将所有食材摆盘
5. 淋上橄榄油和柠檬汁调味

**营养价值：**
• 热量：约380 kcal/份
• 蛋白质：32g
• 脂肪：12g
• 碳水化合物：18g

⏱️ **制作时间：** 20分钟
👨‍🍳 **难度：** 简单
💡 **小贴士：** 可根据喜好添加其他蔬菜
''';
  }
  
  /// 获取流式聊天响应
  static Stream<String> getStreamingResponse(String message) async* {
    if (!_initialized) {
      yield 'AI服务未初始化';
      return;
    }
    
    final response = '''
您好！作为您的AI营养助手，我很高兴为您提供专业的营养指导。
    
根据您的需求，我可以帮助您：
- 制定个性化营养方案
- 分析饮食记录
- 推荐健康食谱
- 回答营养相关问题
    
请告诉我您的具体需求，我会竭诚为您服务！
''';
    
    final words = response.split(' ');
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (i == 0) {
        yield words[i];
      } else {
        yield ' ${words[i]}';
      }
    }
  }
  
  /// 切换AI服务提供者（模拟）
  static Future<bool> switchProvider(String providerName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('已切换到AI服务提供者: $providerName');
    return true;
  }
  
  /// 获取服务状态
  static Map<String, dynamic> getServiceStatus() {
    return {
      'isAvailable': _initialized,
      'currentProvider': 'test_mock',
      'healthStatus': 'healthy',
      'responseTime': 150,
      'lastUpdate': DateTime.now().toIso8601String(),
    };
  }
}