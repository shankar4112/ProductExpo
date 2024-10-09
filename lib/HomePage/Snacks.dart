import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SnacksPage extends StatefulWidget {
  const SnacksPage({super.key});

  @override
  _SnacksPageState createState() => _SnacksPageState();
}

class _SnacksPageState extends State<SnacksPage> {
  // A list of snacks with the new structure
  final List<Map<String, dynamic>> snacks = [
  {
    'description': 'Tasty and crunchy chips.',
    'imageUrl': 'https://img.freepik.com/free-photo/fried-potatoes-french-fries-isolated-white-background_123827-26401.jpg?size=626&ext=jpg&ga=GA1.1.1308315130.1728445011&semt=ais_hybrid',
    'name': 'Chips',
    'price': 2.99,
    'quantity': 1, // Default quantity can be 1
    'totalPrice': 2.99,
  },
  {
    'description': 'Freshly baked cookies.',
    'imageUrl': 'https://img.freepik.com/premium-photo/stack-chocolate-chip-cookies-with-chocolate-chips-top_971034-48185.jpg?ga=GA1.1.1308315130.1728445011&semt=ais_hybrid',
    'name': 'Cookies',
    'price': 3.49,
    'quantity': 1,
    'totalPrice': 3.49,
  },
  {
    'description': 'Refreshing soda.',
    'imageUrl': 'https://img.freepik.com/premium-photo/refreshing-green-can-with-lime-slices-ice_825767-55207.jpg?ga=GA1.1.1308315130.1728445011&semt=ais_hybrid',
    'name': 'Soda',
    'price': 1.99,
    'quantity': 1,
    'totalPrice': 1.99,
  },
  {
    'description': 'Delicious cake.',
    'imageUrl': 'https://img.freepik.com/premium-photo/refreshing-green-can-with-lime-slices-ice_825767-55207.jpg?ga=GA1.1.1308315130.1728445011&semt=ais_hybrid',
    'name': 'Cake',
    'price': 2.79,
    'quantity': 1,
    'totalPrice': 2.79,
  },
  {
    'description': 'Sweet and colorful candy.',
    'imageUrl': 'https://img.freepik.com/premium-photo/slice-cake-dark-background_1271802-17251.jpg?ga=GA1.1.1308315130.1728445011&semt=ais_hybrid',
    'name': 'Candy',
    'price': 1.49,
    'quantity': 1,
    'totalPrice': 1.49,
  },
  {
    'description': 'Rich dark chocolate.',
    'imageUrl': 'https://via.placeholder.com/80',
    'name': 'Chocolate',
    'price': 4.99,
    'quantity': 1,
    'totalPrice': 4.99,
  },
  {
    'description': 'Soft and creamy cream bun.',
    'imageUrl': 'https://via.placeholder.com/80',
    'name': 'Cream Bun',
    'price': 3.19,
    'quantity': 1,
    'totalPrice': 3.19,
  },
  {
    'description': 'Moist and delightful cupcake.',
    'imageUrl': 'https://via.placeholder.com/80',
    'name': 'Cup Cake',
    'price': 2.49,
    'quantity': 1,
    'totalPrice': 2.49,
  },
];


  // Track favorites and cart items
  Set<String> favorites = {};
  Set<String> cart = {};

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to add item to Firestore cart collection
  Future<void> _addToCart(Map<String, dynamic> snack) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Add snack to the user's cart collection
        await _firestore.collection('users').doc(uid).collection('carts').add({
          'name': snack['name'],
          'description': snack['description'],
          'imageUrl': snack['imageUrl'],
          'price': snack['price'],
          'quantity': snack['quantity'],
          'totalPrice': snack['totalPrice'],
          'added_at': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${snack['name']} added to cart!')),
        );
      } else {
        // Handle unauthenticated user case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to add items to the cart')),
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${snack['name']} to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snacks'),
      ),
      body: ListView.builder(
        itemCount: snacks.length,
        itemBuilder: (context, index) {
          final snack = snacks[index];
          final snackName = snack['name'];
          final snackImageUrl = snack['imageUrl'];
          final snackDescription = snack['description'];
          final snackPrice = snack['price'];

          return Card(
            child: ListTile(
              leading: Image.network(snackImageUrl, width: 50, height: 50),
              title: Text('$snackName - Rs.${snackPrice.toStringAsFixed(2)}'),
              subtitle: Text(snackDescription),
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
                        if (!cart.contains(snackName)) {
                          cart.add(snackName!);
                          _addToCart(snack); // Add to Firestore
                        } else {
                          cart.remove(snackName);
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
