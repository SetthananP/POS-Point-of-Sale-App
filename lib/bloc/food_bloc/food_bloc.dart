import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/food_model.dart';
import '../../repositories/food_repository.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository foodRepository;

  List<Food> allFoods = [];
  Map<String, List<Food>> categorizedByFoodSet = {};
  Map<String, List<Food>> categorizedByFoodCat = {};
  String selectedFoodSet = "";
  String selectedCategory = "";

  FoodBloc({required this.foodRepository}) : super(FoodInitial()) {
    on<LoadFood>((event, emit) async {
      emit(FoodLoading());
      try {
        allFoods = await foodRepository.loadFoodData();
        if (allFoods.isEmpty) throw Exception("❌ No food data found!");

        categorizedByFoodSet.clear();
        categorizedByFoodCat.clear();

        for (var food in allFoods) {
          if (food.foodSetName != "Unknown Set") {
            categorizedByFoodSet
                .putIfAbsent(food.foodSetId, () => [])
                .add(food);
          }
        }

        categorizedByFoodSet = Map.fromEntries(
          categorizedByFoodSet.entries.toList()
            ..sort((a, b) => a.value.first.foodSetSorting
                .compareTo(b.value.first.foodSetSorting)),
        );

        Map<String, List<Food>> groupedFoodCategories = {};
        for (var food in allFoods) {
          String categoryKey =
              food.foodCatName.toUpperCase().replaceAll(RegExp(r'S$'), '');
          groupedFoodCategories.putIfAbsent(categoryKey, () => []).add(food);
        }

        categorizedByFoodCat = {};
        groupedFoodCategories.forEach((category, foodList) {
          Set<String> uniqueFoodNames = {};
          List<Food> uniqueFoods = [];

          for (var food in foodList) {
            if (!uniqueFoodNames.contains(food.foodName)) {
              uniqueFoodNames.add(food.foodName);
              uniqueFoods.add(food);
            }
          }

          categorizedByFoodCat[category] = uniqueFoods;
        });

        categorizedByFoodCat = Map.fromEntries(
          categorizedByFoodCat.entries.toList()
            ..sort((a, b) {
              int sortingA = a.value.isNotEmpty
                  ? a.value
                      .map((food) => food.foodCatSorting)
                      .reduce((min, next) => min < next ? min : next)
                  : 999;
              int sortingB = b.value.isNotEmpty
                  ? b.value
                      .map((food) => food.foodCatSorting)
                      .reduce((min, next) => min < next ? min : next)
                  : 999;
              return sortingA.compareTo(sortingB);
            }),
        );

        selectedFoodSet = categorizedByFoodSet.keys.isNotEmpty
            ? categorizedByFoodSet.keys.first
            : "DEFAULT_SET";

        _updateCategories();

        emit(FoodLoaded(
          foods: categorizedByFoodCat[selectedCategory] ?? [],
          selectedFoodSet: selectedFoodSet,
          selectedCategory: selectedCategory,
          categorizedByFoodSet: categorizedByFoodSet,
          categorizedByFoodCat: categorizedByFoodCat,
        ));
      } catch (error) {
        emit(FoodError("Failed to load food data: $error"));
      }
    });

    on<ChangeFoodSet>((event, emit) {
      if (categorizedByFoodSet.containsKey(event.foodSetId)) {
        selectedFoodSet = event.foodSetId;

        final foodsInSet = categorizedByFoodSet[selectedFoodSet] ?? [];

        Map<String, List<Food>> grouped = {};
        for (var food in foodsInSet) {
          String normalizedCatName = food.foodCatName.trim().toUpperCase();
          grouped.putIfAbsent(normalizedCatName, () => []);

          if (!grouped[normalizedCatName]!
              .any((f) => f.foodId == food.foodId)) {
            grouped[normalizedCatName]!.add(food);
          }
        }

        categorizedByFoodCat = Map.fromEntries(
          grouped.entries.toList()
            ..sort((a, b) {
              int sortA = a.value
                  .map((f) => f.foodCatSorting)
                  .reduce((a, b) => a < b ? a : b);
              int sortB = b.value
                  .map((f) => f.foodCatSorting)
                  .reduce((a, b) => a < b ? a : b);
              return sortA.compareTo(sortB);
            }),
        );

        _updateCategories();

        emit(FoodLoaded(
          foods: categorizedByFoodCat[selectedCategory] ?? [],
          selectedFoodSet: selectedFoodSet,
          selectedCategory: selectedCategory,
          categorizedByFoodSet: categorizedByFoodSet,
          categorizedByFoodCat: categorizedByFoodCat,
        ));
      }
    });

    on<ChangeCategory>((event, emit) {
      if (categorizedByFoodCat.containsKey(event.categoryId)) {
        selectedCategory = event.categoryId;
        emit(FoodLoaded(
          foods: const [],
          selectedFoodSet: selectedFoodSet,
          selectedCategory: selectedCategory,
          categorizedByFoodSet: categorizedByFoodSet,
          categorizedByFoodCat: categorizedByFoodCat,
        ));
      }
    });

    on<SearchFood>((event, emit) {
      if (event.query.isEmpty) {
        _updateCategories();
        emit(FoodLoaded(
          foods: categorizedByFoodCat[selectedCategory] ?? [],
          selectedFoodSet: selectedFoodSet,
          selectedCategory: selectedCategory,
          categorizedByFoodSet: categorizedByFoodSet,
          categorizedByFoodCat: categorizedByFoodCat,
        ));
      } else {
        final searchQuery = event.query.toLowerCase();

        final matchedFoods = allFoods.where((food) {
          return food.foodName.toLowerCase().contains(searchQuery) ||
              food.foodDesc.toLowerCase().contains(searchQuery) ||
              food.foodPrice.toStringAsFixed(2).contains(searchQuery);
        }).toList();

        Map<String, List<Food>> grouped = {};
        for (var food in matchedFoods) {
          String categoryKey = food.foodCatName
              .trim()
              .toUpperCase()
              .replaceAll(RegExp(r'S$'), '');
          grouped.putIfAbsent(categoryKey, () => []).add(food);
        }

        emit(FoodLoaded(
          foods: matchedFoods,
          selectedFoodSet: selectedFoodSet,
          selectedCategory: selectedCategory,
          categorizedByFoodSet: categorizedByFoodSet,
          categorizedByFoodCat: grouped,
          isSearching: true,
        ));
      }
    });

    on<ClearSearch>((event, emit) {
      _updateCategories();

      emit(FoodLoaded(
        foods: categorizedByFoodCat[selectedCategory] ?? [],
        selectedFoodSet: selectedFoodSet,
        selectedCategory: selectedCategory,
        categorizedByFoodSet: categorizedByFoodSet,
        categorizedByFoodCat: categorizedByFoodCat,
      ));
    });
  }
  void _updateCategories() {
    categorizedByFoodCat.clear();

    final foodsInSet = categorizedByFoodSet[selectedFoodSet] ?? [];

    for (var food in foodsInSet) {
      String normalizedCategory =
          food.foodCatName.trim().toUpperCase().replaceAll(RegExp(r'S$'), '');

      categorizedByFoodCat.putIfAbsent(normalizedCategory, () => []);
      Set<String> existingNames = categorizedByFoodCat[normalizedCategory]!
          .map((f) => f.foodName.toLowerCase())
          .toSet();

      if (!existingNames.contains(food.foodName.toLowerCase())) {
        categorizedByFoodCat[normalizedCategory]!.add(food);
      }
    }

    categorizedByFoodCat = Map.fromEntries(
      categorizedByFoodCat.entries.toList()
        ..sort((a, b) {
          int sortA = a.value
              .map((f) => f.foodCatSorting)
              .reduce((a, b) => a < b ? a : b);
          int sortB = b.value
              .map((f) => f.foodCatSorting)
              .reduce((a, b) => a < b ? a : b);
          return sortA.compareTo(sortB);
        }),
    );

    selectedCategory = categorizedByFoodCat.keys.first;
  }
}
