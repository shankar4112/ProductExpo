import 'package:flutter/material.dart';

class KecFcScreen extends StatelessWidget {
  const KecFcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KEC_Go!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Amenity...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Categories Section
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
                  _buildCategoryItem('Snacks',
                      'https://tse3.mm.bing.net/th?id=OIP.l9oe3pbUBIlVznzWEIktcwHaFc&pid=Api&P=0&h=180'),
                  _buildCategoryItem('Xerox',
                      'https://atzone.in/wp-content/uploads/2017/11/XeroxShop.jpg'),
                  _buildCategoryItem('Stationaries',
                      'https://tse1.mm.bing.net/th?id=OIP.BQTt5vaPXomBjewK-99-uQHaEv&pid=Api&P=0&h=180'),
                ],
              ),
              const SizedBox(height: 20),

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
      ),
    );
  }

  // Category Item Widget
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

  // Best Selling Product Card
  Widget _buildProductCard(int index) {
    List<String> productImages = [
      'https://wallpaperaccess.com/full/1076692.jpg',
      'https://tse1.mm.bing.net/th?id=OIP.holCZHUmRNNxEGvme6CjzAAAAA&pid=Api&P=0&h=180',
      'https://1.bp.blogspot.com/-EBFQWE03Sbc/YABK95RXCYI/AAAAAAAAZX0/Tji-GVpKiLgkZ0hadWH6HymqFhJ-nqRawCLcBGAsYHQ/s2048/egg%2Bpuffs%2B11.JPG',
      'https://tse3.mm.bing.net/th?id=OIP.L9qhaL2rAzHgRPibN9tWmwHaE8&pid=Api&P=0&h=180',
    ];

    List<String> productDescriptions = [
      'Savor the luxurious taste of our Decadent Hot Coffee',
      'Indulge in the rich, buttery layers of our soft icecreams.',
      'Delight in our Classic Egg Puffs, a savory treat with a perfectly flaky pastry filled with seasoned scrambled eggs.',
      'Make yourself indulge in writing.',
    ];

    List<String> productTitle = [
      'Hot Coffee',
      'Soft Icecream',
      'Puffs',
      'Stationary'
    ];
    List<String> productPrice = ['Rs.15', 'Rs.20', 'Rs.25', 'Rs.10'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              productImages[index],
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 80);
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            productTitle[index],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            productDescriptions[index],
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            productPrice[index],
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.favorite_border, color: Colors.blue),
              Icon(Icons.shopping_cart_outlined, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}
