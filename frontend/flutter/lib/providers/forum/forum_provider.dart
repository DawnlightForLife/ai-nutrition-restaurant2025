import 'package:flutter/material.dart';
import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../../repositories/forum/forum_repository.dart';

/// 论坛状态管理提供者
/// 
/// 负责处理所有论坛相关的数据操作，包括获取、创建、更新和删除帖子及评论。
/// 使用ChangeNotifier通知监听者状态变化。
class ForumProvider with ChangeNotifier {
  /// 数据仓库实例，用于处理数据操作
  ForumRepository? _repository;
  
  // 状态数据
  /// 当前加载的论坛帖子列表
  List<Post> _posts = [];
  
  /// 当前选中的帖子（用于详情查看）
  Post? _currentPost;
  
  /// 当前选中帖子的评论列表
  List<Comment> _comments = [];
  
  /// 标志是否正在加载数据
  bool _isLoading = false;
  
  /// 标志是否正在创建或更新帖子
  bool _isCreating = false;
  
  /// 标志是否正在创建评论
  bool _isCommenting = false;
  
  /// 标志是否发生错误
  bool _hasError = false;
  
  /// 发生错误时显示的错误信息
  String _errorMessage = '';
  
  /// 分页当前页码
  int _currentPage = 1;
  
  /// 分页总页数
  int _totalPages = 1;
  
  /// 标志是否还有更多帖子可加载
  bool _hasMorePosts = true;
  
  /// 当前选中的过滤标签
  String? _selectedTag;

  // 状态数据的getter方法
  /// 返回已加载的帖子列表
  List<Post> get posts => _posts;
  
  /// 返回当前选中的帖子
  Post? get currentPost => _currentPost;
  
  /// 返回当前帖子的评论列表
  List<Comment> get comments => _comments;
  
  /// 返回是否正在加载数据
  bool get isLoading => _isLoading;
  
  /// 返回是否正在创建或更新帖子
  bool get isCreating => _isCreating;
  
  /// 返回是否正在创建评论
  bool get isCommenting => _isCommenting;
  
  /// 返回是否发生错误
  bool get hasError => _hasError;
  
  /// 返回当前错误信息（如果有）
  String get errorMessage => _errorMessage;
  
  /// 返回分页当前页码
  int get currentPage => _currentPage;
  
  /// 返回分页总页数
  int get totalPages => _totalPages;
  
  /// 返回是否还有更多帖子可加载
  bool get hasMorePosts => _hasMorePosts;
  
  /// 返回当前选中的过滤标签
  String? get selectedTag => _selectedTag;

  /// 构造函数，接收ForumRepository实例
  /// 
  /// @param repository 用于数据操作的仓库实例
  ForumProvider(this._repository);
  
  /// 更新仓库引用
  /// 
  /// 用于注入新的仓库实例，通常在初始化后使用
  /// @param repository 新的仓库实例
  void updateRepository(ForumRepository repository) {
    _repository = repository;
  }

  /// 加载论坛帖子，支持分页
  ///
  /// 从仓库获取帖子并相应地更新状态。
  /// 处理分页和数据刷新。
  /// 
  /// @param refresh 如果为true，则从第一页重新加载；如果为false，则加载下一页
  /// @return 操作完成时的Future
  Future<void> loadPosts({bool refresh = false}) async {
    // 防止并发加载操作或在没有仓库的情况下加载
    if (_isLoading || _repository == null) return;
    
    // 如果是刷新操作，重置分页
    if (refresh) {
      _currentPage = 1;
      _hasMorePosts = true;
    }
    
    // 如果没有更多帖子且不是刷新操作，则跳过
    if (!_hasMorePosts && !refresh) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      // 使用当前分页和过滤设置获取帖子
      final result = await _repository!.getPosts(
        page: _currentPage,
        limit: 10,
        tag: _selectedTag,
      );
      
      final List<Post> fetchedPosts = result['posts'];
      
      if (refresh) {
        // 刷新时替换所有帖子
        _posts = fetchedPosts;
      } else {
        // 追加新帖子时避免重复
        final Set<String> existingIds = _posts.map((post) => post.id).toSet();
        _posts.addAll(fetchedPosts.where((post) => !existingIds.contains(post.id)));
      }
      
      // 更新分页状态
      _totalPages = result['totalPages'] ?? 1;
      _hasMorePosts = _currentPage < _totalPages;
      
      if (_hasMorePosts) {
        _currentPage++;
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('加载帖子失败: ${e.toString()}');
      _setLoading(false);
      notifyListeners();
    }
  }

  /// 按标签筛选帖子
  ///
  /// 更新选定的标签并使用新过滤器刷新帖子列表。
  /// 
  /// @param tag 用于筛选的标签，如果为null则显示所有帖子
  /// @return 操作完成时的Future
  Future<void> filterByTag(String? tag) async {
    // 如果标签没有变化，则跳过
    if (_selectedTag == tag) return;
    
    // 更新过滤器并重置分页
    _selectedTag = tag;
    _currentPage = 1;
    _hasMorePosts = true;
    
    // 使用新过滤器重新加载帖子
    await loadPosts(refresh: true);
  }

  /// 加载特定帖子的详细信息
  ///
  /// 从仓库获取帖子详情及其评论。
  /// 
  /// @param postId 要加载的帖子ID
  /// @return 操作完成时的Future
  Future<void> loadPostDetail(String postId) async {
    if (_isLoading) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      // 强制刷新获取帖子详情，确保获取最新数据
      final post = await _repository!.getPostDetail(
        postId: postId,
        forceRefresh: true,
      );
      
      _currentPost = post;
      
      // 同时加载帖子的评论
      await loadComments(postId);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('加载帖子详情失败: ${e.toString()}');
      _setLoading(false);
      notifyListeners();
    }
  }

  /// 加载特定帖子的评论
  ///
  /// 从仓库获取评论并更新状态。
  /// 
  /// @param postId 要加载评论的帖子ID
  /// @return 操作完成时的Future
  Future<void> loadComments(String postId) async {
    try {
      // 强制刷新获取评论，确保获取最新数据
      final comments = await _repository!.getComments(
        postId: postId,
        forceRefresh: true,
      );
      
      _comments = comments;
      notifyListeners();
    } catch (e) {
      debugPrint('加载评论失败: ${e.toString()}');
      _comments = [];
      notifyListeners();
    }
  }

  /// 创建新论坛帖子
  ///
  /// 将帖子数据发送到仓库并在成功时更新本地状态。
  /// 
  /// @param title 帖子标题
  /// @param content 帖子正文内容
  /// @param tags 帖子标签列表（可选）
  /// @return 返回创建的Post对象，如失败则返回null
  Future<Post?> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
  }) async {
    if (_isCreating) return null;
    
    _setCreating(true);
    _clearError();
    
    try {
      // 通过仓库创建帖子
      final post = await _repository!.createPost(
        title: title,
        content: content,
        tags: tags,
      );
      
      // 如果正在查看第一页，将新帖子添加到列表开头
      if (_posts.isNotEmpty && _currentPage == 1) {
        _posts.insert(0, post);
      }
      
      _setCreating(false);
      notifyListeners();
      return post;
    } catch (e) {
      _setError('创建帖子失败: ${e.toString()}');
      _setCreating(false);
      notifyListeners();
      return null;
    }
  }

  /// 更新现有论坛帖子
  ///
  /// 将更新的帖子数据发送到仓库并更新本地状态。
  /// 
  /// @param postId 要更新的帖子ID
  /// @param title 新标题（可选）
  /// @param content 新内容（可选）
  /// @param tags 新标签列表（可选）
  /// @return 返回更新后的Post对象，如失败则返回null
  Future<Post?> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    if (_isCreating) return null;
    
    _setCreating(true);
    _clearError();
    
    try {
      // 通过仓库更新帖子
      final post = await _repository!.updatePost(
        postId: postId,
        title: title,
        content: content,
        tags: tags,
      );
      
      // 如果当前正在查看的是被编辑的帖子，更新当前帖子
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = post;
      }
      
      // 更新列表中的帖子（如果存在）
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index >= 0) {
        _posts[index] = post;
      }
      
      _setCreating(false);
      notifyListeners();
      return post;
    } catch (e) {
      _setError('更新帖子失败: ${e.toString()}');
      _setCreating(false);
      notifyListeners();
      return null;
    }
  }

  /// 删除论坛帖子
  ///
  /// 从仓库中删除帖子并更新本地状态。
  /// 
  /// @param postId 要删除的帖子ID
  /// @return 如删除成功返回true，否则返回false
  Future<bool> deletePost(String postId) async {
    _clearError();
    
    try {
      // 通过仓库删除帖子
      final result = await _repository!.deletePost(postId: postId);
      
      if (result) {
        // 从本地列表中删除帖子
        _posts.removeWhere((post) => post.id == postId);
        
        // 如果当前正在查看的是被删除的帖子，清除当前帖子和评论
        if (_currentPost != null && _currentPost!.id == postId) {
          _currentPost = null;
          _comments = [];
        }
        
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      _setError('删除帖子失败: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  /// 给帖子添加评论
  ///
  /// 将评论数据发送到仓库并更新本地状态。
  /// 
  /// @param postId 要评论的帖子ID
  /// @param content 评论内容
  /// @param parentId 父评论ID（用于回复功能，可选）
  /// @return 返回创建的Comment对象，如失败则返回null
  Future<Comment?> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    if (_isCommenting) return null;
    
    _setCommenting(true);
    _clearError();
    
    try {
      // 通过仓库添加评论
      final comment = await _repository!.addComment(
        postId: postId,
        content: content,
        parentId: parentId,
      );
      
      // 将评论添加到本地列表
      _comments.add(comment);
      
      // 更新当前帖子的评论计数
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = _currentPost!.copyWith(
          commentCount: _currentPost!.commentCount + 1,
        );
      }
      
      // 更新帖子列表中的评论计数
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex >= 0) {
        _posts[postIndex] = _posts[postIndex].copyWith(
          commentCount: _posts[postIndex].commentCount + 1,
        );
      }
      
      _setCommenting(false);
      notifyListeners();
      return comment;
    } catch (e) {
      _setError('添加评论失败: ${e.toString()}');
      _setCommenting(false);
      notifyListeners();
      return null;
    }
  }

  /// 删除帖子中的评论
  ///
  /// 从仓库中删除评论并更新本地状态。
  /// 
  /// @param postId 评论所属的帖子ID
  /// @param commentId 要删除的评论ID
  /// @return 如删除成功返回true，否则返回false
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    _clearError();
    
    try {
      // 通过仓库删除评论
      final result = await _repository!.deleteComment(
        postId: postId,
        commentId: commentId,
      );
      
      if (result) {
        // 从本地列表中删除评论
        _comments.removeWhere((comment) => comment.id == commentId);
        
        // 更新当前帖子的评论计数
        if (_currentPost != null && _currentPost!.id == postId) {
          _currentPost = _currentPost!.copyWith(
            commentCount: _currentPost!.commentCount - 1,
          );
        }
        
        // 更新帖子列表中的评论计数
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex >= 0) {
          _posts[postIndex] = _posts[postIndex].copyWith(
            commentCount: _posts[postIndex].commentCount - 1,
          );
        }
        
        notifyListeners();
      }
      
      return result;
    } catch (e) {
      _setError('删除评论失败: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  /// 切换帖子的点赞状态
  ///
  /// 向仓库发送点赞/取消点赞请求并更新本地状态。
  /// 
  /// @param postId 要点赞/取消点赞的帖子ID
  /// @return 返回新的点赞状态（true=已点赞，false=已取消点赞）
  Future<bool> toggleLikePost(String postId) async {
    try {
      // 通过仓库切换点赞状态
      final isLiked = await _repository!.toggleLikePost(postId: postId);
      
      // 更新当前帖子的点赞状态和计数
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = _currentPost!.copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? _currentPost!.likeCount + 1 : _currentPost!.likeCount - 1,
        );
      }
      
      // 更新帖子列表中的点赞状态和计数
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex >= 0) {
        _posts[postIndex] = _posts[postIndex].copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? _posts[postIndex].likeCount + 1 : _posts[postIndex].likeCount - 1,
        );
      }
      
      notifyListeners();
      return isLiked;
    } catch (e) {
      debugPrint('切换帖子点赞状态失败: ${e.toString()}');
      return false;
    }
  }

  /// 切换评论的点赞状态
  ///
  /// 向仓库发送点赞/取消点赞请求并更新本地状态。
  /// 
  /// @param postId 评论所属的帖子ID
  /// @param commentId 要点赞/取消点赞的评论ID
  /// @return 返回新的点赞状态（true=已点赞，false=已取消点赞）
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      // 通过仓库切换评论点赞状态
      final isLiked = await _repository!.toggleLikeComment(
        postId: postId,
        commentId: commentId,
      );
      
      // 更新评论列表中的点赞状态和计数
      final commentIndex = _comments.indexWhere((comment) => comment.id == commentId);
      if (commentIndex >= 0) {
        _comments[commentIndex] = _comments[commentIndex].copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? _comments[commentIndex].likeCount + 1 : _comments[commentIndex].likeCount - 1,
        );
      }
      
      notifyListeners();
      return isLiked;
    } catch (e) {
      debugPrint('切换评论点赞状态失败: ${e.toString()}');
      return false;
    }
  }

  /// 清除缓存并刷新所有数据
  ///
  /// 当应用需要从服务器重新加载新数据时使用。
  /// 
  /// @return 刷新操作完成时的Future
  Future<void> refresh() async {
    _repository!.clearCache();
    await loadPosts(refresh: true);
  }

  /// 设置加载状态
  ///
  /// @param value 新的加载状态
  void _setLoading(bool value) {
    _isLoading = value;
  }

  /// 设置创建帖子状态
  ///
  /// @param value 新的创建状态
  void _setCreating(bool value) {
    _isCreating = value;
  }

  /// 设置评论状态
  ///
  /// @param value 新的评论状态
  void _setCommenting(bool value) {
    _isCommenting = value;
  }

  /// 设置错误状态和消息
  ///
  /// @param message 要存储的错误消息
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    debugPrint(message);
  }

  /// 清除错误状态
  void _clearError() {
    _hasError = false;
    _errorMessage = '';
  }

  /// 重置所有状态为默认值
  ///
  /// 在注销或需要完全重置时使用。
  void resetState() {
    _posts = [];
    _currentPost = null;
    _comments = [];
    _isLoading = false;
    _isCreating = false;
    _isCommenting = false;
    _hasError = false;
    _errorMessage = '';
    _currentPage = 1;
    _totalPages = 1;
    _hasMorePosts = true;
    _selectedTag = null;
    notifyListeners();
  }
}
