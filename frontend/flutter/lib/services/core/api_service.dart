import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

/// API服务类
///
/// 负责处理与后端服务器的HTTP通信，封装了常用的HTTP方法（GET、POST、PUT、DELETE）
/// 提供错误处理、请求日志记录和响应解析等功能
/// 支持JWT令牌认证和请求头配置
class ApiService {
  /// 服务器基础URL，所有请求都会基于此URL构建
  final String baseUrl;

  /// 默认请求头，应用于所有HTTP请求
  final Map<String, String> defaultHeaders;

  /// 构造函数
  ///
  /// @param baseUrl 必需参数，API服务器的基础URL（例如：https://api.example.com/v1/）
  /// @param defaultHeaders 可选参数，默认的HTTP请求头，默认包含Content-Type和Accept为application/json
  ApiService({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  /// 设置授权头
  ///
  /// 根据提供的令牌创建包含授权信息的请求头
  /// @param token JWT令牌，如果提供则添加到Authorization头
  /// @param customHeaders 可选的额外请求头
  /// @return 包含默认头、授权头和自定义头的完整HTTP请求头映射
  Map<String, String> _getHeaders(String? token,
      {Map<String, String>? customHeaders}) {
    final headers = Map<String, String>.from(defaultHeaders);

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // 添加自定义请求头
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// 处理HTTP响应
  ///
  /// 解析HTTP响应体，处理成功和错误情况
  /// @param response HTTP响应对象
  /// @return 解析后的JSON数据
  /// @throws Exception 当响应状态码不在2xx范围或JSON解析失败时
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 处理成功响应（2xx状态码）
      if (response.body.isEmpty) {
        return {};
      }

      try {
        // 尝试解析JSON响应
        final jsonResponse = jsonDecode(response.body);
        debugPrint(
            '📥 API响应: ${response.statusCode} ${jsonResponse.toString().substring(0, jsonResponse.toString().length > 200 ? 200 : jsonResponse.toString().length)}...');
        return jsonResponse;
      } catch (e) {
        // JSON解析错误处理
        debugPrint(
            '⚠️ JSON解析错误: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
        throw Exception('服务器响应格式错误：无法解析JSON');
      }
    } else {
      // 处理错误响应（非2xx状态码）
      String errorMessage;

      try {
        // 尝试从错误响应中提取错误消息
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? '未知错误';
      } catch (_) {
        // 如果无法解析错误响应，根据状态码提供默认错误消息
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

      // 记录详细错误信息到控制台，便于调试
      debugPrint('HTTP错误: [${response.statusCode}] $errorMessage');
      debugPrint('请求URL: ${response.request?.url}');

      throw Exception(errorMessage);
    }
  }

  /// 包装HTTP异常
  ///
  /// 将原始异常转换为更具用户友好性的异常信息
  /// @param error 原始异常对象
  /// @return 包装后的Exception对象，包含用户友好的错误消息
  Exception _wrapException(dynamic error) {
    String message = error.toString();

    // 根据异常类型提供更具体的错误消息
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

  /// 构建请求URI
  ///
  /// @param endpoint API端点
  /// @param queryParams 查询参数（可选）
  /// @return 构建好的URI
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// 构建请求头
  ///
  /// @param token 认证令牌（可选）
  /// @param customHeaders 自定义请求头（可选）
  /// @return 完整的请求头
  Map<String, String> _buildHeaders(
      String? token, Map<String, String>? customHeaders) {
    return _getHeaders(token, customHeaders: customHeaders);
  }

  /// 发送GET请求
  ///
  /// @param path API路径（不包含baseUrl）
  /// @param queryParams 可选的URL查询参数
  /// @param token 可选的JWT令牌用于认证
  /// @param customHeaders 可选的额外请求头
  /// @return 解析后的响应数据
  /// @throws Exception 当请求失败或响应无效时
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      // 记录请求信息
      debugPrint(
          '🌐 GET请求: $baseUrl$path${queryParams != null ? "?${_formatQueryParams(queryParams)}" : ""}');
      if (token != null) {
        debugPrint('🔑 Token: 已设置');
      }
      if (customHeaders != null && customHeaders.isNotEmpty) {
        debugPrint('🔒 自定义请求头: $customHeaders');
      }

      // 执行GET请求
      final response = await http.get(
        _buildUri(path, queryParams),
        headers: _buildHeaders(token, customHeaders),
      );

      // 记录响应信息
      debugPrint(
          '📥 API响应: ${response.statusCode} ${_truncateResponse(response.body)}');
      return _handleResponse(response);
    } catch (e) {
      // 记录并包装异常
      debugPrint('❌ API错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送POST请求
  ///
  /// @param path API路径（不包含baseUrl）
  /// @param data 可选的请求体数据，将被转换为JSON
  /// @param queryParams 可选的URL查询参数
  /// @param token 可选的JWT令牌用于认证
  /// @param customHeaders 可选的额外请求头
  /// @return 解析后的响应数据
  /// @throws Exception 当请求失败或响应无效时
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      // 记录请求信息
      debugPrint('🌐 POST请求: $baseUrl$path');
      if (data != null) {
        final jsonStr = jsonEncode(data);
        debugPrint('📦 请求数据: $jsonStr');
      }
      if (token != null) {
        debugPrint('🔑 Token: 已设置');
      }
      if (customHeaders != null && customHeaders.isNotEmpty) {
        debugPrint('🔒 自定义请求头: $customHeaders');
      }

      // 执行POST请求
      final response = await http.post(
        _buildUri(path, queryParams),
        headers: _buildHeaders(token, customHeaders),
        body: data != null ? jsonEncode(data) : null,
      );

      // 记录响应信息
      debugPrint(
          '📥 API响应: ${response.statusCode} ${_truncateResponse(response.body)}');
      return _handleResponse(response);
    } catch (e) {
      // 记录并包装异常
      debugPrint('❌ API错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送PUT请求
  ///
  /// 用于更新资源
  /// @param endpoint API端点路径（不包含baseUrl）
  /// @param data 可选的请求体数据，将被转换为JSON
  /// @param token 可选的JWT令牌用于认证
  /// @param customHeaders 可选的额外请求头
  /// @return 解析后的响应数据
  /// @throws Exception 当请求失败或响应无效时
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      // 构建URI
      final uri = Uri.parse('$baseUrl$endpoint');
      final body = data != null ? jsonEncode(data) : null;

      // 记录请求信息
      debugPrint('PUT请求: $uri');
      if (customHeaders != null && customHeaders.isNotEmpty) {
        debugPrint('🔒 自定义请求头: $customHeaders');
      }

      // 执行PUT请求
      final response = await http.put(
        uri,
        headers: _buildHeaders(token, customHeaders),
        body: body,
      );

      // 处理响应
      return _handleResponse(response);
    } catch (e) {
      // 记录并包装异常
      debugPrint('PUT请求错误: $e');
      throw _wrapException(e);
    }
  }

  /// 发送DELETE请求
  ///
  /// 用于删除资源
  /// @param endpoint API端点路径（不包含baseUrl）
  /// @param data 可选参数，会被转换为URL查询参数
  /// @param token 可选的JWT令牌用于认证
  /// @param customHeaders 可选的额外请求头
  /// @return 解析后的响应数据
  /// @throws Exception 当请求失败或响应无效时
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
    Map<String, String>? customHeaders,
  }) async {
    try {
      // 构建基础URI
      final uri = Uri.parse('$baseUrl$endpoint');

      // 将data中的参数添加为URL查询参数（DELETE请求通常不包含请求体）
      Uri requestUri = uri;
      if (data != null && data.isNotEmpty) {
        requestUri = uri.replace(queryParameters: data);
        debugPrint('DELETE请求参数: $data');
      }

      // 记录请求信息
      debugPrint('DELETE请求: $requestUri');
      if (customHeaders != null && customHeaders.isNotEmpty) {
        debugPrint('🔒 自定义请求头: $customHeaders');
      }

      // 执行DELETE请求
      final response = await http.delete(
        requestUri,
        headers: _buildHeaders(token, customHeaders),
      );

      // 特殊处理204状态码（成功但无内容）
      if (response.statusCode == 204) {
        debugPrint('DELETE请求成功，状态码: 204 No Content');
        return {'success': true, 'status': 'success'};
      }

      // 处理其他响应
      return _handleResponse(response);
    } catch (e) {
      // 记录并包装异常
      debugPrint('DELETE请求错误: $e');
      throw _wrapException(e);
    }
  }

  /// 格式化查询参数，用于日志输出
  ///
  /// @param params 查询参数映射
  /// @return 格式化后的查询字符串
  String _formatQueryParams(Map<String, dynamic> params) {
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  /// 截断长响应，用于日志输出
  ///
  /// @param data 响应数据
  /// @return 截断后的字符串（如果原字符串过长）
  String _truncateResponse(dynamic data) {
    final str = data.toString();
    if (str.length > 200) {
      return '${str.substring(0, 200)}...';
    }
    return str;
  }
}
