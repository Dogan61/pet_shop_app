/**
 * Handle Firebase Auth errors
 * @param {Error} error - Firebase error object
 * @param {Object} res - Express response object
 * @returns {boolean} True if error was handled, false otherwise
 */
const handleFirebaseAuthError = (error, res) => {
  if (!error.code) {
    return false;
  }

  const errorMap = {
    'auth/email-already-exists': {
      message: 'This email is already registered',
      error: 'EMAIL_ALREADY_EXISTS',
      status: 400,
    },
    'auth/invalid-email': {
      message: 'Invalid email address format',
      error: 'INVALID_EMAIL',
      status: 400,
    },
    'auth/weak-password': {
      message: 'Password must be at least 6 characters long',
      error: 'WEAK_PASSWORD',
      status: 400,
    },
    'auth/user-not-found': {
      message: 'Invalid email or password',
      error: 'INVALID_CREDENTIALS',
      status: 401,
    },
    'auth/invalid-credential': {
      message: 'Invalid email or password',
      error: 'INVALID_CREDENTIALS',
      status: 401,
    },
  };

  const errorInfo = errorMap[error.code];
  if (errorInfo) {
    res.status(errorInfo.status).json({
      success: false,
      message: errorInfo.message,
      error: errorInfo.error,
    });
    return true;
  }

  return false;
};

/**
 * Handle Firebase REST API errors
 * @param {Error} apiError - Axios error object
 * @param {Object} res - Express response object
 * @returns {boolean} True if error was handled, false otherwise
 */
const handleFirebaseRestApiError = (apiError, res) => {
  if (!apiError.response || !apiError.response.data) {
    return false;
  }

  const errorData = apiError.response.data;
  if (!errorData.error) {
    return false;
  }

  const errorCode = errorData.error.message;

  if (errorCode.includes('INVALID_PASSWORD') || errorCode.includes('EMAIL_NOT_FOUND')) {
    res.status(401).json({
      success: false,
      message: 'Invalid email or password',
      error: 'INVALID_CREDENTIALS',
    });
    return true;
  }

  if (errorCode.includes('USER_DISABLED')) {
    res.status(403).json({
      success: false,
      message: 'Your account has been disabled. Please contact support.',
      error: 'USER_DISABLED',
    });
    return true;
  }

  if (errorCode.includes('TOO_MANY_ATTEMPTS_TRY_LATER')) {
    res.status(429).json({
      success: false,
      message: 'Too many failed login attempts. Please try again later.',
      error: 'TOO_MANY_ATTEMPTS',
    });
    return true;
  }

  return false;
};

module.exports = {
  handleFirebaseAuthError,
  handleFirebaseRestApiError,
};

