# Application Core

Base classes and utilities for the application layer use cases.

## Purpose

- Provide base classes for use cases
- Define common patterns for use case execution
- Handle cross-cutting concerns at the application layer

## Contents

- `UseCase` base class for all use cases
- `NoParams` class for use cases without parameters
- Common application layer utilities

## Example

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetUserUseCase extends UseCase<User, String> {
  final IUserRepository repository;
  
  GetUserUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(String userId) {
    return repository.getUser(userId);
  }
}
```