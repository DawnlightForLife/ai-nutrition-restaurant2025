/**
 * Optimized Consultation Market Service
 * Implements caching and query optimization for better performance
 */

const Consultation = require('../../models/consult/consultationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const mongoose = require('mongoose');
const logger = require('../../config/modules/logger');

// Simple in-memory cache for frequently accessed data
const cache = {
  marketStats: { data: null, timestamp: 0, ttl: 60000 }, // 1 minute TTL
  onlineNutritionists: { data: null, timestamp: 0, ttl: 30000 }, // 30 seconds TTL
};

const consultationMarketServiceOptimized = {
  /**
   * Get market consultations with pagination and caching
   * @param {Object} options - Filter options
   * @returns {Promise<Object>} Consultation list
   */
  async getMarketConsultations(options = {}) {
    try {
      const {
        nutritionistSpecializations = [],
        consultationType,
        priority,
        tags = [],
        minBudget,
        maxBudget,
        limit = 20,
        skip = 0,
        sort = { priority: -1, marketPublishedAt: -1 }
      } = options;

      // Build optimized query
      const query = {
        isMarketOpen: true,
        status: 'available'
      };

      // Use indexed fields for filtering
      if (consultationType) query.consultationType = consultationType;
      if (priority) query.priority = priority;
      
      // Use $in for array filters (more efficient)
      if (tags.length > 0) {
        query.tags = { $in: tags };
      }
      
      // Budget range query
      if (minBudget !== null || maxBudget !== null) {
        query.budget = {};
        if (minBudget !== null) query.budget.$gte = minBudget;
        if (maxBudget !== null) query.budget.$lte = maxBudget;
      }

      // Use lean() for better performance when we don't need Mongoose features
      const [consultations, total] = await Promise.all([
        Consultation.find(query)
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .populate({
            path: 'userId',
            select: 'username nickname avatar gender age',
            options: { lean: true }
          })
          .lean()
          .exec(),
        Consultation.countDocuments(query).exec()
      ]);

      // Post-filter for specializations if needed (in-memory filtering)
      let filteredConsultations = consultations;
      if (nutritionistSpecializations.length > 0) {
        filteredConsultations = consultations.filter(consultation => {
          if (!consultation.tags || consultation.tags.length === 0) return true;
          
          return consultation.tags.some(tag => 
            nutritionistSpecializations.some(spec => 
              spec.toLowerCase().includes(tag.toLowerCase()) ||
              tag.toLowerCase().includes(spec.toLowerCase())
            )
          );
        });
      }

      return {
        success: true,
        data: {
          consultations: filteredConsultations,
          pagination: {
            total,
            limit,
            skip,
            hasMore: total > skip + limit,
            currentPage: Math.floor(skip / limit) + 1,
            totalPages: Math.ceil(total / limit)
          }
        }
      };
    } catch (error) {
      logger.error('Optimized getMarketConsultations failed', { error, options });
      return {
        success: false,
        message: `获取咨询市场列表失败: ${error.message}`
      };
    }
  },

  /**
   * Get market stats with caching
   * @returns {Promise<Object>} Market statistics
   */
  async getMarketStats() {
    try {
      // Check cache
      const now = Date.now();
      if (cache.marketStats.data && (now - cache.marketStats.timestamp) < cache.marketStats.ttl) {
        return {
          success: true,
          data: cache.marketStats.data
        };
      }

      // Use aggregation pipeline with proper indexing
      const stats = await Consultation.aggregate([
        {
          $match: {
            isMarketOpen: true,
            status: 'available'
          }
        },
        {
          $facet: {
            overview: [
              {
                $group: {
                  _id: null,
                  totalAvailable: { $sum: 1 },
                  urgentCount: {
                    $sum: { $cond: [{ $eq: ['$priority', 'urgent'] }, 1, 0] }
                  },
                  highPriorityCount: {
                    $sum: { $cond: [{ $eq: ['$priority', 'high'] }, 1, 0] }
                  },
                  averageBudget: { $avg: '$budget' }
                }
              }
            ],
            typeBreakdown: [
              {
                $group: {
                  _id: '$consultationType',
                  count: { $sum: 1 }
                }
              }
            ],
            recentTrends: [
              {
                $match: {
                  marketPublishedAt: {
                    $gte: new Date(Date.now() - 24 * 60 * 60 * 1000) // Last 24 hours
                  }
                }
              },
              {
                $group: {
                  _id: {
                    hour: { $hour: '$marketPublishedAt' }
                  },
                  count: { $sum: 1 }
                }
              },
              {
                $sort: { '_id.hour': 1 }
              }
            ]
          }
        }
      ]).allowDiskUse(true);

      const result = stats[0];
      const overview = result.overview[0] || {
        totalAvailable: 0,
        urgentCount: 0,
        highPriorityCount: 0,
        averageBudget: 0
      };

      const typeBreakdown = {};
      result.typeBreakdown.forEach(item => {
        typeBreakdown[item._id] = item.count;
      });

      const hourlyTrends = result.recentTrends.map(item => ({
        hour: item._id.hour,
        count: item.count
      }));

      const formattedStats = {
        ...overview,
        averageBudget: overview.averageBudget ? parseFloat(overview.averageBudget.toFixed(2)) : 0,
        consultationTypeBreakdown: typeBreakdown,
        hourlyTrends
      };

      // Update cache
      cache.marketStats = {
        data: formattedStats,
        timestamp: now,
        ttl: cache.marketStats.ttl
      };

      return {
        success: true,
        data: formattedStats
      };
    } catch (error) {
      logger.error('Optimized getMarketStats failed', { error });
      return {
        success: false,
        message: `获取市场统计失败: ${error.message}`
      };
    }
  },

  /**
   * Search consultations with text index
   * @param {Object} searchOptions - Search options
   * @returns {Promise<Object>} Search results
   */
  async searchMarketConsultations(searchOptions = {}) {
    try {
      const {
        keyword,
        nutritionistSpecializations = [],
        consultationType,
        priority,
        tags = [],
        minBudget,
        maxBudget,
        sortBy = 'score',
        sortOrder = 'desc',
        limit = 20,
        skip = 0
      } = searchOptions;

      const query = {
        isMarketOpen: true,
        status: 'available'
      };

      // Use text search if keyword provided
      if (keyword) {
        query.$text = { $search: keyword };
      }

      // Add other filters
      if (consultationType) query.consultationType = consultationType;
      if (priority) query.priority = priority;
      if (tags.length > 0) query.tags = { $in: tags };
      
      if (minBudget !== null || maxBudget !== null) {
        query.budget = {};
        if (minBudget !== null) query.budget.$gte = minBudget;
        if (maxBudget !== null) query.budget.$lte = maxBudget;
      }

      // Build sort options
      let sort = {};
      if (keyword && sortBy === 'score') {
        sort = { score: { $meta: 'textScore' } };
      } else {
        sort[sortBy] = sortOrder === 'desc' ? -1 : 1;
      }

      // Execute optimized query
      let consultationQuery = Consultation.find(query);
      
      if (keyword) {
        consultationQuery = consultationQuery.select({ score: { $meta: 'textScore' } });
      }

      const [consultations, total] = await Promise.all([
        consultationQuery
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .populate({
            path: 'userId',
            select: 'username nickname avatar gender age',
            options: { lean: true }
          })
          .lean()
          .exec(),
        Consultation.countDocuments(query).exec()
      ]);

      // Post-filter for specializations
      let filteredConsultations = consultations;
      if (nutritionistSpecializations.length > 0) {
        filteredConsultations = consultations.filter(consultation => {
          if (!consultation.tags || consultation.tags.length === 0) return true;
          
          return consultation.tags.some(tag => 
            nutritionistSpecializations.some(spec => 
              spec.toLowerCase().includes(tag.toLowerCase()) ||
              tag.toLowerCase().includes(spec.toLowerCase())
            )
          );
        });
      }

      return {
        success: true,
        data: {
          consultations: filteredConsultations,
          pagination: {
            total,
            limit,
            skip,
            hasMore: total > skip + limit,
            currentPage: Math.floor(skip / limit) + 1,
            totalPages: Math.ceil(total / limit)
          }
        }
      };
    } catch (error) {
      logger.error('Optimized searchMarketConsultations failed', { error, searchOptions });
      return {
        success: false,
        message: `搜索失败: ${error.message}`
      };
    }
  },

  /**
   * Get online nutritionists with caching
   * @returns {Promise<Array>} Online nutritionists
   */
  async getOnlineNutritionists() {
    try {
      // Check cache
      const now = Date.now();
      if (cache.onlineNutritionists.data && (now - cache.onlineNutritionists.timestamp) < cache.onlineNutritionists.ttl) {
        return cache.onlineNutritionists.data;
      }

      // Query with specific fields to reduce data transfer
      const nutritionists = await Nutritionist.find({
        'onlineStatus.isOnline': true,
        'onlineStatus.isAvailable': true,
        'verification.verificationStatus': 'approved',
        status: 'active'
      })
      .select('personalInfo.realName personalInfo.avatar professionalInfo.specializations onlineStatus')
      .lean()
      .exec();

      // Update cache
      cache.onlineNutritionists = {
        data: nutritionists,
        timestamp: now,
        ttl: cache.onlineNutritionists.ttl
      };

      return nutritionists;
    } catch (error) {
      logger.error('Failed to get online nutritionists', { error });
      return [];
    }
  },

  /**
   * Clear cache (for admin use or scheduled jobs)
   */
  clearCache() {
    cache.marketStats = { data: null, timestamp: 0, ttl: 60000 };
    cache.onlineNutritionists = { data: null, timestamp: 0, ttl: 30000 };
    logger.info('Consultation market cache cleared');
  }
};

// Re-export other methods from original service
const originalService = require('./consultationMarketService');
module.exports = {
  ...originalService,
  ...consultationMarketServiceOptimized
};