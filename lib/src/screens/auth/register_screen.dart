import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatelessWidget {
  // Text controllers to get user input
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to handle registration
  Future<void> _register(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validate input
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, 'All fields are required');
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'Passwords do not match');
      return;
    }

    try {
      // Register the user using Supabase
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // Check if the user is successfully registered
      if (response.user != null) {
        // Insert profile into the profiles table
        final insertResponse = await Supabase.instance.client
            .from('profiles') // Ensure this matches your table name
            .insert({
          'id': response.user!.id, // Match auth.users.id
          'username': username, // Add username
          'email': email, // Add email
          'role': 'user', // Default role; can later be updated to admin
        });

        if (insertResponse.error == null) {
          _showMessage(context, 'Registration successful');
        } else {
          _showMessage(context, 'Failed to create profile: ${insertResponse.error!.message}');
        }
      } else {
        _showMessage(context, 'Unexpected error occurred during registration');
      }
    } on AuthException catch (e) {
      // Handle authentication errors
      _showMessage(context, 'Auth error: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors
      _showMessage(context, 'Unexpected error: $e');
    }
  }

  // Function to display messages
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 20.0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context); // Navigate back to the previous screen
                          },
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 48.0,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png', // Ensure logo path is correct
                        height: 150.0,
                        width: 150.0,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Navigate back to Login Screen
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x65FFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Text(
                                "SIGN IN",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {}, // Keep this button active for the current screen
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x65C7D6B6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "HELLO!",
                        style: GoogleFonts.lato(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "New User",
                        style: GoogleFonts.lato(fontSize: 14.0),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "USERNAME",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "EMAIL ADDRESS",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "PASSWORD",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "CONFIRM PASSWORD",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () => _register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA4C3A3),
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("SIGN UP"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
