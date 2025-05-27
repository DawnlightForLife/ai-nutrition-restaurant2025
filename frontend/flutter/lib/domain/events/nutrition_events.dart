import 'package:ai_nutrition_restaurant/domain/events/domain_event.dart';
import 'package:ai_nutrition_restaurant/domain/user/value_objects/user_value_objects.dart';
import 'package:ai_nutrition_restaurant/domain/nutrition/entities/nutrition_profile.dart';
import 'package:ai_nutrition_restaurant/domain/nutrition/entities/ai_recommendation.dart';

/// Event fired when a nutrition profile is created
class NutritionProfileCreatedEvent extends DomainEvent {
  final UserId userId;
  final NutritionProfile profile;
  
  NutritionProfileCreatedEvent({
    required this.userId,
    required this.profile,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, profile];
}

/// Event fired when a nutrition profile is updated
class NutritionProfileUpdatedEvent extends DomainEvent {
  final UserId userId;
  final NutritionProfile previousProfile;
  final NutritionProfile updatedProfile;
  final List<String> changedFields;
  
  NutritionProfileUpdatedEvent({
    required this.userId,
    required this.previousProfile,
    required this.updatedProfile,
    required this.changedFields,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, previousProfile, updatedProfile, changedFields];
}

/// Event fired when AI recommendations are generated
class AiRecommendationGeneratedEvent extends DomainEvent {
  final UserId userId;
  final List<AiRecommendation> recommendations;
  final String context; // 'breakfast', 'lunch', 'dinner', 'snack', 'general'
  
  AiRecommendationGeneratedEvent({
    required this.userId,
    required this.recommendations,
    required this.context,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, recommendations, context];
}

/// Event fired when nutrition goals are updated
class NutritionGoalsUpdatedEvent extends DomainEvent {
  final UserId userId;
  final Map<String, double> previousGoals;
  final Map<String, double> newGoals;
  
  NutritionGoalsUpdatedEvent({
    required this.userId,
    required this.previousGoals,
    required this.newGoals,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, previousGoals, newGoals];
}

/// Event fired when dietary restrictions change
class DietaryRestrictionsChangedEvent extends DomainEvent {
  final UserId userId;
  final List<String> addedRestrictions;
  final List<String> removedRestrictions;
  
  DietaryRestrictionsChangedEvent({
    required this.userId,
    required this.addedRestrictions,
    required this.removedRestrictions,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
  
  @override
  List<Object?> get props => [...super.props, userId, addedRestrictions, removedRestrictions];
}