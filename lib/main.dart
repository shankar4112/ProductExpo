import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:kecapp/pages/login.dart'; // Import LoginPage here
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'pages/intro.dart'; // Import the Onboarding screen
import 'LoginSignup/Screen/login.dart';
// import 'pages
//
//
///bottom_nav.dart'; // Import your BottomNav or other main screen
import 'pages/ChooseOptionScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _seenOnboarding = false; // Initialize as false

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus(); // Check the onboarding status when app starts
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen =
        prefs.getBool('seenOnboarding') ?? false; // Get the saved status
    setState(() {
      _seenOnboarding = seen; // Update the state based on the flag
    });
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
      // Show either the onboarding screen (if not seen) or login/main screen
      home: _seenOnboarding ? LoginScreen() : OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(), // Add the login page route
        '/chooseOption': (context) =>
            ChooseOptionScreen(), // Add the bottom navigation or main page route
      },
    );
  }
}
