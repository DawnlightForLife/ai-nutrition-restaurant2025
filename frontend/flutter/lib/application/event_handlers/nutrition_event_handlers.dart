import 'dart:async';

import '../../domain/events/nutrition_events.dart';
import '../../domain/events/user_events.dart';
import '../../domain/nutrition/entities/nutrition_profile.dart';
import '../../domain/user/value_objects/user_value_objects.dart';
import '../facades/nutrition_facade.dart';
import '../services/event_bus.dart';

/// Event handlers for nutrition-related events
class NutritionEventHandlers {
  final NutritionFacade _nutritionFacade;
  final EventBus _eventBus = EventBus();
  
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  
  NutritionEventHandlers({
    required NutritionFacade nutritionFacade,
  }) : _nutritionFacade = nutritionFacade;
  
  /// Initialize event handlers
  void initialize() {
    // When user logs in, load their nutrition profile
    _subscriptions.add(
      _eventBus.on<UserLoggedInEvent>(_handleUserLoggedIn),
    );
    
    // When user registers, create default nutrition profile
    _subscriptions.add(
      _eventBus.on<UserRegisteredEvent>(_handleUserRegistered),
    );
    
    // When nutrition profile is updated, generate new recommendations
    _subscriptions.add(
      _eventBus.on<NutritionProfileUpdatedEvent>(_handleProfileUpdated),
    );
  }
  
  /// Handle user login - load nutrition profile
  Future<void> _handleUserLoggedIn(UserLoggedInEvent event) async {
    _logger.i('Loading nutrition profile for user: ${event.user.id.value}');
    
    final result = await _nutritionFacade.getNutritionProfile(event.user.id);
    
    result.fold(
      (failure) {
        _logger.i('Failed to load nutrition profile: ${failure.toString()}');
      },
      (profile) {
        // Publish profile loaded event
        NutritionProfileCreatedEvent(
          userId: event.user.id,
          profile: profile,
        ).publish();
        
        // Generate initial recommendations
        _generateRecommendations(event.user.id);
      },
    );
  }
  
  /// Handle user registration - create default profile
  Future<void> _handleUserRegistered(UserRegisteredEvent event) async {
    _logger.i('Creating default nutrition profile for new user: ${event.user.id.value}');
    
    // Create default profile based on basic info
    final defaultProfile = NutritionProfile.createDefault(
      userId: event.user.id,
    );
    
    final result = await _nutritionFacade.updateNutritionProfile(
      userId: event.user.id,
      profile: defaultProfile,
    );
    
    result.fold(
      (failure) {
        _logger.i('Failed to create nutrition profile: ${failure.toString()}');
      },
      (profile) {
        // Publish profile created event
        NutritionProfileCreatedEvent(
          userId: event.user.id,
          profile: profile,
        ).publish();
      },
    );
  }
  
  /// Handle profile update - generate new recommendations
  Future<void> _handleProfileUpdated(NutritionProfileUpdatedEvent event) async {
    _logger.i('Nutrition profile updated for user: ${event.userId.value}');
    
    // Check if significant fields changed
    final significantChanges = event.changedFields.any((field) => 
      field == 'weight' ||
      field == 'height' ||
      field == 'activityLevel' ||
      field == 'nutritionGoals' ||
      field == 'dietaryRestrictions'
    );
    
    if (significantChanges) {
      await _generateRecommendations(event.userId);
    }
  }
  
  /// Generate AI recommendations
  Future<void> _generateRecommendations(UserId userId) async {
    _logger.i('Generating new recommendations for user: ${userId.value}');
    
    final result = await _nutritionFacade.getRecommendations(
      userId: userId,
    );
    
    result.fold(
      (failure) {
        _logger.i('Failed to generate recommendations: ${failure.toString()}');
      },
      (recommendations) {
        // Publish recommendations generated event
        AiRecommendationGeneratedEvent(
          userId: userId,
          recommendations: recommendations,
          context: 'general',
        ).publish();
      },
    );
  }
  
  /// Dispose of subscriptions
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}