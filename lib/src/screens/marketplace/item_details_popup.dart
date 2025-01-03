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
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Indicator
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Item Image
                  if (item['images'] != null && item['images'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item['images'][0],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Item Name and Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat, color: Colors.lightGreen),
                        iconSize: 28,
                        tooltip: 'Chat with Uploader',
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
                            final existingChat = await Supabase.instance.client
                                .from('chats')
                                .select()
                                .or(
                                'user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
                                .or(
                                'user1_id.eq.$uploaderId,user2_id.eq.$uploaderId')
                                .maybeSingle();

                            if (existingChat != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: existingChat['id'],
                                  ),
                                ),
                              );
                            } else {
                              final newChat = await Supabase.instance.client
                                  .from('chats')
                                  .insert({
                                'user1_id': currentUserId,
                                'user2_id': uploaderId,
                              }).select().single();

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
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price and Quantity
                  Text(
                    '₱${item['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: ${item['quantity'] ?? 'Not specified'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Uploader Info with Profile Picture
                  if (item['profiles'] != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: item['profiles']['profile_image_url'] != null
                              ? NetworkImage(item['profiles']['profile_image_url'])
                              : null,
                          child: item['profiles']['profile_image_url'] == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '@${item['profiles']['username']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Distance
                  if (distance != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${distance.toStringAsFixed(2)} km away',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
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
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  // Reserve for Pickup Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item reserved for pickup!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.lightGreen,
                        elevation: 3,
                        shadowColor: Colors.lightGreen.withOpacity(0.5),
                      ),
                      icon: const Icon(
                        Icons.shopping_basket,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Reserve for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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
