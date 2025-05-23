/// 缓存服务接口
/// 
/// 定义本地缓存操作的抽象接口
abstract class ICacheService {
  /// 保存数据
  Future<void> save<T>(String key, T data);
  
  /// 获取数据
  Future<T?> get<T>(String key);
  
  /// 删除数据
  Future<void> delete(String key);
  
  /// 清空所有缓存
  Future<void> clear();
  
  /// 检查是否存在
  Future<bool> contains(String key);
  
  /// 设置过期时间
  Future<void> setExpiration(String key, Duration duration);
}