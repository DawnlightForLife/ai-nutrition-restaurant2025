import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.setEnvironment(Environment.staging);
  
  runApp(
    const ProviderScope(
      child: app.MyApp(),
    ),
  );
}