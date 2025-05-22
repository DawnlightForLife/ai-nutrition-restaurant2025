/**
 * 错误处理工具单元测试
 * 测试错误处理工具的各种函数在不同情况下的行为
 */

const {
  handleError,
  handleValidationError,
  handleNotFound,
  handleUnauthorized,
  handleForbidden
} = require('../../../../utils/errors/errorHandler');

// 模拟Express的响应对象
const mockResponse = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};

describe('错误处理工具测试', () => {
  describe('handleError', () => {
    test('应返回500状态码和错误信息', () => {
      const res = mockResponse();
      const error = new Error('服务器内部错误');
      
      handleError(res, error);
      
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '服务器内部错误'
        })
      );
    });
    
    test('应使用自定义状态码', () => {
      const res = mockResponse();
      const error = new Error('服务器内部错误');
      
      handleError(res, error, 503);
      
      expect(res.status).toHaveBeenCalledWith(503);
    });
    
    test('开发环境下应包含错误详情', () => {
      const res = mockResponse();
      const error = new Error('服务器内部错误');
      error.stack = 'Error: 服务器内部错误\n    at Test.fn';
      
      // 模拟开发环境
      const originalNodeEnv = process.env.NODE_ENV;
      process.env.NODE_ENV = 'development';
      
      handleError(res, error);
      
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          error: error
        })
      );
      
      // 恢复环境
      process.env.NODE_ENV = originalNodeEnv;
    });
  });
  
  describe('handleValidationError', () => {
    test('应返回400状态码和验证错误信息', () => {
      const res = mockResponse();
      const error = new Error('验证失败');
      
      handleValidationError(res, error);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '验证失败'
        })
      );
    });
    
    test('应处理Joi验证错误', () => {
      const res = mockResponse();
      const joiError = {
        message: '验证失败',
        details: [
          { path: ['name'], message: '名称是必填项' },
          { path: ['email'], message: '邮箱格式不正确' }
        ]
      };
      
      handleValidationError(res, joiError);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '名称是必填项',
          error: joiError.details
        })
      );
    });
    
    test('应处理Mongoose验证错误', () => {
      const res = mockResponse();
      const mongooseError = {
        message: '验证失败',
        errors: {
          name: { message: '名称是必填项' },
          email: { message: '邮箱格式不正确' }
        }
      };
      
      handleValidationError(res, mongooseError);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '名称是必填项, 邮箱格式不正确',
          error: mongooseError.errors
        })
      );
    });
  });
  
  describe('handleNotFound', () => {
    test('应返回404状态码和默认消息', () => {
      const res = mockResponse();
      
      handleNotFound(res);
      
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Resource not found'
        })
      );
    });
    
    test('应使用自定义消息', () => {
      const res = mockResponse();
      
      handleNotFound(res, '用户不存在');
      
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '用户不存在'
        })
      );
    });
  });
  
  describe('handleUnauthorized', () => {
    test('应返回401状态码和默认消息', () => {
      const res = mockResponse();
      
      handleUnauthorized(res);
      
      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Unauthorized access'
        })
      );
    });
    
    test('应使用自定义消息', () => {
      const res = mockResponse();
      
      handleUnauthorized(res, '请先登录');
      
      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '请先登录'
        })
      );
    });
  });
  
  describe('handleForbidden', () => {
    test('应返回403状态码和默认消息', () => {
      const res = mockResponse();
      
      handleForbidden(res);
      
      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: 'Access forbidden'
        })
      );
    });
    
    test('应使用自定义消息', () => {
      const res = mockResponse();
      
      handleForbidden(res, '权限不足');
      
      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: '权限不足'
        })
      );
    });
  });
}); 