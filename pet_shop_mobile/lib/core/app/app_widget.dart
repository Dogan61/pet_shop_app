import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/app/auth_redirect_listener.dart';
import 'package:pet_shop_app/core/app/localization_config.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/core/router/app_router.dart';
import 'package:pet_shop_app/core/theme/app_theme.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';

/// Main app widget
class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();

  static _AppWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppWidgetState>();
}

class _AppWidgetState extends State<AppWidget> {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AuthCubit>(),
      child: AuthRedirectListener(
        child: MaterialApp.router(
          title: 'Pet Shop App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerConfig: appRouter,
          locale: _locale,
          localizationsDelegates: LocalizationConfig.delegates,
          supportedLocales: LocalizationConfig.supportedLocales,
        ),
      ),
    );
  }
}
