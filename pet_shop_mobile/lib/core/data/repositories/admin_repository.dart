import 'package:pet_shop_app/core/data/datasources/admin_data_source.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';

abstract class AdminRepository {
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(String token);
  Future<ApiResponseModel<Map<String, dynamic>>> setAdmin(
    String email,
    String token,
  );
  Future<ApiResponseModel<Map<String, dynamic>>> removeAdmin(
    String email,
    String token,
  );
  Future<ApiResponseModel<List<Map<String, dynamic>>>> getAdmins(String token);
}

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl({required this.dataSource});
  final AdminDataSource dataSource;

  @override
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(
    String token,
  ) async {
    return dataSource.checkAdmin(token);
  }

  @override
  Future<ApiResponseModel<Map<String, dynamic>>> setAdmin(
    String email,
    String token,
  ) async {
    return dataSource.setAdmin(email, token);
  }

  @override
  Future<ApiResponseModel<Map<String, dynamic>>> removeAdmin(
    String email,
    String token,
  ) async {
    return dataSource.removeAdmin(email, token);
  }

  @override
  Future<ApiResponseModel<List<Map<String, dynamic>>>> getAdmins(
    String token,
  ) async {
    return dataSource.getAdmins(token);
  }
}
