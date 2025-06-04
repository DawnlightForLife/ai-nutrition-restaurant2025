/**
 * 餐厅服务
 * @module services/restaurant/restaurantService
 */

const Restaurant = require('../../domain/restaurant/restaurant');
const Branch = require('../../domain/restaurant/branch');
const Table = require('../../domain/restaurant/table');
const RestaurantSetting = require('../../domain/restaurant/setting');
const { ValidationError, NotFoundError, ConflictError } = require('../../utils/errors');
const logger = require('../../config/modules/logger');

class RestaurantService {
  constructor() {
    // 模拟数据存储（实际应使用数据库）
    this.restaurants = new Map();
    this.branches = new Map();
    this.tables = new Map();
    this.settings = new Map();
  }
  
  // ========== 餐厅管理 ==========
  
  /**
   * 创建餐厅
   */
  async createRestaurant(restaurantData) {
    try {
      // 验证必填字段
      if (!restaurantData.name || !restaurantData.businessLicense) {
        throw new ValidationError('Restaurant name and business license are required');
      }
      
      // 检查营业执照唯一性
      const existingRestaurant = Array.from(this.restaurants.values())
        .find(r => r.businessLicense === restaurantData.businessLicense);
      
      if (existingRestaurant) {
        throw new ConflictError('Business license already registered');
      }
      
      // 创建餐厅实体
      const restaurant = new Restaurant({
        id: this.generateId('REST'),
        ...restaurantData,
        status: 'active',
        verificationStatus: 'pending'
      });
      
      // 保存餐厅
      this.restaurants.set(restaurant.id, restaurant);
      
      // 创建默认设置
      await this.createDefaultSettings(restaurant.id);
      
      logger.info(`Restaurant created: ${restaurant.id}`);
      return restaurant;
    } catch (error) {
      logger.error('Error creating restaurant:', error);
      throw error;
    }
  }
  
  /**
   * 获取餐厅详情
   */
  async getRestaurant(restaurantId) {
    const restaurant = this.restaurants.get(restaurantId);
    if (!restaurant) {
      throw new NotFoundError('Restaurant not found');
    }
    return restaurant;
  }
  
  /**
   * 更新餐厅信息
   */
  async updateRestaurant(restaurantId, updateData) {
    try {
      const restaurant = await this.getRestaurant(restaurantId);
      
      // 更新餐厅信息
      restaurant.update(updateData);
      
      logger.info(`Restaurant updated: ${restaurantId}`);
      return restaurant;
    } catch (error) {
      logger.error('Error updating restaurant:', error);
      throw error;
    }
  }
  
  /**
   * 验证餐厅
   */
  async verifyRestaurant(restaurantId) {
    try {
      const restaurant = await this.getRestaurant(restaurantId);
      restaurant.verify();
      
      logger.info(`Restaurant verified: ${restaurantId}`);
      return restaurant;
    } catch (error) {
      logger.error('Error verifying restaurant:', error);
      throw error;
    }
  }
  
  /**
   * 搜索餐厅
   */
  async searchRestaurants(criteria = {}) {
    try {
      let restaurants = Array.from(this.restaurants.values());
      
      // 按状态过滤
      if (criteria.status) {
        restaurants = restaurants.filter(r => r.status === criteria.status);
      }
      
      // 按验证状态过滤
      if (criteria.verificationStatus) {
        restaurants = restaurants.filter(r => r.verificationStatus === criteria.verificationStatus);
      }
      
      // 按类型过滤
      if (criteria.type) {
        restaurants = restaurants.filter(r => r.type === criteria.type);
      }
      
      // 按菜系过滤
      if (criteria.cuisineType) {
        restaurants = restaurants.filter(r => r.cuisineTypes.includes(criteria.cuisineType));
      }
      
      // 按价格区间过滤
      if (criteria.priceRange) {
        restaurants = restaurants.filter(r => r.priceRange === criteria.priceRange);
      }
      
      // 关键词搜索
      if (criteria.keyword) {
        const keyword = criteria.keyword.toLowerCase();
        restaurants = restaurants.filter(r => 
          r.name.toLowerCase().includes(keyword) ||
          r.description?.toLowerCase().includes(keyword) ||
          r.tags?.some(tag => tag.toLowerCase().includes(keyword))
        );
      }
      
      return restaurants;
    } catch (error) {
      logger.error('Error searching restaurants:', error);
      throw error;
    }
  }
  
  // ========== 分店管理 ==========
  
  /**
   * 创建分店
   */
  async createBranch(restaurantId, branchData) {
    try {
      // 验证餐厅存在
      await this.getRestaurant(restaurantId);
      
      // 验证必填字段
      if (!branchData.name || !branchData.address) {
        throw new ValidationError('Branch name and address are required');
      }
      
      // 创建分店实体
      const branch = new Branch({
        id: this.generateId('BRANCH'),
        restaurantId,
        code: this.generateBranchCode(restaurantId),
        ...branchData
      });
      
      // 保存分店
      this.branches.set(branch.id, branch);
      
      // 创建分店设置（继承餐厅设置）
      await this.createBranchSettings(restaurantId, branch.id);
      
      logger.info(`Branch created: ${branch.id} for restaurant: ${restaurantId}`);
      return branch;
    } catch (error) {
      logger.error('Error creating branch:', error);
      throw error;
    }
  }
  
  /**
   * 获取分店详情
   */
  async getBranch(branchId) {
    const branch = this.branches.get(branchId);
    if (!branch) {
      throw new NotFoundError('Branch not found');
    }
    return branch;
  }
  
  /**
   * 获取餐厅的所有分店
   */
  async getRestaurantBranches(restaurantId) {
    const branches = Array.from(this.branches.values())
      .filter(b => b.restaurantId === restaurantId);
    return branches;
  }
  
  /**
   * 根据位置查找附近分店
   */
  async findNearbyBranches(longitude, latitude, radius = 5000) {
    try {
      const branches = Array.from(this.branches.values())
        .filter(b => b.status === 'active');
      
      const nearbyBranches = branches
        .map(branch => ({
          ...branch.toObject(),
          distance: branch.calculateDistance(longitude, latitude)
        }))
        .filter(b => b.distance <= radius)
        .sort((a, b) => a.distance - b.distance);
      
      return nearbyBranches;
    } catch (error) {
      logger.error('Error finding nearby branches:', error);
      throw error;
    }
  }
  
  // ========== 桌位管理 ==========
  
  /**
   * 创建桌位
   */
  async createTable(branchId, tableData) {
    try {
      // 验证分店存在
      await this.getBranch(branchId);
      
      // 验证桌号唯一性
      const existingTable = Array.from(this.tables.values())
        .find(t => t.branchId === branchId && t.tableNumber === tableData.tableNumber);
      
      if (existingTable) {
        throw new ConflictError(`Table number ${tableData.tableNumber} already exists`);
      }
      
      // 创建桌位实体
      const table = new Table({
        id: this.generateId('TABLE'),
        branchId,
        qrCode: this.generateTableQRCode(branchId, tableData.tableNumber),
        ...tableData
      });
      
      // 保存桌位
      this.tables.set(table.id, table);
      
      logger.info(`Table created: ${table.id} for branch: ${branchId}`);
      return table;
    } catch (error) {
      logger.error('Error creating table:', error);
      throw error;
    }
  }
  
  /**
   * 批量创建桌位
   */
  async createTables(branchId, tableDataList) {
    const tables = [];
    
    for (const tableData of tableDataList) {
      try {
        const table = await this.createTable(branchId, tableData);
        tables.push(table);
      } catch (error) {
        logger.error(`Error creating table ${tableData.tableNumber}:`, error);
      }
    }
    
    return tables;
  }
  
  /**
   * 获取桌位详情
   */
  async getTable(tableId) {
    const table = this.tables.get(tableId);
    if (!table) {
      throw new NotFoundError('Table not found');
    }
    return table;
  }
  
  /**
   * 获取分店的所有桌位
   */
  async getBranchTables(branchId, options = {}) {
    let tables = Array.from(this.tables.values())
      .filter(t => t.branchId === branchId);
    
    // 按区域过滤
    if (options.area) {
      tables = tables.filter(t => t.area === options.area);
    }
    
    // 按状态过滤
    if (options.status) {
      tables = tables.filter(t => t.status === options.status);
    }
    
    // 只显示启用的桌位
    if (options.activeOnly) {
      tables = tables.filter(t => t.isActive);
    }
    
    // 按容量过滤
    if (options.minCapacity) {
      tables = tables.filter(t => t.capacity >= options.minCapacity);
    }
    
    return tables;
  }
  
  /**
   * 占用桌位
   */
  async occupyTable(tableId, orderId) {
    try {
      const table = await this.getTable(tableId);
      table.occupy(orderId);
      
      logger.info(`Table occupied: ${tableId} with order: ${orderId}`);
      return table;
    } catch (error) {
      logger.error('Error occupying table:', error);
      throw error;
    }
  }
  
  /**
   * 释放桌位
   */
  async releaseTable(tableId) {
    try {
      const table = await this.getTable(tableId);
      table.release();
      
      logger.info(`Table released: ${tableId}`);
      return table;
    } catch (error) {
      logger.error('Error releasing table:', error);
      throw error;
    }
  }
  
  // ========== 设置管理 ==========
  
  /**
   * 创建默认设置
   */
  async createDefaultSettings(restaurantId) {
    const settings = new RestaurantSetting({
      id: this.generateId('SET'),
      restaurantId
    });
    
    this.settings.set(settings.id, settings);
    return settings;
  }
  
  /**
   * 创建分店设置
   */
  async createBranchSettings(restaurantId, branchId) {
    const restaurantSettings = await this.getRestaurantSettings(restaurantId);
    
    const branchSettings = new RestaurantSetting({
      id: this.generateId('SET'),
      restaurantId,
      branchId,
      ...restaurantSettings.toObject()
    });
    
    this.settings.set(branchSettings.id, branchSettings);
    return branchSettings;
  }
  
  /**
   * 获取餐厅设置
   */
  async getRestaurantSettings(restaurantId) {
    const settings = Array.from(this.settings.values())
      .find(s => s.restaurantId === restaurantId && !s.branchId);
    
    if (!settings) {
      throw new NotFoundError('Restaurant settings not found');
    }
    
    return settings;
  }
  
  /**
   * 获取分店设置
   */
  async getBranchSettings(branchId) {
    const branch = await this.getBranch(branchId);
    
    // 查找分店特定设置
    let settings = Array.from(this.settings.values())
      .find(s => s.branchId === branchId);
    
    // 如果没有分店设置，返回餐厅设置
    if (!settings) {
      settings = await this.getRestaurantSettings(branch.restaurantId);
    }
    
    return settings;
  }
  
  /**
   * 更新设置
   */
  async updateSettings(settingsId, updates) {
    const settings = this.settings.get(settingsId);
    if (!settings) {
      throw new NotFoundError('Settings not found');
    }
    
    settings.updateSettings(updates);
    settings.validate();
    
    logger.info(`Settings updated: ${settingsId}`);
    return settings;
  }
  
  // ========== 辅助方法 ==========
  
  /**
   * 生成ID
   */
  generateId(prefix) {
    return `${prefix}_${Date.now()}_${Math.random().toString(36).substring(2, 11)}`;
  }
  
  /**
   * 生成分店编号
   */
  generateBranchCode(restaurantId) {
    const branchCount = Array.from(this.branches.values())
      .filter(b => b.restaurantId === restaurantId).length;
    return `BR${String(branchCount + 1).padStart(3, '0')}`;
  }
  
  /**
   * 生成桌位二维码
   */
  generateTableQRCode(branchId, tableNumber) {
    return `https://restaurant.app/scan/table/${branchId}/${tableNumber}`;
  }
}

module.exports = new RestaurantService();