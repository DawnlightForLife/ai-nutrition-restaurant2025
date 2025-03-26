import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/admin.dart';
import '../constants/api.dart';

class AdminProvider with ChangeNotifier {
  Admin? _currentAdmin;
  List<Admin> _admins = [];
  bool _isLoading = false;
  String? _error;

  Admin? get currentAdmin => _currentAdmin;
  List<Admin> get admins => _admins;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 检查当前管理员是否有特定权限
  bool hasPermission(String permission) {
    if (_currentAdmin == null) return false;
    return _currentAdmin!.hasPermission(permission);
  }
  
  // 设置当前管理员
  void setCurrentAdmin(Map<String, dynamic> adminData) {
    _currentAdmin = Admin.fromJson(adminData);
    notifyListeners();
  }
  
  // 清除管理员信息（登出时使用）
  void clearAdmin() {
    _currentAdmin = null;
    _admins = [];
    notifyListeners();
  }
  
  // 获取所有管理员列表
  Future<bool> fetchAdmins(String token) async {
    if (_currentAdmin == null) return false;
    
    // 检查是否有管理员管理权限
    if (!_currentAdmin!.hasPermission(AdminPermission.adminManagement)) {
      _error = '没有权限管理管理员账号';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/admins');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        final List<dynamic> adminList = responseData['admins'];
        _admins = adminList.map((admin) => Admin.fromJson(admin)).toList();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? '获取管理员列表失败';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '网络错误: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // 创建新管理员
  Future<Map<String, dynamic>> createAdmin({
    required String token,
    required String username,
    required String password,
    required String nickname,
    required String email,
    String? phone,
    required List<String> permissions,
    required bool isActive,
  }) async {
    if (_currentAdmin == null) {
      return {
        'success': false,
        'message': '未登录管理员账号'
      };
    }
    
    // 检查是否有管理员管理权限
    if (!_currentAdmin!.hasPermission(AdminPermission.adminManagement)) {
      return {
        'success': false,
        'message': '没有权限创建管理员账号'
      };
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/admins');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'nickname': nickname,
          'email': email,
          'phone': phone,
          'permissions': permissions,
          'isActive': isActive,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      _isLoading = false;
      notifyListeners();
      
      if (response.statusCode == 201 && responseData['success'] == true) {
        // 添加到本地列表
        if (responseData['admin'] != null) {
          final newAdmin = Admin.fromJson(responseData['admin']);
          _admins.add(newAdmin);
          notifyListeners();
        }
        
        return {
          'success': true,
          'message': responseData['message'] ?? '管理员创建成功',
          'admin': responseData['admin']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '创建管理员失败'
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 更新管理员信息
  Future<Map<String, dynamic>> updateAdmin({
    required String token,
    required String adminId,
    String? nickname,
    String? email,
    String? phone,
    List<String>? permissions,
    bool? isActive,
  }) async {
    if (_currentAdmin == null) {
      return {
        'success': false,
        'message': '未登录管理员账号'
      };
    }
    
    // 检查是否有管理员管理权限
    if (!_currentAdmin!.hasPermission(AdminPermission.adminManagement)) {
      return {
        'success': false,
        'message': '没有权限更新管理员账号'
      };
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/admins/$adminId');
      
      final Map<String, dynamic> updateData = {};
      if (nickname != null) updateData['nickname'] = nickname;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (permissions != null) updateData['permissions'] = permissions;
      if (isActive != null) updateData['isActive'] = isActive;
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(updateData),
      );
      
      final responseData = jsonDecode(response.body);
      
      _isLoading = false;
      notifyListeners();
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // 更新本地列表
        if (responseData['admin'] != null) {
          final updatedAdmin = Admin.fromJson(responseData['admin']);
          final index = _admins.indexWhere((admin) => admin.id == adminId);
          if (index >= 0) {
            _admins[index] = updatedAdmin;
            notifyListeners();
          }
          
          // 如果更新的是当前管理员，同时更新currentAdmin
          if (_currentAdmin?.id == adminId) {
            _currentAdmin = updatedAdmin;
            notifyListeners();
          }
        }
        
        return {
          'success': true,
          'message': responseData['message'] ?? '管理员信息更新成功',
          'admin': responseData['admin']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '更新管理员信息失败'
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 删除管理员
  Future<Map<String, dynamic>> deleteAdmin({
    required String token,
    required String adminId,
  }) async {
    if (_currentAdmin == null) {
      return {
        'success': false,
        'message': '未登录管理员账号'
      };
    }
    
    // 检查是否有管理员管理权限
    if (!_currentAdmin!.hasPermission(AdminPermission.adminManagement)) {
      return {
        'success': false,
        'message': '没有权限删除管理员账号'
      };
    }
    
    // 不能删除自己
    if (_currentAdmin!.id == adminId) {
      return {
        'success': false,
        'message': '不能删除当前登录的管理员账号'
      };
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/admins/$adminId');
      
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      _isLoading = false;
      notifyListeners();
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // 从本地列表中移除
        _admins.removeWhere((admin) => admin.id == adminId);
        notifyListeners();
        
        return {
          'success': true,
          'message': responseData['message'] ?? '管理员删除成功'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '删除管理员失败'
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
  
  // 重置管理员密码
  Future<Map<String, dynamic>> resetAdminPassword({
    required String token,
    required String adminId,
    required String newPassword,
  }) async {
    if (_currentAdmin == null) {
      return {
        'success': false,
        'message': '未登录管理员账号'
      };
    }
    
    // 检查是否有管理员管理权限
    if (!_currentAdmin!.hasPermission(AdminPermission.adminManagement)) {
      return {
        'success': false,
        'message': '没有权限重置管理员密码'
      };
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/admins/$adminId/reset-password');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'newPassword': newPassword,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      _isLoading = false;
      notifyListeners();
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? '密码重置成功'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '密码重置失败'
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': false,
        'message': '网络错误: $e'
      };
    }
  }
} 