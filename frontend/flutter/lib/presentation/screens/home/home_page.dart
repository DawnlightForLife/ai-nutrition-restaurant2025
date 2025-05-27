import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../config/theme/yuanqi_colors.dart';
import '../../providers/auth_state_provider.dart';
import '../../providers/nutrition_profile_provider.dart';
import '../../../infrastructure/dtos/nutrition_profile_model.dart';
import '../profile/profile_page.dart';
import '../../../core/navigation/app_router.dart';
import '../nutrition/recommendation_entry_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': '首页'},
    {'icon': Icons.restaurant_menu, 'label': '点餐'},
    {'icon': Icons.smart_toy_outlined, 'label': '元气'},
    {'icon': Icons.receipt_long, 'label': '订单'},
    {'icon': Icons.person, 'label': '我的'},
  ];
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    return Scaffold(
      backgroundColor: YuanqiColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          _buildOrderPage(),
          _buildNutritionProfilePage(),
          _buildOrderListPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      // 如果点击的是元气AI（index=2），跳转到推荐入口页
                      if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecommendationEntryPage(),
                          ),
                        );
                      } else {
                        setState(() {
                          _selectedIndex = index;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 元气AI特殊图标
                          if (index == 2)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: isSelected 
                                    ? YuanqiColors.primaryGradient 
                                    : null,
                                color: !isSelected ? YuanqiColors.textHint : null,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          else
                            Icon(
                              item['icon'] as IconData,
                              color: isSelected 
                                  ? YuanqiColors.primaryOrange 
                                  : YuanqiColors.textHint,
                              size: 24,
                            ),
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected 
                                  ? YuanqiColors.primaryOrange 
                                  : YuanqiColors.textHint,
                              fontWeight: isSelected 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHomePage() {
    final user = ref.watch(authStateProvider).user;
    
    return CustomScrollView(
      slivers: [
        // 顶部应用栏
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: YuanqiColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '北京市朝阳区',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          // 身份切换按钮
                          _buildRoleSwitchButton(),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // TODO(dev): 通知页面
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_getGreeting()}, ${user?.displayName ?? '用户'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '今天想吃点什么？',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // 搜索框
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索健康美食',
                  hintStyle: const TextStyle(color: YuanqiColors.textHint),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: YuanqiColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onTap: () {
                  // TODO(dev): 搜索页面
                },
              ),
            ),
          ),
        ),
        
        // 功能入口
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _buildQuickActions(),
          ),
        ),
        
        // 推荐餐品
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '为您推荐',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: YuanqiColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO(dev): 查看更多
                      },
                      child: const Text(
                        '查看更多',
                        style: TextStyle(
                          color: YuanqiColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRecommendedDishes(),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.fitness_center, 'label': '健身餐', 'color': YuanqiColors.primaryOrange},
      {'icon': Icons.pregnant_woman, 'label': '孕产餐', 'color': YuanqiColors.secondaryGreen},
      {'icon': Icons.school, 'label': '学生餐', 'color': YuanqiColors.secondaryBlue},
      {'icon': Icons.healing, 'label': '养生餐', 'color': YuanqiColors.secondaryYellow},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: () {
            // TODO(dev): 分类页面
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: YuanqiColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildRecommendedDishes() {
    // 示例数据
    final dishes = [
      {
        'name': '轻食鸡胸肉沙拉',
        'calories': '320千卡',
        'price': '¥28',
        'image': '',
      },
      {
        'name': '营养牛肉便当',
        'calories': '480千卡',
        'price': '¥38',
        'image': '',
      },
    ];
    
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: YuanqiColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      color: YuanqiColors.textHint,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish['name']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: YuanqiColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dish['calories']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: YuanqiColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dish['price']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: YuanqiColors.primaryOrange,
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: YuanqiColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildOrderPage() {
    return const Center(
      child: Text('点餐页面'),
    );
  }
  
  Widget _buildNutritionProfilePage() {
    final user = ref.watch(authStateProvider).user;
    final nutritionState = ref.watch(nutritionProfileProvider);
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: YuanqiColors.primaryOrange,
          pinned: true,
          title: const Text(
            '营养档案',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                // TODO(dev): 营养档案帮助说明
              },
            ),
          ],
        ),
        
        // 档案完善状态
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: _buildProfileCompletionStatus(),
          ),
        ),
        
        // AI推荐区域（占位符）
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: _buildAIRecommendationPlaceholder(),
          ),
        ),
        
        // 营养档案表单
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: _buildNutritionProfileForm(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildOrderListPage() {
    return const Center(
      child: Text('订单页面'),
    );
  }
  
  Widget _buildRoleSwitchButton() {
    final user = ref.watch(authStateProvider).user;
    final currentRole = user?.role ?? 'customer';
    
    // 根据当前角色显示不同图标
    IconData roleIcon;
    String roleLabel;
    switch (currentRole) {
      case 'store_manager':
      case 'store_staff':
        roleIcon = Icons.store;
        roleLabel = '商家';
        break;
      case 'nutritionist':
        roleIcon = Icons.health_and_safety;
        roleLabel = '营养师';
        break;
      case 'admin':
      case 'area_manager':
        roleIcon = Icons.admin_panel_settings;
        roleLabel = '管理员';
        break;
      default:
        roleIcon = Icons.person;
        roleLabel = '顾客';
    }
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          _showRoleSwitchDialog();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(roleIcon, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                roleLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showRoleSwitchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择身份'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoleOption(Icons.person, '顾客', 'customer'),
            _buildRoleOption(Icons.store, '商家', 'store_manager'),
            _buildRoleOption(Icons.health_and_safety, '营养师', 'nutritionist'),
            _buildRoleOption(Icons.admin_panel_settings, '管理员', 'admin'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRoleOption(IconData icon, String label, String role) {
    final user = ref.watch(authStateProvider).user;
    final isCurrentRole = user?.role == role;
    
    return ListTile(
      leading: Icon(icon, color: isCurrentRole ? YuanqiColors.primaryOrange : YuanqiColors.textSecondary),
      title: Text(
        label,
        style: TextStyle(
          color: isCurrentRole ? YuanqiColors.primaryOrange : YuanqiColors.textPrimary,
          fontWeight: isCurrentRole ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isCurrentRole ? const Icon(Icons.check, color: YuanqiColors.primaryOrange) : null,
      onTap: () {
        Navigator.pop(context);
        // TODO(dev): 实现角色切换逻辑
        print('切换到角色: $role');
      },
    );
  }
  
  Widget _buildProfileCompletionStatus() {
    final nutritionState = ref.watch(nutritionProfileProvider);
    final completionPercentage = (nutritionState.completionStats?.completionPercentage ?? 0) / 100.0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, color: YuanqiColors.primaryOrange),
              const SizedBox(width: 8),
              const Text(
                '档案完成度',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: YuanqiColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${(completionPercentage * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: YuanqiColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: completionPercentage,
            backgroundColor: YuanqiColors.background,
            valueColor: const AlwaysStoppedAnimation<Color>(YuanqiColors.primaryOrange),
          ),
          const SizedBox(height: 8),
          const Text(
            '完善营养档案，获得更精准的AI营养建议',
            style: TextStyle(
              fontSize: 12,
              color: YuanqiColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAIRecommendationPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            YuanqiColors.secondaryBlue.withOpacity(0.1),
            YuanqiColors.secondaryGreen.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: YuanqiColors.secondaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: YuanqiColors.secondaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: YuanqiColors.secondaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI营养师',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: YuanqiColors.textPrimary,
                      ),
                    ),
                    Text(
                      '专业营养建议即将上线',
                      style: TextStyle(
                        fontSize: 12,
                        color: YuanqiColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🤖 我是您的专属AI营养师，正在为您准备个性化的营养建议和饮食方案。请完善您的营养档案，我将为您提供更精准的健康指导！',
              style: TextStyle(
                fontSize: 14,
                color: YuanqiColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNutritionProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '基础信息',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: YuanqiColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        // 基础身体数据
        _buildSectionCard(
          title: '身体数据',
          icon: Icons.straighten,
          items: [
            _buildFormField('身高', '请输入身高', '厘米'),
            _buildFormField('体重', '请输入体重', '公斤'),
            _buildFormField('年龄', '请输入年龄', '岁'),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 健康目标
        _buildSectionCard(
          title: '健康目标',
          icon: Icons.flag,
          items: [
            _buildDropdownField('健康目标', ['减重', '增肌', '维持体重', '改善体质']),
            _buildDropdownField('活动水平', ['久坐', '轻度活动', '中度活动', '高强度活动']),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 饮食偏好
        _buildSectionCard(
          title: '饮食偏好',
          icon: Icons.restaurant,
          items: [
            _buildMultiSelectField('饮食类型', ['素食', '半素食', '无特殊要求']),
            _buildMultiSelectField('口味偏好', ['清淡', '微辣', '中辣', '重辣', '甜食', '咸食']),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 过敏源信息
        _buildSectionCard(
          title: '过敏源信息',
          icon: Icons.warning,
          items: [
            _buildMultiSelectField('食物过敏', ['海鲜', '坚果', '鸡蛋', '牛奶', '面筋', '大豆']),
            _buildMultiSelectField('忌口食物', ['辛辣', '生冷', '油腻', '高糖']),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // 保存按钮
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _saveNutritionProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: YuanqiColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '保存营养档案',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: YuanqiColors.primaryOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: YuanqiColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }
  
  Widget _buildFormField(String label, String hint, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: YuanqiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              suffixText: unit,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.background),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.background),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.primaryOrange),
              ),
              filled: true,
              fillColor: YuanqiColors.background,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: YuanqiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.background),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.background),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: YuanqiColors.primaryOrange),
              ),
              filled: true,
              fillColor: YuanqiColors.background,
            ),
            hint: Text('请选择$label'),
            items: options.map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            )).toList(),
            onChanged: (value) {
              // TODO(dev): 处理选择
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMultiSelectField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: YuanqiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) => FilterChip(
              label: Text(option),
              onSelected: (selected) {
                // TODO(dev): 处理多选
              },
              backgroundColor: YuanqiColors.background,
              selectedColor: YuanqiColors.primaryOrange.withOpacity(0.2),
              checkmarkColor: YuanqiColors.primaryOrange,
            )).toList(),
          ),
        ],
      ),
    );
  }
  
  void _saveNutritionProfile() async {
    final user = ref.read(authStateProvider).user;
    final nutritionNotifier = ref.read(nutritionProfileProvider.notifier);
    final currentProfile = ref.read(nutritionProfileProvider).profile;
    
    if (user == null) return;
    
    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: YuanqiColors.primaryOrange,
        ),
      ),
    );
    
    try {
      // 创建或更新档案
      NutritionProfile profile;
      bool success;
      
      if (currentProfile == null) {
        // 创建新档案
        profile = NutritionProfile.createDefault(user.userId);
        success = await nutritionNotifier.createProfile(profile);
      } else {
        // 更新现有档案
        success = await nutritionNotifier.updateProfile(currentProfile);
      }
      
      // 关闭加载对话框
      if (mounted) {
        Navigator.pop(context);
      }
      
      if (success) {
        // 显示成功消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('营养档案保存成功'),
              backgroundColor: YuanqiColors.secondaryGreen,
            ),
          );
        }
      } else {
        // 显示错误消息
        final error = ref.read(nutritionProfileProvider).error;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? '保存失败'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 关闭加载对话框
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '早上好';
    } else if (hour < 18) {
      return '下午好';
    } else {
      return '晚上好';
    }
  }
}