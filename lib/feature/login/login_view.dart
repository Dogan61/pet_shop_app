import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/validation/login_validator.dart';
import 'package:pet_shop_app/feature/login/controller/login_controller.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _controller.formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),

                /// Logo
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      image: const DecorationImage(
                        image: NetworkImage(LoginConstants.loginImageHeader),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Welcome text
                CustomWelcomeText(
                  welcomeText: l10n.welcome,
                  theme: theme,
                ),

                const SizedBox(height: 8),

                Text(
                  l10n.signInToYourAccountToContinue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                /// Form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
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
                      const SizedBox(height: 12),
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.forgotPassword,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      /// Login button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_controller.formKey.currentState!.validate()) {
                              return;
                            }

                            if (LoginValidator.validateLoginForm(
                              email: _controller.email,
                              password: _controller.password,
                              context: context,
                            )) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.loginSuccessful)),
                              );
                              // TODO: Login operation will be performed here
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7BAF7B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.signIn,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3E7D3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              l10n.orContinueWith,
                              style: const TextStyle(
                                color: Color(0xFF7BAF7B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3E7D3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SocialLoginButton(
                          text: l10n.google,
                          iconUrl: LoginConstants.googleIcon,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SocialLoginButton(
                          text: l10n.facebook,
                          iconUrl: LoginConstants.facebookIcon,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.dontHaveAnAccount),
                    const SizedBox(width: 8),
                    TextButton(
                      child: Text(
                        l10n.signUp,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => context.go('/register'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
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
        prefixIcon: Icon(
          customIcon,
          color: const Color(0xFF7BAF7B),
        ),
        suffixIcon: visibilityIcon != null && onVisibilityToggle != null
            ? IconButton(
                icon: Icon(visibilityIcon),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF7FBF7),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFFD3E7D3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Color(0xFF7BAF7B),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.text,
    required this.iconUrl,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String iconUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFD3E7D3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              iconUrl,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
