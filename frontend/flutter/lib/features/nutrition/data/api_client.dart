import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  // 基础API客户端，为各个模块的API service提供支持
  Dio getDio() => dio;
}