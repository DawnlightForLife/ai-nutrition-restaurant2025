const guestProfileService = require('../../services/user/guestProfileService');
const { successResponse, errorResponse } = require('../../utils/responseHelper');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

/**
 * 游客档案控制器
 */
class GuestProfileController {
  /**
   * 创建游客档案
   */
  async createGuestProfile(req, res) {
    try {
      const { profileData, specialNotes } = req.body;
      const createdBy = req.user.id;
      
      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
        specialNotes
      };

      const result = await guestProfileService.createGuestProfile(
        profileData, 
        createdBy, 
        options
      );

      return successResponse(res, result.data, result.message, 201);

    } catch (error) {
      if (error instanceof ValidationError) {
        return errorResponse(res, error.message, 400);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '创建游客档案失败', 500);
    }
  }

  /**
   * 获取游客档案详情
   */
  async getGuestProfile(req, res) {
    try {
      const { guestId } = req.params;
      
      const options = {
        logAccess: true,
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const result = await guestProfileService.getGuestProfile(guestId, options);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '获取游客档案失败', 500);
    }
  }

  /**
   * 更新游客档案
   */
  async updateGuestProfile(req, res) {
    try {
      const { guestId } = req.params;
      const updateData = req.body;
      const operatorId = req.user.id;
      
      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const result = await guestProfileService.updateGuestProfile(
        guestId, 
        updateData, 
        operatorId, 
        options
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof ValidationError) {
        return errorResponse(res, error.message, 400);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '更新游客档案失败', 500);
    }
  }

  /**
   * 通过绑定令牌获取档案
   */
  async getProfileByToken(req, res) {
    try {
      const { token } = req.params;

      const result = await guestProfileService.getProfileByBindingToken(token);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      return errorResponse(res, '获取档案失败', 500);
    }
  }

  /**
   * 绑定游客档案到用户
   */
  async bindToUser(req, res) {
    try {
      const { token } = req.params;
      const { userId } = req.body;
      
      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const result = await guestProfileService.bindToUser(token, userId, options);

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '绑定失败', 500);
    }
  }

  /**
   * 获取营养师的游客档案列表
   */
  async getNutritionistProfiles(req, res) {
    try {
      const nutritionistId = req.user.id;
      const { page, limit, status, search } = req.query;
      
      const options = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20,
        status,
        search
      };

      const result = await guestProfileService.getNutritionistGuestProfiles(
        nutritionistId, 
        options
      );

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '获取档案列表失败', 500);
    }
  }

  /**
   * 删除游客档案
   */
  async deleteGuestProfile(req, res) {
    try {
      const { guestId } = req.params;
      const { reason } = req.body;
      const operatorId = req.user.id;

      const result = await guestProfileService.deleteGuestProfile(
        guestId, 
        operatorId, 
        reason
      );

      return successResponse(res, null, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '删除档案失败', 500);
    }
  }

  /**
   * 获取游客档案统计
   */
  async getProfileStats(req, res) {
    try {
      const { nutritionistId } = req.query;
      
      // 如果不是管理员，只能查看自己的统计
      const targetNutritionistId = req.user.roles.includes('admin') 
        ? nutritionistId 
        : req.user.id;

      const result = await guestProfileService.getProfileStats(targetNutritionistId);

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '获取统计数据失败', 500);
    }
  }

  /**
   * 批量创建游客档案（管理员功能）
   */
  async batchCreateProfiles(req, res) {
    try {
      const { profiles } = req.body;
      const createdBy = req.user.id;
      
      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      if (!Array.isArray(profiles) || profiles.length === 0) {
        return errorResponse(res, '档案数据不能为空', 400);
      }

      const results = [];
      for (const profileData of profiles) {
        try {
          const result = await guestProfileService.createGuestProfile(
            profileData, 
            createdBy
          );
          results.push({ success: true, data: result.data });
        } catch (error) {
          results.push({ 
            success: false, 
            error: error.message, 
            profileData 
          });
        }
      }

      const successCount = results.filter(r => r.success).length;
      
      return successResponse(res, {
        results,
        summary: {
          total: profiles.length,
          success: successCount,
          failed: profiles.length - successCount
        }
      }, `批量创建完成，成功${successCount}个`);

    } catch (error) {
      return errorResponse(res, '批量创建失败', 500);
    }
  }

  /**
   * 导出游客档案数据
   */
  async exportProfiles(req, res) {
    try {
      const { startDate, endDate, format = 'json' } = req.query;
      const nutritionistId = req.user.roles.includes('admin') 
        ? req.query.nutritionistId 
        : req.user.id;

      const options = {
        page: 1,
        limit: 1000, // 导出限制
        startDate,
        endDate
      };

      const result = await guestProfileService.getNutritionistGuestProfiles(
        nutritionistId, 
        options
      );

      if (format === 'csv') {
        // 设置CSV响应头
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=guest_profiles.csv');
        
        // 简单的CSV转换
        const csvData = this.convertToCSV(result.data.profiles);
        return res.send(csvData);
      }

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '导出数据失败', 500);
    }
  }

  /**
   * 转换为CSV格式
   * @private
   */
  convertToCSV(profiles) {
    const headers = [
      'guestId', 'age', 'gender', 'height', 'weight', 
      'activityLevel', 'bindingStatus', 'createdAt', 'expiresAt'
    ];
    
    const csvRows = [headers.join(',')];
    
    profiles.forEach(profile => {
      const row = [
        profile.guestId,
        profile.profileData.age || '',
        profile.profileData.gender || '',
        profile.profileData.height || '',
        profile.profileData.weight || '',
        profile.profileData.activityLevel || '',
        profile.bindingStatus,
        profile.createdAt,
        profile.expiresAt
      ];
      csvRows.push(row.join(','));
    });
    
    return csvRows.join('\n');
  }
}

module.exports = new GuestProfileController();