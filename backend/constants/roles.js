module.exports = {
    // 客户角色
    CUSTOMER: { value: 'customer', label: '顾客' },
    
    // 加盟店角色
    STORE_MANAGER: { value: 'store_manager', label: '店长' },
    STORE_STAFF: { value: 'store_staff', label: '店员' },
    NUTRITIONIST: { value: 'nutritionist', label: '营养师' },
    
    // 总部角色
    ADMIN: { value: 'admin', label: '总部管理员' },
    AREA_MANAGER: { value: 'area_manager', label: '区域经理' },
    
    // 系统角色
    SYSTEM: { value: 'system', label: '系统' },
    
    // 保持向后兼容
    USER: { value: 'customer', label: '顾客' }, // 映射到 CUSTOMER
    MERCHANT: { value: 'store_manager', label: '店长' } // 映射到 STORE_MANAGER
  };