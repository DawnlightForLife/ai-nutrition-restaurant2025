// DEPRECATED: This file has been replaced by AuthController using Riverpod
// Please use: import '../controllers/auth_controller.dart';
// 
// Migration Guide:
// - Replace AuthProvider with authControllerProvider
// - Replace Consumer<AuthProvider> with ConsumerWidget and ref.watch(authControllerProvider)
// - Use the new AsyncValue-based state management
//
// Example:
// OLD: Consumer<AuthProvider>(builder: (context, auth, child) => ...)
// NEW: Consumer(builder: (context, ref, child) {
//        final authState = ref.watch(authControllerProvider);
//        return authState.when(...);
//      })

@Deprecated('Use AuthController with Riverpod instead')
class AuthProvider {
  AuthProvider._();
  
  static void _showDeprecationWarning() {
    throw UnsupportedError(
      'AuthProvider is deprecated. Use AuthController with Riverpod instead.\n'
      'See: lib/features/auth/presentation/controllers/auth_controller.dart'
    );
  }
}