import 'package:flutter/material.dart';
import 'product_model.dart'; // Import your Product model

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.imageUrl),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontSize: 20)),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to add to cart
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
