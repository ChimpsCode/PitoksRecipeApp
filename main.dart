// This app contains various food recipes from around the world.
// To make your recipe app user-friendly and engaging, and help users discover and cook delicious meals,
// the possible features are the following:
// - Ingredients and Instructions/Procedures
// - Recipe Search and Filters
// - Recipe Categories
// - Nutritional Information
// - Meal Planner
// - others

import 'package:flutter/material.dart';
import 'package:recipe/screen/RecipePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePreferences();
  runApp(const MainApp());
}

Future<void> initializePreferences() async {
  // ignore: unused_local_variable
  final prefs = await SharedPreferences.getInstance();
  // Logika inisialisasi lainnya
  // Contoh menyimpan nilai default
  // await prefs.setString('key', 'value');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pitoks.png', width: 300, height: 300),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Pitoks Recipe',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Recipepage()),
                );
              },
                child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 58, 146, 194),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
