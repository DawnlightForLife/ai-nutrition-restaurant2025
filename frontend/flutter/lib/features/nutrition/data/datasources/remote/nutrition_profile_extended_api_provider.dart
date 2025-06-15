import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import 'nutrition_profile_extended_api.dart';

/// Nutrition Profile Extended API Service Provider
final nutritionProfileExtendedApiServiceProvider = Provider<NutritionProfileExtendedApiService>((ref) {
  // TODO: 使用真实的 API client
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000', // 需要根据实际配置修改
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  final api = NutritionProfileExtendedApi(dio);
  return NutritionProfileExtendedApiService(api);
});