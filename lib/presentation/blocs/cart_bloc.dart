import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Shared cart state across Home, Details and Cart screens.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartAdd>((event, emit) {
      if (event.quantity < 1) return;
      final updated = [...state.items];
      final index = updated.indexWhere((e) => e.meal.id == event.meal.id);
      if (index == -1) {
        updated.add(CartItem(meal: event.meal, quantity: event.quantity));
      } else {
        updated[index] = updated[index].copyWith(
          quantity: updated[index].quantity + event.quantity,
        );
      }
      _update(updated, emit);
    });
    on<CartIncrease>((event, emit) {
      final updated = [...state.items];
      final index = updated.indexWhere((e) => e.meal.id == event.mealId);
      if (index < 0) return;
      updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
      _update(updated, emit);
    });
    on<CartDecrease>((event, emit) {
      final updated = [...state.items];
      final index = updated.indexWhere((e) => e.meal.id == event.mealId);
      if (index < 0) return;
      if (updated[index].quantity <= 1) {
        updated.removeAt(index);
      } else {
        updated[index] = updated[index].copyWith(quantity: updated[index].quantity - 1);
      }
      _update(updated, emit);
    });
    on<CartRemove>((event, emit) {
      final updated = state.items.where((e) => e.meal.id != event.mealId).toList();
      if (updated.length != state.items.length) _update(updated, emit);
    });
    on<CartClear>((event, emit) => _update([], emit));
  }

  void _update(List<CartItem> items, Emitter<CartState> emit) {
    emit(CartState(items: List.unmodifiable(items), revision: state.revision + 1));
  }
}
