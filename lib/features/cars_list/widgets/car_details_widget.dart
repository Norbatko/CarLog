import 'package:car_log/base/models/car.dart';
import 'package:flutter/material.dart';

const _CAR_NAME_FONT_SIZE = 16.0;
const _LICENSE_PLATE_FONT_SIZE = 14.0;

class CarDetailsWidget extends StatelessWidget {
  final Car car;

  const CarDetailsWidget({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          car.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _CAR_NAME_FONT_SIZE,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          car.licensePlate,
          style: TextStyle(
            fontSize: _LICENSE_PLATE_FONT_SIZE,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
