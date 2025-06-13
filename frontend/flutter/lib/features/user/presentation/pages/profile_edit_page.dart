import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ai_nutrition_restaurant/shared/utils/toast_util.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../../../../config/app_constants.dart';

/// 个人资料编辑页面
class ProfileEditPage extends ConsumerStatefulWidget {
  /// 构造函数
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  bool _isLoading = false;
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = ref.read(authStateProvider);
    final user = authState.user;
    if (user != null) {
      _nicknameController.text = user.nickname ?? '';
      // _bioController.text = user.bio ?? ''; // 假设用户模型有bio字段
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: Text(
              '保存',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 头像编辑区域
                  _buildAvatarSection(user),
                  const SizedBox(height: 32),
                  
                  // 个人信息表单
                  _buildInfoForm(),
                ],
              ),
            ),
            // 加载状态
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(dynamic user) {
    return Center(
      child: Stack(
        children: [
          // 头像
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: _selectedAvatarPath != null 
                ? FileImage(File(_selectedAvatarPath!)) as ImageProvider
                : _getAvatarImage(user),
            child: _selectedAvatarPath == null && _getAvatarImage(user) == null
                ? Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[600],
                  )
                : null,
          ),
          // 编辑按钮
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showAvatarOptions,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 昵称
        _buildFormField(
          label: '昵称',
          controller: _nicknameController,
          hint: '请输入昵称',
          maxLength: 20,
        ),
        const SizedBox(height: 20),
        
        // 个人简介
        _buildFormField(
          label: '简介',
          controller: _bioController,
          hint: '一句话介绍自己',
          maxLength: 100,
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        
        // 其他信息展示（只读）
        _buildReadOnlyInfo(),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyInfo() {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '账号信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('手机号', user?.phone ?? ''),
            _buildInfoRow('注册时间', '2024-01-01'), // 实际项目中从用户数据获取
            _buildInfoRow('用户ID', user?.id ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedAvatarPath != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('移除头像'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedAvatarPath = null;
                  });
                },
              ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('取消'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 400,
        maxHeight: 400,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedAvatarPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ToastUtil.showError(context, '选择图片失败');
      }
    }
  }

  Future<void> _handleSave() async {
    if (_nicknameController.text.trim().isEmpty) {
      ToastUtil.showError(context, '请输入昵称');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileManager = ref.read(profileManagerProvider.notifier);
      
      final update = ProfileUpdate(
        nickname: _nicknameController.text.trim(),
        bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        avatarFile: _selectedAvatarPath != null ? File(_selectedAvatarPath!) : null,
      );

      final success = await profileManager.updateProfile(update);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (success) {
          // 刷新用户信息
          ref.read(authStateProvider.notifier).refreshUserInfo();
          
          ToastUtil.showSuccess(context, '保存成功！');
          Navigator.pop(context);
        } else {
          ToastUtil.showError(context, '保存失败，请重试');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ToastUtil.showError(context, '保存失败: ${e.toString()}');
      }
    }
  }
  
  /// 获取头像图片
  ImageProvider? _getAvatarImage(dynamic user) {
    if (user == null) return null;
    
    // 优先使用displayAvatarUrl获取头像URL
    String? avatarUrl;
    if (user.runtimeType.toString().contains('UserModel')) {
      // 如果是UserModel类型，使用displayAvatarUrl
      avatarUrl = user.displayAvatarUrl;
    } else {
      // 其他情况，尝试获取avatarUrl或avatar
      avatarUrl = user.avatarUrl ?? user.avatar;
    }
    
    if (avatarUrl == null || avatarUrl.isEmpty) return null;
    
    // 如果是相对路径，添加服务器基础URL
    if (avatarUrl.startsWith('/')) {
      avatarUrl = '${AppConstants.serverBaseUrl}$avatarUrl';
    }
    
    return NetworkImage(avatarUrl);
  }
}