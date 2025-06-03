import 'package:flutter/material.dart';

import 'constant.dart';
import 'device_utils.dart';

class Footer extends StatelessWidget {
  final bool isLandscape;
  const Footer({super.key, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

   final isDesktopDevice = isDesktop(context);

    double paddingSize = (screenWidth * (isLandscape ? 0.03 : 0.05)).clamp(16.0, 60.0);
    return Container(
      width: double.infinity,
      color: AppColors.darkGrey,
      padding: EdgeInsets.symmetric(
        vertical: paddingSize * 0.5,
        horizontal: paddingSize,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = Theme.of(context).platform == TargetPlatform.windows;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: isDesktop ? 20 : 22, right: 12),
                        child: buildContactInfo(context),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isDesktop ? (isLandscape ? 40.0 : 70.0) : (isLandscape ? 30.0 : 150.0),
                          top: isDesktop ? (isLandscape ? 12.0 : 20) : (isLandscape ? 30.0 : 35.0),
                        ),
                        child: buildSocialInfo(context),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: isDesktopDevice ? (isLandscape ? 25 : 10) : (isLandscape ? 15 : 60)),
            buildCopyright(context),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    final isDesktopDevice = isDesktop(context);

    double headingSize = isDesktopDevice ? (isLandscape ? 16 : 8) : (screenWidth * (isLandscape ? 0.5 : 0.03)).clamp(10.0, 16.0);
    double bodySize = isDesktopDevice ? (isLandscape ? 16 : 8) : (screenWidth * (isLandscape ? 0.015 : 0.02)).clamp(12.0, 16.0);
    return Padding(
      padding: EdgeInsets.only(
        top: isDesktopDevice ? (isLandscape ? 40 : 25) : (screenHeight * (isLandscape ? 0.055 : 0.035)).clamp(8.0, 60.0),
        left: isDesktopDevice
            ? (isLandscape ? 100 : 0)
            : isLandscape
                ? 275
                : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppStrings.contactUs,
            style: TextStyle(
              color: AppColors.white,
              fontSize: headingSize,
            ),
          ),
          SizedBox(height: isDesktopDevice ? 15 : 25),
          Text(
            AppStrings.address,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: AppColors.white,
              fontSize: bodySize,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        contactItem(context, image: AppAssets.phoneIcon, text: AppStrings.phoneNumber),
        contactItem(context, icon: Icons.camera_alt, text: AppStrings.igName),
        contactItem(context, image: AppAssets.youtubeIcon, text: AppStrings.youtubeName),
        contactItem(context, image: AppAssets.emailIcon, text: AppStrings.emailName),
      ],
    );
  }

  Widget buildCopyright(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isLandscape = screenWidth > screenHeight;
    final bool isDesktop = Theme.of(context).platform == TargetPlatform.windows;

    double iconSize = isDesktop ? (isLandscape ? 20 : 18) : (screenWidth * (isLandscape ? 0.025 : 0.035)).clamp(20.0, 30.0);

    double fontSize = isDesktop ? (isLandscape ? 14 : 10) : (screenWidth * (isLandscape ? 0.022 : 0.028)).clamp(12.0, 18.0);

    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.copyright,
            style: TextStyle(
              color: AppColors.white,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 6),
          Image.asset(
            AppAssets.smileIcon,
            width: iconSize + 10,
            errorBuilder: (_, __, ___) => const Icon(Icons.error, color: AppColors.redText),
          ),
        ],
      ),
    );
  }

  Widget contactItem(
    BuildContext context, {
    String? image,
    IconData? icon,
    required String text,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
   final isDesktopDevice = isDesktop(context);

    double iconSize = isDesktopDevice ? (isLandscape ? 20 : 12) : (screenWidth * (isLandscape ? 0.025 : 0.02)).clamp(12.0, 32.0);

    double fontSize = isDesktopDevice ? (isLandscape ? 16 : 8) : (screenWidth * 0.03).clamp(9.0, 20.0);

    return Padding(
      padding: EdgeInsets.only(
        top: isDesktopDevice ? (screenHeight * (isLandscape ? 0.09 : 0.005)).clamp(8.0, 20.0) : (screenHeight * (isLandscape ? 0.040 : 0.05)).clamp(8.0, 20.0),
        left: isLandscape ? 275 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: image != null
                ? Image.asset(
                    image,
                    fit: BoxFit.contain,
                  )
                : Icon(
                    icon,
                    size: iconSize * 0.9,
                    color: AppColors.white,
                  ),
          ),
          SizedBox(width: isDesktopDevice ? 10 : 24),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.white,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
