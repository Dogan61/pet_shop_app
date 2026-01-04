import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/language_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';

/// Language selector widget with dropdown button
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.currentLocale,
    required this.onLocaleChanged,
    super.key,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      color: LoginConstants.white,
      icon: Container(
        padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
        decoration: BoxDecoration(
          color: LoginConstants.lightBackground,
          borderRadius: AppDimensionsRadius.circularMedium(context),
          border: Border.all(color: LoginConstants.grey300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: AppDimensionsSize.iconSizeSmall(context),
              color: LoginConstants.primaryColor,
            ),
            SizedBox(width: AppDimensionsSpacing.extraSmall(context)),
            Text(
              currentLocale.languageCode.toUpperCase(),
              style: TextStyle(
                fontSize: AppDimensionsFontSize.small(context),
                fontWeight: FontWeight.w600,
                color: LoginConstants.primaryColor,
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensionsRadius.circularMedium(context),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<Locale>(
          value: LanguageConstants.englishLocale,
          child: Row(
            children: [
              const Text(LanguageConstants.englishFlag),
              SizedBox(width: AppDimensionsSpacing.small(context)),
              const Text(LanguageConstants.englishName),
              if (currentLocale.languageCode == 'en')
                const Spacer()
              else
                const SizedBox.shrink(),
              if (currentLocale.languageCode == 'en')
                Icon(
                  Icons.check,
                  size: AppDimensionsSize.iconSizeSmall(context),
                  color: LoginConstants.primaryColor,
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: LanguageConstants.turkishLocale,
          child: Row(
            children: [
              const Text(LanguageConstants.turkishFlag),
              SizedBox(width: AppDimensionsSpacing.small(context)),
              const Text(LanguageConstants.turkishName),
              if (currentLocale.languageCode == 'tr')
                const Spacer()
              else
                const SizedBox.shrink(),
              if (currentLocale.languageCode == 'tr')
                Icon(
                  Icons.check,
                  size: AppDimensionsSize.iconSizeSmall(context),
                  color: LoginConstants.primaryColor,
                ),
            ],
          ),
        ),
      ],
      onSelected: onLocaleChanged,
    );
  }
}
