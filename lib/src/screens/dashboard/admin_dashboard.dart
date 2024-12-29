import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final String username; // Accept the username dynamically

  const AdminDashboard({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'), // Display dynamic username
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Colors.lightGreen,
            ),
            const SizedBox(height: 20),
            Text(
              'Hello, Admin $username!', // Personalize welcome message
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is your admin dashboard. Manage users, settings, and more.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Add functionality for managing users
                _manageUsers(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Manage Users'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add functionality for viewing reports
                _viewReports(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('View Reports'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  // Navigate to Home functionality
                  _navigateHome(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to Settings functionality
                  _navigateSettings(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Log out functionality
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder for managing users
  void _manageUsers(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manage Users functionality not implemented')),
    );
  }

  // Placeholder for viewing reports
  void _viewReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View Reports functionality not implemented')),
    );
  }

  // Navigate to Home functionality
  void _navigateHome(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Home functionality not implemented')),
    );
  }

  // Navigate to Settings functionality
  void _navigateSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Settings functionality not implemented')),
    );
  }

  // Logout functionality
  void _logout(BuildContext context) {
    // Replace this with actual logout logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout functionality not implemented')),
    );

    // Example: Navigate back to Login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
