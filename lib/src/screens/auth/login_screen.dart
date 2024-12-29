import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/screens/dashboard/user_dashboard.dart';
import '/src/screens/dashboard/admin_dashboard.dart';
import 'register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle login
  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, 'Email and password are required');
      return;
    }

    try {
      // Authenticate the user
      final AuthResponse response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        // Fetch user details from profiles table
        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select('username, role')
            .eq('id', userId)
            .maybeSingle();

        if (profileResponse != null) {
          final username = profileResponse['username'];
          final role = profileResponse['role'];

          // Navigate based on role, passing username
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDashboard(username: username),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserDashboard(username: username),
              ),
            );
          }
        } else {
          _showMessage(context, 'No profile found for this user.');
        }
      } else {
        _showMessage(context, 'Invalid email or password');
      }
    } on AuthException catch (e) {
      _showMessage(context, 'Authentication error: ${e.message}');
    } catch (e) {
      _showMessage(context, 'Unexpected error: $e');
    }
  }

  // Function to show snack bar messages
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
                            Navigator.pop(context); // Back to the previous screen
                          },
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 48.0,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png', // Ensure your logo path is correct
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
                              onPressed: () {}, // Already on this screen
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x65C7D6B6),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x65FFFFFF),
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
                        "WELCOME!",
                        style: GoogleFonts.lato(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "SIGN IN TO CONTINUE",
                        style: GoogleFonts.lato(fontSize: 14.0),
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
                      const SizedBox(height: 10.0),
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
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA4C3A3),
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("LOG IN"),
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
