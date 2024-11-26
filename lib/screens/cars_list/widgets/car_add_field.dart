import 'package:flutter/material.dart';

class CarAddField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final String nameOfField;

  const CarAddField(
      {super.key,
      required this.controller,
      required this.errorMessage,
      required this.nameOfField});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$nameOfField *',
        errorText: errorMessage,
      ),
    );
  }
}
