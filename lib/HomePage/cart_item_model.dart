class CartItem {
  String title;
  int quantity;
  double price;

  CartItem({required this.title, required this.quantity, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
    );
  }
}
