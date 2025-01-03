import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF188545), // Set the custom green color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16), // Add padding for height
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontSize: 16, // Adjust text size
            fontWeight: FontWeight.normal, // Optional: Bold text
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}


class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton2({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Set the custom green color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16), // Add padding for height
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey, // Set text color to white
            fontSize: 16, // Adjust text size
            fontWeight: FontWeight.normal, // Optional: Bold text
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

class CustomDropdownButton extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdownButton({
    required this.hintText,
    required this.items,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Set consistent height
      padding: EdgeInsets.symmetric(horizontal: 16), // Padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedValue,
          hint: Text(
            widget.hintText,
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          isExpanded: true, // Makes the dropdown fill the available space
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: Colors.black), // Ensures consistent text style
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value);
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}




class CustomDateButton extends StatefulWidget {
  final String hintText;
  final void Function(DateTime) onDateSelected;

  const CustomDateButton({
    required this.hintText,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDateButtonState createState() => _CustomDateButtonState();
}

class _CustomDateButtonState extends State<CustomDateButton> {
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Consistent height matching CustomDropdownButton
      padding: EdgeInsets.symmetric(horizontal: 16), // Padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // Button backgrounds
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: _pickDate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!) // Display formatted date
                  : widget.hintText,
              style: TextStyle(
                color: _selectedDate != null ? Colors.black : Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

