/// API服务接口
/// 
/// 定义与后端API交互的抽象接口
abstract class IApiService {
  /// GET请求
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  /// POST请求
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  /// PUT请求
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  /// DELETE请求
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  /// 上传文件
  Future<Map<String, dynamic>> uploadFile(
    String path,
    String filePath, {
    String? fieldName,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  });
  
  /// 设置认证令牌
  void setAuthToken(String? token);
  
  /// 清除认证令牌
  void clearAuthToken();
}