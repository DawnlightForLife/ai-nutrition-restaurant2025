/// 结果模型类
/// 处理异步操作的结果，可以是成功或失败
class Result<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  /// 构造函数
  Result({
    required this.isSuccess,
    this.data,
    this.errorMessage,
  });

  /// 创建成功结果
  factory Result.success(T data) {
    return Result(
      isSuccess: true,
      data: data,
    );
  }

  /// 创建失败结果
  factory Result.failure(String message) {
    return Result(
      isSuccess: false,
      errorMessage: message,
    );
  }

  /// 判断是否成功
  bool get isFailure => !isSuccess;

  /// 根据结果状态处理
  void when({
    required Function(T data) success,
    required Function(String message) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else {
      failure(errorMessage ?? '未知错误');
    }
  }

  /// 映射结果到新类型
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      final transformedData = transform(data as T);
      return Result.success(transformedData);
    } else {
      return Result<R>.failure(errorMessage ?? '未知错误');
    }
  }

  /// 获取成功结果数据或默认值
  T getOrElse(T defaultValue) {
    if (isSuccess && data != null) {
      return data as T;
    } else {
      return defaultValue;
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Success: $data';
    } else {
      return 'Failure: $errorMessage';
    }
  }
}