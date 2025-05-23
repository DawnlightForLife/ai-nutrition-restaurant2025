/// 本地存储服务接口
/// 
/// 定义安全的本地存储操作
abstract class IStorageService {
  /// 保存字符串
  Future<void> saveString(String key, String value);
  
  /// 获取字符串
  Future<String?> getString(String key);
  
  /// 保存布尔值
  Future<void> saveBool(String key, bool value);
  
  /// 获取布尔值
  Future<bool?> getBool(String key);
  
  /// 保存整数
  Future<void> saveInt(String key, int value);
  
  /// 获取整数
  Future<int?> getInt(String key);
  
  /// 保存双精度数
  Future<void> saveDouble(String key, double value);
  
  /// 获取双精度数
  Future<double?> getDouble(String key);
  
  /// 删除指定键
  Future<void> remove(String key);
  
  /// 清空所有数据
  Future<void> clear();
  
  /// 安全存储（用于敏感数据）
  Future<void> saveSecure(String key, String value);
  
  /// 获取安全存储的数据
  Future<String?> getSecure(String key);
  
  /// 删除安全存储的数据
  Future<void> removeSecure(String key);
}