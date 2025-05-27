import 'package:flutter/foundation.dart';

enum Environment { dev, staging, prod }

@immutable
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enablePerformanceMonitoring;
  
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enablePerformanceMonitoring,
  });
  
  static late AppConfig _instance;
  
  static AppConfig get instance => _instance;
  
  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _instance = const AppConfig(
          environment: Environment.dev,
          apiBaseUrl: 'http://localhost:3000/api/v1',
          appName: '元气立方 Dev',
          enableLogging: true,
          enablePerformanceMonitoring: false,
        );
        break;
      case Environment.staging:
        _instance = const AppConfig(
          environment: Environment.staging,
          apiBaseUrl: 'https://staging-api.ainutrition.com/api/v1',
          appName: '元气立方 Staging',
          enableLogging: true,
          enablePerformanceMonitoring: true,
        );
        break;
      case Environment.prod:
        _instance = const AppConfig(
          environment: Environment.prod,
          apiBaseUrl: 'https://api.ainutrition.com/api/v1',
          appName: '元气立方',
          enableLogging: false,
          enablePerformanceMonitoring: true,
        );
        break;
    }
  }
  
  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}