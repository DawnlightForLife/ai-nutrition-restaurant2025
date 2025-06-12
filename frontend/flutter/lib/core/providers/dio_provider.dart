import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';

/// Dio提供者
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance.dio;
});

/// DioClient提供者
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient.instance;
});

/// ApiClient提供者
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});