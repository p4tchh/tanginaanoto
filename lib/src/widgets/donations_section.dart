import 'package:flutter/material.dart';

class DonationsSection extends StatefulWidget {
  const DonationsSection({Key? key}) : super(key: key);

  @override
  State<DonationsSection> createState() => _DonationsSectionState();
}

class _DonationsSectionState extends State<DonationsSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.volunteer_activism,
                    color: Colors.lightGreen.shade700,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "DONATIONS/GIVEAWAYS",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "There are 12 available donations. Would you like to take one, donate an item, or help someone find what they need?",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search donations...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Categories Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: donationCategories.length,
            itemBuilder: (context, index) => _buildCategoryCard(
              donationCategories[index],
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      Map<String, dynamic> category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add navigation to category items
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                category['icon'],
                size: 100,
                color: Colors.lightGreen.shade50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    category['icon'],
                    color: Colors.lightGreen.shade700,
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    category['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${category['count']} items',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
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

  final List<Map<String, dynamic>> donationCategories = [
    {
      'title': 'Bags and Purses',
      'icon': Icons.shopping_bag_outlined,
      'count': 15,
    },
    {
      'title': 'Books and Magazines',
      'icon': Icons.menu_book_outlined,
      'count': 23,
    },
    {
      'title': 'Linens',
      'icon': Icons.bedroom_parent_outlined,
      'count': 8,
    },
    {
      'title': 'Accessories',
      'icon': Icons.watch_outlined,
      'count': 12,
    },
    {
      'title': 'Home Decor',
      'icon': Icons.home_outlined,
      'count': 19,
    },
    {
      'title': 'Stationery',
      'icon': Icons.edit_outlined,
      'count': 7,
    },
  ];
}
