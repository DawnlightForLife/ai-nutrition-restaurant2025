/// 邮箱值对象
/// 
/// 对应后端的值对象设计，确保前后端领域模型一致

class Email {
  final String value;
  
  const Email._(this.value);

  /// 创建邮箱
  static Email? create(String input) {
    final trimmed = input.trim().toLowerCase();
    
    if (trimmed.isEmpty) {
      return null;
    }
    
    // 邮箱格式验证
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed)) {
      return null;
    }
    
    return Email._(trimmed);
  }
  
  /// 获取用户名部分
  String get username => value.split('@').first;
  
  /// 获取域名部分
  String get domain => value.split('@').last;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}