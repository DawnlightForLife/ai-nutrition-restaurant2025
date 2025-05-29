import 'package:equatable/equatable.dart';

/// Urecommendation 实体
class Urecommendation extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Urecommendation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
