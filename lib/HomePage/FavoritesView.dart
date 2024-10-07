import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Favorites', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: provider.favoriteItems.length,
              itemBuilder: (context, index) {
                final item = provider.favoriteItems[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      provider.removeFromFavorites(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
