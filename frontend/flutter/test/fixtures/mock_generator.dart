import 'package:ai_nutrition_restaurant/domain/user/entities/user.dart';
import 'package:ai_nutrition_restaurant/domain/user/value_objects/user_value_objects.dart';
import 'package:ai_nutrition_restaurant/domain/nutrition/entities/nutrition_profile.dart';

/// Mock data generator for testing
class MockGenerator {
  static int _idCounter = 1;
  
  /// Generate a unique ID
  static String generateId() => 'test_id_${_idCounter++}';
  
  /// Generate mock user
  static User generateUser({
    String? id,
    String? nickname,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
  }) {
    return User(
      id: UserId(id ?? generateId()),
      nickname: UserName(nickname ?? 'testuser${_idCounter}'),
      email: Email(email ?? 'test${_idCounter}@example.com'),
      phone: Phone(phone ?? '+1234567890'),
      avatar: 'https://example.com/avatar/${_idCounter}.jpg',
      role: UserRole(role ?? 'user'),
      isActive: isActive ?? true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  /// Generate mock nutrition profile
  static NutritionProfile generateNutritionProfile({
    String? userId,
    double? height,
    double? weight,
    DateTime? birthDate,
    String? activityLevel,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
  }) {
    return NutritionProfile(
      userId: UserId(userId ?? generateId()),
      height: height ?? 170.0,
      weight: weight ?? 70.0,
      birthDate: birthDate ?? DateTime(1990, 1, 1),
      gender: 'male',
      activityLevel: activityLevel ?? 'moderate',
      allergies: allergies ?? ['peanuts'],
      dietaryRestrictions: dietaryRestrictions ?? ['vegetarian'],
      healthConditions: ['none'],
      nutritionGoals: {
        'calories': 2000.0,
        'protein': 60.0,
        'carbs': 250.0,
        'fat': 65.0,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  /* TODO: 实现 Restaurant 实体后启用
  /// Generate mock restaurant
  static Restaurant generateRestaurant({
    String? id,
    String? name,
    String? description,
    double? rating,
    bool? isActive,
  }) {
    return Restaurant(
      id: RestaurantId(id ?? generateId()),
      name: name ?? 'Test Restaurant ${_idCounter}',
      description: description ?? 'A test restaurant',
      cuisineTypes: ['Chinese', 'Asian'],
      rating: rating ?? 4.5,
      averagePrice: 25.0,
      location: RestaurantLocation(
        address: '123 Test Street',
        city: 'Test City',
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      contactInfo: ContactInfo(
        phone: '+1234567890',
        email: 'contact@testrestaurant.com',
      ),
      businessHours: {
        'monday': '9:00-22:00',
        'tuesday': '9:00-22:00',
        'wednesday': '9:00-22:00',
        'thursday': '9:00-22:00',
        'friday': '9:00-23:00',
        'saturday': '10:00-23:00',
        'sunday': '10:00-21:00',
      },
      isActive: isActive ?? true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  */
  
  /* TODO: 实现 Order 实体后启用
  /// Generate mock order
  static Order generateOrder({
    String? id,
    String? userId,
    String? restaurantId,
    OrderStatus? status,
    double? totalAmount,
  }) {
    return Order(
      id: OrderId(id ?? generateId()),
      userId: UserId(userId ?? generateId()),
      restaurantId: RestaurantId(restaurantId ?? generateId()),
      items: [
        OrderItem(
          menuItemId: generateId(),
          name: 'Test Dish 1',
          quantity: 2,
          unitPrice: 15.99,
          totalPrice: 31.98,
          customizations: ['No spicy'],
        ),
        OrderItem(
          menuItemId: generateId(),
          name: 'Test Dish 2',
          quantity: 1,
          unitPrice: 12.50,
          totalPrice: 12.50,
          customizations: [],
        ),
      ],
      status: status ?? OrderStatus.pending,
      totalAmount: totalAmount ?? 44.48,
      deliveryInfo: DeliveryInfo(
        address: '456 Delivery Street',
        phoneNumber: '+1234567890',
        instructions: 'Ring the bell',
      ),
      nutritionInfo: {
        'calories': 850.0,
        'protein': 45.0,
        'carbs': 90.0,
        'fat': 25.0,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  */
  
  /// Generate a list of items
  static List<T> generateList<T>(
    T Function() generator, {
    int count = 5,
  }) {
    return List.generate(count, (_) => generator());
  }
  
  /// Reset ID counter (useful between tests)
  static void resetIdCounter() {
    _idCounter = 1;
  }
}