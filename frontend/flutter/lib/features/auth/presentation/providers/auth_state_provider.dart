// Re-export auth controller for backward compatibility
export '../controllers/auth_controller.dart';

// This file provides backward compatibility for old auth state provider references
// The actual auth state is now managed by AuthController using Riverpod's AsyncNotifier pattern