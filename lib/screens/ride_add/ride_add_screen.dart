import 'package:car_log/screens/ride_add/widgets/ride_form.dart';

import 'package:flutter/material.dart';

class RideAddScreen extends StatelessWidget {
  const RideAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Ride',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideForm(),
      ),
    );
  }
}
