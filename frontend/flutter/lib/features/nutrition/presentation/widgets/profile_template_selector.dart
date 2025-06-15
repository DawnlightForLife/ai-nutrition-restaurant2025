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
  static final Map<String, List<Map<String, dynamic>>> _templateCache = {};
  static final Map<String, DateTime> _cacheTimestamp = {};

  @override
  void initState() {
    super.initState();
    _loadTemplatesWithFallback();
  }

  // 预设模板数据（用于立即显示，避免用户等待）
  static const List<Map<String, dynamic>> _fallbackTemplates = [
    {
      'key': 'weightLoss',
      'name': '减重塑形',
      'description': '科学减重，健康塑形，适合想要控制体重的用户',
    },
    {
      'key': 'fitness',
      'name': '健身增肌',
      'description': '增强体质，塑造肌肉线条，适合健身爱好者',
    },
    {
      'key': 'diabetic',
      'name': '血糖管理',
      'description': '血糖控制，营养均衡，适合糖尿病患者',
    },
    {
      'key': 'balanced',
      'name': '均衡营养',
      'description': '营养均衡，适合大多数健康人群的日常饮食',
    },
    {
      'key': 'hypertension',
      'name': '血压管理',
      'description': '低钠低脂，控制血压，适合高血压患者',
    },
    {
      'key': 'pregnancy',
      'name': '孕期营养',
      'description': '营养全面，补充叶酸和钙质，适合孕期女性',
    },
    {
      'key': 'lactation',
      'name': '哺乳期营养',
      'description': '营养充足，促进泌乳，适合哺乳期妈妈',
    },
    {
      'key': 'vegetarian',
      'name': '素食主义',
      'description': '纯植物性饮食，营养均衡，适合素食者',
    },
    {
      'key': 'elderly',
      'name': '老年养生',
      'description': '易消化，营养密度高，适合60岁以上老年人',
    },
    {
      'key': 'teenager',
      'name': '青少年成长',
      'description': '营养全面，促进生长发育，适合13-18岁青少年',
    },
    {
      'key': 'allergic',
      'name': '过敏体质',
      'description': '避开常见过敏原，安全健康，适合过敏体质人群',
    },
    {
      'key': 'gut_health',
      'name': '肠道健康',
      'description': '高纤维，益生菌，改善消化，适合肠道问题人群',
    },
    {
      'key': 'immune_boost',
      'name': '免疫增强',
      'description': '富含维生素C和抗氧化物，增强免疫力',
    },
    {
      'key': 'heart_health',
      'name': '心脏健康',
      'description': '低胆固醇，富含omega-3，保护心血管健康',
    },
    {
      'key': 'brain_health',
      'name': '健脑益智',
      'description': '富含DHA和磷脂，促进大脑发育，适合学生和脑力工作者',
    },
    {
      'key': 'menopause',
      'name': '更年期调理',
      'description': '补充钙质和植物雌激素，缓解更年期症状',
    },
  ];

  Future<void> _loadTemplatesWithFallback() async {
    // 立即使用预设模板，提供即时反馈
    setState(() {
      templates = _fallbackTemplates;
      isLoading = false;
    });

    // 检查缓存
    final cacheKey = 'templates';
    final cached = _templateCache[cacheKey];
    final timestamp = _cacheTimestamp[cacheKey];
    
    // 如果有缓存且未过期（30分钟），使用缓存数据
    if (cached != null && timestamp != null && 
        DateTime.now().difference(timestamp).inMinutes < 30) {
      if (mounted) {
        setState(() {
          templates = cached;
        });
      }
      return;
    }

    // 后台异步获取最新模板数据
    _loadTemplatesFromAPI();
  }

  Future<void> _loadTemplatesFromAPI() async {
    try {
      final apiService = ref.read(nutritionProfileExtendedApiServiceProvider);
      final templatesData = await apiService.getTemplates();
      
      // 更新缓存
      _templateCache['templates'] = templatesData;
      _cacheTimestamp['templates'] = DateTime.now();
      
      // 只有当获取到的数据与当前显示的不同时才更新UI
      if (mounted && templatesData.isNotEmpty && templatesData != templates) {
        setState(() {
          templates = templatesData;
        });
      }
    } catch (e) {
      // 静默失败，继续使用预设模板
      print('Failed to load templates from API: $e');
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
      onRetry: _loadTemplatesWithFallback,
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
    // 使用响应式布局，根据屏幕宽度调整列数
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 400) {
          crossAxisCount = 3;
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85, // 调整宽高比，给文字更多空间
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForTemplate(templateKey),
                  size: 32,
                  color: color,
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? color : null,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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