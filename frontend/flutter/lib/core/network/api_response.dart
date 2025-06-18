/// API响应包装类
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? code;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.code,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error, {int? code}) {
    return ApiResponse(
      success: false,
      error: error,
      code: code,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      success: (json['success'] as bool?) ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T?) toJsonT) {
    return {
      'success': success,
      'data': toJsonT(data),
      'message': message,
      'error': error,
      'code': code,
    };
  }
}