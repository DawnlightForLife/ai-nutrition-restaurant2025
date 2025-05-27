import 'dart:async';

import 'package:logger/logger.dart';

import '../../domain/events/domain_event.dart';
import '../../domain/events/nutrition_events.dart';
import '../../domain/events/user_events.dart';
import '../services/event_bus.dart';

/// Cross-module event handlers for decoupled communication
class CrossModuleHandlers {
  final EventBus _eventBus = EventBus();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final _logger = Logger();
  
  /// Initialize cross-module event handlers
  void initialize() {
    _setupUserToNutritionHandlers();
    _setupNutritionToOrderHandlers();
    _setupOrderToNutritionHandlers();
    _setupAnalyticsHandlers();
  }
  
  /// User module -> Nutrition module communication
  void _setupUserToNutritionHandlers() {
    // When user logs in, nutrition module should load profile
    _subscriptions.add(
      _eventBus.on<UserLoggedInEvent>((event) {
        _logger.i('[Cross-Module] User logged in, triggering nutrition profile load');
        // Nutrition module will handle this via its own event handlers
      }),
    );
    
    // When user profile is updated, check if nutrition-relevant fields changed
    _subscriptions.add(
      _eventBus.on<UserProfileUpdatedEvent>((event) {
        if (event.changedFields.contains('birthDate') ||
            event.changedFields.contains('gender')) {
          _logger.i('[Cross-Module] User profile updated with nutrition-relevant changes');
          // Nutrition module may need to recalculate recommendations
        }
      }),
    );
  }
  
  /// Nutrition module -> Order module communication
  void _setupNutritionToOrderHandlers() {
    // When dietary restrictions change, notify order module
    _subscriptions.add(
      _eventBus.on<DietaryRestrictionsChangedEvent>((event) {
        _logger.i('[Cross-Module] Dietary restrictions changed, order module should filter menu items');
        // Order module can update available menu items
      }),
    );
    
    // When nutrition goals update, order module can suggest appropriate portions
    _subscriptions.add(
      _eventBus.on<NutritionGoalsUpdatedEvent>((event) {
        _logger.i('[Cross-Module] Nutrition goals updated, order module can adjust recommendations');
        // Order module can adjust portion recommendations
      }),
    );
  }
  
  /// Order module -> Nutrition module communication
  void _setupOrderToNutritionHandlers() {
    // When order is completed, update nutrition tracking
    _subscriptions.add(
      _eventBus.on<OrderCompletedEvent>((event) {
        _logger.i('[Cross-Module] Order completed, updating nutrition tracking');
        // Nutrition module can track consumed nutrients
      }),
    );
    
    // When meal is consumed, update daily nutrition intake
    _subscriptions.add(
      _eventBus.on<MealConsumedEvent>((event) {
        _logger.i('[Cross-Module] Meal consumed, updating daily nutrition intake');
        // Nutrition module updates daily tracking
      }),
    );
  }
  
  /// Analytics handlers for all modules
  void _setupAnalyticsHandlers() {
    // Track all important events for analytics
    _subscriptions.add(
      _eventBus.onAll((event) {
        // Log event for analytics
        _logAnalyticsEvent(event);
      }),
    );
  }
  
  /// Log event for analytics
  void _logAnalyticsEvent(DomainEvent event) {
    // In a real app, this would send to analytics service
    _logger.i('[Analytics] Event: ${event.runtimeType} at ${event.occurredOn}');
  }
  
  /// Dispose of subscriptions
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

/// Order completed event (placeholder - should be in order_events.dart)
class OrderCompletedEvent extends DomainEvent {
  final String orderId;
  final String userId;
  final List<String> itemIds;
  final Map<String, double> nutritionInfo;
  
  OrderCompletedEvent({
    required this.orderId,
    required this.userId,
    required this.itemIds,
    required this.nutritionInfo,
    DateTime? timestamp,
    String? eventId,
  }) : super(timestamp: timestamp, eventId: eventId);
  
  @override
  List<Object?> get props => [occurredOn, eventId, orderId, userId, itemIds, nutritionInfo];
}

/// Meal consumed event (placeholder - should be in order_events.dart)
class MealConsumedEvent extends DomainEvent {
  final String userId;
  final String mealId;
  final DateTime consumedAt;
  final Map<String, double> nutritionInfo;
  
  MealConsumedEvent({
    required this.userId,
    required this.mealId,
    required this.consumedAt,
    required this.nutritionInfo,
    DateTime? timestamp,
    String? eventId,
  }) : super(timestamp: timestamp, eventId: eventId);
  
  @override
  List<Object?> get props => [occurredOn, eventId, userId, mealId, consumedAt, nutritionInfo];
}