import 'package:flutter/material.dart';

/// Utility class for responsive dimensions and spacing values
class AppDimensions {
  AppDimensions._();

  /// Returns screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Returns screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Returns percentage of screen width
  static double widthPercent(BuildContext context, double percent) {
    return screenWidth(context) * percent / 100;
  }

  /// Returns percentage of screen height
  static double heightPercent(BuildContext context, double percent) {
    return screenHeight(context) * percent / 100;
  }
}

/// Responsive padding values
class AppDimensionsPadding {
  AppDimensionsPadding._();

  static double extraSmall(BuildContext context) =>
      AppDimensions.widthPercent(context, 2);
  static double small(BuildContext context) =>
      AppDimensions.widthPercent(context, 3);
  static double medium(BuildContext context) =>
      AppDimensions.widthPercent(context, 4);
  static double large(BuildContext context) =>
      AppDimensions.widthPercent(context, 5);
  static double extraLarge(BuildContext context) =>
      AppDimensions.widthPercent(context, 6);

  static EdgeInsets allSmall(BuildContext context) =>
      EdgeInsets.all(small(context));
  static EdgeInsets allMedium(BuildContext context) =>
      EdgeInsets.all(medium(context));
  static EdgeInsets allLarge(BuildContext context) =>
      EdgeInsets.all(large(context));

  static EdgeInsets symmetricHorizontalExtraSmall(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: extraSmall(context));
  static EdgeInsets symmetricHorizontalSmall(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: small(context));
  static EdgeInsets symmetricHorizontalMedium(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: medium(context));
  static EdgeInsets symmetricHorizontalLarge(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: large(context));

  static EdgeInsets symmetricVerticalExtraSmall(BuildContext context) =>
      EdgeInsets.symmetric(vertical: extraSmall(context));
  static EdgeInsets symmetricVerticalSmall(BuildContext context) =>
      EdgeInsets.symmetric(vertical: small(context));
  static EdgeInsets symmetricVerticalMedium(BuildContext context) =>
      EdgeInsets.symmetric(vertical: medium(context));
  static EdgeInsets symmetricVerticalLarge(BuildContext context) =>
      EdgeInsets.symmetric(vertical: large(context));

  static EdgeInsets onlyTopSmall(BuildContext context) =>
      EdgeInsets.only(top: small(context));
  static EdgeInsets onlyTopMedium(BuildContext context) =>
      EdgeInsets.only(top: medium(context));
  static EdgeInsets onlyBottomSmall(BuildContext context) =>
      EdgeInsets.only(bottom: small(context));
  static EdgeInsets onlyBottomMedium(BuildContext context) =>
      EdgeInsets.only(bottom: medium(context));
  static EdgeInsets onlyLeftRightSmall(BuildContext context) =>
      EdgeInsets.only(left: small(context), right: small(context));
}

/// Responsive spacing values (for SizedBox)
class AppDimensionsSpacing {
  AppDimensionsSpacing._();

  static double extraSmall(BuildContext context) =>
      AppDimensions.heightPercent(context, 1);
  static double small(BuildContext context) =>
      AppDimensions.heightPercent(context, 2);
  static double medium(BuildContext context) =>
      AppDimensions.heightPercent(context, 3);
  static double large(BuildContext context) =>
      AppDimensions.heightPercent(context, 4);
  static double extraLarge(BuildContext context) =>
      AppDimensions.heightPercent(context, 5);

  static SizedBox verticalExtraSmall(BuildContext context) =>
      SizedBox(height: extraSmall(context));
  static SizedBox verticalSmall(BuildContext context) =>
      SizedBox(height: small(context));
  static SizedBox verticalMedium(BuildContext context) =>
      SizedBox(height: medium(context));
  static SizedBox verticalLarge(BuildContext context) =>
      SizedBox(height: large(context));
  static SizedBox verticalExtraLarge(BuildContext context) =>
      SizedBox(height: extraLarge(context));

  static SizedBox horizontalExtraSmall(BuildContext context) =>
      SizedBox(width: AppDimensions.widthPercent(context, 2));
  static SizedBox horizontalSmall(BuildContext context) =>
      SizedBox(width: AppDimensions.widthPercent(context, 3));
  static SizedBox horizontalMedium(BuildContext context) =>
      SizedBox(width: AppDimensions.widthPercent(context, 4));
}

/// Responsive sizes (for width, height)
class AppDimensionsSize {
  AppDimensionsSize._();

  static double extraSmall(BuildContext context) =>
      AppDimensions.widthPercent(context, 8);
  static double small(BuildContext context) =>
      AppDimensions.widthPercent(context, 12);
  static double medium(BuildContext context) =>
      AppDimensions.widthPercent(context, 16);
  static double large(BuildContext context) =>
      AppDimensions.widthPercent(context, 24);
  static double extraLarge(BuildContext context) =>
      AppDimensions.widthPercent(context, 30);

  // Custom sizes
  static double logoSize(BuildContext context) =>
      AppDimensions.widthPercent(context, 30);
  static double avatarSize(BuildContext context) =>
      AppDimensions.widthPercent(context, 12);
  static double iconSizeSmall(BuildContext context) =>
      AppDimensions.widthPercent(context, 4);
  static double iconSizeMedium(BuildContext context) =>
      AppDimensions.widthPercent(context, 5);
  static double iconSizeLarge(BuildContext context) =>
      AppDimensions.widthPercent(context, 6);
  static double buttonHeight(BuildContext context) =>
      AppDimensions.heightPercent(context, 6.5);
  static double filterSectionHeight(BuildContext context) =>
      AppDimensions.heightPercent(context, 7);
  static double filterButtonHeight(BuildContext context) =>
      AppDimensions.heightPercent(context, 6.2);
}

/// Responsive border radius values
class AppDimensionsRadius {
  AppDimensionsRadius._();

  static double small(BuildContext context) =>
      AppDimensions.widthPercent(context, 3);
  static double medium(BuildContext context) =>
      AppDimensions.widthPercent(context, 4);
  static double large(BuildContext context) =>
      AppDimensions.widthPercent(context, 6);
  static double extraLarge(BuildContext context) =>
      AppDimensions.widthPercent(context, 7);

  static BorderRadius circularSmall(BuildContext context) =>
      BorderRadius.circular(small(context));
  static BorderRadius circularMedium(BuildContext context) =>
      BorderRadius.circular(medium(context));
  static BorderRadius circularLarge(BuildContext context) =>
      BorderRadius.circular(large(context));
  static BorderRadius circularExtraLarge(BuildContext context) =>
      BorderRadius.circular(extraLarge(context));
}

/// Responsive border width values
class AppDimensionsBorderWidth {
  AppDimensionsBorderWidth._();

  static double thin(BuildContext context) =>
      AppDimensions.widthPercent(context, 0.4);
  static double normal(BuildContext context) =>
      AppDimensions.widthPercent(context, 0.5);
  static double thick(BuildContext context) =>
      AppDimensions.widthPercent(context, 0.6);
}

/// Responsive font size values
class AppDimensionsFontSize {
  AppDimensionsFontSize._();

  static double extraSmall(BuildContext context) =>
      AppDimensions.widthPercent(context, 3);
  static double small(BuildContext context) =>
      AppDimensions.widthPercent(context, 3.5);
  static double medium(BuildContext context) =>
      AppDimensions.widthPercent(context, 4);
  static double large(BuildContext context) =>
      AppDimensions.widthPercent(context, 4.5);
  static double extraLarge(BuildContext context) =>
      AppDimensions.widthPercent(context, 5);
}

/// Responsive values for grid layout
class AppDimensionsGrid {
  AppDimensionsGrid._();

  static int crossAxisCount(BuildContext context) {
    final width = AppDimensions.screenWidth(context);
    if (width < 600) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else {
      return 4;
    }
  }

  static double spacing(BuildContext context) =>
      AppDimensions.widthPercent(context, 4);
  static double childAspectRatio(BuildContext context) => 3 / 4;
}
