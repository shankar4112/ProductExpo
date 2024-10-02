import 'package:flutter/material.dart';

// Model class for cart items
class CartItem {
  String title;
  int quantity;
  double price;

  CartItem({required this.title, required this.quantity, required this.price});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CartItem> cartItems = [];
  List<String> favoriteItems = []; // List to store favorite items
  int cartCount = 0;
  int favoriteCount = 0; // Number of favorite items
  bool isCartVisible = false;
  bool isFavoritesVisible = false; // New variable for favorites visibility

  void addToCart(String title, double price) {
    setState(() {
      int index = cartItems.indexWhere((item) => item.title == title);
      if (index != -1) {
        cartItems[index].quantity += 1;
      } else {
        cartItems.add(CartItem(title: title, quantity: 1, price: price));
      }
      cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
    });
  }

  void removeFromCart(String title) {
    setState(() {
      int index = cartItems.indexWhere((item) => item.title == title);
      if (index != -1) {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity -= 1;
        } else {
          cartItems.removeAt(index);
        }
      }
      cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
    });
  }

  void toggleCartVisibility() {
    setState(() {
      isCartVisible = !isCartVisible;
      isFavoritesVisible = false; // Hide favorites when cart is shown
    });
  }

  void toggleFavoritesVisibility() {
    setState(() {
      isFavoritesVisible = !isFavoritesVisible;
      isCartVisible = false; // Hide cart when favorites are shown
    });
  }

  void addToFavorites(String title) {
    setState(() {
      if (!favoriteItems.contains(title)) {
        favoriteItems.add(title);
        favoriteCount++; // Increase favorite count
      }
    });
  }

  void removeFromFavorites(String title) {
    setState(() {
      favoriteItems.remove(title);
      favoriteCount--; // Decrease favorite count
    });
  }

  void navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage(favoriteItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KECGo!'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Favorite button with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed:
                    toggleFavoritesVisibility, // Toggle favorites visibility
              ),
              if (favoriteCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 8, // Smaller radius for a smaller badge
                    backgroundColor: Colors.red,
                    child: Text(
                      '$favoriteCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: toggleCartVisibility, // Toggle cart visibility
              ),
              if (cartCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 8, // Adjusted to make it smaller
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          buildProductList(),
          if (isCartVisible)
            buildCartView(), // Display the cart view if visible
          if (isFavoritesVisible)
            buildFavoritesView(), // Display favorites view if visible
        ],
      ),
    );
  }

  Widget buildProductList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to SnacksPage when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SnacksPage()),
                    );
                  },
                  child: _buildCategoryItem('Snacks',
                      'https://tse3.mm.bing.net/th?id=OIP.l9oe3pbUBIlVznzWEIktcwHaFc&pid=Api&P=0&h=180'),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to XeroxPage when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const XeroxPage()),
                    );
                  },
                  child: _buildCategoryItem('Xerox',
                      'https://atzone.in/wp-content/uploads/2017/11/XeroxShop.jpg'),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to StationaryPage when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StationaryPage()),
                    );
                  },
                  child: _buildCategoryItem('Stationaries',
                      'https://tse1.mm.bing.net/th?id=OIP.BQTt5vaPXomBjewK-99-uQHaEv&pid=Api&P=0&h=180'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Best Selling Section
            const Text(
              'Best Selling',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: 4, // Number of products
              itemBuilder: (context, index) {
                return _buildProductCard(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    List<String> productTitles = [
      'Hot Coffee',
      'Soft Icecream',
      'Puffs',
      'Stationary'
    ];
    List<String> productImages = [
      'https://wallpaperaccess.com/full/1076692.jpg',
      'https://tse1.mm.bing.net/th?id=OIP.holCZHUmRNNxEGvme6CjzAAAAA&pid=Api&P=0&h=180',
      'https://1.bp.blogspot.com/-EBFQWE03Sbc/YABK95RXCYI/AAAAAAAAZX0/Tji-GVpKiLgkZ0hadWH6HymqFhJ-nqRawCLcBGAsYHQ/s2048/egg%2Bpuffs%2B11.JPG',
      'https://tse3.mm.bing.net/th?id=OIP.L9qhaL2rAzHgRPibN9tWmwHaE8&pid=Api&P=0&h=180'
    ];
    List<double> productPrices = [15.0, 20.0, 25.0, 10.0];

    bool isLiked = favoriteItems.contains(productTitles[index]);

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            // You can optionally handle any actions when the card is tapped
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(productImages[index], height: 80),
                const SizedBox(height: 10),
                Text(productTitles[index],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Rs.${productPrices[index]}',
                    style: const TextStyle(color: Colors.blue, fontSize: 16)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Like button
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isLiked) {
                            removeFromFavorites(productTitles[index]);
                          } else {
                            addToFavorites(productTitles[index]);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    // Cart icon with onPressed event
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.blue),
                      onPressed: () {
                        addToCart(
                            productTitles[index],
                            productPrices[
                                index]); // Add to cart on pressing the cart button
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCartView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 350, // Increased height to accommodate the button
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Your Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Row(
                      children: [
                        // Decrease quantity button
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            removeFromCart(item.title);
                          },
                        ),
                        // Display current quantity
                        Text('Quantity: ${item.quantity}'),
                        // Increase quantity button
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            addToCart(item.title, item.price);
                          },
                        ),
                      ],
                    ),
                    trailing: Text('Rs.${item.price * item.quantity}'),
                  );
                },
              ),
            ),
            // Proceed to Checkout button
            ElevatedButton(
              onPressed: () {
                // Handle the checkout process here
                // For example, navigate to a checkout page or show a confirmation dialog
                proceedToCheckout();
              },
              child: const Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }

// Function to handle checkout
  void proceedToCheckout() {
    // You can implement your checkout logic here
    // For example, show a dialog or navigate to another screen
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: const Text('Proceeding to checkout...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget buildFavoritesView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Your Favorites',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(favoriteItems[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        removeFromFavorites(favoriteItems[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page to display favorite items
class FavoritesPage extends StatelessWidget {
  final List<String> favoriteItems;

  const FavoritesPage(this.favoriteItems, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Items')),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('No favorite items yet.'))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteItems[index]),
                );
              },
            ),
    );
  }
}

// Placeholder pages for snacks, xerox, and stationary
class SnacksPage extends StatelessWidget {
  const SnacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snacks')),
      body: const Center(child: Text('Snacks Page')),
    );
  }
}

class XeroxPage extends StatelessWidget {
  const XeroxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xerox')),
      body: const Center(child: Text('Xerox Page')),
    );
  }
}

class StationaryPage extends StatelessWidget {
  const StationaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stationary')),
      body: const Center(child: Text('Stationary Page')),
    );
  }
}
