import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

import '../../domain/entities/dish_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../data/repositories/dish_repository.dart';
import '../../data/models/dish_model.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';

// Repository provider
final dishRepositoryProvider = Provider<DishRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DishRepositoryImpl(apiClient);
});

// Dishes list provider
final dishesProvider = StateNotifierProvider.family<DishesNotifier, AsyncValue<List<DishEntity>>, String>(
  (ref, merchantId) => DishesNotifier(ref.watch(dishRepositoryProvider), merchantId),
);

// Single dish provider
final dishProvider = StateNotifierProvider.family<DishNotifier, AsyncValue<DishEntity?>, String>(
  (ref, dishId) => DishNotifier(ref.watch(dishRepositoryProvider), dishId),
);

// Store dishes provider
final storeDishesProvider = StateNotifierProvider.family<StoreDishesNotifier, AsyncValue<List<StoreDishEntity>>, String>(
  (ref, storeId) => StoreDishesNotifier(ref.watch(dishRepositoryProvider), storeId),
);

// Dish form provider for create/edit operations
final dishFormProvider = StateNotifierProvider<DishFormNotifier, DishFormState>(
  (ref) => DishFormNotifier(ref.watch(dishRepositoryProvider)),
);

// Image upload provider
final imageUploadProvider = StateNotifierProvider<ImageUploadNotifier, ImageUploadState>(
  (ref) => ImageUploadNotifier(ref.watch(dishRepositoryProvider)),
);

class DishesNotifier extends StateNotifier<AsyncValue<List<DishEntity>>> {
  final DishRepository _repository;
  final String merchantId;

  DishesNotifier(this._repository, this.merchantId) : super(const AsyncValue.loading()) {
    loadDishes();
  }

  Future<void> loadDishes() async {
    state = const AsyncValue.loading();
    final result = await _repository.getDishes(merchantId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (dishes) => state = AsyncValue.data(dishes),
    );
  }

  Future<void> refreshDishes() async {
    await loadDishes();
  }

  Future<bool> deleteDish(String dishId) async {
    final result = await _repository.deleteDish(dishId);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        // Remove dish from current state
        state.whenData((dishes) {
          state = AsyncValue.data(dishes.where((d) => d.id != dishId).toList());
        });
        return true;
      },
    );
  }
}

class DishNotifier extends StateNotifier<AsyncValue<DishEntity?>> {
  final DishRepository _repository;
  final String dishId;

  DishNotifier(this._repository, this.dishId) : super(const AsyncValue.loading()) {
    loadDish();
  }

  Future<void> loadDish() async {
    state = const AsyncValue.loading();
    final result = await _repository.getDishById(dishId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (dish) => state = AsyncValue.data(dish),
    );
  }

  Future<void> refreshDish() async {
    await loadDish();
  }
}

class StoreDishesNotifier extends StateNotifier<AsyncValue<List<StoreDishEntity>>> {
  final DishRepository _repository;
  final String storeId;

  StoreDishesNotifier(this._repository, this.storeId) : super(const AsyncValue.loading()) {
    loadStoreDishes();
  }

  Future<void> loadStoreDishes() async {
    state = const AsyncValue.loading();
    final result = await _repository.getStoreDishes(storeId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (dishes) => state = AsyncValue.data(dishes),
    );
  }

  Future<bool> updateStoreDish(String storeDishId, StoreDishUpdateRequest request) async {
    final result = await _repository.updateStoreDish(storeDishId, request);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedDish) {
        // Update dish in current state
        state.whenData((dishes) {
          final updatedDishes = dishes.map((d) => d.id == storeDishId ? updatedDish : d).toList();
          state = AsyncValue.data(updatedDishes);
        });
        return true;
      },
    );
  }
}

class DishFormNotifier extends StateNotifier<DishFormState> {
  final DishRepository _repository;

  DishFormNotifier(this._repository) : super(const DishFormState());

  void updateForm({
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? tags,
    List<String>? allergens,
    List<String>? dietaryRestrictions,
    SpicyLevel? spicyLevel,
    int? estimatedPrepTime,
    bool? isAvailable,
    Map<String, dynamic>? nutritionFacts,
    List<IngredientUsageEntity>? ingredients,
    bool? isFeatured,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      description: description ?? state.description,
      price: price ?? state.price,
      category: category ?? state.category,
      tags: tags ?? state.tags,
      allergens: allergens ?? state.allergens,
      dietaryRestrictions: dietaryRestrictions ?? state.dietaryRestrictions,
      spicyLevel: spicyLevel ?? state.spicyLevel,
      estimatedPrepTime: estimatedPrepTime ?? state.estimatedPrepTime,
      isAvailable: isAvailable ?? state.isAvailable,
      nutritionFacts: nutritionFacts ?? state.nutritionFacts,
      ingredients: ingredients ?? state.ingredients,
      isFeatured: isFeatured ?? state.isFeatured,
    );
  }

  void resetForm() {
    state = const DishFormState();
  }

  void loadDishForEdit(DishEntity dish) {
    state = DishFormState(
      name: dish.name,
      description: dish.description,
      price: dish.price,
      category: dish.category,
      tags: dish.tags,
      allergens: dish.allergens,
      dietaryRestrictions: dish.suitableDiets,
      spicyLevel: SpicyLevel.fromLevel(dish.spicyLevel),
      estimatedPrepTime: dish.preparationTime,
      isAvailable: dish.isActive,
      nutritionFacts: dish.nutritionFacts,
      ingredients: dish.ingredients.map((name) => 
        IngredientUsageEntity(
          ingredientId: name,
          name: name,
          quantity: 0,
          unit: '',
        )
      ).toList(),
      isFeatured: false, // DishEntity中没有这个字段
      isEditing: true,
      editingDishId: dish.id,
    );
  }

  Future<Either<Failure, DishEntity>> submitForm(String merchantId) async {
    if (!state.isValid) {
      return Left(ValidationFailure(message: 'Form is not valid'));
    }

    state = state.copyWith(isSubmitting: true);

    final Either<Failure, DishEntity> result;

    if (state.isEditing && state.editingDishId != null) {
      // Update existing dish
      final updateRequest = DishUpdateRequest(
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        tags: state.tags,
        allergens: state.allergens,
        dietaryRestrictions: state.dietaryRestrictions,
        spicyLevel: state.spicyLevel,
        estimatedPrepTime: state.estimatedPrepTime,
        isAvailable: state.isAvailable,
        nutritionFacts: state.nutritionFacts,
        ingredients: state.ingredients.map(_mapIngredientEntityToUsage).toList(),
        isFeatured: state.isFeatured,
      );
      result = await _repository.updateDish(state.editingDishId!, updateRequest);
    } else {
      // Create new dish
      final createRequest = DishCreateRequest(
        merchantId: merchantId,
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        tags: state.tags,
        allergens: state.allergens,
        dietaryRestrictions: state.dietaryRestrictions,
        spicyLevel: state.spicyLevel,
        estimatedPrepTime: state.estimatedPrepTime,
        isAvailable: state.isAvailable,
        nutritionFacts: state.nutritionFacts,
        ingredients: state.ingredients.map(_mapIngredientEntityToUsage).toList(),
        isFeatured: state.isFeatured,
      );
      result = await _repository.createDish(createRequest);
    }

    state = state.copyWith(isSubmitting: false);
    return result;
  }

  IngredientUsage _mapIngredientEntityToUsage(IngredientUsageEntity entity) {
    return IngredientUsage(
      ingredientId: entity.ingredientId,
      name: entity.name,
      quantity: entity.quantity,
      unit: entity.unit,
      isOptional: entity.isOptional,
      notes: entity.notes,
    );
  }
}

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final DishRepository _repository;

  ImageUploadNotifier(this._repository) : super(const ImageUploadState());

  Future<bool> uploadImages(String dishId, List<File> images) async {
    state = state.copyWith(isUploading: true, uploadProgress: 0.0);

    final result = await _repository.uploadDishImages(dishId, images);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          error: failure.message,
          uploadProgress: 0.0,
        );
        return false;
      },
      (imageUrls) {
        state = state.copyWith(
          isUploading: false,
          uploadedImageUrls: imageUrls,
          uploadProgress: 1.0,
          error: null,
        );
        return true;
      },
    );
  }

  void clearUploadState() {
    state = const ImageUploadState();
  }
}

// State classes
class DishFormState {
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> tags;
  final List<String> allergens;
  final List<String> dietaryRestrictions;
  final SpicyLevel spicyLevel;
  final int estimatedPrepTime;
  final bool isAvailable;
  final Map<String, dynamic> nutritionFacts;
  final List<IngredientUsageEntity> ingredients;
  final bool isFeatured;
  final bool isSubmitting;
  final bool isEditing;
  final String? editingDishId;

  const DishFormState({
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.category = '',
    this.tags = const [],
    this.allergens = const [],
    this.dietaryRestrictions = const [],
    this.spicyLevel = SpicyLevel.none,
    this.estimatedPrepTime = 0,
    this.isAvailable = true,
    this.nutritionFacts = const {},
    this.ingredients = const [],
    this.isFeatured = false,
    this.isSubmitting = false,
    this.isEditing = false,
    this.editingDishId,
  });

  bool get isValid => name.isNotEmpty && description.isNotEmpty && price > 0;

  DishFormState copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? tags,
    List<String>? allergens,
    List<String>? dietaryRestrictions,
    SpicyLevel? spicyLevel,
    int? estimatedPrepTime,
    bool? isAvailable,
    Map<String, dynamic>? nutritionFacts,
    List<IngredientUsageEntity>? ingredients,
    bool? isFeatured,
    bool? isSubmitting,
    bool? isEditing,
    String? editingDishId,
  }) {
    return DishFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      allergens: allergens ?? this.allergens,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      estimatedPrepTime: estimatedPrepTime ?? this.estimatedPrepTime,
      isAvailable: isAvailable ?? this.isAvailable,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      ingredients: ingredients ?? this.ingredients,
      isFeatured: isFeatured ?? this.isFeatured,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isEditing: isEditing ?? this.isEditing,
      editingDishId: editingDishId ?? this.editingDishId,
    );
  }
}

class ImageUploadState {
  final bool isUploading;
  final double uploadProgress;
  final List<String> uploadedImageUrls;
  final String? error;

  const ImageUploadState({
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.uploadedImageUrls = const [],
    this.error,
  });

  ImageUploadState copyWith({
    bool? isUploading,
    double? uploadProgress,
    List<String>? uploadedImageUrls,
    String? error,
  }) {
    return ImageUploadState(
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
      error: error ?? this.error,
    );
  }
}