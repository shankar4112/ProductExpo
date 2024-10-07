import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'pages/intro.dart'; // Import the Onboarding screen
import 'LoginSignup/Screen/login.dart'; // Import the LoginScreen
import 'pages/ChooseOptionScreen.dart'; // Import the Home Screen (ChooseOptionScreen)

const String seenOnboardingKey = 'seenOnboarding'; // Constant for onboarding key
const String isLoggedInKey = 'isLoggedIn'; // Constant for login key

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    // Handle any initialization errors here
    print("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Map<String, bool>> _checkOnboardingAndLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool(seenOnboardingKey) ?? false;
    bool loggedIn = prefs.getBool(isLoggedInKey) ?? false;
    return {
      'seenOnboarding': seenOnboarding,
      'isLoggedIn': loggedIn,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KEC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: FutureBuilder<Map<String, bool>>(
        future: _checkOnboardingAndLoginStatus(), // Wait for the onboarding and login status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Handle errors
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Determine the initial screen based on onboarding and login status
          bool seenOnboarding = snapshot.data?['seenOnboarding'] ?? false;
          bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;

          if (!seenOnboarding) {
            return const OnboardingScreen(); // Show onboarding if not seen
          } else if (isLoggedIn) {
            return const ChooseOptionScreen(); // Show home screen if logged in
          } else {
            return const LoginScreen(); // Show login screen if not logged in
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(), // Route to login page
        '/chooseOption': (context) => const ChooseOptionScreen(), // Route to home screen
      },
    );
  }
}
