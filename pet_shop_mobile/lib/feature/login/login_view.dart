import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/image_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/controller/login_controller.dart';
import 'package:pet_shop_app/core/validation/login_validator.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/core/widgets/language_selector.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/login/mixins/login_mixin.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';
import 'package:pet_shop_app/main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginMixin {
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
    final appState = MyApp.of(context);
    final currentLocale = appState?.locale ?? const Locale('en');

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        print(
          '🔔 [LoginView] Top-level listener triggered with state: ${state.runtimeType}',
        );
        handleAuthState(context, state, l10n);
      },
      child: Scaffold(
        appBar: const EmptyAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _controller.formKey,
                child: Column(
                  children: [
                    AppDimensionsSpacing.verticalLarge(context),

                    /// Logo
                    Center(
                      child: Container(
                        width: AppDimensionsSize.logoSize(context),
                        height: AppDimensionsSize.logoSize(context),
                        decoration: BoxDecoration(
                          borderRadius: AppDimensionsRadius.circularMedium(
                            context,
                          ),
                          border: Border.all(color: LoginConstants.grey300),
                          image: const DecorationImage(
                            image: NetworkImage(
                              LoginConstants.loginImageHeader,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    AppDimensionsSpacing.verticalLarge(context),

                    /// Welcome text
                    CustomWelcomeText(welcomeText: l10n.welcome, theme: theme),

                    AppDimensionsSpacing.verticalExtraSmall(context),

                    Text(
                      l10n.signInToYourAccountToContinue,
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
                          CustomLoginTextField(
                            controller: _controller.emailController,
                            customHintText: l10n.enterYourEmail,
                            customIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                LoginValidator.validateEmail(value, context),
                          ),
                          AppDimensionsSpacing.verticalSmall(context),
                          CustomLoginTextField(
                            controller: _controller.passwordController,
                            customHintText: l10n.password,
                            customIcon: Icons.lock,
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
                                LoginValidator.validatePassword(value, context),
                          ),

                          /// Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  AppDimensionsPadding.symmetricVerticalMedium(
                                    context,
                                  ),
                              child: Text(
                                l10n.forgotPassword,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          /// Login button
                          _CustomLoginButton(
                            controller: _controller,
                            l10n: l10n,
                            onLogin: () => handleLogin(
                              context,
                              _controller.formKey,
                              _controller.email,
                              _controller.password,
                            ),
                          ),

                          AppDimensionsSpacing.verticalLarge(context),

                          /// Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: LoginConstants.lightGreen,
                                  thickness: AppDimensionsBorderWidth.thin(
                                    context,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    AppDimensionsPadding.symmetricHorizontalSmall(
                                      context,
                                    ),
                                child: Text(
                                  l10n.orContinueWith,
                                  style: const TextStyle(
                                    color: LoginConstants.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: LoginConstants.lightGreen,
                                  thickness: AppDimensionsBorderWidth.thin(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: AppDimensionsPadding.allMedium(context),
                      child: Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              text: l10n.google,
                              iconAsset: ImageConstants.imageGoogleIcon,
                              onPressed: () => handleGoogleSignIn(context),
                            ),
                          ),
                          AppDimensionsSpacing.horizontalSmall(context),
                          Expanded(
                            child: SocialLoginButton(
                              text: l10n.facebook,
                              iconAsset: ImageConstants.imageFacebookIcon,
                              onPressed: () => handleFacebookSignIn(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.dontHaveAnAccount),
                        AppDimensionsSpacing.horizontalExtraSmall(context),
                        TextButton(
                          child: Text(
                            l10n.signUp,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => navigateToRegister(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Language selector button in top right corner
            Positioned(
              top: AppDimensionsPadding.medium(context),
              right: AppDimensionsPadding.medium(context),
              child: LanguageSelector(
                currentLocale: currentLocale,
                onLocaleChanged: (locale) {
                  appState?.changeLocale(locale);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWelcomeText extends StatelessWidget {
  const CustomWelcomeText({
    required this.welcomeText,
    required this.theme,
    super.key,
  });

  final String welcomeText;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      welcomeText,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class CustomLoginTextField extends StatelessWidget {
  const CustomLoginTextField({
    required this.controller,
    required this.customHintText,
    required this.customIcon,
    super.key,
    this.visibilityIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onVisibilityToggle,
  });

  final TextEditingController controller;
  final String customHintText;
  final IconData customIcon;
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
        hintText: customHintText,
        prefixIcon: Icon(customIcon, color: LoginConstants.primaryColor),
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

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.text,
    required this.iconAsset,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String iconAsset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensionsSize.buttonHeight(context),
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          iconAsset,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.image_not_supported,
            size: AppDimensionsSize.iconSizeMedium(context),
            color: LoginConstants.grey300,
          ),
        ),
      ),
    );
  }
}

class _CustomLoginButton extends StatelessWidget {
  const _CustomLoginButton({
    required LoginController controller,
    required this.l10n,
    required this.onLogin,
  });

  final AppLocalizations? l10n;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: AppDimensionsSize.buttonHeight(context),
          child: ElevatedButton(
            onPressed: isLoading ? null : onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: LoginConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: AppDimensionsRadius.circularExtraLarge(context),
              ),
              disabledBackgroundColor: LoginConstants.grey300,
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensionsSpacing.small(context)),
                      Text(
                        l10n?.signIn ?? LoginConstants.signInFallback,
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.medium(context),
                          fontWeight: FontWeight.w600,
                          color: LoginConstants.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n?.signIn ?? LoginConstants.signInFallback,
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.medium(context),
                          fontWeight: FontWeight.w600,
                          color: LoginConstants.white,
                        ),
                      ),
                      SizedBox(width: AppDimensionsSpacing.extraSmall(context)),
                      const Icon(
                        Icons.arrow_forward,
                        color: LoginConstants.white,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
