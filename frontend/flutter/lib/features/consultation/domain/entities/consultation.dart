import 'package:equatable/equatable.dart';

/// Uconsultation 实体
class Uconsultation extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Uconsultation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
