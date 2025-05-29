import 'package:equatable/equatable.dart';

/// Uorder 实体
class Uorder extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Uorder({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
