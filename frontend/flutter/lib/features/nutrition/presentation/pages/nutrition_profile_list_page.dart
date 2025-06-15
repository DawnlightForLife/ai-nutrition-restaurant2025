import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../widgets/nutrition_profile_card.dart';
import 'nutrition_profile_management_page.dart';
import 'nutrition_profile_wizard_page.dart';
import 'ai_recommendation_chat_page.dart';

class NutritionProfileListPage extends ConsumerStatefulWidget {
  const NutritionProfileListPage({super.key});

  @override
  ConsumerState<NutritionProfileListPage> createState() =>
      _NutritionProfileListPageState();
}

class _NutritionProfileListPageState
    extends ConsumerState<NutritionProfileListPage> {
  @override
  void initState() {
    super.initState();
    // 加载档案列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionProfileListProvider.notifier).loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileListState = ref.watch(nutritionProfileListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          '我的营养档案',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
            ),
          ),
        ),
      ),
      body: profileListState.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '正在加载您的营养档案...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : profileListState.error != null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.cloud_off_rounded,
                            size: 40,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '加载遇到问题',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '请检查网络连接后重试',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(nutritionProfileListProvider.notifier)
                                  .loadProfiles();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              '重新加载',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : profileListState.profiles.isEmpty
                  ? _buildEmptyState(context, theme)
                  : _buildProfileList(context, theme, profileListState.profiles),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI向导按钮
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: "wizard",
              onPressed: _createNewProfileWizard,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 快速创建按钮
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              heroTag: "create",
              onPressed: _createNewProfile,
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(
                Icons.flash_on,
                color: Colors.white,
              ),
              label: const Text(
                '快速创建',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 动态图标容器
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.1),
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '开始您的健康之旅',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '创建个性化营养档案，让AI为您\n定制专属的健康饮食方案',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // 特色功能卡片
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI智能向导',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '6步轻松创建专属档案',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 创建按钮组
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _createNewProfileWizard,
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                    label: const Text(
                      '智能向导创建',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _createNewProfile,
                    icon: const Icon(
                      Icons.flash_on,
                      color: Color(0xFF6366F1),
                    ),
                    label: const Text(
                      '快速创建',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF6366F1),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileList(
    BuildContext context,
    ThemeData theme,
    List<NutritionProfileV2> profiles,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(nutritionProfileListProvider.notifier).loadProfiles();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NutritionProfileCard(
              profile: profile,
              onTap: () => _openProfile(profile),
              onLongPress: () => _showProfileOptions(profile),
              onPinToggle: () => _togglePin(profile),
            ),
          );
        },
      ),
    );
  }

  void _createNewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionProfileManagementPage(
          profileId: null,
          isNewProfile: true,
        ),
      ),
    );
  }

  void _createNewProfileWizard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NutritionProfileWizardPage(),
      ),
    );
  }

  void _openProfile(NutritionProfileV2 profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionProfileManagementPage(
          profileId: profile.id,
          isNewProfile: false,
        ),
      ),
    );
  }

  void _showProfileOptions(NutritionProfileV2 profile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖动指示器
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 档案信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.folder,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.profileName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '完整度 ${profile.completionPercentage}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            // 操作选项
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑档案'),
              onTap: () {
                Navigator.pop(context);
                _openProfile(profile);
              },
            ),
            ListTile(
              leading: Icon(
                profile.isPrimary ? Icons.star : Icons.star_border,
                color: profile.isPrimary ? Colors.amber : null,
              ),
              title: Text(profile.isPrimary ? '取消置顶' : '置顶档案'),
              onTap: () {
                Navigator.pop(context);
                _togglePin(profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology_outlined),
              title: const Text('进入AI推荐'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAiRecommendation(profile);
              },
            ),
            if (ref.read(nutritionProfileListProvider).profiles.length > 1)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: const Text(
                  '删除档案',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(profile);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _togglePin(NutritionProfileV2 profile) {
    HapticFeedback.lightImpact();
    ref.read(nutritionProfileListProvider.notifier).togglePrimary(profile.id!);
  }

  void _navigateToAiRecommendation(NutritionProfileV2 profile) {
    // 设置当前档案为活动档案
    ref.read(nutritionProfileListProvider.notifier).setActiveProfile(profile);
    // 导航到AI推荐页面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AiRecommendationChatPage(),
      ),
    );
  }

  void _confirmDelete(NutritionProfileV2 profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除档案'),
        content: Text('确定要删除"${profile.profileName}"吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(nutritionProfileListProvider.notifier)
                  .deleteProfile(profile.id!);
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text('已删除"${profile.profileName}"'),
                  action: SnackBarAction(
                    label: '撤销',
                    onPressed: () {
                      // TODO: 实现撤销删除功能
                    },
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}