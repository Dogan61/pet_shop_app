import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/router/navigation_helper.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// AppBar with back button and optional title
class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({
    this.title,
    this.onBackPressed,
    super.key,
  });

  final String? title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed:
            onBackPressed ?? () => NavigationHelper.navigateBackOrHome(context),
      ),
      title: title != null && title!.isNotEmpty
          ? Text(
              title!,
              style: TextStyle(
                fontSize: AppDimensionsFontSize.large(context),
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Empty AppBar (hidden) for pages that don't need an AppBar
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 0,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.zero;
}
