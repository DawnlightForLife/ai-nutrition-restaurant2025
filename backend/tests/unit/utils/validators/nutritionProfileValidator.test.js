/**
 * 营养档案验证器单元测试
 * 测试所有验证函数在各种场景下的行为
 */

const {
  validateProfileCreation,
  validateProfileUpdate,
  validateProfileQuery
} = require('../../../../utils/validators/nutritionProfileValidator');

describe('营养档案验证器测试', () => {
  // 创建档案验证测试
  describe('validateProfileCreation', () => {
    test('应成功验证有效的营养档案创建数据', () => {
      const validData = {
        name: '默认档案',
        gender: 'male',
        birthDate: '1990-01-01',
        height: 175,
        weight: 70,
        activityLevel: 'moderate',
        goal: 'weight_loss',
        dietaryRestrictions: ['none'],
        healthConditions: ['none'],
        isPrimary: true
      };
      
      const { error } = validateProfileCreation(validData);
      expect(error).toBeUndefined();
    });

    test('应验证失败当缺少必填字段', () => {
      const invalidData = {
        name: '默认档案',
        // 缺少gender等必填字段
      };
      
      const { error } = validateProfileCreation(invalidData);
      expect(error).toBeDefined();
      expect(error.details.length).toBeGreaterThan(0);
      const errorFields = error.details.map(detail => detail.path[0]);
      expect(errorFields).toContain('gender');
      expect(errorFields).toContain('birthDate');
    });

    test('应验证失败当字段值不符合要求', () => {
      const invalidData = {
        name: '默认档案',
        gender: 'invalid-gender', // 无效的性别值
        birthDate: '2050-01-01', // 未来的日期
        height: 300, // 超出范围的身高
        weight: 1, // 低于最小值的体重
        activityLevel: 'moderate',
        goal: 'weight_loss',
      };
      
      const { error } = validateProfileCreation(invalidData);
      expect(error).toBeDefined();
      expect(error.details.length).toBeGreaterThan(0);
      
      const errorFields = error.details.map(detail => detail.path[0]);
      expect(errorFields).toContain('gender');
      expect(errorFields).toContain('birthDate');
      expect(errorFields).toContain('height');
      expect(errorFields).toContain('weight');
    });
  });

  // 更新档案验证测试
  describe('validateProfileUpdate', () => {
    test('应成功验证有效的营养档案更新数据', () => {
      const validUpdateData = {
        name: '更新后的档案',
        weight: 65,
        goal: 'maintenance',
      };
      
      const { error } = validateProfileUpdate(validUpdateData);
      expect(error).toBeUndefined();
    });

    test('应成功验证空的更新数据', () => {
      const emptyUpdateData = {};
      
      const { error } = validateProfileUpdate(emptyUpdateData);
      expect(error).toBeUndefined();
    });

    test('应验证失败当字段值不符合要求', () => {
      const invalidUpdateData = {
        name: 'A', // 低于最小长度
        gender: 'unknown', // 无效的性别值
      };
      
      const { error } = validateProfileUpdate(invalidUpdateData);
      expect(error).toBeDefined();
      expect(error.details.length).toBeGreaterThan(0);
      
      const errorFields = error.details.map(detail => detail.path[0]);
      expect(errorFields).toContain('name');
      expect(errorFields).toContain('gender');
    });
  });

  // 查询验证测试
  describe('validateProfileQuery', () => {
    test('应成功验证有效的查询参数', () => {
      const validQuery = {
        gender: 'female',
        ageMin: 20,
        ageMax: 40,
        goal: 'weight_loss',
        page: 2,
        limit: 20,
        sortBy: 'name',
        order: 'asc'
      };
      
      const { error } = validateProfileQuery(validQuery);
      expect(error).toBeUndefined();
    });

    test('应验证失败当年龄范围无效', () => {
      const invalidQuery = {
        ageMin: 50,
        ageMax: 30, // 最大年龄小于最小年龄
      };
      
      const { error } = validateProfileQuery(invalidQuery);
      expect(error).toBeDefined();
    });

    test('应验证失败当用户ID格式不正确', () => {
      const invalidQuery = {
        userId: 'invalid-id-format', // 不是有效的MongoDB ID格式
      };
      
      const { error } = validateProfileQuery(invalidQuery);
      expect(error).toBeDefined();
      expect(error.details[0].path[0]).toBe('userId');
    });

    test('应使用默认值填充分页参数', () => {
      const query = {};
      
      const { value } = validateProfileQuery(query);
      expect(value.page).toBe(1);
      expect(value.limit).toBe(10);
      expect(value.sortBy).toBe('createdAt');
      expect(value.order).toBe('desc');
    });
  });
}); 