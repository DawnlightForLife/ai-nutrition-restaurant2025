import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../widgets/nutrition_profile_card.dart';
import 'nutrition_profile_management_page.dart';
import 'ai_recommendation_chat_page.dart';

@RoutePage()
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
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('营养档案'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: profileListState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileListState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '加载失败',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profileListState.error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(nutritionProfileListProvider.notifier)
                              .loadProfiles();
                        },
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : profileListState.profiles.isEmpty
                  ? _buildEmptyState(context, theme)
                  : _buildProfileList(context, theme, profileListState.profiles),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewProfile,
        icon: const Icon(Icons.add),
        label: const Text('创建档案'),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 120,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 24),
            Text(
              '还没有营养档案',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '创建您的第一个营养档案，获得个性化的健康推荐',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _createNewProfile,
              icon: const Icon(Icons.add),
              label: const Text('创建档案'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 48),
              ),
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