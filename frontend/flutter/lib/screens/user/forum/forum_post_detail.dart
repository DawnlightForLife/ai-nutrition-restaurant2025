import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../models/forum/comment.dart';
import '../../../models/forum/post.dart';

/// 论坛帖子详情页
class ForumPostDetail extends StatefulWidget {
  static const String routeName = '/forum/post';
  
  final String postId;
  
  const ForumPostDetail({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<ForumPostDetail> createState() => _ForumPostDetailState();
}

class _ForumPostDetailState extends State<ForumPostDetail> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _replyToCommentId;
  String? _replyToUserName;
  
  @override
  void initState() {
    super.initState();
    
    // 加载帖子详情
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ForumProvider>(context, listen: false).loadPostDetail(widget.postId);
    });
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    // 重置加载状态
    Provider.of<ForumProvider>(context, listen: false).resetState();
    super.dispose();
  }
  
  // 发送评论
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    
    final provider = Provider.of<ForumProvider>(context, listen: false);
    
    final comment = await provider.addComment(
      postId: widget.postId,
      content: text,
      parentId: _replyToCommentId,
    );
    
    if (comment != null) {
      _commentController.clear();
      _clearReplyState();
      FocusScope.of(context).unfocus();
    }
  }
  
  // 设置回复状态
  void _setReplyState(String commentId, String userName) {
    setState(() {
      _replyToCommentId = commentId;
      _replyToUserName = userName;
      _commentController.text = '';
    });
    
    _commentFocusNode.requestFocus();
  }
  
  // 清除回复状态
  void _clearReplyState() {
    setState(() {
      _replyToCommentId = null;
      _replyToUserName = null;
    });
  }
  
  // 点赞帖子
  Future<void> _likePost() async {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    await provider.toggleLikePost(widget.postId);
  }
  
  // 点赞评论
  Future<void> _likeComment(String commentId) async {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    await provider.toggleLikeComment(
      postId: widget.postId,
      commentId: commentId,
    );
  }
  
  // 删除评论
  Future<void> _deleteComment(String commentId) async {
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
    ) ?? false;
    
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
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final dateFormatSimple = DateFormat('MM-dd HH:mm');
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
            
            if (provider.isLoading && post == null) {
              return const Center(child: CircularProgressIndicator());
            }
            
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
            
            return Column(
              children: [
                // 帖子内容
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // 帖子内容
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
                                  // 作者头像
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
                                      Text(
                                        post.authorName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                              
                              // 帖子内容
                              Text(
                                post.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // 帖子标签
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
                              
                              // 点赞按钮
                              Row(
                                children: [
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
                                  
                                  InkWell(
                                    onTap: () {
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
                      
                      // 评论分割线
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
                      
                      // 评论列表
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
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final comment = provider.comments[index];
                                  return _CommentItem(
                                    comment: comment,
                                    onReply: () => _setReplyState(comment.id, comment.authorName),
                                    onLike: () => _likeComment(comment.id),
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
                
                // 评论输入框
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
                      Row(
                        children: [
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
                          ElevatedButton(
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
class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final DateFormat dateFormat;

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
          // 作者信息
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
              Text(
                comment.authorName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
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
          
          // 操作按钮
          Row(
            children: [
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
