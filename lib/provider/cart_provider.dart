import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/CartItems_Model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalItemsInCart =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem cartItem) {
    _cartItems.add(cartItem);
    notifyListeners(); // Notify listeners about the change
  }

  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.item.id == itemId);
    notifyListeners(); // Notify listeners about the change
  }
}
