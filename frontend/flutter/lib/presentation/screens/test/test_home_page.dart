import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../core/navigation/app_router.dart';
import '../../../core/network/network_monitor.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/network/offline_manager.dart';
import '../../../infrastructure/dtos/offline_operation.dart';

@RoutePage()
class TestHomePage extends ConsumerStatefulWidget {
  const TestHomePage({super.key});

  @override
  ConsumerState<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends ConsumerState<TestHomePage> {
  final _networkMonitor = GetIt.I<NetworkMonitor>();
  final _offlineManager = GetIt.I<OfflineManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 1 Test Suite'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTestSection(
            title: 'Routing Tests',
            tests: [
              _TestItem(
                name: 'Navigate to Login (Guest Guard)',
                onTest: () async {
                  context.router.push(const LoginRoute());
                  return;
                },
              ),
              _TestItem(
                name: 'Navigate to Profile (Auth Guard)',
                onTest: () async {
                  context.router.push(const ProfileRoute());
                  return;
                },
              ),
              _TestItem(
                name: 'Navigate to 404 Page',
                onTest: () async {
                  context.router.pushNamed('/non-existent-route');
                  return;
                },
              ),
              _TestItem(
                name: 'Navigate with Deep Link',
                onTest: () async {
                  context.router.navigateNamed('/restaurant/123');
                  return;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTestSection(
            title: 'Error Handling Tests',
            tests: [
              _TestItem(
                name: 'Throw Network Exception',
                onTest: () async {
                  throw NetworkException('Test network error');
                },
              ),
              _TestItem(
                name: 'Throw Auth Exception',
                onTest: () async {
                  throw AuthException('Test auth error');
                },
              ),
              _TestItem(
                name: 'Throw General Exception',
                onTest: () async {
                  throw Exception('Test general exception');
                },
              ),
              _TestItem(
                name: 'Test Async Error',
                onTest: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  throw ServerException('Test async server error');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTestSection(
            title: 'Network Monitoring Tests',
            tests: [
              _TestItem(
                name: 'Check Current Network Status',
                onTest: () async {
                  final status = _networkMonitor.currentStatus;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Connected: ${status.isConnected}, '
                        'Type: ${status.connectionType}, '
                        'Has Internet: ${status.hasInternet}',
                      ),
                    ),
                  );
                  return;
                },
              ),
              _TestItem(
                name: 'Add Offline Operation',
                onTest: () async {
                  final operation = OfflineOperation(
                    endpoint: '/api/test',
                    method: 'POST',
                    data: {'test': 'data', 'timestamp': DateTime.now().toIso8601String()},
                  );
                  
                  await _offlineManager.addOperation(operation);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offline operation added to queue'),
                      ),
                    );
                  }
                  return;
                },
              ),
              _TestItem(
                name: 'Cache Test Data',
                onTest: () async {
                  await _offlineManager.cacheData(
                    'test_data',
                    {
                      'message': 'This is cached test data',
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data cached successfully'),
                      ),
                    );
                  }
                  return;
                },
              ),
              _TestItem(
                name: 'Retrieve Cached Data',
                onTest: () async {
                  final data = await _offlineManager.getCachedData('test_data');
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          data != null 
                            ? 'Cached data: ${data['message']}' 
                            : 'No cached data found',
                        ),
                      ),
                    );
                  }
                  return;
                },
              ),
              _TestItem(
                name: 'View Pending Operations',
                onTest: () async {
                  final operations = await _offlineManager.getPendingOperations();
                  
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pending Operations'),
                        content: operations.isEmpty
                          ? const Text('No pending operations')
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: operations.map((op) => ListTile(
                                title: Text(op.endpoint),
                                subtitle: Text('${op.method}'),
                                trailing: Text(
                                  op.timestamp.toString().split('.').first,
                                ),
                              )).toList(),
                            ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  }
                  return;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTestSection(
            title: 'Integration Tests',
            tests: [
              _TestItem(
                name: 'Test Error + Offline Queue',
                onTest: () async {
                  try {
                    // Simulate network error
                    throw NetworkException('Network unavailable');
                  } catch (e) {
                    // Queue operation for retry
                    final operation = OfflineOperation(
                      endpoint: '/api/error-test',
                      method: 'POST',
                      data: {'error': e.toString()},
                    );
                    
                    await _offlineManager.addOperation(operation);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error caught and operation queued'),
                        ),
                      );
                    }
                  }
                  return;
                },
              ),
              _TestItem(
                name: 'Navigate to Test Error Page',
                onTest: () async {
                  context.router.push(const TestErrorRoute());
                  return;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required List<_TestItem> tests,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 0),
          ...tests.map((test) => ListTile(
            title: Text(test.name),
            trailing: const Icon(Icons.play_arrow),
            onTap: () async {
              try {
                await test.onTest();
              } catch (e, stackTrace) {
                if (mounted) {
                  GlobalErrorHandler.showErrorSnackBar(
                    context,
                    title: 'Test Error',
                    message: e.toString(),
                  );
                  
                  GlobalErrorHandler.logError(
                    'Test error',
                    error: e,
                    stackTrace: stackTrace,
                  );
                }
              }
            },
          )),
        ],
      ),
    );
  }
}

class _TestItem {
  final String name;
  final Future<void> Function() onTest;

  const _TestItem({
    required this.name,
    required this.onTest,
  });
}