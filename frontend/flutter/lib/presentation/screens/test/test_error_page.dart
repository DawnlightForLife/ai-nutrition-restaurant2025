import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/error/error_boundary.dart';

@RoutePage()
class TestErrorPage extends StatelessWidget {
  const TestErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Boundary Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'This page tests error boundaries by wrapping error-prone widgets',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Test 1: Widget with immediate error
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test 1: Immediate Error',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ErrorBoundary(
                      errorBuilder: (context, error) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                'Error caught: ${error.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const _ErrorWidget(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test 2: Widget with async error
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test 2: Async Error',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ErrorBoundary(
                      errorBuilder: (context, error) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(height: 8),
                              Text(
                                'Async error caught: ${error.message}',
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const _AsyncErrorWidget(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test 3: Recoverable error
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test 3: Recoverable Error',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const _RecoverableErrorWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    // This will throw an error immediately
    throw ValidationException('This is a test validation error');
  }
}

class _AsyncErrorWidget extends StatefulWidget {
  const _AsyncErrorWidget();

  @override
  State<_AsyncErrorWidget> createState() => _AsyncErrorWidgetState();
}

class _AsyncErrorWidgetState extends State<_AsyncErrorWidget> {
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    throw ServerException('Async server error after 2 seconds');
  }
  
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text('This should not be visible');
  }
}

class _RecoverableErrorWidget extends StatefulWidget {
  const _RecoverableErrorWidget();

  @override
  State<_RecoverableErrorWidget> createState() => _RecoverableErrorWidgetState();
}

class _RecoverableErrorWidgetState extends State<_RecoverableErrorWidget> {
  bool _hasError = false;
  
  void _triggerError() {
    setState(() {
      _hasError = true;
    });
  }
  
  void _recover() {
    setState(() {
      _hasError = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorBuilder: (context, error) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                'Recoverable error: ${error.message}',
                style: const TextStyle(color: Colors.blue),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _recover,
                child: const Text('Recover'),
              ),
            ],
          ),
        );
      },
      child: _hasError
        ? throw CacheException('This is a recoverable error')
        : Column(
            children: [
              const Text('Widget is working normally'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _triggerError,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Trigger Error'),
              ),
            ],
          ),
    );
  }
}