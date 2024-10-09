import 'package:flutter/material.dart';

class SnacksPage extends StatefulWidget {
  @override
  _SnacksPageState createState() => _SnacksPageState();
}

class _SnacksPageState extends State<SnacksPage> {
  // A list of snacks with names, images, and prices
  final List<Map<String, String>> snacks = [
    {'name': 'Chips', 'image': 'assets/chips.png', 'price': '2.99'},
    {'name': 'Cookies', 'image': 'assets/cookies.png', 'price': '3.49'},
    {'name': 'Popcorn', 'image': 'assets/popcorn.png', 'price': '1.99'},
    {'name': 'Cake', 'image': 'assets/cake.png', 'price': '2.79'},
    {'name': 'Candy', 'image': 'assets/candy.png', 'price': '1.49'},
    {
      'name': 'Chocolate',
      'image': 'assets/dark_chocolate.png',
      'price': '4.99'
    },
    {'name': 'Cream Bun', 'image': 'assets/creambun.png', 'price': '3.19'},
    {'name': 'Cup Cake', 'image': 'assets/cupcake.png', 'price': '2.49'},
  ];

  // Track favorites and cart items
  Set<String> favorites = {};
  Set<String> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snacks'),
      ),
      body: ListView.builder(
        itemCount: snacks.length,
        itemBuilder: (context, index) {
          final snack = snacks[index];
          final snackName = snack['name'];
          final snackImage = snack['image'];
          final snackPrice = snack['price'];

          return Card(
            child: ListTile(
              leading: Image.asset(snackImage!, width: 50, height: 50),
              title: Text('$snackName - \$$snackPrice'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      favorites.contains(snackName)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorites.contains(snackName) ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favorites.contains(snackName)) {
                          favorites.remove(snackName);
                        } else {
                          favorites.add(snackName!);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      cart.contains(snackName)
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                    ),
                    onPressed: () {
                      setState(() {
                        if (cart.contains(snackName)) {
                          cart.remove(snackName);
                        } else {
                          cart.add(snackName!);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}