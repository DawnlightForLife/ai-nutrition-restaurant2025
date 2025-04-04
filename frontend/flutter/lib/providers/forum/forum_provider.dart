import 'package:flutter/material.dart';
import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../../repositories/forum/forum_repository.dart';

/// 论坛状态管理提供者
class ForumProvider with ChangeNotifier {
  ForumRepository? _repository;
  
  // 状态数据
  List<Post> _posts = [];
  Post? _currentPost;
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isCommenting = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMorePosts = true;
  String? _selectedTag;

  // 获取状态数据
  List<Post> get posts => _posts;
  Post? get currentPost => _currentPost;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isCommenting => _isCommenting;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMorePosts => _hasMorePosts;
  String? get selectedTag => _selectedTag;

  ForumProvider(this._repository);
  
  /// 更新仓库引用
  void updateRepository(ForumRepository repository) {
    _repository = repository;
  }

  /// 加载帖子列表
  ///
  /// [refresh] 是否刷新（重新加载第一页）
  Future<void> loadPosts({bool refresh = false}) async {
    if (_isLoading || _repository == null) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMorePosts = true;
    }
    
    if (!_hasMorePosts && !refresh) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _repository!.getPosts(
        page: _currentPage,
        limit: 10,
        tag: _selectedTag,
      );
      
      final List<Post> fetchedPosts = result['posts'];
      
      if (refresh) {
        _posts = fetchedPosts;
      } else {
        // 避免重复添加
        final Set<String> existingIds = _posts.map((post) => post.id).toSet();
        _posts.addAll(fetchedPosts.where((post) => !existingIds.contains(post.id)));
      }
      
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
  Future<void> filterByTag(String? tag) async {
    if (_selectedTag == tag) return;
    
    _selectedTag = tag;
    _currentPage = 1;
    _hasMorePosts = true;
    
    await loadPosts(refresh: true);
  }

  /// 加载帖子详情
  Future<void> loadPostDetail(String postId) async {
    if (_isLoading) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final post = await _repository!.getPostDetail(
        postId: postId,
        forceRefresh: true,
      );
      
      _currentPost = post;
      
      await loadComments(postId);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('加载帖子详情失败: ${e.toString()}');
      _setLoading(false);
      notifyListeners();
    }
  }

  /// 加载帖子评论
  Future<void> loadComments(String postId) async {
    try {
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

  /// 创建新帖子
  Future<Post?> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
  }) async {
    if (_isCreating) return null;
    
    _setCreating(true);
    _clearError();
    
    try {
      final post = await _repository!.createPost(
        title: title,
        content: content,
        tags: tags,
      );
      
      // 添加到帖子列表的首位
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

  /// 更新帖子
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
      final post = await _repository!.updatePost(
        postId: postId,
        title: title,
        content: content,
        tags: tags,
      );
      
      // 更新当前帖子
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = post;
      }
      
      // 更新帖子列表中的帖子
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

  /// 删除帖子
  Future<bool> deletePost(String postId) async {
    _clearError();
    
    try {
      final result = await _repository!.deletePost(postId: postId);
      
      if (result) {
        // 从帖子列表中移除
        _posts.removeWhere((post) => post.id == postId);
        
        // 如果是当前帖子，清空当前帖子和评论
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

  /// 添加评论
  Future<Comment?> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    if (_isCommenting) return null;
    
    _setCommenting(true);
    _clearError();
    
    try {
      final comment = await _repository!.addComment(
        postId: postId,
        content: content,
        parentId: parentId,
      );
      
      // 添加到评论列表
      _comments.add(comment);
      
      // 更新当前帖子的评论数
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = _currentPost!.copyWith(
          commentCount: _currentPost!.commentCount + 1,
        );
      }
      
      // 更新帖子列表中的评论数
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

  /// 删除评论
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    _clearError();
    
    try {
      final result = await _repository!.deleteComment(
        postId: postId,
        commentId: commentId,
      );
      
      if (result) {
        // 从评论列表中移除
        _comments.removeWhere((comment) => comment.id == commentId);
        
        // 更新当前帖子的评论数
        if (_currentPost != null && _currentPost!.id == postId) {
          _currentPost = _currentPost!.copyWith(
            commentCount: _currentPost!.commentCount - 1,
          );
        }
        
        // 更新帖子列表中的评论数
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

  /// 切换帖子点赞状态
  Future<bool> toggleLikePost(String postId) async {
    try {
      final isLiked = await _repository!.toggleLikePost(postId: postId);
      
      // 更新当前帖子的点赞状态
      if (_currentPost != null && _currentPost!.id == postId) {
        _currentPost = _currentPost!.copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? _currentPost!.likeCount + 1 : _currentPost!.likeCount - 1,
        );
      }
      
      // 更新帖子列表中的点赞状态
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
      debugPrint('切换点赞状态失败: ${e.toString()}');
      return false;
    }
  }

  /// 切换评论点赞状态
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final isLiked = await _repository!.toggleLikeComment(
        postId: postId,
        commentId: commentId,
      );
      
      // 更新评论列表中的点赞状态
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

  /// 清除缓存并刷新数据
  Future<void> refresh() async {
    _repository!.clearCache();
    await loadPosts(refresh: true);
  }

  /// 设置加载状态
  void _setLoading(bool value) {
    _isLoading = value;
  }

  /// 设置创建帖子状态
  void _setCreating(bool value) {
    _isCreating = value;
  }

  /// 设置评论状态
  void _setCommenting(bool value) {
    _isCommenting = value;
  }

  /// 设置错误状态
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

  /// 重置所有状态
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
