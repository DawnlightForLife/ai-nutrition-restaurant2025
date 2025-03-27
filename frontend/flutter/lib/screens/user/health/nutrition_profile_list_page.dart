import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../models/nutrition_profile.dart';
import 'nutrition_profile_form_page.dart';

class NutritionProfileListPage extends StatefulWidget {
  const NutritionProfileListPage({super.key});

  @override
  State<NutritionProfileListPage> createState() => _NutritionProfileListPageState();
}

class _NutritionProfileListPageState extends State<NutritionProfileListPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 使用 WidgetsBinding 确保在构建完成后加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfiles();
    });
  }

  Future<void> _loadProfiles() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn || userProvider.user == null || userProvider.user!.id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先登录后再查看营养档案')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    try {
      await nutritionProvider.fetchProfiles(userProvider.user!.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nutritionProvider = Provider.of<NutritionProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养档案管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/nutrition/profile/form').then((result) {
                if (result == true) {
                  _loadProfiles();
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfiles,
        child: _buildContent(userProvider, nutritionProvider),
      ),
    );
  }
  
  Widget _buildContent(UserProvider userProvider, NutritionProvider nutritionProvider) {
    // 未登录
    if (!userProvider.isLoggedIn) {
      return _buildLoginPrompt();
    }
    
    // 加载中
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // 加载出错
    if (nutritionProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              nutritionProvider.error!,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProfiles,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    
    // 档案为空
    if (nutritionProvider.profiles.isEmpty) {
      return _buildEmptyState();
    }
    
    // 显示档案列表
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nutritionProvider.profiles.length,
      itemBuilder: (context, index) {
        final profile = nutritionProvider.profiles[index];
        return _buildProfileCard(profile);
      },
    );
  }
  
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            '请先登录以查看营养档案',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_open,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            '您还没有创建营养档案',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '创建营养档案，获取个性化推荐',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/nutrition/profile/form').then((result) {
                if (result == true) {
                  _loadProfiles();
                }
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('创建第一个档案'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileCard(NutritionProfile profile) {
    // 计算BMI状态
    String bmiStatus = '';
    Color bmiColor = Colors.green;
    
    if (profile.bmi != null) {
      final bmi = profile.bmi!;
      if (bmi < 18.5) {
        bmiStatus = '偏瘦';
        bmiColor = Colors.blue;
      } else if (bmi < 24) {
        bmiStatus = '正常';
        bmiColor = Colors.green;
      } else if (bmi < 28) {
        bmiStatus = '超重';
        bmiColor = Colors.orange;
      } else {
        bmiStatus = '肥胖';
        bmiColor = Colors.red;
      }
    }
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // 传递当前档案到表单页面进行编辑
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NutritionProfileFormPage(profile: profile),
            ),
          ).then((result) {
            if (result == true) {
              _loadProfiles();
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '创建于 ${_formatDate(profile.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProfileInfoItem(
                    context,
                    icon: Icons.accessibility,
                    label: '身高',
                    value: profile.height != null ? '${profile.height}cm' : '未填',
                  ),
                  _buildProfileInfoItem(
                    context,
                    icon: Icons.monitor_weight,
                    label: '体重',
                    value: profile.weight != null ? '${profile.weight}kg' : '未填',
                  ),
                  _buildProfileInfoItem(
                    context,
                    icon: Icons.calendar_today,
                    label: '年龄',
                    value: profile.age != null ? '${profile.age}岁' : '未填',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (profile.bmi != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('BMI: '),
                      Text(
                        '${profile.bmi!.toStringAsFixed(1)} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                        ),
                      ),
                      Text(
                        '($bmiStatus)',
                        style: TextStyle(
                          fontSize: 12,
                          color: bmiColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 