import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_shop_app/core/data/repositories/pet_repository.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_state.dart';
import 'package:pet_shop_app/feature/pet_detail/models/pet_model.dart';

// Mock classes
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  group('PetCubit', () {
    late PetCubit petCubit;
    late MockPetRepository mockRepository;

    final mockPet = PetModel(
      id: '1',
      name: 'Buddy',
      breed: 'Golden Retriever',
      age: '2 years',
      gender: 'Male',
      weight: '25 kg',
      color: 'Golden',
      location: 'Istanbul',
      distance: '5 km',
      price: 1000.0,
      imageUrl: 'https://example.com/image.jpg',
      description: 'A friendly dog',
      category: 'dogs',
    );

    setUp(() {
      mockRepository = MockPetRepository();
      petCubit = PetCubit(repository: mockRepository);
    });

    tearDown(() {
      petCubit.close();
    });

    test('initial state is PetInitial', () {
      expect(petCubit.state, isA<PetInitial>());
    });

    group('getAllPets', () {
      blocTest<PetCubit, PetState>(
        'emits [PetLoading, PetLoaded] when getAllPets succeeds',
        build: () {
          when(() => mockRepository.getAllPets(
                category: any(named: 'category'),
                page: any(named: 'page'),
                limit: any(named: 'limit'),
              )).thenAnswer(
            (_) async => ApiResponseModel<List<PetModel>>(
              success: true,
              data: [mockPet],
              message: 'Pets retrieved successfully',
              pagination: {'total': 1, 'page': 1, 'pages': 1},
            ),
          );
          return petCubit;
        },
        act: (cubit) => cubit.getAllPets(),
        expect: () => [
          const PetLoading(),
          PetLoaded(
            pets: [mockPet],
            totalCount: 1,
            currentPage: 1,
            totalPages: 1,
          ),
        ],
      );

      blocTest<PetCubit, PetState>(
        'emits [PetLoading, PetError] when getAllPets fails',
        build: () {
          when(() => mockRepository.getAllPets(
                category: any(named: 'category'),
                page: any(named: 'page'),
                limit: any(named: 'limit'),
              )).thenAnswer(
            (_) async => const ApiResponseModel<List<PetModel>>(
              success: false,
              message: 'Failed to load pets',
            ),
          );
          return petCubit;
        },
        act: (cubit) => cubit.getAllPets(),
        expect: () => [
          const PetLoading(),
          const PetError(message: 'Failed to load pets'),
        ],
      );
    });

    group('getPetById', () {
      blocTest<PetCubit, PetState>(
        'emits [PetLoading, PetDetailLoaded] when getPetById succeeds',
        build: () {
          when(() => mockRepository.getPetById('1')).thenAnswer(
            (_) async => ApiResponseModel<PetModel>(
              success: true,
              data: mockPet,
              message: 'Pet retrieved successfully',
            ),
          );
          return petCubit;
        },
        act: (cubit) => cubit.getPetById('1'),
        expect: () => [
          const PetLoading(),
          PetDetailLoaded(pet: mockPet),
        ],
      );

      blocTest<PetCubit, PetState>(
        'emits [PetLoading, PetError] when getPetById fails',
        build: () {
          when(() => mockRepository.getPetById('1')).thenAnswer(
            (_) async => const ApiResponseModel<PetModel>(
              success: false,
              message: 'Pet not found',
            ),
          );
          return petCubit;
        },
        act: (cubit) => cubit.getPetById('1'),
        expect: () => [
          const PetLoading(),
          const PetError(message: 'Pet not found'),
        ],
      );
    });
  });
}

