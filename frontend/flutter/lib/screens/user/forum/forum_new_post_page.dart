import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../models/forum/post.dart';

/// 发布新帖子页面
class ForumNewPostPage extends StatefulWidget {
  static const String routeName = '/forum/new-post';

  const ForumNewPostPage({Key? key}) : super(key: key);

  @override
  State<ForumNewPostPage> createState() => _ForumNewPostPageState();
}

class _ForumNewPostPageState extends State<ForumNewPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final List<String> _selectedTags = [];
  
  final List<String> _availableTags = [
    '健康饮食',
    '营养知识',
    '菜品推荐',
    '减肥瘦身',
    '增肌健身',
    '疾病调理',
    '餐厅评价',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // 提交表单
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final provider = Provider.of<ForumProvider>(context, listen: false);
        final post = await provider.createPost(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _selectedTags,
        );

        if (post != null) {
          if (!mounted) return;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('帖子发布成功！'),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.pop(context, true);
        } else {
          if (!mounted) return;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          
          setState(() {
            _isSubmitting = false;
          });
        }
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发布失败: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // 处理标签选择
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
            // 标题输入
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '请输入标题（5-50字）',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().length < 5) {
                  return '标题至少需要5个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 内容输入
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '内容',
                hintText: '请输入正文内容（至少20字）',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 5000,
              maxLines: 15,
              minLines: 10,
              validator: (value) {
                if (value == null || value.trim().length < 20) {
                  return '内容至少需要20个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 标签选择
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTags.map((tag) {
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

            // 提交按钮
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
