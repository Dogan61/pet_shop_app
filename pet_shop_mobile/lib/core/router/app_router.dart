import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/feature/admin/dashboard/admin_dashboard_view.dart';
import 'package:pet_shop_app/feature/admin/login/admin_login_view.dart';
import 'package:pet_shop_app/feature/admin/pets/admin_pet_form_view.dart';
import 'package:pet_shop_app/feature/admin/pets/admin_pets_list_view.dart';
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
      path: '/pet-detail/:id',
      name: 'pet-detail',
      builder: (context, state) {
        final petId = state.pathParameters['id'] ?? '';
        return PetDetailView(petId: petId);
      },
    ),

    // Admin Routes
    GoRoute(
      path: '/admin/login',
      name: 'admin-login',
      builder: (context, state) => const AdminLoginView(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      builder: (context, state) => const AdminDashboardView(),
    ),
    GoRoute(
      path: '/admin/pets',
      name: 'admin-pets',
      builder: (context, state) => const AdminPetsListView(),
    ),
    GoRoute(
      path: '/admin/pets/add',
      name: 'admin-pets-add',
      builder: (context, state) => const AdminPetFormView(),
    ),
    GoRoute(
      path: '/admin/pets/edit/:id',
      name: 'admin-pets-edit',
      builder: (context, state) {
        final petId = state.pathParameters['id'] ?? '';
        return AdminPetFormView(petId: petId);
      },
    ),
  ],
);
