import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/order_bloc/order_bloc.dart';
import '../bloc/order_bloc/order_event.dart';
import '../bloc/order_bloc/order_state.dart';
import '../widgets/constant.dart';
import '../widgets/device_utils.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double sidebarWidth = isDesktopDevice ? (isLandscape ? screenWidth * 0.202 : screenWidth * 0.33) : (isLandscape ? screenWidth * 0.205 : screenWidth * 0.32);

    double settingIconSize = isDesktopDevice ? (isLandscape ? 20 : 16) : (screenWidth * 0.035).clamp(12.0, 50.0);
    double titleFontSize = isDesktopDevice ? (isLandscape ? 26 : 16) : (screenWidth * 0.04).clamp(16.0, 34.0);

    double subtotalFontSize = isDesktopDevice ? (isLandscape ? 24 : 14) : (screenWidth * 0.05).clamp(14.0, 27.0);
    double confirmFontSize = isDesktopDevice ? (isLandscape ? 24 : 14) : (screenWidth * 0.025).clamp(12.0, 24.0);
    double orderSize = isDesktopDevice ? (isLandscape ? 16 : 8) : (screenWidth * 0.025).clamp(12.0, 24.0);
    double priceSize = isDesktopDevice ? (isLandscape ? 12 : 10) : (screenWidth * 0.025).clamp(12.0, 24.0);
    double foodDescSize = isDesktopDevice ? (isLandscape ? 16 : 8) : (screenWidth * 0.025).clamp(12.0, 24.0);
    double buttonHeight = isDesktopDevice ? (isLandscape ? 50 : 30) : (screenWidth * 0.09).clamp(44.0, 75.0);
    double buttonWidth = isDesktopDevice ? (isLandscape ? 250 : 150) : (screenWidth * 0.3).clamp(44.0, 300.0);
    double iconSize = isDesktopDevice ? (isLandscape ? 20 : 14) : (screenWidth * 0.02).clamp(12.0, 28.0);
    double emptyTextFontSize = isDesktopDevice ? (isLandscape ? 16 : 10) : (screenWidth * 0.03).clamp(14.0, 24.0);

    final double paddingSize = (screenWidth * (isLandscape ? 0.05 : 0.05)).clamp(12.0, 24.0);

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(color: AppColors.greyText.shade400)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: isDesktopDevice
                  ? (isLandscape ? screenHeight * 0.03 : screenHeight * 0.02)
                  : isLandscape
                      ? screenHeight * 0.03
                      : screenHeight * 0.036,
              left: isDesktopDevice ? 20 : paddingSize,
              right: isDesktopDevice ? 0 : paddingSize,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<int>(
                    icon: Image.asset(
                      AppAssets.settingIcon,
                      width: settingIconSize,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    offset: const Offset(0, 40),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text(AppStrings.setting, style: TextStyle(color: AppColors.blue, decoration: TextDecoration.underline)),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text(AppStrings.store, style: TextStyle(color: AppColors.blue, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: isDesktopDevice
                        ? (isLandscape ? screenHeight * 0.03 : screenHeight * 0)
                        : isLandscape
                            ? screenHeight * 0.036
                            : screenHeight * 0.012,
                    left: paddingSize * 0.01,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            AppStrings.myOrder,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset(
                        AppAssets.editIcon,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: isDesktopDevice ? 8 : 25,
          ),
          const Divider(
            thickness: 1,
            color: AppColors.greyText,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoaded && state.orders.isNotEmpty) {
                  return ListView.separated(
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 1,
                      color: AppColors.greyText,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final entry = state.orders[index];

                      final int quantity = entry.value;
                      final double unitPrice = entry.key.foodPrice;
                      final double totalPrice = unitPrice * quantity;

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: isDesktopDevice ? 8 : 16, vertical: isDesktopDevice ? 4 : 8),
                        padding: EdgeInsets.all(isDesktopDevice ? 10 : 20),
                        decoration: BoxDecoration(
                          color: AppColors.lineColor,
                          borderRadius: BorderRadius.circular(
                            isDesktopDevice ? 3 : 12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "x${entry.value} ${entry.key.foodName}",
                                style: TextStyle(
                                  fontSize: orderSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.key.foodDesc,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: foodDescSize,
                                  color: AppColors.greyText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${totalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: priceSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.price,
                                    ),
                                  ),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: buildQuantityController(context, index, entry.value),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      );
                    },
                  );
                } else {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: isDesktopDevice ? 7 : 30),
                      child: Text(
                        AppStrings.noOrder,
                        style: TextStyle(color: AppColors.greyText, fontSize: emptyTextFontSize),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(
                color: AppColors.greyText,
                indent: 16,
                endIndent: 16,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: isDesktopDevice ? 0 : 40,
                  bottom: 12,
                ),
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLandscape ? screenHeight * 0.035 : screenHeight * 0.015),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppStrings.subtotal,
                                    style: TextStyle(
                                      fontSize: subtotalFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.subtotalColor,
                                      fontFamily: AppFonts.subtotal,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "\$${state is OrderLoaded ? state.subtotal.toStringAsFixed(2) : "0.00"}",
                                    style: TextStyle(
                                      fontSize: subtotalFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: state is OrderLoaded && state.subtotal > 0 ? AppColors.price : AppColors.subtotalColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: ElevatedButton(
                                    onPressed: state is OrderLoaded && state.orders.isNotEmpty ? () {} : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: state is OrderLoaded && state.orders.isNotEmpty ? AppColors.order : AppColors.confirm,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: AppColors.confirm,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          isDesktopDevice ? 6 : 12,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            AppAssets.shopping,
                                            height: iconSize,
                                            width: iconSize,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Confirm Order (${state is OrderLoaded ? state.orders.length : 0})",
                                            style: TextStyle(
                                              fontSize: confirmFontSize,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuantityController(BuildContext context, int index, int quantity) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopDevice = isDesktop(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    double iconSize = isDesktopDevice ? (isLandscape ? 20 : 10) : (screenWidth * 0.06).clamp(16.0, 24.0);
    double fontSize = isDesktopDevice ? (isLandscape ? 20 : 10) : (screenWidth * 0.035).clamp(12.0, 18.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            context.read<OrderBloc>().add(DecreaseOrderQuantity(index));
          },
          child: Container(
            width: isDesktopDevice ? (isLandscape ? 24 : 10) : 24,
            height: isDesktopDevice ? (isLandscape ? 24 : 10) : 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Icon(Icons.remove, size: iconSize, color: Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          quantity.toString().padLeft(2, '0'),
          style: TextStyle(fontSize: fontSize),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            context.read<OrderBloc>().add(IncreaseOrderQuantity(index));
          },
          child: Container(
            width: isDesktopDevice ? (isLandscape ? 24 : 10) : 24,
            height: isDesktopDevice ? (isLandscape ? 24 : 10) : 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
