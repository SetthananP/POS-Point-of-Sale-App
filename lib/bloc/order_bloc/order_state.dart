import 'package:equatable/equatable.dart';
import '../../models/food_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoaded extends OrderState {
  final List<MapEntry<Food, int>> orders;
  final double subtotal;

  const OrderLoaded(this.orders, this.subtotal);

  @override
  List<Object> get props => [orders, subtotal];
}
