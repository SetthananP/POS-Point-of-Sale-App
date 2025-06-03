part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class LoadFood extends FoodEvent {}

class ChangeFoodSet extends FoodEvent {
  final String foodSetId;
  const ChangeFoodSet(this.foodSetId);

  @override
  List<Object> get props => [foodSetId];
}

class ChangeCategory extends FoodEvent {
  final String categoryId;
  const ChangeCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchFood extends FoodEvent {
  final String query;
  const SearchFood(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends FoodEvent {}
