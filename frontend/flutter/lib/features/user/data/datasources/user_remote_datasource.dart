import 'dart:io';
import 'package:dio/dio.dart';

/// 用户远程数据源
class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  /// 检查用户是否已设置密码
  Future<bool> checkHasPassword() async {
    try {
      final response = await _dio.get('/users/has-password');
      return response.data['data']['hasPassword'] ?? false;
    } catch (e) {
      // 如果接口出错，默认返回true（假设有密码）以保证安全
      return true;
    }
  }

  /// 设置密码（新用户）
  Future<void> setPassword(String newPassword) async {
    try {
      await _dio.post('/users/set-password', data: {
        'password': newPassword,
      });
    } catch (e) {
      throw Exception('设置密码失败');
    }
  }

  /// 修改密码（已有密码的用户）
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _dio.post('/users/change-password', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw Exception('修改密码失败');
    }
  }

  /// 更新个人资料
  Future<Map<String, dynamic>> updateProfile(dynamic profileUpdate) async {
    try {
      // 始终使用FormData，这样可以统一处理有文件和无文件的情况
      Map<String, dynamic> formDataMap = {};
      
      if (profileUpdate.nickname != null) {
        formDataMap['nickname'] = profileUpdate.nickname;
      }
      if (profileUpdate.bio != null) {
        formDataMap['bio'] = profileUpdate.bio;
      }
      if (profileUpdate.avatarFile != null) {
        // 获取原始文件的扩展名
        final originalPath = profileUpdate.avatarFile!.path;
        final extension = originalPath.split('.').last.toLowerCase();
        final filename = 'avatar.$extension';
        
        formDataMap['avatar'] = await MultipartFile.fromFile(
          originalPath,
          filename: filename,
        );
      }
      
      FormData formData = FormData.fromMap(formDataMap);
      final response = await _dio.put('/users/profile', data: formData);
      
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '更新失败');
      }
    } catch (e) {
      throw Exception('更新个人资料失败: ${e.toString()}');
    }
  }
}