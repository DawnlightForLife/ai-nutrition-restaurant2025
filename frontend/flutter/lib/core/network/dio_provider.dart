import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

/// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance.dio;
});

/// 为了兼容性，同时提供 dioClientProvider
final dioClientProvider = dioProvider;