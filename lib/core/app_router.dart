import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/feature/login/login_view.dart';
import 'package:pet_shop_app/feature/register/register_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) =>  LoginView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) =>  RegisterView(),
    ),
  ],
);
