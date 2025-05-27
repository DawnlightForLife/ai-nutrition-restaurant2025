import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'widgetbook/widgetbook_app.dart';

void main() {
  // Widgetbook 始终使用开发环境
  AppConfig.setEnvironment(Environment.dev);
  
  runApp(const WidgetbookApp());
}