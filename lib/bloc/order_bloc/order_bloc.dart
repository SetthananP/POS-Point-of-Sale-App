import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../models/food_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<AddToOrder>((event, emit) {
      final currentOrders = state is OrderLoaded
          ? List<MapEntry<Food, int>>.from((state as OrderLoaded).orders)
          : <MapEntry<Food, int>>[];

      currentOrders.add(MapEntry(event.food, 1));
      emit(OrderLoaded(currentOrders, _calculateSubtotal(currentOrders)));
    });

    on<IncreaseOrderQuantity>((event, emit) {
      if (state is OrderLoaded) {
        final currentOrders =
            List<MapEntry<Food, int>>.from((state as OrderLoaded).orders);
        final entry = currentOrders[event.index];
        currentOrders[event.index] = MapEntry(entry.key, entry.value + 1);
        emit(OrderLoaded(currentOrders, _calculateSubtotal(currentOrders)));
      }
    });

    on<DecreaseOrderQuantity>((event, emit) {
      if (state is OrderLoaded) {
        final currentOrders =
            List<MapEntry<Food, int>>.from((state as OrderLoaded).orders);
        final entry = currentOrders[event.index];
        if (entry.value > 1) {
          currentOrders[event.index] = MapEntry(entry.key, entry.value - 1);
        } else {
          currentOrders.removeAt(event.index);
        }
        emit(OrderLoaded(currentOrders, _calculateSubtotal(currentOrders)));
      }
    });

    on<ResetOrder>((event, emit) {
      emit(OrderInitial());
    });
  }

  double _calculateSubtotal(List<MapEntry<Food, int>> orders) {
    return orders.map((entry) => entry.key.foodPrice * entry.value).sum;
  }
}
