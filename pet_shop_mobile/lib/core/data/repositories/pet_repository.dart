import 'package:pet_shop_app/core/data/datasources/pet_data_source.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/pet_detail/models/pet_model.dart';

abstract class PetRepository {
  Future<ApiResponseModel<List<PetModel>>> getAllPets({
    String? category,
    int page = 1,
    int limit = 10,
  });
  Future<ApiResponseModel<PetModel>> getPetById(String id);
  Future<ApiResponseModel<List<PetModel>>> getPetsByCategory(String category);
  Future<ApiResponseModel<PetModel>> createPet(PetModel pet, String token);
  Future<ApiResponseModel<PetModel>> updatePet(
    String id,
    PetModel pet,
    String token,
  );
  Future<ApiResponseModel<void>> deletePet(String id, String token);
}

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl({required this.dataSource});
  final PetDataSource dataSource;

  @override
  Future<ApiResponseModel<List<PetModel>>> getAllPets({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    return dataSource.getAllPets(category: category, page: page, limit: limit);
  }

  @override
  Future<ApiResponseModel<PetModel>> getPetById(String id) async {
    return dataSource.getPetById(id);
  }

  @override
  Future<ApiResponseModel<List<PetModel>>> getPetsByCategory(
    String category,
  ) async {
    return dataSource.getPetsByCategory(category);
  }

  @override
  Future<ApiResponseModel<PetModel>> createPet(
    PetModel pet,
    String token,
  ) async {
    return dataSource.createPet(pet, token);
  }

  @override
  Future<ApiResponseModel<PetModel>> updatePet(
    String id,
    PetModel pet,
    String token,
  ) async {
    return dataSource.updatePet(id, pet, token);
  }

  @override
  Future<ApiResponseModel<void>> deletePet(String id, String token) async {
    return dataSource.deletePet(id, token);
  }
}
