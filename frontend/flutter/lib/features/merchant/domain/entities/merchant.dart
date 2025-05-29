import 'package:equatable/equatable.dart';

/// Umerchant 实体
class Umerchant extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Umerchant({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
