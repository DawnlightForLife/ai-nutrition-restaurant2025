import 'dart:async';
import 'package:ai_nutrition_restaurant/domain/events/domain_event.dart';

/// Type definition for event handlers
typedef EventHandler<T extends DomainEvent> = FutureOr<void> Function(T event);

/// Event bus for domain event communication
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  
  /// Stream controllers for each event type
  final Map<Type, StreamController<DomainEvent>> _controllers = {};
  
  /// Registered handlers for each event type
  final Map<Type, List<EventHandler>> _handlers = {};
  
  /// Global event stream for monitoring all events
  final _globalController = StreamController<DomainEvent>.broadcast();
  
  /// Stream of all events
  Stream<DomainEvent> get allEvents => _globalController.stream;
  
  /// Publish an event
  void publish<T extends DomainEvent>(T event) {
    // Publish to global stream
    _globalController.add(event);
    
    // Get or create controller for this event type
    final controller = _getOrCreateController<T>();
    controller.add(event);
    
    // Execute registered handlers
    final handlers = _handlers[T] ?? [];
    for (final handler in handlers) {
      _executeHandler(handler as EventHandler<T>, event);
    }
  }
  
  /// Subscribe to a specific event type
  StreamSubscription<T> on<T extends DomainEvent>(
    EventHandler<T> handler,
  ) {
    // Register handler
    _handlers[T] ??= [];
    _handlers[T]!.add(handler as EventHandler<DomainEvent>);
    
    // Get or create controller for this event type
    final controller = _getOrCreateController<T>();
    
    // Return subscription
    return controller.stream.cast<T>().listen((event) {
      _executeHandler(handler, event);
    });
  }
  
  /// Subscribe to multiple event types
  StreamSubscription<DomainEvent> onMany<T extends DomainEvent>(
    List<Type> eventTypes,
    EventHandler<DomainEvent> handler,
  ) {
    return allEvents
        .where((event) => eventTypes.contains(event.runtimeType))
        .listen((event) {
      _executeHandler(handler, event);
    });
  }
  
  /// Subscribe to all events
  StreamSubscription<DomainEvent> onAll(
    EventHandler<DomainEvent> handler,
  ) {
    return allEvents.listen((event) {
      _executeHandler(handler, event);
    });
  }
  
  /// Get stream of specific event type
  Stream<T> stream<T extends DomainEvent>() {
    final controller = _getOrCreateController<T>();
    return controller.stream.cast<T>();
  }
  
  /// Clear all handlers for a specific event type
  void clearHandlers<T extends DomainEvent>() {
    _handlers.remove(T);
  }
  
  /// Clear all handlers
  void clearAllHandlers() {
    _handlers.clear();
  }
  
  /// Dispose of resources
  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
    _globalController.close();
    clearAllHandlers();
  }
  
  /// Get or create controller for event type
  StreamController<DomainEvent> _getOrCreateController<T extends DomainEvent>() {
    if (!_controllers.containsKey(T)) {
      _controllers[T] = StreamController<DomainEvent>.broadcast();
    }
    return _controllers[T]!;
  }
  
  /// Execute handler with error handling
  Future<void> _executeHandler<T extends DomainEvent>(
    EventHandler<T> handler,
    T event,
  ) async {
    try {
      await handler(event);
    } catch (e, stack) {
      print('Error in event handler for ${event.runtimeType}: $e');
      print('Stack trace: $stack');
      // Could publish an error event here if needed
    }
  }
}

/// Extension for easy event publishing
extension EventPublisher on DomainEvent {
  void publish() => EventBus().publish(this);
}