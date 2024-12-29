import 'package:flutter/material.dart';

class CartSection extends StatefulWidget {
  const CartSection({Key? key}) : super(key: key);

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': '3/4 SLEEVE | BEIGE FLORAL EMBROIDERY DRESS',
      'price': '₱257',
      'quantity': 1,
      'color': Colors.amber.shade50,
    },
    {
      'name': 'HANDMADE RECYCLED PAPER JOURNAL',
      'price': '₱199',
      'quantity': 1,
      'color': Colors.lightGreen.shade50,
    },
  ];

  double _calculateTotal() {
    double total = 0;
    for (var item in _cartItems) {
      total +=
          double.parse(item['price'].replaceAll('₱', '')) * item['quantity'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cart Header
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
                Icons.shopping_cart_outlined,
                color: Colors.lightGreen.shade700,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                "MY CART",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen.shade700,
                  letterSpacing: 1.2,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_cartItems.length} items",
                  style: TextStyle(
                    color: Colors.lightGreen.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Add items to start shopping",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return CartItem(
                            name: item['name'],
                            price: item['price'],
                            quantity: item['quantity'],
                            color: item['color'],
                            onQuantityChanged: (newQuantity) {
                              setState(() {
                                _cartItems[index]['quantity'] = newQuantity;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                _cartItems.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow("Subtotal", "₱${_calculateTotal()}"),
                            SizedBox(height: 8),
                            _buildInfoRow("Shipping", "₱50"),
                            Divider(height: 24),
                            _buildInfoRow(
                              "Total",
                              "₱${_calculateTotal() + 50}",
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        // Bottom Checkout Section
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _cartItems.isEmpty
                ? null
                : () {
                    // Add checkout functionality
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
            ),
            child: Text(
              'PROCEED TO CHECKOUT',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.lightGreen : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final String price;
  final int quantity;
  final Color color;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  const CartItem({
    Key? key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.color,
    required this.onQuantityChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.lightGreen.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          onQuantityChanged(quantity - 1);
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline),
                      color: Colors.grey[600],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onQuantityChanged(quantity + 1);
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.lightGreen,
                    ),
                  ],
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  label: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
