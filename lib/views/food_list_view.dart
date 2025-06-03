import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:pretest/widgets/constant.dart';

import '../bloc/food_bloc/food_bloc.dart';
import '../bloc/order_bloc/order_bloc.dart';
import '../bloc/order_bloc/order_event.dart';
import '../models/food_model.dart';

import '../widgets/device_utils.dart';
import 'food_menu_header.dart';
import 'order_summary.dart';

class FoodListView extends StatefulWidget {
  const FoodListView({super.key});

  @override
  State<FoodListView> createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  final Map<String, int> _categoryIndexMap = {};
  bool _isManualScrolling = false;

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      if (_isManualScrolling) return;
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isEmpty) return;

      final visibleItems = positions.where((p) => p.itemLeadingEdge >= 0).toList();
      if (visibleItems.isEmpty) return;

      final firstVisible = visibleItems.reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);

      final currentCategory = _categoryIndexMap.entries.firstWhere((entry) => entry.value == firstVisible.index, orElse: () => const MapEntry('', 0)).key;

      final currentState = context.read<FoodBloc>().state;
      if (currentState is FoodLoaded && currentCategory != currentState.selectedCategory && currentCategory.isNotEmpty) {
        context.read<FoodBloc>().add(ChangeCategory(currentCategory));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double sidebarWidth = isDesktopDevice ? (isLandscape ? screenWidth * 0.205 : screenWidth * 0.33) : (isLandscape ? screenWidth * 0.205 : screenWidth * 0.33);

    double headerFontSize = isDesktopDevice ? (isLandscape ? 25.0 : 16.0) : (screenWidth * (isLandscape ? 0.025 : 0.04)).clamp(20.0, 36.0);

    double paddingSize = (screenWidth * (isLandscape ? 0.03 : 0.03)).clamp(8.0, 24.0);

    final double horizontalPadding = (screenWidth * 0.02).clamp(6.0, 24.0);
    final double bottomPadding = (screenHeight * 0.015).clamp(6.0, 16.0);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoodMenuHeader(onFoodSetSelected: (foodSet) {
                  context.read<FoodBloc>().add(ChangeFoodSet(foodSet));
                }, onCategorySelected: (categoryId) async {
                  final index = _categoryIndexMap[categoryId];
                  if (index != null && _itemScrollController.isAttached) {
                    _isManualScrolling = true;

                    await _itemScrollController.scrollTo(
                      index: index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );

                    context.read<FoodBloc>().add(ChangeCategory(categoryId));

                    Future.delayed(const Duration(milliseconds: 200), () {
                      _isManualScrolling = false;
                    });
                  }
                }),
                Expanded(
                  child: BlocBuilder<FoodBloc, FoodState>(
                    builder: (context, state) {
                      if (state is FoodLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FoodLoaded) {
                        final isSearching = state.isSearching;

                        if (isSearching) {
                          final results = state.foods;
                          if (results.isEmpty) return const Center(child: Text("No results found."));

                          final screenSize = MediaQuery.of(context).size;
                          final isLandscape = screenSize.width > screenSize.height;
                          final isDesktop = Theme.of(context).platform == TargetPlatform.windows;

                          final double cardWidth = screenSize.width / (isLandscape ? 4 : 2) - 10;
                          double cardHeight = isDesktop ? (isLandscape ? cardWidth * 0.9 : cardWidth * 0.9) : (isLandscape ? cardWidth * 0.9 : cardWidth * 0.9);

                          return Padding(
                            padding: EdgeInsets.all(paddingSize),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: state.categorizedByFoodCat.length,
                              itemBuilder: (context, index) {
                                final entry = state.categorizedByFoodCat.entries.elementAt(index);
                                final category = entry.key;
                                final foodList = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: index == 0
                                            ? isDesktop
                                                ? (isLandscape ? screenHeight * 0.025 : screenHeight * 0)
                                                : (isLandscape ? screenHeight * 0.03 : screenHeight * 0.025)
                                            : isDesktop
                                                ? (isLandscape ? screenHeight * 0.04 : screenHeight * 0.05)
                                                : (isLandscape ? screenHeight * 0.05 : screenHeight * 0.065),
                                        bottom: bottomPadding + 8,
                                        left: horizontalPadding,
                                        right: horizontalPadding,
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: headerFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: foodList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: isLandscape ? 4 : (screenWidth < 350 ? 1 : 2),
                                          crossAxisSpacing: isDesktop ? (isLandscape ? 10 : 6) : 20.0,
                                          mainAxisSpacing: isDesktop ? (isLandscape ? 10 : 6) : 20.0,
                                          childAspectRatio: isDesktop ? (isLandscape ? 4 / 4 : 4 / 4.5) : (isLandscape ? 4 / 4 : 4 / 4.36)),
                                      itemBuilder: (context, foodIndex) {
                                        final food = foodList[foodIndex];
                                        return GestureDetector(
                                          onTap: () {
                                            if (!food.isOutStock) {
                                              context.read<OrderBloc>().add(AddToOrder(food));
                                            }
                                          },
                                          child: buildFoodItem(food, cardWidth, cardHeight),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }

                        if (state.categorizedByFoodCat.isEmpty) {
                          return const Center(
                            child: Text("No categories available"),
                          );
                        }

                        _categoryIndexMap.clear();
                        List<MapEntry<String, List<Food>>> sortedCategories = state.categorizedByFoodCat.entries.toList();

                        for (int i = 0; i < sortedCategories.length; i++) {
                          _categoryIndexMap[sortedCategories[i].key] = i;
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              top: isDesktopDevice ? (isLandscape ? 10 : 10) : paddingSize,
                              left: isDesktopDevice ? (isLandscape ? 10 : 10) : paddingSize,
                              right: isDesktopDevice ? (isLandscape ? 10 : 10) : paddingSize),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
                              final isDesktop = Theme.of(context).platform == TargetPlatform.windows;

                              double cardWidth = constraints.maxWidth / (isLandscape ? 4 : 2) - 10;
                              double cardHeight = isDesktop ? (isLandscape ? cardWidth * 1.3 : cardWidth * 1.2) : (isLandscape ? cardWidth * 1.5 : cardWidth * 1.2);

                              return ScrollablePositionedList.builder(
                                itemCount: sortedCategories.length,
                                itemScrollController: _itemScrollController,
                                itemPositionsListener: _itemPositionsListener,
                                itemBuilder: (context, index) {
                                  String categoryKey = sortedCategories[index].key;
                                  String displayCategoryName = sortedCategories[index].value.first.foodCatName;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: index == 0
                                              ? isDesktop
                                                  ? (isLandscape ? screenHeight * 0.04 : screenHeight * 0)
                                                  : (isLandscape ? screenHeight * 0.03 : screenHeight * 0.025)
                                              : isDesktop
                                                  ? (isLandscape ? screenHeight * 0.04 : screenHeight * 0.05)
                                                  : (isLandscape ? screenHeight * 0.05 : screenHeight * 0.065),
                                          bottom: isDesktop ? (isLandscape ? 16 : 10) : bottomPadding + 8,
                                          left: horizontalPadding,
                                          right: horizontalPadding,
                                        ),
                                        child: Text(
                                          displayCategoryName,
                                          style: TextStyle(
                                            fontSize: headerFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: isLandscape ? 4 : (screenWidth < 350 ? 1 : 2),
                                          crossAxisSpacing: isDesktop ? (isLandscape ? 10 : 6) : 20.0,
                                          mainAxisSpacing: isDesktop ? (isLandscape ? 10 : 6) : 20.0,
                                          childAspectRatio: isDesktop ? (isLandscape ? 4 / 4 : 4 / 4.3) : (isLandscape ? 4 / 4 : 4 / 4.36),
                                        ),
                                        itemCount: state.categorizedByFoodCat[categoryKey]?.length ?? 0,
                                        itemBuilder: (context, foodIndex) {
                                          final foodList = state.categorizedByFoodCat[categoryKey] ?? [];
                                          final food = foodList[foodIndex];

                                          return GestureDetector(
                                            onTap: () {
                                              if (!food.isOutStock) {
                                                context.read<OrderBloc>().add(AddToOrder(food));
                                              }
                                            },
                                            child: buildFoodItem(food, cardWidth, cardHeight),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text("❌ Failed to load food data"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: sidebarWidth,
            child: const OrderSummary(),
          )
        ],
      ),
    );
  }

  Widget buildFoodItem(Food food, double cardWidth, double cardHeight) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double foodNameFontSize = (screenWidth * (isLandscape ? 0.018 : 0.024)).clamp(6.0, 13.0);
    double foodDescFontSize = (screenWidth * (isLandscape ? 0.016 : 0.022)).clamp(5.5, 11.0);
    double priceFontSize = (screenWidth * 0.020).clamp(6.5, 13.0);
    final imageHeight = cardHeight * 0.45;

    return SizedBox(
      width: cardWidth.clamp(140.0, 300.0),
      height: cardHeight.clamp(160.0, 300.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: food.imageName.startsWith("http")
                      ? Image.network(
                          food.imageName,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppAssets.noImage,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image.asset(
                          food.imageName,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            food.foodName,
                            style: TextStyle(
                              fontSize: foodNameFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            food.foodDesc.isNotEmpty ? food.foodDesc : "No description available",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: foodDescFontSize,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            food.isOutStock ? "Out of Stock" : "\$${food.foodPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: priceFontSize,
                              fontWeight: FontWeight.bold,
                              color: food.isOutStock ? Colors.red : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (food.isOutStock)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: cardHeight * 0.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(
                        fontSize: isDesktopDevice ? 15 : cardHeight * 0.11,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 52, 51, 51),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
