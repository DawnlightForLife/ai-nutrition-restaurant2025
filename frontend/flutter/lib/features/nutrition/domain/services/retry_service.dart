import 'dart:async';
import 'dart:math';

/// 重试策略
enum RetryStrategy {
  linear,      // 线性延迟
  exponential, // 指数退避
  immediate,   // 立即重试
}

/// 重试配置
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final RetryStrategy strategy;
  final double backoffMultiplier;
  final bool Function(dynamic error)? retryIf;
  
  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.strategy = RetryStrategy.exponential,
    this.backoffMultiplier = 2.0,
    this.retryIf,
  });
  
  /// 网络操作的默认配置
  static const RetryConfig network = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 10),
    strategy: RetryStrategy.exponential,
    backoffMultiplier: 2.0,
  );
  
  /// 数据操作的默认配置
  static const RetryConfig data = RetryConfig(
    maxAttempts: 2,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 5),
    strategy: RetryStrategy.linear,
  );
  
  /// 立即重试配置
  static const RetryConfig immediate = RetryConfig(
    maxAttempts: 1,
    initialDelay: Duration.zero,
    strategy: RetryStrategy.immediate,
  );
}

/// 重试服务
class RetryService {
  /// 执行带重试的异步操作
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    RetryConfig config = RetryConfig.network,
    void Function(int attempt, dynamic error)? onRetry,
  }) async {
    int attempt = 0;
    dynamic lastError;
    
    while (attempt < config.maxAttempts) {
      attempt++;
      
      try {
        return await operation();
      } catch (error) {
        lastError = error;
        
        // 检查是否应该重试
        if (config.retryIf != null && !config.retryIf!(error)) {
          throw error;
        }
        
        // 如果已经是最后一次尝试，直接抛出错误
        if (attempt >= config.maxAttempts) {
          throw error;
        }
        
        // 计算延迟时间
        final delay = _calculateDelay(attempt, config);
        
        // 调用重试回调
        onRetry?.call(attempt, error);
        
        print('🔄 重试第 $attempt 次，延迟 ${delay.inMilliseconds}ms: $error');
        
        // 等待后重试
        if (delay > Duration.zero) {
          await Future.delayed(delay);
        }
      }
    }
    
    // 如果所有重试都失败了，抛出最后一个错误
    throw lastError;
  }
  
  /// 计算延迟时间
  static Duration _calculateDelay(int attempt, RetryConfig config) {
    switch (config.strategy) {
      case RetryStrategy.immediate:
        return Duration.zero;
        
      case RetryStrategy.linear:
        final delay = config.initialDelay * attempt;
        return delay > config.maxDelay ? config.maxDelay : delay;
        
      case RetryStrategy.exponential:
        final delay = Duration(
          milliseconds: (config.initialDelay.inMilliseconds * 
                        pow(config.backoffMultiplier, attempt - 1)).round(),
        );
        return delay > config.maxDelay ? config.maxDelay : delay;
    }
  }
  
  /// 创建可重试的操作包装器
  static Future<T> Function() wrap<T>(
    Future<T> Function() operation, {
    RetryConfig config = RetryConfig.network,
    void Function(int attempt, dynamic error)? onRetry,
  }) {
    return () => execute(operation, config: config, onRetry: onRetry);
  }
}

/// 重试状态管理
class RetryState {
  final int currentAttempt;
  final int maxAttempts;
  final bool isRetrying;
  final Duration? nextRetryIn;
  final dynamic lastError;
  
  const RetryState({
    this.currentAttempt = 0,
    this.maxAttempts = 3,
    this.isRetrying = false,
    this.nextRetryIn,
    this.lastError,
  });
  
  bool get canRetry => currentAttempt < maxAttempts;
  bool get hasReachedMaxAttempts => currentAttempt >= maxAttempts;
  double get progress => maxAttempts > 0 ? currentAttempt / maxAttempts : 0.0;
  
  RetryState copyWith({
    int? currentAttempt,
    int? maxAttempts,
    bool? isRetrying,
    Duration? nextRetryIn,
    dynamic lastError,
  }) {
    return RetryState(
      currentAttempt: currentAttempt ?? this.currentAttempt,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      isRetrying: isRetrying ?? this.isRetrying,
      nextRetryIn: nextRetryIn,
      lastError: lastError ?? this.lastError,
    );
  }
}

/// 可重试的操作包装器
class RetryableOperation<T> {
  final Future<T> Function() _operation;
  final RetryConfig _config;
  final void Function(RetryState state)? _onStateChanged;
  
  RetryState _state = const RetryState();
  Timer? _retryTimer;
  
  RetryableOperation(
    this._operation, {
    RetryConfig config = RetryConfig.network,
    void Function(RetryState state)? onStateChanged,
  }) : _config = config, _onStateChanged = onStateChanged;
  
  /// 当前重试状态
  RetryState get state => _state;
  
  /// 执行操作
  Future<T> execute() async {
    _updateState(_state.copyWith(
      currentAttempt: 0,
      isRetrying: false,
      nextRetryIn: null,
      lastError: null,
    ));
    
    return await RetryService.execute(
      _operation,
      config: _config,
      onRetry: _onRetry,
    );
  }
  
  /// 手动重试
  Future<T> retry() async {
    if (!_state.canRetry) {
      throw StateError('已达到最大重试次数');
    }
    
    _cancelRetryTimer();
    return await execute();
  }
  
  /// 取消重试
  void cancel() {
    _cancelRetryTimer();
    _updateState(_state.copyWith(isRetrying: false));
  }
  
  void _onRetry(int attempt, dynamic error) {
    final delay = RetryService._calculateDelay(attempt + 1, _config);
    
    _updateState(_state.copyWith(
      currentAttempt: attempt,
      isRetrying: true,
      nextRetryIn: delay,
      lastError: error,
    ));
    
    // 启动倒计时定时器
    _startRetryTimer(delay);
  }
  
  void _startRetryTimer(Duration delay) {
    _cancelRetryTimer();
    
    if (delay > Duration.zero) {
      _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remaining = delay - Duration(seconds: timer.tick);
        
        if (remaining <= Duration.zero) {
          _cancelRetryTimer();
          _updateState(_state.copyWith(nextRetryIn: null));
        } else {
          _updateState(_state.copyWith(nextRetryIn: remaining));
        }
      });
    }
  }
  
  void _cancelRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }
  
  void _updateState(RetryState newState) {
    _state = newState;
    _onStateChanged?.call(_state);
  }
  
  void dispose() {
    _cancelRetryTimer();
  }
}