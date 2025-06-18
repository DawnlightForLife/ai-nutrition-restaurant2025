/// 权限常量定义
/// 与后端权限系统保持一致
class Permissions {
  // 基础权限
  static const String userRead = 'user:read';
  static const String userWrite = 'user:write';
  static const String userDelete = 'user:delete';
  
  // 商家相关
  static const String merchantRead = 'merchant:read';
  static const String merchantWrite = 'merchant:write';
  static const String merchantDelete = 'merchant:delete';
  static const String merchantManage = 'merchant:manage';
  
  // 菜品相关
  static const String dishRead = 'dish:read';
  static const String dishWrite = 'dish:write';
  static const String dishDelete = 'dish:delete';
  static const String dishManage = 'dish:manage';
  
  // 库存相关
  static const String inventoryRead = 'inventory:read';
  static const String inventoryWrite = 'inventory:write';
  static const String inventoryDelete = 'inventory:delete';
  static const String inventoryManage = 'inventory:manage';
  
  // 订单相关
  static const String orderRead = 'order:read';
  static const String orderWrite = 'order:write';
  static const String orderDelete = 'order:delete';
  static const String orderManage = 'order:manage';
  
  // 营养师相关
  static const String nutritionistRead = 'nutritionist:read';
  static const String nutritionistWrite = 'nutritionist:write';
  static const String nutritionistManage = 'nutritionist:manage';
  
  // 咨询相关
  static const String consultationRead = 'consultation:read';
  static const String consultationWrite = 'consultation:write';
  static const String consultationManage = 'consultation:manage';
  
  // 管理员相关
  static const String adminRead = 'admin:read';
  static const String adminWrite = 'admin:write';
  static const String adminManage = 'admin:manage';
  
  // 系统相关
  static const String systemConfig = 'system:config';
  static const String systemMonitor = 'system:monitor';
  static const String systemBackup = 'system:backup';
  
  // 报表统计
  static const String statsView = 'stats:view';
  static const String statsExport = 'stats:export';
  
  // 用户权限管理
  static const String permissionGrant = 'permission:grant';
  static const String permissionRevoke = 'permission:revoke';
  static const String permissionView = 'permission:view';
}

/// 角色定义
class Roles {
  static const String customer = 'customer';
  static const String storeManager = 'store_manager';
  static const String storeStaff = 'store_staff';
  static const String nutritionist = 'nutritionist';
  static const String areaManager = 'area_manager';
  static const String admin = 'admin';
  static const String superAdmin = 'super_admin';
  static const String system = 'system';
}

/// 权限检查工具类
class PermissionChecker {
  /// 检查用户是否有指定权限
  static bool hasPermission(List<String>? userPermissions, String permission) {
    if (userPermissions == null) return false;
    return userPermissions.contains(permission);
  }
  
  /// 检查用户是否有任一权限
  static bool hasAnyPermission(List<String>? userPermissions, List<String> permissions) {
    if (userPermissions == null) return false;
    return permissions.any((permission) => userPermissions.contains(permission));
  }
  
  /// 检查用户是否有所有权限
  static bool hasAllPermissions(List<String>? userPermissions, List<String> permissions) {
    if (userPermissions == null) return false;
    return permissions.every((permission) => userPermissions.contains(permission));
  }
  
  /// 检查用户是否有指定角色
  static bool hasRole(String? userRole, String role) {
    return userRole == role;
  }
  
  /// 检查用户是否有任一角色
  static bool hasAnyRole(String? userRole, List<String> roles) {
    if (userRole == null) return false;
    return roles.contains(userRole);
  }
  
  /// 检查是否为商家用户
  static bool isMerchant(String? userRole) {
    return hasAnyRole(userRole, [Roles.storeManager, Roles.storeStaff]);
  }
  
  /// 检查是否为营养师
  static bool isNutritionist(String? userRole) {
    return hasRole(userRole, Roles.nutritionist);
  }
  
  /// 检查是否为管理员
  static bool isAdmin(String? userRole) {
    return hasAnyRole(userRole, [Roles.admin, Roles.superAdmin, Roles.areaManager]);
  }
  
  /// 检查是否为顾客
  static bool isCustomer(String? userRole) {
    return hasRole(userRole, Roles.customer);
  }
}

/// 角色权限映射（与后端保持一致）
class RolePermissions {
  static const Map<String, List<String>> _rolePermissions = {
    Roles.customer: [
      Permissions.userRead,
      Permissions.merchantRead,
      Permissions.dishRead,
      Permissions.orderRead,
      Permissions.orderWrite,
      Permissions.consultationRead,
      Permissions.consultationWrite,
    ],
    
    Roles.storeManager: [
      Permissions.userRead,
      Permissions.merchantRead,
      Permissions.merchantWrite,
      Permissions.merchantManage,
      Permissions.dishRead,
      Permissions.dishWrite,
      Permissions.dishDelete,
      Permissions.dishManage,
      Permissions.inventoryRead,
      Permissions.inventoryWrite,
      Permissions.inventoryDelete,
      Permissions.inventoryManage,
      Permissions.orderRead,
      Permissions.orderWrite,
      Permissions.orderManage,
      Permissions.statsView,
      Permissions.statsExport,
    ],
    
    Roles.storeStaff: [
      Permissions.userRead,
      Permissions.merchantRead,
      Permissions.dishRead,
      Permissions.dishWrite,
      Permissions.inventoryRead,
      Permissions.inventoryWrite,
      Permissions.orderRead,
      Permissions.orderWrite,
      Permissions.statsView,
    ],
    
    Roles.nutritionist: [
      Permissions.userRead,
      Permissions.merchantRead,
      Permissions.dishRead,
      Permissions.nutritionistRead,
      Permissions.nutritionistWrite,
      Permissions.nutritionistManage,
      Permissions.consultationRead,
      Permissions.consultationWrite,
      Permissions.consultationManage,
      Permissions.statsView,
    ],
    
    Roles.areaManager: [
      Permissions.userRead,
      Permissions.merchantRead,
      Permissions.merchantWrite,
      Permissions.merchantManage,
      Permissions.dishRead,
      Permissions.dishWrite,
      Permissions.dishManage,
      Permissions.inventoryRead,
      Permissions.inventoryManage,
      Permissions.orderRead,
      Permissions.orderManage,
      Permissions.nutritionistRead,
      Permissions.nutritionistManage,
      Permissions.statsView,
      Permissions.statsExport,
      Permissions.permissionView,
    ],
    
    Roles.admin: [
      // 所有非系统权限
      Permissions.userRead,
      Permissions.userWrite,
      Permissions.userDelete,
      Permissions.merchantRead,
      Permissions.merchantWrite,
      Permissions.merchantDelete,
      Permissions.merchantManage,
      Permissions.dishRead,
      Permissions.dishWrite,
      Permissions.dishDelete,
      Permissions.dishManage,
      Permissions.inventoryRead,
      Permissions.inventoryWrite,
      Permissions.inventoryDelete,
      Permissions.inventoryManage,
      Permissions.orderRead,
      Permissions.orderWrite,
      Permissions.orderDelete,
      Permissions.orderManage,
      Permissions.nutritionistRead,
      Permissions.nutritionistWrite,
      Permissions.nutritionistManage,
      Permissions.consultationRead,
      Permissions.consultationWrite,
      Permissions.consultationManage,
      Permissions.adminRead,
      Permissions.adminWrite,
      Permissions.adminManage,
      Permissions.statsView,
      Permissions.statsExport,
      Permissions.permissionGrant,
      Permissions.permissionRevoke,
      Permissions.permissionView,
    ],
    
    Roles.superAdmin: [
      // 所有权限包括系统权限
      Permissions.userRead,
      Permissions.userWrite,
      Permissions.userDelete,
      Permissions.merchantRead,
      Permissions.merchantWrite,
      Permissions.merchantDelete,
      Permissions.merchantManage,
      Permissions.dishRead,
      Permissions.dishWrite,
      Permissions.dishDelete,
      Permissions.dishManage,
      Permissions.inventoryRead,
      Permissions.inventoryWrite,
      Permissions.inventoryDelete,
      Permissions.inventoryManage,
      Permissions.orderRead,
      Permissions.orderWrite,
      Permissions.orderDelete,
      Permissions.orderManage,
      Permissions.nutritionistRead,
      Permissions.nutritionistWrite,
      Permissions.nutritionistManage,
      Permissions.consultationRead,
      Permissions.consultationWrite,
      Permissions.consultationManage,
      Permissions.adminRead,
      Permissions.adminWrite,
      Permissions.adminManage,
      Permissions.systemConfig,
      Permissions.systemMonitor,
      Permissions.systemBackup,
      Permissions.statsView,
      Permissions.statsExport,
      Permissions.permissionGrant,
      Permissions.permissionRevoke,
      Permissions.permissionView,
    ],
  };
  
  /// 获取角色的所有权限
  static List<String> getRolePermissions(String role) {
    return _rolePermissions[role] ?? [];
  }
  
  /// 获取用户的所有权限（角色权限 + 特殊权限）
  static List<String> getUserPermissions(String? role, List<String>? specialPermissions) {
    final rolePermissions = role != null ? getRolePermissions(role) : <String>[];
    final userSpecialPermissions = specialPermissions ?? <String>[];
    
    // 合并并去重
    return {...rolePermissions, ...userSpecialPermissions}.toList();
  }
}