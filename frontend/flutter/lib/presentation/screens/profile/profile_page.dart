import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme/yuanqi_colors.dart';
import '../../providers/auth_state_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: YuanqiColors.background,
      body: CustomScrollView(
        slivers: [
          // 顶部个人信息卡片
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: YuanqiColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              child: Column(
                children: [
                  // 头像
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: YuanqiColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 用户名
                  Text(
                    user?.username ?? '元气用户',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 手机号
                  Text(
                    user?.phone ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 角色标签
                  if (user?.role != null && user!.role != 'customer')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRoleLabel(user.role),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 功能列表
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 身份管理部分
                  if (_hasSpecialRole(user?.role))
                    _buildSection(
                      title: '身份管理',
                      children: [
                        if (user?.role == 'store_manager')
                          _buildMenuItem(
                            icon: Icons.store,
                            title: '店长工作台',
                            subtitle: '管理门店运营',
                            onTap: () {
                              // TODO(dev): 导航到店长工作台
                            },
                          ),
                        if (user?.role == 'store_staff')
                          _buildMenuItem(
                            icon: Icons.work,
                            title: '店员工作台',
                            subtitle: '处理订单和服务',
                            onTap: () {
                              // TODO(dev): 导航到店员工作台
                            },
                          ),
                        if (user?.role == 'nutritionist')
                          _buildMenuItem(
                            icon: Icons.medical_services,
                            title: '营养师工作台',
                            subtitle: '营养咨询和方案定制',
                            onTap: () {
                              // TODO(dev): 导航到营养师工作台
                            },
                          ),
                        if (user?.role == 'area_manager')
                          _buildMenuItem(
                            icon: Icons.business,
                            title: '区域经理工作台',
                            subtitle: '区域门店管理',
                            onTap: () {
                              // TODO(dev): 导航到区域经理工作台
                            },
                          ),
                      ],
                    ),

                  // 个人信息部分
                  _buildSection(
                    title: '个人信息',
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: '个人资料',
                        subtitle: '查看和编辑个人信息',
                        onTap: () {
                          // TODO(dev): 导航到个人资料页面
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite_outline,
                        title: '营养偏好',
                        subtitle: '设置饮食偏好和过敏原',
                        onTap: () {
                          // TODO(dev): 导航到营养偏好页面
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: '收货地址',
                        subtitle: '管理配送地址',
                        onTap: () {
                          // TODO(dev): 导航到地址管理页面
                        },
                      ),
                    ],
                  ),

                  // 服务与支持
                  _buildSection(
                    title: '服务与支持',
                    children: [
                      _buildMenuItem(
                        icon: Icons.card_membership,
                        title: '会员中心',
                        subtitle: '查看会员权益',
                        onTap: () {
                          // TODO(dev): 导航到会员中心
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: '帮助中心',
                        subtitle: '常见问题和使用指南',
                        onTap: () {
                          // TODO(dev): 导航到帮助中心
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.headset_mic_outlined,
                        title: '联系客服',
                        subtitle: '获取人工服务支持',
                        onTap: () {
                          // TODO(dev): 打开客服页面
                        },
                      ),
                    ],
                  ),

                  // 设置
                  _buildSection(
                    title: '设置',
                    children: [
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: '消息通知',
                        subtitle: '通知提醒设置',
                        onTap: () {
                          // TODO(dev): 导航到通知设置
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.security_outlined,
                        title: '账号与安全',
                        subtitle: '密码和隐私设置',
                        onTap: () {
                          // TODO(dev): 导航到安全设置
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: '关于元气立方',
                        subtitle: '版本 1.0.0',
                        onTap: () {
                          // TODO(dev): 显示关于页面
                        },
                      ),
                    ],
                  ),

                  // 退出登录按钮
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 显示确认对话框
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('退出登录'),
                            content: const Text('确定要退出登录吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: YuanqiColors.error,
                                ),
                                child: const Text('退出'),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          await ref.read(authStateProvider.notifier).logout();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YuanqiColors.error.withOpacity(0.1),
                        foregroundColor: YuanqiColors.error,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '退出登录',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: YuanqiColors.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: YuanqiColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: YuanqiColors.primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: YuanqiColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: YuanqiColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: YuanqiColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'customer':
        return '顾客';
      case 'store_manager':
        return '店长';
      case 'store_staff':
        return '店员';
      case 'nutritionist':
        return '营养师';
      case 'area_manager':
        return '区域经理';
      case 'admin':
        return '管理员';
      default:
        return role;
    }
  }

  bool _hasSpecialRole(String? role) {
    if (role == null) return false;
    const specialRoles = [
      'store_manager',
      'store_staff',
      'nutritionist',
      'area_manager',
      'admin'
    ];
    return specialRoles.contains(role);
  }
}