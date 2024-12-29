import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(15), // Add rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Subtle shadow for better visuals
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic), // Hint text color
          border: InputBorder.none, // Remove default border
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ), // Add padding inside the TextField
        ),
      ),
    );
  }
}

