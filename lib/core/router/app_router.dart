import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/feature/favorites/favorites_view.dart';
import 'package:pet_shop_app/feature/home/home_view.dart';
import 'package:pet_shop_app/feature/home/pet_detail_view.dart';
import 'package:pet_shop_app/feature/login/login_view.dart';
import 'package:pet_shop_app/feature/login/register_view.dart';
import 'package:pet_shop_app/feature/profile/profile_view.dart';

/// Application router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Authentication Routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterView(),
    ),

    // Main Navigation Routes
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesView(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileView(),
    ),

    // Detail Routes
    GoRoute(
      path: '/pet-detail/:index',
      name: 'pet-detail',
      builder: (context, state) {
        final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
        return PetDetailView(index: index);
      },
    ),
  ],
);
