/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String loginWithGoogle = '/auth/google';
  static const String loginWithFacebook = '/auth/facebook';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // Pet endpoints
  static const String pets = '/pets';
  static String petById(String id) => '/pets/$id';
  static String petsByCategory(String category) => '/pets/category/$category';

  // Favorite endpoints
  static const String favorites = '/favorites';
  static String favoriteById(String id) => '/favorites/$id';

  // User endpoints
  static const String userProfile = '/users/profile';

  // Admin endpoints
  static const String adminCheck = '/admin/check';
}

/// API Response Keys
class ApiResponseKeys {
  ApiResponseKeys._();

  static const String success = 'success';
  static const String data = 'data';
  static const String message = 'message';
  static const String pagination = 'pagination';
  static const String count = 'count';
}

/// HTTP Headers
class ApiHeaders {
  ApiHeaders._();

  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';

  static const String applicationJson = 'application/json';

  static String bearerToken(String token) => 'Bearer $token';
}

/// Default Error Messages
class ApiErrorMessages {
  ApiErrorMessages._();

  static const String networkError = 'Network error';
  static const String unknownError = 'An unknown error occurred';
  static const String failedToFetch = 'Failed to fetch data';
  static const String failedToCreate = 'Failed to create';
  static const String failedToUpdate = 'Failed to update';
  static const String failedToDelete = 'Failed to delete';
}
