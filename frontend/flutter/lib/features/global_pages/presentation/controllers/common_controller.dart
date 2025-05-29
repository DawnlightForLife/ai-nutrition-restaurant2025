import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/common.dart';
import '../../domain/usecases/get_commons_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'common_controller.freezed.dart';
part 'common_controller.g.dart';

/// Common 状态类
@freezed
class CommonState with _$CommonState {
  const factory CommonState({
    @Default([]) List<Ucommon> commons,
    @Default(false) bool isLoading,
    String? error,
    @Default({}) Map<String, dynamic> appConfig,
    @Default({}) Map<String, String> translations,
    @Default('zh_CN') String locale,
    @Default(false) bool isDarkMode,
    @Default({}) Map<String, dynamic> userPreferences,
  }) = _CommonState;

  const CommonState._();

  /// 是否处于初始状态
  bool get isInitial => commons.isEmpty && !isLoading && error == null && appConfig.isEmpty;

  /// 是否已加载数据
  bool get hasData => commons.isNotEmpty || appConfig.isNotEmpty;

  /// 获取配置项
  T? getConfig<T>(String key) {
    return appConfig[key] as T?;
  }

  /// 获取翻译文本
  String translate(String key) {
    return translations[key] ?? key;
  }

  /// 获取用户偏好设置
  T? getPreference<T>(String key) {
    return userPreferences[key] as T?;
  }
}

/// Common 控制器
@riverpod
class CommonController extends _$CommonController {
  late final GetUcommonsUseCase _getCommonsUseCase;

  @override
  FutureOr<CommonState> build() {
    _getCommonsUseCase = ref.watch(getCommonsUseCaseProvider);
    // 初始化时加载配置
    _loadInitialConfig();
    return const CommonState();
  }

  /// 加载初始配置
  Future<void> _loadInitialConfig() async {
    // 加载本地存储的用户偏好设置
    await loadUserPreferences();
    // 加载应用配置
    await loadAppConfig();
  }

  /// 加载通用数据
  Future<void> loadCommons() async {
    state = const AsyncValue.loading();

    final result = await _getCommonsUseCase(NoParams());

    state = result.fold(
      (failure) => AsyncValue.data(
        CommonState(error: failure.message),
      ),
      (commons) => AsyncValue.data(
        state.valueOrNull?.copyWith(commons: commons) ?? CommonState(commons: commons),
      ),
    );
  }

  /// 加载应用配置
  Future<void> loadAppConfig() async {
    // TODO: 从远程或本地加载应用配置
    final config = <String, dynamic>{
      'app_version': '1.0.0',
      'min_version': '1.0.0',
      'api_timeout': 30000,
      'max_upload_size': 10485760, // 10MB
      'features': {
        'dark_mode': true,
        'offline_mode': true,
        'push_notifications': true,
      },
    };

    state = AsyncValue.data(
      state.valueOrNull?.copyWith(appConfig: config) ?? CommonState(appConfig: config),
    );
  }

  /// 加载翻译文本
  Future<void> loadTranslations(String locale) async {
    // TODO: 从远程或本地加载翻译文本
    final translations = <String, String>{
      'app_name': '智慧营养餐厅',
      'welcome': '欢迎',
      'login': '登录',
      'logout': '退出登录',
      'confirm': '确认',
      'cancel': '取消',
      'error': '错误',
      'success': '成功',
      'loading': '加载中...',
    };

    state = state.whenData((data) => data.copyWith(
          translations: translations,
          locale: locale,
        ));
  }

  /// 加载用户偏好设置
  Future<void> loadUserPreferences() async {
    // TODO: 从本地存储加载用户偏好设置
    final preferences = <String, dynamic>{
      'theme': 'light',
      'language': 'zh_CN',
      'notification_enabled': true,
      'auto_login': false,
    };

    state = AsyncValue.data(
      state.valueOrNull?.copyWith(userPreferences: preferences) ??
          CommonState(userPreferences: preferences),
    );
  }

  /// 更新用户偏好设置
  Future<void> updatePreference(String key, dynamic value) async {
    final preferences = Map<String, dynamic>.from(state.valueOrNull?.userPreferences ?? {});
    preferences[key] = value;

    state = state.whenData((data) => data.copyWith(userPreferences: preferences));

    // TODO: 保存到本地存储
  }

  /// 切换主题模式
  void toggleTheme() {
    final isDarkMode = !(state.valueOrNull?.isDarkMode ?? false);
    state = state.whenData((data) => data.copyWith(isDarkMode: isDarkMode));
    updatePreference('theme', isDarkMode ? 'dark' : 'light');
  }

  /// 切换语言
  Future<void> changeLocale(String locale) async {
    await loadTranslations(locale);
    updatePreference('language', locale);
  }

  /// 刷新所有数据
  Future<void> refresh() async {
    await Future.wait([
      loadCommons(),
      loadAppConfig(),
      loadTranslations(state.valueOrNull?.locale ?? 'zh_CN'),
    ]);
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }

  /// 检查功能是否启用
  bool isFeatureEnabled(String feature) {
    final features = state.valueOrNull?.appConfig['features'] as Map<String, dynamic>?;
    return features?[feature] as bool? ?? false;
  }

  /// 检查版本是否需要更新
  bool needsUpdate(String currentVersion) {
    final minVersion = state.valueOrNull?.getConfig<String>('min_version');
    if (minVersion == null) return false;
    
    // TODO: 实现版本比较逻辑
    return false;
  }
}

/// UseCase Provider
@riverpod
GetUcommonsUseCase getCommonsUseCase(GetCommonsUseCaseRef ref) {
  final repository = ref.watch(commonRepositoryProvider);
  return GetUcommonsUseCase(repository);
}

/// Repository Provider (需要在DI中配置)
final commonRepositoryProvider = Provider<UcommonRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});

// ===== 便捷访问器 =====

/// 通用数据列表
@riverpod
List<Ucommon> commonList(CommonListRef ref) {
  return ref.watch(commonControllerProvider).valueOrNull?.commons ?? [];
}

/// 是否正在加载
@riverpod
bool commonIsLoading(CommonIsLoadingRef ref) {
  return ref.watch(commonControllerProvider).isLoading;
}

/// 错误信息
@riverpod
String? commonError(CommonErrorRef ref) {
  return ref.watch(commonControllerProvider).valueOrNull?.error;
}

/// 应用配置
@riverpod
Map<String, dynamic> appConfig(AppConfigRef ref) {
  return ref.watch(commonControllerProvider).valueOrNull?.appConfig ?? {};
}

/// 当前语言
@riverpod
String currentLocale(CurrentLocaleRef ref) {
  return ref.watch(commonControllerProvider).valueOrNull?.locale ?? 'zh_CN';
}

/// 是否深色模式
@riverpod
bool isDarkMode(IsDarkModeRef ref) {
  return ref.watch(commonControllerProvider).valueOrNull?.isDarkMode ?? false;
}

/// 翻译文本
@riverpod
String translate(TranslateRef ref, String key) {
  return ref.watch(commonControllerProvider).valueOrNull?.translate(key) ?? key;
}

/// 用户偏好设置
@riverpod
T? userPreference<T>(UserPreferenceRef ref, String key) {
  return ref.watch(commonControllerProvider).valueOrNull?.getPreference<T>(key);
}

/// 功能开关
@riverpod
bool featureEnabled(FeatureEnabledRef ref, String feature) {
  final controller = ref.watch(commonControllerProvider.notifier);
  return controller.isFeatureEnabled(feature);
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final commonProvider = Provider<AsyncValue<CommonState>>((ref) {
  return ref.watch(commonControllerProvider);
});