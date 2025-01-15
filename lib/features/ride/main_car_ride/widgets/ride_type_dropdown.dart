import 'package:flutter/material.dart';

class RideTypeDropdown extends StatelessWidget {
  final String selectedRideType;
  final List<String> rideTypes;
  final ValueChanged<String?> onChanged;

  const RideTypeDropdown(
      {super.key,
      required this.selectedRideType,
      required this.rideTypes,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Ride Type'),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        value: selectedRideType,
        onChanged: onChanged,
        items: rideTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      )),
    );
  }
}
