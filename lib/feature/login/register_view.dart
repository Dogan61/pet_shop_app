import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/validation/register_validator.dart';
import 'package:pet_shop_app/feature/login/controller/register_controller.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: _controller.onBackPressed(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// AVATAR
              const CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),

              const SizedBox(height: 16),

              /// TITLE
              Text(
                l10n.createAccount,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              /// SUBTITLE
              Text(
                l10n.theBestForYourPets,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

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
                  const SizedBox(width: 12),
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

              const SizedBox(height: 12),

              /// EMAIL
              _InputField(
                controller: _controller.emailController,
                hint: l10n.exampleEmail,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    RegisterValidator.validateEmail(value, context),
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 24),

              /// REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.registrationSuccessful)),
                      );
                      // TODO: Register operation will be performed here
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EE26B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    l10n.signUp,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DIVIDER
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l10n.or),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              /// GOOGLE BUTTON
              _SocialButton(
                text: l10n.signUpWithGoogle,
                borderColor: Colors.grey.shade300,
              ),

              const SizedBox(height: 12),

              /// FACEBOOK BUTTON
              _SocialButton(
                text: l10n.signUpWithFacebook,
                backgroundColor: const Color(0xFF4267B2),
                textColor: Colors.white,
              ),

              const SizedBox(height: 24),

              /// FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAnAccount),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      l10n.signIn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6BBF59),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
        fillColor: const Color(0xFFF7FBF7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
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
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
