import 'package:flutter/material.dart';  // Ensure correct import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kecapp/HomePage/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:kecapp/HomePage/product_model.dart'; // Import the shared Product model

class ProductList extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Snacks',
      price: 2.99,
      description: 'Tasty and crunchy snacks.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '2',
      name: 'Xerox',
      price: 0.10,
      description: 'Affordable photocopying services.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '3',
      name: 'Stationary',
      price: 1.50,
      description: 'Quality stationary items for your needs.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '4',
      name: 'Water Bottle',
      price: 5.00,
      description: 'Durable and eco-friendly water bottle.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '5',
      name: 'Notebooks',
      price: 3.50,
      description: 'Perfect for all your writing needs.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '6',
      name: 'Pens',
      price: 1.20,
      description: 'Smooth-writing pens for every occasion.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '7',
      name: 'Backpack',
      price: 25.99,
      description: 'Spacious and stylish backpack.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '8',
      name: 'Calculator',
      price: 12.49,
      description: 'Reliable calculator for students.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '9',
      name: 'Laptop Stand',
      price: 19.99,
      description: 'Ergonomic laptop stand for comfortable working.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
    Product(
      id: '10',
      name: 'Headphones',
      price: 29.99,
      description: 'Noise-cancelling headphones for music lovers.',
      imageUrl: 'https://via.placeholder.com/80',
      quantity: 1,
    ),
  ];

ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(product.price * product.quantity).toStringAsFixed(2)}', // Use quantity for total price
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quantity: ${product.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddToCartWidget(product: product),
                FavoritesWidget(product: product),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// AddToCartWidget
class AddToCartWidget extends StatelessWidget {
  final Product product;

  const AddToCartWidget({super.key, required this.product});

  Future<void> addToFirestore(Product product) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the product already exists in the cart
      QuerySnapshot cartItems = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('carts')
          .where('name', isEqualTo: product.name)
          .get();

      if (cartItems.docs.isNotEmpty) {
        // If the product exists, update the quantity
        DocumentSnapshot existingProduct = cartItems.docs.first;
        int currentQuantity = existingProduct['quantity'];
        
        // Increment quantity and update Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('carts')
            .doc(existingProduct.id)
            .update({
          'quantity': currentQuantity + 1,
          'totalPrice': product.price * (currentQuantity + 1),  // Update total price in Firestore
        });

        // Update local product quantity
        product.quantity = currentQuantity + 1;

      } else {
        // If the product does not exist, add it to the cart
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('carts')
            .add({
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'quantity': 1,
          'totalPrice': product.price,  // Initial price = unit price
        });

        // Set initial quantity locally
        product.quantity = 1;
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        addToFirestore(product);  // Update Firestore and local quantity

        // Show a message indicating the product has been added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added to Cart')),
        );
      },
      child: const Text('Add to Cart'),
    );
  }
}

// FavoritesWidget
class FavoritesWidget extends StatelessWidget {
  final Product product;

  const FavoritesWidget({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<HomeProvider>(context, listen: false).addToFavorites(product);
        // Add to favorites action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Favorites')),
        );
      },
      child: const Text('Favorites'),
    );
  }
}
