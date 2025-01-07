import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideAddDigitField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final String nameOfField;

  const RideAddDigitField(
      {super.key,
      required this.controller,
      required this.errorMessage,
      required this.nameOfField});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: nameOfField,
          errorText: errorMessage,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          )),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}
