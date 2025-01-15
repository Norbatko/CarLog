import 'package:flutter/material.dart';

class FuelTypeDropdown extends StatelessWidget {
  final String selectedFuelType;
  final List<String> fuelTypes;
  final ValueChanged<String?> onChanged;

  const FuelTypeDropdown(
      {super.key,
      required this.selectedFuelType,
      required this.fuelTypes,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Fuel Type'),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        value: selectedFuelType,
        onChanged: onChanged,
        items: fuelTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      )),
    );
  }
}
