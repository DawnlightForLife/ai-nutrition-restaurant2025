import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// 领域事件基类
abstract class DomainEvent extends Equatable {
  /// 事件发生时间
  final DateTime occurredOn;
  
  /// 事件ID
  final String eventId;

  DomainEvent({
    DateTime? timestamp,
    String? eventId,
  }) : occurredOn = timestamp ?? DateTime.now(),
       eventId = eventId ?? const Uuid().v4();

  @override
  List<Object?> get props => [occurredOn, eventId];
}