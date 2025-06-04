/**
 * 餐厅控制器
 * @module controllers/restaurant/restaurantController
 */

const restaurantService = require('../../services/restaurant/restaurantService');
const { successResponse, errorResponse } = require('../../utils/responseHelper');
const logger = require('../../config/modules/logger');

class RestaurantController {
  /**
   * 创建餐厅
   * POST /api/v1/restaurants
   */
  async createRestaurant(req, res) {
    try {
      const restaurantData = req.body;
      const restaurant = await restaurantService.createRestaurant(restaurantData);
      
      return successResponse(res, {
        message: 'Restaurant created successfully',
        data: restaurant.toObject()
      }, 201);
    } catch (error) {
      logger.error('Error in createRestaurant:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取餐厅详情
   * GET /api/v1/restaurants/:id
   */
  async getRestaurant(req, res) {
    try {
      const { id } = req.params;
      const restaurant = await restaurantService.getRestaurant(id);
      
      // 根据用户权限返回不同信息
      const isOwner = req.user && req.user.restaurantId === id;
      const data = isOwner ? restaurant.toObject() : restaurant.toPublicObject();
      
      return successResponse(res, {
        data
      });
    } catch (error) {
      logger.error('Error in getRestaurant:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 更新餐厅信息
   * PUT /api/v1/restaurants/:id
   */
  async updateRestaurant(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      
      const restaurant = await restaurantService.updateRestaurant(id, updateData);
      
      return successResponse(res, {
        message: 'Restaurant updated successfully',
        data: restaurant.toObject()
      });
    } catch (error) {
      logger.error('Error in updateRestaurant:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 搜索餐厅
   * GET /api/v1/restaurants/search
   */
  async searchRestaurants(req, res) {
    try {
      const criteria = req.query;
      const restaurants = await restaurantService.searchRestaurants(criteria);
      
      const data = restaurants.map(r => r.toPublicObject());
      
      return successResponse(res, {
        data,
        total: data.length
      });
    } catch (error) {
      logger.error('Error in searchRestaurants:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 验证餐厅
   * POST /api/v1/restaurants/:id/verify
   */
  async verifyRestaurant(req, res) {
    try {
      const { id } = req.params;
      const restaurant = await restaurantService.verifyRestaurant(id);
      
      return successResponse(res, {
        message: 'Restaurant verified successfully',
        data: restaurant.toObject()
      });
    } catch (error) {
      logger.error('Error in verifyRestaurant:', error);
      return errorResponse(res, error);
    }
  }
  
  // ========== 分店管理 ==========
  
  /**
   * 创建分店
   * POST /api/v1/restaurants/:restaurantId/branches
   */
  async createBranch(req, res) {
    try {
      const { restaurantId } = req.params;
      const branchData = req.body;
      
      const branch = await restaurantService.createBranch(restaurantId, branchData);
      
      return successResponse(res, {
        message: 'Branch created successfully',
        data: branch.toObject()
      }, 201);
    } catch (error) {
      logger.error('Error in createBranch:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取分店详情
   * GET /api/v1/branches/:id
   */
  async getBranch(req, res) {
    try {
      const { id } = req.params;
      const branch = await restaurantService.getBranch(id);
      
      // 根据用户权限返回不同信息
      const isStaff = req.user && (req.user.branchId === id || req.user.restaurantId === branch.restaurantId);
      const data = isStaff ? branch.toObject() : branch.toPublicObject();
      
      return successResponse(res, {
        data
      });
    } catch (error) {
      logger.error('Error in getBranch:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取餐厅的所有分店
   * GET /api/v1/restaurants/:restaurantId/branches
   */
  async getRestaurantBranches(req, res) {
    try {
      const { restaurantId } = req.params;
      const branches = await restaurantService.getRestaurantBranches(restaurantId);
      
      const data = branches.map(b => b.toPublicObject());
      
      return successResponse(res, {
        data,
        total: data.length
      });
    } catch (error) {
      logger.error('Error in getRestaurantBranches:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 查找附近分店
   * GET /api/v1/branches/nearby
   */
  async findNearbyBranches(req, res) {
    try {
      const { longitude, latitude, radius = 5000 } = req.query;
      
      if (!longitude || !latitude) {
        const { ValidationError } = require('../../utils/errors');
        throw new ValidationError('Longitude and latitude are required');
      }
      
      const branches = await restaurantService.findNearbyBranches(
        parseFloat(longitude),
        parseFloat(latitude),
        parseInt(radius)
      );
      
      return successResponse(res, {
        data: branches,
        total: branches.length
      });
    } catch (error) {
      logger.error('Error in findNearbyBranches:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 更新分店信息
   * PUT /api/v1/branches/:id
   */
  async updateBranch(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      
      const branch = await restaurantService.getBranch(id);
      branch.update(updateData);
      
      return successResponse(res, {
        message: 'Branch updated successfully',
        data: branch.toObject()
      });
    } catch (error) {
      logger.error('Error in updateBranch:', error);
      return errorResponse(res, error);
    }
  }
  
  // ========== 桌位管理 ==========
  
  /**
   * 创建桌位
   * POST /api/v1/branches/:branchId/tables
   */
  async createTable(req, res) {
    try {
      const { branchId } = req.params;
      const tableData = req.body;
      
      const table = await restaurantService.createTable(branchId, tableData);
      
      return successResponse(res, {
        message: 'Table created successfully',
        data: table.toObject()
      }, 201);
    } catch (error) {
      logger.error('Error in createTable:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 批量创建桌位
   * POST /api/v1/branches/:branchId/tables/batch
   */
  async createTables(req, res) {
    try {
      const { branchId } = req.params;
      const { tables } = req.body;
      
      if (!Array.isArray(tables)) {
        const { ValidationError } = require('../../utils/errors');
        throw new ValidationError('Tables must be an array');
      }
      
      const createdTables = await restaurantService.createTables(branchId, tables);
      
      return successResponse(res, {
        message: `${createdTables.length} tables created successfully`,
        data: createdTables.map(t => t.toObject())
      }, 201);
    } catch (error) {
      logger.error('Error in createTables:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取桌位详情
   * GET /api/v1/tables/:id
   */
  async getTable(req, res) {
    try {
      const { id } = req.params;
      const table = await restaurantService.getTable(id);
      
      return successResponse(res, {
        data: table.toObject()
      });
    } catch (error) {
      logger.error('Error in getTable:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取分店的所有桌位
   * GET /api/v1/branches/:branchId/tables
   */
  async getBranchTables(req, res) {
    try {
      const { branchId } = req.params;
      const options = req.query;
      
      const tables = await restaurantService.getBranchTables(branchId, options);
      
      const data = tables.map(t => t.toObject());
      
      return successResponse(res, {
        data,
        total: data.length
      });
    } catch (error) {
      logger.error('Error in getBranchTables:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 占用桌位
   * POST /api/v1/tables/:id/occupy
   */
  async occupyTable(req, res) {
    try {
      const { id } = req.params;
      const { orderId } = req.body;
      
      if (!orderId) {
        const { ValidationError } = require('../../utils/errors');
        throw new ValidationError('Order ID is required');
      }
      
      const table = await restaurantService.occupyTable(id, orderId);
      
      return successResponse(res, {
        message: 'Table occupied successfully',
        data: table.toObject()
      });
    } catch (error) {
      logger.error('Error in occupyTable:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 释放桌位
   * POST /api/v1/tables/:id/release
   */
  async releaseTable(req, res) {
    try {
      const { id } = req.params;
      const table = await restaurantService.releaseTable(id);
      
      return successResponse(res, {
        message: 'Table released successfully',
        data: table.toObject()
      });
    } catch (error) {
      logger.error('Error in releaseTable:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 更新桌位信息
   * PUT /api/v1/tables/:id
   */
  async updateTable(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      
      const table = await restaurantService.getTable(id);
      table.update(updateData);
      
      return successResponse(res, {
        message: 'Table updated successfully',
        data: table.toObject()
      });
    } catch (error) {
      logger.error('Error in updateTable:', error);
      return errorResponse(res, error);
    }
  }
  
  // ========== 设置管理 ==========
  
  /**
   * 获取餐厅设置
   * GET /api/v1/restaurants/:restaurantId/settings
   */
  async getRestaurantSettings(req, res) {
    try {
      const { restaurantId } = req.params;
      const settings = await restaurantService.getRestaurantSettings(restaurantId);
      
      return successResponse(res, {
        data: settings.toObject()
      });
    } catch (error) {
      logger.error('Error in getRestaurantSettings:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 获取分店设置
   * GET /api/v1/branches/:branchId/settings
   */
  async getBranchSettings(req, res) {
    try {
      const { branchId } = req.params;
      const settings = await restaurantService.getBranchSettings(branchId);
      
      return successResponse(res, {
        data: settings.toObject()
      });
    } catch (error) {
      logger.error('Error in getBranchSettings:', error);
      return errorResponse(res, error);
    }
  }
  
  /**
   * 更新设置
   * PUT /api/v1/settings/:id
   */
  async updateSettings(req, res) {
    try {
      const { id } = req.params;
      const updates = req.body;
      
      const settings = await restaurantService.updateSettings(id, updates);
      
      return successResponse(res, {
        message: 'Settings updated successfully',
        data: settings.toObject()
      });
    } catch (error) {
      logger.error('Error in updateSettings:', error);
      return errorResponse(res, error);
    }
  }
}

module.exports = new RestaurantController();