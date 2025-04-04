/// API响应模型类
/// 用于处理API请求的响应数据
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  final String? code;
  final int? statusCode;

  /// 构造函数
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.code,
    this.statusCode,
  });

  /// 从JSON转换为对象
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'],
      code: json['code'],
      statusCode: json['statusCode'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'success': success,
    };
    
    if (this.data != null) data['data'] = this.data;
    if (message != null) data['message'] = message;
    if (code != null) data['code'] = code;
    if (statusCode != null) data['statusCode'] = statusCode;
    
    return data;
  }

  /// 创建成功响应
  factory ApiResponse.success(dynamic data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: 200,
    );
  }

  /// 创建失败响应
  factory ApiResponse.failure(String message, {String? code, int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      code: code,
      statusCode: statusCode ?? 400,
    );
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, data: $data, message: $message, code: $code, statusCode: $statusCode}';
  }
} 