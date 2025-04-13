import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/health/nutrition_profile_model.dart';
import '../../utils/global_error_handler.dart';
import '../core/api_service.dart';
import '../core/auth_service.dart';
import '../../providers/core/auth_provider.dart';
import '../../common/constants/api_constants.dart';
import 'package:dio/dio.dart';

class HealthProfileService {
  final ApiService _apiService;
  final AuthService _authService;
  final _errorHandler = GlobalErrorHandler();
  final AuthProvider? _authProvider;

  HealthProfileService(this._apiService, this._authService,
      [this._authProvider]);

  /// 获取用户的所有健康档案
  ///
  /// 返回当前用户的所有健康档案列表
  Future<List<NutritionProfile>> fetchProfilesByUserId() async {
    debugPrint('开始获取健康档案列表...');

    try {
      final authToken = await _authService.getToken();
      debugPrint('获取健康档案列表 - 认证Token: ${authToken != null ? '已获取' : '未获取'}');

      if (authToken == null) {
        throw Exception('未登录，请先登录');
      }

      // 获取用户ID
      String? userId = await _getUserId();
      debugPrint('获取健康档案列表 - 用户ID: $userId');

      if (userId == null || userId.isEmpty) {
        throw Exception('无法获取用户ID');
      }

      // 使用API常量构建请求
      final response = await _apiService.get(
        ApiConstants.nutritionProfiles,
        token: authToken,
        customHeaders: {
          'x-user-id': userId,
        },
      );

      debugPrint('健康档案列表API响应: $response');

      // 检查响应格式
      List profilesData = [];

      // 处理不同的响应格式
      if (response['data'] != null && response['data']['profiles'] != null) {
        profilesData = response['data']['profiles'] as List;
      } else if (response['profiles'] != null) {
        profilesData = response['profiles'] as List;
      } else if (response['data'] != null) {
        profilesData = [response['data']];
      }

      debugPrint('解析到的档案列表数据: $profilesData');

      if (profilesData.isEmpty) {
        debugPrint('健康档案列表为空');
        return [];
      }

      // 转换为模型对象
      final profiles = profilesData.map((profileJson) {
        debugPrint('开始转换JSON数据: $profileJson');
        final profile = NutritionProfile.fromJson(profileJson);
        debugPrint('转换后的档案对象: $profile');
        return profile;
      }).toList();

      debugPrint('健康档案列表获取成功，档案数量: ${profiles.length}');
      return profiles;
    } catch (e) {
      debugPrint('获取健康档案列表异常: $e');
      throw Exception('获取健康档案列表失败: $e');
    }
  }

  /// 从多个来源获取用户ID
  Future<String?> _getUserId() async {
    String? userId;

    // 1. 从AuthProvider获取
    if (_authProvider != null) {
      userId = _authProvider!.userId;
      if (userId != null && userId.isNotEmpty) {
        debugPrint('从AuthProvider获取用户ID: $userId');
        return userId;
      }
    }

    // 2. 从JWT令牌解析
    String? token = await _authService.getToken();
    userId = await _authService.getUserIdFromToken(token);
    if (userId != null && userId.isNotEmpty) {
      debugPrint('从令牌中解析用户ID: $userId');
      if (_authProvider != null) {
        await _authProvider!.updateUserInfo(userId: userId);
      }
      return userId;
    }

    // 3. 从用户信息接口获取
    try {
      final userInfo = await _authService.getUserInfo();
      userId = userInfo['userId'] ?? userInfo['_id'];
      if (userId != null && userId.isNotEmpty) {
        debugPrint('从用户信息接口获取用户ID: $userId');
        if (_authProvider != null) {
          await _authProvider!.updateUserInfo(userId: userId);
        }
        return userId;
      }
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
    }

    return null;
  }

  /// 获取单个健康档案详情
  ///
  /// [id] 档案ID
  Future<NutritionProfile> getProfileById(String id) async {
    try {
      debugPrint('开始获取健康档案详情: $id');

      final authToken = await _authService.getToken();
      if (authToken == null) {
        throw Exception('未登录，请先登录');
      }

      // 获取用户ID
      String? userId;
      if (_authProvider != null) {
        userId = _authProvider!.userId;
      }
      if (userId == null || userId.isEmpty) {
        userId = await _authService.getUserIdFromToken(authToken);
      }
      if (userId == null || userId.isEmpty) {
        throw Exception('无法获取用户ID');
      }

      final response = await _apiService.get(
        ApiConstants.nutritionProfiles + '/' + id,
        token: authToken,
        customHeaders: {
          'x-user-id': userId, // 添加必需的x-user-id头
        },
      );

      if (response['success'] == true && response['data'] != null) {
        debugPrint('健康档案详情获取成功');
        return NutritionProfile.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? '获取健康档案详情失败');
      }
    } catch (e) {
      debugPrint('获取健康档案详情异常: $e');
      rethrow;
    }
  }

  /// 创建健康档案
  ///
  /// [profile] 新的健康档案数据
  Future<Map<String, dynamic>> createProfile(NutritionProfile profile) async {
    try {
      debugPrint('开始创建营养档案...');
      // 获取认证Token
      final authToken = await _authService.getToken();
      if (authToken == null) {
        debugPrint('无法创建档案：未登录或Token失效');
        return {'success': false, 'message': '无法创建档案：未登录或Token失效'};
      }

      // 获取用户ID
      String? userId;
      if (_authProvider != null) {
        userId = _authProvider!.userId;
      }
      if (userId == null || userId.isEmpty) {
        userId = await _authService.getUserIdFromToken(authToken);
      }
      if (userId == null || userId.isEmpty) {
        return {'success': false, 'message': '无法获取用户ID'};
      }

      // 准备请求数据
      final profileData = profile.toJson();
      debugPrint('准备提交的档案数据: $profileData');

      // 确保profileName字段存在且不为空
      if (profileData['profileName'] == null ||
          profileData['profileName'].toString().trim().isEmpty) {
        debugPrint('错误：档案名称为空');
        return {'success': false, 'message': '档案名称不能为空'};
      }

      // 职业映射修正，确保使用后端允许的枚举值
      if (profileData['occupation'] == 'labor') {
        profileData['occupation'] = 'physical_worker';
        debugPrint('将职业labor映射为physical_worker');
      }

      // 移除前端特有字段，避免与后端模型冲突
      profileData.remove('id');

      // 确保营养目标使用正确的枚举值
      if (profileData.containsKey('nutritionGoals') &&
          profileData['nutritionGoals'] is List) {
        profileData['nutritionGoals'] =
            (profileData['nutritionGoals'] as List).map((goal) {
          if (goal == 'blood_sugar_control') {
            return 'disease_management';
          }
          return goal;
        }).toList();
      }

      // 打印最终请求数据，用于调试
      debugPrint('最终提交的档案数据: $profileData');

      // 发送创建请求
      final response = await _apiService.post(
        ApiConstants.nutritionProfiles,
        data: profileData,
        token: authToken,
        customHeaders: {
          'x-user-id': userId, // 添加必需的x-user-id头
        },
      );

      debugPrint('创建档案API响应: $response');

      // 检查响应状态
      bool isSuccessful = false;
      if (response['success'] == true) {
        isSuccessful = true;
      } else if (response['status'] == 'success') {
        isSuccessful = true;
      }

      if (isSuccessful) {
        // 检查profile字段是否存在于response中
        if (response['profile'] != null) {
          debugPrint('档案创建成功: ${response['profile']}');
          return {
            'success': true,
            'message': '档案创建成功',
            'profile': response['profile']
          };
        }
        // 兼容旧格式，也可能profile数据在data字段中
        else if (response['data'] != null &&
            response['data']['profile'] != null) {
          debugPrint('档案创建成功(data.profile字段): ${response['data']['profile']}');
          return {
            'success': true,
            'message': '档案创建成功',
            'profile': response['data']['profile']
          };
        }
        // 兼容data字段直接包含profile数据
        else if (response['data'] != null) {
          debugPrint('档案创建成功(data字段): ${response['data']}');
          return {
            'success': true,
            'message': '档案创建成功',
            'profile': response['data']
          };
        }
        // 如果返回success但没有返回数据
        else {
          debugPrint('档案创建成功但没有返回数据，返回消息: ${response['message']}');
          return {'success': false, 'message': '创建成功但没有获取到档案数据'};
        }
      } else {
        final errorMessage = response['message'] ?? '创建档案失败';
        debugPrint('档案创建失败: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      debugPrint('创建档案过程中发生异常: $e');
      return {'success': false, 'message': '创建档案时出错: $e'};
    }
  }

  /// 更新健康档案
  ///
  /// [id] 档案ID
  /// [profile] 更新的档案数据
  Future<Map<String, dynamic>> updateProfile(
      String id, NutritionProfile profile) async {
    try {
      debugPrint('开始更新健康档案: $id');

      final authToken = await _authService.getToken();
      if (authToken == null) {
        return {'success': false, 'message': '未登录，请先登录'};
      }

      // 获取用户ID
      String? userId;
      if (_authProvider != null) {
        userId = _authProvider!.userId;
      }
      if (userId == null || userId.isEmpty) {
        userId = await _authService.getUserIdFromToken(authToken);
      }
      if (userId == null || userId.isEmpty) {
        return {'success': false, 'message': '无法获取用户ID'};
      }

      // 确保profileName字段存在且不为空
      final profileData = profile.toJson();
      debugPrint('更新档案的数据: $profileData');

      if (profileData['profileName'] == null ||
          profileData['profileName'].toString().trim().isEmpty) {
        debugPrint('错误：档案名称为空');
        return {'success': false, 'message': '档案名称不能为空'};
      }

      // 职业映射修正，确保使用后端允许的枚举值
      if (profileData['occupation'] == 'labor') {
        profileData['occupation'] = 'physical_worker';
        debugPrint('将职业labor映射为physical_worker');
      }

      // 移除不需要更新的字段
      profileData.remove('id'); // ID不应该被更新
      profileData.remove('userId'); // 用户ID不应该被更新
      profileData.remove('createdAt'); // 创建时间不应该被更新

      // 确保营养目标使用正确的枚举值
      if (profileData.containsKey('nutritionGoals') &&
          profileData['nutritionGoals'] is List) {
        profileData['nutritionGoals'] =
            (profileData['nutritionGoals'] as List).map((goal) {
          if (goal == 'blood_sugar_control') {
            return 'disease_management';
          }
          return goal;
        }).toList();
      }

      // 打印最终请求数据，用于调试
      debugPrint('最终提交的更新数据: $profileData');

      // 使用正确的API路径
      final response = await _apiService.put(
        ApiConstants.nutritionProfiles + '/' + id,
        data: profileData,
        token: authToken,
        customHeaders: {
          'x-user-id': userId, // 添加必需的x-user-id头
        },
      );

      debugPrint('更新档案API响应: $response');

      // 检查响应状态
      bool isSuccessful = false;
      if (response['success'] == true) {
        isSuccessful = true;
      } else if (response['status'] == 'success') {
        isSuccessful = true;
      }

      if (isSuccessful) {
        var updatedProfile;

        // 检查不同可能的返回格式
        if (response['profile'] != null) {
          updatedProfile = response['profile'];
        } else if (response['data'] != null &&
            response['data']['profile'] != null) {
          updatedProfile = response['data']['profile'];
        } else if (response['data'] != null) {
          updatedProfile = response['data'];
        }

        debugPrint('档案更新成功: $updatedProfile');

        return {
          'success': true,
          'message': '档案更新成功',
          'profile': updatedProfile
        };
      } else {
        final errorMessage = response['message'] ?? '更新档案失败';
        debugPrint('档案更新失败: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      debugPrint('更新档案异常: $e');
      return {'success': false, 'message': '更新档案时出错: $e'};
    }
  }

  /// 删除健康档案
  ///
  /// [profileId] 档案ID
  Future<bool> deleteProfile(String profileId) async {
    try {
      // 验证ID格式
      if (profileId.isEmpty || profileId.length != 24) {
        debugPrint('档案ID格式无效: $profileId，应为24位的十六进制字符串');
        return false;
      }

      debugPrint('开始删除健康档案: $profileId');

      final authToken = await _authService.getToken();
      if (authToken == null) {
        throw Exception('未登录，请先登录');
      }

      // 获取用户ID
      String? userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('无法获取用户ID');
      }

      // 打印调试信息
      debugPrint('删除请求: 档案ID=$profileId, 用户ID=$userId');

      // 使用API常量发起请求
      final response = await _apiService.delete(
        '${ApiConstants.nutritionProfiles}/$profileId',
        token: authToken,
        customHeaders: {
          'x-user-id': userId,
        },
      );

      debugPrint('删除档案API响应: $response');

      // 检查响应状态（状态码204通常表示成功但无内容）
      bool isSuccessful = false;
      if (response['success'] == true) {
        isSuccessful = true;
      } else if (response['status'] == 'success') {
        isSuccessful = true;
      } else if (response.isEmpty) {
        // DELETE请求返回204时，响应体可能为空，这是正常的
        isSuccessful = true;
      }

      if (isSuccessful) {
        debugPrint('健康档案删除成功');
        return true;
      } else {
        final errorMessage = response['message'] ?? '删除失败';
        debugPrint('健康档案删除失败: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('删除健康档案异常: $e');

      // 检查是否是404错误（资源不存在）
      if (e.toString().contains('404') ||
          e.toString().contains('未找到指定的营养档案') ||
          e.toString().contains('档案不存在') ||
          e.toString().contains('没有找到ID为') ||
          e.toString().contains('No profile found')) {
        // 如果是404错误，说明档案不存在，返回false而不是抛出异常
        debugPrint('档案不存在，删除失败');
        return false;
      }

      // 检查是否是ID格式错误
      if (e.toString().contains('格式无效') ||
          e.toString().contains('Cast') ||
          e.toString().contains('Invalid ObjectId')) {
        debugPrint('档案ID格式无效，删除失败');
        return false;
      }

      // 其他错误则重新抛出
      rethrow;
    }
  }
}
