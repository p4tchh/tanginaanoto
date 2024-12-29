import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class NotificationMenu extends StatefulWidget {
  const NotificationMenu({Key? key}) : super(key: key);

  @override
  State<NotificationMenu> createState() => _NotificationMenuState();
}

class _NotificationMenuState extends State<NotificationMenu> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _notifications = [];
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the subscription on dispose
    super.dispose();
  }

  /// Fetch initial notifications
  Future<void> _fetchNotifications() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id, title, content, is_read, created_at')
          .order('created_at', ascending: false);

      if (response == null) {
        throw Exception('Failed to fetch notifications.');
      }

      setState(() {
        _notifications = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }


  /// Subscribe to new messages and add notifications
  void _subscribeToMessages() {
    try {
      _subscription = _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .listen((data) {
        debugPrint('New message received: $data');

        if (data.isNotEmpty) {
          final newMessage = data.first;

          setState(() {
            _notifications.insert(0, {
              'id': newMessage['id'],
              'title': 'New Message',
              'content': newMessage['content'],
              'is_read': false,
              'created_at': newMessage['created_at'],
            });
          });
        }
      }, onError: (error) {
        debugPrint('Error in message subscription: $error');
      });
    } catch (e) {
      debugPrint('Error subscribing to messages: $e');
    }
  }

  /// Mark all notifications as read
  void _markAllAsRead() async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true});

      setState(() {
        for (var notification in _notifications) {
          notification['is_read'] = true;
        }
      });
    } catch (e) {
      debugPrint('Error marking notifications as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Mark All as Read
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  'NOTIFICATIONS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Notifications List
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(
                  title: notification['title'] ?? 'New Notification',
                  subtitle: notification['content'] ?? 'No content available',
                  icon: Icons.message,
                  isRead: notification['is_read'] ?? false,
                );
              },
            ),
          ),
          // View All Notifications
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'View All Notifications',
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.lightGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Notification item widget
  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isRead = false,
  }) {
    return Container(
      color: isRead ? Colors.transparent : Colors.lightGreen.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.lightGreen.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
