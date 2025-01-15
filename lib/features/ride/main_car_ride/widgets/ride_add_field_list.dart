import 'package:car_log/features/ride/main_car_ride/widgets/ride_add_field.dart';
import 'package:car_log/features/ride/main_car_ride/widgets/ride_type_dropdown.dart';
import 'package:flutter/material.dart';

class RideAddFieldList extends StatelessWidget {
  final Map<String, TextEditingController> digitsControllers;
  final Map<String, String?> errorMessages;
  final String selectedRideType;
  final List<String> rideTypes;
  final ValueChanged<String?> onRideTypeChanged;

  const RideAddFieldList({
    super.key,
    required this.digitsControllers,
    required this.errorMessages,
    required this.selectedRideType,
    required this.rideTypes,
    required this.onRideTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RideTypeDropdown(
            selectedRideType: selectedRideType,
            rideTypes: rideTypes,
            onChanged: onRideTypeChanged,
          ),
          SizedBox(
            height: 30,
          ),
          ...digitsControllers.entries.map((entry) {
            return RideAddDigitField(
              controller: entry.value,
              errorMessage: errorMessages[entry.key],
              nameOfField: entry.key,
            );
          }).toList(),
        ],
      ),
    );
  }
}
