import 'package:equatable/equatable.dart';

/// Uadmin 实体
class Uadmin extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Uadmin({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
