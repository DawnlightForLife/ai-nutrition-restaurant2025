import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

/// Connectivity提供者
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// NetworkInfo提供者
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

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