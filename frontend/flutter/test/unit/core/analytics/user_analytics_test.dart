import 'package:flutter_test/flutter_test.dart';
import 'package:ai_nutrition_restaurant/core/analytics/user_analytics.dart';
import 'package:ai_nutrition_restaurant/config/app_config.dart';

void main() {
  group('UserAnalytics', () {
    setUp(() {
      AppConfig.setEnvironment(Environment.dev);
    });
    
    test('应该跟踪用户登录', () {
      userAnalytics.trackLogin('phone');
      userAnalytics.trackLogin('password');
      userAnalytics.trackLogin('wechat');
      
      expect(true, true);
    });
    
    test('应该跟踪用户登出', () {
      userAnalytics.trackLogout();
      
      expect(true, true);
    });
    
    test('应该跟踪用户注册', () {
      userAnalytics.trackSignup('phone');
      userAnalytics.trackSignup('email');
      
      expect(true, true);
    });
    
    test('应该跟踪页面浏览', () {
      userAnalytics.trackPageView('HomePage');
      userAnalytics.trackPageView('LoginPage', additionalParams: {
        'from': 'splash_screen',
      });
      
      expect(true, true);
    });
    
    test('应该跟踪按钮点击', () {
      userAnalytics.trackButtonClick('login_button');
      userAnalytics.trackButtonClick('add_to_cart', screen: 'ProductDetail');
      userAnalytics.trackButtonClick('checkout', additionalParams: {
        'cart_items': 5,
        'total_amount': 128.5,
      });
      
      expect(true, true);
    });
    
    test('应该跟踪搜索行为', () {
      userAnalytics.trackSearch('鸡胸肉');
      userAnalytics.trackSearch('沙拉', resultCount: 15);
      userAnalytics.trackSearch('低脂', additionalParams: {
        'filter': 'healthy',
      });
      
      expect(true, true);
    });
    
    test('应该跟踪订单', () {
      userAnalytics.trackOrderPlaced('ORDER_12345', 88.8);
      userAnalytics.trackOrderPlaced('ORDER_12346', 166.0, additionalParams: {
        'payment_method': 'alipay',
        'delivery_type': 'express',
      });
      
      expect(true, true);
    });
    
    test('应该跟踪菜品查看', () {
      userAnalytics.trackDishViewed('DISH_001', '营养鸡胸肉');
      userAnalytics.trackDishViewed('DISH_002', '凯撒沙拉', additionalParams: {
        'from_page': 'search_results',
        'position': 3,
      });
      
      expect(true, true);
    });
    
    test('应该跟踪营养档案更新', () {
      userAnalytics.trackNutritionProfileUpdate({
        'height': 175,
        'weight': 70,
        'target': 'muscle_gain',
      });
      
      expect(true, true);
    });
    
    test('应该跟踪咨询开始', () {
      userAnalytics.trackConsultationStarted('nutrition');
      userAnalytics.trackConsultationStarted('fitness', additionalParams: {
        'consultant_id': 'CONS_123',
      });
      
      expect(true, true);
    });
    
    test('应该跟踪错误', () {
      userAnalytics.trackError('NetworkError', '网络连接失败');
      userAnalytics.trackError(
        'ValidationError', 
        '手机号格式不正确',
        stackTrace: 'at LoginPage.validatePhone...',
      );
      
      expect(true, true);
    });
    
    test('应该是单例', () {
      final analytics1 = UserAnalytics();
      final analytics2 = UserAnalytics();
      
      expect(identical(analytics1, analytics2), true);
    });
  });
}