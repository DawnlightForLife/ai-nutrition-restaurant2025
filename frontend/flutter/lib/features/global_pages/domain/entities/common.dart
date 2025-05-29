import 'package:equatable/equatable.dart';

/// Ucommon 实体
class Ucommon extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Ucommon({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
