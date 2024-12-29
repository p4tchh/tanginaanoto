import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/src/widgets/chat_screen.dart';
import 'dart:async';

class ChatSection extends StatefulWidget {
  const ChatSection({Key? key}) : super(key: key);

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> with TickerProviderStateMixin {
  final SupabaseClient _supabase = Supabase.instance.client;
  late TabController _tabController;
  List<Map<String, dynamic>> _chatList = [];
  List<Map<String, dynamic>> _contactsList = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchChats(); // Initial fetch for chat list
    _subscribeToChats(); // Subscribe to real-time updates
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel subscription to avoid memory leaks
    _tabController.dispose();
    super.dispose();
  }

  /// Fetch chats involving the current user
  Future<void> _fetchChats() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        throw Exception('User is not logged in.');
      }

      // Fetch chats with user details
      final response = await _supabase
          .from('chats')
          .select('''
          id,
          user1_id,
          user2_id,
          messages(content, created_at),
          user1:profiles!chats_user1_id_fkey(username, profile_image_url),
          user2:profiles!chats_user2_id_fkey(username, profile_image_url)
        ''')
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId');

      final List<Map<String, dynamic>> chats = List<Map<String, dynamic>>.from(response);

      // Sort chats by the most recent message
      chats.sort((a, b) {
        final DateTime? dateA = a['messages'].isNotEmpty
            ? DateTime.parse(a['messages'].last['created_at'])
            : null;
        final DateTime? dateB = b['messages'].isNotEmpty
            ? DateTime.parse(b['messages'].last['created_at'])
            : null;

        if (dateA == null) return 1; // Chats without messages go to the bottom
        if (dateB == null) return -1;
        return dateB.compareTo(dateA); // Descending order
      });

      setState(() {
        _chatList = chats;
      });
    } catch (e) {
      debugPrint('Error fetching chats: $e');
    }
  }

  /// Subscribe to real-time chat updates
  void _subscribeToChats() {
    try {
      _subscription = _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .listen((data) {
        _fetchChats(); // Re-fetch chats when a new message is detected
      });
    } catch (e) {
      debugPrint('Error subscribing to chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with tabs
        _buildHeader(),
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Chats/Contacts List with TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Chats Tab
              _buildChatList(),
              // Contacts Tab
              _buildContactsList(),
            ],
          ),
        ),
      ],
    );
  }

  /// Build header with tabs
  Widget _buildHeader() {
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
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "MESSAGES",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen.shade700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: Colors.lightGreen.shade700,
              ),
              insets: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            labelColor: Colors.lightGreen.shade700,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text("CHATS"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text("CONTACTS"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the real-time chat list
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _chatList.length,
      itemBuilder: (context, index) {
        final chat = _chatList[index];
        final currentUserId = _supabase.auth.currentUser?.id;
        final isUser1 = chat['user1_id'] == currentUserId;
        final otherUser = isUser1 ? chat['user2'] : chat['user1'];
        final lastMessage = chat['messages'].isNotEmpty
            ? chat['messages'].last['content']
            : 'No messages yet';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: (otherUser != null && otherUser['profile_image_url'] != null)
                ? NetworkImage(otherUser['profile_image_url'])
                : null,
            child: (otherUser == null || otherUser['profile_image_url'] == null)
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(otherUser?['username'] ?? 'Unknown User'),
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // Navigate to ChatScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(chatId: chat['id']),
              ),
            );
          },
        );
      },
    );
  }

  /// Build static contacts list
  Widget _buildContactsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _contactsList.length,
      itemBuilder: (context, index) {
        final contact = _contactsList[index];
        return _buildContactTile(contact);
      },
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(contact['imageUrl']),
      ),
      title: Text(contact['name']),
      subtitle: Text(contact['lastSeen']),
      trailing: IconButton(
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.lightGreen),
        onPressed: () {
          // Start a new chat with the contact
        },
      ),
    );
  }
}
