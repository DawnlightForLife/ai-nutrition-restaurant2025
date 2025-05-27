import 'package:flutter/foundation.dart';
import '../../../domain/abstractions/repositories/i_restaurant_repository.dart';

/// 餐厅Provider
class RestaurantProvider extends ChangeNotifier {
  final IRestaurantRepository _restaurantRepository;
  
  RestaurantProvider({
    required IRestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository;
  
  // TODO(dev): 实现餐厅相关功能
}