import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/screens/auth/login_screen.dart';
import 'src/screens/dashboard/user_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://qaqloaalyvtfdntwzxhg.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFhcWxvYWFseXZ0ZmRudHd6eGhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ2NzYxNDQsImV4cCI6MjA1MDI1MjE0NH0.cEdxFjw2QqrhV2QlgzBuW69eTy9mycQIVNWDikEwBn0',
    );
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SessionChecker(), // New session checker
    );
  }
}

class SessionChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      // No session, navigate to LoginScreen
      return LoginScreen();
    }

    // If session exists, fetch username and navigate
    return FutureBuilder<String?>(
      future: _fetchUsername(session.user!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return UserDashboard(username: 'Guest');
        }

        return UserDashboard(username: snapshot.data!);
      },
    );
  }

  Future<String?> _fetchUsername(String userId) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('username')
        .eq('id', userId)
        .maybeSingle();

    if (response != null && response['username'] != null) {
      return response['username'];
    }
    return null;
  }
}



