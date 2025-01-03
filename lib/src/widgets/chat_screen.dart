import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      // Fetch messages with sender details
      final response = await _supabase
          .from('messages')
          .select(
          '*, sender:profiles!fk_sender_id(username, profile_image_url)')
          .eq('chat_id', widget.chatId)
          .order('created_at', ascending: true);

      final fetchedMessages = List<Map<String, dynamic>>.from(response);

      setState(() {
        _messages = fetchedMessages;
      });

      // Scroll to the latest message
      _scrollToLatestMessage();
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  void _subscribeToMessages() {
    try {
      _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('chat_id', widget.chatId)
          .listen((List<Map<String, dynamic>> data) async {
        for (var message in data) {
          if (!_messages.any((m) => m['id'] == message['id'])) {
            // Fetch sender details for the new message
            if (message['sender'] == null && message['sender_id'] != null) {
              final senderResponse = await _supabase
                  .from('profiles')
                  .select('username, profile_image_url')
                  .eq('id', message['sender_id'])
                  .maybeSingle();

              if (senderResponse != null) {
                message['sender'] = senderResponse;
              }
            }

            // Add the new message
            setState(() {
              _messages.add(message);
              _messages.sort((a, b) => a['created_at']
                  .compareTo(b['created_at'])); // Keep messages sorted
            });
          }
        }

        // Scroll to the latest message
        _scrollToLatestMessage();
      });
    } catch (e) {
      debugPrint('Error subscribing to messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    final currentUserId = _supabase.auth.currentUser?.id;

    if (_messageController.text.isEmpty || currentUserId == null) return;

    try {
      // Insert the message into the messages table
      final messageResponse = await _supabase.from('messages').insert({
        'chat_id': widget.chatId,
        'sender_id': currentUserId,
        'content': _messageController.text,
      }).select().single();

      // Fetch the recipient user ID based on the chat
      final recipientUserId = await _getRecipientUserId();

      if (recipientUserId != null) {
        // Insert notification into the notifications table
        await _supabase.from('notifications').insert({
          'user_id': recipientUserId,  // The recipient of the notification
          'sender_id': currentUserId, // The sender (current user)
          'title': 'New Message',
          'content': _messageController.text,
          'is_read': false,
        });
      }

      // Clear the message input field
      _messageController.clear();

      // Scroll to the latest message
      _scrollToLatestMessage();
    } catch (e) {
      debugPrint('Error sending message or creating notification: $e');
    }
  }



  Future<String?> _getRecipientUserId() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) return null;

      // Fetch chat details to identify the recipient
      final chatDetails = await _supabase
          .from('chats')
          .select('user1_id, user2_id')
          .eq('id', widget.chatId)
          .single();

      if (chatDetails != null) {
        // Determine the recipient based on the current user
        return chatDetails['user1_id'] == currentUserId
            ? chatDetails['user2_id']
            : chatDetails['user1_id'];
      }
    } catch (e) {
      debugPrint('Error fetching recipient user ID: $e');
    }
    return null;
  }

  void _scrollToLatestMessage() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe =
                    message['sender_id'] == _supabase.auth.currentUser?.id;

                final sender = message['sender'];

                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMe ? 'You' : sender?['username'] ?? 'Unknown Sender',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.lightGreen : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['content'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.lightGreen),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
