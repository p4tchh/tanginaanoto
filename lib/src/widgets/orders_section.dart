import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  const OrdersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
          child: Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.lightGreen.shade700,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                "PICKUPS",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen.shade700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Orders List
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: [
              OrderCard(
                name: "Lalisa Manoban",
                location: "Tumaga",
                time: "10:00am - 12:00pm",
                status: OrderStatus.ready,
                imageUrl: "assets/images/profile1.jpg",
              ),
              OrderCard(
                name: "Jennie Kim",
                location: "Pasonanca",
                time: "2:00am - 4:00pm",
                status: OrderStatus.next,
                imageUrl: "assets/images/profile2.jpg",
              ),
              OrderCard(
                name: "Roseanne Park",
                location: "Santa Maria",
                time: "3:00am - 5:00pm",
                status: OrderStatus.picked,
                imageUrl: "assets/images/profile3.jpg",
              ),
              OrderCard(
                name: "Kim Jisoo",
                location: "Boalan",
                time: "4:00am - 6:00pm",
                status: OrderStatus.picked,
                imageUrl: "assets/images/profile4.jpg",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum OrderStatus { ready, next, picked }

class OrderCard extends StatefulWidget {
  final String name;
  final String location;
  final String time;
  final OrderStatus status;
  final String imageUrl;

  const OrderCard({
    Key? key,
    required this.name,
    required this.location,
    required this.time,
    required this.status,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.03 : 0.05),
                blurRadius: _isPressed ? 3 : 5,
                offset: Offset(0, _isPressed ? 1 : 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                ),
                SizedBox(width: 16),
                // Order Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          _buildStatusChip(widget.status),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(
                          Icons.location_on_outlined, widget.location),
                      SizedBox(height: 4),
                      _buildInfoRow(Icons.access_time_outlined, widget.time),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                // Action Buttons
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.phone_outlined),
                      color: Colors.lightGreen,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chat_bubble_outline),
                      color: Colors.lightGreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.ready:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        text = 'Ready to pickup';
        break;
      case OrderStatus.next:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        text = 'Next';
        break;
      case OrderStatus.picked:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        text = 'PICKED';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
