import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用异步状态组件，处理 AsyncValue 的三种状态：loading/data/error
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
    this.skipError = false,
  });

  /// AsyncValue 数据
  final AsyncValue<T> value;
  
  /// 数据状态时的构建器
  final Widget Function(T data) data;
  
  /// 加载状态时的构建器（可选）
  final Widget Function()? loading;
  
  /// 错误状态时的构建器（可选）
  final Widget Function(Object error, StackTrace stackTrace)? error;
  
  /// 刷新时是否跳过加载状态
  final bool skipLoadingOnRefresh;
  
  /// 重新加载时是否跳过加载状态
  final bool skipLoadingOnReload;
  
  /// 是否跳过错误状态
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      skipError: skipError,
      loading: loading ?? _defaultLoading,
      error: error ?? _defaultError,
      data: data,
    );
  }

  Widget _defaultLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            '加载中...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultError(Object error, StackTrace stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.red[400],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              _getErrorMessage(error),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error.toString().contains('network')) {
      return '网络连接失败，请检查网络设置';
    } else if (error.toString().contains('timeout')) {
      return '请求超时，请稍后重试';
    } else if (error.toString().contains('401')) {
      return '未授权，请重新登录';
    } else if (error.toString().contains('403')) {
      return '权限不足';
    } else if (error.toString().contains('404')) {
      return '请求的资源不存在';
    } else if (error.toString().contains('500')) {
      return '服务器内部错误';
    }
    return '未知错误，请稍后重试';
  }
}

/// 带刷新功能的异步状态组件
class AsyncViewWithRefresh<T> extends ConsumerWidget {
  const AsyncViewWithRefresh({
    super.key,
    required this.value,
    required this.data,
    required this.onRefresh,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
    this.skipError = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Future<void> Function() onRefresh;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;
  final bool skipError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AsyncView<T>(
        value: value,
        data: data,
        loading: loading,
        error: error ?? _errorWithRefresh,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipLoadingOnReload: skipLoadingOnReload,
        skipError: skipError,
      ),
    );
  }

  Widget _errorWithRefresh(Object error, StackTrace stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.red[400],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              _getErrorMessage(error),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('重试'),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error.toString().contains('network')) {
      return '网络连接失败，请检查网络设置';
    } else if (error.toString().contains('timeout')) {
      return '请求超时，请稍后重试';
    } else if (error.toString().contains('401')) {
      return '未授权，请重新登录';
    } else if (error.toString().contains('403')) {
      return '权限不足';
    } else if (error.toString().contains('404')) {
      return '请求的资源不存在';
    } else if (error.toString().contains('500')) {
      return '服务器内部错误';
    }
    return '未知错误，请稍后重试';
  }
}