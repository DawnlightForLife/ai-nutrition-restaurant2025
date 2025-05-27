import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/abstractions/services/i_storage_service.dart';

/// Hive本地存储服务实现
/// 提供高性能的本地数据存储能力
@LazySingleton(as: IStorageService)
class HiveStorageService implements IStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _userBox = 'user_box';
  static const String _cacheBox = 'cache_box';
  static const String _settingsBox = 'settings_box';
  static const String _offlineBox = 'offline_box';

  late Box<dynamic> _userBoxInstance;
  late Box<dynamic> _cacheBoxInstance;
  late Box<dynamic> _settingsBoxInstance;
  late Box<dynamic> _offlineBoxInstance;

  /// 初始化Hive存储
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // 注册自定义适配器（如果需要）
    // Hive.registerAdapter(UserModelAdapter());
    
    // 打开所需的Box
    await Future.wait([
      Hive.openBox(_userBox),
      Hive.openBox(_cacheBox),
      Hive.openBox(_settingsBox),
      Hive.openBox(_offlineBox),
    ]);
  }

  HiveStorageService() {
    _userBoxInstance = Hive.box(_userBox);
    _cacheBoxInstance = Hive.box(_cacheBox);
    _settingsBoxInstance = Hive.box(_settingsBox);
    _offlineBoxInstance = Hive.box(_offlineBox);
  }

  @override
  Future<void> saveString(String key, String value) async {
    await _settingsBoxInstance.put(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _settingsBoxInstance.get(key) as String?;
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _settingsBoxInstance.put(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _settingsBoxInstance.get(key) as bool?;
  }

  @override
  Future<void> saveInt(String key, int value) async {
    await _settingsBoxInstance.put(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _settingsBoxInstance.get(key) as int?;
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    await _settingsBoxInstance.put(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _settingsBoxInstance.get(key) as double?;
  }

  @override
  Future<void> remove(String key) async {
    await _settingsBoxInstance.delete(key);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _userBoxInstance.clear(),
      _cacheBoxInstance.clear(),
      _settingsBoxInstance.clear(),
      _offlineBoxInstance.clear(),
    ]);
  }

  @override
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// 保存用户数据
  Future<void> saveUserData(String key, dynamic value) async {
    await _userBoxInstance.put(key, value);
  }

  /// 获取用户数据
  T? getUserData<T>(String key) {
    return _userBoxInstance.get(key) as T?;
  }

  /// 保存缓存数据（带过期时间）
  Future<void> saveCacheData(String key, dynamic value, {Duration? expiry}) async {
    final data = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await _cacheBoxInstance.put(key, data);
  }

  /// 获取缓存数据（检查过期）
  T? getCacheData<T>(String key) {
    final data = _cacheBoxInstance.get(key);
    if (data == null) return null;

    final timestamp = data['timestamp'] as int;
    final expiry = data['expiry'] as int?;

    if (expiry != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp > expiry) {
        _cacheBoxInstance.delete(key);
        return null;
      }
    }

    return data['value'] as T?;
  }

  /// 保存离线操作
  Future<void> saveOfflineOperation(Map<String, dynamic> operation) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _offlineBoxInstance.put(key, operation);
  }

  /// 获取所有离线操作
  List<Map<String, dynamic>> getOfflineOperations() {
    return _offlineBoxInstance.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// 清除离线操作
  Future<void> clearOfflineOperations() async {
    await _offlineBoxInstance.clear();
  }

  /// 监听数据变化
  Stream<BoxEvent> watch(String key) {
    final box = _getBox(key);
    return box.watch(key: key);
  }

  /// 根据key前缀获取对应的Box
  Box<dynamic> _getBox(String key) {
    if (key.startsWith('user_')) {
      return _userBoxInstance;
    } else if (key.startsWith('cache_')) {
      return _cacheBoxInstance;
    } else if (key.startsWith('settings_')) {
      return _settingsBoxInstance;
    } else if (key.startsWith('offline_')) {
      return _offlineBoxInstance;
    }
    return _cacheBoxInstance; // 默认使用缓存Box
  }

  /// 关闭所有Box
  static Future<void> close() async {
    await Hive.close();
  }
}