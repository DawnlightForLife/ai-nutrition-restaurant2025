# Riverpod Migration Guide

## Overview
This guide documents the migration from ChangeNotifier-based state management to Riverpod 2.0 with AsyncNotifier pattern.

## Migration Benefits

### 1. **Compile-time Safety**
- Type-safe provider dependencies
- Compile-time circular dependency detection
- No runtime provider not found errors

### 2. **Better Performance**
- Automatic disposal and caching
- Fine-grained rebuilds
- Lazy loading by default

### 3. **Modern Async Handling**
- Built-in loading/error states with AsyncValue
- Automatic error handling
- Previous state preservation during updates

### 4. **Code Generation**
- Less boilerplate with @riverpod annotation
- Auto-generated provider names
- Type-safe family providers

## Migration Steps

### Step 1: Update Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.4.10
  riverpod_annotation: ^2.3.5

dev_dependencies:
  riverpod_generator: ^2.3.11
```

### Step 2: Replace ChangeNotifier with AsyncNotifier

**Before (ChangeNotifier):**
```dart
class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;
  
  Future<void> signIn(...) async {
    _status = AuthStatus.loading;
    notifyListeners();
    // ... logic
  }
}
```

**After (AsyncNotifier):**
```dart
@riverpod
class AuthAsync extends _$AuthAsync {
  @override
  FutureOr<User?> build() async {
    // Initial state logic
    return null;
  }
  
  Future<void> signIn(...) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // ... logic
      return user;
    });
  }
}
```

### Step 3: Update Widget Usage

**Before:**
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return CircularProgressIndicator();
        }
        // ... rest of UI
      },
    );
  }
}
```

**After:**
```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authAsyncProvider);
    
    return authState.when(
      data: (user) => // ... authenticated UI,
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### Step 4: Setup Provider Scope

**main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await configureDependencies();
  
  runApp(
    ProviderSetup.createProviderScope(
      child: MyApp(),
    ),
  );
}
```

## Provider Patterns

### 1. **Simple State Provider**
```dart
@riverpod
String appTitle(AppTitleRef ref) => 'Smart Nutrition';
```

### 2. **Async Data Provider**
```dart
@riverpod
Future<List<Restaurant>> nearbyRestaurants(NearbyRestaurantsRef ref) async {
  final location = await ref.watch(locationProvider.future);
  return ref.watch(restaurantRepositoryProvider).getNearby(location);
}
```

### 3. **Family Provider (with parameters)**
```dart
@riverpod
Future<NutritionProfile?> nutritionProfile(
  NutritionProfileRef ref,
  UserId userId,
) async {
  final facade = ref.watch(nutritionFacadeProvider);
  final result = await facade.getNutritionProfile(userId);
  return result.fold((l) => throw l, (r) => r);
}
```

### 4. **Stream Provider**
```dart
@riverpod
Stream<List<Order>> activeOrders(ActiveOrdersRef ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return Stream.value([]);
  
  return ref.watch(orderRepositoryProvider).watchActiveOrders(userId);
}
```

## Best Practices

### 1. **Use AsyncNotifier for Complex State**
```dart
@riverpod
class ShoppingCart extends _$ShoppingCart {
  @override
  FutureOr<Cart> build() async {
    // Initialize cart
    return Cart.empty();
  }
  
  Future<void> addItem(MenuItem item) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final cart = state.valueOrNull ?? Cart.empty();
      return cart.addItem(item);
    });
  }
}
```

### 2. **Proper Error Handling**
```dart
// In notifier
state = await AsyncValue.guard(() async {
  final result = await repository.fetchData();
  return result.fold(
    (failure) => throw failure,
    (data) => data,
  );
});

// In widget
authState.when(
  data: (user) => HomeScreen(user: user),
  loading: () => LoadingScreen(),
  error: (error, stack) {
    if (error is NetworkFailure) {
      return NetworkErrorScreen(onRetry: () {
        ref.invalidate(authAsyncProvider);
      });
    }
    return GenericErrorScreen(error: error);
  },
);
```

### 3. **Dependency Injection**
```dart
// Override providers in tests
testWidgets('auth test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          MockAuthRepository(),
        ),
      ],
      child: MyApp(),
    ),
  );
});
```

### 4. **State Preservation**
```dart
// Preserve data while loading
Future<void> refresh() async {
  state = const AsyncValue.loading().copyWithPrevious(state);
  // ... refresh logic
}
```

## Common Patterns

### Loading States
```dart
// Global loading state
@riverpod
bool isAnyLoading(IsAnyLoadingRef ref) {
  return ref.watch(authAsyncProvider).isLoading ||
         ref.watch(nutritionProfileProvider(userId)).isLoading ||
         ref.watch(ordersProvider).isLoading;
}
```

### Error Recovery
```dart
// Retry logic
ElevatedButton(
  onPressed: () {
    ref.invalidate(authAsyncProvider);
  },
  child: Text('Retry'),
)
```

### Computed Values
```dart
@riverpod
double totalCartPrice(TotalCartPriceRef ref) {
  final cart = ref.watch(shoppingCartProvider).valueOrNull;
  if (cart == null) return 0.0;
  
  return cart.items.fold(0.0, (sum, item) => sum + item.totalPrice);
}
```

## Testing

### Unit Tests
```dart
test('auth sign in', () async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        MockAuthRepository(),
      ),
    ],
  );
  
  final notifier = container.read(authAsyncProvider.notifier);
  await notifier.signIn(email: 'test@test.com', password: 'password');
  
  final state = container.read(authAsyncProvider);
  expect(state.valueOrNull?.email, 'test@test.com');
});
```

### Widget Tests
```dart
testWidgets('login screen', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authAsyncProvider.overrideWith(() => MockAuthNotifier()),
      ],
      child: MaterialApp(home: LoginScreen()),
    ),
  );
  
  // Test UI interactions
});
```

## Troubleshooting

### Common Issues

1. **ProviderNotFoundException**
   - Ensure ProviderScope is at the root
   - Check provider overrides are set correctly

2. **Infinite Loops**
   - Avoid watching providers that you modify in build()
   - Use ref.read() for one-time reads in callbacks

3. **State Not Updating**
   - Ensure you're creating new instances (immutability)
   - Check if provider is being disposed unexpectedly

4. **Type Errors**
   - Run build_runner to generate code
   - Check generic type parameters match

## Migration Checklist

- [ ] Add Riverpod dependencies
- [ ] Setup ProviderScope in main.dart
- [ ] Create AsyncNotifier for each ChangeNotifier
- [ ] Generate code with build_runner
- [ ] Update widgets to use ConsumerWidget/ConsumerStatefulWidget
- [ ] Replace Provider.of/Consumer with ref.watch/ref.read
- [ ] Update tests with ProviderContainer
- [ ] Remove old Provider/ChangeNotifier code
- [ ] Update documentation

---

**Last Updated**: $(date)
**Version**: 1.0.0