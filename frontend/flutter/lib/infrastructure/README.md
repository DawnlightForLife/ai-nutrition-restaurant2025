# Infrastructure Layer

Technical implementations and external resource access.

## Directory Structure

- **repositories/** - Concrete implementations of domain repository interfaces
- **services/** - External service implementations (API clients, device services)
- **datasources/** - Data source implementations (remote and local)
- **mappers/** - Data transformation between DTOs and domain entities
  - **generated/** - Auto-generated mappers
- **dtos/** - Data Transfer Objects for API communication
  - **generated/** - OpenAPI-generated DTOs
- **api/** - API-related implementations
  - **generated/** - OpenAPI-generated API clients

## Responsibilities

1. Implement domain abstractions
2. Handle external API communication
3. Manage local data persistence
4. Transform data between external formats and domain models
5. Handle technical concerns (networking, caching, etc.)

## Guidelines

- All implementations should depend on domain abstractions
- Use dependency injection for all services
- Handle exceptions and convert them to domain failures
- Keep infrastructure details isolated from domain logic