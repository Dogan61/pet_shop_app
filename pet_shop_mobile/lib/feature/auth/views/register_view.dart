import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/feature/auth/controller/register_controller.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/feature/auth/validation/register_validator.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/auth/mixins/login_mixin.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with LoginMixin {
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
          body: Center(child: Text(UIConstants.localizationsNotAvailable)));
    }
    return BlocProvider(
      create: (context) => di.sl<AuthCubit>(),
      child: Scaffold(
        appBar: BackAppBar(
          onBackPressed: _controller.onBackPressed(context),
        ),
        body: SingleChildScrollView(
        padding: AppDimensionsPadding.onlyLeftRightSmall(context),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              AppDimensionsSpacing.verticalMedium(context),

              /// AVATAR
              CircleAvatar(
                radius: AppDimensionsSize.avatarSize(context) / 2,
                backgroundImage: const NetworkImage(
                  LoginConstants.registerAvatarImage,
                ),
              ),
              AppDimensionsSpacing.verticalMedium(context),

              /// TITLE
              Text(
                l10n.createAccount,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              AppDimensionsSpacing.verticalExtraSmall(context),

              /// SUBTITLE
              Text(
                l10n.theBestForYourPets,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              AppDimensionsSpacing.verticalLarge(context),

              /// NAME + SURNAME
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      controller: _controller.firstNameController,
                      hint: l10n.firstName,
                      icon: Icons.person,
                      validator: (value) =>
                          RegisterValidator.validateFirstName(value, context),
                    ),
                  ),
                  AppDimensionsSpacing.horizontalSmall(context),
                  Expanded(
                    child: _InputField(
                      controller: _controller.lastNameController,
                      hint: l10n.lastName,
                      icon: Icons.person_outline,
                      validator: (value) =>
                          RegisterValidator.validateLastName(value, context),
                    ),
                  ),
                ],
              ),
              AppDimensionsSpacing.verticalSmall(context),

              /// EMAIL
              _InputField(
                controller: _controller.emailController,
                hint: l10n.exampleEmail,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    RegisterValidator.validateEmail(value, context),
              ),
              AppDimensionsSpacing.verticalSmall(context),

              /// PASSWORD
              _InputField(
                controller: _controller.passwordController,
                hint: l10n.password,
                icon: Icons.lock,
                isPassword: true,
                obscureText: _controller.obscurePassword,
                onVisibilityToggle: () {
                  setState(() {
                    _controller.togglePasswordVisibility();
                  });
                },
                validator: (value) =>
                    RegisterValidator.validatePassword(value, context),
              ),
              AppDimensionsSpacing.verticalLarge(context),

              /// REGISTER BUTTON
              _CustomRegisterButton(
                controller: _controller,
                l10n: l10n,
              ),
              AppDimensionsSpacing.verticalMedium(context),

              /// DIVIDER
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: AppDimensionsPadding.symmetricHorizontalExtraSmall(
                        context),
                    child: Text(l10n.or),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              AppDimensionsSpacing.verticalMedium(context),

              /// GOOGLE BUTTON
              _SocialButton(
                text: l10n.signUpWithGoogle,
                borderColor: LoginConstants.grey300,
                onPressed: () async {
                  final error = await handleGoogleSignIn(context);
                  if (error != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              AppDimensionsSpacing.verticalSmall(context),

              /// FACEBOOK BUTTON
              _SocialButton(
                text: l10n.signUpWithFacebook,
                backgroundColor: LoginConstants.facebookColor,
                textColor: LoginConstants.white,
                onPressed: () async {
                  final error = await handleFacebookSignIn(context);
                  if (error != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              AppDimensionsSpacing.verticalLarge(context),

              /// FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAnAccount),
                  GestureDetector(
                    onTap: () => context.go(LoginConstants.loginRoute),
                    child: Text(
                      l10n.signIn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: LoginConstants.registerLinkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _CustomRegisterButton extends StatelessWidget {
  const _CustomRegisterButton({
    required RegisterController controller,
    required this.l10n,
  }) : _controller = controller;

  final RegisterController _controller;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Show success/error messages
        if (state is AuthRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n?.registrationSuccessful ??
                    LoginConstants.registrationSuccessfulFallback,
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to home after successful registration
          Future.microtask(() {
            if (context.mounted) {
              context.go(LoginConstants.homeRoute);
            }
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        
        return SizedBox(
          width: double.infinity,
          height: AppDimensionsSize.buttonHeight(context),
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (!_controller.formKey.currentState!.validate()) {
                      return;
                    }
                    if (RegisterValidator.validateRegisterForm(
                      firstName: _controller.firstName,
                      lastName: _controller.lastName,
                      email: _controller.email,
                      password: _controller.password,
                      context: context,
                    )) {
                      // Call backend API for registration
                      final fullName =
                          '${_controller.firstName} ${_controller.lastName}';
                      context.read<AuthCubit>().register(
                            RegisterRequestModel(
                              fullName: fullName,
                              email: _controller.email,
                              password: _controller.password,
                            ),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: LoginConstants.registerButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: AppDimensionsRadius.circularExtraLarge(context),
              ),
              disabledBackgroundColor: LoginConstants.grey300,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Text(
                    l10n?.signUp ?? LoginConstants.signUpFallback,
                    style: TextStyle(
                      fontSize: AppDimensionsFontSize.medium(context),
                      fontWeight: FontWeight.w600,
                      color: LoginConstants.black,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onVisibilityToggle,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword && onVisibilityToggle != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: LoginConstants.lightBackground,
        border: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.red,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: LoginConstants.red,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.onPressed,
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensionsSize.buttonHeight(context),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: AppDimensionsSpacing.small(context)),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? LoginConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
