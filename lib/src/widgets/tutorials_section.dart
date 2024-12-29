import 'package:flutter/material.dart';

class TutorialsSection extends StatefulWidget {
  const TutorialsSection({Key? key}) : super(key: key);

  @override
  State<TutorialsSection> createState() => _TutorialsSectionState();
}

class _TutorialsSectionState extends State<TutorialsSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with tabs
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
            children: [
              Row(
                children: [
                  Icon(
                    Icons.school_outlined,
                    color: Colors.lightGreen.shade700,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "TUTORIALS",
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
              TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.lightGreen.shade700,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                labelColor: Colors.lightGreen.shade700,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: "RECYCLE IN STEPS"),
                  Tab(text: "RECYCLE IN ACTION"),
                ],
              ),
            ],
          ),
        ),

        // Tutorial Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Recycle in Steps
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: recycleSteps.length,
                itemBuilder: (context, index) =>
                    _buildStepCard(recycleSteps[index], index),
              ),
              // Recycle in Action
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: recycleActions.length,
                itemBuilder: (context, index) =>
                    _buildActionCard(recycleActions[index]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(Map<String, String> step, int index) {
    return GestureDetector(
      onTap: () {
        // Add navigation to step-by-step tutorial view
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 64,
                  color: Colors.lightGreen.shade200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    step['description']!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            step['author']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add navigation to step-by-step view
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen.shade50,
                          foregroundColor: Colors.lightGreen.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          "View step by step",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(Map<String, String> action) {
    return GestureDetector(
      onTap: () {
        // Add navigation to video player view
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade50,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: Colors.lightGreen.shade700,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '10:30', // Example duration
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    action['description']!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        action['author']!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> recycleSteps = [
    {
      'title': 'Cloud Tulip Small Mirror Night Light - Pink',
      'description':
          'Create a beautiful cloud-shaped night light with recycled materials',
      'author': '@ella.nor_11',
    },
    {
      'title': 'Cute And Easy Easter Basket Craft',
      'description': 'Make adorable Easter baskets using simple materials',
      'author': '@ella.nor_11',
    },
  ];

  final List<Map<String, String>> recycleActions = [
    {
      'title': 'Fairy White Bracelet Tutorial',
      'description':
          'Learn how to create a beautiful fairy white bracelet using recycled materials. Perfect for beginners!',
      'author': '@ella.nor_11',
    },
    {
      'title': 'DIY Macrame Wristlet Keychain',
      'description':
          'Easy macrame tutorial for beginners. Create your own stylish keychain using simple techniques.',
      'author': '@fleurda1',
    },
    {
      'title': 'Scrap Wooden Furniture And Deco Ideas',
      'description':
          'Transform scrap wood into beautiful furniture and decorative pieces. Recycle wood art tutorial.',
      'author': '@dim_tim1',
    },
  ];
}
