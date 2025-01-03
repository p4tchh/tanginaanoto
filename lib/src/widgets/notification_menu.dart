import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class NotificationMenu extends StatefulWidget {
  final String userId;

  const NotificationMenu({Key? key, required this.userId}) : super(key: key);

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
    _subscribeToNotifications();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Fetch notifications from the database
  Future<void> _fetchNotifications() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select(
        '''
            id, title, content, is_read, created_at,
            sender:profiles(username, profile_image_url)
            ''',
      )
          .eq('user_id', widget.userId)
          .order('created_at', ascending: false);

      final fetchedNotifications = List<Map<String, dynamic>>.from(response);

      setState(() {
        _notifications = fetchedNotifications;
      });
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  void _subscribeToNotifications() {
    try {
      _subscription = _supabase
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('user_id', widget.userId)
          .listen((List<Map<String, dynamic>> data) async {
        for (var notification in data) {
          if (notification['sender_id'] == null) {
            debugPrint('Skipping notification without sender_id: ${notification['id']}');
            continue;
          }

          if (!_notifications.any((n) => n['id'] == notification['id'])) {
            setState(() {
              _notifications.insert(0, notification);
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Error subscribing to notifications: $e');
    }
  }



  /// Mark all notifications as read
  Future<void> _markAllAsRead() async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', widget.userId);

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
            offset: const Offset(0, 2),
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
                  isRead: notification['is_read'] ?? false,
                  sender: notification['sender'],
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

  /// Build a single notification item
  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool isRead,
    required Map<String, dynamic>? sender,
  }) {
    final senderUsername = sender?['username'] ?? 'Unknown Sender';
    final senderProfileImage = sender?['profile_image_url'];

    return Container(
      color: isRead ? Colors.transparent : Colors.lightGreen.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: senderProfileImage != null
                  ? NetworkImage(senderProfileImage)
                  : null,
              child: senderProfileImage == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
