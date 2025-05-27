import 'package:flutter/material.dart';
import 'user_analytics.dart';

mixin AnalyticsMixin<T extends StatefulWidget> on State<T> {
  String get screenName => widget.runtimeType.toString();
  
  @override
  void initState() {
    super.initState();
    // 自动跟踪页面浏览
    userAnalytics.trackPageView(screenName);
  }
  
  // 便捷方法：跟踪按钮点击
  void trackButtonClick(String buttonName, {Map<String, dynamic>? additionalParams}) {
    userAnalytics.trackButtonClick(
      buttonName,
      screen: screenName,
      additionalParams: additionalParams,
    );
  }
  
  // 便捷方法：跟踪项目选择
  void trackItemSelect(String itemType, String itemId, {Map<String, dynamic>? additionalParams}) {
    userAnalytics.trackItemSelect(
      itemType,
      itemId,
      additionalParams: {
        'screen': screenName,
        ...?additionalParams,
      },
    );
  }
  
  // 便捷方法：跟踪搜索
  void trackSearch(String query, {int? resultCount}) {
    userAnalytics.trackSearch(
      query,
      resultCount: resultCount,
      additionalParams: {
        'screen': screenName,
      },
    );
  }
  
  // 便捷方法：跟踪错误
  void trackError(String errorMessage, {dynamic error, StackTrace? stackTrace}) {
    userAnalytics.trackError(
      error?.runtimeType.toString() ?? 'UnknownError',
      errorMessage,
      stackTrace: stackTrace?.toString(),
    );
  }
}