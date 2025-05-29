import 'package:equatable/equatable.dart';

/// Uforum 实体
class Uforum extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Uforum({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
