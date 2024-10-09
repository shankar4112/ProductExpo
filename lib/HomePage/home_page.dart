import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartIcon.dart';
import 'favoritesIcon.dart';
import 'home_provider.dart';
import 'CartView.dart'; // Import CartView
import 'FavoritesView.dart'; // Import FavoritesView
import 'productList.dart'; // Import ProductList
import 'category_page.dart'; // Import CategoryPage
import 'Snacks.dart';
import 'Photocopy.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KECGo!'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            CartIcon(), // Accesses HomeProvider
            FavoritesIcon(), // Accesses HomeProvider
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Search Bar
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Categories
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryButton(label: 'Snacks'),
                      CategoryButton(label: 'Photocopy'),
                      CategoryButton(label: 'Stationery'),
                    ],
                  ),
                ),
                // Best Selling Items
                Expanded(
                  child: ProductList(), // List of best-selling products
                ),
              ],
            ),
            Consumer<HomeProvider>(
              builder: (context, provider, _) {
                if (provider.isCartVisible) return const CartView(); // Show CartView if cart is visible
                if (provider.isFavoritesVisible) return const FavoritesView(); // Show FavoritesView if favorites are visible
                return const SizedBox.shrink(); // Empty space if neither are visible
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Snacks') {
          // Navigate to SnacksPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SnacksPage()), // Link SnacksPage here
          );
        } else if(label == 'Photocopy') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhotocopyPage()),
          );
        } else {
          // Navigate to the respective category page for other categories
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage(label: label)),
          );
        }
      },
      child: Text(label),
    );
  }
}

