import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';

/// Navigation helper utilities
class NavigationHelper {
  NavigationHelper._();

  /// Navigate back or to home if cannot pop
  static void navigateBackOrHome(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      //TODO : DÜZENLEME YAPILMALI
      context.go(LoginConstants.homeRoute);
    }
  }

  /// Navigate to pet detail
  static void navigateToPetDetail(BuildContext context, int index) {
    context.push('/pet-detail/$index');
  }
}
