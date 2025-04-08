import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../models/forum/comment.dart';
import '../../../models/forum/post.dart';

/// 论坛帖子详情页
///
/// 展示帖子的完整内容、评论列表，并支持发表评论、回复、点赞等交互功能
/// 使用Provider状态管理实现数据加载和UI更新
class ForumPostDetail extends StatefulWidget {
  /// 路由名称，用于导航
  static const String routeName = '/forum/post';
  
  /// 帖子ID，用于加载特定帖子的详情
  final String postId;
  
  /// 构造函数
  ///
  /// @param key Widget键值
  /// @param postId 要显示的帖子ID
  const ForumPostDetail({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<ForumPostDetail> createState() => _ForumPostDetailState();
}

/// 帖子详情页状态类
class _ForumPostDetailState extends State<ForumPostDetail> {
  /// 评论输入框控制器
  final TextEditingController _commentController = TextEditingController();
  
  /// 评论输入框焦点节点，用于控制键盘和输入焦点
  final FocusNode _commentFocusNode = FocusNode();
  
  /// 当前回复的评论ID，如果为null则表示直接评论帖子
  String? _replyToCommentId;
  
  /// 当前回复的用户名，用于在输入框上方显示"回复：xxx"
  String? _replyToUserName;
  
  @override
  void initState() {
    super.initState();
    
    // 在Widget完成首次布局后加载帖子详情
    // 使用addPostFrameCallback确保Provider上下文已准备好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ForumProvider>(context, listen: false).loadPostDetail(widget.postId);
    });
  }
  
  @override
  void dispose() {
    // 释放资源，避免内存泄漏
    _commentController.dispose();
    _commentFocusNode.dispose();
    // 重置Forum Provider的加载状态，避免影响其他页面
    Provider.of<ForumProvider>(context, listen: false).resetState();
    super.dispose();
  }
  
  /// 发送评论方法
  ///
  /// 获取评论内容并调用Provider的addComment方法提交到服务器
  /// 发送成功后清空输入框和回复状态
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return; // 防止发送空评论
    
    final provider = Provider.of<ForumProvider>(context, listen: false);
    
    // 调用Provider添加评论
    final comment = await provider.addComment(
      postId: widget.postId,
      content: text,
      parentId: _replyToCommentId, // 如果是回复其他评论，则传入父评论ID
    );
    
    // 评论成功后的处理
    if (comment != null) {
      _commentController.clear(); // 清空输入框
      _clearReplyState();        // 清除回复状态
      FocusScope.of(context).unfocus(); // 收起键盘
    }
  }
  
  /// 设置回复状态
  ///
  /// 记录要回复的评论ID和用户名，并聚焦到评论输入框
  /// 
  /// @param commentId 要回复的评论ID
  /// @param userName 要回复的用户名
  void _setReplyState(String commentId, String userName) {
    setState(() {
      _replyToCommentId = commentId;
      _replyToUserName = userName;
      _commentController.text = ''; // 清空当前输入
    });
    
    // 自动聚焦到评论框，弹出键盘
    _commentFocusNode.requestFocus();
  }
  
  /// 清除回复状态
  ///
  /// 取消回复模式，恢复为直接评论帖子的状态
  void _clearReplyState() {
    setState(() {
      _replyToCommentId = null;
      _replyToUserName = null;
    });
  }
  
  /// 点赞帖子
  ///
  /// 调用Provider的toggleLikePost方法切换帖子的点赞状态
  Future<void> _likePost() async {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    await provider.toggleLikePost(widget.postId);
  }
  
  /// 点赞评论
  ///
  /// 调用Provider的toggleLikeComment方法切换评论的点赞状态
  /// 
  /// @param commentId 要点赞的评论ID
  Future<void> _likeComment(String commentId) async {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    await provider.toggleLikeComment(
      postId: widget.postId,
      commentId: commentId,
    );
  }
  
  /// 删除评论
  ///
  /// 显示确认对话框，用户确认后调用Provider的deleteComment方法删除评论
  /// 
  /// @param commentId 要删除的评论ID
  Future<void> _deleteComment(String commentId) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条评论吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false; // 用户取消或点击外部区域时默认为false
    
    // 用户确认删除
    if (confirmed) {
      final provider = Provider.of<ForumProvider>(context, listen: false);
      await provider.deleteComment(
        postId: widget.postId,
        commentId: commentId,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 日期格式化器，用于显示帖子和评论的时间
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final dateFormatSimple = DateFormat('MM-dd HH:mm');
    
    // 获取当前登录用户的ID，用于判断评论是否可以删除（只能删除自己的评论）
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子详情'),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Consumer<ForumProvider>(
          builder: (context, provider, child) {
            final post = provider.currentPost;
            
            // 加载中状态
            if (provider.isLoading && post == null) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // 帖子不存在或已被删除
            if (post == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '帖子不存在或已被删除',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('返回'),
                    ),
                  ],
                ),
              );
            }
            
            // 正常显示帖子内容和评论
            return Column(
              children: [
                // 帖子内容部分（可滚动区域）
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // 帖子内容区域
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 帖子标题
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // 作者信息和发布时间
                              Row(
                                children: [
                                  // 作者头像（占位图标）
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue.shade100,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 作者名
                                      Text(
                                        post.authorName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // 发布时间
                                      Text(
                                        dateFormat.format(post.createdAt),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // 帖子正文内容
                              Text(
                                post.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // 帖子标签列表
                              if (post.tags.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: post.tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              
                              const SizedBox(height: 16),
                              
                              // 交互按钮区域（点赞、评论）
                              Row(
                                children: [
                                  // 点赞按钮
                                  InkWell(
                                    onTap: _likePost,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            post.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: post.isLiked ? Colors.red : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            post.likeCount.toString(),
                                            style: TextStyle(
                                              color: post.isLiked ? Colors.red : Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '点赞',
                                            style: TextStyle(
                                              color: post.isLiked ? Colors.red : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // 评论按钮
                                  InkWell(
                                    onTap: () {
                                      // 点击后聚焦到评论输入框
                                      _commentFocusNode.requestFocus();
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.chat_bubble_outline,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            post.commentCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '评论',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // 评论区域标题
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: Colors.grey.shade100,
                          child: Row(
                            children: [
                              const Text(
                                '全部评论',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${post.commentCount})',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // 评论列表区域
                      // 如果没有评论，显示空状态提示
                      provider.comments.isEmpty
                          ? SliverToBoxAdapter(
                              child: Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '暂无评论，来说两句吧',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          // 有评论时显示评论列表
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final comment = provider.comments[index];
                                  // 使用自定义评论项组件显示每条评论
                                  return _CommentItem(
                                    comment: comment,
                                    onReply: () => _setReplyState(comment.id, comment.authorName),
                                    onLike: () => _likeComment(comment.id),
                                    // 只有评论作者才能删除评论
                                    onDelete: currentUserId == comment.authorId
                                        ? () => _deleteComment(comment.id)
                                        : null,
                                    dateFormat: dateFormatSimple,
                                  );
                                },
                                childCount: provider.comments.length,
                              ),
                            ),
                    ],
                  ),
                ),
                
                // 底部评论输入区域
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 回复状态提示，仅在回复模式下显示
                      if (_replyToUserName != null) ...[
                        Row(
                          children: [
                            Text(
                              '回复: $_replyToUserName',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            // 取消回复按钮
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: _clearReplyState,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      // 评论输入框和发送按钮
                      Row(
                        children: [
                          // 评论输入框
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              focusNode: _commentFocusNode,
                              decoration: const InputDecoration(
                                hintText: '说点什么...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 3,
                              minLines: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 发送按钮
                          ElevatedButton(
                            // 正在提交评论时禁用按钮
                            onPressed: provider.isCommenting
                                ? null
                                : _submitComment,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              minimumSize: const Size(50, 46),
                            ),
                            // 加载状态显示进度指示器
                            child: provider.isCommenting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('发表'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 评论项组件
///
/// 用于显示单条评论，包括评论内容、作者信息、发布时间等
/// 支持点赞、回复、删除等交互操作
class _CommentItem extends StatelessWidget {
  /// 评论数据模型
  final Comment comment;
  
  /// 回复按钮点击回调
  final VoidCallback onReply;
  
  /// 点赞按钮点击回调
  final VoidCallback onLike;
  
  /// 删除按钮点击回调，如果为null则不显示删除按钮
  final VoidCallback? onDelete;
  
  /// 日期格式化器，用于格式化评论时间
  final DateFormat dateFormat;

  /// 构造函数
  ///
  /// @param key Widget键
  /// @param comment 评论数据
  /// @param onReply 回复回调
  /// @param onLike 点赞回调
  /// @param onDelete 删除回调，可选
  /// @param dateFormat 日期格式化器
  const _CommentItem({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.onLike,
    this.onDelete,
    required this.dateFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 评论者信息行
          Row(
            children: [
              // 评论者头像
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade100,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              // 评论者名称
              Text(
                comment.authorName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // 评论发布时间
              Text(
                dateFormat.format(comment.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // 评论内容
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // 评论底部操作栏
          Row(
            children: [
              // 点赞按钮
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(
                        comment.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: comment.isLiked ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likeCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: comment.isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 回复按钮
              InkWell(
                onTap: onReply,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    '回复',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // 删除按钮，仅当onDelete不为null时显示（即当前用户是评论作者）
              if (onDelete != null) ...[
                const SizedBox(width: 16),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '删除',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
