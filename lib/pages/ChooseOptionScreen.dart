import 'package:flutter/material.dart';
// import 'kec_amenity.dart'; // Import the KEC Amenity screen
import '../HomePage/bottom_nav.dart';
import 'fcnav.dart';

class ChooseOptionScreen extends StatelessWidget {
  final Map<String, dynamic>? user; // Add a parameter for user data

  const ChooseOptionScreen({super.key, this.user}); // Update the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KECGo!'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 13, 151, 161), // Start color
              Color.fromARGB(255, 255, 255, 255), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // KEC Amenity Option
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNav(user: user), // Pass user data
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 200, // Set the button width
                    height: 250, // Set the button height
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/kec_amenity.png', height: 120),
                          const SizedBox(height: 10),
                          const Text(
                            'KEC Amenity',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                // KEC Foodcourt Option
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Fcnav()),
                    );
                  },
                  child: SizedBox(
                    width: 200, // Set the button width
                    height: 250, // Set the button height
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/kec_foodcourt.png', height: 120),
                          const SizedBox(height: 10),
                          const Text(
                            'KEC Foodcourt',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
