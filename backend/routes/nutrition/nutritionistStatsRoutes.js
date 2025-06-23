const express = require('express');
const router = express.Router();
const nutritionistStatsController = require('../../controllers/nutrition/nutritionistStatsController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const { permissionMiddleware } = require('../../middleware/auth/permissionMiddleware');

router.get('/overview/:nutritionistId', 
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistStats
);

router.get('/income/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistIncome
);

router.get('/reviews/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistReviews
);

router.get('/performance/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistPerformanceOverview
);

router.get('/clients/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistClientAnalysis
);

router.get('/work-time/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getNutritionistWorkTimeAnalysis
);

router.post('/report/:nutritionistId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.exportNutritionistReport
);

router.get('/report-status/:reportId',
  authenticateUser,
  permissionMiddleware(['nutritionist:stats:read', 'admin:all']),
  nutritionistStatsController.getReportStatus
);

module.exports = router;