import 'app_exceptions.dart';
import '../failures/failures.dart';

/// 异常到失败的映射器
/// 
/// 用于在Repository实现中将数据层的异常转换为领域层的失败
class ExceptionMapper {
  /// 将异常转换为失败
  static Failure handleException(Exception exception) {
    if (exception is AppException) {
      return _mapAppException(exception);
    }
    
    // 处理其他类型的异常
    return UnknownFailure(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
    );
  }
  
  /// 将AppException转换为对应的Failure
  static Failure _mapAppException(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return NetworkFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      
      case ApiException:
        final apiException = exception as ApiException;
        return ServerFailure(
          message: apiException.message,
          code: apiException.code,
          statusCode: apiException.statusCode,
          details: apiException.details,
        );
      
      case ValidationException:
        final validationException = exception as ValidationException;
        return ValidationFailure(
          message: validationException.message,
          errors: validationException.errors,
          code: validationException.code,
        );
      
      case AuthException:
        return AuthFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      
      case CacheException:
        return CacheFailure(
          message: exception.message,
          code: exception.code,
        );
      
      case PermissionException:
        return PermissionFailure(
          message: exception.message,
          code: exception.code,
        );
      
      case BusinessException:
        return BusinessFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
      
      case DataFormatException:
        return DataFormatFailure(
          message: exception.message,
          code: exception.code,
        );
      
      default:
        return UnknownFailure(
          message: exception.message,
          code: exception.code,
          details: exception.details,
        );
    }
  }
  
  /// 异步操作的便捷方法
  static Future<T> guardAsync<T>(
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } on AppException catch (e) {
      throw _mapAppException(e);
    } on Exception catch (e) {
      throw handleException(e);
    }
  }
  
  /// 同步操作的便捷方法
  static T guard<T>(
    T Function() operation,
  ) {
    try {
      return operation();
    } on AppException catch (e) {
      throw _mapAppException(e);
    } on Exception catch (e) {
      throw handleException(e);
    }
  }
}