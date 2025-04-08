import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/forum/forum_provider.dart';
import '../../../models/forum/post.dart';
import 'forum_post_detail.dart';
import 'forum_new_post_page.dart';

/// 论坛首页
///
/// 显示论坛帖子列表，支持分类筛选、下拉刷新、上拉加载更多等功能
/// 使用Provider状态管理实现数据加载和UI更新
class ForumHomePage extends StatefulWidget {
  /// 路由名称，用于导航
  static const String routeName = '/forum';

  /// 构造函数
  const ForumHomePage({Key? key}) : super(key: key);

  @override
  State<ForumHomePage> createState() => _ForumHomePageState();
}

/// 论坛首页状态类
class _ForumHomePageState extends State<ForumHomePage> {
  /// 滚动控制器，用于监听列表滚动事件和实现上拉加载更多
  final ScrollController _scrollController = ScrollController();
  
  /// 是否正在加载更多数据的标志
  bool _isLoadingMore = false;
  
  /// 论坛Provider实例，用于数据获取和状态管理
  ForumProvider? _forumProvider;
  
  /// 帖子分类标签列表
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
  
  /// 当前选中的标签，null表示选择"全部"
  String? _selectedTag;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取ForumProvider实例
    _forumProvider = Provider.of<ForumProvider>(context, listen: false);
  }
  
  @override
  void initState() {
    super.initState();
    
    // 监听滚动事件，实现上拉加载更多
    _scrollController.addListener(_scrollListener);
    
    // 首次加载数据，使用addPostFrameCallback确保在Widget构建完成后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forumProvider?.loadPosts();
    });
  }
  
  @override
  void dispose() {
    // 移除滚动监听并释放资源
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    // 不在dispose中重置状态，避免Provider状态异常
    super.dispose();
  }
  
  @override
  void deactivate() {
    // 在deactivate中安全地重置状态
    // 当页面被移出导航堆栈时，重置Provider状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _forumProvider?.resetState();
      }
    });
    super.deactivate();
  }
  
  /// 滚动监听器
  ///
  /// 监听列表滚动事件，当滚动到接近底部时触发加载更多
  void _scrollListener() {
    if (_isLoadingMore) return;
    
    // 当滚动位置接近底部时（还剩200像素）加载更多
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }
  
  /// 加载更多帖子
  ///
  /// 当列表滚动到底部时调用，加载下一页数据
  Future<void> _loadMorePosts() async {
    // 如果没有更多数据或正在加载中，则不执行操作
    if (!_forumProvider!.hasMorePosts || _forumProvider!.isLoading) return;
    
    // 设置加载状态
    setState(() {
      _isLoadingMore = true;
    });
    
    // 调用Provider加载更多帖子
    await _forumProvider!.loadPosts();
    
    // 恢复状态
    setState(() {
      _isLoadingMore = false;
    });
  }
  
  /// 下拉刷新
  ///
  /// 重新加载第一页帖子数据，用于RefreshIndicator
  Future<void> _refreshPosts() async {
    await _forumProvider!.loadPosts(refresh: true);
  }
  
  /// 创建新帖子
  ///
  /// 导航到发帖页面，返回后刷新列表
  void _navigateToNewPost() {
    Navigator.pushNamed(
      context, 
      ForumNewPostPage.routeName,
    ).then((_) {
      // 发布成功后刷新帖子列表
      _refreshPosts();
    });
  }
  
  /// 筛选帖子标签
  ///
  /// 根据选择的标签筛选帖子列表
  /// @param tag 选中的标签，如果是"全部"则传入null
  void _filterByTag(String? tag) {
    setState(() {
      _selectedTag = tag == '全部' ? null : tag;
    });
    
    // 调用Provider根据标签筛选帖子
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
          // 标签筛选栏，横向滚动显示所有标签
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
                // 判断当前标签是否选中
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
          
          // 帖子列表区域
          Expanded(
            child: Consumer<ForumProvider>(
              builder: (context, provider, child) {
                // 首次加载中显示加载指示器
                if (provider.isLoading && provider.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // 没有帖子时显示空状态
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
                
                // 正常显示帖子列表，支持下拉刷新
                return RefreshIndicator(
                  onRefresh: _refreshPosts,
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: provider.posts.length + 1, // 多一项用于显示加载更多
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // 最后一项显示加载更多指示器或底部
                      if (index == provider.posts.length) {
                        return _buildLoadMoreIndicator(provider);
                      }
                      
                      // 构建帖子项
                      return _buildPostItem(provider.posts[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // 悬浮发帖按钮
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewPost,
        child: const Icon(Icons.add),
        tooltip: '发布帖子',
      ),
    );
  }
  
  /// 构建加载更多指示器
  ///
  /// 在列表底部显示加载更多的进度指示器
  /// 如果没有更多数据则不显示
  /// @param provider ForumProvider实例
  /// @return 加载更多指示器组件
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
  
  /// 构建帖子项
  ///
  /// 显示单个帖子的卡片，包含标题、内容预览、作者信息等
  /// @param post 帖子数据模型
  /// @return 帖子卡片组件
  Widget _buildPostItem(Post post) {
    // 日期格式化器
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    return InkWell(
      onTap: () {
        // 点击帖子导航到详情页
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
            
            // 帖子内容预览，只显示前两行
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
            
            // 帖子标签横向滚动列表
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
            
            // 帖子底部信息栏（作者、时间、点赞、评论）
            Row(
              children: [
                // 作者头像占位
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
                
                // 点赞数指示器
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
                
                // 评论数指示器
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
