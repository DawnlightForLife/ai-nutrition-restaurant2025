import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../widgets/nutrition_profile_card.dart';
import '../widgets/nutrition_cube_progress_card.dart';
import '../widgets/profile_search_bar.dart';
import '../widgets/quick_filter_tags.dart';
import '../widgets/advanced_filter_dialog.dart';
import '../widgets/export_config_dialog.dart';
import '../widgets/export_progress_dialog.dart';
import '../widgets/nutrition_chart_widget.dart';
import '../providers/nutrition_progress_provider.dart';
import '../providers/search_filter_provider.dart';
import '../providers/data_export_provider.dart';
import '../services/user_feedback_service.dart';
import '../../domain/services/error_handling_service.dart';
import '../../domain/models/export_config_model.dart';
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
    final filteredProfiles = ref.watch(filteredProfilesProvider);

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
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          // 批量导出按钮
          if (filteredProfiles.isNotEmpty)
            IconButton(
              onPressed: _showBatchExportDialog,
              icon: const Icon(Icons.download),
              tooltip: '批量导出',
            ),
        ],
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
              ? _buildErrorState(context, theme, profileListState)
              : profileListState.profiles.isEmpty
                  ? _buildEmptyState(context, theme)
                  : filteredProfiles.isEmpty && profileListState.profiles.isNotEmpty
                      ? _buildNoResultsState(context, theme)
                      : _buildProfileList(context, theme, profileListState.profiles, filteredProfiles),
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
    List<NutritionProfileV2> filteredProfiles,
  ) {
    // 找到主要档案或第一个档案用于显示营养立方进度
    final primaryProfile = profiles.firstWhere(
      (p) => p.isPrimary,
      orElse: () => profiles.first,
    );

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(nutritionProfileListProvider.notifier).loadProfiles();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredProfiles.length + 3, // +3 for progress card, search bar, and filter tags
        itemBuilder: (context, index) {
          // 第一个位置显示营养立方进度卡片
          if (index == 0) {
            return Column(
              children: [
                NutritionCubeProgressCard(
                  profile: primaryProfile,
                  onTap: () => _showProgressDetails(primaryProfile),
                ),
                const SizedBox(height: 16),
              ],
            );
          }
          
          // 第二个位置显示搜索栏
          if (index == 1) {
            return Column(
              children: [
                ProfileSearchBar(
                  onAdvancedFilter: _showAdvancedFilter,
                ),
                const SizedBox(height: 12),
              ],
            );
          }
          
          // 第三个位置显示快速筛选标签和统计信息
          if (index == 2) {
            return Column(
              children: [
                QuickFilterTags(),
                const SizedBox(height: 8),
                // 分割线和档案标题
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '我的档案 (${filteredProfiles.length})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
              ],
            );
          }
          
          // 档案列表（index-3因为前面有3个固定项目）
          final profile = filteredProfiles[index - 3];
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
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('克隆档案'),
              onTap: () {
                Navigator.pop(context);
                _cloneProfile(profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('导出档案'),
              onTap: () {
                Navigator.pop(context);
                _exportProfile(profile);
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
        builder: (context) => AiRecommendationChatPage(profileId: profile.id!),
      ),
    );
  }

  void _cloneProfile(NutritionProfileV2 profile) {
    // 显示克隆选项对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('克隆档案'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('要克隆档案"${profile.profileName}"吗？'),
            const SizedBox(height: 8),
            const Text(
              '克隆的档案将包含所有当前设置，您可以在新档案中进行调整。',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCloneOptions(profile);
            },
            child: const Text('克隆'),
          ),
        ],
      ),
    );
  }

  void _showCloneOptions(NutritionProfileV2 profile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖动指示器
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题
            Text(
              '选择克隆方式',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // 选项1：快速克隆
            _buildCloneOption(
              context,
              icon: Icons.flash_on,
              title: '快速克隆',
              subtitle: '直接创建副本，自动添加"副本"后缀',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                _performQuickClone(profile);
              },
            ),
            
            const SizedBox(height: 12),
            
            // 选项2：智能克隆
            _buildCloneOption(
              context,
              icon: Icons.auto_awesome,
              title: '智能克隆',
              subtitle: '使用向导模式，可以调整克隆的内容',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                _performSmartClone(profile);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloneOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performQuickClone(NutritionProfileV2 profile) async {
    try {
      // 显示加载对话框
      UserFeedbackService.showLoadingDialog(
        context,
        message: '正在克隆档案...',
      );

      // 执行快速克隆
      final clonedProfile = await ref.read(nutritionProfileListProvider.notifier).cloneProfile(
        profile.id!,
        newName: '${profile.profileName} 副本',
        cloneMode: 'quick',
      );

      // 给用户奖励能量点数 - 克隆档案 (源档案获得奖励)
      if (clonedProfile?.id != null) {
        await ref.read(nutritionProgressProvider.notifier).addEnergyPoints(
          profile.id!, // 给源档案用户奖励
          30, // 克隆档案奖励
          activityType: 'profile_clone',
          description: '克隆档案',
        );
      }

      // 关闭加载对话框
      UserFeedbackService.hideLoadingDialog(context);

      // 显示成功消息
      UserFeedbackService.showSuccess(
        context,
        '档案克隆成功！🎉 获得 30 能量点奖励',
      );
    } catch (e) {
      // 关闭加载对话框
      UserFeedbackService.hideLoadingDialog(context);
      
      // 显示错误消息
      UserFeedbackService.showError(
        context,
        e,
        actionLabel: '重试',
        action: () => _performQuickClone(profile),
      );
    }
  }

  void _performSmartClone(NutritionProfileV2 profile) {
    // 导航到向导页面，传入克隆的档案
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionProfileWizardPage(
          cloneFromProfile: profile,
        ),
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

  void _showProgressDetails(NutritionProfileV2 profile) {
    final stats = ref.read(nutritionProfileStatsProvider(profile));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 拖拽指示器
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // 标题
              Row(
                children: [
                  Icon(
                    Icons.view_in_ar,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '营养立方详情',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profile.profileName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 营养数据图表
              NutritionChartWidget(profile: profile),
              
              const SizedBox(height: 16),
              
              // 详细统计
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailCard(
                      context,
                      title: '能量等级',
                      subtitle: stats['energyLevelName'] as String,
                      value: '${stats['totalEnergyPoints']} 能量点',
                      progress: stats['energyLevelProgress'] as double,
                      icon: Icons.auto_awesome,
                      color: Colors.amber,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildDetailCard(
                      context,
                      title: '坚持记录',
                      subtitle: '${_getStreakLevelName(stats['currentStreak'] as int)} · 连续${stats['currentStreak']}天',
                      value: '最佳记录 ${stats['bestStreak']} 天',
                      progress: (stats['currentStreak'] as int) / ((stats['bestStreak'] as int) + 1),
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildDetailCard(
                      context,
                      title: '活跃状态',
                      subtitle: (stats['isStreakActive'] as bool) ? '活跃用户' : '需要激活',
                      value: profile.lastActiveDate != null 
                          ? '最后活跃：${_formatLastActive(profile.lastActiveDate!)}'
                          : '从未活跃',
                      progress: (stats['isStreakActive'] as bool) ? 1.0 : 0.0,
                      icon: Icons.trending_up,
                      color: (stats['isStreakActive'] as bool) ? Colors.green : Colors.grey,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 激励文案
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stats['motivationalMessage'] as String,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
    required double progress,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 进度条
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastActive(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '刚刚';
      }
      return '${diff.inHours}小时前';
    } else if (diff.inDays == 1) {
      return '昨天';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  String _getStreakLevelName(int streak) {
    if (streak >= 30) return '大师级';
    if (streak >= 14) return '专家级';
    if (streak >= 7) return '进阶级';
    if (streak >= 3) return '入门级';
    return '新手';
  }

  String _getMotivationalText(NutritionProfileV2 profile) {
    if (profile.totalEnergyPoints == 0) {
      return '🌟 开始你的营养立方之旅吧！每一次健康选择都会为你的立方充能！';
    }
    
    if (profile.currentStreak == 0) {
      return '💪 重新开始永远不晚！今天就开始新的连续记录吧！';
    }
    
    if (profile.currentStreak < 7) {
      return '🔥 保持下去！你已经坚持了${profile.currentStreak}天，一周目标在望！';
    }
    
    if (profile.currentStreak < 21) {
      return '⭐ 了不起！${profile.currentStreak}天的坚持让你离习惯养成更近了一步！';
    }
    
    if (profile.currentStreak < 50) {
      return '🏆 你是真正的营养冠军！${profile.currentStreak}天的坚持值得骄傲！';
    }
    
    return '👑 营养大师！${profile.currentStreak}天的坚持已经成为传奇！继续保持这份毅力！';
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    NutritionProfileListState state,
  ) {
    final errorType = NutritionErrorHandlingService.getErrorType(state.error);
    final retryAdvice = NutritionErrorHandlingService.getRetryAdvice(state.error);
    
    return Center(
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
            // 错误图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getErrorColor(errorType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                _getErrorIcon(errorType),
                size: 40,
                color: _getErrorColor(errorType),
              ),
            ),
            const SizedBox(height: 24),
            
            // 错误标题
            Text(
              _getErrorTitle(errorType),
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            // 错误消息
            Text(
              state.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            
            // 重试信息
            if (state.retryAttempts > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '已重试 ${state.retryAttempts} 次',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // 操作按钮
            Row(
              children: [
                if (state.canRetry) ...[
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(nutritionProfileListProvider.notifier).retryLoadProfiles();
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text(
                          '重试',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      UserFeedbackService.showInfo(
                        context,
                        retryAdvice,
                        actionLabel: '了解',
                      );
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('帮助'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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

  Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.blue;
      case ErrorType.permission:
        return Colors.orange;
      case ErrorType.validation:
        return Colors.purple;
      case ErrorType.storage:
        return Colors.brown;
      case ErrorType.general:
      case ErrorType.unknown:
        return Colors.red;
    }
  }

  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.permission:
        return Icons.lock;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.storage:
        return Icons.storage;
      case ErrorType.general:
      case ErrorType.unknown:
        return Icons.error;
    }
  }

  String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return '网络连接问题';
      case ErrorType.permission:
        return '权限不足';
      case ErrorType.validation:
        return '数据验证错误';
      case ErrorType.storage:
        return '存储空间不足';
      case ErrorType.general:
      case ErrorType.unknown:
        return '加载遇到问题';
    }
  }

  /// 导出单个档案
  Future<void> _exportProfile(NutritionProfileV2 profile) async {
    final config = await showDialog<ExportConfig>(
      context: context,
      builder: (context) => ExportConfigDialog(
        isMultiProfile: false,
        profileCount: 1,
      ),
    );

    if (config != null) {
      // 显示进度对话框
      ExportProgressDialog.show(
        context,
        onCompleted: () {
          // 添加到导出历史
          final result = ref.read(dataExportProvider).lastResult;
          if (result != null) {
            addExportToHistory(ref, result);
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('档案「${profile.profileName}」导出成功！'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onCancelled: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('导出已取消'),
            ),
          );
        },
      );

      // 执行导出
      await ref.read(dataExportProvider.notifier).exportProfile(profile, config);
    }
  }

  /// 显示批量导出对话框
  Future<void> _showBatchExportDialog() async {
    final filteredProfiles = ref.read(filteredProfilesProvider);
    final config = await showDialog<ExportConfig>(
      context: context,
      builder: (context) => ExportConfigDialog(
        isMultiProfile: true,
        profileCount: filteredProfiles.length,
      ),
    );

    if (config != null) {
      _performBatchExport(config);
    }
  }

  /// 执行批量导出
  Future<void> _performBatchExport(ExportConfig config) async {
    final filteredProfiles = ref.read(filteredProfilesProvider);
    
    // 显示进度对话框
    ExportProgressDialog.show(
      context,
      onCompleted: () {
        // 添加到导出历史
        final result = ref.read(dataExportProvider).lastResult;
        if (result != null) {
          addExportToHistory(ref, result);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('成功导出 ${filteredProfiles.length} 个档案！'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onCancelled: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('批量导出已取消'),
          ),
        );
      },
    );

    // 执行批量导出
    await ref.read(dataExportProvider.notifier).exportProfiles(filteredProfiles, config);
  }

  void _showAdvancedFilter() {
    showDialog(
      context: context,
      builder: (context) => const AdvancedFilterDialog(),
    );
  }

  Widget _buildNoResultsState(BuildContext context, ThemeData theme) {
    final searchFilter = ref.watch(searchFilterProvider);
    final hasActiveFilters = searchFilter.searchQuery.isNotEmpty || 
                           searchFilter.hasActiveFilters;
    
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300]!.withOpacity(0.5),
                    Colors.grey[400]!.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                hasActiveFilters ? Icons.search_off : Icons.folder_open,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // 标题
            Text(
              hasActiveFilters ? '未找到匹配的档案' : '没有档案',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // 描述
            Text(
              hasActiveFilters 
                  ? '请尝试调整搜索条件或清除筛选器' 
                  : '您还没有创建任何营养档案',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // 操作按钮
            if (hasActiveFilters)
              Container(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(searchFilterProvider.notifier).clearAll();
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('清除所有筛选'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _createNewProfileWizard,
                      icon: const Icon(Icons.auto_awesome, color: Colors.white),
                      label: const Text(
                        '智能向导创建',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 48,
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
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
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
}