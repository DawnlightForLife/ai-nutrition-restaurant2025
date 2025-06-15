import 'package:freezed_annotation/freezed_annotation.dart';

/// 用户ID值对象
class UserId {
  final String value;

  const UserId(this.value);

  factory UserId.fromString(String id) {
    if (id.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    return UserId(id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  // JSON序列化支持
  Map<String, dynamic> toJson() => {'value': value};
  
  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(json['value'] as String);
  }
}