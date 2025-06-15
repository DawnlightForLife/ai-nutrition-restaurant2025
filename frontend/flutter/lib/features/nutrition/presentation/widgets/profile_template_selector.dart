import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/nutrition_template_model.dart';
import '../../data/models/nutrition_profile_model.dart';
import '../../data/datasources/remote/nutrition_profile_extended_api.dart';
import '../../data/datasources/remote/nutrition_profile_extended_api_provider.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../../../core/widgets/shimmer_loading.dart';

/// 营养档案模板选择器
class ProfileTemplateSelector extends ConsumerStatefulWidget {
  final Function(NutritionTemplateModel) onTemplateSelected;
  final bool isEnabled;

  const ProfileTemplateSelector({
    Key? key,
    required this.onTemplateSelected,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  ConsumerState<ProfileTemplateSelector> createState() => _ProfileTemplateSelectorState();
}

class _ProfileTemplateSelectorState extends ConsumerState<ProfileTemplateSelector> {
  String? selectedTemplateKey;
  List<Map<String, dynamic>> templates = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = ref.read(nutritionProfileExtendedApiServiceProvider);
      final templatesData = await apiService.getTemplates();
      
      if (mounted) {
        setState(() {
          templates = templatesData;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = '获取模板失败: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard_customize,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '快速开始',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '选择一个模板快速创建营养档案',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              _buildLoadingState()
            else if (error != null)
              _buildErrorState()
            else if (templates.isEmpty)
              _buildEmptyState()
            else
              _buildTemplateGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const ShimmerLoading(
      child: Row(
        children: [
          Expanded(child: _TemplateCardSkeleton()),
          SizedBox(width: 12),
          Expanded(child: _TemplateCardSkeleton()),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return ErrorRetryWidget(
      message: error!,
      onRetry: _loadTemplates,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Text(
        '暂无可用模板',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildTemplateGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final templateData = templates[index];
        
        // 直接使用原始数据而不是解析为模型
        final templateKey = templateData['key']?.toString() ?? 'template_$index';
        final templateName = templateData['name']?.toString() ?? '未命名模板';
        
        return _SimpleTemplateCard(
          templateKey: templateKey,
          name: templateName,
          description: templateData['description']?.toString(),
          isSelected: selectedTemplateKey == templateKey,
          onTap: () {
            setState(() {
              selectedTemplateKey = templateKey;
            });
            
            // 创建简化的模板对象传递给回调
            final mockTemplate = _createMockTemplate(templateData);
            widget.onTemplateSelected(mockTemplate);
            
            // 显示成功提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已应用"$templateName"模板'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }
  
  /// 创建简化的模板对象
  NutritionTemplateModel _createMockTemplate(Map<String, dynamic> templateData) {
    // 创建一个简单的NutritionProfileModel
    final mockProfileModel = NutritionTemplateModel(
      key: templateData['key']?.toString() ?? '',
      name: templateData['name']?.toString() ?? '',
      description: templateData['description']?.toString(),
      data: NutritionProfileModel(
        id: null,
        userId: '',
        profileName: '',
        gender: '',
        nutritionGoals: const [],
        isPrimary: false,
        createdAt: null,
        updatedAt: null,
      ),
    );
    
    return mockProfileModel;
  }
}

/// 简化的模板卡片
class _SimpleTemplateCard extends StatelessWidget {
  final String templateKey;
  final String name;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;

  const _SimpleTemplateCard({
    super.key,
    required this.templateKey,
    required this.name,
    this.description,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIconForTemplate(String key) {
    switch (key) {
      case 'diabetic':
        return Icons.medical_services;
      case 'fitness':
        return Icons.fitness_center;
      case 'pregnancy':
        return Icons.pregnant_woman;
      case 'weightLoss':
        return Icons.trending_down;
      default:
        return Icons.person;
    }
  }

  Color _getColorForTemplate(String key) {
    switch (key) {
      case 'diabetic':
        return Colors.blue;
      case 'fitness':
        return Colors.orange;
      case 'pregnancy':
        return Colors.pink;
      case 'weightLoss':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForTemplate(templateKey);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.1) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForTemplate(templateKey),
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 模板卡片
class _TemplateCard extends StatelessWidget {
  final NutritionTemplateModel template;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    Key? key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  IconData _getIconForTemplate(String key) {
    switch (key) {
      case 'diabetic':
        return Icons.medical_services;
      case 'fitness':
        return Icons.fitness_center;
      case 'pregnancy':
        return Icons.pregnant_woman;
      case 'weightLoss':
        return Icons.trending_down;
      default:
        return Icons.person;
    }
  }

  Color _getColorForTemplate(String key) {
    switch (key) {
      case 'diabetic':
        return Colors.blue;
      case 'fitness':
        return Colors.orange;
      case 'pregnancy':
        return Colors.pink;
      case 'weightLoss':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final templateKey = template.key ?? 'default';
    final color = _getColorForTemplate(templateKey);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.1) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForTemplate(templateKey),
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                template.name ?? '未命名模板',
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 模板卡片骨架屏
class _TemplateCardSkeleton extends StatelessWidget {
  const _TemplateCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}