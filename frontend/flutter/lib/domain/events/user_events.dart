import 'package:ai_nutrition_restaurant/domain/events/domain_event.dart';
import 'package:ai_nutrition_restaurant/domain/user/entities/user.dart';
import 'package:ai_nutrition_restaurant/domain/user/value_objects/user_value_objects.dart';

/// Event fired when a user successfully logs in
class UserLoggedInEvent extends DomainEvent {
  final User user;
  final String authMethod; // 'email', 'phone', 'oauth'
  
  UserLoggedInEvent({
    required this.user,
    required this.authMethod,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, user, authMethod];
}

/// Event fired when a user logs out
class UserLoggedOutEvent extends DomainEvent {
  final UserId userId;
  final String reason; // 'manual', 'session_expired', 'forced'
  
  UserLoggedOutEvent({
    required this.userId,
    required this.reason,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, reason];
}

/// Event fired when a user profile is updated
class UserProfileUpdatedEvent extends DomainEvent {
  final User previousUser;
  final User updatedUser;
  final List<String> changedFields;
  
  UserProfileUpdatedEvent({
    required this.previousUser,
    required this.updatedUser,
    required this.changedFields,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, previousUser, updatedUser, changedFields];
}

/// Event fired when a new user registers
class UserRegisteredEvent extends DomainEvent {
  final User user;
  final String registrationMethod; // 'email', 'phone', 'oauth'
  
  UserRegisteredEvent({
    required this.user,
    required this.registrationMethod,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, user, registrationMethod];
}

/// Event fired when a user account is activated
class UserActivatedEvent extends DomainEvent {
  final UserId userId;
  final String activationMethod; // 'email_verification', 'phone_verification', 'admin'
  
  UserActivatedEvent({
    required this.userId,
    required this.activationMethod,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, activationMethod];
}

/// Event fired when a user account is deactivated
class UserDeactivatedEvent extends DomainEvent {
  final UserId userId;
  final String reason;
  
  UserDeactivatedEvent({
    required this.userId,
    required this.reason,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, reason];
}