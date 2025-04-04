import 'package:flutter/material.dart';

/// 验证工具类
///
/// 提供各种表单验证方法
class Validators {
  /// 验证手机号
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    
    if (value.length != 11) {
      return '手机号必须为11位';
    }
    
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
      return '请输入有效的手机号';
    }
    
    return null;
  }
  
  /// 验证验证码
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validateCode(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    
    if (value.length != length) {
      return '验证码必须为$length位';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '验证码只能包含数字';
    }
    
    return null;
  }
  
  /// 验证密码
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    
    if (value.length < minLength) {
      return '密码长度不能少于$minLength位';
    }
    
    // 密码强度检查 - 要求包含字母和数字
    bool hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    
    if (!hasLetter || !hasDigit) {
      return '密码必须同时包含字母和数字';
    }
    
    return null;
  }
  
  /// 验证确认密码
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '请再次输入密码';
    }
    
    if (value != password) {
      return '两次输入的密码不一致';
    }
    
    return null;
  }
  
  /// 验证昵称
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validateNickname(String? value, {bool isRequired = false, int maxLength = 20}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '请输入昵称';
    }
    
    if (value != null && value.isNotEmpty) {
      if (value.length > maxLength) {
        return '昵称长度不能超过$maxLength个字符';
      }
      
      // 仅检查一些常见的特殊字符
      if (value.contains('<') || value.contains('>') || 
          value.contains('/') || value.contains('\\') || 
          value.contains('"') || value.contains("'")) {
        return '昵称不能包含特殊字符';
      }
    }
    
    return null;
  }
  
  /// 通用非空验证
  ///
  /// 返回 null 表示验证通过，否则返回错误信息
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName不能为空';
    }
    return null;
  }
}