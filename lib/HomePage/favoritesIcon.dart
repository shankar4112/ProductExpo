import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';

class FavoritesIcon extends StatelessWidget {
  const FavoritesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: provider.toggleFavoritesVisibility, // Ensure this matches the provider method
            ),
            if (provider.favoriteCount > 0)
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${provider.favoriteCount}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
