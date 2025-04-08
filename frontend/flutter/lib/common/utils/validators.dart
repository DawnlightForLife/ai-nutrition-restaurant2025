import 'package:flutter/material.dart';

/**
 * 验证工具类
 * 
 * 提供各种表单验证方法，用于验证用户输入的有效性
 * 主要包含手机号、验证码、密码、昵称等常用表单字段的验证逻辑
 * 所有验证方法返回null表示验证通过，返回字符串表示验证失败的错误信息
 */
class Validators {
  /**
   * 验证手机号
   * 
   * 验证规则:
   * 1. 不能为空
   * 2. 长度必须为11位
   * 3. 必须符合中国大陆手机号格式（1开头 + 3-9的第二位 + 9位数字）
   * 
   * @param value 要验证的手机号字符串
   * @return null表示验证通过，否则返回错误提示信息
   */
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
  
  /**
   * 验证验证码
   * 
   * 验证规则:
   * 1. 不能为空
   * 2. 长度必须符合指定位数（默认6位）
   * 3. 只能包含数字
   * 
   * @param value 要验证的验证码字符串
   * @param length 验证码的期望长度，默认为6位
   * @return null表示验证通过，否则返回错误提示信息
   */
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
  
  /**
   * 验证密码
   * 
   * 验证规则:
   * 1. 不能为空
   * 2. 长度不能少于指定位数（默认6位）
   * 3. 必须同时包含字母和数字（密码强度要求）
   * 
   * @param value 要验证的密码字符串
   * @param minLength 密码的最小长度要求，默认为6位
   * @return null表示验证通过，否则返回错误提示信息
   */
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
  
  /**
   * 验证确认密码
   * 
   * 验证规则:
   * 1. 不能为空
   * 2. 必须与原密码一致
   * 
   * @param value 要验证的确认密码字符串
   * @param password 原密码，用于比对一致性
   * @return null表示验证通过，否则返回错误提示信息
   */
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '请再次输入密码';
    }
    
    if (value != password) {
      return '两次输入的密码不一致';
    }
    
    return null;
  }
  
  /**
   * 验证昵称
   * 
   * 验证规则:
   * 1. 如果isRequired为true，则不能为空
   * 2. 如果不为空，则长度不能超过指定最大长度（默认20个字符）
   * 3. 不能包含特定的特殊字符（<, >, /, \, ", '）
   * 
   * @param value 要验证的昵称字符串
   * @param isRequired 是否为必填项，默认为false
   * @param maxLength 昵称的最大长度限制，默认为20个字符
   * @return null表示验证通过，否则返回错误提示信息
   */
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
  
  /**
   * 通用非空验证
   * 
   * 适用于各种需要进行非空检查的表单字段
   * 验证规则: 字段值不能为null且去除空格后不能为空字符串
   * 
   * @param value 要验证的字符串值
   * @param fieldName 字段名称，用于构建错误提示信息
   * @return null表示验证通过，否则返回错误提示信息
   */
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName不能为空';
    }
    return null;
  }
}