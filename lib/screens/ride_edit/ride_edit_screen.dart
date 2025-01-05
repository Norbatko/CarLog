import 'package:car_log/screens/ride_edit/utils/ride_form.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/ride.dart';

class RideEditScreen extends StatelessWidget {
  final Ride ride;

  const RideEditScreen({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ride.id.isEmpty ? 'Create Ride' : 'Edit Ride',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideForm(ride: ride),
      ),
    );
  }
}
