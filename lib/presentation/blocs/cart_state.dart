import '../../domain/entities/cart_item.dart';

class CartState {
  const CartState({this.items = const [], this.revision = 0});
  final List<CartItem> items;
  final int revision;

  bool get isEmpty => items.isEmpty;
  int get count => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => items.isEmpty ? 0 : 2.99;
  double get total => subtotal + deliveryFee;
}
