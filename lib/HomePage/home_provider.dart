import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kecapp/HomePage/product_model.dart'; // Import the shared Product model

class HomeProvider extends ChangeNotifier {
  List<Product> cartItems = [];
  List<Product> favoriteItems = [];
  bool isCartVisible = false;
  bool isFavoritesVisible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeProvider() {
    // Initialize the provider by fetching the cart items
    fetchCartItems();
  }

  int get cartCount => cartItems.length;
  int get favoriteCount => favoriteItems.length;

  Future<void> fetchCartItems() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in. Cannot fetch cart items.');
      return;
    }

    // Log the user ID for debugging
    print('Fetching cart items for user ID: ${user.uid}');

    // Fetch cart items from Firestore
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('carts')
        .get();

    // Check if the snapshot has documents
    if (snapshot.docs.isEmpty) {
      print('No cart items found.');
    } else {
      print('Cart items fetched: ${snapshot.docs.length}');
    }

    // Update cartItems
    cartItems = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromMap(data, doc.id);
    }).toList();

    notifyListeners();
  } catch (error) {
    print('Error fetching cart items: $error');
  }
}


  Future<void> updateItemQuantity(int index, int newQuantity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in.');
      return;
    }

    final Product item = cartItems[index]; // Access the product directly

    try {
      // Update the quantity and total price in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(item.id) // Use the document ID to update the quantity
          .update({
        'quantity': newQuantity,
        'totalPrice': item.price * newQuantity, // Update total price
      });

      // Update the quantity locally
      cartItems[index] = Product(
        id: item.id,
        name: item.name,
        price: item.price,
        description: item.description,
        imageUrl: item.imageUrl,
        quantity: newQuantity,
      );

      notifyListeners(); // Notify the UI to rebuild
    } catch (e) {
      print('Error updating item quantity: $e');
    }
  }

  Future<void> removeFromCart(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in.');
      return;
    }

    final Product item = cartItems[index]; // Access the product

    try {
      // Use the product's document ID to remove it from Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(item.id) // Use the document ID here
          .delete();

      // Remove item locally from the UI
      cartItems.removeAt(index);
      notifyListeners();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

Future<void> checkout() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No user is logged in.');
    return;
  }

  try {
    // Create order data
    final orderData = {
      'userId': user.uid,
      'items': cartItems.map((item) => {
        'productId': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      }).toList(),
      'totalAmount': cartItems.fold<int>(0, (sum, item) => sum + (item.price * item.quantity).toInt()),
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Add order to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add(orderData);

    // Clear cart in Firestore (if intended)
    for (var item in cartItems) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('carts')
          .doc(item.id) // Use the document ID here
          .delete();
    }

    // Clear local cart after successful checkout
    cartItems.clear();
    notifyListeners(); // Notify the UI to rebuild
  } catch (e) {
    print('Error during checkout: $e');
  }
}


  void toggleCartVisibility() {
    isCartVisible = !isCartVisible;
    notifyListeners();
  }

  void toggleFavoritesVisibility() {
    isFavoritesVisible = !isFavoritesVisible;
    notifyListeners();
  }

  void addToCart(Product product) {
  // Check if the product already exists in the cart
  final existingProductIndex = cartItems.indexWhere((item) => item.id == product.id);
  if (existingProductIndex != -1) {
    // If it exists, update the quantity in Firestore
    updateItemQuantity(existingProductIndex, cartItems[existingProductIndex].quantity + 1);
  } else {
    // If it doesn't exist, add product locally
    cartItems.add(product.copyWith(quantity: 1)); // Assuming a copyWith method in Product
    // Do not try to assign to totalPrice; instead, use the getter when needed
    notifyListeners();
  }
}


  void removeFromCartLocal(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  void addToFavorites(Product product) {
    favoriteItems.add(product); // Add product to favorites
    notifyListeners();
  }

  void removeFromFavorites(int index) {
    favoriteItems.removeAt(index);
    notifyListeners();
  }

 

  @override
  void dispose() {
    // Handle any cleanup here if necessary
    super.dispose();
  }
}
