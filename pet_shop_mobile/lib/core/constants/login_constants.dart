import 'package:flutter/material.dart';

/// Constants used for Login and Register pages
class LoginConstants {
  LoginConstants._(); // Private constructor - cannot be instantiated

  // Image URLs
  static const String loginImageHeader =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAXI_C1Hd4mmrLDcAF6BQM4wmWrQcWaoPV9zorESBsHWmHgB8ER_PeluJSLgxa4HRQo0QH0nckjLTmjMFAZIRW5uObhQipLYU9qLBNdSVV-84k6HrMiBIE0SB5Lo2SZYuE-8SHhkgvkeQLJV_LGgLS11KCLo2FPMvb-pggyzoSRmrm4CHkpZp93SBkUW5Tm_JZgROAuyLFm2oBR8zOY_P5iuBO-Zst7kpWMw72ZOAK6O-P-iPOZfk6hhJgtFYpU1j5O2848aM3I2HGp';
  static const String registerAvatarImage = 'https://i.pravatar.cc/150?img=3';
  
  // Social Login Icons (Deprecated - use ImageConstants instead)
  @Deprecated('Use ImageConstants.imageGoogleIcon instead')
  static const String googleIcon =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png';
  @Deprecated('Use ImageConstants.imageFacebookIcon instead')
  static const String facebookIcon =
      'https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg';

  // Text Constants (Legacy - now using l10n)
  static const String passwordText = 'Password';
  static const String emailText = 'Enter your email';
  static const String continueText = 'Sign in to your account to continue';
  static const String welcomeText = 'Welcome';
  static const String isExistsText = "Don't have an account?";
  static const String registerText = 'Sign up';
  static const String toContinune = 'or continue with';

  // Fallback Messages
  static const String loginSuccessfulFallback = 'Login successful';
  static const String registrationSuccessfulFallback =
      'Registration successful';
  static const String signInFallback = 'Sign In';
  static const String signUpFallback = 'Sign Up';

  // Route Constants
  static const String registerRoute = '/register';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  // Color Constants
  static const Color primaryColor = Color(0xFF7BAF7B);
  static const Color lightGreen = Color(0xFFD3E7D3);
  static const Color lightBackground = Color(0xFFF7FBF7);
  static const Color registerButtonColor = Color(0xFF8EE26B);
  static const Color facebookColor = Color(0xFF4267B2);
  static const Color registerLinkColor = Color(0xFF6BBF59);

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static Color grey300 = Colors.grey.shade300;
}
