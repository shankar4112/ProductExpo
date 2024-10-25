import 'package:flutter/material.dart'; // Ensure correct import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kecapp/HomePage/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:kecapp/HomePage/product_model.dart'; // Import the shared Product model

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    // Using StreamBuilder to fetch products dynamically from Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading products'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        final List<Product> products = snapshot.data!.docs.map((doc) {
          return Product(
            id: doc.id,
            name: doc['name'],
            price: doc['price'].toDouble(),
            description: doc['description'],
            imageUrl: doc['imageUrl'],
            quantity: doc['quantity'], // default or stored quantity
          );
        }).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product);
          },
        );
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$0${(product.price * product.quantity).toStringAsFixed(2)}', // Use quantity for total price
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
          'totalPrice': product.price *
              (currentQuantity + 1), // Update total price in Firestore
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
          'totalPrice': product.price, // Initial price = unit price
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
        addToFirestore(product); // Update Firestore and local quantity

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
        Provider.of<HomeProvider>(context, listen: false)
            .addToFavorites(product);
        // Add to favorites action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Favorites')),
        );
      },
      child: const Text('Favorites'),
    );
  }
}