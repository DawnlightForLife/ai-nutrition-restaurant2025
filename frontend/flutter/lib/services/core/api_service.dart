import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final http.Client _client;

  ApiService({
    required String baseUrl,
    required http.Client client,
  })  : _baseUrl = baseUrl,
        _client = client;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      var uri = Uri.parse(_baseUrl + endpoint);
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      debugPrint('🌐 GET请求: $uri');
      if (headers != null) {
        debugPrint('🔑 请求头: $headers');
      }

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ GET请求错误: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl + endpoint);
      
      debugPrint('🌐 POST请求: $uri');
      if (headers != null) {
        debugPrint('🔑 请求头: $headers');
      }
      if (body != null) {
        debugPrint('📦 请求数据: $body');
      }

      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ POST请求错误: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl + endpoint);
      
      debugPrint('🌐 PUT请求: $uri');
      if (headers != null) {
        debugPrint('🔑 请求头: $headers');
      }
      if (body != null) {
        debugPrint('📦 请求数据: $body');
      }

      final response = await _client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ PUT请求错误: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('🌐 DELETE请求: ${_baseUrl + endpoint}');
      
      final uri = Uri.parse(_baseUrl + endpoint);
      final response = await _client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ DELETE请求错误: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      final error = _handleErrorResponse(response);
      throw Exception(error);
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? '未知错误';
    } catch (e) {
      return '请求失败: ${response.statusCode}';
    }
  }
} 