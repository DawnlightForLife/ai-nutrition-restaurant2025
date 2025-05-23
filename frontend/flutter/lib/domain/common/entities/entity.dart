/// 实体基类
/// 
/// 所有领域实体都应该继承此类
/// 提供实体的基本功能和约束
abstract class Entity {
  const Entity();
  
  /// 判断两个实体是否相等
  /// 基于运行时类型和属性进行比较
  bool equals(Entity other) {
    return identical(this, other);
  }
}