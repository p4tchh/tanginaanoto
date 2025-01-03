import 'package:flutter/material.dart';
import '/src/widgets/profile_menu.dart';
import '/src/widgets/featured_carousel.dart';
import '/src/widgets/notification_menu.dart';
import '/src/screens/marketplace/item_list_screen.dart';
import '/src/widgets/cart_section.dart';
import '/src/widgets/orders_section.dart';
import '/src/widgets/chat_section.dart';
import '/src/widgets/tutorials_section.dart';
import '/src/widgets/donations_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDashboard extends StatefulWidget {
  final String username; // Pass username from the backend

  const UserDashboard({Key? key, required this.username}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;
  String? _profileImageUrl; // Store profile image URL

  @override
  void initState() {
    super.initState();
    _loadProfilePicture(); // Fetch the profile picture from Supabase
  }

  Future<void> _loadProfilePicture() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId != null) {
        // Fetch the profile image URL from the profiles table
        final response = await Supabase.instance.client
            .from('profiles')
            .select('profile_image_url')
            .eq('id', userId)
            .maybeSingle();

        if (response != null) {
          setState(() {
            _profileImageUrl = response['profile_image_url'];
          });
        } else {
          print('No profile picture found.');
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(child: _pages[_currentIndex]),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // Top Bar Section
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProfileMenu(context), // Open the ProfileMenu
            child: CircleAvatar(
              radius: 20,
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!) // Load profile picture
                  : null,
              backgroundColor: Colors.lightGreen.shade200,
              child: _profileImageUrl == null
                  ? Icon(
                      Icons.account_circle,
                      size: 30.0,
                      color: Colors.lightGreen.shade700,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              "Welcome, ${widget.username}",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border, color: Colors.amber),
          ),IconButton(
            onPressed: () {
              final userId = Supabase.instance.client.auth.currentUser?.id;

              if (userId != null) {
                _showNotificationMenu(context, userId);
              } else {
                debugPrint('User ID is null. Cannot show notifications.');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You need to log in to view notifications.'),
                  ),
                );
              }
            },
            icon: Icon(Icons.notifications_none, color: Colors.grey[700]),
          ),

        ],
      ),
    );
  }

  // Bottom Navigation Bar Section
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarIcon(Icons.home, "Home", 0),
          _buildNavBarIcon(Icons.shopping_cart, "Cart", 1),
          _buildNavBarIcon(Icons.shopping_bag, "Orders", 2),
          _buildNavBarIcon(Icons.chat_bubble_outline, "Chats", 3),
          _buildNavBarIcon(Icons.school_outlined, "Tutorials", 4),
          _buildNavBarIcon(Icons.volunteer_activism, "Donations", 5),
        ],
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Colors.lightGreen.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _currentIndex == index ? 1.2 : 1.0,
              child: Icon(
                icon,
                color: _currentIndex == index
                    ? Colors.lightGreen
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _currentIndex == index
                    ? Colors.lightGreen
                    : Colors.grey[600],
                fontWeight: _currentIndex == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for Profile Menu
  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Add semi-transparent overlay
      builder: (context) => Dialog(
        alignment: Alignment.topLeft,
        insetPadding: const EdgeInsets.only(top: 70, left: 16),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ProfileMenu(username: widget.username),
      ),
    );
  }

  // Dialog for Notification Menu
  void _showNotificationMenu(BuildContext context, String userId) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        alignment: Alignment.topRight,
        insetPadding: const EdgeInsets.only(top: 70, right: 16),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: NotificationMenu(userId: userId), // Pass userId or other relevant data
      ),
    );
  }


  final List<Widget> _pages = [
    Column(
      children: const [
        FeaturedCarousel(),
        Expanded(
          child: ItemListScreen(),
        ),
      ],
    ),
    const CartSection(),
    const OrdersSection(),
    const ChatSection(),
    const TutorialsSection(),
    const DonationsSection(),
  ];
}
