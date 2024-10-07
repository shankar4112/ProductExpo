import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      
      body: provider.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.cartItems[index];

                      return ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${item.price.toStringAsFixed(2)}'),
                            const SizedBox(height: 4),
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  provider.updateItemQuantity(index, item.quantity - 1);
                                } else {
                                  provider.removeFromCart(index); // Remove if quantity is 0
                                }
                              },
                            ),
                            Text('${item.quantity}'), // Display the quantity
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                provider.updateItemQuantity(index, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${provider.cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Perform checkout
                          await provider.checkout();
                          // Show confirmation message or navigate to orders page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout successful!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // Optionally navigate to orders page
                          // Navigator.pushReplacementNamed(context, '/orders');
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
