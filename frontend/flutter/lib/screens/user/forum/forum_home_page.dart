import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../models/forum/post.dart';
import 'forum_post_detail.dart';
import 'forum_new_post_page.dart';

/// 论坛首页
class ForumHomePage extends StatefulWidget {
  static const String routeName = '/forum';

  const ForumHomePage({Key? key}) : super(key: key);

  @override
  State<ForumHomePage> createState() => _ForumHomePageState();
}

class _ForumHomePageState extends State<ForumHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  ForumProvider? _forumProvider;
  
  final List<String> _tags = [
    '全部',
    '健康饮食',
    '营养知识',
    '菜品推荐',
    '减肥瘦身',
    '增肌健身',
    '疾病调理',
    '餐厅评价',
  ];
  
  String? _selectedTag;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forumProvider = Provider.of<ForumProvider>(context, listen: false);
  }
  
  @override
  void initState() {
    super.initState();
    
    // 监听滚动事件，实现上拉加载更多
    _scrollController.addListener(_scrollListener);
    
    // 首次加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forumProvider?.loadPosts();
    });
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    // 不在dispose中重置状态
    super.dispose();
  }
  
  @override
  void deactivate() {
    // 在deactivate中安全地重置状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _forumProvider?.resetState();
      }
    });
    super.deactivate();
  }
  
  // 滚动监听器
  void _scrollListener() {
    if (_isLoadingMore) return;
    
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }
  
  // 加载更多帖子
  Future<void> _loadMorePosts() async {
    if (!_forumProvider!.hasMorePosts || _forumProvider!.isLoading) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    await _forumProvider!.loadPosts();
    
    setState(() {
      _isLoadingMore = false;
    });
  }
  
  // 下拉刷新
  Future<void> _refreshPosts() async {
    await _forumProvider!.loadPosts(refresh: true);
  }
  
  // 创建新帖子
  void _navigateToNewPost() {
    Navigator.pushNamed(
      context, 
      ForumNewPostPage.routeName,
    ).then((_) {
      // 发布成功后刷新帖子列表
      _refreshPosts();
    });
  }
  
  // 筛选帖子标签
  void _filterByTag(String? tag) {
    setState(() {
      _selectedTag = tag == '全部' ? null : tag;
    });
    
    _forumProvider!.filterByTag(_selectedTag);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康交流论坛'),
        elevation: 0.5,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索功能
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 标签筛选栏
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, index) {
                final tag = _tags[index];
                final isSelected = (tag == '全部' && _selectedTag == null) || 
                                  tag == _selectedTag;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => _filterByTag(tag),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green.shade700 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 帖子列表
          Expanded(
            child: Consumer<ForumProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无帖子',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _navigateToNewPost,
                          child: const Text('发布第一个帖子'),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: _refreshPosts,
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: provider.posts.length + 1,
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == provider.posts.length) {
                        return _buildLoadMoreIndicator(provider);
                      }
                      
                      return _buildPostItem(provider.posts[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPost,
        child: const Icon(Icons.add),
        tooltip: '发布帖子',
      ),
    );
  }
  
  // 构建加载更多指示器
  Widget _buildLoadMoreIndicator(ForumProvider provider) {
    if (!provider.hasMorePosts) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
  
  // 构建帖子项
  Widget _buildPostItem(Post post) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ForumPostDetail.routeName,
          arguments: post.id,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 帖子标题
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            
            // 帖子内容预览
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // 帖子标签
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (post.tags.isNotEmpty)
              const SizedBox(height: 12),
            
            // 帖子底部信息（作者、时间、点赞、评论）
            Row(
              children: [
                // 作者头像
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade100,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                
                // 作者名称
                Expanded(
                  child: Text(
                    post.authorName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // 发布时间
                Text(
                  dateFormat.format(post.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                
                // 点赞数
                Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: post.isLiked ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.likeCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // 评论数
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.commentCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
