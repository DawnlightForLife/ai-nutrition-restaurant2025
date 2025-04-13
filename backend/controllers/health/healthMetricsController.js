/**
 * Health Metrics Controller
 * Handles HTTP requests related to user health metrics
 * @module controllers/health/healthMetricsController
 */
const healthMetricsService = require('../../services/health/healthMetricsService');
const logger = require('../../utils/logger');
const AppError = require('../../utils/appError');
const catchAsync = require('../../utils/catchAsync');

/**
 * Create a single health metric record
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const createMetric = async (req, res) => {
  try {
    const userId = req.user.id; // From auth middleware
    const metricData = { ...req.body, userId: userId };
    
    const result = await healthMetricsService.createMetric(metricData);
    
    return res.status(201).json({
      success: true,
      message: 'Health metric created successfully',
      data: result
    });
  } catch (error) {
    logger.error(`Failed to create health metric: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to create health metric',
      error: error.message
    });
  }
};

/**
 * Batch import health metrics
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const batchImportMetrics = async (req, res) => {
  try {
    const userId = req.user.id; // From auth middleware
    const { metrics } = req.body;
    
    if (!metrics || !Array.isArray(metrics) || metrics.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Invalid metrics data'
      });
    }
    
    // Add user ID to each record
    const metricsWithUser = metrics.map(metric => ({
      ...metric,
      userId: userId
    }));
    
    const result = await healthMetricsService.batchImportMetrics(metricsWithUser);
    
    return res.status(201).json({
      success: true,
      message: 'Health metrics batch imported successfully',
      data: result
    });
  } catch (error) {
    logger.error(`Failed to batch import health metrics: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to batch import health metrics',
      error: error.message
    });
  }
};

/**
 * Get user health metrics list
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getUserMetrics = async (req, res) => {
  try {
    const userId = req.user.id; // From auth middleware
    const { 
      metricType, 
      startDate, 
      endDate,
      limit = 20,
      page = 1,
      sortBy = 'recordedAt',
      sortOrder = 'desc',
      nutritionProfileId
    } = req.query;
    
    const options = {
      metricType,
      startDate,
      endDate,
      limit: parseInt(limit),
      page: parseInt(page),
      sort: { [sortBy]: sortOrder === 'desc' ? -1 : 1 },
      nutritionProfileId
    };
    
    const result = await healthMetricsService.getUserMetrics(userId, options);
    
    return res.status(200).json({
      success: true,
      message: 'Health metrics retrieved successfully',
      data: result.metrics,
      pagination: result.pagination
    });
  } catch (error) {
    logger.error(`Failed to get health metrics list: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to get health metrics list',
      error: error.message
    });
  }
};

/**
 * Get health metric statistics
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getMetricStats = async (req, res) => {
  try {
    const userId = req.user.id; // From auth middleware
    const { metricType } = req.params;
    const { 
      startDate,
      endDate,
      interval = 'day',
      nutritionProfileId
    } = req.query;
    
    if (!metricType) {
      return res.status(400).json({
        success: false,
        message: 'Metric type cannot be empty'
      });
    }
    
    const options = {
      startDate,
      endDate,
      interval,
      nutritionProfileId
    };
    
    const result = await healthMetricsService.getMetricStats(userId, metricType, options);
    
    return res.status(200).json({
      success: true,
      message: 'Health metric statistics retrieved successfully',
      data: result
    });
  } catch (error) {
    logger.error(`Failed to get health metric statistics: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to get health metric statistics',
      error: error.message
    });
  }
};

/**
 * Get single health metric details
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const getMetricById = async (req, res) => {
  try {
    const { id } = req.params;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Metric ID cannot be empty'
      });
    }
    
    const metric = await healthMetricsService.getMetricById(id);
    
    // Verify the retrieved metric belongs to the authenticated user
    if (metric.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'You do not have permission to access this metric'
      });
    }
    
    return res.status(200).json({
      success: true,
      message: 'Health metric details retrieved successfully',
      data: metric
    });
  } catch (error) {
    if (error.statusCode === 404) {
      return res.status(404).json({
        success: false,
        message: 'Health metric not found'
      });
    }
    
    logger.error(`Failed to get health metric details: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to get health metric details',
      error: error.message
    });
  }
};

/**
 * Update health metric
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const updateMetric = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Metric ID cannot be empty'
      });
    }
    
    // First get the metric to check ownership
    const existingMetric = await healthMetricsService.getMetricById(id);
    
    // Verify the metric belongs to the authenticated user
    if (existingMetric.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'You do not have permission to update this metric'
      });
    }
    
    // Ensure user cannot change userId field
    if (updateData.userId) {
      delete updateData.userId;
    }
    
    const result = await healthMetricsService.updateMetric(id, updateData);
    
    return res.status(200).json({
      success: true,
      message: 'Health metric updated successfully',
      data: result
    });
  } catch (error) {
    if (error.statusCode === 404) {
      return res.status(404).json({
        success: false,
        message: 'Health metric not found'
      });
    }
    
    logger.error(`Failed to update health metric: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to update health metric',
      error: error.message
    });
  }
};

/**
 * Delete health metric
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
const deleteMetric = async (req, res) => {
  try {
    const { id } = req.params;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Metric ID cannot be empty'
      });
    }
    
    // First get the metric to check ownership
    const existingMetric = await healthMetricsService.getMetricById(id);
    
    // Verify the metric belongs to the authenticated user
    if (existingMetric.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'You do not have permission to delete this metric'
      });
    }
    
    await healthMetricsService.deleteMetric(id);
    
    return res.status(200).json({
      success: true,
      message: 'Health metric deleted successfully'
    });
  } catch (error) {
    if (error.statusCode === 404) {
      return res.status(404).json({
        success: false,
        message: 'Health metric not found'
      });
    }
    
    logger.error(`Failed to delete health metric: ${error.message}`);
    return res.status(500).json({
      success: false,
      message: 'Failed to delete health metric',
      error: error.message
    });
  }
};

module.exports = {
  createMetric,
  batchImportMetrics,
  getUserMetrics,
  getMetricById,
  updateMetric,
  deleteMetric,
  getMetricStats
}; 