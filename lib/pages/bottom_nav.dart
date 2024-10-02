import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'order.dart';
import 'profile.dart';
import 'wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomePage homepage;
  late OrderPage order;
  late ProfilePage profile;
  late WalletPage wallet;

  @override
  void initState() {
    homepage = const HomePage();
    order = const OrderPage();
    profile = const ProfilePage();
    wallet = const WalletPage();
    pages = [homepage, order, wallet, profile];
    currentPage = homepage; // Initialize with the home page
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[currentTabIndex]; // Update the current page
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.wallet_outlined, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
      body: currentPage, // Display the current page here
    );
  }
}
