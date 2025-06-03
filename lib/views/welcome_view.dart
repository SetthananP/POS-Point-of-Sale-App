import 'package:flutter/material.dart';

import 'package:pretest/views/food_list_view.dart';

import '../widgets/app_header.dart';
import '../widgets/constant.dart';
import '../widgets/device_utils.dart';
import '../widgets/footer.dart';

import 'service_selection_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool showContactInfo = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    return Scaffold(
      body: Stack(
        children: [
          isLandscape
              ? Positioned(
                  bottom: -150,
                  left: -80,
                  child: Image.asset(
                    AppAssets.bgIsLandscape,
                    width: screenWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: screenWidth * 0.85,
                    child: Image.asset(
                      AppAssets.backgroundImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
          Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  child: isLandscape
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppHeader(
                              onRestaurantTap: () {
                                setState(() {
                                  showContactInfo = !showContactInfo;
                                });
                              },
                              onSettingTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ServiceSelectionView()),
                                );
                              },
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child:
                                        buildLeftContent(context, isLandscape),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:
                                        buildIllustration(context, isLandscape),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            AppHeader(
                              onRestaurantTap: () {
                                setState(() {
                                  showContactInfo = !showContactInfo;
                                });
                              },
                              onSettingTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ServiceSelectionView(),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Flexible(
                                  child: buildLeftContent(context, isLandscape),
                                ),
                                Flexible(
                                  child:
                                      buildIllustration(context, isLandscape),
                                ),
                              ],
                            )),
                          ],
                        ),
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: showContactInfo ? 0 : -screenHeight * 0.5,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !showContactInfo,
              child: Container(
                height:
                    isLandscape ? screenHeight * 0.325 : screenHeight * 0.185,
                color: AppColors.darkGrey,
                child: Footer(isLandscape: isLandscape),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeftContent(BuildContext context, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDesktopDevice = isDesktop(context);

    double titleFontSize = isDesktopDevice
        ? (isLandscape ? 100 : 55)
        : (screenWidth * (isLandscape ? 0.06 : 0.2)).clamp(34.0, 124.0);

    double subtitleFontSize = isDesktopDevice
        ? (isLandscape ? 24 : 14)
        : (screenWidth * (isLandscape ? 0.022 : 0.030)).clamp(14.0, 34.0);

    double paymentFontSize = isDesktopDevice
        ? (isLandscape ? 23 : 13)
        : (screenWidth * (isLandscape ? 0.02 : 0.030)).clamp(12.0, 34.0);
    return Align(
      alignment: isLandscape ? Alignment.center : Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: isDesktopDevice
              ? (isLandscape ? 60 : 60)
              : (isLandscape ? 80 : screenHeight * 0.073),
          right: isLandscape ? screenWidth * 0.05 : 0,
          left: isLandscape ? screenWidth * 0.05 : 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.selfService,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.title,
                    ),
                  ),
                  SizedBox(
                      height: isDesktopDevice
                          ? (isLandscape ? 0 : 0)
                          : screenWidth * (isLandscape ? 0.01 : 0)),
                  Text(
                    AppStrings.experience,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.title,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: isDesktopDevice
                    ? (isLandscape ? 10 : 17)
                    : screenWidth * (isLandscape ? 0.01 : 0.035)),
            Text(
              AppStrings.subTagline,
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: const Color.fromARGB(255, 115, 115, 115),
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height: isDesktopDevice
                    ? (isLandscape ? 12 : 9)
                    : screenWidth * (isLandscape ? 0 : 0.02)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.creditCard,
                  width: isDesktopDevice
                      ? (isLandscape ? 26 : 16)
                      : screenWidth * (isLandscape ? 0.03 : 0.04),
                  height: isDesktopDevice
                      ? (isLandscape ? 26 : 16)
                      : screenWidth * (isLandscape ? 0.03 : 0.04),
                ),
                SizedBox(width: screenWidth * (isLandscape ? 0.005 : 0.01)),
                Text(
                  AppStrings.paymentNote,
                  style: TextStyle(
                    fontSize: paymentFontSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.redText,
                    decoration: TextDecoration.underline,
                    fontFamily: AppFonts.body,
                  ),
                ),
              ],
            ),
            SizedBox(
                height: isDesktopDevice
                    ? (isLandscape ? 30 : 35)
                    : screenWidth * (isLandscape ? 0.05 : 0.065)),
            Transform.translate(
              offset: Offset(
                0,
                isDesktopDevice
                    ? (isLandscape ? 45 : 0)
                    : (isLandscape ? -5 : 5),
              ),
              child: buildOrderButton(context, isLandscape),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButton(BuildContext context, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDesktopDevice = isDesktop(context);

    double buttonWidth = isDesktopDevice
        ? (isLandscape ? 300 : 190)
        : (screenWidth * (isLandscape ? 0.25 : 0.5)).clamp(140, 422);

    double buttonHeight = isDesktopDevice
        ? (isLandscape ? 95 : 55)
        : (screenHeight * (isLandscape ? 0.2 : 0.090)).clamp(40, 120);

    double fontSize = isDesktopDevice
        ? (isLandscape ? 26 : 16)
        : (screenWidth * (isLandscape ? 0.023 : 0.05)).clamp(14, 36);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodListView()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isDesktopDevice ? 6 : 12,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * (isLandscape ? 0.025 : 0.04),
            vertical: screenWidth * (isLandscape ? 0.008 : 0.015),
          ),
        ),
        child: FittedBox(
          child: Text(
            AppStrings.startOrder,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.white,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIllustration(BuildContext context, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopDevice = isDesktop(context);

    final double iconSize =
        isDesktopDevice ? (isLandscape ? 30 : 20) : screenWidth * 0.03;
    final double textFontSize = isDesktopDevice
        ? (isLandscape ? 30 : 20)
        : (screenWidth * 0.05).clamp(16.0, 48.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;

        final double containerHeight = isDesktopDevice
            ? maxHeight
            : (isLandscape ? maxHeight * 1 : maxHeight * 1);

        return Container(
          width: double.infinity,
          height: containerHeight,
          padding: EdgeInsets.only(
            top: isDesktopDevice ? maxHeight * 0.07 : 0,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.welcomeIllustration),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: const Alignment(-0.04, 0.6),
            child: FractionallySizedBox(
              widthFactor: isLandscape ? 0.5 : 0.25,
              heightFactor: isLandscape ? 0.5 : 0.45,
              child: isLandscape
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant,
                            color: AppColors.white, size: iconSize),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.restaurantName,
                          style: TextStyle(
                            fontFamily: AppFonts.title,
                            color: AppColors.white,
                            fontSize: textFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant,
                            color: AppColors.white, size: iconSize),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.restaurantHalfName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.title,
                            color: AppColors.white,
                            fontSize: textFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
