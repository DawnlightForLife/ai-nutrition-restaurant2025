import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common/loading_overlay.dart';
import '../../../models/health/nutrition_profile_model.dart';
import '../../../providers/health/health_profile_provider.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../widgets/common/error_message.dart';
import '../../../widgets/common/loading_indicator.dart';
import 'health_form_page.dart';

class HealthProfilesPage extends StatefulWidget {
  static const routeName = '/health-profiles';

  const HealthProfilesPage({Key? key}) : super(key: key);

  @override
  State<HealthProfilesPage> createState() => _HealthProfilesPageState();
}

class _HealthProfilesPageState extends State<HealthProfilesPage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadProfiles());
  }
  
  Future<void> _loadProfiles() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final provider = Provider.of<HealthProfileProvider>(context, listen: false);
      debugPrint('开始获取健康档案列表...');
      await provider.fetchProfiles();
      debugPrint('健康档案列表获取成功，档案数量: ${provider.profiles.length}');
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      debugPrint('加载档案列表时发生错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养档案管理'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<HealthProfileProvider>(
      builder: (context, provider, child) {
        if (_errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Exception: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadProfiles,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        if (provider.profiles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('您还没有创建营养档案'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _navigateToForm(context),
                  child: const Text('创建营养档案'),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: _loadProfiles,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.profiles.length,
            itemBuilder: (context, index) {
              final profile = provider.profiles[index];
              return _buildProfileCard(context, profile, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context, 
    NutritionProfile profile,
    HealthProfileProvider provider,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: profile.isPrimary ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: profile.isPrimary 
            ? BorderSide(color: theme.colorScheme.primary, width: 2) 
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _navigateToForm(context, profile: profile, viewOnly: true),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            if (profile.isPrimary)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  '主要档案',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        radius: 24,
                        child: Text(
                          profile.profileName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.profileName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '创建于 ${profile.formattedCreationDate()}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.accessibility_new,
                        label: '${profile.height.toInt()} cm',
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.monitor_weight_outlined,
                        label: '${profile.weight.toInt()} kg',
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.speed,
                        label: 'BMI: ${profile.calculateBMI().toStringAsFixed(1)}',
                        color: _getBmiColor(profile.calculateBMI(), theme),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHealthTags(profile, theme),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('编辑'),
                        onPressed: () => _navigateToForm(context, profile: profile),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('删除'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () => _confirmDelete(context, profile, provider),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 获取BMI颜色指示
  Color _getBmiColor(double bmi, ThemeData theme) {
    if (bmi < 18.5) {
      return Colors.blue; // 偏瘦
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return theme.colorScheme.primary; // 正常
    } else if (bmi >= 25 && bmi < 29.9) {
      return Colors.orange; // 超重
    } else {
      return Colors.red; // 肥胖
    }
  }
  
  // 构建信息芯片
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建健康标签
  Widget _buildHealthTags(NutritionProfile profile, ThemeData theme) {
    final healthGoals = profile.nutritionGoalsText;
    
    if (healthGoals.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: healthGoals.map((goal) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            goal,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // 导航到表单页面
  Future<void> _navigateToForm(BuildContext context, {NutritionProfile? profile, bool viewOnly = false}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthFormPage(
          profile: profile,
          viewOnly: viewOnly,
        ),
      ),
    );
    
    if (result == true) {
      _loadProfiles();
    }
  }

  void _confirmDelete(
    BuildContext context, 
    NutritionProfile profile, 
    HealthProfileProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 ${profile.profileName} 的健康档案吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() {
                _isLoading = true;
              });
              
              try {
                final success = await provider.deleteProfile(profile.id);
                
                setState(() {
                  _isLoading = false;
                });
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('健康档案已删除'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('删除失败: ${provider.errorMessage ?? "未知错误"}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                setState(() {
                  _isLoading = false;
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('删除失败: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
