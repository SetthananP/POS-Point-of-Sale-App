import 'package:flutter/material.dart';

import 'constant.dart';
import 'device_utils.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onRestaurantTap;
  final VoidCallback? onSettingTap;

  const AppHeader({
    Key? key,
    this.onRestaurantTap,
    this.onSettingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double paddingSize = isDesktopDevice ? (isLandscape ? 32 : 22) : (screenWidth * (isLandscape ? 0.025 : 0.095)).clamp(16.0, 74.0);
    double iconSize = isDesktopDevice ? (isLandscape ? 25 : 17.0) : (screenWidth * (isLandscape ? 0.025 : 0.035)).clamp(20.0, 36.0);
    double textFontSize = isDesktopDevice ? (isLandscape ? 26 : 18.0) : (screenWidth * (isLandscape ? 0.025 : 0.05)).clamp(18.0, 36.0);
    double settingIconWidth = isDesktopDevice ? (isLandscape ? 30 : 14) : (screenWidth * (isLandscape ? 0.03 : 0.040)).clamp(24.0, 36.0);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          left: paddingSize,
          right: paddingSize * 0.2,
          top: paddingSize,
          bottom: paddingSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onRestaurantTap,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant,
                    color: const Color.fromARGB(255, 115, 115, 115),
                    size: iconSize,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.restaurantName,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 115, 115, 115),
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.body,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Image.asset(AppAssets.settingIcon, width: settingIconWidth),
              onPressed: onSettingTap,
            ),
          ],
        ),
      ),
    );
  }
}
