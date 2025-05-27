# 代码模板

本文档提供智能营养餐厅App常用代码模板，便于团队快速创建符合架构规范的代码文件。

## 目录

- [接口模板](#接口模板)
- [实现类模板](#实现类模板)
- [用例模板](#用例模板)
- [Provider模板](#provider模板)
- [Riverpod模板](#riverpod模板)
- [Mapper模板](#mapper模板)
- [Facade模板](#facade模板)
- [事件模板](#事件模板)
- [图表组件模板](#图表组件模板)
- [测试模板](#测试模板)

## 接口模板

### 服务接口模板

```dart
import '../../../models/module/model_name.dart';
import '../../../models/common/api_response.dart';

/// 模块服务接口
///
/// 描述该接口的职责
abstract class IModuleService {
  /// 获取数据
  Future<ApiResponse<ModelName>> getData();
  
  /// 创建数据
  Future<ApiResponse<ModelName>> createData(Map<String, dynamic> data);
  
  /// 更新数据
  Future<ApiResponse<ModelName>> updateData(String id, Map<String, dynamic> data);
  
  /// 删除数据
  Future<ApiResponse<bool>> deleteData(String id);
}
```

### 仓库接口模板

```dart
import '../../../models/module/model_name.dart';

/// 模块仓库接口
///
/// 描述该接口的职责
abstract class IModuleRepository {
  /// 获取数据
  Future<ModelName> getData();
  
  /// 创建数据
  Future<ModelName> createData(Map<String, dynamic> data);
  
  /// 更新数据
  Future<ModelName> updateData(String id, Map<String, dynamic> data);
  
  /// 删除数据
  Future<bool> deleteData(String id);
}
```

## 实现类模板

### 服务实现模板

```dart
import 'package:injectable/injectable.dart';

import '../../models/module/model_name.dart';
import '../../models/common/api_response.dart';
import '../../domain/abstractions/services/i_api_service.dart';
import '../../domain/abstractions/services/i_module_service.dart';

/// 模块服务实现
@Injectable(as: IModuleService)
@lazySingleton
class ModuleService implements IModuleService {
  final IApiService _apiService;
  
  /// 构造函数
  ModuleService(this._apiService);
  
  @override
  Future<ApiResponse<ModelName>> getData() async {
    try {
      final response = await _apiService.get('/module/data');
      return ApiResponse(
        statusCode: 200,
        message: '获取数据成功',
        success: true,
        data: ModelName.fromJson(response),
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: '获取数据失败：${e.toString()}',
        success: false,
        data: null,
      );
    }
  }
  
  @override
  Future<ApiResponse<ModelName>> createData(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/module/data', data: data);
      return ApiResponse(
        statusCode: 201,
        message: '创建数据成功',
        success: true,
        data: ModelName.fromJson(response),
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: '创建数据失败：${e.toString()}',
        success: false,
        data: null,
      );
    }
  }
  
  @override
  Future<ApiResponse<ModelName>> updateData(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/module/data/$id', data: data);
      return ApiResponse(
        statusCode: 200,
        message: '更新数据成功',
        success: true,
        data: ModelName.fromJson(response),
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: '更新数据失败：${e.toString()}',
        success: false,
        data: null,
      );
    }
  }
  
  @override
  Future<ApiResponse<bool>> deleteData(String id) async {
    try {
      await _apiService.delete('/module/data/$id');
      return ApiResponse(
        statusCode: 200,
        message: '删除数据成功',
        success: true,
        data: true,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: '删除数据失败：${e.toString()}',
        success: false,
        data: false,
      );
    }
  }
}
```

### 仓库实现模板

```dart
import 'package:injectable/injectable.dart';

import '../../models/module/model_name.dart';
import '../../domain/abstractions/services/i_module_service.dart';
import '../../domain/abstractions/repositories/i_module_repository.dart';

/// 模块仓库实现
@Injectable(as: IModuleRepository)
@lazySingleton
class ModuleRepository implements IModuleRepository {
  final IModuleService _moduleService;
  
  /// 构造函数
  ModuleRepository(this._moduleService);
  
  @override
  Future<ModelName> getData() async {
    final response = await _moduleService.getData();
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }
  
  @override
  Future<ModelName> createData(Map<String, dynamic> data) async {
    final response = await _moduleService.createData(data);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }
  
  @override
  Future<ModelName> updateData(String id, Map<String, dynamic> data) async {
    final response = await _moduleService.updateData(id, data);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }
  
  @override
  Future<bool> deleteData(String id) async {
    final response = await _moduleService.deleteData(id);
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data ?? false;
  }
}
```

## 用例模板

### 带参数的用例模板

```dart
import 'package:injectable/injectable.dart';

import '../../models/module/model_name.dart';
import '../../domain/abstractions/repositories/i_module_repository.dart';
import '../core/result.dart';

/// 用例参数
class DoSomethingParams {
  final String id;
  final Map<String, dynamic> data;
  
  /// 构造函数
  const DoSomethingParams({
    required this.id,
    required this.data,
  });
}

/// 执行某操作的用例
///
/// 描述用例的业务目的
@injectable
class DoSomethingUseCase {
  final IModuleRepository _moduleRepository;
  
  /// 构造函数
  DoSomethingUseCase(this._moduleRepository);
  
  /// 执行用例
  Future<Result<ModelName>> execute(DoSomethingParams params) async {
    try {
      // 验证
      if (!_validateData(params.data)) {
        return Result.failure(
          ValidationError(message: '数据格式不正确'),
        );
      }
      
      // 执行
      final result = await _moduleRepository.updateData(params.id, params.data);
      
      // 返回结果
      return Result.success(result);
    } catch (e) {
      // 返回错误
      return Result.failure(
        AppError(message: '操作失败: ${e.toString()}', exception: e),
      );
    }
  }
  
  /// 便捷调用方法
  Future<Result<ModelName>> call(DoSomethingParams params) => execute(params);
  
  /// 验证数据
  bool _validateData(Map<String, dynamic> data) {
    // 实现验证逻辑
    return data.isNotEmpty;
  }
}
```

### 无参数的用例模板

```dart
import 'package:injectable/injectable.dart';

import '../../models/module/model_name.dart';
import '../../domain/abstractions/repositories/i_module_repository.dart';
import '../core/result.dart';

/// 获取数据的用例
///
/// 描述用例的业务目的
@injectable
class GetDataUseCase {
  final IModuleRepository _moduleRepository;
  
  /// 构造函数
  GetDataUseCase(this._moduleRepository);
  
  /// 执行用例
  Future<Result<ModelName>> execute() async {
    try {
      // 执行
      final result = await _moduleRepository.getData();
      
      // 返回结果
      return Result.success(result);
    } catch (e) {
      // 返回错误
      return Result.failure(
        AppError(message: '获取数据失败: ${e.toString()}', exception: e),
      );
    }
  }
  
  /// 便捷调用方法
  Future<Result<ModelName>> call() => execute();
}
```

## Provider模板

```dart
import 'package:flutter/material.dart';

import '../../models/module/model_name.dart';
import '../../application/app_use_cases.dart';
import '../../application/module/do_something_use_case.dart';
import '../../application/core/result.dart';

/// 模块状态管理
class ModuleProvider extends ChangeNotifier {
  final AppUseCases _useCases;
  
  ModelName? _data;
  bool _isLoading = false;
  String _errorMessage = '';
  
  /// 构造函数
  ModuleProvider({AppUseCases? useCases}) 
      : _useCases = useCases ?? AppUseCases.fromGetIt();
  
  /// 当前数据
  ModelName? get data => _data;
  
  /// 是否加载中
  bool get isLoading => _isLoading;
  
  /// 错误信息
  String get errorMessage => _errorMessage;
  
  /// 加载数据
  Future<void> loadData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await _useCases.getData();
    
    result.fold(
      (data) {
        _data = data;
        _errorMessage = '';
      },
      (error) {
        _errorMessage = error.message;
      },
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// 执行操作
  Future<bool> doSomething(String id, Map<String, dynamic> data) async {
    if (_isLoading) return false;
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final params = DoSomethingParams(id: id, data: data);
    final result = await _useCases.doSomething(params);
    
    bool success = false;
    
    result.fold(
      (updatedData) {
        _data = updatedData;
        _errorMessage = '';
        success = true;
      },
      (error) {
        _errorMessage = error.message;
        success = false;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    return success;
  }
  
  /// 清除数据
  void clearData() {
    _data = null;
    _errorMessage = '';
    notifyListeners();
  }
}
```

## 测试模板

### 用例测试模板

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:your_app/domain/abstractions/repositories/i_module_repository.dart';
import 'package:your_app/models/module/model_name.dart';
import 'package:your_app/application/module/do_something_use_case.dart';

// 生成Mock类
@GenerateMocks([IModuleRepository])
import 'do_something_use_case_test.mocks.dart';

void main() {
  late MockIModuleRepository mockRepository;
  late DoSomethingUseCase useCase;
  
  setUp(() {
    mockRepository = MockIModuleRepository();
    useCase = DoSomethingUseCase(mockRepository);
  });
  
  group('DoSomethingUseCase', () {
    final testId = '123';
    final testData = {'name': 'Test Name'};
    final testModel = ModelName(id: testId, name: 'Test Name');
    
    test('should return success with model when repository succeeds', () async {
      // 准备
      when(mockRepository.updateData(testId, testData))
          .thenAnswer((_) async => testModel);
      
      // 执行
      final params = DoSomethingParams(id: testId, data: testData);
      final result = await useCase(params);
      
      // 验证
      expect(result.isSuccess, true);
      expect(result.value.id, testId);
      verify(mockRepository.updateData(testId, testData)).called(1);
    });
    
    test('should return failure when data is invalid', () async {
      // 准备 - 传入空数据触发验证失败
      final emptyData = <String, dynamic>{};
      
      // 执行
      final params = DoSomethingParams(id: testId, data: emptyData);
      final result = await useCase(params);
      
      // 验证
      expect(result.isFailure, true);
      expect(result.error, isA<ValidationError>());
      verifyNever(mockRepository.updateData(any, any));
    });
    
    test('should return failure when repository throws', () async {
      // 准备
      when(mockRepository.updateData(testId, testData))
          .thenThrow(Exception('Repository error'));
      
      // 执行
      final params = DoSomethingParams(id: testId, data: testData);
      final result = await useCase(params);
      
      // 验证
      expect(result.isFailure, true);
      expect(result.error, isA<AppError>());
      expect(result.error.message, contains('Repository error'));
    });
  });
}
```

### Provider测试模板

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:your_app/application/app_use_cases.dart';
import 'package:your_app/application/module/do_something_use_case.dart';
import 'package:your_app/application/module/get_data_use_case.dart';
import 'package:your_app/application/core/result.dart';
import 'package:your_app/models/module/model_name.dart';
import 'package:your_app/providers/module/module_provider.dart';

// 模拟AppUseCases
class MockAppUseCases extends Mock implements AppUseCases {}

void main() {
  late MockAppUseCases mockUseCases;
  late ModuleProvider provider;
  
  setUp(() {
    mockUseCases = MockAppUseCases();
    provider = ModuleProvider(useCases: mockUseCases);
  });
  
  group('ModuleProvider', () {
    final testModel = ModelName(id: '123', name: 'Test Name');
    final testId = '123';
    final testData = {'name': 'Updated Name'};
    final updatedModel = ModelName(id: '123', name: 'Updated Name');
    
    test('initial state should be correct', () {
      expect(provider.data, isNull);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, '');
    });
    
    group('loadData', () {
      test('should update state on success', () async {
        // 准备
        when(mockUseCases.getData())
            .thenAnswer((_) async => Result.success(testModel));
        
        // 执行
        await provider.loadData();
        
        // 验证
        expect(provider.data, testModel);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, '');
      });
      
      test('should update error state on failure', () async {
        // 准备
        when(mockUseCases.getData())
            .thenAnswer((_) async => Result.failure(AppError(message: 'Failed')));
        
        // 执行
        await provider.loadData();
        
        // 验证
        expect(provider.data, isNull);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, 'Failed');
      });
    });
    
    group('doSomething', () {
      test('should update state and return true on success', () async {
        // 准备
        when(mockUseCases.doSomething(any))
            .thenAnswer((_) async => Result.success(updatedModel));
        
        // 执行
        final result = await provider.doSomething(testId, testData);
        
        // 验证
        expect(result, true);
        expect(provider.data, updatedModel);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, '');
      });
      
      test('should update error state and return false on failure', () async {
        // 准备
        when(mockUseCases.doSomething(any))
            .thenAnswer((_) async => Result.failure(AppError(message: 'Failed')));
        
        // 执行
        final result = await provider.doSomething(testId, testData);
        
        // 验证
        expect(result, false);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, 'Failed');
      });
    });
    
    test('clearData should reset state', () {
      // 准备 - 先设置一些数据
      provider = ModuleProvider(useCases: mockUseCases)
        .._data = testModel
        .._errorMessage = 'Some error';
      
      // 执行
      provider.clearData();
      
      // 验证
      expect(provider.data, isNull);
      expect(provider.errorMessage, '');
    });
  });
}
```

## Riverpod模板

### AsyncNotifier模板

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/common/failures/app_failure.dart';
import '../../application/facades/module_facade.dart';

part 'module_async_notifier.g.dart';

/// 模块异步状态管理
@riverpod
class ModuleAsync extends _$ModuleAsync {
  late final ModuleFacade _facade;
  
  @override
  FutureOr<List<ModelName>> build() async {
    _facade = ref.watch(moduleFacadeProvider);
    
    // 初始化加载数据
    final result = await _facade.getDataList();
    return result.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }
  
  /// 刷新数据
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
  
  /// 创建数据
  Future<Either<AppFailure, ModelName>> createData({
    required String name,
    required String description,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _facade.createData(
      name: name,
      description: description,
    );
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (data) async {
        // 刷新列表
        await refresh();
      },
    );
    
    return result;
  }
  
  /// 更新数据
  Future<Either<AppFailure, ModelName>> updateData({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final result = await _facade.updateData(id: id, data: data);
    
    if (result.isRight()) {
      await refresh();
    }
    
    return result;
  }
  
  /// 删除数据
  Future<Either<AppFailure, Unit>> deleteData(String id) async {
    final result = await _facade.deleteData(id);
    
    if (result.isRight()) {
      await refresh();
    }
    
    return result;
  }
}

/// 获取单个数据的Provider
@riverpod
Future<ModelName?> moduleItem(ModuleItemRef ref, String id) async {
  final list = await ref.watch(moduleAsyncProvider.future);
  return list.firstWhereOrNull((item) => item.id == id);
}
```

### StateNotifier模板

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_state_notifier.freezed.dart';
part 'module_state_notifier.g.dart';

/// 模块状态
@freezed
class ModuleState with _$ModuleState {
  const factory ModuleState({
    @Default([]) List<ModelName> items,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    ModelName? selectedItem,
  }) = _ModuleState;
}

/// 模块状态管理
@riverpod
class Module extends _$Module {
  @override
  ModuleState build() {
    return const ModuleState();
  }
  
  /// 设置选中项
  void selectItem(ModelName? item) {
    state = state.copyWith(selectedItem: item);
  }
  
  /// 设置加载状态
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
  
  /// 设置错误信息
  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }
  
  /// 清除错误
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}
```

## Mapper模板

### 基础Mapper实现

```dart
import '../../infrastructure/mappers/base_mapper.dart';
import '../../infrastructure/dtos/generated/models/model_dto.dart';
import '../../domain/module/entities/model_name.dart';

/// 模块数据映射器
class ModuleMapper extends BaseMapper<ModelDto, ModelName> {
  @override
  ModelName toEntity(ModelDto dto) {
    return ModelName(
      id: dto.id,
      name: dto.name,
      description: dto.description ?? '',
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: dto.updatedAt != null 
          ? DateTime.parse(dto.updatedAt!) 
          : null,
      // 处理嵌套对象
      details: dto.details != null 
          ? _detailsMapper.toEntity(dto.details!) 
          : null,
      // 处理枚举
      status: _mapStatus(dto.status),
      // 处理列表
      tags: dto.tags ?? [],
    );
  }
  
  @override
  ModelDto toDto(ModelName entity) {
    return ModelDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      details: entity.details != null 
          ? _detailsMapper.toDto(entity.details!) 
          : null,
      status: _mapStatusToDto(entity.status),
      tags: entity.tags,
    );
  }
  
  // 私有映射方法
  final _detailsMapper = DetailsMapper();
  
  Status _mapStatus(String status) {
    switch (status) {
      case 'active':
        return Status.active;
      case 'inactive':
        return Status.inactive;
      default:
        return Status.unknown;
    }
  }
  
  String _mapStatusToDto(Status status) {
    switch (status) {
      case Status.active:
        return 'active';
      case Status.inactive:
        return 'inactive';
      default:
        return 'unknown';
    }
  }
}
```

## Facade模板

### 模块Facade实现

```dart
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/common/facade/module_facade.dart';
import '../../domain/common/failures/app_failure.dart';
import '../../application/module/get_data_use_case.dart';
import '../../application/module/create_data_use_case.dart';
import '../../application/module/update_data_use_case.dart';
import '../../application/module/delete_data_use_case.dart';

part 'module_facade.g.dart';

/// 模块Facade实现
class ModuleFacadeImpl implements ModuleFacade {
  final GetDataUseCase _getDataUseCase;
  final CreateDataUseCase _createDataUseCase;
  final UpdateDataUseCase _updateDataUseCase;
  final DeleteDataUseCase _deleteDataUseCase;
  
  ModuleFacadeImpl({
    required GetDataUseCase getDataUseCase,
    required CreateDataUseCase createDataUseCase,
    required UpdateDataUseCase updateDataUseCase,
    required DeleteDataUseCase deleteDataUseCase,
  })  : _getDataUseCase = getDataUseCase,
        _createDataUseCase = createDataUseCase,
        _updateDataUseCase = updateDataUseCase,
        _deleteDataUseCase = deleteDataUseCase;
  
  @override
  String get moduleName => 'Module';
  
  @override
  bool get isReady => true;
  
  @override
  Future<void> initialize() async {
    // 初始化模块资源
  }
  
  @override
  Future<void> dispose() async {
    // 清理模块资源
  }
  
  @override
  Future<Either<AppFailure, List<ModelName>>> getDataList() async {
    final result = await _getDataUseCase();
    return result.fold(
      (error) => Left(AppFailure(message: error.message)),
      (data) => Right(data),
    );
  }
  
  @override
  Future<Either<AppFailure, ModelName>> createData({
    required String name,
    required String description,
  }) async {
    final params = CreateDataParams(
      name: name,
      description: description,
    );
    
    final result = await _createDataUseCase(params);
    return result.fold(
      (error) => Left(AppFailure(message: error.message)),
      (data) => Right(data),
    );
  }
  
  @override
  Future<Either<AppFailure, ModelName>> updateData({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final params = UpdateDataParams(id: id, data: data);
    
    final result = await _updateDataUseCase(params);
    return result.fold(
      (error) => Left(AppFailure(message: error.message)),
      (data) => Right(data),
    );
  }
  
  @override
  Future<Either<AppFailure, Unit>> deleteData(String id) async {
    final result = await _deleteDataUseCase(id);
    return result.fold(
      (error) => Left(AppFailure(message: error.message)),
      (_) => const Right(unit),
    );
  }
}

/// 模块Facade Provider
@riverpod
ModuleFacade moduleFacade(ModuleFacadeRef ref) {
  return ModuleFacadeImpl(
    getDataUseCase: ref.watch(getDataUseCaseProvider),
    createDataUseCase: ref.watch(createDataUseCaseProvider),
    updateDataUseCase: ref.watch(updateDataUseCaseProvider),
    deleteDataUseCase: ref.watch(deleteDataUseCaseProvider),
  );
}
```

## 事件模板

### 领域事件定义

```dart
import '../../domain/events/base_event.dart';
import '../module/entities/model_name.dart';

/// 模块创建事件
class ModuleCreatedEvent extends DomainEvent {
  final ModelName model;
  
  ModuleCreatedEvent({
    required this.model,
  }) : super(
          aggregateId: model.id,
          eventType: 'ModuleCreated',
        );
  
  @override
  Map<String, dynamic> toJson() => {
        'model': model.toJson(),
      };
}

/// 模块更新事件
class ModuleUpdatedEvent extends DomainEvent {
  final ModelName model;
  final Map<String, dynamic> changes;
  
  ModuleUpdatedEvent({
    required this.model,
    required this.changes,
  }) : super(
          aggregateId: model.id,
          eventType: 'ModuleUpdated',
        );
  
  @override
  Map<String, dynamic> toJson() => {
        'model': model.toJson(),
        'changes': changes,
      };
}

/// 模块删除事件
class ModuleDeletedEvent extends DomainEvent {
  final String modelId;
  
  ModuleDeletedEvent({
    required this.modelId,
  }) : super(
          aggregateId: modelId,
          eventType: 'ModuleDeleted',
        );
  
  @override
  Map<String, dynamic> toJson() => {
        'modelId': modelId,
      };
}
```

### 事件处理器

```dart
import '../../application/services/event_bus.dart';
import '../../domain/events/module_events.dart';

/// 模块事件处理器
class ModuleEventHandler {
  final EventBus _eventBus;
  
  ModuleEventHandler(this._eventBus) {
    _registerHandlers();
  }
  
  void _registerHandlers() {
    // 监听模块创建事件
    _eventBus.on<ModuleCreatedEvent>((event) async {
      print('Module created: ${event.model.id}');
      // 处理模块创建后的业务逻辑
      await _handleModuleCreated(event);
    });
    
    // 监听模块更新事件
    _eventBus.on<ModuleUpdatedEvent>((event) async {
      print('Module updated: ${event.model.id}');
      // 处理模块更新后的业务逻辑
      await _handleModuleUpdated(event);
    });
    
    // 监听模块删除事件
    _eventBus.on<ModuleDeletedEvent>((event) async {
      print('Module deleted: ${event.modelId}');
      // 处理模块删除后的业务逻辑
      await _handleModuleDeleted(event);
    });
  }
  
  Future<void> _handleModuleCreated(ModuleCreatedEvent event) async {
    // 实现创建后的业务逻辑
    // 例如：发送通知、更新缓存、触发其他流程等
  }
  
  Future<void> _handleModuleUpdated(ModuleUpdatedEvent event) async {
    // 实现更新后的业务逻辑
  }
  
  Future<void> _handleModuleDeleted(ModuleDeletedEvent event) async {
    // 实现删除后的业务逻辑
  }
}
```

## 图表组件模板

### 自定义图表组件

```dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../presentation/components/charts/base_chart.dart';
import '../../presentation/components/charts/chart_config.dart';

/// 模块数据图表
class ModuleDataChart extends BaseChart {
  final List<ModuleData> data;
  final String? title;
  
  const ModuleDataChart({
    super.key,
    required this.data,
    required super.config,
    this.title,
  });
  
  @override
  Widget buildChart(BuildContext context) {
    if (data.isEmpty) {
      return BaseChart.empty(
        config: config,
        message: '暂无数据',
      );
    }
    
    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: config.height,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              barTouchData: BarTouchData(
                enabled: config.interactive,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: config.theme.tooltipBackgroundColor,
                  getTooltipItem: _getTooltipItem,
                ),
              ),
              titlesData: FlTitlesData(
                show: config.showLabels,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: config.showAxis,
                  ),
                ),
              ),
              borderData: FlBorderData(show: config.showGrid),
              barGroups: _createBarGroups(),
              gridData: FlGridData(show: config.showGrid),
            ),
            swapAnimationDuration: config.animationDuration,
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
        if (config.showLegend) ...[
          const SizedBox(height: 16),
          _buildLegend(context),
        ],
      ],
    );
  }
  
  double _calculateMaxY() {
    return data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;
  }
  
  List<BarChartGroupData> _createBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.value,
            color: config.theme.getColorForIndex(index),
            width: 22,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }
  
  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < data.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          data[index].label,
          style: TextStyle(
            color: config.theme.labelColor,
            fontSize: 12,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
  
  BarTooltipItem? _getTooltipItem(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    return BarTooltipItem(
      '${data[groupIndex].label}\n',
      TextStyle(
        color: config.theme.tooltipTextColor,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text: rod.toY.toStringAsFixed(1),
          style: TextStyle(
            color: config.theme.getColorForIndex(groupIndex),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: config.theme.getColorForIndex(index),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.label,
              style: TextStyle(
                color: config.theme.labelColor,
                fontSize: 12,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// 模块数据模型
class ModuleData {
  final String label;
  final double value;
  
  const ModuleData({
    required this.label,
    required this.value,
  });
}
```

### Widgetbook用例

```dart
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter/material.dart';

import 'module_data_chart.dart';
import '../../presentation/components/charts/chart_config.dart';

@widgetbook.UseCase(name: 'Default', type: ModuleDataChart)
Widget moduleDataChartDefaultUseCase(BuildContext context) {
  final data = [
    ModuleData(label: '一月', value: 65),
    ModuleData(label: '二月', value: 78),
    ModuleData(label: '三月', value: 90),
    ModuleData(label: '四月', value: 85),
    ModuleData(label: '五月', value: 95),
  ];
  
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: ModuleDataChart(
        data: data,
        config: ChartConfig(
          theme: ChartTheme.fromTheme(Theme.of(context)),
          showLegend: true,
          showGrid: true,
          animate: true,
        ),
        title: '月度数据统计',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Loading', type: ModuleDataChart)
Widget moduleDataChartLoadingUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: BaseChart.loading(
        config: ChartConfig(
          theme: ChartTheme.fromTheme(Theme.of(context)),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Error', type: ModuleDataChart)
Widget moduleDataChartErrorUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: BaseChart.error(
        message: '加载数据失败',
        config: ChartConfig(
          theme: ChartTheme.fromTheme(Theme.of(context)),
        ),
        onRetry: () {
          print('Retry clicked');
        },
      ),
    ),
  );
}
```

---

这些模板提供了创建符合架构规范的各类组件的标准方式，包括新增的架构改进功能。在实际开发中，可以根据具体需求进行适当调整，但应保持整体架构风格的一致性。

新增的模板包括：
- **Riverpod模板** - AsyncNotifier和StateNotifier的使用方式
- **Mapper模板** - DTO与Entity之间的转换实现
- **Facade模板** - 模块统一接口的实现方式
- **事件模板** - 领域事件的定义和处理
- **图表组件模板** - 数据可视化组件的创建方式

这些模板配合原有的模板，为开发团队提供了完整的代码规范指导。

## Mason 模板生成器

本项目支持使用 [Mason](https://pub.dev/packages/mason_cli) 作为代码模板生成工具，帮助快速创建符合项目架构的新功能模块。

### 安装Mason CLI

```bash
dart pub global activate mason_cli
```

### 初始化项目Mason环境

```bash
# 初始化环境并创建功能模块模板
./scripts/init_mason.sh

# 创建UI组件模板
./scripts/init_widget_brick.sh
```

### 创建新功能模块

```bash
# 方法1：使用Mason CLI
mason make feature_module --name nutrition_analysis --description "营养分析功能模块"

# 方法2：使用便捷脚本
./scripts/create_module.sh nutrition_analysis "营养分析功能模块"
```

这将创建完整的Clean Architecture层级结构：

```
lib/features/nutrition_analysis/
├── data/
│   └── repositories/
│       └── nutrition_analysis_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── nutrition_analysis_repository.dart
│   └── usecases/
│       └── get_nutrition_analysis.dart
└── presentation/
    ├── providers/
    │   └── nutrition_analysis_provider.dart
    └── pages/
        └── nutrition_analysis_page.dart
```

### 创建新UI组件

```bash
# 方法1：使用Mason CLI
mason make widget --name food_card --category cards --description "食物卡片组件"

# 方法2：使用便捷脚本
./scripts/create_widget.sh food_card cards "食物卡片组件"
```

这将创建以下文件：
- 组件实现：`lib/components/cards/food_card.dart`
- 单元测试：`test/components/cards/food_card_test.dart`
- Golden测试：`test/golden/components/cards/food_card_golden_test.dart`
- Widgetbook测试：`test/golden/components/cards/food_card_widgetbook_test.dart` 