import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/src/widgets/chat_screen.dart';

void showItemDetailsPopup(
    BuildContext context, Map<String, dynamic> item, double? distance) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Allow the bottom sheet to expand fully
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7, // Adjust initial height
        maxChildSize: 0.95, // Adjust maximum height
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController, // Connect to DraggableScrollableSheet
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Item Image
                  if (item['images'] != null && item['images'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['images'][0],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Item Name and Chat Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {

                          final uploaderId = item['profiles']?['id'];
                          final currentUserId =
                              Supabase.instance.client.auth.currentUser?.id;

                          if (uploaderId == null || currentUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Error: Could not fetch user details.')),
                            );
                            return;
                          }

                          if (uploaderId == currentUserId) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('You cannot chat with yourself!')),
                            );
                            return;
                          }

                          try {
                            // Check if a chat already exists between the users
                            final existingChat = await Supabase.instance.client
                                .from('chats')
                                .select()
                                .or(
                                'user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
                                .or(
                                'user1_id.eq.$uploaderId,user2_id.eq.$uploaderId')
                                .maybeSingle();

                            if (existingChat != null) {
                              // Navigate to ChatScreen with existing chatId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: existingChat['id'],
                                  ),
                                ),
                              );
                            } else {
                              // Create a new chat session
                              final newChat = await Supabase.instance.client
                                  .from('chats')
                                  .insert({
                                'user1_id': currentUserId,
                                'user2_id': uploaderId,
                              })
                                  .select()
                                  .single();

                              // Navigate to ChatScreen with new chatId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: newChat['id'],
                                  ),
                                ),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $error')),
                            );
                          }
                        },
                        icon: const Icon(Icons.chat, color: Colors.lightGreen),
                        tooltip: 'Chat with uploader',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '₱${item['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Uploader Info
                  if (item['profiles'] != null)
                    Text(
                      'Uploaded by @${item['profiles']['username']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 8),
                  // Distance
                  if (distance != null)
                    Text(
                      '${distance.toStringAsFixed(2)} km away',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'] ?? 'No description available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Close Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
