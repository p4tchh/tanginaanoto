import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/screens/auth/login_screen.dart'; // Import your LoginScreen or next screen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  Future<void> _onGetStartedPressed(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);

    // Navigate to the SessionChecker (Login or Dashboard)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/backgrounds/background_image.jpg', // Replace with your background image path
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Welcome Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo Section
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/logo.png', // Replace with your logo
                    height: 70,
                  ),
                ),
                const SizedBox(height: 20),
                // App Slogan or Title
                const Text(
                  'Turn Old into Gold',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Share, Create, and Inspire!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                // Animated "Get Started" Button
                ElevatedButton(
                  onPressed: () => _onGetStartedPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
