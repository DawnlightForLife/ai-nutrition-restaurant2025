import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 个人中心页面
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 跳转到设置页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息卡片
            const _UserInfoCard(),
            const SizedBox(height: 16),
            
            // 角色入口
            const _RoleEntriesSection(),
            const SizedBox(height: 16),
            
            // 功能菜单
            const _FunctionMenuSection(),
            const SizedBox(height: 16),
            
            // 其他设置
            const _SettingsSection(),
          ],
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户昵称',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '手机号: 138****1234',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 跳转到编辑资料页面
            },
          ),
        ],
      ),
    );
  }
}

class _RoleEntriesSection extends StatelessWidget {
  const _RoleEntriesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '角色入口',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // 这里根据用户角色动态显示
          _buildRoleEntry(
            context,
            icon: Icons.store,
            title: '商家管理',
            subtitle: '管理店铺、菜品、订单',
            onTap: () {
              // TODO: 跳转到商家管理
            },
          ),
          _buildRoleEntry(
            context,
            icon: Icons.psychology,
            title: '营养师工作台',
            subtitle: '提供专业营养咨询服务',
            onTap: () {
              // TODO: 跳转到营养师工作台
            },
          ),
          _buildRoleEntry(
            context,
            icon: Icons.work,
            title: '员工工作台',
            subtitle: '处理店铺日常运营工作',
            onTap: () {
              // TODO: 跳转到员工工作台
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleEntry(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _FunctionMenuSection extends StatelessWidget {
  const _FunctionMenuSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的功能',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.restaurant,
                  title: '我的营养档案',
                  onTap: () {
                    // TODO: 跳转到营养档案
                  },
                ),
                _buildMenuItem(
                  icon: Icons.recommend,
                  title: '我的推荐',
                  onTap: () {
                    // TODO: 跳转到推荐记录
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_cart,
                  title: '我的订单',
                  onTap: () {
                    // TODO: 跳转到订单列表
                  },
                ),
                _buildMenuItem(
                  icon: Icons.chat,
                  title: '咨询记录',
                  onTap: () {
                    // TODO: 跳转到咨询记录
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: '我的收藏',
                  onTap: () {
                    // TODO: 跳转到收藏列表
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '设置',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.help,
                  title: '客服与反馈',
                  onTap: () {
                    // TODO: 跳转到客服页面
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info,
                  title: '关于我们',
                  onTap: () {
                    // TODO: 跳转到关于我们
                  },
                ),
                _buildMenuItem(
                  icon: Icons.privacy_tip,
                  title: '隐私协议',
                  onTap: () {
                    // TODO: 跳转到隐私协议
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: '退出登录',
                  onTap: () {
                    // TODO: 退出登录逻辑
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}