/// 手机号码值对象
/// 
/// 对应后端的值对象设计，确保前后端领域模型一致

class PhoneNumber {
  final String value;
  
  const PhoneNumber._(this.value);

  /// 创建手机号码
  static PhoneNumber? create(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.isEmpty) {
      return null;
    }
    
    // 中国手机号验证
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(cleaned)) {
      return null;
    }
    
    return PhoneNumber._(cleaned);
  }
  
  /// 格式化显示
  String get formatted => '${value.substring(0, 3)} ${value.substring(3, 7)} ${value.substring(7)}';
  
  /// 脱敏显示
  String get masked => '${value.substring(0, 3)}****${value.substring(7)}';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}