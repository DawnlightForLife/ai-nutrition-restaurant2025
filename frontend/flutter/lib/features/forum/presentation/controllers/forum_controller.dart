import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/forum.dart';
import '../../domain/usecases/get_forums_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'forum_controller.freezed.dart';
part 'forum_controller.g.dart';

/// Forum 状态类
@freezed
class ForumState with _$ForumState {
  const factory ForumState({
    @Default([]) List<Uforum> forums,
    @Default(false) bool isLoading,
    String? error,
    Uforum? selectedForum,
  }) = _ForumState;

  const ForumState._();

  /// 是否处于初始状态
  bool get isInitial => forums.isEmpty && !isLoading && error == null;

  /// 是否已加载数据
  bool get hasData => forums.isNotEmpty;
}

/// Forum 控制器
@riverpod
class ForumController extends _$ForumController {
  late final GetUforumsUseCase _getForumsUseCase;

  @override
  FutureOr<ForumState> build() {
    _getForumsUseCase = ref.watch(getForumsUseCaseProvider);
    return const ForumState();
  }

  /// 加载论坛列表
  Future<void> loadForums() async {
    state = const AsyncValue.loading();

    final result = await _getForumsUseCase(NoParams());

    state = result.fold(
      (failure) => AsyncValue.data(
        ForumState(error: failure.message),
      ),
      (forums) => AsyncValue.data(
        ForumState(forums: forums),
      ),
    );
  }

  /// 刷新论坛列表
  Future<void> refresh() async {
    await loadForums();
  }

  /// 根据ID获取论坛
  Uforum? getForumById(String id) {
    return state.valueOrNull?.forums.firstWhere(
      (forum) => forum.id == id,
      orElse: () => throw Exception('Forum not found'),
    );
  }

  /// 搜索论坛
  List<Uforum> searchForums(String query) {
    final forums = state.valueOrNull?.forums ?? [];
    if (query.isEmpty) return forums;

    return forums.where((forum) {
      final titleMatch = forum.title.toLowerCase().contains(query.toLowerCase());
      final descriptionMatch = forum.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return titleMatch || descriptionMatch;
    }).toList();
  }

  /// 按分类筛选论坛
  List<Uforum> filterByCategory(String category) {
    final forums = state.valueOrNull?.forums ?? [];
    if (category.isEmpty) return forums;

    return forums.where((forum) => forum.category == category).toList();
  }

  /// 选择论坛
  void selectForum(Uforum? forum) {
    state = state.whenData((data) => data.copyWith(selectedForum: forum));
  }

  /// 清除选中的论坛
  void clearSelection() {
    selectForum(null);
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }
}

/// UseCase Provider
@riverpod
GetUforumsUseCase getForumsUseCase(GetForumsUseCaseRef ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return GetUforumsUseCase(repository);
}

/// Repository Provider (需要在DI中配置)
final forumRepositoryProvider = Provider<UforumRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});

// ===== 便捷访问器 =====

/// 论坛列表
@riverpod
List<Uforum> forumList(ForumListRef ref) {
  return ref.watch(forumControllerProvider).valueOrNull?.forums ?? [];
}

/// 是否正在加载
@riverpod
bool forumIsLoading(ForumIsLoadingRef ref) {
  return ref.watch(forumControllerProvider).isLoading;
}

/// 错误信息
@riverpod
String? forumError(ForumErrorRef ref) {
  return ref.watch(forumControllerProvider).valueOrNull?.error;
}

/// 选中的论坛
@riverpod
Uforum? selectedForum(SelectedForumRef ref) {
  return ref.watch(forumControllerProvider).valueOrNull?.selectedForum;
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final forumProvider = Provider<AsyncValue<ForumState>>((ref) {
  return ref.watch(forumControllerProvider);
});