/**
 * Health Metrics Routes
 */
const express = require('express');
const router = express.Router();
const healthMetricsController = require('../../controllers/health/healthMetricsController');
const authMiddleware = require('../../middleware/auth/authMiddleware');

// User authentication middleware
router.use(authMiddleware.authenticate);

/**
 * @route POST /api/health/metrics
 * @desc Create a single health metric record
 * @access Private
 */
router.post('/', healthMetricsController.createMetric);

/**
 * @route GET /api/health/metrics
 * @desc Get user health metrics list
 * @access Private
 */
router.get('/', healthMetricsController.getUserMetrics);

/**
 * @route GET /api/health/metrics/:id
 * @desc Get a single health metric details
 * @access Private
 */
router.get('/:id', healthMetricsController.getMetricById);

/**
 * @route PUT /api/health/metrics/:id
 * @desc Update a health metric
 * @access Private
 */
router.put('/:id', healthMetricsController.updateMetric);

/**
 * @route DELETE /api/health/metrics/:id
 * @desc Delete a health metric
 * @access Private
 */
router.delete('/:id', healthMetricsController.deleteMetric);

/**
 * @route GET /api/health/metrics/stats/:metricType
 * @desc Get health metric statistics
 * @access Private
 */
router.get('/stats/:metricType', healthMetricsController.getMetricStats);

/**
 * @route POST /api/health/metrics/batch-import
 * @desc Batch import health metrics
 * @access Private
 */
router.post('/batch-import', healthMetricsController.batchImportMetrics);

module.exports = router; 