part of 'food_bloc.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<Food> foods;
  final String selectedFoodSet;
  final String selectedCategory;
  final Map<String, List<Food>> categorizedByFoodSet;
  final Map<String, List<Food>> categorizedByFoodCat;

    final bool isSearching;
  final List<Food> searchResults;

  const FoodLoaded({
    required this.foods,
    required this.selectedFoodSet,
    required this.selectedCategory,
    required this.categorizedByFoodSet,
    required this.categorizedByFoodCat,
    this.isSearching = false,
    this.searchResults = const [],
  });

  @override
  List<Object> get props => [
        foods,
        selectedFoodSet,
        selectedCategory,
        categorizedByFoodSet,
        categorizedByFoodCat,
        isSearching,
        searchResults,
      ];
}

class FoodError extends FoodState {
  final String message;
  const FoodError(this.message);

  @override
  List<Object> get props => [message];
}
