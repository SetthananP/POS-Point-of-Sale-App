import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_bloc/food_bloc.dart';
import '../bloc/order_bloc/order_bloc.dart';
import '../bloc/order_bloc/order_event.dart';
import '../widgets/constant.dart';
import '../widgets/device_utils.dart';

class FoodMenuHeader extends StatefulWidget {
  final Function(String) onCategorySelected;
  final Function(String) onFoodSetSelected;

  const FoodMenuHeader({
    super.key,
    required this.onCategorySelected,
    required this.onFoodSetSelected,
  });

  @override
  FoodMenuHeaderState createState() => FoodMenuHeaderState();
}

class FoodMenuHeaderState extends State<FoodMenuHeader> with SingleTickerProviderStateMixin {
  String selectedCategory = "";
  String selectedFoodSet = "";

  late TabController _tabController;

  bool showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodLoaded) {
          final isSearching = state.isSearching;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (!isSearching)
                if (!isSearching) _buildFoodSetTabs(state),
              if (!isSearching) const SizedBox(height: 10),
              if (!isSearching) _buildCategoryTabs(state),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double backFontSize = isDesktopDevice ? (isLandscape ? 20 : 12) : (screenWidth * (isLandscape ? 0.022 : 0.025)).clamp(14.0, 24.0);

    double iconSize = isDesktopDevice ? (isLandscape ? 20 : 12) : (screenWidth * 0.035).clamp(20.0, 32.0);

    return Padding(
      padding: EdgeInsets.only(
          top: isDesktopDevice ? (isLandscape ? 15.0 : 15.0) : (screenWidth * (isLandscape ? 0 : 0.1)).clamp(13.0, 42.0),
          left: isDesktopDevice ? (isLandscape ? 20.0 : 20.0) : (screenWidth * (isLandscape ? 0.015 : 0.1)).clamp(16.0, 39.0),
          right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isDesktopDevice ? (isLandscape ? 10 : 3) : screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<OrderBloc>().add(const ResetOrder());
                      context.read<FoodBloc>().add(ClearSearch());
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: iconSize * 0.85,
                      color: AppColors.greyText,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        AppStrings.back,
                        style: TextStyle(fontSize: backFontSize, fontFamily: AppFonts.body, color: AppColors.greyText, fontWeight: FontWeight.w200),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      backgroundColor: AppColors.greyText.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isDesktopDevice ? 6 : 12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: isDesktopDevice ? 12 : 8,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: showSearchBar ? _buildSearchBar() : _buildSearchIcon(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIcon() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > MediaQuery.of(context).size.height;
    final isDesktopDevice = isDesktop(context);

    final double iconSize = isDesktopDevice ? (isLandscape ? 20 : 20) : (screenWidth * 0.035).clamp(20.0, 30.0);
    final double paddingSize = (screenWidth * (isLandscape ? 0.02 : 0.05)).clamp(8.0, 16.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyText.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(paddingSize / 2.5),
      child: IconButton(
        onPressed: () {
          setState(() => showSearchBar = true);
          _searchController.clear();
        },
        icon: Icon(Icons.search, size: iconSize, color: Colors.black54),
        splashRadius: iconSize * 0.9,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildSearchBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > MediaQuery.of(context).size.height;
    final isDesktopDevice = isDesktop(context);

    final double iconSize = isDesktopDevice ? (isLandscape ? 18 : 16) : 18;
    final double fontSize = isDesktopDevice ? 14 : 13;
    final double height = isDesktopDevice ? 36 : 42;
    final double horizontalPadding = isDesktopDevice ? 10 : 12;

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.greyText.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyText.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: iconSize, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: fontSize),
              decoration: const InputDecoration(
                hintText: AppStrings.search,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (query) {
                context.read<FoodBloc>().add(SearchFood(query));
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: iconSize, color: Colors.black54),
            onPressed: () {
              setState(() => showSearchBar = false);
              _searchController.clear();
              context.read<FoodBloc>().add(ClearSearch());
            },
            splashRadius: iconSize * 0.9,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodSetTabs(FoodLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double paddingSize = isDesktopDevice ? (isLandscape ? 20.0 : 20.0) : (screenWidth * (isLandscape ? 0.05 : 0.05)).clamp(12.0, 26.0);

    double headerFontSize = isDesktopDevice ? (isLandscape ? 16.0 : 12.0) : (screenWidth * 0.03).clamp(12.0, 24.0);

    return Transform.translate(
      offset: Offset(
        0,
        isDesktopDevice ? (isLandscape ? 20 : 5) : (isLandscape ? 23 : 23),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isDesktopDevice ? 20 : 35,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.categorizedByFoodSet.entries.where((entry) => entry.value.first.foodSetName != "Unknown Set").map((entry) {
              final String foodSetId = entry.key;
              final String foodSetName = entry.value.first.foodSetName;
              final bool isSelected = foodSetId == state.selectedFoodSet;

              return GestureDetector(
                onTap: () {
                  context.read<FoodBloc>().add(ChangeFoodSet(foodSetId));
                  widget.onFoodSetSelected(foodSetId);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktopDevice ? (isLandscape ? 40 : 25) : paddingSize * 2,
                    vertical: isDesktopDevice ? (isLandscape ? 13 : 9) : (isLandscape ? paddingSize / 1.4 : paddingSize / 1.6),
                  ),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.tabbar : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(isDesktopDevice ? 5 : 10),
                    border: isSelected ? Border.all(color: AppColors.black, width: 1) : null,
                  ),
                  child: Text(
                    foodSetName,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.greyText,
                      fontSize: headerFontSize,
                      fontFamily: AppFonts.body,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(FoodLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final isDesktopDevice = isDesktop(context);

    double paddingSize = isDesktopDevice ? (isLandscape ? 18.0 : 14.0) : (screenWidth * (isLandscape ? 0.1 : 0.04)).clamp(12.0, 33.0);

    double tabFontSize = isDesktopDevice ? (isLandscape ? 16.0 : 8.0) : (screenWidth * (isLandscape ? 0.025 : 0.025)).clamp(6.0, 16.0);

    final categoryEntries = state.categorizedByFoodCat.entries.toList()
      ..sort((a, b) {
        if (a.value.isEmpty || b.value.isEmpty) return 0;
        int sortingA = a.value.map((food) => food.foodCatSorting).reduce((min, next) => min < next ? min : next);
        int sortingB = b.value.map((food) => food.foodCatSorting).reduce((min, next) => min < next ? min : next);
        return sortingA.compareTo(sortingB);
      });

    return Transform.translate(
      offset: Offset(
        0,
        isDesktopDevice ? (isLandscape ? 30 : 2) : (isLandscape ? 35 : 35),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isDesktopDevice ? 20 : 35,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(isDesktopDevice ? 6 : 12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: categoryEntries.map((entry) {
                final String categoryId = entry.key;
                final String foodCatName = entry.value.first.foodCatName;
                final bool isSelected = categoryId == state.selectedCategory;

                return GestureDetector(
                  onTap: () {
                    context.read<FoodBloc>().add(ChangeCategory(categoryId));
                    widget.onCategorySelected(categoryId);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktopDevice ? (isLandscape ? 25.0 : 14.0) : (isLandscape ? (paddingSize * 1.7) : (paddingSize * 0.8)),
                      vertical: isDesktopDevice ? (isLandscape ? 13.0 : 10.0) : (isLandscape ? (paddingSize / 1.4) : (paddingSize / 1.5)),
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.tabbar : Colors.transparent,
                      borderRadius: BorderRadius.circular(isDesktopDevice ? 6 : 12),
                    ),
                    child: Text(
                      foodCatName,
                      style: TextStyle(color: isSelected ? AppColors.white : AppColors.black, fontSize: tabFontSize, fontFamily: AppFonts.body),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
