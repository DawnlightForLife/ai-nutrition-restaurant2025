# System Configuration Feature

## Overview

The System Configuration feature provides a centralized way to manage application-wide settings, particularly feature toggles like merchant and nutritionist certification buttons. This allows administrators to control feature availability without code changes.

## Architecture

### Data Layer

#### Remote Data Source
- **File**: `lib/features/system/data/datasources/system_config_remote_datasource.dart`
- **Purpose**: Handles API communication with the backend
- **Key Methods**:
  - `getPublicConfigs()`: Fetches all public system configurations
  - `getCertificationConfig()`: Fetches certification-specific configurations

#### Models
- **File**: `lib/features/system/data/models/system_config_model.dart`
- **Purpose**: Data transfer objects for API communication
- **Includes**: JSON serialization/deserialization

#### Repositories
- **File**: `lib/features/system/data/repositories/system_config_repository_impl.dart`
- **Purpose**: Implements the domain repository interface
- **Features**: Error handling and data transformation

### Domain Layer

#### Entities
- **File**: `lib/features/system/domain/entities/system_config.dart`
- **Key Classes**:
  - `SystemConfig`: Base configuration entity
  - `CertificationConfig`: Specialized entity for certification settings
  - `CertificationMode`: Enum for certification modes (contact/auto)

#### Repositories
- **File**: `lib/features/system/domain/repositories/system_config_repository.dart`
- **Purpose**: Abstract interface for system configuration operations

#### Use Cases
- **File**: `lib/features/system/domain/usecases/get_certification_config.dart`
- **Purpose**: Business logic for fetching certification configurations

### Presentation Layer

#### Providers
- **File**: `lib/features/system/presentation/providers/system_config_provider.dart`
- **Key Providers**:
  - `certificationConfigProvider`: AsyncNotifierProvider for certification settings
  - Manages state and caching of certification configurations

#### Services
- **File**: `lib/features/system/data/services/system_config_service.dart`
- **Purpose**: Service layer with caching capabilities
- **Features**:
  - In-memory caching with 5-minute TTL
  - Convenience methods for checking certification status

## Usage

### Checking Certification Status in UI

```dart
// In a ConsumerWidget
final certConfig = ref.watch(certificationConfigProvider);

certConfig.when(
  data: (config) {
    if (config.merchantCertificationEnabled) {
      // Show merchant certification button
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error loading config'),
);
```

### Using the Service Directly

```dart
final systemConfigService = ref.read(systemConfigServiceProvider);
final isMerchantCertEnabled = await systemConfigService.isMerchantCertificationEnabled();
```

## Admin Interface

The admin interface for managing system configurations is located at:
- **File**: `lib/features/admin/presentation/pages/system_config_page.dart`
- **Features**:
  - Toggle switches for enabling/disabling features
  - Contact information management
  - Real-time updates

## Integration Points

1. **User Profile Page**: 
   - File: `lib/features/main/presentation/widgets/user_profile_placeholder.dart`
   - Uses `certificationConfigProvider` to conditionally show certification buttons

2. **Navigation**:
   - Certification buttons respect system configuration
   - When enabled, will navigate to contact page (to be implemented)

## Future Enhancements

1. **QR Code Contact Page**: Next implementation phase
2. **Permission Management**: Manual permission granting by admins
3. **Workspace Switching**: For users with granted permissions
4. **Extended Configuration Options**: Additional feature toggles as needed

## Best Practices

1. **Caching**: The service implements a 5-minute cache to reduce API calls
2. **Error Handling**: All API calls include proper error handling
3. **State Management**: Uses Riverpod for reactive state updates
4. **Type Safety**: Strong typing throughout with proper models and entities