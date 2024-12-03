import 'package:flutter/material.dart';

class CarIconWidget extends StatelessWidget {
  const CarIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Icon(
      Icons.car_rental,
      color: theme.colorScheme.secondary,
      size: 36.0,
    );
  }
}
