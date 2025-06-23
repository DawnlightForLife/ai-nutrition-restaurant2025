import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 营养师个人资料页面
/// 包含基本信息、认证状态、专业信息、收入统计等
class NutritionistProfilePage extends ConsumerStatefulWidget {
  final String nutritionistId;

  const NutritionistProfilePage({
    super.key,
    required this.nutritionistId,
  });

  @override
  ConsumerState<NutritionistProfilePage> createState() => _NutritionistProfilePageState();
}

class _NutritionistProfilePageState extends ConsumerState<NutritionistProfilePage>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: 刷新营养师数据
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 头像和基本信息
              _buildProfileHeader(user),
              
              const SizedBox(height: 24),
              
              // 认证状态卡片
              _buildCertificationCard(),
              
              const SizedBox(height: 16),
              
              // 专业信息卡片
              _buildProfessionalInfoCard(),
              
              const SizedBox(height: 16),
              
              // 收入统计卡片
              _buildIncomeStatsCard(),
              
              const SizedBox(height: 16),
              
              // 服务统计卡片
              _buildServiceStatsCard(),
              
              const SizedBox(height: 16),
              
              // 设置选项
              _buildSettingsSection(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 头像
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: user.avatar != null 
                      ? NetworkImage(user.avatar!) 
                      : null,
                  child: user.avatar == null 
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _changeAvatar(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 姓名和称号
            Text(
              user.name ?? '营养师',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              '国家注册营养师',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 认证徽章
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge('✓ 已认证', Colors.green),
                const SizedBox(width: 8),
                _buildBadge('专业级', Colors.blue),
                const SizedBox(width: 8),
                _buildBadge('5年经验', Colors.orange),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 编辑按钮
            ElevatedButton.icon(
              onPressed: () => _editProfile(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('编辑资料'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCertificationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified,
                  color: Colors.green[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '认证状态',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _viewCertification(),
                  child: const Text('查看详情'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildCertificationItem(
                    '认证等级',
                    '专业级',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildCertificationItem(
                    '有效期至',
                    '2026-12-31',
                    Icons.event,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildCertificationItem(
                    '专业领域',
                    '临床营养',
                    Icons.local_hospital,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildCertificationItem(
                    '执业编号',
                    'RD202***',
                    Icons.badge,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.work,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '专业信息',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _editProfessionalInfo(),
                  child: const Text('编辑'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoRow('毕业院校', '中国农业大学'),
            _buildInfoRow('专业', '食品科学与营养工程'),
            _buildInfoRow('学历', '硕士研究生'),
            _buildInfoRow('工作经验', '5年'),
            _buildInfoRow('擅长领域', '临床营养、运动营养、慢病管理'),
            
            const SizedBox(height: 12),
            
            const Text(
              '个人简介',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '具有5年临床营养经验，擅长慢性病营养管理和运动营养指导。曾在三甲医院营养科工作，为数千名患者提供专业营养咨询服务。',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '收入统计',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _viewIncomeDetail(),
                  child: const Text('查看详情'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('本月收入', '¥3,580', Colors.green),
                ),
                Expanded(
                  child: _buildStatItem('总收入', '¥28,960', Colors.blue),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('本月咨询', '42次', Colors.orange),
                ),
                Expanded(
                  child: _buildStatItem('好评率', '98%', Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '服务统计',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('累计客户', '286人', Colors.blue),
                ),
                Expanded(
                  child: _buildStatItem('回头客', '78%', Colors.green),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('平均评分', '4.9分', Colors.amber),
                ),
                Expanded(
                  child: _buildStatItem('响应时间', '2分钟', Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.account_circle,
            '账户设置',
            '修改密码、绑定手机等',
            () => _navigateToAccountSettings(),
          ),
          _buildSettingsItem(
            Icons.notifications,
            '通知设置',
            '消息提醒、系统通知',
            () => _navigateToNotificationSettings(),
          ),
          _buildSettingsItem(
            Icons.security,
            '隐私设置',
            '个人信息、数据安全',
            () => _navigateToPrivacySettings(),
          ),
          _buildSettingsItem(
            Icons.help,
            '帮助中心',
            '常见问题、联系客服',
            () => _navigateToHelp(),
          ),
          _buildSettingsItem(
            Icons.logout,
            '退出登录',
            '安全退出当前账户',
            () => _logout(),
            isLast: true,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isLast = false,
    Color? textColor,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: textColor),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }

  // 事件处理方法
  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现拍照功能
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现相册选择功能
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/profile/edit');
  }

  void _viewCertification() {
    Navigator.pushNamed(context, '/nutritionist/certification');
  }

  void _editProfessionalInfo() {
    Navigator.pushNamed(context, '/profile/professional/edit');
  }

  void _viewIncomeDetail() {
    Navigator.pushNamed(context, '/nutritionist/income');
  }

  void _navigateToAccountSettings() {
    Navigator.pushNamed(context, '/settings/account');
  }

  void _navigateToNotificationSettings() {
    Navigator.pushNamed(context, '/settings/notifications');
  }

  void _navigateToPrivacySettings() {
    Navigator.pushNamed(context, '/settings/privacy');
  }

  void _navigateToHelp() {
    Navigator.pushNamed(context, '/help');
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: 实现登出逻辑
      ref.read(authStateProvider.notifier).logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/auth/login',
          (route) => false,
        );
      }
    }
  }
}