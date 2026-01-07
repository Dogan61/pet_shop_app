/**
 * Send success response
 * @param {Object} res - Express response object
 * @param {Object} data - Response data
 * @param {string} [message] - Success message
 * @param {number} [statusCode=200] - HTTP status code
 */
const sendSuccess = (res, data, message = null, statusCode = 200) => {
  const response = {
    success: true,
    data,
  };

  if (message) {
    response.message = message;
  }

  res.status(statusCode).json(response);
};

/**
 * Send error response
 * @param {Object} res - Express response object
 * @param {string} message - Error message
 * @param {string} [errorCode] - Error code
 * @param {number} [statusCode=400] - HTTP status code
 */
const sendError = (res, message, errorCode = null, statusCode = 400) => {
  const response = {
    success: false,
    message,
  };

  if (errorCode) {
    response.error = errorCode;
  }

  res.status(statusCode).json(response);
};

/**
 * Send validation error response
 * @param {Object} res - Express response object
 * @param {string} message - Validation error message
 */
const sendValidationError = (res, message) => {
  sendError(res, message, 'VALIDATION_ERROR', 400);
};

/**
 * Send not found error response
 * @param {Object} res - Express response object
 * @param {string} message - Not found message
 */
const sendNotFound = (res, message = 'Resource not found') => {
  sendError(res, message, null, 404);
};

/**
 * Send unauthorized error response
 * @param {Object} res - Express response object
 * @param {string} message - Unauthorized message
 */
const sendUnauthorized = (res, message = 'Unauthorized') => {
  sendError(res, message, 'UNAUTHORIZED', 401);
};

/**
 * Send forbidden error response
 * @param {Object} res - Express response object
 * @param {string} message - Forbidden message
 */
const sendForbidden = (res, message = 'Forbidden') => {
  sendError(res, message, 'FORBIDDEN', 403);
};

/**
 * Send server error response
 * @param {Object} res - Express response object
 * @param {string} message - Server error message
 * @param {string} [errorCode] - Error code
 */
const sendServerError = (res, message = 'Internal server error', errorCode = 'INTERNAL_ERROR') => {
  sendError(res, message, errorCode, 500);
};

module.exports = {
  sendSuccess,
  sendError,
  sendValidationError,
  sendNotFound,
  sendUnauthorized,
  sendForbidden,
  sendServerError,
};

