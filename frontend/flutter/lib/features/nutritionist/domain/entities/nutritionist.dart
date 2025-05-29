import 'package:equatable/equatable.dart';

/// Unutritionist 实体
class Unutritionist extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Unutritionist({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
