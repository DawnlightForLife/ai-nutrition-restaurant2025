# Error Handling Consolidation Plan

## Current Issues
1. Duplicate exception definitions in `/core/error/app_exception.dart` and `/core/exceptions/app_exceptions.dart`
2. Mixed paradigms (Exceptions and Failures) in the same directory
3. Inconsistent imports across the codebase
4. Missing `error_handler.dart` file referenced in `error_boundary.dart`

## Proposed Structure

```
lib/core/
├── exceptions/              # Data/Infrastructure layer
│   ├── app_exceptions.dart  # All exception classes
│   └── exception_mapper.dart # Maps exceptions to failures
│
├── failures/               # Domain layer
│   └── failures.dart       # All failure classes
│
└── error/                  # Presentation layer
    ├── error_handler.dart  # Global error handler
    ├── error_boundary.dart # Error boundary widget
    └── error_widgets.dart  # Error UI components

```

## Layer Responsibilities

### 1. Data/Infrastructure Layer (`/core/exceptions/`)
- **Purpose**: Handle external errors (API, Database, Cache)
- **Classes**: 
  - `AppException` (base)
  - `NetworkException`
  - `ApiException` (with status codes)
  - `ServerException`
  - `CacheException`
  - `ValidationException`
  - `AuthException`
  - `BadRequestException`, `UnauthorizedException`, etc.

### 2. Domain Layer (`/core/failures/`)
- **Purpose**: Business logic errors
- **Classes**:
  - `Failure` (base with Equatable)
  - `ServerFailure`
  - `CacheFailure`
  - `NetworkFailure`
  - `ValidationFailure`
  - `UnauthorizedFailure`
  - `NotFoundFailure`
  - `UnknownFailure`

### 3. Presentation Layer (`/core/error/`)
- **Purpose**: Error display and user feedback
- **Components**:
  - `GlobalErrorHandler` - Centralized error handling
  - `ErrorBoundary` - Widget error boundary
  - `ErrorToast` - Error notifications
  - `DefaultErrorWidget` - Error UI

## Migration Steps

### Step 1: Consolidate Exception Classes
1. Merge both `app_exception.dart` files into `/core/exceptions/app_exceptions.dart`
2. Remove duplicate definitions
3. Ensure all exceptions extend the base `AppException`

### Step 2: Move Failures
1. Create `/core/failures/` directory
2. Move `failures.dart` from `/core/error/` to `/core/failures/`
3. Update all imports

### Step 3: Create Exception Mapper
1. Create `/core/exceptions/exception_mapper.dart`
2. Implement mapping from exceptions to failures:
```dart
Failure mapExceptionToFailure(Exception exception) {
  if (exception is NetworkException) {
    return NetworkFailure(message: exception.message, code: exception.code);
  }
  // ... other mappings
  return UnknownFailure(message: exception.toString());
}
```

### Step 4: Fix Presentation Layer
1. Create `/core/error/error_handler.dart` with `GlobalErrorHandler` class
2. Move error UI components to `/core/error/error_widgets.dart`
3. Update `error_boundary.dart` imports

### Step 5: Update Repository Implementations
1. Catch exceptions in data sources
2. Map to failures in repositories
3. Return `Either<Failure, Success>` to use cases

### Step 6: Update All Imports
1. Update all files importing from `/core/error/app_exception.dart` to `/core/exceptions/app_exceptions.dart`
2. Update all files importing failures to use `/core/failures/failures.dart`
3. Update presentation layer imports

## Benefits
1. **Clear separation of concerns** by layer
2. **No duplicate code**
3. **Consistent error handling** across the app
4. **Easy to maintain and extend**
5. **Follows Clean Architecture** principles

## Implementation Priority
1. High: Fix duplicate exceptions (breaking issue)
2. High: Create missing error_handler.dart
3. Medium: Separate failures from exceptions
4. Low: Create comprehensive error widgets