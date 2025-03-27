import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';

/// API助手类 - 提供统一的API调用、错误处理和日志记录
class ApiHelper {
  /// 执行GET请求
  static Future<Map<String, dynamic>> get(
    String url, {
    String? token,
    Map<String, String>? headers,
    required String logPrefix,
    int timeout = 30,
  }) async {
    return _executeRequest(
      () => http.get(
        Uri.parse(url),
        headers: _buildHeaders(token, headers),
      ).timeout(Duration(seconds: timeout)),
      logPrefix: logPrefix,
      url: url,
    );
  }

  /// 执行POST请求
  static Future<Map<String, dynamic>> post(
    String url, {
    required Map<String, dynamic> data,
    String? token,
    Map<String, String>? headers,
    required String logPrefix,
    int timeout = 30,
  }) async {
    return _executeRequest(
      () => http.post(
        Uri.parse(url),
        headers: _buildHeaders(token, headers),
        body: jsonEncode(data),
      ).timeout(Duration(seconds: timeout)),
      logPrefix: logPrefix,
      url: url,
      data: data,
    );
  }

  /// 执行PUT请求
  static Future<Map<String, dynamic>> put(
    String url, {
    required Map<String, dynamic> data,
    String? token,
    Map<String, String>? headers,
    required String logPrefix,
    int timeout = 30,
  }) async {
    return _executeRequest(
      () => http.put(
        Uri.parse(url),
        headers: _buildHeaders(token, headers),
        body: jsonEncode(data),
      ).timeout(Duration(seconds: timeout)),
      logPrefix: logPrefix,
      url: url,
      data: data,
    );
  }

  /// 执行DELETE请求
  static Future<Map<String, dynamic>> delete(
    String url, {
    String? token,
    Map<String, String>? headers,
    required String logPrefix,
    int timeout = 30,
  }) async {
    return _executeRequest(
      () => http.delete(
        Uri.parse(url),
        headers: _buildHeaders(token, headers),
      ).timeout(Duration(seconds: timeout)),
      logPrefix: logPrefix,
      url: url,
    );
  }

  /// 构建请求头
  static Map<String, String> _buildHeaders(String? token, Map<String, String>? additionalHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// 执行请求并处理响应
  static Future<Map<String, dynamic>> _executeRequest(
    Future<http.Response> Function() requestFunc, {
    required String logPrefix,
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      print('[$logPrefix] 请求URL: $url');
      if (data != null) {
        final logData = Map<String, dynamic>.from(data);
        // 屏蔽密码等敏感信息
        if (logData.containsKey('password')) {
          logData['password'] = '******';
        }
        print('[$logPrefix] 请求数据: ${jsonEncode(logData)}');
      }

      final response = await requestFunc();
      
      print('[$logPrefix] 响应状态码: ${response.statusCode}');
      
      final Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
        print('[$logPrefix] 响应数据: success=${responseData["success"]}, message=${responseData["message"]}');
      } catch (e) {
        print('[$logPrefix] 解析响应数据错误: $e');
        print('[$logPrefix] 原始响应体: ${response.body.substring(0, min(100, response.body.length))}...');
        return {
          'success': false,
          'message': '服务器返回数据格式错误',
          'error': e.toString(),
          'statusCode': response.statusCode,
        };
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        print('[$logPrefix] 请求失败: ${responseData["message"]}');
        return {
          'success': false,
          'message': responseData['message'] ?? '请求失败',
          'statusCode': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      print('[$logPrefix] 请求出错: $e');
      return {
        'success': false,
        'message': '网络错误',
        'error': e.toString(),
      };
    }
  }

  /// 显示错误提示对话框
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示成功提示
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 