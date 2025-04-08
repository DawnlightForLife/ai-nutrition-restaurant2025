import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../models/forum/post.dart';

/// 发布新帖子页面
///
/// 提供用户创建新帖子的表单界面，包含标题、内容和标签选择功能
/// 使用Provider状态管理实现数据提交和状态更新
class ForumNewPostPage extends StatefulWidget {
  /// 路由名称，用于导航
  static const String routeName = '/forum/new-post';

  /// 构造函数
  const ForumNewPostPage({Key? key}) : super(key: key);

  @override
  State<ForumNewPostPage> createState() => _ForumNewPostPageState();
}

/// 发布新帖子页面状态类
class _ForumNewPostPageState extends State<ForumNewPostPage> {
  /// 表单Key，用于表单验证
  final _formKey = GlobalKey<FormState>();
  
  /// 标题输入控制器
  final _titleController = TextEditingController();
  
  /// 内容输入控制器
  final _contentController = TextEditingController();
  
  /// 已选择的标签列表
  final List<String> _selectedTags = [];
  
  /// 可选择的标签列表
  final List<String> _availableTags = [
    '健康饮食',
    '营养知识',
    '菜品推荐',
    '减肥瘦身',
    '增肌健身',
    '疾病调理',
    '餐厅评价',
  ];

  /// 是否正在提交表单的标志
  bool _isSubmitting = false;

  @override
  void dispose() {
    // 释放控制器资源
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 提交表单
  ///
  /// 验证并提交新帖子数据，处理成功和失败的反馈
  Future<void> _submitForm() async {
    // 验证表单字段
    if (_formKey.currentState!.validate()) {
      // 设置提交状态，显示加载指示器
      setState(() {
        _isSubmitting = true;
      });

      try {
        // 获取ForumProvider并调用创建帖子方法
        final provider = Provider.of<ForumProvider>(context, listen: false);
        final post = await provider.createPost(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
        );

        // 处理创建结果
        if (post != null) {
          // 防止组件已卸载时调用setState
          if (!mounted) return;
          
          // 显示成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('帖子发布成功！'),
              backgroundColor: Colors.green,
            ),
          );
          
          // 返回上一页，并传递成功标志
          Navigator.pop(context, true);
        } else {
          // 防止组件已卸载时调用setState
          if (!mounted) return;
          
          // 显示错误提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          
          // 恢复状态，允许重新提交
          setState(() {
            _isSubmitting = false;
          });
        }
      } catch (e) {
        // 防止组件已卸载时调用setState
        if (!mounted) return;
        
        // 显示异常提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发布失败: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        
        // 恢复状态，允许重新提交
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// 处理标签选择
  ///
  /// 切换标签的选中状态，如果已选中则移除，否则添加
  /// @param tag 要切换的标签名称
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布帖子'),
        elevation: 0.5,
        actions: [
          // 顶部导航栏的发布按钮
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('发布'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 标题输入字段
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '请输入标题（5-50字）',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 50, // 限制最大长度
              validator: (value) {
                // 验证标题长度
                if (value == null || value.trim().length < 5) {
                  return '标题至少需要5个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 内容输入字段，多行文本框
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '内容',
                hintText: '请输入正文内容（至少20字）',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 5000, // 限制最大长度
              maxLines: 15, // 最大行数
              minLines: 10, // 最小行数
              validator: (value) {
                // 验证内容长度
                if (value == null || value.trim().length < 20) {
                  return '内容至少需要20个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 标签选择区域
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '标签（可选）',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // 标签选择芯片组
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
                    // 检查标签是否已选中
                    final isSelected = _selectedTags.contains(tag);
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => _toggleTag(tag),
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.green.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.green.shade700 : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                // 显示已选标签数量
                if (_selectedTags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '已选择 ${_selectedTags.length} 个标签',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),

            // 底部提交按钮
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      '发布帖子',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
