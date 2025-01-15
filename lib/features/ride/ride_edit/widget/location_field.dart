import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onPressed;
  final Function(String)? onLocationReceived;

  const LocationField({
    Key? key,
    required this.controller,
    required this.label,
    required this.onPressed,
    this.onLocationReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            onPressed();
            if (onLocationReceived != null) {
              onLocationReceived!(controller.text);
            }
          },
        ),
      ),
    );
  }
}
