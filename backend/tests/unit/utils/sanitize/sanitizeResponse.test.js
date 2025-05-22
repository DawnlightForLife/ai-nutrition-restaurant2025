/**
 * 响应数据敏感字段过滤工具单元测试
 * 主要测试纯函数逻辑部分
 */

const { sanitizeData, sanitizeObject, extractSensitivityMap } = require('../../../../utils/sanitize/sanitizeResponse');

// 模拟mongoose schema
const mockSchema = {
  paths: {
    name: { options: {} },
    email: { options: { sensitive: true } },
    phone: { options: { sensitive: true } },
    address: {
      schema: {
        paths: {
          street: { options: {} },
          city: { options: {} },
          zipCode: { options: { sensitive: true } }
        }
      }
    },
    contacts: {
      instance: 'Array',
      schema: {
        paths: {
          name: { options: {} },
          phone: { options: { sensitive: true } }
        }
      }
    }
  }
};

describe('敏感数据过滤工具测试', () => {
  describe('extractSensitivityMap', () => {
    test('应正确提取敏感字段映射', () => {
      const sensitivityMap = extractSensitivityMap(mockSchema);
      
      expect(sensitivityMap).toHaveProperty('email', true);
      expect(sensitivityMap).toHaveProperty('phone', true);
      expect(sensitivityMap).toHaveProperty('address.zipCode', true);
      expect(sensitivityMap).toHaveProperty('contacts.phone', true);
      
      expect(sensitivityMap).not.toHaveProperty('name');
      expect(sensitivityMap).not.toHaveProperty('address.street');
    });
  });

  describe('sanitizeObject', () => {
    test('应保留非敏感字段', () => {
      const data = {
        name: '张三',
        age: 25,
        interests: ['阅读', '游泳']
      };
      
      const result = sanitizeObject(data, [], {}, false, null, false);
      
      expect(result).toEqual(data);
    });

    test('应过滤敏感字段当用户未登录', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '13800138000'
      };
      
      const sensitivityMap = {
        email: true,
        phone: true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, false, null, false);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).not.toHaveProperty('email');
      expect(result).not.toHaveProperty('phone');
    });

    test('应保留敏感字段当用户是管理员', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '13800138000'
      };
      
      const sensitivityMap = {
        email: true,
        phone: true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, true, 'user123', true);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).toHaveProperty('email', 'zhangsan@example.com');
      expect(result).toHaveProperty('phone', '13800138000');
    });

    test('应保留敏感字段当用户是数据所有者', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '13800138000',
        userId: 'user123'
      };
      
      const sensitivityMap = {
        email: true,
        phone: true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, true, 'user123', false);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).toHaveProperty('email', 'zhangsan@example.com');
      expect(result).toHaveProperty('phone', '13800138000');
    });

    test('应过滤敏感字段当用户不是数据所有者', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '13800138000',
        userId: 'user123'
      };
      
      const sensitivityMap = {
        email: true,
        phone: true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, true, 'user456', false);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).not.toHaveProperty('email');
      expect(result).not.toHaveProperty('phone');
      expect(result).toHaveProperty('userId', 'user123');
    });

    test('应递归处理嵌套对象', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        address: {
          street: '中国大道1号',
          city: '北京',
          zipCode: '100000'
        }
      };
      
      const sensitivityMap = {
        email: true,
        'address.zipCode': true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, false, null, false);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).not.toHaveProperty('email');
      expect(result).toHaveProperty('address.street', '中国大道1号');
      expect(result).toHaveProperty('address.city', '北京');
      expect(result).not.toHaveProperty('address.zipCode');
    });

    test('应递归处理数组', () => {
      const data = {
        name: '张三',
        contacts: [
          { name: '李四', phone: '13811111111' },
          { name: '王五', phone: '13822222222' }
        ]
      };
      
      const sensitivityMap = {
        'contacts.phone': true
      };
      
      const result = sanitizeObject(data, [], sensitivityMap, false, null, false);
      
      expect(result).toHaveProperty('name', '张三');
      expect(result.contacts).toHaveLength(2);
      expect(result.contacts[0]).toHaveProperty('name', '李四');
      expect(result.contacts[0]).not.toHaveProperty('phone');
      expect(result.contacts[1]).toHaveProperty('name', '王五');
      expect(result.contacts[1]).not.toHaveProperty('phone');
    });
  });

  describe('sanitizeData', () => {
    test('应使用正确的选项调用sanitizeObject', () => {
      const data = {
        name: '张三',
        email: 'zhangsan@example.com',
        phone: '13800138000'
      };
      
      // 未登录用户
      let result = sanitizeData(data, {
        hasAuthentication: false,
        userId: null,
        isAdmin: false
      });
      
      expect(result).toHaveProperty('name', '张三');
      expect(result).toHaveProperty('email', 'zhangsan@example.com');
      expect(result).toHaveProperty('phone', '13800138000');
      
      // 使用自定义敏感字段映射进行测试
      const customSensitiveData = {
        sanitizeObject: (data, path, sensitivityMap, hasAuth, userId, isAdmin) => {
          // 模拟敏感字段过滤结果
          return {
            name: data.name,
            // 过滤敏感字段
            filtered: true
          };
        }
      };
      
      // 需要使用原始实现
      const originalSanitizeObject = sanitizeObject;
      const mockSanitizeObject = jest.fn((data) => {
        return { ...data, __processed: true };
      });
      
      // 模拟实现以验证调用参数
      global.sanitizeObject = mockSanitizeObject;
      
      sanitizeData(data, {
        hasAuthentication: true,
        userId: 'user123',
        isAdmin: true
      });
      
      expect(mockSanitizeObject).toHaveBeenCalledWith(
        data,
        [],
        {},
        true,
        'user123',
        true
      );
      
      // 恢复原始实现
      global.sanitizeObject = originalSanitizeObject;
    });
  });
}); 