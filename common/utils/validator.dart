class Validator {
  // 验证邮箱地址
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱地址';
    }
    // 基本的邮箱验证正则表达式
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  // 验证密码
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度至少为6位';
    }
    return null;
  }

  // 验证两次密码是否一致
  static String? validatePasswordConfirm(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return '请再次输入密码';
    }
    if (value != password) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  // 验证手机号
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    // 中国大陆手机号验证正则表达式
    final phoneRegExp = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }

  // 验证不能为空
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '此项'}不能为空';
    }
    return null;
  }

  // 验证数字
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '此项'}不能为空';
    }
    if (double.tryParse(value) == null) {
      return '${fieldName ?? '此项'}必须是有效的数字';
    }
    return null;
  }

  // 验证数字范围
  static String? validateNumberRange(
    String? value, {
    double? min,
    double? max,
    String? fieldName,
  }) {
    final result = validateNumber(value, fieldName: fieldName);
    if (result != null) {
      return result;
    }

    final number = double.parse(value!);
    if (min != null && number < min) {
      return '${fieldName ?? '此项'}不能小于$min';
    }
    if (max != null && number > max) {
      return '${fieldName ?? '此项'}不能大于$max';
    }
    return null;
  }

  // 验证文本长度
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '此项'}不能为空';
    }

    if (minLength != null && value.length < minLength) {
      return '${fieldName ?? '此项'}长度不能少于$minLength个字符';
    }
    if (maxLength != null && value.length > maxLength) {
      return '${fieldName ?? '此项'}长度不能超过$maxLength个字符';
    }
    return null;
  }

  // 验证用户名
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名';
    }
    if (value.length < 3) {
      return '用户名长度至少为3位';
    }
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!usernameRegExp.hasMatch(value)) {
      return '用户名只能包含字母、数字、下划线和连字符';
    }
    return null;
  }
} 