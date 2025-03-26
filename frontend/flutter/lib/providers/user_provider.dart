import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;
  // 当前活跃的角色 (user, nutritionist, merchant)
  String _activeRole = 'user';

  User? get user => _user;
  String? get token => _token;
  String get activeRole => _activeRole;

  bool get isLoggedIn => _user != null && _token != null;
  
  // 判断是否是营养师身份
  bool get isNutritionistActive => _activeRole == 'nutritionist';
  
  // 判断是否是商家身份
  bool get isMerchantActive => _activeRole == 'merchant';
  
  // 判断是否是普通用户身份
  bool get isUserActive => _activeRole == 'user';
  
  // 判断是否有管理员权限
  bool get isAdmin => _user != null && _user!.role == 'admin';

  void login(User user, String token) {
    _user = user;
    _token = token;
    // 默认使用用户的主要角色
    _activeRole = user.role;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _token = null;
    _activeRole = 'user';
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
  
  // 设置用户信息
  void setUser(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    // 如果没有设置活跃角色，则使用用户的主要角色
    if (_activeRole == 'user') {
      _activeRole = _user!.role;
    }
    notifyListeners();
  }
  
  // 设置JWT令牌
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
  
  // 切换到普通用户身份
  void switchToUserRole() {
    if (_activeRole != 'user') {
      _activeRole = 'user';
      notifyListeners();
    }
  }
  
  // 切换到营养师身份
  bool switchToNutritionistRole({BuildContext? context}) {
    if (_user == null) return false;
    
    // 检查用户是否有营养师权限
    if (_user!.canSwitchToNutritionist()) {
      _activeRole = 'nutritionist';
      notifyListeners();
      
      // 如果提供了context，导航到营养师界面
      if (context != null) {
        Navigator.pushReplacementNamed(context, '/nutritionist/home');
      }
      
      return true;
    }
    return false;
  }
  
  // 切换到商家身份
  bool switchToMerchantRole({BuildContext? context}) {
    if (_user == null) return false;
    
    // 检查用户是否有商家权限
    if (_user!.canSwitchToMerchant()) {
      _activeRole = 'merchant';
      notifyListeners();
      
      // 如果提供了context，导航到商家界面
      if (context != null) {
        Navigator.pushReplacementNamed(context, '/merchant/home');
      }
      
      return true;
    }
    return false;
  }
  
  // 检查用户是否有管理员权限
  bool canAccessAdminFeatures() {
    return _user != null && _user!.role == 'admin';
  }
  
  // 申请营养师认证
  Future<Map<String, dynamic>> applyForNutritionistVerification(String certificateUrl, String description) async {
    if (!isLoggedIn || _token == null) {
      return {
        'success': false,
        'message': '请先登录'
      };
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/users/nutritionist-verification');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode({
          'certificateUrl': certificateUrl,
          'description': description
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // 更新用户信息
        if (responseData['user'] != null) {
          _user = User.fromJson(responseData['user']);
          notifyListeners();
        }
        
        return {
          'success': true,
          'message': responseData['message'] ?? '申请已提交，请等待审核'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '申请失败'
        };
      }
    } catch (e) {
      print('申请营养师认证出错: $e');
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 检查营养师认证状态
  Future<Map<String, dynamic>> checkNutritionistVerificationStatus() async {
    if (!isLoggedIn || _token == null) {
      return {
        'success': false,
        'message': '请先登录'
      };
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/users/nutrition-verification-status');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token'
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // 更新用户信息
        if (responseData['user'] != null) {
          _user = User.fromJson(responseData['user']);
          notifyListeners();
        }
        
        return {
          'success': true,
          'status': responseData['status'],
          'message': responseData['message'] ?? '查询成功'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '查询失败'
        };
      }
    } catch (e) {
      print('查询营养师认证状态出错: $e');
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 管理员功能：审核营养师认证
  Future<Map<String, dynamic>> reviewNutritionistVerification(String userId, bool approved, {String? rejectionReason}) async {
    if (!isLoggedIn || _token == null) {
      return {
        'success': false,
        'message': '请先登录'
      };
    }
    
    if (!canAccessAdminFeatures()) {
      return {
        'success': false,
        'message': '您没有管理员权限'
      };
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/review-nutritionist');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode({
          'userId': userId,
          'approved': approved,
          'rejectionReason': rejectionReason,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? (approved ? '已批准该用户的营养师认证' : '已拒绝该用户的营养师认证')
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '操作失败'
        };
      }
    } catch (e) {
      print('审核营养师认证出错: $e');
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 管理员功能：生成商家注册码
  Future<Map<String, dynamic>> generateMerchantCodes(int count, int validityDays) async {
    if (!isLoggedIn || _token == null) {
      return {
        'success': false,
        'message': '请先登录'
      };
    }
    
    if (!canAccessAdminFeatures()) {
      return {
        'success': false,
        'message': '您没有管理员权限'
      };
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/merchant-codes');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode({
          'count': count,
          'validityDays': validityDays,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'codes': responseData['codes'],
          'message': responseData['message'] ?? '已成功生成注册码'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '生成注册码失败'
        };
      }
    } catch (e) {
      print('生成商家注册码出错: $e');
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
}
