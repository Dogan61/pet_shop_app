import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_shop_app/core/config/app_config.dart';
import 'package:pet_shop_app/core/data/datasources/admin_data_source.dart';
import 'package:pet_shop_app/core/data/datasources/auth_data_source.dart';
import 'package:pet_shop_app/core/data/datasources/favorite_data_source.dart';
import 'package:pet_shop_app/core/data/datasources/pet_data_source.dart';
import 'package:pet_shop_app/core/data/datasources/user_data_source.dart';
import 'package:pet_shop_app/core/data/repositories/admin_repository.dart';
import 'package:pet_shop_app/core/data/repositories/auth_repository.dart';
import 'package:pet_shop_app/core/data/repositories/favorite_repository.dart';
import 'package:pet_shop_app/core/data/repositories/pet_repository.dart';
import 'package:pet_shop_app/core/data/repositories/user_repository.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/user/bloc/user_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! External
  sl..registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.apiBaseUrl}/api',
        connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor (disabled for production)
    // dio.interceptors.add(
    //   LogInterceptor(
    //     requestBody: true,
    //     responseBody: true,
    //   ),
    // );

    return dio;
  })

  //! Data Sources
  ..registerLazySingleton<PetDataSource>(() => PetDataSourceImpl(dio: sl()))

  ..registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(dio: sl()))

  ..registerLazySingleton<FavoriteDataSource>(
    () => FavoriteDataSourceImpl(dio: sl()),
  )

  ..registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(dio: sl()))

  ..registerLazySingleton<AdminDataSource>(
    () => AdminDataSourceImpl(dio: sl()),
  )

  //! Repositories
  ..registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(dataSource: sl()),
  )

  ..registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  )

  ..registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(dataSource: sl()),
  )

  ..registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(dataSource: sl()),
  )

  ..registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(dataSource: sl()),
  )

  //! Bloc/Cubit
  ..registerFactory<PetCubit>(() => PetCubit(repository: sl()))

  // AuthCubit should be singleton to maintain state across navigation
  ..registerLazySingleton<AuthCubit>(() => AuthCubit(repository: sl()))

  ..registerFactory<FavoriteCubit>(() => FavoriteCubit(repository: sl()))

  ..registerFactory<UserCubit>(() => UserCubit(repository: sl()))

  ..registerFactory<AdminCubit>(() => AdminCubit(repository: sl()));
}
