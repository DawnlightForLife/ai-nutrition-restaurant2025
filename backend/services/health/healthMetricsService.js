/**
 * Health Metrics Service
 * Handles business logic related to user health metrics
 * @module services/health/healthMetricsService
 */
const HealthMetric = require('../../models/health/healthMetricsModel');
const AppError = require('../../utils/appError');
const logger = require('../../utils/logger');
const mongoose = require('mongoose');

/**
 * Health Metrics Service
 * Used to record and manage user health metrics data: weight, BMI, exercise records, etc.
 */
const healthMetricsService = {
  /**
   * Create health metric record
   * @param {Object} metricData - Health metric data
   * @returns {Promise<Object>} Created health metric record
   */
  async createMetric(metricData) {
    try {
      const newMetric = new HealthMetric(metricData);
      await newMetric.save();
      return newMetric;
    } catch (error) {
      logger.error(`Failed to create health metric record: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * Get user health metric records list
   * @param {string} userId - User ID
   * @param {Object} options - Query options
   * @returns {Promise<Object>} Health metric records list and pagination info
   */
  async getUserMetrics(userId, options = {}) {
    const {
      metricType,
      startDate,
      endDate,
      limit = 20,
      page = 1,
      sort = { recordedAt: -1 },
      nutritionProfileId
    } = options;

    // Build query conditions
    const query = { userId };
    
    if (metricType) {
      query.metricType = metricType;
    }
    
    if (startDate || endDate) {
      query.recordedAt = {};
      if (startDate) {
        query.recordedAt.$gte = new Date(startDate);
      }
      if (endDate) {
        query.recordedAt.$lte = new Date(endDate);
      }
    }
    
    if (nutritionProfileId) {
      query.nutritionProfileId = nutritionProfileId;
    }

    // Calculate pagination
    const skip = (page - 1) * limit;
    const countPromise = HealthMetric.countDocuments(query);
    const metricsPromise = HealthMetric.find(query)
      .sort(sort)
      .skip(skip)
      .limit(limit);

    // Run queries in parallel for better performance
    const [totalCount, metrics] = await Promise.all([countPromise, metricsPromise]);

    // Build pagination info
    const pagination = {
      total: totalCount,
      page,
      limit,
      pages: Math.ceil(totalCount / limit)
    };

    return { metrics, pagination };
  },

  /**
   * Get single health metric record
   * @param {string} id - Health metric record ID
   * @returns {Promise<Object>} Health metric record
   */
  async getMetricById(id) {
    try {
      const metric = await HealthMetric.findById(id);
      if (!metric) {
        throw new AppError('Health metric record not found', 404);
      }
      return metric;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('Invalid health metric ID format', 400);
      }
      logger.error(`Failed to get health metric details: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * Update health metric record
   * @param {string} id - Health metric record ID
   * @param {Object} updateData - Update data
   * @returns {Promise<Object>} Updated health metric record
   */
  async updateMetric(id, updateData) {
    try {
      // Prevent modifying user ID field
      if (updateData.userId) {
        delete updateData.userId;
      }
      
      const metric = await HealthMetric.findByIdAndUpdate(
        id,
        updateData,
        {
          new: true,
          runValidators: true
        }
      );
      
      if (!metric) {
        throw new AppError('Health metric record not found', 404);
      }
      
      return metric;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('Invalid health metric ID format', 400);
      }
      if (error.name === 'ValidationError') {
        throw new AppError('Health metric data validation failed', 400);
      }
      logger.error(`Failed to update health metric: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * Delete health metric record
   * @param {string} id - Health metric record ID
   * @returns {Promise<void>}
   */
  async deleteMetric(id) {
    try {
      const result = await HealthMetric.findByIdAndDelete(id);
      
      if (!result) {
        throw new AppError('Health metric record not found', 404);
      }
      
      return;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('Invalid health metric ID format', 400);
      }
      logger.error(`Failed to delete health metric: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * Get statistics for a specific type of health metric
   * @param {string} userId - User ID
   * @param {string} metricType - Metric type
   * @param {Object} options - Statistics options
   * @returns {Promise<Object>} Statistics results
   */
  async getMetricStats(userId, metricType, options = {}) {
    const {
      startDate,
      endDate,
      interval = 'day',
      nutritionProfileId
    } = options;

    // Build time range query
    const timeQuery = {};
    if (startDate) {
      timeQuery.$gte = new Date(startDate);
    }
    if (endDate) {
      timeQuery.$lte = new Date(endDate);
    }

    // Build basic query
    const query = {
      userId,
      metricType
    };
    
    if (Object.keys(timeQuery).length > 0) {
      query.recordedAt = timeQuery;
    }
    
    if (nutritionProfileId) {
      query.nutritionProfileId = nutritionProfileId;
    }

    // Get statistics data
    const metrics = await HealthMetric.find(query).sort({ recordedAt: 1 });
    
    // If no data found, return empty results
    if (metrics.length === 0) {
      return {
        metricType,
        dataPoints: [],
        summary: {
          count: 0,
          min: null,
          max: null,
          avg: null
        }
      };
    }

    // Calculate basic statistics
    let sum = 0;
    let min = metrics[0].value;
    let max = metrics[0].value;
    const dataPoints = [];

    // Process each data point, calculate statistics
    metrics.forEach(metric => {
      const value = parseFloat(metric.value);
      sum += value;
      
      if (value < min) min = value;
      if (value > max) max = value;
      
      dataPoints.push({
        id: metric._id,
        date: metric.recordedAt,
        value: metric.value,
        unit: metric.unit,
        notes: metric.notes
      });
    });

    return {
      metricType,
      dataPoints: dataPoints,
      summary: {
        count: metrics.length,
        min,
        max,
        avg: sum / metrics.length
      }
    };
  },

  /**
   * Batch create health metric records
   * @param {Array<Object>} metricsData - Health metric data array
   * @returns {Promise<Array<Object>>} Newly created health metric records array
   */
  async batchCreateMetrics(metricsData) {
    return await HealthMetric.insertMany(metricsData);
  },

  /**
   * Batch import health metrics
   * @param {Array} metricsData - Health metric data array
   * @returns {Promise<Object>} Import results
   */
  async batchImportMetrics(metricsData) {
    const session = await mongoose.startSession();
    try {
      session.startTransaction();
      
      const insertedMetrics = await HealthMetric.insertMany(metricsData, { session });
      
      await session.commitTransaction();
      return {
        count: insertedMetrics.length,
        metrics: insertedMetrics
      };
    } catch (error) {
      await session.abortTransaction();
      logger.error(`Failed to batch import health metrics: ${error.message}`, { error });
      throw error;
    } finally {
      session.endSession();
    }
  }
};

module.exports = healthMetricsService; 
