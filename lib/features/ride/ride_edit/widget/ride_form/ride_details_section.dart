import 'package:car_log/features/ride/model/ride_type.dart';
import 'package:car_log/features/ride/ride_edit/utils/build_card_section.dart';
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideDetailsSection extends StatelessWidget {
  final TextEditingController distanceController;
  final TextEditingController rideTypeController;

  const RideDetailsSection({
    required this.distanceController,
    required this.rideTypeController,
  });

  @override
  Widget build(BuildContext context) {
    return BuildCardSection(
      context: context,
      title: RideFormConstants.RIDE_DETAILS_TITLE,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: distanceController,
                decoration: const InputDecoration(labelText: RideFormConstants.DISTANCE_LABEL, prefixIcon: Icon(Icons.directions_car)),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<RideType>(
                value: stringToRideType(rideTypeController.text),
                decoration: const InputDecoration(labelText: 'Ride Type'),
                items: RideType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.toString().split('.').last))).toList(),
                onChanged: (newValue) => rideTypeController.text = newValue.toString().split('.').last,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
