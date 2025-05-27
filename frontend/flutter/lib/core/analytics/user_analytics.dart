import 'package:flutter/foundation.dart';
import '../performance/performance_monitor.dart';

enum AnalyticsEventType {
  // 用户认证事件
  userLogin,
  userLogout,
  userSignup,
  
  // 页面浏览事件
  pageView,
  
  // 用户交互事件
  buttonClick,
  itemSelect,
  search,
  
  // 业务事件
  orderPlaced,
  dishViewed,
  nutritionProfileUpdated,
  consultationStarted,
  
  // 错误事件
  error,
}

class UserAnalytics {
  static final UserAnalytics _instance = UserAnalytics._internal();
  factory UserAnalytics() => _instance;
  UserAnalytics._internal();
  
  final Performance _performance = Performance();
  
  // 跟踪用户登录
  void trackLogin(String method) {
    _logEvent(AnalyticsEventType.userLogin, {
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // 跟踪用户登出
  void trackLogout() {
    _logEvent(AnalyticsEventType.userLogout, {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // 跟踪用户注册
  void trackSignup(String method) {
    _logEvent(AnalyticsEventType.userSignup, {
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // 跟踪页面浏览
  void trackPageView(String pageName, {Map<String, dynamic>? additionalParams}) {
    final params = {
      'page_name': pageName,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.pageView, params);
  }
  
  // 跟踪按钮点击
  void trackButtonClick(String buttonName, {String? screen, Map<String, dynamic>? additionalParams}) {
    final params = {
      'button_name': buttonName,
      if (screen != null) 'screen': screen,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.buttonClick, params);
  }
  
  // 跟踪项目选择
  void trackItemSelect(String itemType, String itemId, {Map<String, dynamic>? additionalParams}) {
    final params = {
      'item_type': itemType,
      'item_id': itemId,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.itemSelect, params);
  }
  
  // 跟踪搜索
  void trackSearch(String query, {int? resultCount, Map<String, dynamic>? additionalParams}) {
    final params = {
      'search_query': query,
      if (resultCount != null) 'result_count': resultCount,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.search, params);
  }
  
  // 跟踪订单
  void trackOrderPlaced(String orderId, double totalAmount, {Map<String, dynamic>? additionalParams}) {
    final params = {
      'order_id': orderId,
      'total_amount': totalAmount,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.orderPlaced, params);
  }
  
  // 跟踪菜品查看
  void trackDishViewed(String dishId, String dishName, {Map<String, dynamic>? additionalParams}) {
    final params = {
      'dish_id': dishId,
      'dish_name': dishName,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.dishViewed, params);
  }
  
  // 跟踪营养档案更新
  void trackNutritionProfileUpdate(Map<String, dynamic> changes) {
    final params = {
      'changes': changes,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _logEvent(AnalyticsEventType.nutritionProfileUpdated, params);
  }
  
  // 跟踪咨询开始
  void trackConsultationStarted(String consultationType, {Map<String, dynamic>? additionalParams}) {
    final params = {
      'consultation_type': consultationType,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalParams,
    };
    _logEvent(AnalyticsEventType.consultationStarted, params);
  }
  
  // 跟踪错误
  void trackError(String errorType, String errorMessage, {String? stackTrace}) {
    final params = {
      'error_type': errorType,
      'error_message': errorMessage,
      if (stackTrace != null) 'stack_trace': stackTrace,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _logEvent(AnalyticsEventType.error, params);
  }
  
  // 内部方法：记录事件
  void _logEvent(AnalyticsEventType eventType, Map<String, dynamic> parameters) {
    final eventName = eventType.toString().split('.').last;
    Performance.monitor.logCustomEvent(eventName, parameters);
    
    if (kDebugMode) {
      print('Analytics Event: $eventName');
      print('Parameters: $parameters');
    }
  }
}

// 全局访问点
final userAnalytics = UserAnalytics();