// import 'package:flutter/material.dart';
//
// class ItemDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> item;
//
//   const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final uploaderName = item['profiles']['username'];
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           item['name'],
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.lightGreen,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Item Image
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: item['images'] != null && item['images'].isNotEmpty
//                   ? Image.network(
//                 item['images'][0],
//                 height: 250,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               )
//                   : Container(
//                 height: 250,
//                 color: Colors.grey[300],
//                 child: const Center(
//                   child: Icon(
//                     Icons.image,
//                     size: 64,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Item Name
//             Text(
//               item['name'],
//               style: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // Price
//             Text(
//               '₱${item['price']}',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.lightGreen,
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Description Section
//             _buildSectionTitle('Description'),
//             const SizedBox(height: 8),
//             Text(
//               item['description'] ?? 'No description provided.',
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.5,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Uploader Profile
//             _buildSectionTitle('Uploaded By'),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.lightGreen[100],
//                   child: const Icon(Icons.person, color: Colors.lightGreen),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   '@$uploaderName',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.black87,
//       ),
//     );
//   }
// }
