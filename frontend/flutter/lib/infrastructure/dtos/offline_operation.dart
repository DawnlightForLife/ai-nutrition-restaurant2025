import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// 离线操作模型
/// 
/// 用于存储在离线状态下需要执行但尚未同步的操作
class OfflineOperation extends Equatable {
  /// 唯一标识符
  final String id;
  
  /// API端点
  final String endpoint;
  
  /// 请求数据
  final Map<String, dynamic> data;
  
  /// 请求方法 (GET, POST, PUT, DELETE)
  final String method;
  
  /// 创建时间戳
  final DateTime timestamp;
  
  /// 构造函数
  OfflineOperation({
    required this.endpoint,
    required this.data,
    required this.method,
    String? id,
    DateTime? timestamp,
  }) : 
    id = id ?? const Uuid().v4(),
    timestamp = timestamp ?? DateTime.now();
  
  /// 从JSON创建实例
  factory OfflineOperation.fromJson(Map<String, dynamic> json) {
    return OfflineOperation(
      id: json['id'] as String,
      endpoint: json['endpoint'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      method: json['method'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'data': data,
      'method': method,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  /// 创建此实例的副本
  OfflineOperation copyWith({
    String? id,
    String? endpoint,
    Map<String, dynamic>? data,
    String? method,
    DateTime? timestamp,
  }) {
    return OfflineOperation(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      data: data ?? this.data,
      method: method ?? this.method,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  @override
  List<Object> get props => [id, endpoint, data, method, timestamp];
  
  @override
  String toString() => 'OfflineOperation(id: $id, endpoint: $endpoint, method: $method)';
} 