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
      final response = await _supabase
          .from('messages')
          .select('*, profiles(username)')
          .eq('chat_id', widget.chatId)
          .order('created_at', ascending: true);

      setState(() {
        _messages = List<Map<String, dynamic>>.from(response);
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
          .listen((List<Map<String, dynamic>> data) {
        setState(() {
          _messages = data;
        });

        // Scroll to the latest message
        _scrollToLatestMessage();
      });
    } catch (e) {
      debugPrint('Error subscribing to messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (_messageController.text.isEmpty) return;

    try {
      await _supabase.from('messages').insert({
        'chat_id': widget.chatId,
        'sender_id': currentUserId,
        'content': _messageController.text,
      });

      // Clear the message input field
      _messageController.clear();

      // Scroll to the latest message
      _scrollToLatestMessage();
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
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
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the scroll controller
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe =
                    message['sender_id'] == _supabase.auth.currentUser?.id;

                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
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
                );
              },
            ),
          ),

          // Message Input Field
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
