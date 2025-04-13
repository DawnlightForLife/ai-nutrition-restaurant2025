/**
 * Error handling utility
 * Provides consistent error handling functions for API controllers
 * @module utils/errorHandler
 */
const logger = require('./logger');

/**
 * Handle API errors and send appropriate response
 * @param {Object} res - Express response object
 * @param {Error} error - Error object
 * @param {number} statusCode - HTTP status code (default: 500)
 * @returns {Object} JSON response with error details
 */
exports.handleError = (res, error, statusCode = 500) => {
  // Log the error with details
  console.error(`API error: ${error.message}`, error);
  
  // Send the response
  return res.status(statusCode).json({
    success: false,
    message: error.message || 'Internal server error',
    // Only include detailed error info in development
    error: process.env.NODE_ENV === 'production' ? {} : error
  });
};

/**
 * Handle validation errors from Joi or Mongoose
 * @param {Object} res - Express response object
 * @param {Error} error - Validation error object
 * @returns {Object} JSON response with validation error details
 */
exports.handleValidationError = (res, error) => {
  console.warn(`Validation error: ${error.message}`, error);
  
  // Extract meaningful message from different validation libraries
  let errorMessage = error.message;
  let errorDetails = {};
  
  // Handle Joi validation errors
  if (error.details && Array.isArray(error.details)) {
    errorMessage = error.details[0].message;
    errorDetails = error.details;
  }
  
  // Handle Mongoose validation errors
  if (error.errors) {
    errorMessage = Object.values(error.errors)
      .map(err => err.message)
      .join(', ');
    errorDetails = error.errors;
  }
  
  return res.status(400).json({
    success: false,
    message: errorMessage,
    error: errorDetails
  });
};

/**
 * Handle not found errors
 * @param {Object} res - Express response object
 * @param {string} message - Custom not found message
 * @returns {Object} JSON response with not found details
 */
exports.handleNotFound = (res, message = 'Resource not found') => {
  return res.status(404).json({
    success: false,
    message: message
  });
};

/**
 * Handle unauthorized errors
 * @param {Object} res - Express response object
 * @param {string} message - Custom unauthorized message
 * @returns {Object} JSON response with unauthorized details
 */
exports.handleUnauthorized = (res, message = 'Unauthorized access') => {
  return res.status(401).json({
    success: false,
    message: message
  });
};

/**
 * Handle forbidden errors
 * @param {Object} res - Express response object
 * @param {string} message - Custom forbidden message
 * @returns {Object} JSON response with forbidden details
 */
exports.handleForbidden = (res, message = 'Access forbidden') => {
  return res.status(403).json({
    success: false,
    message: message
  });
}; 