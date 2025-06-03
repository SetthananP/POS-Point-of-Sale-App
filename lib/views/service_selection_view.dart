import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/constant.dart';
import '../widgets/device_utils.dart';
import '../widgets/footer.dart';

import 'food_list_view.dart';
import 'welcome_view.dart';

class ServiceSelectionView extends StatefulWidget {
  const ServiceSelectionView({
    super.key,
  });

  @override
  State<ServiceSelectionView> createState() => _ServiceSelectionViewState();
}

class _ServiceSelectionViewState extends State<ServiceSelectionView> {
  bool showContactInfo = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    final isDesktopDevice = isDesktop(context);

    double horizontalSpacing = (screenWidth * 0.03).clamp(12.0, 32.0);

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
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: screenWidth * 1,
                    child: Image.asset(
                      AppAssets.backgroundImage2,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
          Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
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
                                                const WelcomeView()),
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: buildLeftContent(
                                                context, isLandscape),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FoodListView(),
                                                  ),
                                                );
                                              },
                                              child:
                                                  _buildServiceOptionWithOverlay(
                                                "To Stay",
                                                "assets/animation/ani_to_stay.gif",
                                                AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FoodListView(),
                                                  ),
                                                );
                                              },
                                              child:
                                                  _buildServiceOptionWithOverlay(
                                                "Togo Walk-in",
                                                "assets/animation/ani_welcome_3.gif",
                                                Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          builder: (_) => const WelcomeView(),
                                        ),
                                      );
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildLeftContent(context, isLandscape),
                                      SizedBox(
                                          height: isDesktopDevice
                                              ? 60
                                              : screenHeight * 0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FoodListView(),
                                                ),
                                              );
                                            },
                                            child:
                                                _buildServiceOptionWithOverlay(
                                              "To Stay",
                                              "assets/animation/ani_to_stay.gif",
                                              AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(width: horizontalSpacing),
                                          Flexible(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FoodListView(),
                                                  ),
                                                );
                                              },
                                              child:
                                                  _buildServiceOptionWithOverlay(
                                                "Togo Walk-in",
                                                "assets/animation/ani_welcome_3.gif",
                                                Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                      Container(
                        height: isDesktopDevice
                            ? (isLandscape ? 265 : 150)
                            : (isLandscape
                                ? screenHeight * 0.325
                                : screenHeight * 0.185),
                        color: AppColors.darkGrey,
                        child: Footer(isLandscape: isLandscape),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
      child: Transform.translate(
        offset: Offset(
          0,
          isDesktopDevice ? (isLandscape ? 20 : 55) : (isLandscape ? 50 : 0),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: isDesktopDevice ? 0 : (isLandscape ? 0 : screenHeight * 0.073),
            left: isLandscape ? 0 : 0,
            right: isLandscape ? screenWidth * 0.05 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Text(
                      AppStrings.selfService,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.title,
                      ),
                    ),
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
                      ? 17
                      : screenWidth * (isLandscape ? 0.01 : 0.035)),
              Text(
                AppStrings.subTagline,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: const Color.fromARGB(255, 115, 115, 115),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.body,
                ),
              ),
              SizedBox(
                  height: isDesktopDevice
                      ? 9
                      : screenWidth * (isLandscape ? 0 : 0.02)),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.creditCard,
                      width: isDesktopDevice
                          ? 16
                          : screenWidth * (isLandscape ? 0.03 : 0.04),
                      height: isDesktopDevice
                          ? 16
                          : screenWidth * (isLandscape ? 0.03 : 0.04),
                    ),
                    SizedBox(width: screenWidth * (isLandscape ? 0.005 : 0.01)),
                    Text(
                      AppStrings.paymentNote,
                      style: TextStyle(
                        fontSize: paymentFontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontFamily: AppFonts.body,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: isDesktopDevice
                      ? 35
                      : screenWidth * (isLandscape ? 0.05 : 0.065)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOptionWithOverlay(
    String title,
    String assetPath,
    Color color,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double containerWidth = isDesktopDevice
        ? 200
        : (screenWidth * (isLandscape ? 0.44 : 0.44)).clamp(140.0, 450.0);

    double containerHeight = isDesktopDevice
        ? (isLandscape ? (screenHeight * 0.43).clamp(260.0, 400.0) : 210)
        : (screenHeight * 0.5).clamp(180.0, 510.0);

    double overlayHeight =
        isDesktopDevice ? 50 : (containerHeight * 0.5).clamp(40.0, 110.0);

    double fontSize = isDesktopDevice
        ? 16
        : (screenWidth * (isLandscape ? 0.016 : 0.05)).clamp(12.0, 30.0);

    return Container(
      width: containerWidth,
      height: containerHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(isDesktopDevice ? 6 : 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isDesktopDevice ? 6 : 12),
                topRight: Radius.circular(isDesktopDevice ? 6 : 12),
              ),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            height: overlayHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(isDesktopDevice ? 6 : 12),
                bottomRight: Radius.circular(isDesktopDevice ? 6 : 12),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: overlayHeight * 0.2),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: fontSize,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
