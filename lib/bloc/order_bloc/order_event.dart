import 'package:equatable/equatable.dart';
import '../../models/food_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class AddToOrder extends OrderEvent {
  final Food food;
  const AddToOrder(this.food);

  @override
  List<Object?> get props => [food];
}

class IncreaseOrderQuantity extends OrderEvent {
  final int index;
  const IncreaseOrderQuantity(this.index);

  @override
  List<Object?> get props => [index];
}

class DecreaseOrderQuantity extends OrderEvent {
  final int index;
  const DecreaseOrderQuantity(this.index);

  @override
  List<Object?> get props => [index];
}

class ResetOrder extends OrderEvent {
  const ResetOrder();
}
