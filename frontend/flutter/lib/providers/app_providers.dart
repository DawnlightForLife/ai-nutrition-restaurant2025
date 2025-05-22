import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

// 引入模块 Provider
import '../modules/user/providers/auth_provider.dart';
import '../modules/order/providers/order_provider.dart';
// 如有其他模块，继续添加...

final List<ChangeNotifierProvider> appProviders = [
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => OrderProvider()),
  // Add other global providers here
];