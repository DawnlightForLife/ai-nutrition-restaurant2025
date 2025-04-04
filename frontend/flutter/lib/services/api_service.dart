import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

/// API服务
///
/// 提供HTTP请求方法，处理服务器通信
class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  /// 设置授权头
  Map<String, String> _getHeaders(String? token) {
    final headers = Map<String, String>.from(defaultHeaders);
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// 处理HTTP响应
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      
      try {
        final jsonResponse = jsonDecode(response.body);
        debugPrint('📥 API响应: ${response.statusCode} ${jsonResponse.toString().substring(0, jsonResponse.toString().length > 200 ? 200 : jsonResponse.toString().length)}...');
        return jsonResponse;
      } catch (e) {
        debugPrint('⚠️ JSON解析错误: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
        throw Exception('服务器响应格式错误：无法解析JSON');
      }
    } else {
      String errorMessage;
      
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? '未知错误';
      } catch (_) {
        // 根据状态码提供更具体的错误消息
        switch (response.statusCode) {
          case 400:
            errorMessage = '请求参数错误 (400)';
            break;
          case 401:
            errorMessage = '未授权，请重新登录 (401)';
            break;
          case 403:
            errorMessage = '权限不足，无法访问 (403)';
            break;
          case 404:
            errorMessage = '请求的资源不存在，请检查API地址 (404)';
            break;
          case 500:
            errorMessage = '服务器内部错误 (500)';
            break;
          case 502:
            errorMessage = '网关错误 (502)';
            break;
          case 503:
            errorMessage = '服务暂时不可用 (503)';
            break;
          case 504:
            errorMessage = '网关超时 (504)';
            break;
          default:
            errorMessage = '服务器错误: ${response.statusCode}';
        }
      }
      
      // 记录详细错误信息到控制台
      debugPrint('HTTP错误: [${response.statusCode}] $errorMessage');
      debugPrint('请求URL: ${response.request?.url}');
      
      throw Exception(errorMessage);
    }
  }
  
  /// 包装HTTP异常
  Exception _wrapException(dynamic error) {
    String message = error.toString();
    
    // 提供更友好的网络错误消息
    if (message.contains('SocketException') || 
        message.contains('Connection refused') ||
        message.contains('Network is unreachable')) {
      return Exception('无法连接到服务器，请检查网络连接');
    } else if (message.contains('timed out')) {
      return Exception('请求超时，服务器响应时间过长');
    } else if (message.contains('Certificate')) {
      return Exception('SSL证书验证失败，请确认网络安全');
    } else {
      return Exception('网络请求失败: $message');
    }
  }

  /// 发送GET请求
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      debugPrint('🌐 GET请求: $baseUrl$path${queryParams != null ? "?${_formatQueryParams(queryParams)}" : ""}');
      if (token != null) {
        debugPrint('🔑 Token: 已设置');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$path${queryParams != null ? "?${_formatQueryParams(queryParams)}" : ""}'),
        headers: _getHeaders(token),
      );

      debugPrint('📥 API响应: ${response.statusCode} ${_truncateResponse(response.body)}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ API错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送POST请求
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      debugPrint('🌐 POST请求: $baseUrl$path');
      if (data != null) {
        final jsonStr = jsonEncode(data);
        debugPrint('📦 请求数据: $jsonStr');
      }
      if (token != null) {
        debugPrint('🔑 Token: 已设置');
      }

      final uri = Uri.parse('$baseUrl$path');
      final queryUri = queryParams != null ? uri.replace(queryParameters: queryParams) : uri;

      final response = await http.post(
        queryUri,
        headers: _getHeaders(token),
        body: data != null ? jsonEncode(data) : null,
      );

      debugPrint('📥 API响应: ${response.statusCode} ${_truncateResponse(response.body)}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ API错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送PUT请求
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final body = data != null ? jsonEncode(data) : null;
      
      debugPrint('PUT请求: $uri');
      
      final response = await http.put(
        uri,
        headers: _getHeaders(token),
        body: body,
      );
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('PUT请求错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送DELETE请求
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      
      // 将data中的参数添加为URL查询参数
      Uri requestUri = uri;
      if (data != null && data.isNotEmpty) {
        requestUri = uri.replace(queryParameters: data);
        debugPrint('DELETE请求参数: $data');
      }
      
      debugPrint('DELETE请求: $requestUri');
      
      final response = await http.delete(
        requestUri,
        headers: _getHeaders(token),
      );
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE请求错误: $e');
      throw _wrapException(e);
    }
  }

  // 格式化查询参数，用于日志
  String _formatQueryParams(Map<String, dynamic> params) {
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  // 截断长响应，用于日志
  String _truncateResponse(dynamic data) {
    final str = data.toString();
    if (str.length > 200) {
      return '${str.substring(0, 200)}...';
    }
    return str;
  }
}
