import 'package:flutter/material.dart';

class CartItem {
  String title;
  int quantity;
  double price;

  CartItem({required this.title, required this.quantity, required this.price});
}

class CartModule extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(String title, double price) {
    int index = _cartItems.indexWhere((item) => item.title == title);
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void removeFromCart(String title) {
    int index = _cartItems.indexWhere((item) => item.title == title);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
    }
    notifyListeners();
  }

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}
