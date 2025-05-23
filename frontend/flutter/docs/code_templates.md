# 代码模板

本文档提供智能营养餐厅App常用代码模板，便于团队快速创建符合架构规范的代码文件。

## 目录

- [接口模板](#接口模板)
- [实现类模板](#实现类模板)
- [用例模板](#用例模板)
- [Provider模板](#provider模板)
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

---

这些模板提供了创建符合架构规范的各类组件的标准方式。在实际开发中，可以根据具体需求进行适当调整，但应保持整体架构风格的一致性。 