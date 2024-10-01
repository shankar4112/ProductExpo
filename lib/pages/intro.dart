import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView to slide between intro pages
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPageContent(
                image: 'assets/self-checkout.png',
                title: "Order from the Menu",
                content:
                    "Select and order food or items from our menu in just a few taps!",
              ),
              _buildPageContent(
                image: 'assets/instantbooking.webp',
                title: "Instant Booking",
                content: "Reserve items for pick-up at your convenience.",
              ),
              _buildPageContent(
                image: 'assets/teacherandstudent.webp',
                title: "For Students and Teachers",
                content: "Available exclusively for KEC students and teachers.",
              ),
            ],
          ),

          Positioned(
            top: 50,
            right: 20,
            child: _currentPage != totalPages - 1
                ? TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(totalPages - 1);
                    },
                    child: Text("Skip"),
                  )
                : Container(),
          ),
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width * 0.45,
            child: Row(
              children: List.generate(totalPages, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < totalPages - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  _completeOnboarding(context);
                }
              },
              child: Text(
                _currentPage == totalPages - 1 ? "Get Started" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save onboarding status and navigate to login page
  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true); // Set onboarding as seen
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Navigate to login page
  }

  Widget _buildPageContent(
      {required String image, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
