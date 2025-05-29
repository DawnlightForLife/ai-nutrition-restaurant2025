# 论坛模块 (Forum)

## 📋 模块概述

论坛模块为用户提供营养健康交流社区，支持发帖、评论、点赞、收藏等社交功能，打造专业的营养知识分享平台。

### 核心功能
- 📝 话题发布与浏览
- 💬 评论互动系统
- 👍 点赞收藏功能
- 🏷️ 标签分类管理
- 🔍 内容搜索筛选

## 🎯 主要功能

### 1. 内容类型
- **营养知识**：专业营养文章
- **饮食日记**：用户饮食记录分享
- **经验分享**：健康管理心得
- **问答互动**：营养相关Q&A
- **食谱分享**：健康食谱交流

### 2. 帖子标签系统
- `nutrition` - 营养知识
- `recipe` - 食谱分享
- `experience` - 经验心得
- `question` - 提问求助
- `discussion` - 讨论交流

## 🔌 状态管理

```dart
@riverpod
class ForumController extends _$ForumController {
  @override
  Future<List<ForumPost>> build() async {
    final useCase = ref.read(getForumPostsUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (posts) => posts,
    );
  }

  Future<void> createPost(PostRequest request) async { /* ... */ }
  Future<void> likePost(String postId) async { /* ... */ }
  Future<void> addComment(String postId, String content) async { /* ... */ }
  Future<void> collectPost(String postId) async { /* ... */ }
}
```

## 📱 核心组件

- **ForumPostList**: 帖子列表展示
- **PostEditor**: 发帖编辑器
- **CommentSection**: 评论区组件
- **TagSelector**: 标签选择器
- **SearchBar**: 搜索过滤栏

## 🚀 使用示例

```dart
class ForumHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(forumControllerProvider);
    
    return AsyncView<List<ForumPost>>(
      value: postsState,
      data: (posts) => ForumPostList(
        posts: posts,
        onPostTap: (post) => context.go('/forum/post/${post.id}'),
        onCreatePost: () => context.go('/forum/create'),
      ),
    );
  }
}
```

---

**📚 相关文档**
- [社区规范指南](./docs/COMMUNITY_GUIDELINES.md)
- [内容审核机制](./docs/CONTENT_MODERATION.md)
