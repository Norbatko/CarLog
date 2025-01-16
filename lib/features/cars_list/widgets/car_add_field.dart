import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarAddField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final String nameOfField;
  final bool isRequired;
  final bool isNumeric;

  const CarAddField({
    super.key,
    required this.controller,
    required this.errorMessage,
    required this.nameOfField,
    required this.isRequired,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$nameOfField *' : nameOfField,
        errorText: errorMessage,
      ),
      keyboardType: isNumeric
          ? TextInputType.number
          : TextInputType.text, // Conditional keyboard type
      inputFormatters: isNumeric
          ? [
              FilteringTextInputFormatter.digitsOnly
            ] // Only allow digits if numeric
          : [],
    );
  }
}
