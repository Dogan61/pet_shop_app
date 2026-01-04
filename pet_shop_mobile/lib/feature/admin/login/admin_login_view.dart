import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/controller/login_controller.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/core/validation/login_validator.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_cubit.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_state.dart';
import 'package:pet_shop_app/feature/admin/login/mixins/admin_login_mixin.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> with AdminLoginMixin {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: Text(UIConstants.localizationsNotAvailable)),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(create: (context) => di.sl<AdminCubit>()),
      ],
      child: BlocListener<AdminCubit, AdminState>(
        listener: handleAdminState,
        child: Scaffold(
          appBar: const EmptyAppBar(),
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              handleAuthState(context, state);
              if (state is AuthAuthenticated) {
                // Check admin status after login
                context.read<AdminCubit>().checkAdmin(state.token);
              }
            },
            builder: (context, state) {
              final authState = context.watch<AuthCubit>().state;
              final adminState = context.watch<AdminCubit>().state;
              final isLoading =
                  authState is AuthLoading || adminState is AdminLoading;

              return SingleChildScrollView(
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      AppDimensionsSpacing.verticalLarge(context),

                      /// Admin Icon
                      Center(
                        child: Container(
                          width: AppDimensionsSize.logoSize(context),
                          height: AppDimensionsSize.logoSize(context),
                          decoration: BoxDecoration(
                            color: LoginConstants.primaryColor.withOpacity(0.1),
                            borderRadius: AppDimensionsRadius.circularMedium(
                              context,
                            ),
                            border: Border.all(
                              color: LoginConstants.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            AdminConstants.dashboardIcon,
                            size: 60,
                            color: AdminConstants.primaryColor,
                          ),
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      /// Title
                      Text(
                        AdminConstants.adminLoginTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AdminConstants.primaryColor,
                        ),
                      ),

                      AppDimensionsSpacing.verticalExtraSmall(context),

                      /// Subtitle
                      Text(
                        AdminConstants.adminLoginSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      AppDimensionsSpacing.verticalExtraLarge(context),

                      /// Form
                      Padding(
                        padding: AppDimensionsPadding.symmetricHorizontalLarge(
                          context,
                        ),
                        child: Column(
                          children: [
                            _AdminLoginTextField(
                              controller: _controller.emailController,
                              hintText: l10n.enterYourEmail,
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  LoginValidator.validateEmail(value, context),
                            ),
                            AppDimensionsSpacing.verticalSmall(context),
                            _AdminLoginTextField(
                              controller: _controller.passwordController,
                              hintText: l10n.password,
                              icon: Icons.lock,
                              visibilityIcon: _controller.obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              obscureText: _controller.obscurePassword,
                              onVisibilityToggle: () {
                                setState(() {
                                  _controller.togglePasswordVisibility();
                                });
                              },
                              validator: (value) =>
                                  LoginValidator.validatePassword(
                                    value,
                                    context,
                                  ),
                            ),

                            AppDimensionsSpacing.verticalLarge(context),

                            /// Login Button
                            SizedBox(
                              width: double.infinity,
                              height: AppDimensionsSize.buttonHeight(context),
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => handleLogin(
                                        context,
                                        _controller.formKey,
                                        _controller.email,
                                        _controller.password,
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: LoginConstants.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        AppDimensionsRadius.circularExtraLarge(
                                          context,
                                        ),
                                  ),
                                  disabledBackgroundColor:
                                      LoginConstants.grey300,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AdminConstants.signInButton,
                                            style: TextStyle(
                                              fontSize:
                                                  AppDimensionsFontSize.medium(
                                                    context,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                              color: AdminConstants.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                AppDimensionsSpacing.extraSmall(
                                                  context,
                                                ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: LoginConstants.white,
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            AppDimensionsSpacing.verticalLarge(context),

                            /// Back to regular login
                            TextButton(
                              onPressed: () => navigateToUserLogin(context),
                              child: const Text(
                                AdminConstants.backToUserLogin,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdminLoginTextField extends StatelessWidget {
  const _AdminLoginTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.visibilityIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onVisibilityToggle,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final IconData? visibilityIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onVisibilityToggle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: LoginConstants.primaryColor),
        suffixIcon: visibilityIcon != null && onVisibilityToggle != null
            ? IconButton(
                icon: Icon(visibilityIcon),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: LoginConstants.lightBackground,
        contentPadding: EdgeInsets.symmetric(
          vertical: AppDimensionsPadding.medium(context),
          horizontal: AppDimensionsPadding.large(context),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.lightGreen,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.primaryColor,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.red,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.red,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
      ),
    );
  }
}
