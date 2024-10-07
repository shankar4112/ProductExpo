class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  int quantity; // Make quantity mutable

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.quantity,
  });

  // Add the copyWith method
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  // Assuming you already have a fromMap method
  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      quantity: data['quantity'] ?? 1, // Default quantity to 1 if not provided
    );
  }

  // Define totalPrice as a getter
  double get totalPrice => price * quantity; // Total price based on quantity
}
