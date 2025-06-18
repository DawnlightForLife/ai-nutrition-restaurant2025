/**
 * 营养需求分析页面
 * AI智能分析用户营养需求，提供个性化建议
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/nutrition_ordering.dart';
import '../providers/nutrition_ordering_provider.dart';
import '../widgets/nutrition_needs_display_widget.dart';
import '../widgets/ai_nutrition_analysis_widget.dart';
import '../widgets/nutrition_goals_selector_widget.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../core/extensions/context_extensions.dart';

class NutritionNeedsAnalysisPage extends ConsumerStatefulWidget {
  final String? profileId;

  const NutritionNeedsAnalysisPage({
    super.key,
    this.profileId,
  });

  @override
  ConsumerState<NutritionNeedsAnalysisPage> createState() =>
      _NutritionNeedsAnalysisPageState();
}

class _NutritionNeedsAnalysisPageState
    extends ConsumerState<NutritionNeedsAnalysisPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedProfileId;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedProfileId = widget.profileId;
    
    // 如果有profileId，立即开始分析
    if (_selectedProfileId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performNutritionAnalysis();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _performNutritionAnalysis() async {
    if (_selectedProfileId == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      await ref
          .read(nutritionOrderingProvider.notifier)
          .analyzeNutritionNeeds(_selectedProfileId!);
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('营养分析失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _onProfileSelected(String profileId) {
    setState(() {
      _selectedProfileId = profileId;
    });
    _performNutritionAnalysis();
  }

  void _onStartOrdering() {
    if (_selectedProfileId != null) {
      context.pushRoute('/nutrition/ordering/element-selection', extra: {
        'profileId': _selectedProfileId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionOrderingProvider);
    final needsAnalysis = state.nutritionNeeds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('营养需求分析'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade800,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green.shade800,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: Colors.green.shade600,
          tabs: const [
            Tab(
              icon: Icon(Icons.analytics_outlined),
              text: 'AI分析',
            ),
            Tab(
              icon: Icon(Icons.track_changes_outlined),
              text: '营养目标',
            ),
            Tab(
              icon: Icon(Icons.insights_outlined),
              text: '详细报告',
            ),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isAnalyzing || state.isLoading,
        child: TabBarView(
          controller: _tabController,
          children: [
            // AI分析标签页
            _buildAIAnalysisTab(needsAnalysis),
            
            // 营养目标标签页
            _buildNutritionGoalsTab(),
            
            // 详细报告标签页
            _buildDetailedReportTab(needsAnalysis),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(needsAnalysis),
    );
  }

  Widget _buildAIAnalysisTab(NutritionNeedsAnalysis? needsAnalysis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI分析状态卡片
          _buildAnalysisStatusCard(),
          
          const SizedBox(height: 16),
          
          // 营养档案选择器
          if (_selectedProfileId == null) _buildProfileSelector(),
          
          const SizedBox(height: 16),
          
          // AI营养分析组件
          if (needsAnalysis != null) 
            AIProfileNutritionAnalysisWidget(
              analysis: needsAnalysis,
              onReanalyze: _performNutritionAnalysis,
            )
          else
            _buildEmptyAnalysisState(),
        ],
      ),
    );
  }

  Widget _buildAnalysisStatusCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: Colors.green.shade600,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI营养分析助手',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '基于您的个人资料和健康目标，AI将为您提供科学、个性化的营养需求分析，'
              '帮助您精准选择所需的营养元素和食材。',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            if (_isAnalyzing) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '正在分析您的营养需求...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择营养档案',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '请选择一个营养档案开始分析',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 打开营养档案选择对话框
                  _showProfileSelectionDialog();
                },
                icon: const Icon(Icons.person_outline),
                label: const Text('选择营养档案'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAnalysisState() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '等待分析',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '选择营养档案后开始AI分析',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionGoalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          NutritionGoalsSelectorWidget(
            profileId: _selectedProfileId,
            onGoalsUpdated: () {
              // 目标更新后重新分析
              _performNutritionAnalysis();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedReportTab(NutritionNeedsAnalysis? needsAnalysis) {
    if (needsAnalysis == null) {
      return const Center(
        child: Text('暂无分析报告'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: NutritionNeedsDisplayWidget(
        analysis: needsAnalysis,
        showActions: true,
      ),
    );
  }

  Widget _buildBottomActionBar(NutritionNeedsAnalysis? needsAnalysis) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _selectedProfileId != null ? _performNutritionAnalysis : null,
              icon: const Icon(Icons.refresh),
              label: const Text('重新分析'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: Colors.green.shade300),
                foregroundColor: Colors.green.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: needsAnalysis != null ? _onStartOrdering : null,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('开始定制营养餐'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSelectionDialog() {
    // TODO: 实现营养档案选择对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择营养档案'),
        content: const Text('营养档案选择功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}